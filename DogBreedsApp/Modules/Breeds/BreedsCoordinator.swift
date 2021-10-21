//
//  BreedsCoordinator.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import UIKit
import RxSwift
import Combine

class BreedsCoordinator: Coordinator {
    
    private weak var breedsViewController: BreedsViewController?
    private weak var navigationController: UINavigationController?
    
    private var breedsRepository: BreedsRepositoryType?
    
    private let disposeBag = DisposeBag()
    private var subscriptions: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let apiService = APIService()
        let storageService = StorageService()
        
        self.breedsRepository = BreedsRepository(api: apiService, storage: storageService)
    }
    
    func load() {
        guard let navigationController = navigationController, let repo = breedsRepository else { return }
        let viewModel = BreedsViewModel(repository: repo)
        let viewController = BreedsViewController(viewModel: viewModel)
        
        onBreedEventsSubscribe(viewModel: viewModel)
        
        navigationController.setViewControllers([viewController], animated: false)
        
        breedsViewController = viewController
    }
    
    // MARK: - Navigation
    
    private func toBreedsDetails(with breed: String) {
        guard let navigationController = navigationController, let repo = breedsRepository else { return }
        
        let coordinator = BreedDetailsCoordinator(navigationController: navigationController,
                                                  repository: repo,
                                                  breed: breed)
        
        coordinator.load()
    }
    
    private func toFavorites() {
        guard let navigationController = navigationController, let repo = breedsRepository else { return }
        
        let coordinator = FavoritesCoordinator(navigationController: navigationController,
                                               repository: repo)
        
        coordinator.load()
    }
    
    // MARK: - Subscriptions
    
    private func onBreedEventsSubscribe(viewModel: BreedsViewModel) {
        
        viewModel.onFavoritesTapped?
            .sink(receiveValue: { [weak self] in
                self?.toFavorites()
            }).store(in: &subscriptions)
        
        viewModel.onBreedSelected?
            .sink(receiveValue: { [weak self] in
                self?.toBreedsDetails(with: $0)
            }).store(in: &subscriptions)
    }
}
