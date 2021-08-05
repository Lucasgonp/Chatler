//
//  RegistrationForm.swift
//  Chatler
//
//  Created by Lucas Pereira on 29/07/21.
//

import UIKit

struct RegistrationForm {
    var email, fullname, username, password: String
    var profileImageUrl: String?
    var profileImage: UIImage?
    
    var dictionary: [String: Any] {
        let data = ["email": email,
                    "fullname": fullname,
                    "profileImageUrl": profileImageUrl ?? Images.Register.defaultProfileImageUrl,
                    "username": username] as [String: Any]
        return data
    }
}
