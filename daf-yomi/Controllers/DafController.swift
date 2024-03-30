//
//  DafController.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 30/03/2024.
//

import Foundation

class DafController: ObservableObject {
    @Published var heText: [[String]] = [[]]
    
    func fetchText(tractate: String, daf: String) {
        Task {
            do {
                let sefariaRef = "\(Shas.sefariaRefs[tractate]!).\(Shas.hebrewToNumber(hebrewNumber: daf))"
                let text = try await SefariaClient.fetchText(ref: sefariaRef)
                DispatchQueue.main.async {
                    self.heText = text
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
