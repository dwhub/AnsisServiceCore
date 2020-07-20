//
//  File.swift
//  
//
//  Created by Andi Yudistira on 20/7/20.
//

import Vapor
import Fluent

public final class User : Model {
    static let schema = "users"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "firstname")
    var firstname: String?
    
    @Field(key: "lastname")
    var lastname: String?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "phone")
    var phone: String?
    
    @Field(key: "email")
    var email: String?
    
    @Field(key: "password")
    var password: String
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deletedAt", on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    init(_ email: String?, _ firstName: String? = nil, _ lastName: String? = nil, _ password: String,
         _ userName: String, _ phone: String?) throws {
        self.email = email
        self.username = userName
        self.phone = phone
        self.firstname = firstName
        self.lastname = lastName
        self.password = try BCryptDigest().hash(password)
    }
}
