//
//  ContentView.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import SwiftUI
import CoreData
struct ContentView: View {
    @State var showSettings = false
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var serverProvider = ServerProvider.shared
    
    @AppStorage("ShowServerCount") var showServerCount = true
    
    var body: some View {
        ZStack{
            MainPage(showSettings: $showSettings)
                .environment(\.managedObjectContext, viewContext)
                .sheet(isPresented: $showSettings){
                    SettingsPage(showSettingsPage: $showSettings)
                        .environment(\.managedObjectContext, viewContext)
                    
                }
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    addButton()
                        .padding()
                }
            }
        }
        
    }
    
    func addButton() -> some View{
        Button{
            withAnimation(){
                showSettings.toggle()
            }
        }label: {
            Image(systemName: "gear")
                .font(.system(size: 35))
                .padding()
                .background{
                    Circle()
                        .shadow(radius: 5)
                        .foregroundStyle(.ultraThinMaterial)
                }
                .overlay{
                    if serverProvider.serverCount != 0 && showServerCount{
                        Text("\(serverProvider.serverCount)")
                            .font(.callout)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .background(Capsule().fill(.red))
                            .offset(x: 22, y: -22)
                            .opacity(0.9)
                    }
                }
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
    return ContentView()
        .environment(\.managedObjectContext, container.viewContext)
}
