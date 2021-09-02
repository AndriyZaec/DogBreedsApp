//
//  APIService.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import RxSwift

protocol CustomError: Error {
    var localizedTitle: String { get set }
    var localizedDescription: String { get set }
}

protocol APIServiceType {
    
    func getBreedList() -> Observable<[String]>
    func getBreedImages(breed: String) -> Observable<[String]>
    
}

class APIService: APIServiceType {
    
    private let baseURL: URL = URL(string: "https://dog.ceo/api/")!
    
    func getBreedList() -> Observable<[String]> {
        
        return Observable.create { [unowned self] observer -> Disposable in
            
            URLSession.shared.dataTask(with: baseURL.appendingPathComponent(Routes.allBreeds.path)) { data, response, error in
                
                if let error = error {
                    observer.onError(error)
                }
                
                if let jsonData = data, let breedsResp = try? JSONDecoder().decode(BreedsDynamicKeysResponse.self, from: jsonData) {
                    if breedsResp.status == "success" && breedsResp.message.count != 0 {
                        observer.onNext(breedsResp.message.keys.map({ String($0) }))
                    }
                }
            }.resume()
            
            return Disposables.create()
        }
    }
    
    func getBreedImages(breed: String) -> Observable<[String]> {
        return Observable.create { [unowned self] observer -> Disposable in
            
            URLSession.shared.dataTask(with: baseURL.appendingPathComponent(Routes.breedsImages(breed).path)) { data, response, error in
                
                if let error = error {
                    observer.onError(error)
                }
                
                if let jsonData = data, let breedsResp = try? JSONDecoder().decode(BreedsResponse.self, from: jsonData) {
                    if breedsResp.status == "success" && breedsResp.message.count != 0 {
                        observer.onNext(breedsResp.message)
                    }
                }
            }.resume()
            
            return Disposables.create()
        }
    }
    
}

enum Routes {
    case allBreeds
    case breedsImages(String)
    
    var path: String {
        switch self {
        case .allBreeds:
            return "breeds/list/all"
        case .breedsImages(let breed):
            return "breed/\(breed)/images"
        }
    }
}
