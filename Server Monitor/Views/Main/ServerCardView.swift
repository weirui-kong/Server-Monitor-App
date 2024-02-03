//
//  ServerCardView.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import SwiftUI
import Anitom
import Kingfisher
struct ServerCardView: View {
    
    @AppStorage("PlainFillTheme") var plainFillTheme = "Dark"
    //@StateObject var inj = AnitomInjector()
    
    var server: UniversalServer
    var largerScale = false
    var supportDomesticPing: Bool
    var supportConnectionCount: Bool
    var supportProcessCount: Bool
    var supportIoRw: Bool
    @AppStorage("ShowIspLogo") var showIspLogo = true
    var body: some View {
        VStack{
            basicInfo()
            netInfo()
            if supportDomesticPing{
                ispPingInfo()
            }
            
            if server.online{
                loadBars()
            }else{
                loadBars()
                    .blur(radius: 7)
                    .overlay{
                        Text("当前服务器不在线")
                            .padding()
                            .materialBackground()
                    }
            }
        }
        .foregroundColor(.white.opacity(0.8))
        .padding()
        .materialBackground(overrideColor: plainFillTheme == "Dark" ? .black : .white)
        //.onHoverFloating(inj: inj, duration: 0.3, dropShaddow: false, scaleMargin: 0)
    }
    
    private func basicInfo() -> some View{
        VStack{
            HStack{
                Text(getFlagEmoji(for: server.region))
                Text(server.name)
            }.font(largerScale ? .title : .title2)
            
            HStack{
                Image(systemName: "location")
                Text(server.location ?? "未知")
                Spacer()
                Image(systemName: "clock.badge.checkmark")
                Text(server.uptime ?? "未知")
            }.font(largerScale ? .body : .footnote)
        }
    }
    
    private func netInfo() -> some View{
        VStack{
            HStack{
                HStack{
                    Image(systemName: "network")
                        .overlay{
                            Text("4")
                                .font(.system(size: largerScale ? 14 : 10))
                                .colorFillBackground(cornerRadius: 3, overrideColor: .white)
                                .offset(x: largerScale ? 8 : 5, y: largerScale ? 8 : 5)
                        }
                    Text(server.online4 ? "Online" : "Offline")
                }
                .opacity(server.online4 ? 1 : 0.5)
                Spacer()
                
                Image(systemName: "icloud.and.arrow.up")
                Text("\(formatBytes(server.networkTx))/\(formatBytes(server.networkOut))" )
            }.font(largerScale ? .body : .footnote)
            
            HStack{
                HStack{
                    Image(systemName: "network")
                        .overlay{
                            Text("6")
                                .font(.system(size: largerScale ? 14 : 10))
                                .colorFillBackground(cornerRadius: 3, overrideColor: .white)
                                .offset(x: largerScale ? 8 : 5, y: largerScale ? 8 : 5)
                        }
                    Text(server.online6 ? "Online" : "Offline")
                }
                .opacity(server.online6 ? 1 : 0.5)
                Spacer()
                Image(systemName: "icloud.and.arrow.down")
                Text("\(formatBytes(server.networkRx))/\(formatBytes(server.networkIn))" )
            }.font(largerScale ? .body : .footnote)
        }
    }
    
    func carrierIdentifier(code: String, scale: CGFloat = 1.0) -> some View{
        Group{
            if showIspLogo && (onlineImgLink(searchBy: code) != nil){
                KFImage(URL(string: onlineImgLink(searchBy: code)!)!)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(scale)
                    .frame(height: largerScale ? 60 : 40)
                    .opacity(0.8)
                    
            }else{
                Text(code)
                    .colorFillBackground()
            }
        }
    }
    
    private func ispPingInfo() -> some View{
        HStack{
            VStack{
                carrierIdentifier(code: "CM")
                Text("\(server.ping10086 ?? -1)%/\(server.latency10086 ?? -1)ms")
                    .font(largerScale ? .body : .footnote)
            }.colorFillBackground(padding: 5, opacity: 0.8, overrideColor: .white)
            Spacer()
            VStack{
                carrierIdentifier(code: "CT")
                Text("\(server.ping189 ?? -1)%/\(server.latency189 ?? -1)ms")
                    .font(largerScale ? .body : .footnote)
            }.colorFillBackground(padding: 5, opacity: 0.8, overrideColor: .white)
            Spacer()
            VStack{
                carrierIdentifier(code: "CU", scale: 0.8)
                Text("\(server.ping10010 ?? -1)%/\(server.latency10010 ?? -1)ms")
                    .font(largerScale ? .body : .footnote)
            }.colorFillBackground(padding: 5, opacity: 0.8, overrideColor: .white)
        }
        
    }
    
    
    private func loadBars() -> some View{
    
        VStack(spacing: largerScale ? 17 : 15){
            progressBar(of: server.cpuPercent, title: "CPU", sysImg: "cpu",
                        overlay: "\(server.cpuPercent ?? 0) %"
            )
            progressBar(of: server.memoryUsedPercent, title: "MEM", sysImg: "memorychip",
                        overlay: "\(formatBytes(server.memoryUsed))/\(formatBytes(server.memoryTotal))"
            )
            progressBar(of: server.hddUsedPercent, title: "HDD", sysImg: "opticaldiscdrive",
                        overlay: "\(formatBytes(server.hddUsed))/\(formatBytes(server.hddTotal))"
            )
            progressBar(of: server.swapUsedPercent, title: "SWP", sysImg: "rectangle.2.swap",
                        overlay: "\(formatBytes(server.swapUsed))/\(formatBytes(server.swapTotal))"
            )
        }
    }
    
