//
//  ProfileCellViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 04/08/21.
//

import Foundation
import UIKit

// MARK: - Populate Profile Cells
enum ProfileViewModelCollection: Int, CaseIterable {
    case accountInfo
    case setting
    
    var description: String {
        switch self {
        case .accountInfo:
            return Strings.Profile.accountInfo
        case .setting:
            return Strings.Profile.accountSettings
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .accountInfo:
            return Images.Profile.personCircle
        case .setting:
            return Images.Profile.gear
        }
    }
}
