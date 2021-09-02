//
//  StorageService.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import Foundation

protocol StorageServiceType {
    
    func getFavorites() -> [String: String]
    func saveFavorite(breed: String, url: String)
    func removeFavorite(url: String)
    
}

class StorageService: StorageServiceType {
    
    private let userDefaultsKey = "Favorites"
    
    func saveFavorite(breed: String, url: String) {
        if var favorites = UserDefaults.standard.value(forKey: userDefaultsKey) as? [String: String] {
            favorites[url] = breed
            UserDefaults.standard.set(favorites, forKey: userDefaultsKey)
        } else {
            let favorites = [url: breed]
            UserDefaults.standard.set(favorites, forKey: userDefaultsKey)
        }
    }
    
    func removeFavorite(url: String) {
        if var favorites = UserDefaults.standard.value(forKey: userDefaultsKey) as? [String: String] {
            favorites.removeValue(forKey: url)
            UserDefaults.standard.set(favorites, forKey: userDefaultsKey)
        }
    }

    func getFavorites() -> [String: String] {
        return UserDefaults.standard.value(forKey: userDefaultsKey) as? [String: String] ?? [:]
    }
    
}
