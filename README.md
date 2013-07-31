CalendarPlugin
==============

Adds the ability to create and edit events in the calendar for PhoneGap apps.

Follows the [Cordova Plugin spec](http://cordova.apache.org/docs/en/3.0.0/plugin_ref_spec.md), so that it works with [Plugman](https://github.com/apache/cordova-plugman), or you can install it manually below.

    var calendar = cordova.require("cordova/plugin/Calendar");
    
    /*
        Adds an event to the calendar. This is done silently in the background on iOS.
        On Android, it brings the user to the calendar's add event form, prefilled with parameter data.
         
        @param title           the event's title
        @param description     the event's description (called Notes on iOS)
        @param location        the event's location
        @param startDate       a Javascript Date var for the event's start time and date
        @param endDate         a Javascript Date var for the event's start time and date
        @param successCallback returns the value as the argument to the callback when successful
        @param failureCallback returns the error string as the argument to the callback, for a failure
    */
    calendar.addEvent(title, description, location, startDate, endDate, successCallback, errorCallback)

Currently tested working on iOS 5 / Android 4.x devices on Cordova 3.0.0.
