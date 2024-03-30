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
            .activityBackgroundTint(Color.accent.opacity(0.1))
            .activitySystemActionForegroundColor(Color.accent)

        } dynamicIsland: { context in
            DynamicIsland {
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
                Text("דף \(context.attributes.daf.daf)")
            } compactTrailing: {
//                ProgressView(value: 45, total: 100) {
//                    Text("45")
//                }
//                .progressViewStyle(.circular)
//                .frame(height: 24)
//                .tint(Color.green)
              Text(context.attributes.daf.tractate)
            } minimal: {
                Text(context.attributes.daf.daf)
                    .font(Font.custom("SiddurOC-Black", size: 30))
                    .baselineOffset(12)
            }
            .contentMargins(.leading, 0, for: .compactTrailing)
//            .contentMargins(.trailing, 2, for: .compactTrailing)
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.accent)
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
