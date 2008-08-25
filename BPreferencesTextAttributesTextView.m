//
//  BPreferencesTextAttributesTextView.m
//  BPreferences
//
//  Created by Jesse Grosjean on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BPreferencesTextAttributesTextView.h"
#import "BPreferencesTextAttributesLayoutManager.h"


@implementation BPreferencesTextAttributesTextView

- (void)awakeFromNib {
	[[self textContainer] replaceLayoutManager:[[BPreferencesTextAttributesLayoutManager alloc] init]];
}

- (void)keyDown:(NSEvent *)theEvent {	
}

- (void)keyUp:(NSEvent *)theEvent {	
}

- (void)mouseDown:(NSEvent *)theEvent {
}

- (void)viewDidMoveToWindow {
	[[self window] performSelector:@selector(makeFirstResponder:) withObject:self afterDelay:0.0];
}

- (void)setRulerVisible:(BOOL)flag {
    if (flag != [self isRulerVisible]) {
		if (flag) {
			[[self window] makeFirstResponder:self];
		}
		
		[super setRulerVisible:flag];
		[self setSelectedRange:NSMakeRange(0,0)];
		[self selectAll:nil];
    }
}

- (void)drawRect:(NSRect)rect {
	[[self backgroundColor] set];
	NSRectFill(rect);
	
	NSLayoutManager *layoutManger = [self layoutManager];
	NSRange glyphRange = [layoutManger glyphRangeForTextContainer:[self textContainer]];		
	
	if (glyphRange.length > 0) {
		[layoutManger drawGlyphsForGlyphRange:glyphRange atPoint:NSMakePoint(0, 0)];
	}
}

@end
