using Toybox.Application;
using Toybox.WatchUi;

var gDeviceSettings;            // quick access to settings on the device
var gSettingsChanged = true;    // flag as to whether or not the app settings have changed

class DigilogueApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    //    $.gDeviceSettings = System.getDeviceSettings();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new DigilogueView() ];
    }

    // new app settings have been received so trigger a UI update and set flag
    function onSettingsChanged() {
        $.gSettingsChanged = true;  // set global flag so the View object knows to reload settings and adjust accordingly
        $.gDeviceSettings = System.getDeviceSettings();     // probably a good time to refresh the device settings also
        WatchUi.requestUpdate();
    }
    
    /*
    function getSettingsView() {
		return [new DigilogueSettingsView(), new DigilogueSettingsDelegate()];
	}
	*/
    
    /*
    // returns a config property as a boolean object
    function getBooleanProperty(key, initial) {
        var value = getProperty(key);
        if (value != null) {
            if (value instanceof Lang.Boolean) {
                return value;
            } else if (value instanceof Lang.String) {
                return value.toNumber() != 0;
            }
        }
        return initial;
    }

    // returns a config property as a Number object
    function getNumberProperty(key, initial) {
        var value = getProperty(key);
        if (value != null) {
            if (value instanceof Lang.Number) {
                return value;
            } else if (value instanceof Lang.Long || value instanceof Lang.String) {
                return value.toNumber();
            }
        }
        return initial;
    }
	*/
}