This plugin creates a preferences window and a menu item to show that window. Other plugins can extend the `preferencePanes` extension point to contribute their own preference panes.

## Example Code

This plugin provides a public API for showing the preferenes window and selecting a particular preferences pane. Here's how to select the preference pane whose identifier is `your.preference.pane.identifier`.

    [[BPreferencesController sharedInstance] setSelectedPaneIdentifier:@"your.preference.pane.identifier"];