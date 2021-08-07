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
        switch self {
        case .genericError:
            return "Algo deu errado! D:"
        }
    }
}
