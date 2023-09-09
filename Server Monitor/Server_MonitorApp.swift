//
//  Server_MonitorApp.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import SwiftUI
import CoreData

@main
struct Server_MonitorApp: App {
    let container: NSPersistentContainer
    
    init(){
        // 指定模型文件
        container = NSPersistentContainer(name: "MonitorConfigs")
        // 加载存储类型
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, container.viewContext)
        }
    }
}


