//
//  SearchKeywordView.swift
//  HealthMealAI
//
//  Created by Phucnd on 29/7/25.
//

import SwiftUI


enum SearchDisplayType {
    case suggestion
    case maker
    case menu
}

enum FilterType: Int {
    case all = 0
    case maker
    case homeCook
    
    var name: String {
        switch self {
            case .all: return "All"
            case .maker: return "Maker"
            case .homeCook: return "HomeCook"
        }
    }
}

class SearchKeywordViewModel: ObservableObject {
    @Published var selectedFilter: FilterType = .all
    @Published var keyword: String = ""
    @Published var displayType: SearchDisplayType = .maker
    
    func searchMenu() {
        displayType = .menu
    }
}

struct SearchKeywordView: View {
    
    @StateObject private var vm = SearchKeywordViewModel()
    
    private func filterButton(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .font(.system(size: 12, weight: .light))
            .foregroundColor(selected ? .blue : .black)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(selected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(selected ? Color.blue : .clear, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Color.white
                .frame(height: 20)
                .padding(.horizontal, 16)
            // search bar
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
                    TextField("Tìm kiếm...", text: $vm.keyword)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .textFieldStyle(.plain)
                        .padding(.vertical, 8)
                        .onSubmit {
                            vm.searchMenu()
                        }
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
            // filter options: all, maker only, none maker
            HStack(spacing: 8) {
                filterButton(title: FilterType.all.name, selected: vm.selectedFilter == .all) {
                    vm.selectedFilter = .all
                    vm.displayType = .maker // Reset to maker when filter changes
                }
                filterButton(title: FilterType.maker.name, selected: vm.selectedFilter == .maker) {
                    vm.selectedFilter = .maker
                    vm.displayType = .suggestion
                }
                filterButton(title: FilterType.homeCook.name, selected: vm.selectedFilter == .homeCook) {
                    vm.selectedFilter = .homeCook
                    vm.displayType = .menu
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            // list item
            switch vm.displayType {
                case .maker:
                    SearchResultMakerView()
                case .menu:
                    SearchResultListMenuView()
                case .suggestion:
                    SearchResultSuggestionView()
            }
            
            Spacer()
        })
    }
}

struct SearchResultListMenuView: View {
    var body: some View {
        List {
            Section(header: SearchSectionHeader()) {
                ForEach(0..<10, id: \.self) { index in
                    SearchRowItemView(index: index)
                }
            }
            .listRowSeparator(.hidden)
            
            Section(header: SearchSectionHeader()) {
                ForEach(0..<10, id: \.self) { index in
                    SearchRowItemView(index: index)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .background(Color.white)
    }
}

struct SearchResultMakerView: View {
    var body: some View {
        Text("Maker results will go here")
            .padding()
    }
}

struct SearchResultSuggestionView: View {
    var body: some View {
        Text("Suggestions will go here")
            .padding()
    }
}

// MARK: - preview
#Preview {
    SearchKeywordView()
}

struct SearchSectionHeader: View {
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                Image(systemName: "sparkles")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                Text("Header 1")
                    .foregroundColor(.gray)
                Spacer()
            }
            Divider()
        }
        .frame(minHeight: 20)
        .padding(.horizontal, 16)
        .background(Color.white)
        .listRowInsets(EdgeInsets())
    }
}


struct SearchRowItemView: View {
    
    let index: Int
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "leaf")
                    .foregroundColor(.green)
                Text("Bánh mì ốp la \(index + 1)")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                Spacer()
                Text("100 kcal")
                    .font(.system(size: 13))
                    .foregroundColor(.orange)
            }
            .padding(.vertical, 8)
            Divider()
        }
    }
}
