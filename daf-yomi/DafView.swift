//
//  DafView.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 30/03/2024.
//

import SwiftUI

struct DafView: View {
    let tractate: String
    let daf: String
    @StateObject private var dafController = DafController()

    var body: some View {
        ScrollView {
            if (!(dafController.heText.first?.isEmpty ?? false)) {
                TextView(heText: dafController.heText)
                    .padding()
            } else {
                ProgressView("טוען...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }.navigationTitle("דף \(daf)")
        .onAppear {
             dafController.fetchText(tractate: tractate, daf: daf)
        }
    }
}

struct DafView_Previews: PreviewProvider {
    static var previews: some View {
        DafView(tractate: "סוכה", daf: "ב")
    }
}
