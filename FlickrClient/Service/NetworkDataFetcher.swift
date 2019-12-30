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

//    func fetchImages(searchTerm: String, latitude: Float? = nil, longitude: Float? = nil, page: Int?, completion: @escaping (SearchResults?) -> Void) {
//        networkService.request(searchTerm: searchTerm, latitude: latitude, longitude: longitude, page: page) { (SearchResults) in
////            if let error = error {
////                print("Error received requesting data: \(error.localizedDescription)")
////                completion(nil)
////            }
//
//            completion(data)
//        }
//    }



}
