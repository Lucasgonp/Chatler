//
//  ProfileCellViewModel.swift
//  Chatler
//
//  Created by Lucas Pereira on 04/08/21.
//

import Foundation

// MARK: - Populate Profile Cells
enum profileViewModelCollection: Int, CaseIterable {
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
    
    var iconImageName: String {
        switch self {
        case .accountInfo:
            return "person.circle"
        case .setting:
            return "gear"
        }
    }
}
