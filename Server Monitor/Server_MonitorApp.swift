//
//  Server_MonitorApp.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/8/23.
//

import SwiftUI
import CoreData

@main
struct Server_MonitorApp: App {
    @AppStorage("AlwaysOnDisplay") var alwaysOnDisplay = true
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {applyDefaultSettings()})
        }
    }
    func applyDefaultSettings(){
        UIApplication.shared.isIdleTimerDisabled = alwaysOnDisplay
    }
}


let builtinImgs = [
    ("Catalina", "robert-palmer-apcVUAd_o9M-unsplash", "Robert Palmer (@honestcode)", "city near seashore under orange and yellow cloudy sky", "https://unsplash.com/photos/city-near-seashore-under-orange-and-yellow-cloudy-sky-apcVUAd_o9M"),
    ("Catalina", "xuyu-chi-_6KrHEpZ0Ro-unsplash-small", "Xuyu Chi (@xccc)", "a sailboat and a small boat in the ocean", "https://unsplash.com/photos/a-sailboat-and-a-small-boat-in-the-ocean-_6KrHEpZ0Ro"),
    ("Switzerland Snow", "erol-ahmed-d3pTF3r_hwY-unsplash", "Erol Ahmed (@erol)", "mountains covered with snow", "https://unsplash.com/photos/mountains-covered-with-snow-d3pTF3r_hwY")
]

let onlineImgs = [
    ("CM", "China Mobile", "https://download.logo.wine/logo/China_Mobile/China_Mobile-Logo.wine.png", "图片来自于logo.wine网站"),
    ("CT", "China Telecom", "https://download.logo.wine/logo/China_Telecom/China_Telecom-Logo.wine.png", "图片来自于logo.wine网站"),
    ("CU", "China Unicom", "https://download.logo.wine/logo/China_Unicom/China_Unicom-Logo.wine.png", "图片来自于logo.wine网站")
]

func onlineImgLink(searchBy: String) -> String? {
    let imgLink = onlineImgs.first { $0.0 == searchBy }?.2
    return imgLink
}

let onlineImgsTos = """
感谢您使用Server Monitor Mobile并考虑展示在线获取的图片。在使用该功能之前，请仔细阅读以下免责声明。

用户责任：展示在线获取的图片完全由用户自行选择，并承担相应的责任。用户必须确保展示的图片内容合法，不侵犯他人的权益，包括但不限于版权、商标权、隐私权等。用户需要自行了解并遵守适用的法律法规，以确保展示图片的合法性。

内容来源：我们的应用程序提供了在线获取图片的功能，但我们无法对所获取的图片的来源进行全面监控和审核。这些图片可能来自于各种互联网资源，包括公开的图片库、社交媒体平台等。因此，我们无法对图片的准确性、合法性、完整性或品质进行保证。

法律责任：我们不承担因用户展示在线获取的图片而产生的任何法律责任。如果用户选择展示图片，并且违反了任何相关法律法规或侵犯了他人的权益，用户将独立承担相应的法律责任，包括可能的侵权索赔、罚款等。

安全风险：展示在线获取的图片存在一定的安全风险，包括但不限于恶意软件、病毒、不良内容等。尽管我们采取了合理的安全措施，但我们无法完全消除这些风险。用户应自行采取适当的安全措施，确保其设备和数据的安全。

修改和更新：我们保留随时修改或更新该免责声明的权利。任何修改或更新将在我们的应用程序中发布，并自发布之日起生效。用户在继续使用应用程序之前应定期查看免责声明的变更。

请您在使用应用程序的展示功能之前，仔细阅读并理解以上免责声明。通过启用展示功能，您将被视为已经接受并同意自行承担相关的责任和风险。如您有任何疑问或需要进一步的法律意见，请咨询专业律师。
"""
