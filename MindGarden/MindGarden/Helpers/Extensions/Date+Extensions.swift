//
//  Date+Extensions.swift
//  MindGarden
//
//  Created by Dante Kim on 8/7/21.
//

import Foundation

extension Date {
    static func dayOfWeek(day: String, month: String, year: String)-> String{
        // Specify date components
        let userCalendar = Calendar.current // since the components above (like year 1980) are for Gregorian
        var dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: Int(year) ?? 0, month: Int(month) ?? 0, day: Int(day) ?? 0)
        // Create date from components
        let someDateTime = userCalendar.date(from: dateComponents)
        let dat = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: someDateTime ?? Date())
        return weekDay
     }
    func get(_ type: Calendar.Component)-> String {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return "\(t)"
    }

    func weekDayToInt(weekDay: String) -> Int {
        switch weekDay {
        case "Sun":
            return 0
        case "Mon":
            return 1
        case "Tue":
            return 2
        case "Wed":
            return 3
        case "Thu":
            return 4
        case "Fri":
            return 5
        case "Sat":
            return 6
        default:
            return 0
        }
    }

    func getNumberOfDays(month: String, year: String) -> Int {
        switch month {
        case "1":
            return 31
        case "2":
            if isLeapYear(Int(year) ?? 2000) {
                return 29
            } else {
                return 28
            }
        case "3":
            return 31
        case "4":
            return 30
        case "5":
            return 31
        case "6":
            return 30
        case "7":
            return 31
        case "8":
            return 31
        case "9":
            return 30
        case "10":
            return 31
        case "11":
            return 30
        case "12":
            return 31
        default:
            return -1
        }
    }

    func getMonthName(month: String) -> String {
        switch month {
        case "1":
            return "January"
        case "2":
           return "February"
        case "3":
            return "March"
        case "4":
            return "April"
        case "5":
            return "May"
        case "6":
            return "June"
        case "7":
            return "July"
        case "8":
            return "August"
        case "9":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
            return "-1"
        }
    }

    func getMonthNum(month: String) -> Int {
        switch month {
        case "Jan":
            return 1
        case "Feb":
            return 2
        case "Mar":
            return 3
        case "Apr":
            return 4
        case "May":
            return 5
        case "Jun":
            return 6
        case "Jul":
            return 7
        case "Aug":
            return 8
        case "Sep":
            return 9
        case "Oct":
            return 10
        case "Nov":
            return 11
        case "Dec":
            return 12
        default:
            return -1
        }

    }

    func intToMonth(num: Int) -> String {
        switch num {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return "Jan"

        }
    }
    func isLeapYear(_ year: Int) -> Bool {

        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))


        return isLeapYear
    }

}
