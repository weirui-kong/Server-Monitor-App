//
//  ServerCardView.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import SwiftUI

struct ServerCardView: View {
    
    var server: UniversalServer
    
    var body: some View {
        VStack{
            basicInfo()
            netInfo()
            loadBars()
        }
        .foregroundColor(.white.opacity(0.8))
        .padding()
        .materialBackground()
        
    }
    
    private func basicInfo() -> some View{
        VStack{
            HStack{
                Text(getFlagEmoji(for: server.region))
                Text(server.name)
            }.font(.title2)
            
            HStack{
                Image(systemName: "location")
                Text(server.location ?? "未知")
                Spacer()
                Image(systemName: "clock.badge.checkmark")
                Text(server.uptime ?? "未知")
            }.font(.footnote)
        }
    }
    
    private func netInfo() -> some View{
        VStack{
            HStack{
                HStack{
                    Image(systemName: "network")
                        .overlay(Text("4").font(.system(size: 10)).colorFillBackground(cornerRadius: 3).offset(x: 5, y: 5))
                    Text(server.online4 ? "Online" : "Offline")
                }
                .opacity(server.online4 ? 1 : 0.5)
                Spacer()
                
                Image(systemName: "icloud.and.arrow.up")
                Text("\(formatBytes(server.networkTx))/\(formatBytes(server.networkOut))" )
            }.font(.footnote)
            
            HStack{
                HStack{
                    Image(systemName: "network")
                        .overlay(Text("6").font(.system(size: 10)).colorFillBackground(cornerRadius: 3).offset(x: 5, y: 5))
                    Text(server.online6 ? "Online" : "Offline")
                }
                .opacity(server.online6 ? 1 : 0.5)
                Spacer()
                Image(systemName: "icloud.and.arrow.down")
                Text("\(formatBytes(server.networkRx))/\(formatBytes(server.networkIn))" )
            }.font(.footnote)
        }
    }
    
    private func loadBars() -> some View{
    
        VStack(spacing: 15){
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
                .frame(width: 40)
            ZStack{
                GeometryReader{geo in
                    ZStack(alignment: .leading){
                        Capsule()
                            .opacity(0.2)
                        
                        Capsule()
                            .frame(width: max(20, Double(percent ?? 100) / 100.0 * geo.size.width))
                            .foregroundStyle(getColorForLoad(percent))
                            .opacity(0.7)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5), value: percent)
                        
                    }
                    
                }
                
                Text(percent == nil ? "N/A" : overlay)
                    .font(.caption)
                    .padding(3)
                    .colorFillBackground(cornerRadius: 5, opacity: 0.5)
            }.frame(height: 25)
            
        }
    }
    
    
    private func getColorForLoad(_ load: Int? ) -> Color {
        guard (load != nil) else{
            return .black.opacity(0.8)
        }
        
        switch load! {
        case 0..<35:
            return Color.fromHex("7ac143")!
        case 35..<75:
            return Color.fromHex("f48924")!
        default:
            return Color.fromHex("ff4c4c")!
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
        
        return flagEmoji.isEmpty ? "🚩" : flagEmoji
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
    ServerCardView(server: UniversalServer(
        name: "My Server",
        type: "Web Server",
        host: "example.com",
        location: "Houston",
        online4: true,
        online6: false,
        uptime: "10 days",
        load: 1.5,
        networkRx: 100,
        networkTx: 50,
        networkIn: 3452,
        networkOut: 1244,
        cpuPercent: 53,
        memoryTotal: 8192,
        memoryUsed: 2048,
        swapTotal: 4096,
        swapUsed: 512,
        hddTotal: 100000,
        hddUsed: 50000,
        custom: "Custom info",
        region: "US"
    ))
}
 
