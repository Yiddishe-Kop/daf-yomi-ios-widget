//
//  SefiratHaOmerWidget.swift
//  today
//
//  Created by Codex on 02/05/2026.
//

import SwiftUI
import WidgetKit
import AppIntents

struct SefiratHaOmerEntry: TimelineEntry {
  let date: Date
  let day: Int?
  let nextUpdate: Date
  let isCounted: Bool
}

struct SefiratHaOmerProvider: TimelineProvider {
  private let calculator = OmerCalculator()
  private let countStore = OmerCountStore()

  func placeholder(in context: Context) -> SefiratHaOmerEntry {
    SefiratHaOmerEntry(
      date: Date(), day: 31, nextUpdate: calculator.nextSunset(after: Date()), isCounted: false)
  }

  func getSnapshot(in context: Context, completion: @escaping (SefiratHaOmerEntry) -> Void) {
    completion(entry(for: Date()))
  }

  func getTimeline(
    in context: Context, completion: @escaping (Timeline<SefiratHaOmerEntry>) -> Void
  ) {
    let entry = entry(for: Date())
    completion(Timeline(entries: [entry], policy: .after(entry.nextUpdate)))
  }

  private func entry(for date: Date) -> SefiratHaOmerEntry {
    let day = calculator.omerDay(for: date)

    return SefiratHaOmerEntry(
      date: date,
      day: day,
      nextUpdate: calculator.nextSunset(after: date),
      isCounted: countStore.isCounted(day: day, on: date)
    )
  }
}

struct SefiratHaOmerEntryView: View {
  var entry: SefiratHaOmerProvider.Entry

  @Environment(\.widgetFamily) var family

  private var hebrewDay: String {
    guard let day = entry.day else {
      return "-"
    }

    return Shas.arabicToHebrew(num: day)
  }

  private var countOpacity: Double {
    entry.isCounted ? 1.0 : 0.5
  }

  var body: some View {
    widgetContent
      .widgetBackground(backgroundView: Color.clear)
  }

  @ViewBuilder
  private var widgetContent: some View {
    switch family {
    case .accessoryInline:
      HStack {
        Image(systemName: "sunset.fill")
        Text("\(hebrewDay) לעמר")
      }
    case .accessoryCircular:
      ZStack(alignment: .topTrailing) {
        OmerProgressGrid(day: entry.day ?? 0)
          .frame(width: 48, height: 48)
          .opacity(0.55)

        Text(hebrewDay)
          .font(Font.custom("SiddurOC-Black", size: 25))
          .foregroundStyle(.white)
          .padding(.top, 3)
          .padding(.trailing, 4)
          .offset(x: 16, y: 0)
      }
      .frame(width: 58, height: 58)
    case .accessoryRectangular:
      HStack(alignment: .center, spacing: 10) {
        OmerProgressGrid(day: entry.day ?? 0, cellSize: 4.75, spacing: 2.75)
          .frame(width: 50, height: 50)

        Text("\(hebrewDay) לעמר")
          .font(Font.custom("SiddurOC-Black", size: 28))
          .foregroundStyle(.gray800)
          .lineLimit(1)
          .minimumScaleFactor(0.65)
          .frame(width: 86, alignment: .trailing)
          .offset(y: -4)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .environment(\.layoutDirection, .rightToLeft)
    default:
      VStack(spacing: 8) {
        Text(hebrewDay)
          .font(Font.custom("SiddurOC-Black", size: 54))
          .foregroundStyle(.orange)
        OmerProgressGrid(day: entry.day ?? 0, cellSize: 8, spacing: 4)
          .frame(width: 80, height: 80)
      }
    }
  }
}

struct OmerProgressGrid: View {
  let day: Int
  let cellSize: CGFloat
  let spacing: CGFloat
  let completedColor: Color
  let pendingColor: Color

  init(
    day: Int,
    cellSize: CGFloat = 4,
    spacing: CGFloat = 3,
    completedColor: Color = Color.gray800,
    pendingColor: Color = Color.gray800.opacity(0.22)
  ) {
    self.day = day
    self.cellSize = cellSize
    self.spacing = spacing
    self.completedColor = completedColor
    self.pendingColor = pendingColor
  }

