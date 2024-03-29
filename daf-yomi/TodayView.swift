//
//  ContentView.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 04/06/2023.
//

import SwiftUI

struct TodayView: View {
    @StateObject private var apiManager = APIManager()

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "books.vertical.fill")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                        .padding()
                    Text("Todays Daf")
                        .font(.title2)
                    Spacer()
                    if apiManager.dafYomiData != nil {
                        DafGuage(dafYomiData: apiManager.dafYomiData!)
                            .padding()
                    }
                    
                }
                .background(.background)
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack {
                    VStack {
                        if apiManager.dafYomiData != nil {
                            Text(apiManager.dafYomiData!.tractate)
                                .font(Font.custom("SiddurOC-Black", size: 50))
                                .foregroundColor(.accentColor)
                                .padding(.top, -20)
                            Text(apiManager.dafYomiData!.daf)
                                .font(Font.custom("SiddurOC-Black", size: 200))
                                .foregroundColor(Color("gray800"))
                                .offset(x: 0, y: -40)
                                .padding(.top, -100)
                                .padding(.bottom, -40)
                            MarkAsLearnt(daf: apiManager.dafYomiData!)
                                .padding()
                        } else {
                            ProgressView("טוען...")
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }.padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.background)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                
                if apiManager.dafYomiData != nil {
                    // Daf Text
                    VStack {
                        VStack(alignment: .leading) {
                            if (!(apiManager.heText.first?.isEmpty ?? false)) {
                                ForEach(apiManager.heText, id: \.self) { page in
                                    ForEach(page, id: \.self) { line in
                                        if let plainText = removeHTMLTags(line) {
                                            Text(plainText)
                                        } else {
                                            Text("Error parsing HTML")
                                        }
                                    }
                                }
                                .environment(\.font, Font.custom("SiddurOC-Regular", size: 26))
                            } else {
                                Button(action: {
                                    apiManager.fetchText()
                                }) {
                                    HStack {
                                        Text("למד עכשיו")
                                            .bold()
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(Color("gray800"))
                                    }.padding(.horizontal, 10)
                                }.buttonStyle(.bordered)
                                    .background(Color("gray200"))
                                    .foregroundColor(Color("gray800"))
                                    .cornerRadius(20)
                                
                                
                            }
                        }
                        .padding()
                        .environment(\.layoutDirection, .rightToLeft)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.background)
                    .cornerRadius(12)
                    .padding([.horizontal])
                }
                
                Spacer()
                
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .onAppear {
                apiManager.fetchDafYomi()
            }
        }
        .background(Color("gray200"))
    }
}

// Function to remove HTML tags from the string
func removeHTMLTags(_ htmlString: String) -> String? {
    do {
        // Regular expression to remove HTML tags
        let regex = try NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
        // Replace HTML tags with an empty string
        let plainText = regex.stringByReplacingMatches(in: htmlString,
                                                        options: [],
                                                        range: NSRange(location: 0, length: htmlString.utf16.count),
                                                        withTemplate: "")
        return plainText
    } catch {
        print("Error:", error)
        return nil
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
