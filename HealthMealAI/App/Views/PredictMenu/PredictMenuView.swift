//
//  PredictMenuView.swift
//  HealthMealAI
//
//  Created by Phucnd on 26/7/25.
//


import SwiftUI
import SwiftUIFlow



struct PredictMenuView: View {
    @ObservedObject var mainListViewModel: MainListViewModel
    @ObservedObject var viewModel: PredictMenuViewModel

    var buttonStyle: PredictMenuViewModel.ButtonSizeStyle {
        if mainListViewModel.menuItems.count > 0 || mainListViewModel.sheetPosition == .minimal {
            return .small
        }
        return .big
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if buttonStyle == .big {
                Text("Nhập món ăn")
                    .font(.title2)
                    .fontWeight(.semibold)
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
                                // TODO: handle tap on \(item.name)
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
    }
    
    @ViewBuilder
    func actionButton(for type: BottomSheetType) -> some View {
        Button(action: {
            switch type {
                case .history:
                    mainListViewModel.sheetPosition = .normal
                    mainListViewModel.bottomSheetType = type
                default:
                    return
            }
            
        }) {
            if buttonStyle == .big {
                VStack(spacing: 4) {
                    Image(systemName: iconName(for: type.name))
                        .font(.system(size: 24))
                    Text(type.name)
                        .font(.footnote)
                }
                .frame(width: (UIScreen.main.bounds.width - 20)/3, height: 80)
            } else {
                Image(systemName: iconName(for: type.name))
                    .font(.system(size: 20))
                    .padding(.vertical, 8)
                    .frame(width: UIScreen.main.bounds.width/5, height: 40)
            }
        }
    }
}

struct PredictMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PredictMenuView(mainListViewModel: MainListViewModel(), viewModel: PredictMenuViewModel())
    }
}

func iconName(for title: String) -> String {
    switch title {
    case "Tìm kiếm": return "magnifyingglass"
    case "Lịch sử": return "clock"
    case "Bộ của tôi": return "star"
    case "Camera": return "camera"
    case "Thư viện": return "photo.on.rectangle"
    default: return "questionmark"
    }
}
