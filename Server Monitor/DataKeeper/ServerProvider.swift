//
//  ServerProvider.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import Foundation
import SwiftUI
class ServerProvider: ObservableObject{
    // static let monitors = [("OSP", "https://server.onespirit.fyi/json/stats.json", MonitorType.hotaru), ("OSP alias", "https://server.onespirit.fyi/json/stats.json", MonitorType.hotaru), ("OSP alias2", "https://server.onespirit.fyi/json/stats.json", MonitorType.hotaru), ("OSP alias3", "https://server.onespirit.fyi/json/stats.json", MonitorType.hotaru), ("OSP alias4", "https://server.onespirit.fyi/json/stats.json", MonitorType.hotaru), ("OSP alias5", "https://server.onespirit.fyi/json/stats.json", MonitorType.hotaru)]
    static let monitors = [("OSP", "https://server.onespirit.fyi/json/stats.json", MonitorType.hotaru)]
    
    static var shared = ServerProvider()
    
    @Published var groups: [UniversalServerGroup] = []
    
    @Published var serverCount = 0
    
    init() {
        DispatchQueue.global().async {
            while true{
                self.updateServerMonitorData()
                self.countServer()
                sleep(2)
            }
        }
    }
    
    private func updateServerMonitorData(){
        
        for monitor in ServerProvider.monitors{
            NetworkManager.shared.sendRequest(path: monitor.1){data in
                let group: UniversalServerGroup? = monitor.2.factory(data, monitor.0)
                
                guard group != nil else{
                    print("数据解析出错")
                    return
                }
                self.updateGroup(group!)
            }err_completion: {
                let group = UniversalServerGroup(label: monitor.0, server: [], lastUpdated: 0, type: monitor.2)
                self.updateGroup(group)
            }
        }
    }
    
    private func updateGroup(_ newGroup: UniversalServerGroup) {
        if let index = groups.firstIndex(where: { $0.label == newGroup.label }) {
            groups[index] = newGroup
        } else {
            groups.append(newGroup)
        }
    }
    
    private func countServer(){
        var count = 0
        for group in groups {
            count += group.server.count
        }
        DispatchQueue.main.async{
            self.serverCount = count
        }
    }
}
