//
//  ValidationService.swift
//  Chatler
//
//  Created by Lucas Pereira on 29/07/21.
//

import Foundation

enum CustomError: Error {
    case genericError
    
    var errorDescription: String {
        var description: String
        switch self {
        case .genericError:
            description = "DEBUG: Profile image selected is nil"
        }
        
        description = "\(description): \(localizedDescription)"
        return description
        
    }
}
