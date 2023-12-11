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
}
