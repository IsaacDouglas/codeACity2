//
//  URLSession.swift
//  codeACity2
//
//  Created by Isaac Douglas on 13/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import Foundation

extension URLSession {
    func get<T: Codable>(_ url: String, onErron: @escaping ((Error) -> ()), onSucess: @escaping (T) -> ()) {
        let _url = URL(string: url)!
        let session = URLSession.shared
        var request = URLRequest(url: _url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { (data, request, error) in
            if error != nil {
                DispatchQueue.main.async {
                    onErron(error!)
                }
            } else {
                guard let data = data else { return }
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else { return }
                DispatchQueue.main.async {
                    onSucess(decodedData)
                }
            }
            }.resume()
    }
    
    func post<T: Codable, U: Codable>(_ url: String, body: T, onErron: @escaping ((Error) -> ()), onSucess: @escaping (U) -> ()) {
        let _url = URL(string: url)!
        let session = URLSession.shared
        var request = URLRequest(url: _url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body.self)
        
        session.dataTask(with: request) { (data, request, error) in
            if error != nil {
                DispatchQueue.main.async {
                    onErron(error!)
                }
            } else {
                guard let data = data else { return }
                guard let decodedData = try? JSONDecoder().decode(U.self, from: data) else { return }
                DispatchQueue.main.async {
                    onSucess(decodedData)
                }
            }
            }.resume()
    }
}
