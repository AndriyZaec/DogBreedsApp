//
//  APIService.swift
//  DogBreedsApp
//
//  Created by Andrew Zaiets on 31.08.2021.
//

import RxSwift
import Combine

enum CustomError: Error {
    case statusCode
    case decoding
    case invalidURL
    case other(Error)
    
    static func map(_ error: Error) -> CustomError {
        return (error as? CustomError) ?? .other(error)
    }
}

protocol APIServiceType {
    
    func getBreedList() -> AnyPublisher<[String], CustomError>
    func getBreedImages(breed: String) -> AnyPublisher<[String], CustomError>
    
}

class APIService: APIServiceType {
    
    private let baseURL: URL = URL(string: "https://dog.ceo/api/")!
    
    func getBreedList() -> AnyPublisher<[String], CustomError> {
        
        return URLSession.shared.dataTaskPublisher(for: baseURL.appendingPathComponent(Routes.allBreeds.path))
            .tryMap({ response in
                guard let httpURLResponse = response.response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                        throw CustomError.statusCode
                    }
                    return response.data
            })
            .decode(type: BreedsDynamicKeysResponse.self, decoder: JSONDecoder())
            .tryMap({ Array($0.message.keys) })
            .mapError({ CustomError.map($0) })
            .eraseToAnyPublisher()
    }
    
    func getBreedImages(breed: String) -> AnyPublisher<[String], CustomError> {
        return URLSession.shared.dataTaskPublisher(for: baseURL.appendingPathComponent(Routes.breedsImages(breed).path))
            .tryMap({ response in
                guard let httpURLResponse = response.response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                        throw CustomError.statusCode
                    }
                    return response.data
            })
            .decode(type: BreedsResponse.self, decoder: JSONDecoder())
            .tryMap({ Array($0.message) })
            .mapError({ CustomError.map($0) })
            .eraseToAnyPublisher()
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
