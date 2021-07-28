//
//  Strings.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import Foundation

struct Strings {
    struct Conversations {
        static let title = NSLocalizedString("title", comment: "")
    }
    
    struct Login {
        static let emailPlaceholder = NSLocalizedString("email.placeholder", comment: "")
        static let passwordPlaceholder = NSLocalizedString("password.placeholder", comment: "")
        
        static let loginButton = NSLocalizedString("loginButton", comment: "")
        static let dontHaveAccountTextButton = NSLocalizedString("dontHaveAccountTextButton", comment: "")
        static let dontHaveAccountActionButton = NSLocalizedString("dontHaveAccountActionButton", comment: "")
    }
    
    struct Register {
        static let fullNamePlaceholder = NSLocalizedString("full.name.placeholder", comment: "")
        static let usernamePlaceholder = NSLocalizedString("username.placeholder", comment: "")
        
        static let signUpButton = NSLocalizedString("signup.button", comment: "")
        static let alreadyHaveAccountTextButton = NSLocalizedString("alreadyHaveAccountTextButton", comment: "")
        static let alreadyHaveAccountActionButton = NSLocalizedString("alreadyHaveAccountActionButton", comment: "")
    }
}
