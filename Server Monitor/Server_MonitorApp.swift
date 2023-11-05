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
    @AppStorage("AlwaysOnDisplay") var alwaysOnDisplay = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {applyDefaultSettings()})
        }
    }
    func applyDefaultSettings(){
        UIApplication.shared.isIdleTimerDisabled = alwaysOnDisplay
    }
}


