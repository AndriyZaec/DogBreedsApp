//
//  BreedsViewController.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class BreedsViewController: BaseViewController<BreedsViewModel> {
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BreedCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: BreedCollectionViewCell.self))
        return collectionView
    }()
    
    private var favoritesButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        button.tintColor = .black
        return button
    }()
    
    override init(viewModel: BreedsViewModel) {
        super.init(viewModel: viewModel)
        
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        super.bind()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.breeds
            .asObservable()
            .bind(to: collectionView.rx
                    .items(cellIdentifier: String(describing: BreedCollectionViewCell.self), cellType: BreedCollectionViewCell.self)) { idx, model, cell in
                cell.configure(with: model)
        }
        .disposed(by: disposeBag)
        
        favoritesButton.rx
            .tap
            .asDriver()
            .drive(viewModel.onFavoritesTapped)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(String.self)
            .bind(to: viewModel.onBreedSelected)
            .disposed(by: disposeBag)
    }
    
    override func style() {
        super.style()
        
        self.title = "Breeds"
        
        self.view.addSubview(collectionView)
        
        self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.collectionView.backgroundColor = .systemGray6
        
        navigationItem.rightBarButtonItem = favoritesButton
    }

}

extension BreedsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
}
