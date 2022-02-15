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
