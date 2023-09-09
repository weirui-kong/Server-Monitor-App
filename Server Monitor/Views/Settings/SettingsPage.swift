//
//  SettingsPage.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import SwiftUI
import CoreData
struct SettingsPage: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @AppStorage("BackgroundImageLink") var bgImgLink: String = "https://api.dujin.org/bing/1920.php"
    @AppStorage("BackgroundUseMaterial") var bgUseMaterial: Bool = true
    @AppStorage("ShowServerCount") var showServerCount = true
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    HStack{
                        Text("图床地址")
                        Spacer(minLength: 50)
                        TextField("图床地址", text: $bgImgLink, prompt: Text("图床地址"))
                    }
                    Toggle("使用 Material", isOn: $bgUseMaterial)
                    Toggle("显示 Badge", isOn: $showServerCount)
                }header: {
                    Text("首页")
                        .headerProminence(.increased)
                }
                
                Section{
                    NavigationLink(isActive: $isAdding, destination: addMonitor, label:{ Text("添加探针")})
                }header: {
                    Text("探针")
                        .headerProminence(.increased)
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    @State var selectedType_raw = "HOTARU"
    @State var showAfterAdd = true
    @State var label = ""
    @State var apiPath = "https://"
    @State var isAdding = false
    func addMonitor() -> some View{
        List{
            Section{
                HStack{
                    Text("探针类型")
                    Spacer()
                    Menu(selectedType_raw) {
                        ForEach(MonitorType.allCases, id: \.rawValue){type in
                            Button(type.rawValue){selectedType_raw = type.rawValue}
                        }
                        Button("更多服务接入中"){}
                    }
                }
                Toggle("主页显示", isOn: $showAfterAdd)
                HStack{
                    Text("别名")
                    Spacer(minLength: 50)
                    TextField("别名", text: $label, prompt: Text("未命名"))
                        .multilineTextAlignment(.trailing)
                }
                VStack(alignment: .leading){
                    Text("API地址")
                    TextEditor(text: $apiPath)
                        .multilineTextAlignment(.leading)
                        .frame(height: 100)
                }
            }
            
            Button("添加"){
                let monitor = Monitor(context: self.viewContext)
                monitor.label = self.label == "" ? "未命名" : self.label
                monitor.path = self.apiPath
                monitor.type_raw = self.selectedType_raw
                monitor.show = self.showAfterAdd
                do {
                    try self.viewContext.save()
                } catch {
                    print("whoops \(error.localizedDescription)")
                }
                isAdding = false
            }
        }
        .navigationTitle("添加探针")
        .onDisappear{
            showAfterAdd = true
            label = ""
            apiPath = "https://"
        }
    }
}

#Preview {
    let container = NSPersistentContainer(name: "MonitorConfigs")
    container.loadPersistentStores { description, error in
        if let error = error {
            fatalError("Unable to load persistent stores: \(error)")
        }
    }
    return SettingsPage()
        .environment(\.managedObjectContext, container.viewContext)
}
