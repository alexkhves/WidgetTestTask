//
//  CalendarWidgetEntryView.swift
//  CalendarWidgetExtension
//
//  Created by Alexey Hvesko on 01.05.2021.
//

import WidgetKit
import SwiftUI
import EventKit

struct CalendarWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    @Environment(\.calendar) var calendar
      
      private var month: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
      }
    
    @State var calendarEvents : [String] = []

    var eventStore = EKEventStore()
    
    var entry: Provider.Entry
    var body: some View {
        
        switch family {
                case .systemSmall:
                    ZStack (alignment: .topLeading) {
                        GeometryReader { geo in
                            Image("background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        VStack (alignment: .leading, spacing: 0) {
                            Text(getDay())
                                .font(Font.custom("DancingScript-Regular", size: 24))
                                .padding(.top, 18)
                                .padding(.horizontal, 18)
                                .padding(.bottom, 24)
                            Text(getDate())
                                .font(Font.custom("DancingScript-Regular", size: 36))
                                .padding(.horizontal, 18)
                            Text(getMonth())
                                .font(Font.custom("DancingScript-Regular", size: 18))
                                .padding(.horizontal, 18)
                        }
                        Spacer()
                    }
                case .systemMedium:
                    ZStack (alignment: .topLeading) {
                        GeometryReader { geo in
                            Image("backgroundWide")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        CalendarView(interval: month) { date in
                              Text(String(self.calendar.component(.day, from: date)))
                                .font(Font.custom("DancingScript-Regular", size: 9))
                                .frame(width: 15, height: 15, alignment: .center)
                                .background(getOverlayForCurrentDay(date: date))
                            }
                    }
                default:
                    ZStack (alignment: .top) {
                        GeometryReader { geo in
                            Image("background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        CalendarView(interval: month) { date in
                              Text(String(self.calendar.component(.day, from: date)))
                                .font(Font.custom("DancingScript-Regular", size: 9))
                                .frame(width: 15, height: 15, alignment: .center)
                                .background(getOverlayForCurrentDay(date: date))
                            }
                    }
                }
    }
    
    func getTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: entry.date)
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: entry.date)
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: entry.date)
    }
    
    func isToday(date: Date) -> Bool {
        return self.calendar.component(.day, from: date) == self.calendar.component(.day, from: Date())
    }

    func getOverlayForCurrentDay(date: Date) -> some View {
        return
            AnyView(Circle()
            .foregroundColor(isToday(date: date) ? Color(red: 255 / 255, green: 195 / 255, blue: 195 / 255) : Color.clear)
            .clipShape(Circle())
            )
    }
    
    func getEvents(completionHandler: @escaping () -> Void) {
        eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
            if granted {
                let predicate = self.eventStore.predicateForEvents(withStart: Date(), end: Date(), calendars: nil)
                let events = self.eventStore.events(matching: predicate)
                for event in events {
                    self.calendarEvents.append(self.getTime(date: event.startDate) + " " + event.title)
                }
                completionHandler()
            }else{
                print("Access denied")
            }
        })
    }
    
}

