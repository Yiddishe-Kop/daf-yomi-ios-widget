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
        let entry = DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ב.", ref: "ברכות.ב"))
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DafYomiEntry>) -> Void) {
        var entries: [DafYomiEntry] = []
        
        let apiManager = TodayController()
        apiManager.fetchDafYomi {
            let dafYomiData = apiManager.dafYomiData ?? DafYomiData(tractate: "ברכות", daf: "ב.", ref: "ברכות.ב")
            let entry = DafYomiEntry(date: Date(), data: dafYomiData)
            entries.append(entry)
            
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            let midnight = Calendar.current.startOfDay(for: tomorrow)
            let timeline = Timeline(entries: entries, policy: .after(midnight))
            completion(timeline)
        }
    }
    
    func placeholder(in context: Context) -> DafYomiEntry {
        DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ב.", ref: "ברכות.ב"))
    }
}

struct todayEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    var body: some View {
        widgetContent
            .widgetBackground(backgroundView: Color.clear)
    }
    
    @ViewBuilder
    var widgetContent: some View {
        switch family {
            case .accessoryInline:
                HStack {
                    Image(systemName: "character.book.closed.fill.he")
                    Text(entry.data!.tractate + " דף " + entry.data!.daf)
                }
            case .accessoryCircular:
                DafGuage(dafYomiData: entry.data!)
            case .accessoryRectangular:
                HStack{
                    Text(entry.data!.tractate + " דף")
                        .font(Font.custom("SiddurOC-Regular", size: 25))
                    Text(String(entry.data!.daf))
                        .font(Font.custom("SiddurOC-Black", size: 25))
                }.environment(\.layoutDirection, .rightToLeft)
            case .systemSmall:
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        DafGuage(dafYomiData: entry.data!)
                    }
                }
            case .systemMedium:
                DafGuage(dafYomiData: entry.data!)
            case .systemLarge, .systemExtraLarge:
                DafGuage(dafYomiData: entry.data!)
            @unknown default:
                Text(entry.data!.tractate + " דף " + String(entry.data!.daf))
        }
        
    }
}

struct todaysDaf: Widget {
    let kind: String = "today"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MyWidget", provider: Provider()) { entry in
            todayEntryView(entry: entry)
        }
        .configurationDisplayName("הדף היומי")
        .description("הצג את הדף של היום")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryInline,
            .accessoryRectangular,
            .systemSmall,
            .systemMedium,
            .systemLarge
        ])
    }
}

extension View {
    func widgetBackground(backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
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
        todayEntryView(entry: DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small Widget")
        todayEntryView(entry: DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30")))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium Widget")
        todayEntryView(entry: DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30")))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large Widget")
        todayEntryView(entry: DafYomiEntry(date: Date(), data: DafYomiData(tractate: "ברכות", daf: "ג׳", ref: "Gittin.30")))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
            .previewDisplayName("Extra Large Widget")
    }
}
