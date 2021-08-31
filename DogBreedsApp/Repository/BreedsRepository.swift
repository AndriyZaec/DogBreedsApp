//
//  BreedsRepository.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import Foundation
import RxSwift

protocol BreedsRepositoryType {
    
    // TODO: - Change with model
    func getBreeds() -> Observable<[String]>
    func getBreedsImages(breed: String) -> Observable<[String]>
    func getFavorites() -> Observable<[String]>
    
}

final class BreedsRepository: BreedsRepositoryType {
    
    private let apiService: APIServiceType
    private let storageService: StorageServiceType
    
    init(api: APIServiceType, storage: StorageServiceType) {
        self.apiService = api
        self.storageService = storage
    }
    
    func getBreeds() -> Observable<[String]> {
        return apiService.getBreedList()
    }
    
    func getBreedsImages(breed: String) -> Observable<[String]> {
        return apiService.getBreedImages(breed: breed)
    }
    
    func getFavorites() -> Observable<[String]> {
        return Observable.create({ [weak self] observer -> Disposable in
            observer.onNext([])
            
            return Disposables.create()
        })
    }
}
