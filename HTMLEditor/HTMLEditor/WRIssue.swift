//
//  WRIssue.swift
//  
//
//  Created by Weerasooriya, Tulakshana on 12/9/16.
//  Copyright © 2016 Tulakshana. All rights reserved.
//

import Foundation

class WRIssue {
    
    var type:WRIssueType = WRIssueType.concision
    var explanation:String = "Sample details of the issue"
    
    init(issueType:WRIssueType, issueDetails:String) {
        type = issueType
        explanation = issueDetails
    }
    
    init() {
        //this is the constructor with default values
    }
    
    func getColorCode(type: WRIssueType) -> String {
        var colorCode = "wrpink"
        switch type {
        case .concision:
            colorCode = "wrpink"
        case .clarity:
            colorCode = "wrorange"
        case .logic:
            colorCode = "wrblue"
        case .grammar:
            colorCode = "wrgreen"
        case .spelling:
            colorCode = "wrred"
        }
        return colorCode
    }
}
