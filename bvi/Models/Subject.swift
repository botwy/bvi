//
//  Subject.swift
//  bvi
//
//  Created by Елена Гончарова on 22.08.2023.
//

import Foundation

struct Subject {
    let code: String
    let title: String
    let olympiads: [Olympiad]
}


extension Subject {
    init?(olympiadsJson: [JSON.Olympiad]) {
        guard let first = olympiadsJson.first else {
            return nil
        }
        let olympiads = olympiadsJson.map {
            Olympiad(olympiadJson: $0)
        }
        self.init(code: first.subject.code, title: first.subject.title, olympiads: olympiads)
    }
}
