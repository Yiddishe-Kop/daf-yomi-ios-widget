//
//  ShasView.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 29/03/2024.
//

import SwiftUI

struct TractateView: View {

    let tractate: String
    let totalDafim: Int

    var body: some View {
        let items = (1...totalDafim-1).map { Shas.arabicToHebrew(num: $0+1) }

        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 5), spacing: 10) {
                ForEach(items, id: \.self) { item in
                    NavigationLink(destination: DafView(tractate: tractate, daf: item)) {
                        Text(item)
                            .font(Font.custom("SiddurOC-Black", size: 42))
                            .padding(.top, -18)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray200)
                            .foregroundColor(.gray800)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }.navigationTitle("מסכת \(tractate)")
    }
}

struct TractateView_Previews: PreviewProvider {
    static var previews: some View {
        TractateView(tractate: "יומא", totalDafim: 55)
    }
}
