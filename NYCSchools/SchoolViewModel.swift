//
//  SchoolViewModel.swift
//  20230729-JonChang-NYCSchools
//
//  Created by Jon Chang on 7/29/23.
//

import Foundation
import Combine

enum Status {
    case initial, loading, loaded, error, empty
}

class SchoolViewModel: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    private let service:SchoolServiceProtocol
    
    init(service: SchoolServiceProtocol) {
        self.service = service
    }
    
    @Published var data: [SchoolData] = [SchoolData]()
    @Published var status: Status = .initial
    
    func getSchools() {
        status = .loading
        service.fetchSchools()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    self?.status = .error
                    print(String(describing: err))
                }
            } receiveValue: { [weak self] response in
                self?.data = response
            
                if response.count > 0 {
                    self?.status = .loaded
                } else {
                    self?.status = .empty
                }
            }
            .store(in: &cancellable)
    }
}


class SATViewModel: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    private let service:SchoolServiceProtocol
    
    init(service: SchoolServiceProtocol) {
        self.service = service
    }
    
    @Published var data: [SATData] = [SATData]()
    @Published var status: Status = .initial
    
    func getSAT(_ dbn: String) {
        status = .loading
        service.fetchSAT(dbn)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    self?.status = .error
                    print(String(describing: err))
                }
            } receiveValue: { [weak self] response in
                self?.data = response
                
                if response.count > 0 {
                    self?.status = .loaded
                } else {
                    self?.status = .empty
                }
            }
            .store(in: &cancellable)
    }
}
