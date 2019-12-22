//
//  NetworkService.swift
//  FlickrClient
//
//  Created by Tyts on 16.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import Foundation

class NetworkService {
    
    private let apiKey:String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }

//    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void)  {
//
//        let parameters = self.prepareParaments(searchTerm: searchTerm)
//        let url = self.url(params: parameters)
//        var request = URLRequest(url: url)
//        request.httpMethod = "get"
//        let task = createDataTask(from: request, completion: completion)
//        task.resume()
//    }
    
    func request(searchTerm: String, latitude: Float? = nil, longitude: Float? = nil, page: Int?, completion: @escaping (Data?, Error?) -> Void)  {
        
        let parameters = self.prepareParaments(searchTerm: searchTerm, latitude: latitude, longitude: longitude, radius: 5, page: page)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        print(url)
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareParaments(searchTerm: String?, latitude: Float? = nil, longitude: Float? = nil, radius: Int? = nil, page: Int? = 1) -> [String: String] {
        var parameters = [String: String]()
        parameters["method"] = "flickr.photos.search"
        parameters["format"] = "json"
        parameters["nojsoncallback"] = "1"
        parameters["format"] = "json"
        parameters["api_key"] = apiKey
        
        parameters["text"] = searchTerm
        
        if let latitude = latitude, let longitude = longitude, let radius = radius {
            parameters["lat"] = String(latitude)
            parameters["lon"] = String(longitude)
            parameters["radius"] = String(radius)
        }

        parameters["per_page"] = String(20)
        parameters["page"] = String(page ?? 1)
        
        
        return parameters
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "flickr.com"
        components.path = "/services/rest/"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }

    private func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
}
