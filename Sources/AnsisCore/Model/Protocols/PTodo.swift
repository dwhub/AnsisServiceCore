//
//  Todo.swift
//  
//
//  Created by Andi Yudistira on 12/7/20.
//

import Foundation

public protocol PTodo {
    var id: UUID? { get set}
    var title: String { get set }
}
