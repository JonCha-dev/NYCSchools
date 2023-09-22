//
//  SATCell.swift
//  NYCSchools
//
//  Created by Jon Chang on 7/29/23.
//

import SwiftUI

struct SATCell: View {
    @StateObject var viewModel = SATViewModel(service: SchoolService())
    
    let dbn: String
    
    var body: some View {
        VStack {
            switch viewModel.status {
            case .initial, .loading:
                Text("Loading...")
            case .error:
                Text("Error.")
            case .empty:
                Text("No data available")
            case .loaded:
                ForEach(viewModel.data, id: \.self) { score in
                    Text("Reading: " + score.sat_critical_reading_avg_score)
                    Text("Math: " + score.sat_math_avg_score)
                    Text("Writing: " + score.sat_writing_avg_score)
                }
            }
        }
        .onAppear {
            viewModel.getSAT(dbn)
        }
    }
}

struct SATCell_Previews: PreviewProvider {
    static var previews: some View {
        SATCell(dbn: "21K728")
    }
}
