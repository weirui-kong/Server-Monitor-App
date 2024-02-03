//
//  DataFactory.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import Foundation

class ServerDataFactory {
    static func parseFromHotaru(from data: Data, label: String) -> UniversalServerGroup? {
        let decoder = JSONDecoder()
        do {
            let serverData = try decoder.decode(DataRsp_Hotaru.self, from: data)
            var groups = UniversalServerGroup(label: label, server: [], lastUpdated: Int(serverData.updated) ?? 0, type: .hotaru)
            for server in serverData.servers{
                let uni = UniversalServer(
                        name: server.name,
                        type: server.type,
                        host: server.host,
                        location: server.location,
                        online4: server.online4,
                        online6: server.online6,
                        uptime: server.uptime,
                        load: server.load,
                        networkRx: server.networkRx,
                        networkTx: server.networkTx,
                        networkIn: server.networkIn,
                        networkOut: server.networkOut,
                        cpuPercent: server.cpu,
                        memoryTotal: server.memoryTotal == nil ? nil : server.memoryTotal! * 1000,
                        memoryUsed: server.memoryUsed == nil ? nil : server.memoryUsed! * 1000,
                        swapTotal: server.swapTotal == nil ? nil : server.swapTotal! * 1000,
                        swapUsed: server.swapUsed == nil ? nil : server.swapUsed! * 1000,
                        hddTotal: server.hddTotal == nil ? nil : server.hddTotal! * 1000 * 1000,
                        hddUsed: server.hddUsed == nil ? nil : server.hddUsed! * 1000 * 1000,
                        custom: server.custom,
                        region: server.region
                    )
                groups.server.append(uni)
            }
            return groups.server.count == 0 ? nil : groups
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    static func parseFromCppla(from data: Data, label: String) -> UniversalServerGroup? {
        let decoder = JSONDecoder()
        do {
            let serverData = try decoder.decode(DataRsp_Cppla.self, from: data)
            var groups = UniversalServerGroup(label: label, server: [], lastUpdated: Int(serverData.updated) ?? 0, type: .server_status)
            for server in serverData.servers {
                let uni = UniversalServer(
                    name: server.name,
                    type: server.type,
                    host: server.host,
                    location: server.location,
                    online4: server.online4,
                    online6: server.online6,
                    uptime: server.uptime,
                    load: server.load,
                    networkRx: server.networkRx,
                    networkTx: server.networkTx,
                    networkIn: server.networkIn,
                    networkOut: server.networkOut,
                    cpuPercent: server.cpu,
                    memoryTotal: server.memoryTotal,
                    memoryUsed: server.memoryUsed,
                    swapTotal: server.swapTotal,
                    swapUsed: server.swapUsed,
                    hddTotal: server.hddTotal,
                    hddUsed: server.hddUsed,
                    custom: server.custom,
                    region: "",
                    ping10010: server.ping10010,
                    ping189: server.ping189,
                    ping10086: server.ping10086,
                    time10010: server.time10010,
                    time189: server.time189,
                    time10086: server.time10086,
                    tcpCount: server.tcpCount,
                    udpCount: server.udpCount,
                    processCount: server.processCount,
                    threadCount: server.threadCount,
                    ioRead: server.ioRead,
                    ioWrite: server.ioWrite
                )
                groups.server.append(uni)
            }
            return groups.server.isEmpty ? nil : groups
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    static func parseFromNezha(from data: Data, label: String) -> UniversalServerGroup? {
        return nil
    }
    static func convertStringifiedJSONToDictionary(from data: Data) -> [String: Any]? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            }
        } catch {
            print("Error converting stringified JSON to Dictionary: \(error)")
        }
        
        return nil
    }
}
