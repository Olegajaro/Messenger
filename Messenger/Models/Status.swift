//
//  Status.swift
//  Messenger
//
//  Created by Олег Федоров on 15.02.2022.
//

import Foundation

enum Status: String, CaseIterable {
    
    case available = "Available"
    case busy = "Busy"
    case atSchool = "At School"
    case atTheMovies = "At the Movies"
    case atWork = "At Work"
    case batteryAboutToDie = "Battery about to die"
    case cantTalk = "Can't Talk"
    case inAMeeting = "In a Meeting"
    case atTheGym = "At the Gym"
    case sleeping = "Sleeping"
    case urgentCallsOnly = "Urgent calls only"
    
    static var allStatuses: [String] {
        Status.allCases.map { $0.rawValue }
    } 
}
