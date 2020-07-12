//
//  LoginResponse.swift
//  
//
//  Created by Andi Yudistira on 12/7/20.
//

import Foundation

public struct LoginOutput {
    let userId: Int
    let email: String
    let firstname: String?
    let lastname: String?
    let accessToken: String
    let refreshToken: String
}
