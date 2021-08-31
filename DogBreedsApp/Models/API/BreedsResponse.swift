//
//  BreedsResponse.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import Foundation

struct BreedsDynamicKeysResponse: Codable {
    let message: [String: [String]]
    let status: String
}

struct BreedsResponse: Codable {
    let message: [String]
    let status: String
}

