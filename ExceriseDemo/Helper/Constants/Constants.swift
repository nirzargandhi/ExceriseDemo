//
//  Constants.swift

//MARK: - Colors
extension UIColor {
    
    class func appBlack() -> UIColor { return UIColor(named: "AppBlack")! }
    class func appGray() -> UIColor { return UIColor(named: "AppGray")! }
    class func appRed() -> UIColor { return UIColor(named: "AppRed")! }
}

// MARK: - Global
enum GlobalConstants {
    
    static let appName    = Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}

//MARK: - StoryBoard Identifier's
enum AllStoryBoard {
    
    static let Main = UIStoryboard(name: "Main", bundle: nil)
}

//MARK: - ViewController Names
enum ViewControllerName {
    
    static let kGetReadyVC = "GetReadyVC"
    static let kFoodMenuVC = "FoodMenuVC"
    static let kFoodDetailVC = "FoodDetailVC"
}

//MARK: - Cell Identifiers
enum CellIdentifiers {
    
}

//MARK: - Message's
enum AlertMessage {
    
    //In Progress Message
    static let msgInProgress = "In Progress"
    
    //Internet Connection Message
    static let msgNetworkConnection = "You are not connected to internet. Please connect and try again"
    
    //Camera, Images and ALbums Related Messages
    static let msgPhotoLibraryPermission = "Please enable access for photos from Privacy Settings"
    static let msgCameraPermission = "Please enable camera access from Privacy Settings"
    static let msgNoCamera = "Device has no camera"
    static let msgImageSaveIssue = "Photo is unable to save in your local storage. Please check storage or try after some time"
    static let msgSelectPhoto = "Please select photo"
    
    //General Error Message
    static let msgError = "Something went wrong. Please try after sometime"
    
    //Video Error Message
    static let msgVideoUnavailable = "Video is not available for this location"
    
    //Validation Message
    static let msgTourname = "Please enter tour name"
    
    //General Delete Message
    static let msgGeneralDelete = "Are you sure you want to delete?"
    
    //Save - Success and Fail Message
    static let msgSaveSuccess = "Tour has been saved successfully"
    static let msgSaveFailed = "Unable to save tour. Please try again after sometime"
    
    //Logout Message
    static let msgLogout = "Are you sure you want to log out from the application?"
}

//MARK: - Web Service URLs
enum WebServiceURL {
    
    static let mainURL = ""
}

//MARK: - Web Service Parameters
enum WebServiceParameter {
    
}

//MARK: - UserDefault
enum UserDefault {
    
    static let kAPIToken = "api_token"
    static let kIsKeyChain = "isKeyChain"
}

//MARK: - Constants
struct Constants {
    
    //MARK: - Device Type
    enum UIUserInterfaceIdiom : Int {
        
        case Unspecified
        case Phone
        case Pad
    }
    
    //MARK: - Screen Size
    struct ScreenSize {
        
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
}

//MARK: - DateTime Format
enum DateAndTimeFormatString {
    
    static let strDateFormate_ddMMMyyyyhhmmss = "dd MMM yyyy hh:mm:ss a"
    static let strDateFormate_ddMMMyyyy = "dd MMM yyyy"
    static let strDateFormate_hhmma = "hh:mm a"
}

