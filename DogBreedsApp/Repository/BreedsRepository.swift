//
//  BreedsRepository.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import Foundation
import RxSwift
import Combine

protocol BreedsRepositoryType {
    
    // TODO: - Change with model
    func getBreeds() -> AnyPublisher<[String], Error>
    func getBreedsImages(breed: String) -> AnyPublisher<[String], Error>
    func getFavorites() -> Observable<[String: String]>
    func favoritize(breed: String, url: String)
    
}

final class BreedsRepository: BreedsRepositoryType {
    
    private let apiService: APIServiceType
    private let storageService: StorageServiceType
    
    init(api: APIServiceType, storage: StorageServiceType) {
        self.apiService = api
        self.storageService = storage
    }
    
    func getBreeds() ->  AnyPublisher<[String], Error> {
        return self.apiService.getBreedList()
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func getBreedsImages(breed: String) -> AnyPublisher<[String], Error> {
        return self.apiService.getBreedImages(breed: breed)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func getFavorites() -> Observable<[String: String]> {
        return Observable.create({ [weak self] observer -> Disposable in
            observer.onNext(self?.storageService.getFavorites() ?? [:])
            return Disposables.create()
        })
    }
    
    func favoritize(breed: String, url: String) {
        let favorites = storageService.getFavorites()
        if favorites[url] != nil {
            storageService.removeFavorite(url: url)
        } else {
            storageService.saveFavorite(breed: breed, url: url)
        }
    }
}
