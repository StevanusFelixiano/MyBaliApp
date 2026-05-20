//
//  Screen1View.swift
//  MyBaliApp
//
//  Created by Ivan on 03/03/26.
//

import SwiftUI

struct Screen1View: View {
    
    @StateObject var store = ExpenseStore()
    
    @State private var selectedMonth = Date()
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var showMonthWheel = false
    
    
    // MARK: FILTER
    
    var filteredExpenses: [Expense] {
        store.expenses.filter {
            (searchText.isEmpty ||
             $0.note.lowercased().contains(searchText.lowercased()))
            &&
            Calendar.current.isDate(
                $0.date,
                equalTo: selectedMonth,
                toGranularity: .month
            )
        }
        .sorted { $0.date > $1.date }
    }
    
    
    // MARK: GROUP
    
    var groupedExpenses: [Date:[Expense]] {
        Dictionary(grouping: filteredExpenses) {
            Calendar.current.startOfDay(for: $0.date)
        }
    }
    
    
    // MARK: SORTED DATES
    
    var sortedDates: [Date] {
        groupedExpenses.keys.sorted(by: >)
    }
    
    
    // MARK: TOTAL
    
    var incomeTotal: Double {
        filteredExpenses
            .filter { $0.type == "income" }
            .reduce(0) { $0 + $1.amount }
    }
    
    var expenseTotal: Double {
        filteredExpenses
            .filter { $0.type == "expense" }
            .reduce(0) { $0 + $1.amount }
    }
    
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                VStack(spacing:0) {
                    
                    headerView
                    
                    ScrollView {
                        
                        LazyVStack(spacing:16) {
                            
                            ForEach(sortedDates, id: \.self) { date in
                                
                                ExpenseDaySection(
                                    date: date,
                                    expenses: groupedExpenses[date] ?? [],
                                    store: store
                                )
                            }
                        }
                        .padding(.top,10)
                    }
                }
                
                
                // ADD BUTTON
                
                if !showMonthWheel {
                    
                    VStack{
                        Spacer()
                        
                        HStack{
                            Spacer()
                            
                            NavigationLink{
                                Screen2View(store:store)
                            }label:{
                                
                                Image(systemName:"plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width:60,height:60)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius:5)
                            }
                            .padding()
                        }
                    }
                }
                
                
                // MONTH PICKER
                
                if showMonthWheel {
                    
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture{
                            showMonthWheel = false
                        }
                    
                    MonthWheelPicker(
                        selectedMonth:$selectedMonth
                    ){
                        showMonthWheel = false
                    }
                    .frame(width:320,height:260)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(radius:20)
                }
            }
        }
    }
    
    
    // HEADER VIEW
    
    var headerView: some View {
        
        VStack(spacing:16){
            
            HStack{
                
                if isSearching {
                    
                    TextField("Search note...", text:$searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    Button("Cancel"){
                        withAnimation{
                            isSearching = false
                            searchText = ""
                        }
                    }
                    
                } else {
                    
                    Button{
                        changeMonth(-1)
                    }label:{
                        Image(systemName:"chevron.left")
                    }
                    
                    Button{
                        showMonthWheel = true
                    }label:{
                        Text(monthString)
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    
                    Button{
                        changeMonth(1)
                    }label:{
                        Image(systemName:"chevron.right")
                    }
                    
                    Spacer()
                    
                    Button{
                        withAnimation{
                            isSearching = true
                        }
                    }label:{
                        Image(systemName:"magnifyingglass")
                    }
                }
            }
            
            
            HStack{
                
                VStack{
                    Text("Income")
                        .foregroundColor(.blue)
                    
                    Text("\(incomeTotal, specifier:"%.2f")")
                }
                
                Spacer()
                
                VStack{
                    Text("Expenses")
                        .foregroundColor(.red)
                    
                    Text("\(expenseTotal, specifier:"%.2f")")
                }
                
                Spacer()
                
                VStack{
                    Text("Total")
                    
                    Text("\(incomeTotal-expenseTotal, specifier:"%.2f")")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(14)
        }
        .padding(.horizontal)
        .padding(.top,12)
        .padding(.bottom,5)
        .background(Color(.systemBackground))
        .overlay(
            Divider(),
            alignment: .bottom
        )
        .shadow(color:.black.opacity(0.05), radius:4, y:2)
    }
    
    
    var monthString:String{
        selectedMonth.formatted(
            .dateTime.month(.wide).year()
        )
    }
    
    
    func changeMonth(_ value:Int){
        
        withAnimation(.easeInOut){
            
            selectedMonth =
            Calendar.current.date(
                byAdding:.month,
                value:value,
                to:selectedMonth
            )!
        }
    }
}






// MARK: DAY SECTION

struct ExpenseDaySection: View {
    
    let date: Date
    let expenses: [Expense]
    let store: ExpenseStore
    
    var dailyTotal: Double {
            expenses.reduce(0) { result, expense in
                result + (expense.type == "income" ? expense.amount : -expense.amount)
            }
        }
    var body: some View {
        
        VStack(alignment:.leading, spacing:8){
            
            HStack{
                
                Text(date.formatted(.dateTime.day()))
                    .font(.title2)
                    .bold()
                
                Text(date.formatted(.dateTime.weekday(.abbreviated)))
                    .font(.caption)
                    .padding(4)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
                
                Text(date.formatted(.dateTime.month().year()))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("Rp \(dailyTotal, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(dailyTotal >= 0 ? .blue : .red)
            }
            
            
            ForEach(expenses) { expense in
                
                NavigationLink {
                    Screen2View(store: store, expenseToEdit: expense)
                } label: {
                    ExpenseRow(expense: expense)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Divider()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .padding(.horizontal)
    }
}





// MARK: ROW

struct ExpenseRow: View {
    
    let expense: Expense
    
    var body: some View {
        
        HStack{
            
            VStack(alignment:.leading){
                
                Text(expense.note.isEmpty ? expense.category : expense.note)
                    .font(.subheadline)
                
                Text("\(expense.category) • \(expense.account)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("Rp \(expense.amount, specifier:"%.2f")")
                .foregroundColor(
                    expense.type == "income"
                    ? .blue
                    : .red
                )
        }
        .padding(.vertical,6)
    }
}




#Preview {
    Screen1View()
}
