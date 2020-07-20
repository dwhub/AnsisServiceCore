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
        
    func refreshToken(request: Request, refreshToken: String) throws -> EventLoopFuture<(payloadString: String, payload: Payload)> {
        do {
            let refreshPayload: RefreshToken = try request.application
                .jwt.signers.verify(refreshToken, as: RefreshToken.self)
            
            return try User.query(on: request.db)
                    .filter(\.$id == refreshPayload.id)
                    .all().flatMapThrowing { (users) -> (payloadString: String, payload: Payload) in
                guard users.count > 0 else {
                    throw UserServiceError.UserUnauthorized
                }
                        
                let user: User = users.first!

                let payload = Payload(id: user.id!, username: user.username)
                var payloadString = try request.application.jwt.signers.sign(payload)
                                        
                return (payloadString, payload)
            }
        } catch {
            throw UserServiceError.JWTSigningError
        }
    }
    
    func authenticate(request: Request, username: String, password: String) throws -> EventLoopFuture<User> {
        do {
            return try User.query(on: request.db).filter(\.$username == username).all().flatMapThrowing { (users) -> User in
                guard users.count > 0 else {
                    throw UserServiceError.UserUnauthorized
                }
                
                let user = users.first!
                
                var check = false

                do {
                    check = try Bcrypt.verify(password, created: user.password)
                } catch {
                    throw UserServiceError.BCryptError
                }
                
                return user
            }
        } catch {
            throw UserServiceError.AuthenticationError
        }
    }
}

struct AuthServiceKey: StorageKey {
    typealias Value = AuthService
}

extension Application {
    var authService: AuthService? {
        get {
            self.storage[AuthServiceKey.self]
        }
        set {
            self.storage[AuthServiceKey.self] = newValue
        }
    }
}
