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
    
    var errorDescription: String {
        switch self {
        case .imageIsNil:
            return "DEBUG: Profile image selected is nil"
        case .imageCantCompress:
            return "DEBUG: Erro while compressing image"
        case .uploadError:
            return "DEBUG: Error while uploading image"
        case .downloadError:
            return "DEBUG: Error while downloading imge"
        case .missingFields:
            return "DEBUG: There are missing fileds to fill"
        case .creatingUserImageError:
            return "DEBUG: Error while creating user image"
        case .getUidError:
            return "DEBUG: Error while getting user ID"
        case .uploadUserDataError:
            return "Debug: Error while upload user data"
        case .creatingUserError:
            return "Debug: Error white creating user"
        }
    }
}
