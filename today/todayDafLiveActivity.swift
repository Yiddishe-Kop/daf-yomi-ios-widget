//
//  todayLiveActivity.swift
//  today
//
//  Created by Yehuda Neufeld on 05/06/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct todayDafLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodaysDafAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                DafGuage(dafYomiData: context.attributes.daf)
            }.padding()
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("בלאט גמרא")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("נאך א")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    DafGuage(dafYomiData: context.attributes.daf)
                    // more content
                }
            } compactLeading: {
                Text("דף ב׳")
            } compactTrailing: {
                ProgressView(value: 45, total: 100) {
                    Text("45")
                }
                .progressViewStyle(.circular)
                .frame(height: 24)
                .tint(Color.green)
//              Text("ב״מ")
            } minimal: {
//                Text("ב׳")
                ProgressView(value: 45, total: 100) {
                    Text("45")
                }
                .progressViewStyle(.circular)
                .frame(height: 24)
                .tint(Color.green)
            }
            .contentMargins(.leading, 0, for: .compactTrailing)
//            .contentMargins(.trailing, 2, for: .compactTrailing)
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct todayLiveActivity_Previews: PreviewProvider {
    static let attributes = TodaysDafAttributes(daf: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30"))
    static let contentState = TodaysDafAttributes.ContentState(percentageLearnt: 45)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
