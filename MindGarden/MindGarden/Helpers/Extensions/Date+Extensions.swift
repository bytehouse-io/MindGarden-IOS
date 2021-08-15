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
        var dateComponents = DateComponents()
        dateComponents.year = Int(day) ?? 0
        dateComponents.month = Int(month) ?? 0
        dateComponents.day = Int(year) ?? 0

        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        let someDateTime = userCalendar.date(from: dateComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
//        let weekDay = dateFormatter.string(from: )
        return "someDateTime"
     }
    func get(_ type: Calendar.Component)-> String {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return "\(t)"
    }

    func getNumberOfDays(month: String, year: String) -> Int {
        switch month {
        case "Jan":
            return 31
        case "Feb":
            if isLeapYear(Int(year) ?? 2000) {
                return 29
            } else {
                return 28
            }
        case "Mar":
            return 31
        case "Apr":
            return 30
        case "May":
            return 31
        case "Jun":
            return 30
        case "Jul":
            return 31
        case "Aug":
            return 31
        case "Sep":
            return 30
        case "Oct":
            return 31
        case "Nov":
            return 30
        case "Dec":
            return 31
        default:
            return -1
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
        case 0:
            return "Dec"
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
