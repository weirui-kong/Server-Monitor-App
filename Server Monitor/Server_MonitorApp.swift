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


let imgs = [
    ("Catalina", "robert-palmer-apcVUAd_o9M-unsplash", "Robert Palmer (@honestcode)", "city near seashore under orange and yellow cloudy sky", "https://unsplash.com/photos/city-near-seashore-under-orange-and-yellow-cloudy-sky-apcVUAd_o9M"),
    ("Catalina", "xuyu-chi-_6KrHEpZ0Ro-unsplash-small", "Xuyu Chi (@xccc)", "a sailboat and a small boat in the ocean", "https://unsplash.com/photos/a-sailboat-and-a-small-boat-in-the-ocean-_6KrHEpZ0Ro")
]
