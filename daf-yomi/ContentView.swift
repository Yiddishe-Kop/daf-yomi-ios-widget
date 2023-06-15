//
//  ContentView.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 04/06/2023.
//

import SwiftUI

struct ContentView: View {
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
                    if (apiManager.dafYomiData != nil) {
                        DafGuage(dafYomiData: apiManager.dafYomiData!)
                            .padding()
                    }
                    
                }
                .background(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .shadow(color: Color("gray800").opacity(0.3), radius: 2)
                
                VStack {
                    VStack{
                        if (apiManager.dafYomiData != nil) {
                            Text(apiManager.dafYomiData!.tractate)
                                .font(Font.custom("SiddurOC-Black", size: 50))
                                .foregroundColor(.accentColor)
                            Text(apiManager.dafYomiData!.daf)
                                .font(Font.custom("SiddurOC-Black", size: 200))
                                .foregroundColor(Color("gray800"))
                                .offset(x: 0, y: -40)
                            
                        } else {
                            ProgressView("טוען...")
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }.padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 5)
                .shadow(color: Color("gray800").opacity(0.3), radius: 2)
                
                
                if (apiManager.dafYomiData != nil) {
                    // Daf Text
                    VStack {
                        VStack(alignment: .leading) {
                            if (!(apiManager.heText.first?.isEmpty ?? false)) {
                                ForEach(apiManager.heText, id: \.self) { page in
                                    ForEach(page, id: \.self) { line in
                                        Text(line)
                                    }
                                }
                                .environment(\.font, Font.custom("SiddurOC-Regular", size: 28))
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
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: Color("gray800").opacity(0.3), radius: 2)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
