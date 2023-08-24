//
//  Level.swift
//  bvi
//
//  Created by Елена Гончарова on 23.08.2023.
//

import UIKit

enum Level: Int {
    case unknown = -1, vsosh = 0, first = 1, second, third
    
    var title: String {
        if self == .unknown {
            return ""
        }
        return self == .vsosh ? "всош" : "\(self.rawValue) уровень"
    }
    
    var color: UIColor {
        switch self {
        case .vsosh: return .systemGreen
        case .first: return .systemBlue
        case .second: return .systemOrange
        case .third: return .systemBrown
        case .unknown: return .clear
        }
    }
}
