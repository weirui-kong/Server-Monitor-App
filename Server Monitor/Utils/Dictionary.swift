//
//  String.swift
//  Server Monitor
//
//  Created by 孔维锐 on 12/31/23.
//
//  ref: https://www.jianshu.com/p/53b9c7fac281

import Foundation
extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
  var showJsonString: String {
        do {
            var dic: [String: Any] = [String: Any]()
            for (key, value) in self {
                dic["\(key)"] = value
            }
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)

            if let data = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as String? {
                return data
            } else {
                return "{}"
            }
        } catch {
            return "{}"
        }
    }
}
