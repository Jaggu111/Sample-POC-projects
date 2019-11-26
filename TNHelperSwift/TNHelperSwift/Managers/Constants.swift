//
//  Constants.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import Foundation

enum UserStateType : String {
    case UnKnown = "UnKnown"
    case NotRegistered = "NotRegistered"
    case Registered = "Registered"
    case SigningIn = "SignIn"
    case SigningUp = "SignUp"
    case SigningUpFromDetail = "SigningUpFromDetail"
    case SigningUpFromReservations = "SigningUpFromReservations"
    case SigningUpFromNonDetail = "SigningUpFromNonDetail"
    case ParkingFlow = "ParkingFlow"
    case Reservations = "Reservations"
    case ReservationFlow = "ReservationFlow"
    case BrowsingApp = "BrowsingApp"
}

//Notification Constants
let SIGNUP_FLOW_DISMISSED_FROM_RESERVATION = "SignUpFlowHasBeenDismissedFromReservationDetailVC"
let SIGNUP_FLOW_DISMISSED_FROM_ON_DEMAND = "SignUpFlowHasBeenDismissedFromOnDemandDetailVC"

//Images
let ICON_RESERVATIONS_LIST_VIEW = "ReservationsListView"
let ICON_RESERVATIONS_MAP_VIEW = "ReservationsMapView"
let PLACEHOLDER_IMAGE = "Placeholder_Image"

//UserDefault keys
let CHOOSE_SLIDER_VC_CUSTOM_HEIGHT = "height"

//ViewControllers
let VC_EVENT_MAP_VIEW_CONTROLLER = "EventMapViewController"

//Button Titles
let BUTTON_TITLE_UPDATE_PAYMENT_METHOD = "UPDATE PAYMENT METHOD"
let BUTTON_TITLE_ADD_PAYMENT_METHOD = "ADD PAYMENT METHOD"

struct Constants {
    //globally used all through the app
    struct Global {
        static let park = "park"
        static let reserve = "reserve"
        static let permit = "Permits"
        static let reservations = "reservations"
        static let more = "more"
        static let activity = "activity"
        static let stopParking = "Stop Parking"
        static let cancel = "Cancel"
        static let CANCELED = "CANCELED"
        static let remoteConfigPlist = "RemoteConfigDefaults"
        static let appStoreURL = "https://itunes.apple.com/us/app/parkmobile-find-parking/id365399299?mt=8"
    }
    //tabs at bottom
    struct Tab {
        static let activityTab = "ActivityTab"
        static let parkTab = "ParkTab"
        static let moreTab = "MoreTab"
    }
    //parkZoneDetailViewController
    struct DetailsPage {
        static let freeParkingTitle = "Free Parking -"
    }
    
    //confirmationViewController
    struct ConfirmationPage {
        static let parkingWith = "YOU ARE PARKING WITH"
    }
    
    struct AddPromotion {
        static let added = "added"
    }
    
    struct Font {
        static let openSansBold = "OpenSans-Bold"
        static let openSansSemiBold = "OpenSans-Semibold"
        static let openSans = "OpenSans"
    }
    //VenueLandingEventsViewController - events view
    struct VenueLandingEventsView {
        //images
        static let iconCalender = "Icon_Calender"
        static let iconReservationGlobe = "Icon_Globe"
        static let iconNoZones = "Icon_NoZones"
        static let iconNoEvents = "Icon_NoEvents"
        //strings
        static let noResultFound = "No Results Found"
        static let noEventFound = "No Events Found"
        static let events = "events"
        static let lots = "lots"
    }
    struct Nib {
        static let ParkMobileProRegistrationView = "ParkMobileProRegistrationView"
    }
    struct Error {
        static let ShouldNotImplementFromStoryboard = "Shouldn't implement from storyboard"
        static let decodingFailed = "Failed to decode userInfo"
        static let modelNotExist = "Core Data Model should exist for proceeding"
    }
    struct Image {
        static let ParkMobileProRegistrationImage = "ParkMobileProRegistrationImage"
        static let bigCar = "Car_big"
    }
    
    struct Storyboard {
        static let moreTab = "MoreTab"
        static let login = "LoginRegister"
    }
    
    struct ControllerIdentifier {
        static let preferredMembership = "Preferred Membership View Controller"
        static let signIn = "Sign In View Controller"
        static let signUp = "Sign Up View Controller"
        static let pastSessionDetailParentNavigation = "PastSessionDetailNavigationController"
        static let reservationDetail = "ReservationDetailViewController"
    }
    
    struct ButtonTitles {
        static let notNow = "Not Now"
        static let learnMore = "Learn More"
        static let change = "CHANGE"
    }
    
    struct SDKKey {
        static let inrixAppId = "0dd396b9-4a86-4238-9315-c4371b55391c"
        static let inrixHashToken = "17e81233fd11112824f6b0463f095cfe098a0cdd"
    }
    
    struct QRCodeGenerator {
        static let filterName = "CIQRCodeGenerator"
        static let filterKey = "inputMessage"
        static let invertFilter = "CIColorInvert"
        static let alphaFilter = "CIMaskToAlpha"
    }
    
    struct NotificationName {
        static let signInTappedFromSignUp = Notification.Name("SignInTappedFromSignUp")
        static let signUpTappedFromSignIn = Notification.Name("SignUpTappedFromSignIn")
    }
    
    struct DictionaryKey {
        static let cancelledParkingAction = "hasCancelledParkingAction"
        static let bundleIdentifier = "CFBundleIdentifier"
        static let version = "CFBundleShortVersionString"
        static let managedObjectContext = "managedObjectContext"
    }
    
    struct TableViewCellIdentifier {
        static let pmCustomCell = "PMCustomTableViewCell"
    }
    
    enum LocalizedKey: String {
        case noHistoryTitle, noHistoryMessage, noUpcomingTitle, noUpcomingMessage, noActiveTitle,
            noActiveMessage, unAuthenticatedNoActivityMessage, createAnAccount, signInTitle, active,
            upcoming, history, cancel, update, forceUpdateTitle, enterZoneNumber, enterZoneOrSpaceNumber,
            noMatchingZones, noMatchingZonesErrorMessage, ok, done, spaceNumberTitle, enterSpaceNumber, tryAgain,
        requestFailureMessage, requestFailureTitle, guestPassTitle, guestPassSubTitle, guestPassNoCodeButtonTitle,inValidSignInTitle,inValidSignInMessage
    }
    
    enum RemoteConfigKey: String {
        case masterPassV7Feature, termsAndConditionsUrlQA, termsAndConditionsUrlPROD, privacyPolicyUrlQA, privacyPolicyUrlPROD, visaCheckoutApiKey_QA, visaCheckoutApiKey_PROD, zenDeskHelpUrl, shouldShowForceUpdate, forceUpdateMessage
    }
    
    enum CoreDataEntity: String {
        case parkingHistory, parkingAction, address, reservationIdentifier, vehicle, priceDetail, parkingZone, gPSPoint, addPromoError, zoneInfo, parkInfo, zoneRedemptionInstruction, zoneService, lotQuote, pricingLine, timeBlock, paymentOption, durationSelection, parkingTimeInformation, hourMinuteSelection, promotion
    }
}
