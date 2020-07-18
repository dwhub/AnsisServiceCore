//
//  File.swift
//  
//
//  Created by Andi Yudistira on 18/7/20.
//

import Vapor
import JWT

public final class JWTMiddleware: Middleware {
    public init() { }

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        guard let token = request.headers.bearerAuthorization?.token.utf8 else {
            return request.eventLoop.makeFailedFuture(Abort(.unauthorized, reason: "Missing authorization bearer header"))
        }
        
        #if DEBUG
        if request.headers.bearerAuthorization?.token == "TEST_TOKEN" {
            request.payload = Payload(id: 0, username: "test@account.com")
            return next.respond(to: request)
        }
        #endif

        do {
            request.payload = try request.jwt.verify(Array(token), as: Payload.self)
        } catch let JWTError.claimVerificationFailure(name: name, reason: reason) {
            request.logger.error("JWT Verification Failure: \(name), \(reason)")
            return request.eventLoop.makeFailedFuture(JWTError.claimVerificationFailure(name: name, reason: reason))
        } catch let error {
            return request.eventLoop.makeFailedFuture(error)
        }

        return next.respond(to: request)
    }

}
extension AnyHashable {
    static let payload: String = "jwt_payload"
}

extension Request {
    public var loggedIn: Bool {
        return self.storage[PayloadKey.self] != nil ? true : false
    }

    public var payload: Payload {
        get { self.storage[PayloadKey.self]! }
        set { self.storage[PayloadKey.self] = newValue }
    }

}
