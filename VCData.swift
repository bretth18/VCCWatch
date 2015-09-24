//
//  VCData.swift
//  VCCWatch
//
//  Created by Brett Henderson on 9/24/15.
//  Copyright © 2015 Brett Henderson. All rights reserved.
//

import Foundation
import WatchKit
import WebKit


public class VCData: CRAFTY_UUID, CRAFTY_COM {
    
    
    public int batteryPercentage;
    
    public int currentTemperature;
}
    public int setTemperature

    public int boostTemperature


public class VaporizerUpdateListener: UIAppearance {
    
    func onUpdate(VaporizerData, data);
    
}
//RETURN DATA TYPE NULL

public bool hasData() :{
    return batteryPercentage != null || currentTemperature !=null || setTemperature != null || boostTemperature != null
}


}
