//
//  Json.swift
//  bvi
//
//  Created by Елена Гончарова on 05.08.2023.
//

import Foundation

struct JSON {
    
}

extension JSON {
    struct Config: Codable {
        let host: String
        let olympiadsUrl: String
    }
    
    struct Subject: Codable {
        let code: String
        let title: String
    }
    
    struct Olympiad: Codable {
        let id: String
        let subject: JSON.Subject
        let name: String
        let level: Int
        let description: String
        let links: [Link]?
    }
    
    struct OlympiadsRs: Codable {
        let olympiads: [JSON.Olympiad]
    }
}
