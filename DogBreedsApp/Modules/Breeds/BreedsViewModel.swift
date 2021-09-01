//
//  BreedsViewModel.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import Foundation
import RxSwift
import RxCocoa

class BreedsViewModel: BaseViewModel {
    
    // MARK: - Injections
    private let repository: BreedsRepositoryType
    
    // MARK: - Properties
    var breedsDriver: Driver<[String]> = .never()
    
    var onBreedSelected: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    // MARK: - Lifecycle
    
    init(repository: BreedsRepositoryType) {
        self.repository = repository
        
        super.init()
        
        breedsDriver = repository.getBreeds()
            .debug()
            .do(onError: { [weak self] in self?.onError?.accept($0) })
            .asDriver(onErrorJustReturn: [])
        
        onBreedSelected.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
}
