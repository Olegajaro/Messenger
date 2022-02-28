//
//  GlobalFunctions.swift
//  Messenger
//
//  Created by Олег Федоров on 15.02.2022.
//

import Foundation

func fileNameFrom(fileUrl: String) -> String {
    
    let nameFirstChop = fileUrl.components(separatedBy: "_").last
    let nameSecondChop = nameFirstChop?.components(separatedBy: "?").first
    let nameThirdChop = nameSecondChop?.components(separatedBy: ".").first
    
    return nameThirdChop ?? ""
}

func timeElapsed(_ date: Date) -> String {
    
    let seconds = Date().timeIntervalSince(date)
    
    var elapsed = ""
    
    if seconds < 60 {
        elapsed = "Just now"
    } else if seconds < 60 * 60 {
        
        let minutes = Int(seconds / 60)
        let minText = minutes > 1 ? "mins" : "min"
        elapsed = " \(minutes) \(minText)"
        
    } else if seconds < 24 * 60 * 60 {
        
        let hours = Int(seconds / (60 * 60))
        let hourText = hours > 1 ? "hours" : "hour"
        elapsed = "\(hours) \(hourText)"
        
    } else {
        elapsed = date.longDate()
    }
    
    return elapsed
}
