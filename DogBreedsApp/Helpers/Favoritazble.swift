//
//  Favoritazble.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 02.09.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol Favoritazble: AnyObject {
    var onBreedFavoriteSelected: BehaviorRelay<(breed: String, url: String)> { get }
    var disposeBag: DisposeBag { get }
}
