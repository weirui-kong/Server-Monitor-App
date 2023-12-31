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
    static var monitors: [(String, String, MonitorType, Bool)] = []
    
    static let shared = ServerProvider()
    
    @Published var groups: [UniversalServerGroup] = []
    
    @Published var serverCount = 0
    
    init() {
        loadMonitorsFromUserDefaults()
        
        let updateTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [self] timer in
            
            self.updateServerMonitorData()
            self.countServer()
            
        }
        // 添加到运行循环中，使定时器生效
        RunLoop.current.add(updateTimer, forMode: .common)
        
        let checkRedundantGroupsTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [self] timer in
            for group in groups{
                let now = Date()
                if group.lastUpdated + 60 < Int(now.timeIntervalSince1970) {
                    withAnimation(){
                        self.groups.removeAll(where: {$0.label == group.label})
                    }
                }
            }
        }
        // 添加到运行循环中，使定时器生效
        RunLoop.current.add(checkRedundantGroupsTimer, forMode: .common)
    }
    
    private func updateServerMonitorData() {
        // 遍历筛选出 show 为 true 的监视器数据
        for monitor in ServerProvider.monitors.filter({ $0.3 }) {
            // 发送网络请求获取监视器数据
            NetworkManager.shared.sendRequest(path: monitor.1) { data in
                // 使用监视器对应的工厂方法解析数据并创建 UniversalServerGroup 实例
                let group: UniversalServerGroup? = monitor.2.factory(data, monitor.0)
                
                // 检查解析结果是否为空
                guard group != nil else {
                    print("数据解析出错")
                    return
                }
                
                // 更新 UniversalServerGroup
                self.updateGroup(group!)
            } err_completion: {
                // 创建一个默认的 UniversalServerGroup，用于处理错误情况
                let group = UniversalServerGroup(label: monitor.0, server: [], lastUpdated: 0, type: monitor.2)
                
                // 更新 UniversalServerGroup
                self.updateGroup(group)
            }
        }
    }
    
    private func updateGroup(_ newGroup: UniversalServerGroup) {
        
        if let index = groups.firstIndex(where: { $0.label == newGroup.label }) {
            groups[index] = newGroup
        } else {
            withAnimation(.spring){
                groups.append(newGroup)
            }
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
    
    // MARK: Server Configs Saving
    // 保存数据到 UserDefaults
    private func saveMonitorsToUserDefaults() {
        // 将数据转换为可保存的格式
        let data = ServerProvider.monitors.map { (name, url, type, show) -> [String: Any] in
            return [
                "name": name,
                "url": url,
                "type": type.rawValue,
                "show": show
            ]
        }
        
        // 保存数据到 UserDefaults
        UserDefaults.standard.set(data, forKey: "monitors")
    }
    
    // 从 UserDefaults 读取数据
    private func loadMonitorsFromUserDefaults(){
        // 从 UserDefaults 获取数据
        guard let data = UserDefaults.standard.array(forKey: "monitors") as? [[String: Any]] else {
            return
        }
        
        // 将数据转换为原始格式
        ServerProvider.monitors = data.compactMap { dict -> (String, String, MonitorType, Bool)? in
            guard let name = dict["name"] as? String,
                  let url = dict["url"] as? String,
                  let typeRawValue = dict["type"] as? String,
                  let type = MonitorType(rawValue: typeRawValue),
                  let show = dict["show"] as? Bool else {
                return nil
            }
            
            return (name, url, type, show)
        }
    }
    
    // 添加新的数据到 monitors
    func addMonitor(name: String, url: String, type: MonitorType, show: Bool) {
        // 添加新的数据
        ServerProvider.monitors.append((name, url, type, show))
        
        // 保存更新后的数据到 UserDefaults
        saveMonitorsToUserDefaults()
    }
    
    // 删除全部
    func removeAllMonitors() {
        // 添加新的数据
        ServerProvider.monitors = []
        
        // 保存更新后的数据到 UserDefaults
        saveMonitorsToUserDefaults()
    }
    
    func removeMonitorByName(_ name: String) {
        // 查找要删除的监视器在 monitors 数组中的索引
        if let index = ServerProvider.monitors.firstIndex(where: { $0.0 == name }) {
            // 找到了要删除的监视器，进行删除操作
            ServerProvider.monitors.remove(at: index)
            
            // 保存更新后的数据到 UserDefaults
            saveMonitorsToUserDefaults()
        } else {
            // 没有找到要删除的监视器
            print("未找到名称为 \(name) 的监视器")
        }
    }
}
