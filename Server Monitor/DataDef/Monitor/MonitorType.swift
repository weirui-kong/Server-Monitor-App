//
//  MonitorType.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import Foundation
enum MonitorType: String, CaseIterable{
    case server_status = "原版CPP.LA"
    case hotaru = "HOTARU"
    case nezha = "哪吒"
    
    var factory: ((Data, String) -> UniversalServerGroup?) {
        switch self {
        case .hotaru:
            return ServerDataFactory.parseFromHotaru
        case .server_status:
            return ServerDataFactory.parseFromCppla
        case .nezha:
            return ServerDataFactory.parseFromNezha
        }
    }
    
    static let supportedProtos = ["http-get", "websocket"]

    static let defaultProto = "http-get"
    
    var getDefaultRequestProto: String{
        switch self {
        case .hotaru:
            return "http-get"
        case .server_status:
            return "http-get"
        case .nezha:
            return "websocket"
        }
    }
    
    var getDefaultRequestProtoPrefix: String{
        switch self {
        case .hotaru:
            return "https://"
        case .server_status:
            return "https://"
        case .nezha:
            return "wss://"
        }
    }
    
    var getRequestApiSample: String{
        switch self {
        case .hotaru:
            return "https://server.onespirit.fyi/json/stats.json"
        case .server_status:
            return "https://tz.cloudcpp.com/json/stats.json"
        case .nezha:
            return ""
        }
    }
    
    var getOpensourceOrigin: String{
        switch self {
        case .hotaru:
            return "https://github.com/cokemine/ServerStatus-Hotaru"
        case .server_status:
            return "https://github.com/cppla/ServerStatus"
        case .nezha:
            return "https://github.com/naiba/nezha"
        }
    }
    
    var getOpensourceProjectName: String{
        switch self {
        case .hotaru:
            return "cokemine/ServerStatus-Hotaru"
        case .server_status:
            return "cppla/ServerStatus"
        case .nezha:
            return "naiba/nezha"
        }
    }
    
    var getFeatures: [String]{
        switch self {
        case .hotaru:
            return []
        case .server_status:
            return ["三网延迟", "网络波动", "线程数", "链接数"]
        case .nezha:
            return []
        }
    }
    
    var supportDomesticPing: Bool{
        switch self {
        case .hotaru: return false
        case .server_status: return true
        case .nezha: return false
        }
    }
    
    var supportConnectionCount: Bool{
        switch self {
        case .hotaru: return false
        case .server_status: return true
        case .nezha: return false
        }
    }
    
    var supportProcessCount: Bool{
        switch self {
        case .hotaru: return false
        case .server_status: return true
        case .nezha: return false
        }
    }
    
    var supportIoRw: Bool{
        switch self {
        case .hotaru: return false
        case .server_status: return true
        case .nezha: return false
        }
    }
}
