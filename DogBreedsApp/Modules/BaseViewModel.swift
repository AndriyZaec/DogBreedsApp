//
//  BaseViewModel.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 01.09.2021.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    var onError: BehaviorRelay<Error>? = .none
    var onLoading: BehaviorRelay<Error>? = .none
    
}
