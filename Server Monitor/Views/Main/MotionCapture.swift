//
//  MotionCapture.swift
//  Server Monitor
//
//  Created by 孔维锐 on 10/18/23.
//

import Foundation
import CoreMotion
import SwiftUI
class MotionManager: ObservableObject {
    static let shared = MotionManager()
    let motionManager = CMMotionManager()
    @Published var x = 0.0
    @Published var y = 0.0
    @AppStorage("AllowDepthEffect") var allowDepthEffect: Bool = true
    
    init() {
        if allowDepthEffect{
            start()
        }
    }
    
    func start(){
        motionManager.deviceMotionUpdateInterval = 1 / 3.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in

            guard let motion = data?.attitude else { return }
            withAnimation(){
                switch getDeviceOrientation(){
                case .portrait:
                    self?.x = motion.roll
                    self?.y = motion.pitch
                case .portraitUpsideDown:
                    self?.x = -motion.roll
                    self?.y = -motion.pitch
                case .landscapeLeft:
                    self?.x = motion.pitch
                    self?.y = -motion.roll
                case .landscapeRight:
                    self?.x = -motion.pitch
                    self?.y = motion.roll
                default: break
                    
                }
            
                
            }
        }
    }
    
    func stop(){
        motionManager.stopDeviceMotionUpdates()
    }
}
