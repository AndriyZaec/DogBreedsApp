//
//  FavoritesCoordinator.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 02.09.2021.
//

import Foundation
import UIKit
import RxSwift

class FavoritesCoordinator: Coordinator {
    
    private weak var favoriteViewController: FavoriteViewController?
    private weak var navigationController: UINavigationController?
    
    private let breedsRepository: BreedsRepositoryType
    
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController, repository: BreedsRepositoryType) {
        self.navigationController = navigationController
        
        self.breedsRepository = repository
    }
    
    func load() {
        guard let navigationController = navigationController else { return }
        let viewModel = FavoriteViewModel(repository: breedsRepository)
        let viewController = FavoriteViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        favoriteViewController = viewController
    }
}
