//
//  MonitorType.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import Foundation
enum MonitorType: String, CaseIterable{
    case hotaru = "HOTARU"
    case nezha = "哪吒"
    var factory: ((Data, String) -> UniversalServerGroup?) {
        return ServerDataFactory.parseFromHotaru
    }
    
    static let supportedProtos = ["http-get", "websocket"]

    static let defaultProto = "http-get"
    
    var getDefaultRequestProto: String{
        switch self {
        case .hotaru:
            return "http-get"
        case .nezha:
            return "websocket"
        }
    }
    
    var getDefaultRequestProtoPrefix: String{
        switch self {
        case .hotaru:
            return "https://"
        case .nezha:
            return "wss://"
        }
    }
    
    
    
}
