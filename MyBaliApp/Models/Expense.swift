//
//  Expense.swift
//  MyBaliApp
//
//  Created by Stevanus Felixiano on 11/03/26.
//

import Foundation

struct Expense: Identifiable, Codable, Equatable {
    var id = UUID()
    var date: Date
    var amount: Double
    var category: String
    var account: String
    var note: String
    var type: String 
}
