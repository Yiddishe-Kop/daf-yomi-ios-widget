//
//  ShasView.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 29/03/2024.
//

import SwiftUI

struct ShasView: View {

    let tractates = Shas.tractates

    var body: some View {
        List {
           ForEach(tractates, id: \.self) { name in
               let number = Shas.dafimCount[name] ?? 0
               NavigationLink(destination: TractateView(tractate: name, totalDafim: number  )) {   
                   HStack {
                       Text(name)
                           .font(Font.custom("SiddurOC-Black", size: 32))
                           .padding(.top, -12)
                       Spacer()
                       Badge(number: number)
                   }
               }
           }
       }
        .listStyle(.automatic)
        .navigationTitle("תלמוד בבלי")
    }
}

struct Badge: View {
    let number: Int
    
    var body: some View {
        Text("\(number)")
            .font(.caption)
            .foregroundColor(.gray800)
            .padding(5)
            .background(.gray200)
            .cornerRadius(20)
    }
}

struct ShasView_Previews: PreviewProvider {
    static var previews: some View {
        ShasView()
    }
}
