//
//  BPreferencesTextAttributesLayoutManager.m
//  BPreferences
//
//  Created by Jesse Grosjean on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BPreferencesTextAttributesLayoutManager.h"


@implementation BPreferencesTextAttributesLayoutManager

- (NSView *)rulerAccessoryViewForTextView:(NSTextView *)view paragraphStyle:(NSParagraphStyle *)style ruler:(NSRulerView *)ruler enabled:(BOOL)isEnabled {
	NSView *result = [super rulerAccessoryViewForTextView:view paragraphStyle:style ruler:ruler enabled:isEnabled];;
	return result;
}

@end
