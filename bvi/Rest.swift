//
//  Fetch.swift
//  bvi
//
//  Created by Елена Гончарова on 05.08.2023.
//

import Foundation

class Rest {
    enum Method: String {
        case GET
        case POST
    }
    
    private let session = URLSession(configuration: .default)
    
    func fetch<Rs: Decodable>(url: URL, method: Method = .GET, bodyRq: Data?, completion: @escaping (Rs) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = bodyRq
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let bodyRs = try decoder.decode(Rs.self, from: data)
                completion(bodyRs)
            } catch {
                debugPrint(error as NSError)
                return
            }
        }
        
        dataTask.resume()
    }
    
    func get<Rs: Decodable>(url: URL, completion: @escaping (Rs) -> Void) {
        fetch(url: url, bodyRq: nil, completion: completion)
    }
    
    func post<Rq: Encodable, Rs: Decodable>(url: URL, bodyRq: Rq, completion: @escaping (Rs) -> Void) {
        var data: Data? = nil
        let encoder = JSONEncoder()
        do {
            data = try encoder.encode(bodyRq)
        } catch {
            debugPrint(error as NSError)
            return
        }
        fetch(url: url, method: .POST, bodyRq: data, completion: completion)
    }
}
