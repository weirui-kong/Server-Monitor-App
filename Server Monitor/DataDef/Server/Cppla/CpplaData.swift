//
//  CpplaData.swift
//  Server Monitor
//
//  Created by 孔维锐 on 2/3/24.
//
import Foundation

struct DataDef_Cppla: Codable {
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
    var ping10010: Int? // 联通线路丢包，可选
    var ping189: Int? // 电信线路丢包，可选
    var ping10086: Int? // 移动线路丢包，可选
    var time10010: Int? // 联通线路延迟，可选
    var time189: Int? // 电信线路延迟，可选
    var time10086: Int? // 移动线路延迟，可选
    var tcpCount: Int? // TCP连接数，可选
    var udpCount: Int? // UDP连接数，可选
    var processCount: Int? // 进程数，可选
    var threadCount: Int? // 线程数，可选
    var ioRead: Int? // IO读取，可选
    var ioWrite: Int? // IO写入，可选

    enum CodingKeys: String, CodingKey {
        case name, type, host, online4, online6, uptime, load
        case networkRx = "network_rx"
        case networkTx = "network_tx"
        case networkIn = "network_in"
        case networkOut = "network_out"
        case cpu, memoryTotal = "memory_total", memoryUsed = "memory_used"
        case swapTotal = "swap_total", swapUsed = "swap_used"
        case hddTotal = "hdd_total", hddUsed = "hdd_used"
        case custom
        case location
        case ping10010, ping189, ping10086, time10010, time189, time10086, tcpCount, udpCount, processCount, threadCount, ioRead, ioWrite
    }
}

struct DataRsp_Cppla: Codable {
    let servers: [DataDef_Cppla]
    let updated: String
}
