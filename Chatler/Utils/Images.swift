//
//  Images.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import UIKit

struct Images {
    struct Common {
        static var xMark = UIImage(systemName: "xmark")
    }
    
    struct Chat {
        static var background = UIImage(named: "chat.background")
    }
    
    struct Login {
        static var envelope: UIImage = #imageLiteral(resourceName: "ic_mail_outline_white_2x")
        static var lock: UIImage = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        static var profile = UIImage(systemName: "person.circle.fill")
        static var addPhoto: UIImage = #imageLiteral(resourceName: "plus_photo")
        
        static var profileBubble = UIImage(systemName: "bubble.right")
    }
    
    struct Profile {
        static var pencil = UIImage(named: "pencil")
        static var profile2 = UIImage(named: "user-2")
        static var personCircle = UIImage(systemName: "person.circle")
        static var gear = UIImage(systemName: "gear")
    }
    
    struct Friend {
        static var sharedImages = UIImage(systemName: "photo")
    }
    
    struct Register {
        static var defaultProfileImage = #imageLiteral(resourceName: "user-2")
        static var defaultProfileImageUrl = "https://ibb.co/FnfgFP6"
    }
}
