//
//  BreedDetailsViewController.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 02.09.2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class BreedDetailsViewController: BaseViewController<BreedDetailsViewModel> {
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BreedDetailsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: BreedDetailsCollectionViewCell.self))
        return collectionView
    }()
    
    override init(viewModel: BreedDetailsViewModel) {
        super.init(viewModel: viewModel)
        
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        super.bind()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.breedsImages
            .asObservable()
            .bind(to: collectionView.rx
                    .items(cellIdentifier: String(describing: BreedDetailsCollectionViewCell.self), cellType: BreedDetailsCollectionViewCell.self)) { idx, model, cell in
                let isFavorite = viewModel.favorites.contains(model)
                cell.configure(with: viewModel.breed, breedUrl: model, isFavorite: isFavorite, parent: viewModel)
        }
        .disposed(by: disposeBag)
    }
    
    override func style() {
        super.style()
        
        self.title = (viewModel?.breed ?? "").capitalized
        
        self.view.addSubview(collectionView)
        
        self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.collectionView.backgroundColor = .systemGray6
    }

}

extension BreedDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 40) / 3
        return CGSize(width: width, height: width)
    }
    
}
