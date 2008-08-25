//
//  BPreferencesTextAttributesController.m
//  BPreferences
//
//  Created by Jesse Grosjean on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BPreferencesTextAttributesController.h"
#import "BPreferencesTextAttributesTextView.h"


@implementation BPreferencesTextAttributesController

#pragma mark Init

- (id)init {
	if (self = [super initWithWindowNibName:@"BPreferencesTextAttributesWindow"]) {
	}
	return self;
}

- (void)awakeFromNib {
	[[textView textStorage] setDelegate:self];
	[[self undoManager] disableUndoRegistration];
	[[textView textStorage] replaceCharactersInRange:NSMakeRange(0, [[textView textStorage] length]) withString:BLocalizedString(@"Use this text area to select your prefered text attributes. This text is not editable, but the attributes are. To change font's etc, Control-Click on this text and then choose the Font menu item from the popup menu.", @"")];
	[[self undoManager] enableUndoRegistration];
	[textView setRulerVisible:YES];
	[selectAttributesControl setMenu:textAttributesMenu forSegment:0];
}

- (NSDictionary *)textAttributes {
	return [[textView textStorage] attributesAtIndex:0 effectiveRange:NULL];
}

- (void)setTextAttributes:(NSDictionary *)newTextAttributes {
	[[textView textStorage] setAttributes:newTextAttributes range:NSMakeRange(0, [[textView textStorage] length])];
}

- (NSUndoManager *)undoManager {
	if (!undoManager) {
		undoManager = [[NSUndoManager alloc] init];
	}
	return undoManager;
}

- (IBAction)ok:(id)sender {
	[NSApp endSheet:[self window] returnCode:NSOKButton];
	[[self window] close];
}

- (IBAction)cancel:(id)sender {
	[NSApp endSheet:[self window] returnCode:NSCancelButton];
	[[self window] close];
}

- (IBAction)reset:(id)sender {
	self.textAttributes = [NSDictionary dictionary];
}

- (IBAction)changeFont:(id)sender {
	[[self window] makeFirstResponder:textView];
	[[NSFontManager sharedFontManager] orderFrontFontPanel:sender];
}

- (void)textStorageDidProcessEditing:(NSNotification *)aNotification {
}

- (NSUndoManager *)undoManagerForTextView:(NSTextView *)aTextView {
	return [self undoManager];
}

@end
