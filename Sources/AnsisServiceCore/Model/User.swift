//
//  File.swift
//  
//
//  Created by Andi Yudistira on 20/7/20.
//

import Vapor
import Fluent

public final class User : Model {
    public static let schema = "users"
    
    @ID(custom: "id")
    public var id: Int?
    
    @Field(key: "firstname")
    public var firstname: String?
    
    @Field(key: "lastname")
    public var lastname: String?
    
    @Field(key: "username")
    public var username: String
    
    @Field(key: "phone")
    public var phone: String?
    
    @Field(key: "email")
    public var email: String?
    
    @Field(key: "password")
    public var password: String
    
    @Timestamp(key: "createdAt", on: .create)
    public var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    public var updatedAt: Date?
    
    @Timestamp(key: "deletedAt", on: .delete)
    public var deletedAt: Date?
    
    @Children(for: \.$user)
    public var addresses: [Address]
    
    public init() { }
    
    public init(_ email: String?, _ firstName: String? = nil, _ lastName: String? = nil, _ password: String,
         _ userName: String, _ phone: String?) throws {
        self.email = email
        self.username = userName
        self.phone = phone
        self.firstname = firstName
        self.lastname = lastName
        self.password = try BCryptDigest().hash(password)
    }
}
