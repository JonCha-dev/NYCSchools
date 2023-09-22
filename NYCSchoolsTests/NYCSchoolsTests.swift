//
//  NYCSchoolsTests.swift
//  NYCSchoolsTests
//
//  Created by Jon Chang on 7/29/23.
//

import XCTest
import Combine
@testable import NYCSchools

enum FileName: String {
    case school_success_file, school_failure_file, school_empty_file, sat_success_file, sat_failure_file
}

final class NYCSchoolsTests: XCTestCase {
    private var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellable = []
    }

    func test_school_fetch_success() {
        let exp = XCTestExpectation(description: "fetch success data")
        let viewModel = SchoolViewModel(service: MockSchoolService(file: .school_success_file))
        
        viewModel.getSchools()
        
        viewModel.$data
            .sink { schools in
                let firstschool = schools.first!
                XCTAssertEqual(firstschool.dbn, "02M260")
                exp.fulfill()
            }
        
        wait(for:[exp], timeout: 5.0)
    }

    func test_school_fetch_failure() {
        let exp = XCTestExpectation(description: "fetch failure data")
        let viewModel = SchoolViewModel(service: MockSchoolService(file: .school_failure_file))
        
        viewModel.getSchools()
        
        viewModel.$status
            .sink { state in
                XCTAssertEqual(state, .error)
                exp.fulfill()
            }
        
        wait(for:[exp], timeout: 5.0)
    }
    
    func test_school_fetch_empty() {
        let exp = XCTestExpectation(description: "fetch empty data")
        let viewModel = SchoolViewModel(service: MockSchoolService(file: .school_empty_file))
        
        viewModel.getSchools()
        
        viewModel.$status
            .sink { state in
                XCTAssertEqual(state, .empty)
                exp.fulfill()
            }
        
        wait(for:[exp], timeout: 5.0)
    }
    
    func test_sat_fetch_success() {
        let exp = XCTestExpectation(description: "fetch success data")
        let viewModel = SATViewModel(service: MockSchoolService(file: .sat_success_file))
        
        viewModel.getSAT("dbn")
        
        viewModel.$data
            .sink { scores in
                let score = scores.first!
                XCTAssertEqual(score.sat_critical_reading_avg_score, "411")
                exp.fulfill()
            }
        
        wait(for:[exp], timeout: 5.0)
    }

    func test_sat_fetch_failure() {
        let exp = XCTestExpectation(description: "fetch failure data")
        let viewModel = SATViewModel(service: MockSchoolService(file: .sat_failure_file))
        
        viewModel.getSAT("dbn")
        
        viewModel.$status
            .sink { state in
                XCTAssertEqual(state, .error)
                exp.fulfill()
            }
        
        wait(for:[exp], timeout: 5.0)
    }
    
    func test_sat_fetch_empty() {
        let exp = XCTestExpectation(description: "fetch empty data")
        let viewModel = SATViewModel(service: MockSchoolService(file: .school_empty_file))
        
        viewModel.getSAT("dbn")
        
        viewModel.$status
            .sink { state in
                XCTAssertEqual(state, .empty)
                exp.fulfill()
            }
        
        wait(for:[exp], timeout: 5.0)
    }
}

class MockSchoolService: SchoolServiceProtocol {
    let file: FileName
    
    init(file: FileName) {
        self.file = file
    }
    
    func fetchSchools() -> Future<[SchoolData], Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            guard let url = Bundle(for: type(of: self)).url(forResource: file.rawValue, withExtension: "json") else { return }
            
            let data = try! Data(contentsOf: url)
            
            do {
                let response = try JSONDecoder().decode([SchoolData].self, from: data)
                promise(.success(response))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func fetchSAT(_ dbn:String) -> Future<[SATData], Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            guard let url = Bundle(for: type(of: self)).url(forResource: file.rawValue, withExtension: "json") else { return }
            
            let data = try! Data(contentsOf: url)
            
            do {
                let response = try JSONDecoder().decode([SATData].self, from: data)
                promise(.success(response))
            } catch {
                promise(.failure(error))
            }
        }
    }
}
