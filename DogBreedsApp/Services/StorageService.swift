//
//  StorageService.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import Foundation

protocol StorageServiceType {
    
    func getFavorites() -> [String]
    
}

class StorageService: StorageServiceType {

    func getFavorites() -> [String] {
        []
    }
    
}
