//
//  BPreferencesController.m
//  BPreferences
//
//  Created by Jesse Grosjean on 8/23/07.
//  Copyright 2007 Blocks. All rights reserved.
//

#import "BPreferencesController.h"


@interface BPreferencesController (BPreferencesControllerPrivate)
- (void)resizeWindowToSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate;
- (BConfigurationElement *)paneConfigurationElementForIdentifier:(NSString *)paneIdentifier;
- (NSViewController *)paneControllerForIdentifier:(NSString *)paneIdentifier;
@end

@implementation BPreferencesController

#pragma mark Class Methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark Init

- (id)init {
    if (self = [super initWithWindowNibName:@"BPreferencesController"]) {
    }
    return self;
}

#pragma mark AwakeFromNib-like Methods

- (void)windowDidLoad {
    toolbar = [[NSToolbar alloc] initWithIdentifier:@"BPreferenceManagerToolbarIdentifier"];    
    [toolbar setDelegate:self];
    [[self window] setToolbar:toolbar];
    [[self window] center];
	[[self window] makeKeyAndOrderFront:self];
	
    NSString *firstPaneIdentifier = [[self paneIdentifiers] count] ? [paneIdentifiers objectAtIndex:0] : nil;
    if (firstPaneIdentifier && [self selectedPaneIdentifier] == nil) {
		[self setSelectedPaneIdentifier:firstPaneIdentifier];
    }
	
	[loadingTextField setHidden:YES];
}

#pragma Accessors

- (NSString *)selectedPaneIdentifier {
	return selectedPaneIdentifier;
}

- (void)setSelectedPaneIdentifier:(NSString *)paneIdentifier {
	[[self window] makeKeyAndOrderFront:self];
		
    if ([[self selectedPaneIdentifier] isEqual:paneIdentifier]) {
		return;
    }
	
    [toolbar setSelectedItemIdentifier:paneIdentifier];
	
	[[self window] setContentView:loadingView];

	BConfigurationElement *configurationElement = [self paneConfigurationElementForIdentifier:paneIdentifier];
	NSViewController *preferencePaneController = [self paneControllerForIdentifier:paneIdentifier];
	NSView *preferencePaneView = [preferencePaneController view];
	
    BLogAssert(preferencePaneController != nil, @"invalid paneIdentifier");
    BLogAssert(preferencePaneView != nil, @"failed to create preference pane view");
    BLogAssert([configurationElement floatAttributeForKey:@"width"] == [preferencePaneView bounds].size.width, @"preference pane view width does not match declared width");
    BLogInfo([NSString stringWithFormat:@"showing pane %@", paneIdentifier]);
    
	selectedPaneIdentifier = paneIdentifier;
    
    if ([[self window] isVisible]) {
		[self resizeWindowToSize:[preferencePaneView bounds].size display:YES animate:YES];
    } else {
		[self resizeWindowToSize:[preferencePaneView bounds].size display:NO animate:NO];
    }
    
    [[self window] setContentView:preferencePaneView];
}

- (NSArray *)paneIdentifiers {
	if (!paneIdentifiers) {
		NSUInteger maxPreferencePaneViewWidth = 0;
		
		paneIdentifiers = [[NSMutableArray alloc] init];
		paneIdentifiersToConfigurationElements = [[NSMutableDictionary alloc] init];
		paneIdentifiersToPreferencePaneControllers = [[NSMutableDictionary alloc] init];
		
		NSArray *requiredKeys = [NSArray arrayWithObjects:@"id", @"label", @"title", @"image", @"width", @"controller", nil];
		BExtensionPoint *extensionPoint = [[BExtensionRegistry sharedInstance] extensionPointFor:@"com.blocks.BPreferences.preferencePanes"];
		
		for (BConfigurationElement *each in [extensionPoint configurationElementsNamed:@"preferencePane"]) {
			if ([each assertKeysPresent:requiredKeys]) {
				NSString *identifier = [[each attributes] objectForKey:@"id"];
				if (![paneIdentifiers containsObject:identifier]) {
					[paneIdentifiers addObject:identifier];
					[paneIdentifiersToConfigurationElements setObject:each forKey:identifier];
					NSString *eachWidth = [each attributeForKey:@"width"];
					if (eachWidth && [eachWidth integerValue] > maxPreferencePaneViewWidth) {
						maxPreferencePaneViewWidth = [eachWidth integerValue];
					} 
				} else {
					BLogWarning([NSString stringWithFormat:@"preference pane id %@ is already in use.", identifier]);
				}
			}
		}
		
	
		NSSize defaultWindowSize = [[[self window] contentView] bounds].size;
		if (maxPreferencePaneViewWidth > defaultWindowSize.width) {
			defaultWindowSize.width = maxPreferencePaneViewWidth;
			[self resizeWindowToSize:defaultWindowSize display:NO animate:NO];
		}
	}
    return paneIdentifiers;
}

