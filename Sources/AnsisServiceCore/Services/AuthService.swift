//
//  File.swift
//  
//
//  Created by Andi Yudistira on 20/7/20.
//

import Vapor
import Foundation
import Fluent

public struct AuthService {
        
    public func refreshToken(request: Request, refreshToken: String) throws -> EventLoopFuture<(payloadString: String, payload: Payload)> {
        let refreshPayload: RefreshToken = try request.application
            .jwt.signers.verify(refreshToken, as: RefreshToken.self)
        
        return User.query(on: request.db)
                .filter(\.$id == refreshPayload.id)
                .all().flatMapThrowing { (users) -> (payloadString: String, payload: Payload) in
            guard users.count > 0 else {
                throw UserServiceError.UserUnauthorized
            }
                    
            let user: User = users.first!

            let payload = Payload(id: user.id!, username: user.username)
            let payloadString = try request.application.jwt.signers.sign(payload)
                                    
            return (payloadString, payload)
        }
    }
    
    public func authenticate(request: Request, username: String, password: String) throws -> EventLoopFuture<User> {
        return User.query(on: request.db).filter(\.$username == username).all().flatMapThrowing { (users) -> User in
            guard users.count > 0 else {
                throw UserServiceError.UserUnauthorized
            }
            
            let user = users.first!
            
            do {
                _ = try Bcrypt.verify(password, created: user.password)
            } catch {
                throw UserServiceError.BCryptError
            }
            
            return user
        }
    }
}

public struct AuthServiceKey: StorageKey {
    public typealias Value = AuthService
}

extension Application {
    public var authService: AuthService? {
        get {
            self.storage[AuthServiceKey.self]
        }
        set {
            self.storage[AuthServiceKey.self] = newValue
        }
    }
}
