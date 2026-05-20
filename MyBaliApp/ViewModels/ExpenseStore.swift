//
//  ExpenseStore.swift
//  MyBaliApp
//
//  Created by Stevanus Felixiano on 12/03/26.
//

import Foundation
import Combine

class ExpenseStore: ObservableObject {
    
    @Published var expenses: [Expense] = []
    
    private let fileURL: URL
    
    init() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = path.appendingPathComponent("expenses.json")
        load()
    }
    
    // MARK: LOAD
    
    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        }
    }
    
    // MARK: SAVE
    
    func save() {
        if let data = try? JSONEncoder().encode(expenses) {
            try? data.write(to: fileURL)
        }
    }
    
    // MARK: ADD
    
    func add(_ expense: Expense) {
        expenses.append(expense)
        save()
    }
    
    // MARK: UPDATE
    
    func update(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
            save()
        }
    }
    
    // MARK: DELETE
    
    func delete(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
        save()
    }
}
