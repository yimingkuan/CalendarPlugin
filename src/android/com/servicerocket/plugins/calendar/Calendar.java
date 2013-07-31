package com.servicerocket.plugins.calendar;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.Activity;
import android.content.Intent;
import android.provider.CalendarContract;
import android.provider.CalendarContract.Events;

public class Calendar extends CordovaPlugin {
	public static final String ACTION_ADD_EVENT = "addEvent";
	public static final String ACTION_EDIT_EVENT = "editEvent";
	public static final Integer RESULT_CODE_ADD = 0;
	public static final Integer RESULT_CODE_EDIT = 1;
	private CallbackContext callback;

	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		try {
			String title = args.getString(0);
			String description = args.getString(1);
			String location = args.getString(2);
			long startTimeMillis = args.getLong(3);
			long endTimeMillis = args.getLong(4);
			callback = callbackContext;
			
			if (action.equals(ACTION_ADD_EVENT)) { 
				Intent intent = new Intent(Intent.ACTION_INSERT)
		            .setData(Events.CONTENT_URI)
			        .putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTimeMillis)
			        .putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTimeMillis)
			        .putExtra(Events.TITLE, title)
			        .putExtra(Events.DESCRIPTION, description)
			        .putExtra(Events.EVENT_LOCATION, location)
			        .putExtra(Events.AVAILABILITY, Events.AVAILABILITY_FREE);

				this.cordova.startActivityForResult(this, intent, RESULT_CODE_ADD);
				return true;
			} else if (action.equals(ACTION_EDIT_EVENT)) {
				//to do later
				return true;
			}
		} catch(Exception e) {
			System.err.println("Exception: " + e.getMessage());
			callback.error(e.getMessage());
			return false;
		}     

		return false;
	}

	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == RESULT_CODE_ADD) {
			if (resultCode == Activity.RESULT_OK) {
				callback.success();
			} else {
				callback.error("Activity result code " + resultCode);
			}
		} else if (requestCode == RESULT_CODE_EDIT) {
			if (resultCode == Activity.RESULT_OK) {
				callback.success();
			} else {
				callback.error("Activity result code " + resultCode);
			}
		}
	}
}