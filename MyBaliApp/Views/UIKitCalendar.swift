//
//  UIKitCalendar.swift
//  MyBaliApp
//
//  Created by Stevanus Felixiano on 12/03/26.
//

import SwiftUI
import UIKit

struct UIKitCalendar: UIViewRepresentable {

    @Binding var date: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.changed),
            for: .valueChanged
        )
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = date
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: UIKitCalendar

        init(_ parent: UIKitCalendar) {
            self.parent = parent
        }

        @objc func changed(_ sender: UIDatePicker) {
            parent.date = sender.date
        }
    }
}