#pragma mark Delegate/Datasource

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted {
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdent];
    BConfigurationElement *paneConfigurationElement = [self paneConfigurationElementForIdentifier:itemIdent];
    
    if (paneConfigurationElement) {
        [toolbarItem setLabel:[paneConfigurationElement localizedAttributeForKey:@"label"]];
        [toolbarItem setToolTip:[paneConfigurationElement localizedAttributeForKey:@"toolTip"]];
        [toolbarItem setImage:[paneConfigurationElement imageAttributeForKey:@"image"]];
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(toolbarItemClicked:)];
    } else {
        toolbarItem = nil;
    }
    
    return toolbarItem;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *) toolbar {
    return [self paneIdentifiers];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *) toolbar {
    return [self paneIdentifiers];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    return [self paneIdentifiers];
}

- (void)toolbarItemClicked:(id)sender {
    [self setSelectedPaneIdentifier:[sender itemIdentifier]];
}

@end

@implementation BPreferencesController (BPreferencesControllerPrivate)

CGFloat ToolbarHeightForWindow(NSWindow *window) {
    NSToolbar *toolbar;
    CGFloat toolbarHeight = 0.0;
    NSRect windowFrame;
    toolbar = [window toolbar];
    
    if(toolbar && [toolbar isVisible]) {
        windowFrame = [NSWindow contentRectForFrameRect:[window frame] styleMask:[window styleMask]];
        toolbarHeight = NSHeight(windowFrame) - NSHeight([[window contentView] frame]);
    }
    
    return toolbarHeight;
}

- (void)resizeWindowToSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate {
    NSRect aFrame;
    
	if (newSize.width != 550) {
		BLogWarning(@"preferences window resize width does not equal expected width of 550... tidy things up!");
	}
	
    CGFloat newHeight = newSize.height + ToolbarHeightForWindow([self window]);
    CGFloat newWidth = newSize.width;
    
    aFrame = [NSWindow contentRectForFrameRect:[[self window] frame] styleMask:[[self window] styleMask]];
    
    aFrame.origin.y += aFrame.size.height;
    aFrame.origin.y -= newHeight;
    aFrame.size.height = newHeight;
    aFrame.size.width = newWidth;
    
    aFrame = [NSWindow frameRectForContentRect:aFrame styleMask:[[self window] styleMask]];
    
    [[self window] setFrame:aFrame display:display animate:animate];
}

- (BConfigurationElement *)paneConfigurationElementForIdentifier:(NSString *)paneIdentifier {
	if (!paneIdentifiers) [self paneIdentifiers];
	return [paneIdentifiersToConfigurationElements objectForKey:paneIdentifier];
}

- (NSViewController *)paneControllerForIdentifier:(NSString *)paneIdentifier {
	if (!paneIdentifiers) [self paneIdentifiers];
	
	NSViewController * preferencePaneController = [paneIdentifiersToPreferencePaneControllers objectForKey:paneIdentifier];
	
	if (!preferencePaneController) {
		BConfigurationElement *configurationElement = [self paneConfigurationElementForIdentifier:paneIdentifier];
		preferencePaneController = [configurationElement createExecutableExtensionFromAttribute:@"controller" conformingToClass:[NSViewController class] conformingToProtocol:nil respondingToSelectors:nil];
		
		if (preferencePaneController) {
			[paneIdentifiersToPreferencePaneControllers setObject:preferencePaneController forKey:paneIdentifier];
		}
	}
	
	return preferencePaneController;
}

@end