//
//  Validator+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import UIKit

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //never change this format unless required. Changing this needs to rework on this
        //get the date from the string
        return dateFormatter.date(from: self)
    }
    
    //this method will move the year part to the end of the string
    func moveYearToLast() -> String {
        let components = self.components(separatedBy: "-")
        return "\(components[1])/\(components.last!)/\(components.first!)"
    }
    
    func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //never change this format unless required. Changing this needs to rework on pulling the date and time objects below
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //first get the date from the received string
        if let date = dateFormatter.date(from: self) {
            //then set the date and time style to match the expected requirement
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .long
            //finally get the date in the string format
            let dateString = dateFormatter.string(from: date)
            if let day = dateString.components(separatedBy: ",").first?.prefix(3).uppercased() {
                return day
            }
        }
        return ""
    }
    
    func getDateInteger() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //never change this format unless required. Changing this needs to rework on pulling the date and time objects below
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //first get the date from the received string
        if let date = dateFormatter.date(from: self) {
            //then set the date and time style to match the expected requirement
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .long
            //finally get the date in the string format
            let dateString = dateFormatter.string(from: date)
            //separate the dateString into multiple Components so that we can extract what we need
            let components = dateString.components(separatedBy: ",")
            //pull out date component
            if let dateInt = components[1].components(separatedBy: " ").last {
                return dateInt
            }
        }
        return ""
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //never change this format unless required. Changing this needs to rework on pulling the date and time objects below
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //first get the date from the received string
        if let date = dateFormatter.date(from: self) {
            //then set the date and time style to match the expected requirement
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .long
            //finally get the date in the string format
            let dateString = dateFormatter.string(from: date)
            //separate the dateString into multiple Components so that we can extract what we need
            let components = dateString.components(separatedBy: ",")
            return components[1].components(separatedBy: " ")[1].prefix(3).uppercased()
        }
        return ""
    }
    
    func getTime(withTimeZone timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //never change this format unless required. Changing this needs to rework on pulling the date and time objects below
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = timeZone
        //first get the date from the received string
        if let date = dateFormatter.date(from: self) {
            //then set the date and time style to match the expected requirement
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .long
            //finally get the date in the string format
            let dateString = dateFormatter.string(from: date)
            //separate the dateString into multiple Components so that we can extract what we need
            let components = dateString.components(separatedBy: ",")
            //pull out start time component
            if let timeComponents = components.last?.components(separatedBy: "at ").last {
                let individualTimeComponents = timeComponents.components(separatedBy: " ")
                var finalTimeString = ""
                for component in individualTimeComponents {
                    if let firstIndividualComponent = individualTimeComponents.first, component == firstIndividualComponent {
                        let endIndex = firstIndividualComponent.index(firstIndividualComponent.endIndex, offsetBy: -3)
                        finalTimeString.append("\(String(firstIndividualComponent[..<endIndex])) ")
                    } else {
                        finalTimeString.append("\(component) ")
                    }
                }
                return finalTimeString
            }
        }
        return ""
    }
    
    func getNumberOfHoursTo(endDateString endDateStr: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //never change this format unless required. Changing this needs to rework on pulling the date and time objects below
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //first get the date from the received string
        if let startDate = dateFormatter.date(from: self),
            let endDate = dateFormatter.date(from: endDateStr) {
            return endDate.numberOfHours(from: startDate)
        }
        return nil
    }
    
    func apiErrorMessage() -> String {
        return "Check back soon for new \(self). In the meantime, look at the PARK tab to find Zoned Parking when you get to your destination."
    }
    
    /*This method returns the attributedString with passed bold words as arguments in between*/
    func convertToAttributedString(withSpecializationFor partsOfTheString: [String]) -> NSMutableAttributedString {
        let separatedStrings = self.components(separatedBy: partsOfTheString)
        let formattedString = NSMutableAttributedString(string: "")
        
        let count = partsOfTheString.count >= separatedStrings.count ? partsOfTheString.count : separatedStrings.count
        for i in 0..<count {
            if i < separatedStrings.count {
                formattedString.append(NSMutableAttributedString(string: separatedStrings[i]))
            }
            if i < partsOfTheString.count {
                let attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                                                           NSAttributedString.Key.font: UIFont(name:  Constants.Font.openSansBold, size: 15) as Any]
                formattedString.append(NSMutableAttributedString(string: partsOfTheString[i], attributes: attr))
            }
        }
        return formattedString
    }
    
    func appendFindParking() -> NSMutableAttributedString {
        let formattedString = NSMutableAttributedString(string: self)
        let attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.tnmobileBlue(),
                                                   NSAttributedString.Key.font: UIFont(name:  Constants.Font.openSansBold, size: 11) as Any]
        formattedString.append(NSMutableAttributedString(string: " FIND PARKING", attributes: attr))
        return formattedString
    }
    
    func components(separatedBy strings: [String]) -> [String] {
        var remaingingString: String? = self
        var returnStrings: [String] = []
        for string in strings {
            if let firstPartOfString = remaingingString?.components(separatedBy: string).first {
                returnStrings.append(firstPartOfString)
            }
            if let lastPartOfString = remaingingString?.components(separatedBy: string).last {
                remaingingString = lastPartOfString
            }
            
        }
        guard let leftOutStringInTheEnd = remaingingString else {
            return returnStrings
        }
        returnStrings.append(leftOutStringInTheEnd)
        return returnStrings
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var doubleValue: Double? {
        return Double(self)
    }
    
    var upperPrefix: String {
        return prefix(1).uppercased() + dropFirst()
    }
}
