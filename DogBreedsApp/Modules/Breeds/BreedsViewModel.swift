//
//  BreedsViewModel.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

class BreedsViewModel: BaseViewModel {
    
    // MARK: - Injections
    private let repository: BreedsRepositoryType
    
    // MARK: - Properties
    var breedsDriver: Driver<[String]> = .never()
    var breeds: BehaviorRelay<[String]> = .init(value: [])
    
    var onBreedSelected: BehaviorRelay<String> = BehaviorRelay(value: "")
    var onFavoritesTapped: BehaviorRelay<Void> = BehaviorRelay(value: ())
    
    // MARK: - Lifecycle
    
    init(repository: BreedsRepositoryType) {
        self.repository = repository
        
        super.init()
        
        repository.getBreeds()
            .subscribe(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { breeds in
                self.breeds.accept(breeds)
            }.store(in: &subscriptions)
    }
}
