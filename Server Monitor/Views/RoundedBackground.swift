//
//  RoundedBackground.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/21/23.
//

import SwiftUI

struct SemitransparentLayer: View {
    @AppStorage("BackgroundUseMaterial") var bgUseMaterial: Bool = true
    var forceUseColorFill = false
    var cornerRadius: CGFloat
    var body: some View {
        Group{
            if bgUseMaterial && !forceUseColorFill{
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(.ultraThinMaterial)
            }else{
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(.white.opacity(0.3))
            }
        }
    }
}

extension View{
    func materialBackground(padding: CGFloat = 0, cornerRadius: CGFloat = 10, opacity: Double = 1) -> some View{
        return self.padding(padding).background(SemitransparentLayer(cornerRadius: cornerRadius).opacity(opacity))
    }
    func materialOverlay(padding: CGFloat = 0, cornerRadius: Double = 10, opacity: Double = 1) -> some View{
        return self.padding(padding).overlay(SemitransparentLayer(cornerRadius: cornerRadius).opacity(opacity))
    }
    func colorFillBackground(padding: CGFloat = 0, cornerRadius: CGFloat = 10, opacity: Double = 1) -> some View{
        return self.padding(padding).background(SemitransparentLayer(forceUseColorFill: true, cornerRadius: cornerRadius).opacity(opacity))
    }
    func colorFillOverlay(padding: CGFloat = 0, cornerRadius: Double = 10, opacity: Double = 1) -> some View{
        return self.padding(padding).overlay(SemitransparentLayer(forceUseColorFill: true, cornerRadius: cornerRadius).opacity(opacity))
    }
}
