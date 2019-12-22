//
//  NetworkDataFetcher.swift
//  FlickrClient
//
//  Created by Tyts on 16.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import Foundation

class NetworkDataFetcher {

    private let networkService: NetworkService 
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchImages(searchTerm: String, latitude: Float? = nil, longitude: Float? = nil, page: Int?, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(searchTerm: searchTerm, latitude: latitude, longitude: longitude, page: page) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }

            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }

    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }

        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }


}
