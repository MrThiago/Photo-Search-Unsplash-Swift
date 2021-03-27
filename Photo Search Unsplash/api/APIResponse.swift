//
//  APIResponse.swift
//  Photo Search Unsplash
//
//  Created by Thiago Gouvea on 27/03/2021.
//

import Foundation
import UIKit

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let description: String?
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let regular: String
    let thumb: String
}
