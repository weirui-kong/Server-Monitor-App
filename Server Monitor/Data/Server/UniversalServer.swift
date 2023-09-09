//
//  UniversalServer.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import Foundation

class UniversalServer {
    var name: String // 服务器名称
    
    var type: String // 服务器类型
    
    var host: String? // 服务器主机，可选
    
    var location: String? // 服务器位置，可选
    
    var online: Bool // 服务器是否在线
    
    var online4: Bool // IPv4 地址是否在线
    
    var online6: Bool // IPv6 地址是否在线
    
    var uptime: String? // 服务器运行时间，可选
    
    var load: Double? // 服务器负载，可选
    
    var networkRx: Int? // 网络接收字节数，可选
    
    var networkTx: Int? // 网络发送字节数，可选
    
    var networkIn: Int? // 网络接收流量，可选
    
    var networkOut: Int? // 网络发送流量，可选
    
    var cpuPercent: Int? // CPU 使用率，可选
    
    var memoryTotal: Int? // 总内存容量，可选
    
    var memoryUsed: Int? // 已使用内存容量，可选
    
    var memoryUsedPercent: Int? // 内存使用百分比，可选
    
    var swapTotal: Int? // 总交换空间容量，可选
    
    var swapUsed: Int? // 已使用交换空间容量，可选
    
    var swapUsedPercent: Int? // 交换空间使用百分比，可选
    
    var hddTotal: Int? // 总硬盘容量，可选
    
    var hddUsed: Int? // 已使用硬盘容量，可选
    
    var hddUsedPercent: Int? // 硬盘使用百分比，可选
    
    var custom: String? // 自定义信息，可选
    
    var region: String // 服务器所在地区，ISO的标准码，例如US HK
    
    
    init(name: String, type: String, host: String? = nil, location: String? = nil, online4: Bool, online6: Bool, uptime: String? = nil, load: Double? = nil, networkRx: Int? = nil, networkTx: Int? = nil, networkIn: Int? = nil, networkOut: Int? = nil, cpuPercent: Int? = nil, memoryTotal: Int? = nil, memoryUsed: Int? = nil, swapTotal: Int? = nil, swapUsed: Int? = nil, hddTotal: Int? = nil, hddUsed: Int? = nil, custom: String? = nil, region: String) {
        self.name = name
        self.type = type
        self.host = host
        self.location = location
        self.online = online4 || online6
        self.online4 = online4
        self.online6 = online6
        self.uptime = uptime
        self.load = load
        self.networkRx = networkRx
        self.networkTx = networkTx
        self.networkIn = networkIn
        self.networkOut = networkOut
        self.cpuPercent = cpuPercent
        self.memoryTotal = memoryTotal
        self.memoryUsed = memoryUsed
        self.memoryUsedPercent = UniversalServer.calculatePercentage(value: memoryUsed, total: memoryTotal)
        self.swapTotal = swapTotal
        self.swapUsed = swapUsed
        self.swapUsedPercent = UniversalServer.calculatePercentage(value: swapUsed, total: swapTotal)
        self.hddTotal = hddTotal
        self.hddUsed = hddUsed
        self.hddUsedPercent = UniversalServer.calculatePercentage(value: hddUsed, total: hddTotal)
        self.custom = custom
        self.region = region
    }
    
    static private func calculatePercentage(value: Int?, total: Int?) -> Int? {
        guard let value = value, let total = total else {
            return nil
        }
        
        if total == 0 {
            return nil
        }
        return Int((Double(value) / Double(total)) * 100)
    }
}
