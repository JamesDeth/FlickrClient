//
//  NetworkService.swift
//  FlickrClient
//
//  Created by Tyts on 16.12.2019.
//  Copyright © 2019 Tyts&Co. All rights reserved.
//

import Foundation

class NetworkService {

    private let LOCATION_RADIUS = 5
    private let apiKey:String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchImages(searchTerm: String, latitude: Float? = nil, longitude: Float? = nil, page: Int?, completion: @escaping (_ flickrResults: FlickrResults?, _ photos: [Photo]?) -> Void)  {
        let parameters = self.prepareParaments(searchTerm: searchTerm, latitude: latitude, longitude: longitude, radius: LOCATION_RADIUS, page: page)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        print(url)
        request.httpMethod = "get"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            
            guard let _ = response as? HTTPURLResponse, let data = data, let flickrResults = self.decodeJSON(type: FlickrResults.self, from: data) else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            
            var photos:[Photo] = []
            flickrResults.photos.photo.forEach {
                flickrPhoto in
                let photo = Photo(flickrPhoto: flickrPhoto)
                let url = photo.url(size: Photo.thumbnailSize)
                if let img = photo.loadImage(by: url) {
                    photo.thumbnail = img
                    photos.append(photo)
                }
            }
            
            DispatchQueue.main.async {
                completion(flickrResults, photos)
            }
        }.resume()
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
