//
//  Result+Ext.swift
//  AlarmMission
//
//  Created by choijunios on 3/4/25.
//


//
//  Result+Ex.swift
//  SOOP2025
//
//  Created by choijunios on 2/5/25.
//

extension Result {
    var value: Success? {
        guard case let .success(value) = self else {
            return nil
        }
        return value
    }

    var error: Failure? {
        guard case let .failure(error) = self else {
            return nil
        }
        return error
    }
}
