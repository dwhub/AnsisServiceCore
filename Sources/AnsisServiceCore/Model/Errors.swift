//
//  File.swift
//  
//
//  Created by Andi Yudistira on 20/7/20.
//

import Foundation

public enum UserServiceError: Error {
    case UserUnauthorized
    case AuthenticationError
    case PasswordMismatch
    case BCryptError
    case JWTSigningError
    case UnknownError
}
