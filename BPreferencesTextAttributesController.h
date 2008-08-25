//
//  BPreferencesTextAttributesController.h
//  BPreferences
//
//  Created by Jesse Grosjean on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Blocks/Blocks.h>


@interface BPreferencesTextAttributesController : NSWindowController {
	IBOutlet NSTextView *textView;
	IBOutlet NSMenu *textAttributesMenu;
	IBOutlet NSSegmentedControl *selectAttributesControl;
	
	NSUndoManager *undoManager;
}

@property(retain) NSDictionary *textAttributes;
@property(readonly) NSUndoManager *undoManager;

- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)changeFont:(id)sender;

@end
