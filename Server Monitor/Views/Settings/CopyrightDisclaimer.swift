//
//  CopyrightDisclaimer.swift
//  Server Monitor
//
//  Created by 孔维锐 on 11/21/23.
//

import SwiftUI

struct CopyrightDisclaimer: View {
    
    var body: some View {
        List{
            Section{
                ForEach(imgs, id: \.1){img in
                    NavigationLink(img.0, destination: imageCPDetail(name: img.0, imgName: img.1, author: img.2, description: img.3, link: img.4))
                }
                
            }header: {
                Text("图片")
                    .headerProminence(.increased)
            }
        }
    }
    
    func imageCPDetail(name:String, imgName: String, author: String, description: String, link: String) -> some View{
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
    
}

#Preview {
    NavigationView{
        CopyrightDisclaimer()
            .navigationTitle("Copyright Disclaimer")
    }
}
