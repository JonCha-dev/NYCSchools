//
//  SchoolService.swift
//  20230729-JonChang-NYCSchools
//
//  Created by Jon Chang on 7/29/23.
//

import Foundation
import Combine

protocol SchoolServiceProtocol {
    func fetchSchools() -> Future<[SchoolData], Error>
    
    func fetchSAT(_ dbn: String) -> Future<[SATData], Error> 
}

class SchoolService: SchoolServiceProtocol {
    private var cancellable = Set<AnyCancellable>()
    private let urlStringSchool = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    private let urlStringSAT = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?dbn="
    
    func fetchSchools() -> Future<[SchoolData], Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            guard let url = URL(string: urlStringSchool) else { return }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [SchoolData].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let err):
                        promise(.failure(err))
                    }
                } receiveValue: { response in
                    promise(.success(response))
                }
                .store(in: &cancellable)
        }
    }
    
    func fetchSAT(_ dbn: String) -> Future<[SATData], Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            let finalUrlString = urlStringSAT + dbn
            guard let url = URL(string: finalUrlString) else { return }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [SATData].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let err):
                        promise(.failure(err))
                    }
                } receiveValue: { response in
                    promise(.success(response))
                }
                .store(in: &cancellable)
        }
    }
}
