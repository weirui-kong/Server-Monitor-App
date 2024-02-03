//
//  MainPage.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import SwiftUI
import Kingfisher

struct MainPage: View {
    @Binding var showSettings: Bool
    @AppStorage("LargerScale") var largerScale = false
    @AppStorage("PlainFillTheme") var plainFillTheme = "Dark"

    @ObservedObject var serverProvider = ServerProvider.shared
    @StateObject private var motion = MotionManager.shared
    
    @AppStorage("AllowDepthEffectOfBackground") var allowDepthEffectOfBackground: Bool = true
    @AppStorage("AllowDepthEffectOfForeground") var allowDepthEffectOfForeground: Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                if serverProvider.groups.isEmpty{
                    Text("还没有服务器呢")
                        .padding(100)
                }
                ForEach(serverProvider.groups, id: \.label){group in
                    Group{
                        Section{
                            if group.server.isEmpty{
                                Text("没有正在运行的服务器或解析错误\n请查看设置")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(Material.ultraThin)
                                    .cornerRadius(15)
                                    .padding()
                            }else{
                                LazyVGrid(columns: [GridItem(.adaptive(
                                    minimum: largerScale ? 350 : 280,
                                    maximum: largerScale ? 500 : 400
                                ))]){
                                    
                                    ForEach(group.server, id: \.id){server in
                                        ServerCardView(
                                            server: server,
                                            supportDomesticPing: group.type.supportDomesticPing,
                                            supportConnectionCount: group.type.supportConnectionCount, 
                                            supportProcessCount: group.type.supportProcessCount,
                                            supportIoRw: group.type.supportIoRw
                                        )
                                            .padding(largerScale ? 5 : 0)
                                            
                                            
                                    }
                                }
                            }
                            
                        }header: {
                            Text(group.label)
                                .font(.headline)
                                .foregroundStyle(plainFillTheme == "Dark" ? .black : .white)

                        }
                        if group.lastUpdated != 0{
                            HStack{
                                Spacer()
                                Text("上次更新：\(convertTimestampToDateString(timestamp: TimeInterval(group.lastUpdated)))")
                                    .font(.caption.monospaced())
                                    .foregroundColor(.white)
                                    .colorFillBackground(padding: 5)
                                    
                                    //.foregroundStyle(plainFillTheme == "Dark" ? .black : .white)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .offset(x: allowDepthEffectOfForeground ? motion.x * -40 : 0, y: allowDepthEffectOfForeground ? motion.y * -40 : 0)
                }
                .padding()
            }
            .navigationTitle("Server Monitor")
            .navigationBarTitleDisplayMode(.inline)
            
            .background{
                backgroundImage()
            }
        }
        .navigationViewStyle(.stack)
        
    }
    
    @AppStorage("BackgroundImageLink") var bgImgLink: String = ""
    @AppStorage("UseMaterial") var useMaterial: Bool = true
    @AppStorage("BackgroundImageRender") var bgImgRender = "Blur"
    @AppStorage("BackgroundImageBlurRadius") var bgImgBlurRadius = 10.0
    
    func backgroundImage() -> some View{
        Group{
            if let url = URL(string: bgImgLink){
                let image =
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    
                if bgImgRender == "Material"{
                    image.overlay{
                        Rectangle()
                            .foregroundStyle(.ultraThinMaterial)
                    }
                }else if bgImgRender == "Blur"{
                    image.blur(radius: bgImgBlurRadius)
                }else{
                    image
                }
            }else{
                let imgName = UIScreen.main.bounds.height > UIScreen.main.bounds.width
                ? "xuyu-chi-_6KrHEpZ0Ro-unsplash-small"
                : "erol-ahmed-d3pTF3r_hwY-unsplash"
                
                let image = Image(imgName)
                
                if bgImgRender == "Material"{
                    image.overlay{
                        Rectangle()
                            .foregroundStyle(.ultraThinMaterial)
                    }
                }else if bgImgRender == "Blur"{
                    image.blur(radius: bgImgBlurRadius)
                }else{
                    image
                }
            }
            
        }
        .animation(.easeInOut)
        .scaleEffect(allowDepthEffectOfBackground ? 1.2 : 1, anchor: .center)
        .offset(x: allowDepthEffectOfBackground ? motion.x * 40 : 0, y: allowDepthEffectOfBackground ? motion.y * 40 : 0)
        .ignoresSafeArea()
    }
    
    func convertTimestampToDateString(timestamp: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}


#Preview {
    @State var showSettings = false
    return MainPage(showSettings: $showSettings)
}
