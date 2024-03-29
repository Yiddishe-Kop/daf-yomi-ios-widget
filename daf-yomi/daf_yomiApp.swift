//
//  daf_yomiApp.swift
//  daf-yomi
//
//  Created by Yehuda Neufeld on 04/06/2023.
//

import SwiftUI

@main
struct daf_yomiApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Group {
                    TodayView()
                        .tabItem {
                            Label("Today", systemImage: "doc.text.image")
                        }
                    NavigationStack {
                        ShasView()
                    }
                    .tabItem {
                        Label("Shas", systemImage: "books.vertical")
                    }
                }
                .toolbarBackground(.gray800, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            }
        }
    }
}
