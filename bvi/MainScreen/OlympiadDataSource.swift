//
//  OlympiadDataSource.swift
//  bvi
//
//  Created by Елена Гончарова on 05.08.2023.
//

import Foundation

class OlympiadDataSource {
    private var data: [Subject] = []
    
    var groupsCount: Int {
        return data.count
    }
    
    func getItemsCount(section: Int) -> Int {
        return data[section].olympiads.count
    }
    
    func getGroup(section: Int) -> Subject {
        return data[section]
    }
    
    func getItem(for indexPath: IndexPath) -> Olympiad {
        return data[indexPath.section].olympiads[indexPath.row]
    }
    
    
    func fetchData(completion: @escaping () -> Void) {
        let rest = Rest()
        guard let configUrl = URL(string: "https://raw.githubusercontent.com/botwy/bvi-config/main/server.json") else {
            return
        }
        rest.get(url: configUrl) { (config: JSON.Config) in
            guard let url = URL(string: "\(config.olympiadsUrl)") else {
                return
            }
            rest.get(url: url) { [weak self] (olympiadsRs: JSON.OlympiadsRs) in
                self?.process(olympiadsRs: olympiadsRs)
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    private func process(olympiadsRs: JSON.OlympiadsRs) {
        let sortedOlympiads =  olympiadsRs.olympiads.sorted { $0.name < $1.name }
        let subjects = sortedOlympiads.map { $0.subject.code }
        let groups = Set(subjects)
            .compactMap { subject in
                let filteredOlympiads = sortedOlympiads.filter{ $0.subject.code == subject }
                return Subject(olympiadsJson: filteredOlympiads)
            }
            .sorted { $0.title < $1.title}
        
        DispatchQueue.main.async {
            self.data = groups
        }
        
    }
}
