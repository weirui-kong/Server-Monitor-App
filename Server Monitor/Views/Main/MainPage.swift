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
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var serverProvider = ServerProvider.shared
    
    @AppStorage("BackgroundImageLink") var bgImgLink: String = "https://api.dujin.org/bing/1920.php"
    @AppStorage("BackgroundUseMaterial") var bgUseMaterial: Bool = true
    var body: some View {
        NavigationView{
            ScrollView{
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
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 280, maximum: 400))]){
                                    
                                    ForEach(group.server, id: \.name){server in
                                        ServerCardView(server: server)
                                    }
                                }
                            }
                            
                        }header: {
                            Text(group.label)
                                .font(.headline)
                        }
                        if group.lastUpdated != 0{
                            HStack{
                                Spacer()
                                Text("上次更新：\(convertTimestampToDateString(timestamp: TimeInterval(group.lastUpdated)))")
                                    .font(.caption.monospaced())
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding()
            }
            .navigationTitle("Server Monitor")
            .navigationBarTitleDisplayMode(.inline)
            
            .background{
                ZStack{
                    if let url = URL(string: bgImgLink){
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .overlay{
                                if bgUseMaterial{
                                    Rectangle()
                                        .foregroundStyle(.ultraThinMaterial)
                                        .ignoresSafeArea()
                                }
                                
                            }
                            .animation(.easeInOut)
                    }
                    
                }
            }
        }
        .navigationViewStyle(.stack)
        
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