  private var columns: [GridItem] {
    Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: 7)
  }

  var body: some View {
    LazyVGrid(columns: columns, spacing: spacing) {
      ForEach(1...49, id: \.self) { index in
        if index == 33 {
          Image(systemName: "flame.fill")
            .font(.system(size: cellSize * 1.75, weight: .bold))
            .foregroundStyle(
              LinearGradient(
                colors: [
                  Color(red: 1.0, green: 0.95, blue: 0.18),
                  Color(red: 1.0, green: 0.48, blue: 0.0),
                  Color(red: 0.95, green: 0.08, blue: 0.02),
                ],
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .shadow(color: Color(red: 1.0, green: 0.42, blue: 0.0).opacity(0.78), radius: cellSize * 0.42)
            .frame(width: cellSize, height: cellSize)
        } else {
          RoundedRectangle(cornerRadius: cellSize * 0.35, style: .continuous)
            .fill(index <= day ? completedColor : pendingColor)
            .frame(width: cellSize, height: cellSize)
        }
      }
    }
    .environment(\.layoutDirection, .rightToLeft)
  }
}

struct SefiratHaOmerWidget: Widget {
  let kind: String = "SefiratHaOmerWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: SefiratHaOmerProvider()) { entry in
      SefiratHaOmerEntryView(entry: entry)
    }
    .configurationDisplayName("ספירת העומר")
    .description("הצג את היום הנוכחי בספירת העומר")
    .supportedFamilies([
      .accessoryCircular,
      .accessoryInline,
      .accessoryRectangular,
    ])
  }
}

struct SefiratHaOmerCircularEntryView: View {
  var entry: SefiratHaOmerProvider.Entry

  @Environment(\.widgetFamily) var family

  private var hebrewDay: String {
    guard let day = entry.day else {
      return "-"
    }

    return Shas.arabicToHebrew(num: day)
  }

  private var progressValue: Double {
    Double(entry.day ?? 0)
  }

  var body: some View {
    widgetContent
      .widgetBackground(backgroundView: Color.clear)
  }

  @ViewBuilder
  private var widgetContent: some View {
    switch family {
    case .accessoryInline:
      HStack {
        Image(systemName: "sunset.fill")
        Text("\(hebrewDay) לעמר")
      }
    case .accessoryCircular:
      ZStack {
        OmerCircularGaugeRing(progress: progressValue / 49.0)

        Text(hebrewDay)
          .font(Font.custom("SiddurOC-Black", size: 34))
          .foregroundStyle(.gray800)
          .offset(y: -6)

        Text("לעמר")
          .font(Font.custom("SiddurOC-Regular", size: 16))
          .foregroundStyle(.gray800)
          .offset(y: 24)
      }
    case .accessoryRectangular:
      SefiratHaOmerEntryView(entry: entry)
    default:
      SefiratHaOmerEntryView(entry: entry)
    }
  }

}

struct OmerCircularGaugeRing: View {
  let progress: Double

  private let startAngle = 135.0
  private let endAngle = 405.0
  private let lagBaOmerProgress = 33.0 / 49.0
  private let lagBaOmerGap = 18.0

  private var clampedProgress: Double {
    min(max(progress, 0), 1)
  }

  var body: some View {
    ZStack {
      OmerGaugeArc(startAngle: startAngle, endAngle: lagBaOmerAngle - lagBaOmerGap)
        .stroke(.gray800.opacity(0.34), style: StrokeStyle(lineWidth: 6, lineCap: .round))

      OmerGaugeArc(startAngle: lagBaOmerAngle + lagBaOmerGap, endAngle: endAngle)
        .stroke(.gray800.opacity(0.34), style: StrokeStyle(lineWidth: 6, lineCap: .round))

      progressArc

      lagBaOmerFlame
    }
    .frame(width: 52, height: 52)
  }

