//
//  BornTimeData.swift
//  FeatureCommonEntity
//
//  Created by choijunios on 2/13/25.
//

public struct BornTimeData {
    public var meridiem: Meridiem
    public var hour: Hour
    public var minute: Minute
    
    public init(meridiem: Meridiem, hour: Hour, minute: Minute) {
        self.meridiem = meridiem
        self.hour = hour
        self.minute = minute
    }
}
