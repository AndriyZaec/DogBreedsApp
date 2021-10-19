//
//  BaseViewModel.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 01.09.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

class BaseViewModel {
    
    let disposeBag = DisposeBag()

    var subscriptions: Set<AnyCancellable> = []
    
    var onError: BehaviorRelay<Error>? = .none
    var onLoading: BehaviorRelay<Error>? = .none
    
}
