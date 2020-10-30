//
//  CustomError.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 30..
//

import Foundation

public struct CustomError: Error {
    let msg: String
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(msg, comment: "")
    }
}
