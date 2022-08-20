//
//  Game.swift
//  rawgGamesSearch
//
//  Created by Artem Kvashnin on 16.08.2022.
//

import Foundation
import UIKit

struct Game: Codable {
    var name: String
    var rating: Double?
    var releaseDate: Date?
    var imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case name
        case rating = "metacritic"
        case releaseDate = "released"
        case imageURL = "background_image"
        
    }
}


