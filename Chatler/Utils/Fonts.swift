//
//  Fonts.swift
//  Chatler
//
//  Created by Lucas Pereira on 27/07/21.
//

import UIKit

struct Fonts {
    static func defaultLight(size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size)
    }
    
    static func defaultBold(size: CGFloat) -> UIFont {
        UIFont.boldSystemFont(ofSize: size)
    }
}
