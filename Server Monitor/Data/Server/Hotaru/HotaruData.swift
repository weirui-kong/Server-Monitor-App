//
//  HotaruData.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import Foundation

struct DataDef_Hotaru: Codable {
    let name: String
    let type: String
    let host: String?
    let location: String?
    let online4: Bool
    let online6: Bool
    let uptime: String?
    let load: Double?
    let networkRx: Int?
    let networkTx: Int?
    let networkIn: Int?
    let networkOut: Int?
    let cpu: Int?
    let memoryTotal: Int?
    let memoryUsed: Int?
    let swapTotal: Int?
    let swapUsed: Int?
    let hddTotal: Int?
    let hddUsed: Int?
    let custom: String?
    let region: String
    
    enum CodingKeys: String, CodingKey {
        case name, type, host, location, online4, online6, uptime, load
        case networkRx = "network_rx"
        case networkTx = "network_tx"
        case networkIn = "network_in"
        case networkOut = "network_out"
        case cpu, memoryTotal = "memory_total", memoryUsed = "memory_used"
        case swapTotal = "swap_total", swapUsed = "swap_used"
        case hddTotal = "hdd_total", hddUsed = "hdd_used"
        case custom, region
    }
}

struct DataRsp_Hotaru: Codable {
    let servers: [DataDef_Hotaru]
    let updated: String
}
