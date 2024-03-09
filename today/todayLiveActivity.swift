//
//  todayLiveActivity.swift
//  today
//
//  Created by Yehuda Neufeld on 05/06/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct todayAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct todayLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: todayAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                DafGuage(dafYomiData: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30"))
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
                    DafGuage(dafYomiData: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30"))
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
    static let attributes = todayAttributes(name: "Me")
    static let contentState = todayAttributes.ContentState(value: 3)

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
