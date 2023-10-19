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
    
    @AppStorage("ShowServerCount") var showServerCount = true
    
    @AppStorage("UseMaterial") var useMaterial: Bool = true
    @AppStorage("LargerScale") var largerScale = false
    @AppStorage("PlainFillTheme") var plainFillTheme = "Dark"
    let plainFillThemes = ["Light", "Dark"]
    
    
    @AppStorage("BackgroundImageLink") var bgImgLink: String = "https://api.dujin.org/bing/1920.php"
    @AppStorage("BackgroundImageRender") var bgImgRender = "Blur"
    @AppStorage("BackgroundImageBlurRadius") var bgImgBlurRadius = 10.0
    @AppStorage("AllowDepthEffect") var allowDepthEffect: Bool = false{
        didSet{
            if allowDepthEffect{
                MotionManager.shared.start()
            }else{
                MotionManager.shared.stop()
            }
        }
    }
    
    let imagePresentMethods = ["Plain", "Blur", "Material"]
    
    @Binding var showSettingsPage: Bool
    var body: some View {
        NavigationView{
            List{
                Section{
                    Toggle("显示 Badge", isOn: $showServerCount)
                }header: {
                    Text("首页")
                        .headerProminence(.increased)
                }
                
                Section{
                    Toggle("使用 Material", isOn: $useMaterial)
                    
                        HStack{
                            if !useMaterial{
                                Picker("颜色主题", selection: $plainFillTheme) {
                                    ForEach(plainFillThemes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                //.pickerStyle(.segmented)
                            } else{
                                Picker("颜色主题", selection: .constant("Auto")) {
                                    ForEach(["Auto"], id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                        }
                    
                    Toggle("更大视图", isOn: $largerScale)

                }header: {
                    Text("组件")
                        .headerProminence(.increased)
                }footer: {
                    Text("开启 Material 在较旧的机器上可能导致性能下降。更大视图适用于 Mac 上缩放过小的情况。")
                }
                
                Section{
                    HStack{
                        Text("图床地址")
                        Spacer(minLength: 50)
                        TextField("图床地址", text: $bgImgLink, prompt: Text("图床地址"))
                    }
                    Picker("ImagePresentMethod", selection: $bgImgRender) {
                        ForEach(imagePresentMethods, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if bgImgRender == "Blur"{
                        HStack{
                            Text("模糊度: \(String(format: "%.1f", bgImgBlurRadius))")
                            Slider(value: $bgImgBlurRadius, in: 2...20)
                        }
                    }
                    
                    Toggle("深度效果", isOn: $allowDepthEffect)
                    
                    HStack {
                        Spacer()
                        Button("重设"){
                            resetSettingsBackgroundSection()
                        }.tint(.red)
                        Spacer()
                    }
                    
                    
                }header: {
                    Text("背景 & 呈现方式")
                        .headerProminence(.increased)
                }footer: {
                    Text("Material 对性能要求较高，请酌情使用。")
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
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Close", systemImage: "xmark", action: {showSettingsPage.toggle()})
                }
            }
        }
    }
    func resetSettingsBackgroundSection(){
        self.bgImgLink = "https://api.dujin.org/bing/1920.php"
        self.bgImgRender = "Blur"
        self.bgImgBlurRadius = 10.0
        self.allowDepthEffect = true
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
    return SettingsPage(showSettingsPage: .constant(true))
        .environment(\.managedObjectContext, container.viewContext)
}

