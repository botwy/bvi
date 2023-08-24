//
//  Olympiad.swift
//  bvi
//
//  Created by Елена Гончарова on 07.08.2023.
//

import Foundation

struct Olympiad {
    let id: String
    let name: String
    let level: Level
    let description: String
    let links: [Link]?
}

extension Olympiad {
    init(olympiadJson: JSON.Olympiad) {
        self.init(
            id: olympiadJson.id,
            name: olympiadJson.name,
            level: Level(rawValue: olympiadJson.level) ?? .unknown,
            description: olympiadJson.description,
            links: olympiadJson.links
        )
    }
}
