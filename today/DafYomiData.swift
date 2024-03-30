//
//  DafYomiData.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 15/06/2023.
//

import Foundation

struct DafYomiData: Codable {
    let tractate: String
    let daf: String
    let ref: String
    
    func totalDafim() -> Int {
        return Shas.dafimCount[tractate] ?? 0
    }
    
    func dafNumber() -> Int {
        return Shas.hebrewToNumber(hebrewNumber: self.daf)
    }
    
    func shortTractateName() -> String {
        let words = self.tractate.components(separatedBy: " ")
        if words.count == 2 {
            let firstLetters = words.map { $0.prefix(1).capitalized }
            return firstLetters.joined(separator: "״")
        } else {
            return self.tractate
        }
    }
}
