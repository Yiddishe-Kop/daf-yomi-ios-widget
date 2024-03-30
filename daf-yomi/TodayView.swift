//
//  ContentView.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 04/06/2023.
//

import SwiftUI

struct TodayView: View {
    @StateObject private var todayController = TodayController()

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
                    if todayController.dafYomiData != nil {
                        DafGuage(dafYomiData: todayController.dafYomiData!)
                            .padding()
                    }
                    
                }
                .background(.background)
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack {
                    VStack {
                        if todayController.dafYomiData != nil {
                            Text(todayController.dafYomiData!.tractate)
                                .font(Font.custom("SiddurOC-Black", size: 50))
                                .foregroundColor(.accentColor)
                                .padding(.top, -20)
                            Text(todayController.dafYomiData!.daf)
                                .font(Font.custom("SiddurOC-Black", size: 200))
                                .foregroundColor(Color("gray800"))
                                .offset(x: 0, y: -40)
                                .padding(.top, -100)
                                .padding(.bottom, -40)
                            MarkAsLearnt(daf: todayController.dafYomiData!)
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
                
                
                if todayController.dafYomiData != nil {
                    // Daf Text
                    VStack {
                        VStack(alignment: .leading) {
                            if (!(todayController.heText.first?.isEmpty ?? false)) {
                                TextView(heText: todayController.heText)
                            } else {
                                Button(action: {
                                     todayController.fetchText()
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
                todayController.fetchDafYomi()
            }
        }
        .background(Color("gray200"))
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
