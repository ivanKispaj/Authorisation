//
//  File.swift
//  
//
//  Created by Ivan Konishchev on 14.12.2022.
//

import Foundation

import Foundation

internal extension String {
    
    func encodeBase64() -> String {
        guard let encoding = data(using: .utf8)?.base64EncodedString() else { return self }
        return encoding
    }
    
    func decodeBase64() -> String {
        guard let data = Data(base64Encoded: self) else { return self }
        guard let ret = String(data: data, encoding: .utf8) else { return self }
                return ret
    }
}
