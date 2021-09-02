//
//  BreedDetailsCoordinator.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 02.09.2021.
//

import Foundation
import UIKit
import RxSwift

class BreedDetailsCoordinator: Coordinator {
    
    private weak var breedDetailsViewController: BreedDetailsViewController?
    private weak var navigationController: UINavigationController?
    
    private let breedsRepository: BreedsRepositoryType
    private let breed: String
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController, repository: BreedsRepositoryType, breed: String) {
        self.navigationController = navigationController
        
        self.breedsRepository = repository
        self.breed = breed
    }
    
    func load() {
        guard let navigationController = navigationController else { return }
        let viewModel = BreedDetailsViewModel(repository: breedsRepository, breed: breed)
        let viewController = BreedDetailsViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        breedDetailsViewController = viewController
    }
}
