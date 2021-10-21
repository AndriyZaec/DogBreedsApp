//
//  BreedsViewModel.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import Foundation
import Combine

class BreedsViewModel: BaseViewModel {
    
    // MARK: - Injections
    private let repository: BreedsRepositoryType
    
    // MARK: - Properties
    @Published var breeds: [String] = []
    
    var onBreedSelected: AnyPublisher<String, Never>?
    var onFavoritesTapped: AnyPublisher<Void, Never>?
    
    // MARK: - Lifecycle
    
    init(repository: BreedsRepositoryType) {
        self.repository = repository
        
        super.init()
        
        repository.getBreeds()
            .sink { compleation in
                switch compleation {
                case .finished: break
                case .failure(_): break
                }
            } receiveValue: { [weak self] val in
                self?.breeds = val.sorted()
            }.store(in: &subscriptions)

    }
}
