//
//  SearchBarView.swift
//  HealthMealAI
//
//  Created by Phucnd on 1/8/25.
//

import SwiftUI

extension SearchKeywordView {
    /// SearchBarView is a view that contains a search bar for entering keywords.
    /// Only used in SearchKeywordView.
    @MainActor
    struct SearchBarView: View {
        @ObservedObject var vm: SearchKeywordViewModel
        var body: some View {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    // chip tag for maker
                    Text("Pesi")
                        .foregroundColor(.accentColor.opacity(0.8))
                        .font(.footnote)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor.opacity(0.8), lineWidth: 1))
                    DeleteDetectingTextField(text: $vm.keyword, onDeleteLastCharacter: {
                        print("Delete last character detected")
                    }, onDeleteBackward: {
                        print("Delete backward detected")
                    }, onSubmit: {
                        vm.searchMenu()
                    })
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .textFieldStyle(.plain)
                    .padding(.vertical, 8)
                    .frame(height:36)
                    if !vm.keyword.isEmpty {
                        Button("", systemImage: "xmark.circle.fill") {
                            vm.keyword = ""
                        }
                        .foregroundColor(.gray)
                    }
                }
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                Button("Cancel") {
                    
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

}