  @ViewBuilder
  private var progressArc: some View {
    if progressAngle <= lagBaOmerAngle - lagBaOmerGap {
      OmerGaugeArc(startAngle: startAngle, endAngle: progressAngle)
        .stroke(.gray800.opacity(0.82), style: StrokeStyle(lineWidth: 6, lineCap: .round))
    } else if progressAngle <= lagBaOmerAngle + lagBaOmerGap {
      OmerGaugeArc(startAngle: startAngle, endAngle: lagBaOmerAngle - lagBaOmerGap)
        .stroke(.gray800.opacity(0.82), style: StrokeStyle(lineWidth: 6, lineCap: .round))
    } else {
      OmerGaugeArc(startAngle: startAngle, endAngle: lagBaOmerAngle - lagBaOmerGap)
        .stroke(.gray800.opacity(0.82), style: StrokeStyle(lineWidth: 6, lineCap: .round))

      OmerGaugeArc(startAngle: lagBaOmerAngle + lagBaOmerGap, endAngle: progressAngle)
        .stroke(.gray800.opacity(0.82), style: StrokeStyle(lineWidth: 6, lineCap: .round))
    }
  }

  private var progressAngle: Double {
    startAngle + ((endAngle - startAngle) * clampedProgress)
  }

  private var lagBaOmerAngle: Double {
    startAngle + ((endAngle - startAngle) * lagBaOmerProgress)
  }

  private var lagBaOmerFlame: some View {
    markerFlame(size: 7.5)
      .foregroundStyle(.white)
  }

  private func markerFlame(size: CGFloat) -> some View {
    let angle = Angle.degrees(lagBaOmerAngle)
    let radius: CGFloat = 26
    let x = cos(angle.radians) * radius
    let y = sin(angle.radians) * radius

    return Image(systemName: "flame.fill")
      .font(.system(size: size, weight: .black))
      .frame(width: 11, height: 11)
      .offset(x: x, y: y)
  }
}

struct OmerGaugeArc: Shape {
  let startAngle: Double
  let endAngle: Double

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let radius = min(rect.width, rect.height) / 2
    let center = CGPoint(x: rect.midX, y: rect.midY)

    path.addArc(
      center: center,
      radius: radius,
      startAngle: .degrees(startAngle),
      endAngle: .degrees(endAngle),
      clockwise: false
    )

    return path
  }
}

struct SefiratHaOmerCircularWidget: Widget {
  let kind: String = "SefiratHaOmerCircularWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: SefiratHaOmerProvider()) { entry in
      SefiratHaOmerCircularEntryView(entry: entry)
    }
    .configurationDisplayName("ספירת העומר - עיגול")
    .description("הצג את ספירת העומר בסגנון מד עגול")
    .supportedFamilies([
      .accessoryCircular,
      .accessoryInline,
      .accessoryRectangular,
    ])
  }
}

struct SefiratHaOmerHomeWidget: Widget {
  let kind: String = "SefiratHaOmerHomeWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: SefiratHaOmerProvider()) { entry in
      SefiratHaOmerHomeEntryView(entry: entry)
    }
    .configurationDisplayName("ספירת העומר - תזכורת")
    .description("תזכורת יומית לספור את העומר עם סימון לאחר הספירה")
    .supportedFamilies([
      .systemSmall,
      .systemMedium,
      .systemLarge,
    ])
  }
}

struct SefiratHaOmerHomeEntryView: View {
  var entry: SefiratHaOmerProvider.Entry

  @Environment(\.widgetFamily) var family

  private var hebrewDay: String {
    guard let day = entry.day else {
      return "-"
    }

    return Shas.arabicToHebrew(num: day)
  }

  private var progress: Double {
    Double(entry.day ?? 0) / 49.0
  }

  private var countText: String {
    "\u{202B}\(hebrewDay) לעמר\u{202C}"
  }

  private var countOpacity: Double {
    entry.isCounted ? 1.0 : 0.5
  }

  var body: some View {
    ZStack {
      switch family {
      case .systemMedium:
        mediumContent
      case .systemLarge:
        largeContent
      default:
        smallContent
      }
    }
    .widgetBackground(backgroundView: OmerWheatBackdrop())
  }

  private var smallContent: some View {
    ZStack {
      VStack(alignment: .trailing, spacing: 8) {
        Spacer(minLength: 0)

        countRow(fontSize: 42, minScale: 0.65)
      }

      cornerActionButton
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .offset(x: -4, y: -4)
    }
    .padding(14)
  }

