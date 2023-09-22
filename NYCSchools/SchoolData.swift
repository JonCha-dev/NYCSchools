//
//  SchoolData.swift
//  20230729-JonChang-NYCSchools
//
//  Created by Jon Chang on 7/29/23.
//

import Foundation

struct SchoolData: Decodable, Hashable {
    let dbn: String
    let school_name: String
}

struct SATData: Decodable, Hashable {
    let sat_critical_reading_avg_score: String
    let sat_math_avg_score: String
    let sat_writing_avg_score: String
}
