//
//  Date+Extension.swift
//  AstroPicDaily
//
//  Created by Nikhil Bhosale on 2024-05-11.
//

import Foundation

extension Date {
    var yyyyMMdd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func getPastDateBy(noOfDays: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -noOfDays, to: self)
    }
}
