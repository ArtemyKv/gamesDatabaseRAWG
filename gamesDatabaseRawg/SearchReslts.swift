//
//  SearchReslts.swift
//  rawgGamesSearch
//
//  Created by Artem Kvashnin on 16.08.2022.
//

import Foundation

struct SearchResults: Codable {
    var count: Double
    var results: [Game]
}
