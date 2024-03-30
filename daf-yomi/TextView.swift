//
//  TextView.swift
//  הדף היומי
//
//  Created by Yehuda Neufeld on 30/03/2024.
//

import SwiftUI

struct TextView: View {
    var heText: [[String]] = [[]]
    
    var body: some View {
        ForEach(heText, id: \.self) { page in
            ForEach(page, id: \.self) { line in
                if let plainText = removeHTMLTags(line) {
                    Text(plainText)
                } else {
                    Text("Error parsing HTML")
                }
            }
        }
        .environment(\.font, Font.custom("SiddurOC-Regular", size: 26))
        .multilineTextAlignment(.trailing)
        .textSelection(.enabled)
    }
}

// Function to remove HTML tags from the string
func removeHTMLTags(_ htmlString: String) -> String? {
    do {
        // Regular expression to remove HTML tags
        let regex = try NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
        // Replace HTML tags with an empty string
        let plainText = regex.stringByReplacingMatches(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.utf16.count), withTemplate: "")
        return plainText
    } catch {
        print("Error:", error)
        return nil
    }
}
