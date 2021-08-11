//
//  Strings.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import Foundation

struct Strings {
    struct Main {
        static let cancel = NSLocalizedString("cancel", comment: "")
    }
    
    struct Conversations {
        static let title = NSLocalizedString("conversations.title", comment: "")
    }
    
    struct NewMessage {
        static let title = NSLocalizedString("newMessage.title", comment: "")
        static let searchForUser = NSLocalizedString("searchForUser", comment: "")
    }
    
    struct Login {
        static let emailPlaceholder = NSLocalizedString("email.placeholder", comment: "")
        static let passwordPlaceholder = NSLocalizedString("password.placeholder", comment: "")
        
        static let loginButton = NSLocalizedString("loginButton", comment: "")
        static let dontHaveAccountTextButton = NSLocalizedString("dontHaveAccountTextButton", comment: "")
        static let dontHaveAccountActionButton = NSLocalizedString("dontHaveAccountActionButton", comment: "")
    }
    
    struct Profile {
        static let accountInfo = NSLocalizedString("accountInfo", comment: "")
        static let accountSettings = NSLocalizedString("accountSettings", comment: "")
        static let logout = NSLocalizedString("accountLogout", comment: "")
        static let logoutQuestion = NSLocalizedString("accountLogoutQuestion", comment: "")
    }
    
    struct Friend {
        static let sharedImages = NSLocalizedString("friend.sharedImages", comment: "")
        static let mute = NSLocalizedString("friend.mute", comment: "")
    }
    
    struct Register {
        static let fullNamePlaceholder = NSLocalizedString("full.name.placeholder", comment: "")
        static let usernamePlaceholder = NSLocalizedString("username.placeholder", comment: "")
        
        static let signUpButton = NSLocalizedString("signup.button", comment: "")
        static let alreadyHaveAccountTextButton = NSLocalizedString("alreadyHaveAccountTextButton", comment: "")
        static let alreadyHaveAccountActionButton = NSLocalizedString("alreadyHaveAccountActionButton", comment: "")
    }
    
    struct ErrorHandling {
        static let genericTitle = NSLocalizedString("genericTitle", comment: "")
        static let genericButton = NSLocalizedString("genericButton", comment: "")
    }
}
