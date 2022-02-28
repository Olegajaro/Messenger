//
//  Date+Extensions.swift
//  Messenger
//
//  Created by Олег Федоров on 28.02.2022.
//

import Foundation

extension Date {
    
    func longDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
