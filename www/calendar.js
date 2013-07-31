
cordova.define("cordova/plugin/Calendar",
    
    function (require, exports, module) {

        var exec = require("cordova/exec");

        var Calendar = function () { };

        Calendar.prototype.addEvent = function(title, description, location, startDate, endDate, successCallback, errorCallback) {
            if (typeof errorCallback != "function")  {
                console.debug("calendar.addEvent failure: errorCallback parameter must be a function" + typeof errorCallback);
                return
            }

            if (typeof successCallback != "function") {
                console.debug("calendar.addEvent failure: successCallback parameter must be a function" + typeof successCallback);
                return
            }

            return cordova.exec (successCallback, errorCallback, 'Calendar', 'addEvent',
                [title, description, location, startDate.getTime(), endDate.getTime()]
            );
        };

        Calendar.prototype.editEvent = function(title, description, location, startDate, endDate, successCallback, errorCallback) {
            if (typeof errorCallback != "function")  {
                console.debug("calendar.editEvent failure: errorCallback parameter must be a function");
                return
            }

            if (typeof successCallback != "function") {
                console.debug("calendar.editEvent failure: successCallback parameter must be a function");
                return
            }

            return cordova.exec(successCallback, errorCallback, 'Calendar', 'editEvent',
                [title, description, location, startDate.getTime().toString(), endDate.getTime().toString()]
            );
        };

        var calendar = new Calendar();
        module.exports = calendar;
    });