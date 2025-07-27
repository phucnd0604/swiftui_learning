//
//  MainListViewModel.swift
//  HealthMealAI
//
//  Created by Phucnd on 25/7/25.
//

import SwiftUI

enum BottomSheetType: CaseIterable {
    case predictMenu
    case history
    case search
    case mySetMenu
    case takePhoto
    case inputPhoto
    
    var name: String {
        switch self {
            case .predictMenu:
                return "Dự đoán thực đơn"
            case .history:
                return "Lịch sử"
            case .search:
                return "Tìm kiếm"
            case .mySetMenu:
                return "Thực đơn của tôi"
            case .takePhoto:
                return "Chụp ảnh"
            case .inputPhoto:
                return "Nhập ảnh"
        }
    }
    
    var icon: String {
        switch self {
            case .predictMenu:
                return "brain"
            case .history:
                return "clock"
            case .search:
                return "magnifyingglass"
            case .mySetMenu:
                return "list.bullet.rectangle"
            case .takePhoto:
                return "camera"
            case .inputPhoto:
                return "photo.on.rectangle.angled"
        }
    }
}

class MainListViewModel: ObservableObject {
    
    @Published var timeLineDate: Date = Date()
    @Published var sheetPosition: BottomSheetPosition = .normal
    @Published var bottomSheetType: BottomSheetType = .predictMenu
    
    /// Mock image items for horizontal scroll header
    var imageItems: [UIImage] {
        // Return a few colored images as mock data
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
        return colors.map { color in
            UIGraphicsImageRenderer(size: CGSize(width: 120, height: 120)).image { ctx in
                color.setFill()
                ctx.fill(CGRect(origin: .zero, size: CGSize(width: 120, height: 120)))
            }
        }
    }
    
    var mealType: MealType = .launch
    
    var timeLineTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timeLineDate)
    }
    
    @Published var menuItems: [MenuItem] = []
    
    var totalKcal: Float {
        menuItems.reduce(0) { $0 + ($1.composition.energy * $1.quantity) }
    }

    var totalSalt: Float {
        menuItems.reduce(0) { $0 + ($1.composition.salt * $1.quantity) }
    }

    var totalGlucide: Float {
        menuItems.reduce(0) { $0 + ($1.composition.glucide * $1.quantity) }
    }

    // -- MARK: Initializer and Methods
    init(mealType: MealType = .launch, date: Date = Date()) {
        timeLineDate = mealType.eatTime(date)
        self.mealType = mealType
    }
    
    func updateTime(date: Date) {
        timeLineDate = date
    }
    
    func addItem(_ item: MenuItem) {
        if menuItems.contains(where: { $0.id == item.id }) {
            // If the item already exists plus quantity
            if let index = menuItems.firstIndex(where: { $0.id == item.id }) {
                menuItems[index].quantity += 1
                objectWillChange.send() // Notify observers that the item has changed
            }
        } else {
            menuItems.append(item)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        menuItems.remove(atOffsets: offsets)
    }
    
    func deleteItem(_ item: MenuItem) {
        if let index = menuItems.firstIndex(where: { $0.id == item.id }) {
            menuItems.remove(at: index)
        }
    }
}
