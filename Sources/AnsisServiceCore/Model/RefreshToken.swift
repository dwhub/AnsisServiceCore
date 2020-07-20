//
//  File.swift
//  
//
//  Created by Andi Yudistira on 20/7/20.
//

import Vapor
import JWT

public struct RefreshToken: JWTPayload {
    public let id: Int
    public let iat: TimeInterval
    public let exp: TimeInterval
    
    public init(user: User, expiration: TimeInterval = 24 * 60 * 60 * 30) {
        let now = Date().timeIntervalSince1970
        self.id = user.id ?? 0
        self.iat = now
        self.exp = now + expiration
    }
    
    public func verify(using signer: JWTSigner) throws {
        let expiration = Date(timeIntervalSince1970: self.exp)
        try ExpirationClaim(value: expiration).verifyNotExpired()
    }
}
