//
//  FriendViewModelCollection.swift
//  Chatler
//
//  Created by Lucas Pereira on 11/08/21.
//

import Foundation
import UIKit

    // MARK: - Populate Friend Cells

enum FriendViewModelCollection: Int, CaseIterable {
    case sharedImages
    
    var description: String {
        switch self {
        case .sharedImages:
            return Strings.Friend.sharedImages
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .sharedImages:
            return Images.Friend.sharedImages
        }
    }
}
