//
//  PredictMenuView.swift
//  HealthMealAI
//
//  Created by Phucnd on 26/7/25.
//


import SwiftUI

struct PredictMenuView: View {
    @EnvironmentObject var mainListViewModel: MainListViewModel
    @EnvironmentObject var viewModel: PredictMenuViewModel

    var buttonStyle: PredictMenuViewModel.ButtonSizeStyle {
        if mainListViewModel.menuItems.count > 0 || mainListViewModel.sheetPosition == .minimal {
            return .small
        }
        return .big
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if buttonStyle == .big {
                Text("Nhập món ăn")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
            }
            
            if buttonStyle == .big {
                let firstRow = viewModel.actions.prefix(3)
                let secondRow = viewModel.actions.suffix(from: 3)
                
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        ForEach(firstRow, id: \.self) { type in
                            actionButton(for: type)
                        }
                    }
                    HStack(spacing: 10) {
                        ForEach(secondRow, id: \.self) { type in
                            actionButton(for: type)
                        }
                    }
                }
                .buttonStyle(.plain)
                .controlSize(.regular)
            } else {
                HStack(spacing: 0) {
                    ForEach(viewModel.actions, id: \.self) { type in
                        actionButton(for: type)
                    }
                }
                .buttonStyle(.plain)
                .controlSize(.regular)
            }
            
            if mainListViewModel.sheetPosition != .minimal {
                Text("Gợi ý AI")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            if mainListViewModel.sheetPosition != .minimal {
                ScrollView {
                    VStack {
                        FlowLayout(mode: .scrollable, items: viewModel.suggestedMenus) { item in
                            Button(action: {
                                mainListViewModel.addItem(item)
                            }) {
                                HStack {
                                    // plust icon
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                    Text(item.name)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color.blue.opacity(0.2)))
                                .foregroundColor(.blue)
                            }
                        }.padding(.horizontal, 16)
                        // not eat button
                        if mainListViewModel.menuItems.isEmpty {
                            Button(action: {
                                
                            }) {
                                VStack {
                                    Text("or")
                                        .foregroundColor(.gray)
                                    Text("Đăng ký không ăn gì")
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 2)
                                        .foregroundColor(.blue)
                                }.padding(.top, 8)
                            }
                        }
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 50) // Placeholder for bottom spacing
                    }
                }
            }
            if mainListViewModel.sheetPosition == .minimal {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .alert("Error", isPresented: $viewModel.showError, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        })
        .onChange(of: viewModel.errorMessage) { newValue in
            viewModel.showError = newValue != nil
        }
    }
    
    @ViewBuilder
    func actionButton(for type: BottomSheetType) -> some View {
        Button(action: {
            if mainListViewModel.sheetPosition == .minimal {
                mainListViewModel.sheetPosition = .normal
            }
            mainListViewModel.bottomSheetType = type
            switch type {
                case .history:
                    mainListViewModel.bottomSheetType = type
                default:
                    return
            }
            
        }) {
            if buttonStyle == .big {
                VStack(spacing: 4) {
                    Image(systemName: type.icon)
                        .font(.system(size: 24))
                    Text(type.name)
                        .font(.footnote)
                }
                .frame(width: (UIScreen.main.bounds.width - 20)/3, height: 80)
            } else {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                    .padding(.vertical, 8)
                    .frame(width: UIScreen.main.bounds.width/5, height: 40)
            }
        }
    }
}

struct PredictMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PredictMenuView()
    }
}
