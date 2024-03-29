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
        List {
            ForEach(1...totalDafim, id: \.self) { dafNumber in
               HStack {
                   Text("דף \(dafNumber)")
                       .font(Font.custom("SiddurOC-Black", size: 32))
                       .padding(.top, -12)
                   Spacer()
               }
           }
       }
        .listStyle(.automatic)
        .navigationTitle(tractate)
    }
}

struct TractateView_Previews: PreviewProvider {
    static var previews: some View {
        TractateView(tractate: "סוכה", totalDafim: 55)
    }
}
