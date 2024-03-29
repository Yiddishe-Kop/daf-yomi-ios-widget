//
//  DafYomiAttributes.swift
//  הדף היומי
//
//  Created by Yehuda Neufeld on 10/03/2024.
//
import ActivityKit

struct TodaysDafAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var percentageLearnt: Int
    }

    // Fixed non-changing properties about your activity go here!
    var daf: DafYomiData
}
