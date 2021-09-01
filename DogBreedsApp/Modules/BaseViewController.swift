//
//  BaseViewController.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 01.09.2021.
//

import UIKit
import RxSwift

class BaseViewController<T: BaseViewModel>: UIViewController {
    
    let disposeBag = DisposeBag()
    var viewModel: T?
    
    init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        style()
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.onError?.subscribe(onNext: { [weak self] in
            let alert = UIAlertController(title: "Error", message: $0.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    func bind() { }
    func style() { }
    
}
