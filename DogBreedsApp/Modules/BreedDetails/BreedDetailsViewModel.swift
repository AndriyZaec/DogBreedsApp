//
//  BreedDetailsViewModel.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 02.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

class BreedDetailsViewModel: BaseViewModel, Favoritazble {
    
    // MARK: - Injections
    private let repository: BreedsRepositoryType
    
    var breed: String
    
    // MARK: - Properties
    var breedsImagesDriver: Driver<[String]> = .never()
    
    var onBreedFavoriteSelected: BehaviorRelay<(breed: String, url: String)> = BehaviorRelay(value: ("", ""))
    
    var favorites: [String] = []
    
    // MARK: - Lifecycle
    
    init(repository: BreedsRepositoryType, breed: String) {
        self.repository = repository
        self.breed = breed
        
        super.init()
        
        getFavorites()
        
//        breedsImagesDriver = repository.getBreedsImages(breed: breed)
//            .do(onError: { [weak self] in self?.onError?.accept($0) })
//            .asDriver(onErrorJustReturn: [])
        
        onBreedFavoriteSelected.skip(1).subscribe(onNext: { [weak self] in
            self?.repository.favoritize(breed: $0.breed, url: $0.url)
            self?.getFavorites()
        }).disposed(by: disposeBag)
    }
    
    func getFavorites() {
        self.repository.getFavorites()
            .subscribe(onNext: { [weak self] in self?.favorites = Array($0.filter({ $0.value == self?.breed }).keys) })
            .disposed(by: disposeBag)
    }
}

