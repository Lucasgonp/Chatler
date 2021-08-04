//
//  ValidationService.swift
//  Chatler
//
//  Created by Lucas Pereira on 29/07/21.
//

import Foundation

enum CustomError: Error {
    case imageIsNil
    case imageCantCompress
    case uploadError
    case downloadError
    
    case missingFields
    case creatingUserImageError
    case creatingUserError
    case getUidError
    case uploadUserDataError
    
    case loadImageError
    case defaultError
    
    case fetchUser
    
    var errorDescription: String {
        var description: String
        switch self {
        case .imageIsNil:
            description = "DEBUG: Profile image selected is nil"
        case .imageCantCompress:
            description = "DEBUG: Erro while compressing image"
        case .uploadError:
            description = "DEBUG: Error while uploading image"
        case .downloadError:
            description = "DEBUG: Error while downloading imge"
        case .missingFields:
            description = "DEBUG: There are missing fileds to fill"
        case .creatingUserImageError:
            description = "DEBUG: Error while creating user image"
        case .getUidError:
            description = "DEBUG: Error while getting user ID"
        case .uploadUserDataError:
            description = "Debug: Error while upload user data"
        case .creatingUserError:
            description = "Debug: Error white creating user"
        case .loadImageError:
            description = "DEBUG: Error loading image"
        case .defaultError:
            description = "DEBUG: Error default"
        case .fetchUser:
            description = "DEBUG: Erro ao carregar usuario"
        }
        
        description = "\(description): \(localizedDescription)"
        return description
        
    }
}
