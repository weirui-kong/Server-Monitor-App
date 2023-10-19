//
//  RoundedBackground.swift
//  Server Monitor
//
//  Created by 孔维锐 on 9/21/23.
//

import SwiftUI

struct SemitransparentLayer: View {
    @AppStorage("UseMaterial") var bgUseMaterial: Bool = true
    var forceUseColorFill = false
    var cornerRadius: CGFloat
    var overrideColor: Color?
    var body: some View {
        Group{
            if bgUseMaterial && !forceUseColorFill{
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(.ultraThinMaterial)
            }else{
                if let color = overrideColor{
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundStyle(color.opacity(0.25))
                }else{
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundStyle(.black.opacity(0.25))
                }
                
            }
        }
    }
}

extension View{
    func materialBackground(padding: CGFloat = 0, cornerRadius: CGFloat = 10, opacity: Double = 1, overrideColor: Color? = nil) -> some View{
        return self.padding(padding).background(SemitransparentLayer(cornerRadius: cornerRadius, overrideColor: overrideColor).opacity(opacity))
    }
    func materialOverlay(padding: CGFloat = 0, cornerRadius: Double = 10, opacity: Double = 1, overrideColor: Color? = nil) -> some View{
        return self.padding(padding).overlay(SemitransparentLayer(cornerRadius: cornerRadius, overrideColor: overrideColor).opacity(opacity))
    }
    func colorFillBackground(padding: CGFloat = 0, cornerRadius: CGFloat = 10, opacity: Double = 1, overrideColor: Color? = nil) -> some View{
        return self.padding(padding).background(SemitransparentLayer(forceUseColorFill: true, cornerRadius: cornerRadius, overrideColor: overrideColor).opacity(opacity))
    }
    func colorFillOverlay(padding: CGFloat = 0, cornerRadius: Double = 10, opacity: Double = 1, overrideColor: Color? = nil) -> some View{
        return self.padding(padding).overlay(SemitransparentLayer(forceUseColorFill: true, cornerRadius: cornerRadius, overrideColor: overrideColor).opacity(opacity))
    }
}
