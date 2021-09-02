//
//  BreedDetailsCollectionViewCell.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 02.09.2021.
//

import UIKit
import Kingfisher
import RxSwift

class BreedDetailsCollectionViewCell: UICollectionViewCell {
    
    weak var parent: Favoritazble?
    
    var disposeBag = DisposeBag()
    
    override var reuseIdentifier: String? {
        String(describing: BreedDetailsCollectionViewCell.self)
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .random()
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var imageUrl: String = "" {
        didSet {
            guard let imageUrl = URL(string: imageUrl) else {
                imageView.image = UIImage(systemName: "prohibit")
                return
            }
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    private var breed: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        favoriteButton.isSelected = false
        disposeBag = DisposeBag()
    }
    
    func configure(with breed: String, breedUrl: String, isFavorite: Bool = false, parent: Favoritazble) {
        self.parent = parent
        self.imageUrl = breedUrl
        self.breed = breed
        self.favoriteButton.isSelected = isFavorite
        
        self.bind()
    }
    
    private func style() {
        self.addSubview(containerView)
        self.containerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        containerView.addSubview(imageView)
        self.imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        containerView.addSubview(favoriteButton)
        self.favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 3).isActive = true
        self.favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3).isActive = true
    }
    
    private func bind() {
        guard let parent = parent else { return }
        
        favoriteButton.rx
            .tap
            .asDriver()
            .do(onNext: { [unowned self] in self.favoriteButton.isSelected = !self.favoriteButton.isSelected })
            .map({ [unowned self] in (self.breed, self.imageUrl)  })
            .drive(parent.onBreedFavoriteSelected)
            .disposed(by: disposeBag)
    }
}
