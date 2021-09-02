//
//  FavoriteViewModel.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 02.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteViewModel: BaseViewModel, Favoritazble {
    
    // MARK: - Injections
    private let repository: BreedsRepositoryType
    
    // MARK: - Properties
    var favoritesImages: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var breedsFavoritesImages: BehaviorRelay<[String: String]> = BehaviorRelay(value: [:])
    
    var onBreedFavoriteSelected: BehaviorRelay<(breed: String, url: String)> = BehaviorRelay(value: ("", ""))
    var onFilterFavoritesImages: BehaviorRelay<Void> = BehaviorRelay(value: ())
    
    var favoritesByBreeds = [String: String]()
    
    // MARK: - Lifecycle
    
    init(repository: BreedsRepositoryType) {
        self.repository = repository
        
        super.init()
        
        getFavorites()
        
        onBreedFavoriteSelected.skip(1).do(afterNext: { [weak self] _ in
            self?.getFavorites()
        }).subscribe(onNext: { [weak self] in
            self?.repository.favoritize(breed: $0.breed, url: $0.url)
        }).disposed(by: disposeBag)
        
        onFilterFavoritesImages.skip(1).subscribe(onNext: { [unowned self] in
            repository.getFavorites()
                .compactMap({ $0.keys.sorted(by: { $0 > $1 }) })
                .bind(to: self.favoritesImages)
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    private func getFavorites() {
        repository.getFavorites()
            .do(onError: { [weak self] in self?.onError?.accept($0) })
            .map({ Array($0.keys) })
            .bind(to: favoritesImages)
            .disposed(by: disposeBag)
        
        repository.getFavorites()
            .do(onError: { [weak self] in self?.onError?.accept($0) })
            .subscribe(onNext: { [weak self] in
                self?.favoritesByBreeds = $0
            })
            .disposed(by: disposeBag)
    }
}
