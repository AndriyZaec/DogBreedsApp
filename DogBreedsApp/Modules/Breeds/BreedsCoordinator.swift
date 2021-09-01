//
//  BreedsCoordinator.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import UIKit
import RxSwift

class BreedsCoordinator: Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    private weak var breedsViewController: BreedsViewController?
    private weak var navigationController: UINavigationController?
    
    private var breedsRepository: BreedsRepositoryType?
    
    private let disposeBag = DisposeBag()
    
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
        
        navigationController.pushViewController(viewController, animated: true)
        
        breedsViewController = viewController
    }
}
