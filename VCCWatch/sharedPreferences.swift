//
//  sharedPreferences.swift
//  VCCWatch
//
//  Created by Brett Henderson on 9/23/15.
//  Copyright © 2015 Brett Henderson. All rights reserved.
//

import Foundation
import WatchKit
import iAd


public class SharedPreferencesSettings: WritableSettings{
    
    private final Context ctx;
    
    public SharedPreferencesSettings(final Context ctx) {
    this.ctx = ctx;
    
    
private SharedPreferences getPrefs() {
    return ctx.getSharedPreferneces("seetings", Activity.MODE_PRIVATE);
}

@override
public int getTemperatureFormat() {
    return getPrefs().getInt("temp", TEMPERATURE_CELSIUS);

}

@override
public void settemperatureFormat(int format) {
    return getPrefs().edit().putInt("temp", format).commit();

}


@override
    public NSString getAutoConnectMac() {
    return getPrefs().getScring("addr", null);
    
    }

}
    }
}