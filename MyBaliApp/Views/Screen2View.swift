//
//  Screen2View.swift
//  MyBaliApp
//
//  Created by Ivan on 03/03/26.
//

import SwiftUI

struct Screen2View: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: ExpenseStore
    var expenseToEdit: Expense? = nil
    @State private var amount = ""
    @State private var rawAmount = ""
    @State private var isFormatting = false
    
    @State private var category = ""
    @State private var account = ""
    @State private var note = ""
    
    @State private var type = "expense"
    
    @State private var selectedDate = Date()
    @State private var pickerDate = Date()
    
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    
    @State private var showCategoryPicker = false
    @State private var showAccountPicker = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case amount
        case category
        case account
    }
    
    struct CategoryItem: Identifiable {
        let id = UUID()
        let icon: String
        let name: String
    }
    
    // EXPENSE CATEGORY
    let expenseCategories = [
        CategoryItem(icon:"fork.knife", name:"Food"),
        CategoryItem(icon:"person.2", name:"Social Life"),
        CategoryItem(icon:"car", name:"Transportation"),
        CategoryItem(icon:"photo", name:"Culture"),
        CategoryItem(icon:"house", name:"Daily Needs"),
        CategoryItem(icon:"tshirt", name:"Clothing"),
        CategoryItem(icon:"sparkles", name:"Beauty"),
        CategoryItem(icon:"heart", name:"Health"),
        CategoryItem(icon:"book", name:"Education"),
        CategoryItem(icon:"gift", name:"Gifts"),
        CategoryItem(icon:"square.grid.2x2", name:"Others")
    ]
    
    // INCOME CATEGORY
    let incomeCategories = [
        CategoryItem(icon:"banknote", name:"Salary"),
        CategoryItem(icon:"dollarsign.circle", name:"Allowance"),
        CategoryItem(icon:"gift", name:"Bonus"),
        CategoryItem(icon:"chart.line.uptrend.xyaxis", name:"Investment"),
        CategoryItem(icon:"square.grid.2x2", name:"Others")
    ]
    
    // Dynamic category source
    var categories: [CategoryItem] {
        type == "income" ? incomeCategories : expenseCategories
    }
    
    func formatRupiahTyping(_ value: String) -> String {
        guard let number = Double(value) else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "Rp "
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    func formatRupiahFinal(_ value: String) -> String {
        guard let number = Double(value) else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = "Rp "
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing:20){
                
                HStack{
                    Button{
                        dismiss()
                    }label:{
                        Label("Back", systemImage:"chevron.left")
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                
                HStack{
                    
                    Button{
                        type = "income"
                        category = ""
                    }label:{
                        Text("Income")
                            .padding(8)
                            .frame(width:100)
                            .overlay(
                                RoundedRectangle(cornerRadius:8)
                                    .stroke(type == "income" ? Color.blue : Color.gray)
                            )
                    }
                    .foregroundColor(type == "income" ? .blue : .gray)
                    
                    Spacer()
                    
                    Button{
                        type = "expense"
                        category = ""
                    }label:{
                        Text("Expense")
                            .padding(8)
                            .frame(width:100)
                            .overlay(
                                RoundedRectangle(cornerRadius:8)
                                    .stroke(type == "expense" ? Color.orange : Color.gray)
                            )
                    }
                    .foregroundColor(type == "expense" ? .orange : .gray)
                }
                .padding(.horizontal)
                
                
                VStack(spacing:16){
                    
                    HStack{
                        Text("Date")
                        Spacer()
                        
                        Button{
                            pickerDate = selectedDate
                            showDatePicker = true
                        }label:{
                            Text(selectedDate.formatted(.dateTime.day().month().year().weekday()))
                                .foregroundColor(.black)
                        }
                        
                        Button{
                            pickerDate = selectedDate
                            showTimePicker = true
                        }label:{
                            Text(selectedDate.formatted(.dateTime.hour().minute()))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Divider()
                    
                    
                    HStack{
                        Text("Amount")
                        Spacer()
                        
                        TextField("0", text:$amount)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width:150)
                            .focused($focusedField, equals: .amount)
                            .onChange(of: amount) { _, newValue in
                                
                                if isFormatting { return }
                                if focusedField != .amount { return }
                                
                                let numbers = newValue.filter { $0.isNumber }
                                
                                if numbers == rawAmount { return }
                                
                                rawAmount = numbers
                                
                                if numbers.isEmpty {
                                    amount = ""
                                } else {
                                    isFormatting = true
                                    amount = formatRupiahTyping(numbers)
                                    isFormatting = false
                                }
                            }
                    }
                    
                    Divider()
                    
                    
                    HStack{
                        Text("Category")
                        Spacer()
                        
                        TextField("", text:$category)
                            .multilineTextAlignment(.trailing)
                            .frame(width:150)
                            .focused($focusedField, equals: .category)
                            .onTapGesture {
                                focusedField = .category
                            }
                    }
                    
                    Divider()
                    
                    
                    HStack{
                        Text("Account")
                        Spacer()
                        
                        TextField("", text:$account)
                            .multilineTextAlignment(.trailing)
                            .frame(width:150)
                            .focused($focusedField, equals: .account)
                            .onTapGesture {
                                focusedField = .account
                            }
                    }
                    
                    Divider()
                    
                    HStack{
                        Text("Note")
                        Spacer()
                        
                        TextField("Write note", text:$note)
                            .multilineTextAlignment(.trailing)
                            .frame(width:150)
                    }
                    
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                
                HStack(spacing:12){
                    
                    if let oldExpense = expenseToEdit {
                        
                        Button{
                            store.delete(oldExpense)
                            dismiss()
                        }label:{
                            Text("Delete")
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(14)
                        }
                    }
                    
                    
                    Button{
                        
                        guard let value = Double(rawAmount),
                              !category.isEmpty,
                              !account.isEmpty
                        else { return }
                        
                        if let oldExpense = expenseToEdit {
                            
                            let updatedExpense = Expense(
                                id: oldExpense.id,
                                date: selectedDate,
                                amount: value,
                                category: category,
                                account: account,
                                note: note,
                                type: type
                            )
                            
                            store.update(updatedExpense)
                            
                        } else {
                            
                            let expense = Expense(
                                date: selectedDate,
                                amount: value,
                                category: category,
                                account: account,
                                note: note,
                                type: type
                            )
                            
                            store.add(expense)
                        }
                        
                        dismiss()
                        
                    }label:{
                        
                        Text("Save")
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            if showDatePicker {
                
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                
                VStack {
                    
                    UIKitCalendar(date: $pickerDate)
                        .frame(width:300,height:320)
                    
                    HStack {
                        
                        Button("Cancel") {
                            showDatePicker = false
                        }
                        .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button("OK") {
                            selectedDate = pickerDate
                            showDatePicker = false
                        }
                        .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                    
                }
                .padding()
                .frame(width:320)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius:20)
            }
            
            
            if showTimePicker {
                
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                
                VStack {
                    
                    DatePicker(
                        "",
                        selection: $pickerDate,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    
                    HStack {
                        
                        Button("Cancel") {
                            showTimePicker = false
                        }
                        .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button("OK") {
                            selectedDate = pickerDate
                            showTimePicker = false
                        }
                        .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                    
                }
                .padding()
                .frame(width:300,height:260)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius:20)
            }
            // CATEGORY PICKER
            
            if showCategoryPicker {
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing:0){
                    
                    HStack{
                        Text("Category")
                            .font(.headline)
                        Spacer()
                        Button{
                            showCategoryPicker = false
                            focusedField = nil
                        }label:{
                            Image(systemName:"xmark")
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    
                    
                    LazyVGrid(columns:[
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],spacing:16){
                        
                        ForEach(categories){ item in
                            
                            Button{
                                category = item.name
                                showCategoryPicker = false
                                focusedField = nil
                            }label:{
                                
                                VStack(spacing:10){
                                    
                                    Image(systemName:item.icon)
                                        .font(.system(size:26))
                                    
                                    Text(item.name)
                                        .font(.system(size:14, weight:.medium))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.8)
                                }
                                .frame(maxWidth:.infinity)
                                .frame(height:100)
                                .background(Color(.systemGray6))
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    
                }
                .cornerRadius(20)
                .padding(.horizontal)
            }
            
            
            // ACCOUNT PICKER
            
            if showAccountPicker {
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing:0){
                    
                    HStack{
                        Text("Account")
                            .font(.headline)
                        Spacer()
                        Button{
                            showAccountPicker = false
                            focusedField = nil
                        }label:{
                            Image(systemName:"xmark")
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    
                    VStack(spacing:16){
                        
                        Button{
                            account = "Cash"
                            showAccountPicker = false
                            focusedField = nil
                        }label:{
                            Text("Cash")
                                .frame(maxWidth:.infinity)
                        }
                        
                        Button{
                            account = "Transfer"
                            showAccountPicker = false
                            focusedField = nil
                        }label:{
                            Text("Transfer")
                                .frame(maxWidth:.infinity)
                        }
                        
                        Button{
                            account = "Card"
                            showAccountPicker = false
                            focusedField = nil
                        }label:{
                            Text("Card")
                                .frame(maxWidth:.infinity)
                        }
                        
                    }
                    .padding()
                    .background(Color.white)
                    
                }
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(true)
        
        .onAppear{
            if let expense = expenseToEdit {
                rawAmount = String(Int(expense.amount))
                amount = formatRupiahFinal(rawAmount)
                category = expense.category
                account = expense.account
                note = expense.note
                type = expense.type
                selectedDate = expense.date
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                focusedField = .amount
            }
        }
        
        .onChange(of: focusedField) { _, newField in
            
            if newField != .amount && !rawAmount.isEmpty {
                isFormatting = true
                amount = formatRupiahFinal(rawAmount)
                isFormatting = false
            }
            
            if newField == .amount && !rawAmount.isEmpty {
                isFormatting = true
                amount = formatRupiahTyping(rawAmount)
                isFormatting = false
            }
            
            if newField == .category {
                showCategoryPicker = true
            }
            
            if newField == .account {
                showAccountPicker = true
            }
        }
        
        .toolbar{
            if focusedField == .amount {
                ToolbarItemGroup(placement:.keyboard){
                    Spacer()
                    Button("Done"){
                        focusedField = .category
                    }
                }
            }
        }
    }
}

#Preview {
    Screen2View(store: ExpenseStore())
}
