//
//  User.swift
//  
//
//  Created by Andi Yudistira on 12/7/20.
//

import Foundation

public protocol PUser {
    var firstname: String? { get set}
    var lastname: String? { get set}
    var email: String { get set}
    var passwordHash: String { get set}
    var lastLoginTime: Date? { get set}
    var registrationTime: Date { get set}
}
