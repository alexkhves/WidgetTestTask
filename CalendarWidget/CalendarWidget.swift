//
//  CalendarWidget.swift
//  CalendarWidget
//
//  Created by Alexey Hvesko on 01.05.2021.
//

import WidgetKit
import SwiftUI

@main
struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar Widget")
        .description("This is a testTask widget.")
    }
}