  private var mediumContent: some View {
    ZStack {
      VStack {
        HStack(alignment: .top) {
          Spacer(minLength: 0)

          homeProgressGrid(cellSize: 4.5, spacing: 2.6)
            .frame(width: 58, height: 58)
        }

        Spacer(minLength: 0)
      }

      VStack(alignment: .trailing, spacing: 0) {
        Spacer(minLength: 26)
        countRow(fontSize: 42, minScale: 0.65)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

      actionButton
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
    .padding(14)
  }

  private var largeContent: some View {
    ZStack {
      VStack(alignment: .trailing, spacing: 14) {
        HStack(alignment: .top) {
          homeProgressGrid(cellSize: 6.9, spacing: 3.8)
            .frame(width: 92, height: 92)

          Spacer(minLength: 12)
        }

        Spacer(minLength: 0)

        countRow(fontSize: 72, minScale: 0.6)
      }

      cornerActionButton
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    .padding(18)
  }

  private func countRow(fontSize: CGFloat, minScale: CGFloat) -> some View {
    HStack(alignment: .center, spacing: 8) {
      Text(countText)
        .font(Font.custom("SiddurOC-Black", size: fontSize))
        .foregroundStyle(.white.opacity(countOpacity))
        .lineLimit(1)
        .minimumScaleFactor(minScale)
    }
    .environment(\.layoutDirection, .rightToLeft)
    .frame(maxWidth: .infinity, alignment: .trailing)
  }

  @ViewBuilder
  private var statusPill: some View {
    if entry.isCounted {
      Button(intent: ToggleOmerCountIntent()) {
        statusPillLabel
      }
      .buttonStyle(.plain)
    } else {
      statusPillLabel
    }
  }

  private var statusPillLabel: some View {
    Label(entry.isCounted ? "נספר" : "לספור", systemImage: entry.isCounted ? "checkmark.seal.fill" : "exclamationmark.circle.fill")
      .font(.system(size: 13, weight: .bold, design: .rounded))
      .foregroundStyle(.white)
      .labelStyle(.titleAndIcon)
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(
        .ultraThinMaterial,
        in: Capsule()
      )
      .background(
        (entry.isCounted ? Color.green : Color.orange).opacity(0.16),
        in: Capsule()
      )
      .overlay {
        Capsule()
          .stroke(.white.opacity(0.34), lineWidth: 1)
      }
      .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
  }

  private func homeProgressGrid(cellSize: CGFloat, spacing: CGFloat) -> some View {
    OmerProgressGrid(
      day: entry.day ?? 0,
      cellSize: cellSize,
      spacing: spacing,
      completedColor: .white.opacity(0.92),
      pendingColor: .white.opacity(0.28)
    )
  }

  @ViewBuilder
  private var actionButton: some View {
    if entry.day == nil {
      Text("מחוץ לימי הספירה")
        .font(.system(size: 13, weight: .semibold, design: .rounded))
        .foregroundStyle(.white.opacity(0.9))
        .lineLimit(1)
    } else {
      Button(intent: ToggleOmerCountIntent()) {
        Image(systemName: entry.isCounted ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
          .font(.system(size: 24, weight: .bold))
          .foregroundStyle(.white)
          .frame(width: 40, height: 40)
          .background(.ultraThinMaterial, in: Circle())
          .background((entry.isCounted ? Color.green : Color.orange).opacity(entry.isCounted ? 0.18 : 0.28), in: Circle())
          .overlay {
            Circle()
              .stroke(.white.opacity(0.34), lineWidth: 1)
          }
          .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
      }
      .buttonStyle(.plain)
    }
  }

  @ViewBuilder
  private var cornerActionButton: some View {
    if entry.day == nil {
      Text("מחוץ לימי הספירה")
        .font(.system(size: 13, weight: .semibold, design: .rounded))
        .foregroundStyle(.white.opacity(0.9))
        .lineLimit(1)
    } else {
      Button(intent: ToggleOmerCountIntent()) {
        Image(systemName: entry.isCounted ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
          .font(.system(size: 24, weight: .bold))
          .foregroundStyle(.white)
          .frame(width: 40, height: 40)
          .background(.ultraThinMaterial, in: Circle())
          .background((entry.isCounted ? Color.green : Color.orange).opacity(entry.isCounted ? 0.18 : 0.28), in: Circle())
          .overlay {
            Circle()
              .stroke(.white.opacity(0.34), lineWidth: 1)
          }
          .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
      }
      .buttonStyle(.plain)
    }
  }
}

struct OmerWheatBackdrop: View {
  var body: some View {
    ZStack {
      Image("OmerWheatBackdrop")
        .resizable()
        .scaledToFill()

      LinearGradient(
        colors: [
          Color.black.opacity(0.08),
          Color.black.opacity(0.36),
          Color.black.opacity(0.62),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )

      LinearGradient(
        colors: [
          Color(red: 1.0, green: 0.75, blue: 0.24).opacity(0.28),
          Color.clear,
        ],
        startPoint: .topTrailing,
        endPoint: .center
      )
    }
  }
}

struct OmerCountStore {
  private let countedDayKey = "SefiratHaOmerCountedDay"
  private let countedYearKey = "SefiratHaOmerCountedHebrewYear"
  private let calculator = OmerCalculator()

  func markCounted(on date: Date = Date()) {
    guard let day = calculator.omerDay(for: date) else {
      return
    }

    UserDefaults.standard.set(day, forKey: countedDayKey)
    UserDefaults.standard.set(hebrewYear(for: date), forKey: countedYearKey)
  }

  func toggleCounted(on date: Date = Date()) {
    let day = calculator.omerDay(for: date)

    if isCounted(day: day, on: date) {
      UserDefaults.standard.removeObject(forKey: countedDayKey)
      UserDefaults.standard.removeObject(forKey: countedYearKey)
    } else {
      markCounted(on: date)
    }
  }

  func isCounted(day: Int?, on date: Date = Date()) -> Bool {
    guard let day else {
      return false
    }

    return UserDefaults.standard.integer(forKey: countedDayKey) == day
      && UserDefaults.standard.integer(forKey: countedYearKey) == hebrewYear(for: date)
  }

  private func hebrewYear(for date: Date) -> Int {
    var calendar = Calendar(identifier: .hebrew)
    calendar.timeZone = .current
    return calendar.component(.year, from: date)
  }
}

struct ToggleOmerCountIntent: AppIntent {
  static var title: LocalizedStringResource = "Toggle Omer Counted"
  static var description = IntentDescription("Toggle today's Omer count.")

  func perform() async throws -> some IntentResult {
    OmerCountStore().toggleCounted()
    WidgetCenter.shared.reloadTimelines(ofKind: "SefiratHaOmerHomeWidget")
    WidgetCenter.shared.reloadTimelines(ofKind: "MyWidget")
    return .result()
  }
}

struct OmerHomeEntryFactory {
  static func entry(for date: Date = Date()) -> SefiratHaOmerEntry {
    let calculator = OmerCalculator()
    let day = calculator.omerDay(for: date)

    return SefiratHaOmerEntry(
      date: date,
      day: day,
      nextUpdate: calculator.nextSunset(after: date),
      isCounted: OmerCountStore().isCounted(day: day, on: date)
    )
  }
}

struct OmerCalculator {
  private let sunsetHour = 18
  private let timeZone = TimeZone.current
  private let hebrewCalendar: Calendar = {
    var calendar = Calendar(identifier: .hebrew)
    calendar.timeZone = .current
    return calendar
  }()

  private let localCalendar: Calendar = {
    var calendar = Calendar.current
    calendar.timeZone = .current
    return calendar
  }()

  func omerDay(for date: Date) -> Int? {
    let omerDate = dateForOmerBoundary(at: date)
    let hebrewYear = hebrewCalendar.component(.year, from: omerDate)

    guard
      let start = hebrewCalendar.date(
        from: DateComponents(calendar: hebrewCalendar, year: hebrewYear, month: 8, day: 16)),
      let end = hebrewCalendar.date(byAdding: .day, value: 48, to: start)
    else {
      return nil
    }

    guard omerDate >= start && omerDate <= end else {
      return nil
    }

    let components = hebrewCalendar.dateComponents([.day], from: start, to: omerDate)
    return (components.day ?? 0) + 1
  }

  func nextSunset(after date: Date) -> Date {
    let todaySunset = sunset(on: date)
    if date < todaySunset {
      return todaySunset
    }

    let tomorrow =
      localCalendar.date(byAdding: .day, value: 1, to: date)
      ?? date.addingTimeInterval(24 * 60 * 60)
    return sunset(on: tomorrow)
  }

  private func dateForOmerBoundary(at date: Date) -> Date {
    if date >= sunset(on: date) {
      return localCalendar.date(byAdding: .day, value: 1, to: date) ?? date
    }

    return date
  }

  private func sunset(on date: Date) -> Date {
    if let calculatedSunset = calculatedSunset(on: date) {
      return calculatedSunset
    }

    let startOfDay = localCalendar.startOfDay(for: date)
    return localCalendar.date(byAdding: .hour, value: sunsetHour, to: startOfDay) ?? date
  }

  private func calculatedSunset(on date: Date) -> Date? {
    guard let location = TimeZoneSunsetLocation.location(for: timeZone.identifier),
      let dayOfYear = localCalendar.ordinality(of: .day, in: .year, for: date)
    else {
      return nil
    }

    let longitudeHour = location.longitude / 15
    let approximateTime = Double(dayOfYear) + ((18 - longitudeHour) / 24)
    let meanAnomaly = (0.9856 * approximateTime) - 3.289
    let trueLongitude = normalizedDegrees(
      meanAnomaly
        + (1.916 * sin(degreesToRadians(meanAnomaly)))
        + (0.020 * sin(degreesToRadians(2 * meanAnomaly)))
        + 282.634
    )

    var rightAscension = radiansToDegrees(atan(0.91764 * tan(degreesToRadians(trueLongitude))))
    rightAscension = normalizedDegrees(rightAscension)
    rightAscension += floor(trueLongitude / 90) * 90 - floor(rightAscension / 90) * 90
    rightAscension /= 15

    let sinDeclination = 0.39782 * sin(degreesToRadians(trueLongitude))
    let cosDeclination = cos(asin(sinDeclination))
    let zenith = 90.833
    let cosHourAngle =
      (cos(degreesToRadians(zenith))
        - (sinDeclination * sin(degreesToRadians(location.latitude))))
      / (cosDeclination * cos(degreesToRadians(location.latitude)))

    guard cosHourAngle >= -1 && cosHourAngle <= 1 else {
      return nil
    }

    let hourAngle = radiansToDegrees(acos(cosHourAngle)) / 15
    let localMeanTime = hourAngle + rightAscension - (0.06571 * approximateTime) - 6.622
    let utcHour = normalizedHours(localMeanTime - longitudeHour)
    let offsetHour = Double(timeZone.secondsFromGMT(for: date)) / 3600
    let localHour = normalizedHours(utcHour + offsetHour)

    let hour = Int(localHour)
    let minuteDecimal = (localHour - Double(hour)) * 60
    let minute = Int(minuteDecimal)
    let second = Int((minuteDecimal - Double(minute)) * 60)

    return localCalendar.date(
      bySettingHour: hour,
      minute: minute,
      second: second,
      of: localCalendar.startOfDay(for: date)
    )
  }

  private func normalizedDegrees(_ degrees: Double) -> Double {
    let result = degrees.truncatingRemainder(dividingBy: 360)
    return result < 0 ? result + 360 : result
  }

  private func normalizedHours(_ hours: Double) -> Double {
    let result = hours.truncatingRemainder(dividingBy: 24)
    return result < 0 ? result + 24 : result
  }

  private func degreesToRadians(_ degrees: Double) -> Double {
    degrees * .pi / 180
  }

  private func radiansToDegrees(_ radians: Double) -> Double {
    radians * 180 / .pi
  }
}

struct TimeZoneSunsetLocation {
  let latitude: Double
  let longitude: Double

  static func location(for identifier: String) -> TimeZoneSunsetLocation? {
    locations[identifier]
  }

  private static let locations: [String: TimeZoneSunsetLocation] = [
    "Asia/Jerusalem": TimeZoneSunsetLocation(latitude: 31.778, longitude: 35.235),
    "America/New_York": TimeZoneSunsetLocation(latitude: 40.7128, longitude: -74.0060),
    "America/Detroit": TimeZoneSunsetLocation(latitude: 42.3314, longitude: -83.0458),
    "America/Toronto": TimeZoneSunsetLocation(latitude: 43.6532, longitude: -79.3832),
    "America/Chicago": TimeZoneSunsetLocation(latitude: 41.8781, longitude: -87.6298),
    "America/Denver": TimeZoneSunsetLocation(latitude: 39.7392, longitude: -104.9903),
    "America/Los_Angeles": TimeZoneSunsetLocation(latitude: 34.0522, longitude: -118.2437),
    "Europe/London": TimeZoneSunsetLocation(latitude: 51.5072, longitude: -0.1276),
    "Europe/Paris": TimeZoneSunsetLocation(latitude: 48.8566, longitude: 2.3522),
    "Europe/Berlin": TimeZoneSunsetLocation(latitude: 52.5200, longitude: 13.4050),
    "Europe/Zurich": TimeZoneSunsetLocation(latitude: 47.3769, longitude: 8.5417),
    "Europe/Vienna": TimeZoneSunsetLocation(latitude: 48.2082, longitude: 16.3738),
    "Europe/Brussels": TimeZoneSunsetLocation(latitude: 50.8503, longitude: 4.3517),
    "Europe/Amsterdam": TimeZoneSunsetLocation(latitude: 52.3676, longitude: 4.9041),
    "Australia/Melbourne": TimeZoneSunsetLocation(latitude: -37.8136, longitude: 144.9631),
    "Australia/Sydney": TimeZoneSunsetLocation(latitude: -33.8688, longitude: 151.2093),
    "Africa/Johannesburg": TimeZoneSunsetLocation(latitude: -26.2041, longitude: 28.0473),
  ]
}

struct SefiratHaOmerWidget_Previews: PreviewProvider {
  static var previews: some View {
    SefiratHaOmerEntryView(entry: SefiratHaOmerEntry(date: Date(), day: 31, nextUpdate: Date(), isCounted: false))
      .previewContext(WidgetPreviewContext(family: .accessoryCircular))
      .previewDisplayName("Omer Grid Circular")
    SefiratHaOmerCircularEntryView(entry: SefiratHaOmerEntry(date: Date(), day: 31, nextUpdate: Date(), isCounted: false))
      .previewContext(WidgetPreviewContext(family: .accessoryCircular))
      .previewDisplayName("Omer Gauge Circular")
    SefiratHaOmerEntryView(entry: SefiratHaOmerEntry(date: Date(), day: 31, nextUpdate: Date(), isCounted: false))
      .previewContext(WidgetPreviewContext(family: .accessoryInline))
      .previewDisplayName("Inline")
    SefiratHaOmerEntryView(entry: SefiratHaOmerEntry(date: Date(), day: 31, nextUpdate: Date(), isCounted: false))
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
      .previewDisplayName("Rectangular")
    SefiratHaOmerHomeEntryView(entry: SefiratHaOmerEntry(date: Date(), day: 31, nextUpdate: Date(), isCounted: false))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
      .previewDisplayName("Omer Home Small")
    SefiratHaOmerHomeEntryView(entry: SefiratHaOmerEntry(date: Date(), day: 31, nextUpdate: Date(), isCounted: false))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
      .previewDisplayName("Omer Home Medium")
    SefiratHaOmerHomeEntryView(entry: SefiratHaOmerEntry(date: Date(), day: 31, nextUpdate: Date(), isCounted: true))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
      .previewDisplayName("Omer Home Counted")
    SefiratHaOmerHomeEntryView(entry: SefiratHaOmerEntry(date: Date(), day: 31, nextUpdate: Date(), isCounted: true))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
      .previewDisplayName("Omer Home Large Counted")
  }
}
