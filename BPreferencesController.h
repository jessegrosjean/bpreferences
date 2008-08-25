//
//  BPreferencesController.h
//  BPreferences
//
//  Created by Jesse Grosjean on 8/23/07.
//  Copyright 2007 Blocks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>


@interface BPreferencesController : NSWindowController {
    IBOutlet NSView *loadingView;
	IBOutlet NSTextField *loadingTextField;
    
    NSToolbar *toolbar;
    NSMutableArray *paneIdentifiers;
    NSMutableDictionary *paneIdentifiersToConfigurationElements;
    NSMutableDictionary *paneIdentifiersToPreferencePaneControllers;
	NSString *selectedPaneIdentifier;
}

#pragma mark Class Methods

+ (id)sharedInstance;

#pragma mark Accessors

@property(assign) NSString *selectedPaneIdentifier;
@property(readonly) NSArray *paneIdentifiers;

@end
