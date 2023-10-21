//
//  UniversalServerGroup.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import Foundation
class UniversalServerGroup: ObservableObject{
    var label: String
    @Published var server: [UniversalServer]
    @Published var lastUpdated: Int
    var type: MonitorType
    init(label: String, server: [UniversalServer], lastUpdated: Int, type: MonitorType) {
        self.label = label
        self.server = server
        self.lastUpdated = lastUpdated
        self.type = type
    }
}


