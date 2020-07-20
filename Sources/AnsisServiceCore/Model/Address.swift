//
//  File.swift
//  
//
//  Created by Andi Yudistira on 20/7/20.
//

import Vapor
import Fluent

public final class Address: Model {
    public static let schema = "addresses"
    
    @ID(custom: "id")
    public var id: Int?
    
    @Field(key: "street")
    public var street: String
    
    @Field(key: "city")
    public var city: String
    
    @Field(key: "zip")
    public var zip: String
    
    @Field(key: "userId")
    public var userId: Int
    
    @Timestamp(key: "createdAt", on: .create)
    public var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    public var updatedAt: Date?
    
    @Timestamp(key: "deletedAt", on: .delete)
    public var deletedAt: Date?

    @Parent(key: "userId")
    var user: User
    
    public init() { }
    
    public init(street: String, city: String, zip: String, userId: Int) {
            self.street = street
            self.city = city
            self.zip = zip
            self.userId = userId
    }
}
