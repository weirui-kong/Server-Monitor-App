//
//  MonitorType.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import Foundation
enum MonitorType: String, CaseIterable{
    case hotaru = "HOTARU"
    
    var factory: ((Data, String) -> UniversalServerGroup?) {
        return ServerDataFactory.parseFromHotaru
    }
}
