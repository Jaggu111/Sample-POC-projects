//
//  HelperFunctions.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import Foundation
import UIKit

struct HelperFunctions {

    // get a random UUID token
    static func getRandomUUID() -> String {
        let stringWithDashes = UUID().uuidString
        // the above returns a string like "6AF1254C-ED2B-4E47-BFA4-939884FAB8DE"
        return stringWithDashes.replacingOccurrences(of: "-", with: "")
    }

    // Validate email when user is registering
    static func isEmailValid(withText email: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?"
        let matched = findMatches(for: emailRegEx, in: email)
        return matched.count > 0
    }
    
    // Check if password used during registration is valid
    // Password should have at least 8 characters of which at least one is a
    // number OR special characters such as @, % and !
    static func isPasswordValid(withText password: String) -> Bool {
//        let passwdRegex = Config.passwordValidationRegex ?? "(?=^.{8,100}$)(?=.*\\d)|(?=^.{8,100}$)(?=.*[@'#.$;%^&+=!\"()*,-/:<>?])"
//        let matched = findMatches(for: passwdRegex, in: password)
//        return matched.count > 0
        //check for numbers if any
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = password.rangeOfCharacter(from: decimalCharacters)
        //check for letters if any
        let stringCharacters = CharacterSet.letters
        let stringRange = password.rangeOfCharacter(from: stringCharacters)
        return password.count > 7 && stringRange != nil && decimalRange != nil
    }

    // pattern matching
    static func findMatches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    static func didFindSpecialCharacters(inString string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: string, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, string.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return false
    }
    
    // generating QR code image data
    static func getCIImage(usingString serial: String) -> CIImage? {
        guard let filter = CIFilter(name: Constants.QRCodeGenerator.filterName),
            let data = serial.data(using: .isoLatin1, allowLossyConversion: false) else {return nil}
        filter.setValue(data, forKey: Constants.QRCodeGenerator.filterKey)
        guard let ciImage = filter.outputImage else {return nil}
        let transformed = ciImage.transformed(by: CGAffineTransform.init(scaleX: 10, y: 10))
        let invertFilter = CIFilter(name: Constants.QRCodeGenerator.invertFilter)
        invertFilter?.setValue(transformed, forKey: kCIInputImageKey)
        let alphaFilter = CIFilter(name: Constants.QRCodeGenerator.alphaFilter)
        alphaFilter?.setValue(invertFilter?.outputImage, forKey: kCIInputImageKey)
        return alphaFilter?.outputImage
    }

}

//MARK: Global protocol

/**
 Used for all dismiss actions and an optional dictionary object and
 optional completion object are passed in required scenarios
 */
protocol DismissViewControllerDelegate: class {
    func dismissViewController(animated: Bool, info: [AnyHashable: Any]?, completion: (() -> ())?)
}

//MARK: Global functions
public func onMainAsync(action: @escaping () -> Void) {
    DispatchQueue.main.async {
        action()
    }
}

func customAnimate(forDuration duration: TimeInterval = 0, delay: TimeInterval = 0, options: UIView.AnimationOptions = .curveLinear, animations: @escaping () -> Void, completion: ((Bool)-> Void)? = nil) {
    UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
}

func customTransition(withView view: UIView, duration: TimeInterval = 0, options: UIView.AnimationOptions = [.transitionCrossDissolve], animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
    UIView.transition(with: view, duration: duration, options: options, animations: animations, completion: completion)
}

internal var isMPLSApp: Bool {
    var booleanValue = false
    #if MPLSPARKINGDEBUG || MPLSPARKINGRELEASE
    booleanValue = true
    #endif
    return booleanValue
}

internal var mainBundle: Bundle {
    return Bundle.main
}

//remove this method when all localized strings are moved in to localizable file
internal func LocalizedString(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}

internal func LocalizedString(_ key: Constants.LocalizedKey) -> String {
    return NSLocalizedString(key.rawValue, comment: "")
}

internal func startSpinning() {
    Spinner.startSpinning()
}

internal func stopSpinning() {
    Spinner.stopSpinning()
}

internal var isQA: Bool {
    var isDebug = false
    #if DEBUG || PREMIERPARKINGDEBUG || PARKLOUIEDEBUG || MKEPARKDEBUG || FWPARKDEBUG || METERUPDEBUG || PARKITCHARLOTTEDEBUG || PARKHOUSTONDEBUG || MAPCOMOBILEPAYDEBUG || PARKMEDFORDDEBUG || GOMOBILEPGHDEBUG || PARKLANCASTERDEBUG || MPLSPARKINGDEBUG || SEVENONESEVENDEBUG || PARKNOWDEBUG || PARKCOLUMBUSDEBUG || PARK915DEBUG
    isDebug = true
    #endif
    return isDebug
}

internal var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
