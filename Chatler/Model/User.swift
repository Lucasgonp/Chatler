//
//  User.swift
//  Chatler
//
//  Created by Lucas Pereira on 01/08/21.
//

import Foundation

struct User: Decodable {
    let uid: String
    let profileImageUrl: String
    let username: String
    let fullname: String
    let email: String
}
