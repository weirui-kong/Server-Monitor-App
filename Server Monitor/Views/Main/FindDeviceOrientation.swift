//
//  FindDeviceOrientation.swift
//  Server Monitor
//
//  Created by 孔维锐 on 10/18/23.
//


//
//  FindDeviceOrientation.swift
//  Starter Project
//
//  Created by Oscar de la Hera Gomez on 2/10/23.
//
import Foundation
import UIKit

func getDeviceOrientation() -> UIDeviceOrientation {
    let identifier: String = "getDeviceOrientation"
    var orientation = UIDevice.current.orientation
    // Get the interface orientation incase the UIDevice Orientation doesn't exist.
    let interfaceOrientation: UIInterfaceOrientation?
    if #available(iOS 15, *) {
        interfaceOrientation = UIApplication.shared.connectedScenes
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.interfaceOrientation
    } else {
        interfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
    guard interfaceOrientation != nil else {
        return orientation
    }

    // Initially the orientation is unknown so we need to check based on the application window orientation.
    if !orientation.isValidInterfaceOrientation {
        // Notice that UIDeviceOrientation.landscapeRight is assigned to UIInterfaceOrientation.landscapeLeft and UIDeviceOrientation.landscapeLeft is assigned to UIInterfaceOrientation.landscapeRight. The reason for this is that rotating the device requires rotating the content in the opposite direction.
        // Reference : https://developer.apple.com/documentation/uikit/uiinterfaceorientation
        switch interfaceOrientation {
        case .portrait:
            orientation = .portrait
            break
        case .landscapeRight:
            orientation = .landscapeLeft
            break
        case .landscapeLeft:
            orientation = .landscapeRight
            break
        case .portraitUpsideDown:
            orientation = .portraitUpsideDown
            break
        default:
            orientation = .unknown
            break
        }
    }

    return orientation
}
