//
//  BreedCollectionViewCell.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 01.09.2021.
//

import UIKit

class BreedCollectionViewCell: UICollectionViewCell {
    
    override var reuseIdentifier: String? {
        String(describing: BreedCollectionViewCell.self)
    }
    
    var breedName: String? {
        didSet {
            self.breedLabel.text = (breedName ?? "").capitalized
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .random()
        return view
    }()
    
    private let breedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with breed: String) {
        self.breedName = breed
    }
    
    private func style() {
        self.addSubview(containerView)
        self.containerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        containerView.addSubview(blurView)
        self.blurView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.blurView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        self.blurView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        self.containerView.addSubview(breedLabel)
        self.breedLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive =  true
        self.breedLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive =  true
    }
    
}
