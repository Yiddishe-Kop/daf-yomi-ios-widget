//
//  today.swift
//  today
//
//  Created by Yehuda Neufeld on 05/06/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct DafYomiEntry: TimelineEntry {
    let date: Date
    let data: DafYomiData?
}

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (DafYomiEntry) -> Void) {
        let entry = DafYomiEntry(date: Date(), data: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DafYomiEntry>) -> Void) {
        var entries: [DafYomiEntry] = []
                
        let apiManager = APIManager()
        apiManager.fetchDafYomi {
            let entry = DafYomiEntry(date: Date(), data: apiManager.dafYomiData)
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> DafYomiEntry {
        DafYomiEntry(date: Date(), data: nil)
    }
}

struct todayEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    var body: some View {
        
        if ((entry.data) == nil) {
            Text("Loading...")
        } else {
            switch family {
                case .accessoryInline:
                    HStack {
                        Image(systemName: "character.book.closed.fill.he")
                        Text(entry.data!.tractate + " דף " + String(entry.data!.daf))
                    }
                case .accessoryCircular:
                    DafGuage(dafYomiData: entry.data!)
                    .containerBackground(for: .widget) {
                        Color.gray
                    }
                case .accessoryRectangular:
                    HStack{
                        Text(entry.data!.tractate + " דף")
                            .font(Font.custom("SiddurOC-Regular", size: 25))
                        Text(String(entry.data!.daf))
                            .font(Font.custom("SiddurOC-Black", size: 25))
                    }.environment(\.layoutDirection, .rightToLeft)
                    .containerBackground(for: .widget) {
                        Color.gray
                    }
                default:
                    Text(entry.data!.tractate + " דף " + String(entry.data!.daf))
            }
        }
    }
}

struct today: Widget {
    let kind: String = "today"

    var body: some WidgetConfiguration {
            StaticConfiguration(kind: "MyWidget", provider: Provider()) { entry in
                todayEntryView(entry: entry)
            }
            .configurationDisplayName("הדף היומי")
            .description("הצג את הדף של היום")
            .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
        }
}

struct today_Previews: PreviewProvider {
    static var previews: some View {
        todayEntryView(entry: DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30")))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")
        todayEntryView(entry: DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30")))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
        todayEntryView(entry: DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30")))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
    }
}
