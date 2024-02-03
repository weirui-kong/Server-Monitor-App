//
//  RandomSomething.swift
//  Server Monitor
//
//  Created by 孔维锐 on 2/3/24.
//

import Foundation

func randomEmoji() -> String {
    let base: UInt32 = 0x1F300
    let range: UInt32 = 79
    let randomScalar = base + arc4random_uniform(range)
    if let emoji = UnicodeScalar(randomScalar)?.description {
        return emoji
    } else {
        return ""
    }
}
