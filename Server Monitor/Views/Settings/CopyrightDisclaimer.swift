//
//  CopyrightDisclaimer.swift
//  Server Monitor
//
//  Created by 孔维锐 on 11/21/23.
//

import SwiftUI
import Kingfisher

struct CopyrightDisclaimer: View {
    
    var body: some View {
        List{
            Section{
                ForEach(builtinImgs, id: \.1){img in
                    NavigationLink(img.0, destination: builtinImageCPDetail(name: img.0, imgName: img.1, author: img.2, description: img.3, link: img.4))
                }
                
            }header: {
                Text("内建图片")
                    .headerProminence(.increased)
            }
            
            Section{
                ForEach(onlineImgs, id: \.1){img in
                    NavigationLink(img.1, destination: onlineImageCPDetail(name: img.1, url: img.2, description: img.3))
                }
                
            }header: {
                Text("在线图片")
                    .headerProminence(.increased)
            }
        }
    }
    
    func builtinImageCPDetail(name: String, imgName: String, author: String, description: String, link: String) -> some View{
        VStack(alignment: .leading){
            List{
                
                HStack{
                    Text("Name")
                    Spacer()
                    Text(imgName)
                }
                HStack{
                    Text("Auther")
                    Spacer()
                    Text(author)
                }
                HStack{
                    Text("Description")
                    Spacer()
                    Text(description)
                }
                HStack{
                    Text("Source")
                    Spacer()
                    Text(link)
                }
                Image(imgName)
                    .resizable()
                    .scaledToFit()
            }
            
        }.navigationTitle(name)
    }
    
    func onlineImageCPDetail(name: String, url: String, description: String) -> some View{
        List{
            Section{
                HStack{
                    Text("Name")
                    Spacer()
                    Text(name)
                }
                
                HStack{
                    Text("Description")
                    Spacer()
                    Text(description)
                }
                KFImage(URL(string: url)!)
                    .resizable()
                    .scaledToFit()
            }footer: {
                Text(onlineImgsTos)
            }
        }
    }
}

#Preview {
    NavigationView{
        CopyrightDisclaimer()
            .navigationTitle("Copyright Disclaimer")
    }
}
