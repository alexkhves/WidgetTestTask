//
//  CalendarWidgetPreviews.swift
//  CalendarWidgetExtension
//
//  Created by Alexey Hvesko on 01.05.2021.
//

import WidgetKit
import SwiftUI

struct CalendarWidget_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
