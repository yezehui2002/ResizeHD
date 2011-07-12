//
//  ResizeView.m
//  ResizeHD
//
//  Created by ipalmer on 20/06/11.
//  Copyright 2011 BakingCode. All rights reserved.
//

#import "ResizeView.h"

@implementation ResizeView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, 
                                       NSFilenamesPboardType, nil]];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) {
        
        [[NSCursor dragCopyCursor] set];
		
        return NSDragOperationGeneric;
		
    } // end if
	
    // not a drag we can use
	return NSDragOperationNone;	
	
} // end draggingEntered

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    return YES;
} // end prepareForDragOperation

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
	// define the images  types we accept
	// NSPasteboardTypeTIFF: (used to be NSTIFFPboardType).
	// NSFilenamesPboardType:An array of NSString filenames
    NSArray *zImageTypesAry = [NSArray arrayWithObjects:NSFilenamesPboardType, nil];
	
    NSString *zDesiredType = [zPasteboard availableTypeFromArray:zImageTypesAry];
    
    if ([zDesiredType isEqualToString:NSFilenamesPboardType]) {
		// the pasteboard contains a list of file names
        NSArray *zFileNamesAry = [zPasteboard propertyListForType:@"NSFilenamesPboardType"];
        
        for (NSString *zPath in zFileNamesAry) {
            
            NSRange r = [zPath rangeOfString:@"@2x" options:NSBackwardsSearch];
            if (r.length == 0) {
                r = [zPath rangeOfString:@"-hd" options:NSBackwardsSearch];
            }
            
            if (r.length != 0) {
                
                NSData *sourceData = [[NSData alloc] initWithContentsOfFile:zPath];
                
                NSImage *sourceImage = [[NSImage alloc] initWithData: sourceData];
                
                if (sourceImage != nil) {
                    float resizeWidth = [sourceImage size].width / 2;
                    float resizeHeight = [sourceImage size].height / 2;
                    
                    NSImage *resizedImage = [[NSImage alloc] initWithSize: NSMakeSize(resizeWidth, resizeHeight)];
                    
                    NSSize originalSize = [sourceImage size];
                    
                    [resizedImage lockFocus];
                    [sourceImage drawInRect: NSMakeRect(0, 0, resizeWidth, resizeHeight) fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height) operation: NSCompositeSourceOver fraction: 1.0];
                    [resizedImage unlockFocus];
                    
                    CIImage *desImage = [CIImage imageWithData:[resizedImage TIFFRepresentation]];
                    
                    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCIImage:desImage];
                    NSData *resizedData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
                    [resizedData writeToFile: [NSString stringWithFormat:@"%@.png", [zPath substringWithRange:NSMakeRange(0, r.location)]] atomically: NO];
                }
            }
        }
    
    }// end if
	return YES;
	
} // end performDragOperation


- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
    [self setNeedsDisplay:YES];
} // end concludeDragOperation

@end
