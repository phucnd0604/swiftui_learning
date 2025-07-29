//
//  MainListView.swift
//  HealthMealAI
//
//  Created by Phucnd on 25/7/25.
//

import SwiftUI


// -- MARK: Meal Header View

struct MealHeaderView: View {
    @ObservedObject var viewModel: MainListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HeaderActionView(viewModel: viewModel)
            HeaderDetailsView(viewModel: viewModel)
            // bottom separator
            Divider()
        }
        .background(Color.white.ignoresSafeArea(edges: .top))
    }
}

// -- MARK: Header Action View
struct HeaderActionView: View {
    @ObservedObject var viewModel: MainListViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.mealType.name)
                .font(.system(size: 13))
            Text("\(viewModel.timeLineDate.formatted(date: .long, time: .omitted))")
                .font(.system(size: 13))
            Text("\(viewModel.timeLineTime)")
                .font(.system(size: 13))
                .foregroundStyle(.blue)
                .overlay {
                    DatePicker(
                        "",
                        selection: $viewModel.timeLineDate,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .blendMode(.destinationOver)
                    .onChange(of: viewModel.timeLineDate) { newValue in
                        viewModel.updateTime(date: newValue)
                    }
                }
            
            Spacer()
            
            HStack {
                Button(action: {
                    // Cancel action
                }) {
                    Text("Huỷ")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    // Done action
                }) {
                    Text("Xong")
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

// -- MARK: Header Details View

struct HeaderDetailsView: View {
    
    @ObservedObject var viewModel: MainListViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Text(viewModel.menuItems.count.description)
                .font(.system(size: 13, weight: .bold)) +
            Text(" menu")
                .font(.system(size: 11))
            
            Spacer()
            
            Group {
                Text(viewModel.totalKcal.formatted)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.orange) +
                Text("kcal")
                    .font(.system(size: 11))
                Text("Đường")
                    .font(.system(size: 11))
                Text(viewModel.totalGlucide.formatted)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.green) +
                Text("g")
                    .font(.system(size: 11))
                Text("Muối")
                    .font(.system(size: 11))
                Text(viewModel.totalSalt.formatted)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray) +
                Text("g")
                    .font(.system(size: 11))
            }
        }
        .padding(.horizontal)
    }
}

// -- MARK: Empty state view

struct EmptyMealStateView: View {
    
    var onRegisterNothing: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(systemName: "leaf.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.green.opacity(0.6))
                .padding(.top, 50)
            
            Text("Bạn chưa chọn món ăn nào")
                .font(.headline)
                .foregroundColor(.gray)
            
            Button(action: onRegisterNothing) {
                Text("Đăng ký không ăn gì")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .foregroundColor(.blue)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// -- MARK: Main List View

struct MainListView: View {
    
    @StateObject private var viewModel = MainListViewModel()
    @StateObject private var predictVM = PredictMenuViewModel()
    
    init() {
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    private func sectionHeaderView(_ viewModel: MainListViewModel) -> some View {
        TabView {
            ForEach(viewModel.imageItems, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(height: 180)
        .padding(.horizontal, -20)
        .padding(.vertical, 10)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        
    }
    
    private func sectionFooterView() -> some View {
        HStack {
            Spacer()
            Button(action: {
                // handle create myset
            }) {
                Text("Tạo thực đơn của tôi")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                    .padding(.vertical, 10)
            }
            Spacer()
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                MealHeaderView(viewModel: viewModel)
                    .zIndex(100)
                if viewModel.menuItems.isEmpty {
                    EmptyMealStateView {
                        // handle eat nothing
                    }
                } else {
                    ScrollViewReader { scrollProxy in
                        List {
                            Section(header: sectionHeaderView(viewModel), footer: sectionFooterView()) {
                                ForEach(viewModel.menuItems) { item in
                                    MenuRowView(item: item, viewModel: viewModel)
                                        .id(item.id)
                                        .padding(.vertical, 8)
                                }
                                .onDelete(perform: viewModel.deleteItem)
                            }
                        }
                        .listStyle(.insetGrouped)
                        .padding(.top, -10)
                        .zIndex(1)
                        .safeAreaInset(edge: .bottom) {
                            Spacer()
                                .frame(height: BottomSheetPosition.offsetBottom(for: viewModel.sheetPosition, screenHeight: UIScreen.main.bounds.height))
                                .animation(.easeInOut(duration: 0.3), value: viewModel.sheetPosition)
                        }
                        .onChange(of: viewModel.menuItems.count) { _ in
                            // when the menu items change, scroll to the last ite
                            if let last = viewModel.menuItems.last {
                                withAnimation {
                                    scrollProxy.scrollTo(last.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: viewModel.menuItems.count) { _ in
                // then reload predict menu
                predictVM.uuids = viewModel.menuItems.map { $0.id }
            }
            .background(Color(UIColor.systemGroupedBackground))
            BottomSheetView(position: $viewModel.sheetPosition) {
                switch viewModel.bottomSheetType {
                    case .predictMenu:
                        PredictMenuView()
                            .frame(maxWidth: .infinity, alignment: .top)
                    case .history:
                        HistoryView()
                            .frame(maxWidth: .infinity, alignment: .top)
                    case .search:
                        SearchKeywordView()                            
                    case .mySetMenu:
                        Text("My Set Menu View")
                    case .takePhoto:
                        Text("Take Photo View")
                    case .inputPhoto:
                        Text("Input Photo View")
                }
            }
        }
        .environmentObject(viewModel)
        .environmentObject(predictVM)
    }
}

#Preview {
    MainListView()
        .environmentObject(MainListViewModel())
        .environmentObject(PredictMenuViewModel())
}
