//
//  AppIconManager.swift
//  DynamicAppIcon
//
//  Created by Husnain Ali on 29/06/24.
//

import UIKit
//import FirebaseRemoteConfig

enum Icon: String, CaseIterable{
    case AppleTV
    case Appstore
    case Calculator
    case Facetime
    case Help
    case Maps
    case Music
    case News
    case Shazam
    
    static var icons: [Icon] {
        Array(self.allCases)
    }
}

class AppIconManager {
    
    // the current app icon name
    private var currentAppIcon: String?{
        UIApplication.shared.alternateIconName
    }
    
    func setAppIcon(_ icon: String?) {
        if currentAppIcon != icon{
            setAppIconWithAlert(icon)
        } else {
            print("Same as current app icon.")
        }
    }
    
    // This method wont show an alert while setting the app icon (Not safe, might crash if the Apple changes the method)
    private func setAppIconWithoutAlert(_ iconName: String?) {
        if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons{
            typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()
            let selectorString = "_setAlternateIconName:completionHandler:"
            let selector = NSSelectorFromString(selectorString)
            let imp = UIApplication.shared.method(for: selector)
            let method = unsafeBitCast(imp, to: setAlternateIconName.self)
            method(UIApplication.shared, selector, iconName as NSString?, { _ in })
        }
    }
    
    // Recommended approch but will show an Alert to the user.
    private func setAppIconWithAlert(_ iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if error == nil{
                print("The app icon has been successfully set.")
            }else{
                print("Could not set app icon due to error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
}
