//
//  APIManager.swift
//  AnjaliDeokateTask
//
//  Created by Anjali on 27/11/24.
//

import Foundation
import Combine

protocol CryptoService : AnyObject {
    func getCryptoList() -> AnyPublisher<[Crypto], Error>
}

class APIManager: CryptoService {
    private let cryptoListEndpoint = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
    
    static let shared = APIManager()
    
    private init() {}
    
    func getCryptoList() -> AnyPublisher<[Crypto], Error> {
        var dataTask: URLSessionDataTask?
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        guard !ProcessInfo.processInfo.arguments.contains("UITesting") else {
            return mockGetCryptoList()
        }
        
        return Future<[Crypto], Error> { [weak self] promise in
            guard let self,
                  let url = URL(string: cryptoListEndpoint) else {
                promise(.failure(NSError(domain: "API", code: 404)))
                return
            }
            
            let urlRequest =  URLRequest(url: url)
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode([Crypto].self, from: data)
                    promise(.success(decodedResponse))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func mockGetCryptoList() -> AnyPublisher<[Crypto], Error> {
        
        if let path = Bundle.main.path(forResource: "MockResponse", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let decodedResponse = try JSONDecoder().decode([Crypto].self, from: data)
                return Just(decodedResponse)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch let error {
                print("Parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
