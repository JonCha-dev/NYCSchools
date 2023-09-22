//
//  ContentView.swift
//  NYCSchools
//
//  Created by Jon Chang on 7/29/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel:SchoolViewModel = SchoolViewModel(service: SchoolService())
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    switch viewModel.status {
                    case .initial, .loading:
                        Text("Loading...")
                    case .error:
                        Text("Error.")
                    case .empty:
                        Text("Nothing to load.")
                    case .loaded:
                        listView(viewModel.data)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Schools")
        }
        .onAppear {
            viewModel.getSchools()
        }
    }
    
    private func listView(_ data:[SchoolData]) -> some View {
        ForEach(data, id: \.self) { school in
            NavigationLink {
                SATCell(dbn: school.dbn)
            } label: {
                Text(school.school_name)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding()
            .border(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
