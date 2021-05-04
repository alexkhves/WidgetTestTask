//
//  CalendarWidgetView.swift
//  CalendarWidgetExtension
//
//  Created by Alexey Hvesko on 02.05.2021.
//

import SwiftUI

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.widgetFamily) var family
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let showHeaders: Bool
    let content: (Date) -> DateView

    init(
        interval: DateInterval,
        showHeaders: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
        self.showHeaders = showHeaders
        self.content = content
    }

    var body: some View {
        switch family {
            case .systemMedium:
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 80)), count: 7), spacing: 2) {
                    ForEach(months, id: \.self) { month in
                        Section(header: header(for: month)) {
                            ForEach(days(for: month), id: \.self) { date in
                                if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                    content(date).id(date)
                                } else {
                                    content(date).hidden()
                                }
                            }
                        }
                    }
                }
                .padding(.leading, 15)
                .padding(.trailing, 170)
                .padding(.top, 30)
                .padding(.bottom, 36)

            default:
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 80)), count: 7), spacing: 8.5) {
                    ForEach(months, id: \.self) { month in
                        Section(header: header(for: month)) {
                            ForEach(days(for: month), id: \.self) { date in
                                if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                    content(date).id(date)
                                } else {
                                    content(date).hidden()
                                }
                            }
                        }
                    }
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .padding(.top, 20)
                .padding(.bottom, 36)
        }
        
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    private func header(for month: Date) -> some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month

        return Group {
            if showHeaders {
                switch family {
                    case .systemMedium:
                    Text(formatter.string(from: month))
                        .font(Font.custom("DancingScript-Regular", size: 16))
                        .padding(.bottom, -10)
                
                        HStack {
                            setDays(text: "S", paddHor: 4.5, fontSize: 8)
                            setDays(text: "M", paddHor: 4.5, fontSize: 8)
                            setDays(text: "T", paddHor: 4.5, fontSize: 8)
                            setDays(text: "W", paddHor: 4.5, fontSize: 8)
                            setDays(text: "T", paddHor: 4.5, fontSize: 8)
                            setDays(text: "F", paddHor: 4.5, fontSize: 8)
                            setDays(text: "S", paddHor: 4.5, fontSize: 8)
                        }
                        .frame(width: 150, height: 22, alignment: .center)
                default:
                    Text(formatter.string(from: month))
                        .font(Font.custom("DancingScript-Regular", size: 18))
                        //.padding(.bottom, -10)
                        HStack {
                            setDays(text: "S", paddHor: 15, fontSize: 9)
                            setDays(text: "M", paddHor: 15, fontSize: 9)
                            setDays(text: "T", paddHor: 15, fontSize: 9)
                            setDays(text: "W", paddHor: 15, fontSize: 9)
                            setDays(text: "T", paddHor: 15, fontSize: 9)
                            setDays(text: "F", paddHor: 15, fontSize: 9)
                            setDays(text: "S", paddHor: 15, fontSize: 9)
                        }
                        .frame(width: 300, height: 22, alignment: .center)
                }
            }
        }
    }
    
    func setDays(text: String, paddHor: CGFloat, fontSize: CGFloat) -> some View {
        return Text(text)
            .font(Font.custom("DancingScript-Regular", size: fontSize))
            .foregroundColor(Color(red: 255 / 255, green: 112 / 255, blue: 103 / 255))
            .padding(.horizontal, paddHor)
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
    
    func setLargeGrid() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 80)), count: 7), spacing: 2) {
            ForEach(months, id: \.self) { month in
                Section(header: header(for: month)) {
                    ForEach(days(for: month), id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date).id(date)
                        } else {
                            content(date).hidden()
                        }
                    }
                }
            }
        }
        .padding(.leading, 15)
        .padding(.trailing, 170)
        .padding(.top, 30)
        .padding(.bottom, 36)
    }

    private func days(for month: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
}
