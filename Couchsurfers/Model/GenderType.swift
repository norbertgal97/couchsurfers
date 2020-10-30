//
//  GenderType.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 30..
//

import Foundation

enum GenderType: String, CaseIterable {
    case not_specified = "notSpecified"
    case male = "male"
    case female = "female"
    case other = "other"
    
    func ordinal() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
    
    func localizedString() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
    }
}
