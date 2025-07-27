//
//  MenuRowView.swift
//  HealthMealAI
//
//  Created by Phucnd on 25/7/25.
//

import SwiftUI
import Popovers

struct MenuRowView: View {
    @ObservedObject var item: MenuItem
    // store old quantity value to update after editing
    @State var oldQuantity: Float = 0
    @State private var tempQuantityText: String = ""
    @State private var showingQuantityPicker = false
    var viewModel: MainListViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 13))
                HStack {
                    Text("\(item.composition.energy.formatted) kcal")
                        .foregroundColor(.orange)
                    Text("Đường: \(item.composition.glucide.formatted)g")
                        .foregroundColor(.green)
                    Text("Muối: \(item.composition.salt.formatted)g")
                        .foregroundColor(.gray)
                }
                .font(.system(size: 11))
            }
            
            // amount: border 4, background gray 0.1
            Text(item.amount)
                .font(.system(size: 11))
                .foregroundColor(.black)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
            
            Spacer()
            Button {
                oldQuantity = item.quantity
                item.quantity = 0
                tempQuantityText = "0"
                showingQuantityPicker = true
            } label: {
                Text(item.quantity.formatted)
                    .frame(width: 40, height: 40)
                    .font(.subheadline)
                    .foregroundColor(showingQuantityPicker ? .gray : .blue)
                    .multilineTextAlignment(.center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                
            }
            .buttonStyle(.plain)
            .popover(
                present: $showingQuantityPicker,
                attributes: {
                    $0.sourceFrameInset.top = -8
                    $0.position = .absolute(
                        originAnchor: .top,
                        popoverAnchor: .bottom
                    )
                }
            ) {
                Templates.Container(
                    arrowSide: .bottom(.mostClockwise),
                    backgroundColor: .green
                ) {
                    QuantityPickerView(
                        text: $tempQuantityText,
                        onDone: {
                            showingQuantityPicker = false
                            let quantity = Float(tempQuantityText) ?? 0
                            if quantity <= 0 {
                                viewModel.deleteItem(item)
                            } else {
                                item.quantity = quantity
                                oldQuantity = quantity
                            }
                        },
                        onChange: { newValue in
                            tempQuantityText = newValue
                            item.quantity = Float(newValue) ?? 0
                            
                        }
                    )
                    
                }
                .frame(maxWidth: 300)
            }
            /*.popover(isPresented: $showingQuantityPicker, attachmentAnchor: .point(.leading)) {
             if #available(iOS 16.4, *) {
             QuantityPickerView(
             text: $tempQuantityText,
             onDone: {
             showingQuantityPicker = false
             let quantity = Float(tempQuantityText) ?? 0
             if quantity <= 0 {
             viewModel.deleteItem(item)
             } else {
             item.quantity = quantity
             oldQuantity = quantity
             }
             },
             onChange: { newValue in
             tempQuantityText = newValue
             item.quantity = Float(newValue) ?? 0
             
             }
             ).presentationCompactAdaptation(.popover)
             .onDisappear {
             // If the user didn't change the quantity, revert to old value
             item.quantity = oldQuantity
             }
             } else {
             // Fallback on earlier versions
             }
             }
             }*/
        }
    }
}

fileprivate let maxSize = 250.0

private struct QuantityPickerView: View {
    
    @Binding var text: String
    var onDone: () -> Void
    var onChange: (String) -> Void
    
    private let width = (maxSize)/3
    private let height = (maxSize)/5
    
    var body: some View {
        
        VStack(spacing: 1) {
            let rows: [[String]] = [
                ["1", "2", "3"],
                ["4", "5", "6"],
                ["7", "8", "9"],
                [".", "0", "<-"]
            ]
            
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(row, id: \.self) { value in
                        Button(action: {
                            if value == "<-" {
                                text = String(text.dropLast())
                                if text.isEmpty {
                                    text = "0"
                                }
                                onChange(text)
                            } else {
                                if value == "." {
                                    if text.contains(".") || text.count >= 3 {
                                        return
                                    }
                                    let newText = text + value
                                    if let number = Double(newText), number < 100 {
                                        text = newText
                                        onChange(text)
                                    }
                                } else {
                                    if text == "0" {
                                        let newText = value
                                        if let number = Double(newText), number < 100 {
                                            text = newText
                                            onChange(text)
                                        }
                                    } else if let dotRange = text.range(of: ".") {
                                        let fractionalPart = text[dotRange.upperBound...]
                                        if fractionalPart.count >= 1 {
                                            return
                                        }
                                        let newText = text + value
                                        if let number = Double(newText), number < 100 {
                                            text = newText
                                            onChange(text)
                                        }
                                    } else {
                                        if text.count >= 3 {
                                            return
                                        }
                                        let newText = text + value
                                        if let number = Double(newText), number < 100 {
                                            text = newText
                                            onChange(text)
                                        }
                                    }
                                }
                            }
                        }) {
                            if value == "<-" {
                                Image(systemName: "delete.left")
                                    .frame(width: width, height: height)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                            } else {
                                Text(value)
                                    .frame(width: width, height: height)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
            
            Button("Done") {
                onDone()
            }
            .padding(.top, 4)
            .frame(width: maxSize, height: height)
            .background(Color.init(hex: "#F0F0F0"))
            .foregroundColor(.black)
        }
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(width: maxSize, height: maxSize)
    }
}


// preview
struct MenuRowView_Previews: PreviewProvider {
    static var previews: some View {
        let item = sampleMenuItems.first!
        let viewModel = MainListViewModel()
        MenuRowView(item: item, viewModel: viewModel)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
