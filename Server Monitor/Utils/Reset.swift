//
//  Reset.swift
//  Server Monitor
//
//  Created by 孔维锐 on 10/21/23.
//

import Foundation
import Kingfisher

func clearUserDefaultsAndCache() {
    // 清除 UserDefaults 的全部数据
    if let bundleIdentifier = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
        UserDefaults.standard.synchronize()
    }
    
    // 清除 Kingfisher 的缓存
    KingfisherManager.shared.cache.clearDiskCache()
    KingfisherManager.shared.cache.clearMemoryCache()
    
    // 清除 Server Provider
    
    ServerProvider.shared.removeAllMonitors()
}
