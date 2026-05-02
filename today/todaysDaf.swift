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
    private let fallbackDaf = DafYomiData(tractate: "ברכות", daf: "ב.", ref: "ברכות.ב")

    func getSnapshot(in context: Context, completion: @escaping (DafYomiEntry) -> Void) {
        let entry = DafYomiEntry(date: Date(), data: fallbackDaf)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DafYomiEntry>) -> Void) {
        let entry = DafYomiEntry(date: Date(), data: fallbackDaf)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let midnight = Calendar.current.startOfDay(for: tomorrow)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
    
    func placeholder(in context: Context) -> DafYomiEntry {
        DafYomiEntry(date: Date(), data: fallbackDaf)
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
                SefiratHaOmerHomeEntryView(entry: OmerHomeEntryFactory.entry(for: entry.date))
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
            .systemSmall
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
