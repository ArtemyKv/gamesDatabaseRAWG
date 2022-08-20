//
//  QueryService.swift
//  rawgGamesSearch
//
//  Created by Artem Kvashnin on 16.08.2022.
//

import Foundation
import UIKit

class QueryService {
    let defaultSession = URLSession(configuration: .default)
    
    private var sessionDataTask: URLSessionDataTask?
    
    private var imageDownloadingTasks: [IndexPath: URLSessionDataTask] = [:]
    
    private var games: [Game] = []
    
    private let cachedImages = NSCache<NSString, UIImage>()
    
    private func cachedImage(for urlString: NSString) -> UIImage? {
        return cachedImages.object(forKey: urlString)
    }
    
    func getSearchResults(searchTerm: String, completion: @escaping ([Game]?) -> Void) {
        var urlComponents = URLComponents(string: "https://api.rawg.io/api/games")!
        let queryDict = [
            "key": "2aac9729c54546fd84ec55edacfca66c",
            "search": searchTerm,
            "page_size": "100",
//            "search_precise": "false",
//            "search_exact": "false",
            "ordering": "-metacritic"
        ]
        urlComponents.queryItems = queryDict.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else { return }
        
        sessionDataTask = nil
        imageDownloadingTasks.values.forEach { $0.cancel() }
        imageDownloadingTasks = [:]
        
        
        sessionDataTask = defaultSession.dataTask(with: url, completionHandler: { data, response, error in
            
            defer {
                self.sessionDataTask = nil
            }
            
            if let error = error {
                self.handleClientError(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to fetch data from server")
                return
            }
            
            guard let data = data else { return }

            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let searchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                self.games = searchResults.results
                print("hello!")
                DispatchQueue.main.async {
                    completion(self.games)
                }
            } catch let error {
                print("Error \(error), \(error.localizedDescription)")
            }
        })
        sessionDataTask?.resume()
    }
    
    func fetchImage(for game: Game, at indexPath: IndexPath, completion: @escaping (Game, UIImage?) -> Void) {
        guard let imageUrl = game.imageURL else { return }
        //Check for cached image and call completion on main queue if image exists
        let cacheID = NSString(string: imageUrl.absoluteString)
        if let cachedImage = cachedImage(for: cacheID) {
            DispatchQueue.main.async {
                completion(game, cachedImage)
            }
            return
        }
        
        imageDownloadingTasks[indexPath] = nil
        imageDownloadingTasks[indexPath] = defaultSession.dataTask(with: imageUrl, completionHandler: { [weak self] data, response, error in
            defer {
                self?.imageDownloadingTasks[indexPath] = nil
            }
            
            if let error = error {
                print("Image Fetching Error\n \(error), \(error.localizedDescription)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Server error loading image")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                self?.cachedImages.setObject(image, forKey: cacheID)
                DispatchQueue.main.async {
                    completion(game, image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(game, nil)
                }
            }
        })
        imageDownloadingTasks[indexPath]?.resume()
    }
        
    private func handleClientError(_ error: Error) {
        print("Fetching failed, Client error: \(error), \(error.localizedDescription)")
    }
    
}
