//
//  Level.swift
//  bvi
//
//  Created by Елена Гончарова on 23.08.2023.
//

import UIKit

enum Level: Int {
    case unknown = 0, first = 1, second, third
    
    var title: String {
        self == .unknown ? "" : "\(self.rawValue) уровень"
    }
    
    var color: UIColor {
        switch self {
        case .first: return .systemGreen
      //  case .second: return UIColor(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        case .second: return .systemBlue
        case .third: return .systemOrange
        case .unknown: return .clear
        }
    }
}
