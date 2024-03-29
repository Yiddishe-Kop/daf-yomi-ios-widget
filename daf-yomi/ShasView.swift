//
//  ShasView.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 29/03/2024.
//

import SwiftUI

struct ShasView: View {

    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
        }
        .listStyle(.automatic)
        .navigationTitle("Shas")
    }
}


struct ShasView_Previews: PreviewProvider {
    static var previews: some View {
        ShasView()
    }
}
