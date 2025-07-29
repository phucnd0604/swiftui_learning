//
//  CustomTextField.swift
//  HealthMealAI
//
//  Created by Phucnd on 29/7/25.
//

import SwiftUI

class CustomUITextField: UITextField {
    var onDeleteWhenEmpty: (() -> Void)?
    
    override func deleteBackward() {
        super.deleteBackward()
        onDeleteWhenEmpty?()
    }
}

struct DeleteDetectingTextField: UIViewRepresentable {
    @Binding var text: String
    var onDeleteLastCharacter: () -> Void
    var onDeleteBackward: () -> Void
    var onSubmit: (() -> Void)? = nil
    
    func makeUIView(context: Context) -> CustomUITextField {
        let textField = CustomUITextField()
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textDidChange(_:)), for: .editingChanged)
        textField.onDeleteWhenEmpty = {
            onDeleteBackward()
        }
        return textField
    }
    
    func updateUIView(_ uiView: CustomUITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DeleteDetectingTextField
        
        init(_ parent: DeleteDetectingTextField) {
            self.parent = parent
        }
        
        @objc func textDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Detect deletion
            if string.isEmpty && range.length > 0 {
                if (textField.text ?? "").count == 1 {
                    parent.onDeleteLastCharacter()
                }
            }
            return true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.onSubmit?()
            textField.resignFirstResponder()
            return true
        }
    }
}
