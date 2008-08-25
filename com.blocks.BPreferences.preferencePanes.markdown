Use this extension point to add preferene panes to the preferences window.

## Example Configuration:

The object returned by `[GeneralPreferencesController sharedInstance]` must be a subclass of `NSViewController`. The view maintained by that controller view will be used as the new preference pane. This configuration markup should be added to the Plugin.xml file of the plugin that declares the `GeneralPreferencesController` class.

	<extension point="com.blocks.BPreferences.preferencePanes">
        <preferencePane id="general"
                     label="%General"
                     title="%General Preferences"
                     image="GeneralPreferencesIcon"
                     width="550"
                     controller="GeneralPreferencesController sharedInstance" />
    </extension>