    private func progressBar(of percent: Int?, title: String, sysImg: String, overlay: String) -> some View{
        
        HStack{
            Image(systemName: sysImg)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text(title)
                .minimumScaleFactor(0.5)
                .font(largerScale ? .title3 : .body)
                .frame(width: largerScale ? 45 : 40)
            ZStack{
                GeometryReader{geo in
                    ZStack(alignment: .leading){
                        Capsule()
                            .opacity(0.2)
                        
                        Capsule()
                            .frame(width: max(20, Double(percent ?? 100) / 100.0 * geo.size.width))
                            .foregroundStyle(getColorForLoad(percent))
                            .opacity(0.8)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5), value: percent)
                        
                    }
                    
                }
                
                Text(percent == nil ? "N/A" : overlay)
                    .font(largerScale ? .subheadline : .caption)
                    .padding(3)
                    .colorFillBackground(cornerRadius: 5, opacity: 0.5)
                
            }.frame(height: largerScale ? 30 : 25)
            
        }
    }
    
    @AppStorage("UseHighSaturationColors") var useHighSaturationColors = false
    private func getColorForLoad(_ load: Int? ) -> Color {
        guard (load != nil) else{
            return .black.opacity(0.8)
        }
        
        switch (load!, useHighSaturationColors) {
        case (0..<35, false):
            return Color.fromHex("7ac143")!
        case (35..<75, false):
            return Color.fromHex("f48924")!
        case (_, false):
            return Color.fromHex("ff4c4c")!
        case (0..<35, true):
            return Color.fromHex("50C878")!
        case (35..<75, true):
            return Color.fromHex("F28C28")!
        case (_, true):
            return Color.fromHex("E34234")!
        }
    }
    private func formatBytes(_ bytes: Int?) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB, .useTB]
        byteCountFormatter.countStyle = .file
        
        return byteCountFormatter.string(fromByteCount: Int64(bytes ?? 0))
    }
    
    private func getFlagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var flagEmoji = ""
        
        countryCode.uppercased().unicodeScalars.forEach {
            if let flagScalar = UnicodeScalar(base + $0.value) {
                flagEmoji.append(String(describing: flagScalar))
            }
        }
        
        //return flagEmoji.isEmpty ? "🚩" : flagEmoji
        return flagEmoji
    }
}


extension Color {
    static func fromHex(_ hex: String) -> Color? {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgbValue: UInt64 = 0
        
        guard Scanner(string: hexString).scanHexInt64(&rgbValue) else {
            return nil
        }
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
//    ServerCardView(server: UniversalServer(
//        name: "My Server",
//        type: "Web Server",
//        host: "example.com",
//        location: "Houston",
//        online4: true,
//        online6: false,
//        uptime: "10 days",
//        load: 1.5,
//        networkRx: 100,
//        networkTx: 50,
//        networkIn: 3452,
//        networkOut: 1244,
//        cpuPercent: 53,
//        memoryTotal: 8192,
//        memoryUsed: 2048,
//        swapTotal: 4096,
//        swapUsed: 512,
//        hddTotal: 100000,
//        hddUsed: 50000,
//        custom: "Custom info",
//        region: "US"
//    ), largerScale: true)
    ServerCardView(server: UniversalServer(name: "香港", type: "KVM", host: "", location: "HK", online4: true, online6: false, uptime: "106 天", load: 0.27, networkRx: 17872, networkTx: 19702, networkIn: 258123837125, networkOut: 183551862448, cpuPercent: 3, memoryTotal: 4013656, memoryUsed: 587812, swapTotal: 998396, swapUsed: 280700, hddTotal: 59204, hddUsed: 29706, custom: "", region: "", ping10010: 0, ping189: 0, ping10086: 12, latency10010: 12, latency189: 48, latency10086: 32, tcpCount: 16, udpCount: 200, processCount: 422, threadCount: 3221, ioRead: 0, ioWrite: 16384), largerScale: false, supportDomesticPing: true, supportConnectionCount: true, supportProcessCount: true, supportIoRw: true)
        .background(Color.black)
}
 
