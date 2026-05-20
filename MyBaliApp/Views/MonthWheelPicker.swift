//
//  MonthWheelPicker.swift
//  MyBaliApp
//
//  Created by Stevanus Felixiano on 12/03/26.
//

import SwiftUI

struct MonthWheelPicker: View {
    
    @Binding var selectedMonth: Date
    var close: () -> Void
    
    @State private var month =
        Calendar.current.component(.month, from: Date())
    
    @State private var year =
        Calendar.current.component(.year, from: Date())
    
    let months = Array(1...12)
    let years =
        Array(2000...Calendar.current.component(.year, from: Date()))
    
    var body: some View {
        VStack {
            Text("Select Month")
                .font(.headline)
                .padding()

            HStack {
                Picker("Month", selection: $month) {
                    ForEach(months,id:\.self){ m in
                        Text(Calendar.current.monthSymbols[m-1])
                            .tag(m)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("Year", selection: $year) {
                    ForEach(years,id:\.self){ y in
                        Text(String(y))
                            .tag(y)
                    }
                }
                .pickerStyle(.wheel)
            }
            
            Button("Done") {
                var comp = DateComponents()
                comp.month = month
                comp.year = year
                
                if let newDate =
                    Calendar.current.date(from: comp) {
                    
                    if newDate <= Date() {
                        selectedMonth = newDate
                    }
                }
                close()
            }
            .padding()
        }
    }
}
