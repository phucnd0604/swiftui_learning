//
//  HistoryView.swift
//  HealthMealAI
//
//  Created by Phucnd on 26/7/25.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var historyItems: [MenuItem] = []
    @Published var historyType: MealType = .breakfast // Default history type
    @Published var hasMoreData: Bool = false
    @Published var isLoadingMore: Bool = false
    
    init() {
        // Load history items from a data source
        loadHistory()
    }
    
    func loadHistory() {
        ProgressManager.shared.show()
        // Simulate a network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let sampleItem = sampleMenuItems.shuffled().prefix(10)
            self.historyItems = Array(sampleItem)
            self.hasMoreData = true
            ProgressManager.shared.hide()
        }
    }
    
    @MainActor
    func loadMore() async {
        guard !isLoadingMore, hasMoreData else { return }
        isLoadingMore = true
        try? await Task.sleep(nanoseconds: 3_000_000_000) // 1 second delay
        let moreItems = generateRandomMenuItems(count: 10)
        historyItems.append(contentsOf: moreItems)
        if historyItems.count >= 100 {
            hasMoreData = false
        }
        isLoadingMore = false
    }
}


struct HistoryRowView: View {
    var item: MenuItem
    @ObservedObject var viewModel: MainListViewModel
    
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
            Spacer()
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
        }
    }
}


struct HistoryView: View {
    // ViewModel for managing history data
    @StateObject private var viewModel = HistoryViewModel()
    @EnvironmentObject var mainListViewModel: MainListViewModel
    
    var body: some View {
        VStack {
            // Header bar: icon + text -- button cancel
            HStack {
                Image(systemName: "clock")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("Meal History")
                Spacer()
                Button(action: {
                    mainListViewModel.bottomSheetType = .predictMenu
                }) {
                    Text("Close")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
            }.padding()
            
            Picker("History Type", selection: $viewModel.historyType) {
                Text("Breakfast").tag(MealType.breakfast)
                Text("Lunch").tag(MealType.launch)
                Text("Dinner").tag(MealType.dinner)
                Text("Snack").tag(MealType.breakMeal)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: viewModel.historyType) { _ in
                viewModel.loadHistory()
            }
            .padding(.horizontal)
            
            // list of history items
            List {
                ForEach(viewModel.historyItems) { item in
                    HistoryRowView(item: item, viewModel: mainListViewModel)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            // Handle item tap, maybe show details or add to current meal
                            mainListViewModel.addItem(item)
                            mainListViewModel.bottomSheetType = .predictMenu
                        }
                }
                
                // Load more indicator
                if viewModel.hasMoreData {
                    ActivityIndicator(
                        isAnimating: .constant(true),
                        style: .large
                    )
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        Task {
                            await viewModel.loadMore()
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}



// preview data for testing
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
