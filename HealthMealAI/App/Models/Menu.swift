//
//  Menu.swift
//  HealthMealAI
//
//  Created by Phucnd on 25/7/25.
//

import Foundation

enum MealType: String, CaseIterable, Identifiable {
    case breakfast = "Sáng"
    case launch = "Trưa"
    case dinner = "Tối"
    case breakMeal = "Ăn nhẹ"
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .breakfast:
            return "Bữa sáng"
        case .launch:
            return "Bữa trưa"
        case .dinner:
            return "Bữa tối"
        case .breakMeal:
            return "Ăn nhẹ"
        }
    }
    
    func eatTime(_ date: Date) -> Date {
        // Returns the date for the meal type based on the given date
        switch self {
        case .breakfast:
            return Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: date) ?? date
        case .launch:
            return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
        case .dinner:
            return Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: date) ?? date
        case .breakMeal:
            return Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: date) ?? date
        }
    }
}

class MenuItem: Identifiable, Hashable, ObservableObject {
            
    let id: UUID
    var name: String
    @Published var quantity: Float
    let composition: Composition
    let amount: String

    init(id: UUID = UUID(), name: String, quantity: Float, composition: Composition, amount: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.composition = composition
        self.amount = amount
    }
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Composition {
    var energy: Float      // đơn vị kcal
    var salt: Float     // đơn vị g
    var glucide: Float  // đơn vị g
}


// dummy data


let dishNames = [
    "Phở", "Cơm tấm", "Bún bò", "Gỏi cuốn", "Cháo lòng", "Hủ tiếu", "Bánh mì", "Mì quảng", "Bún thịt nướng", "Bánh cuốn",
    "Cơm rang", "Súp cua", "Bánh đa cua", "Xôi mặn", "Bánh xèo", "Nem rán", "Canh chua", "Cà ri gà", "Lẩu thái", "Thịt kho tàu",
    "Cơm gà", "Cơm chiên Dương Châu", "Cơm trộn Hàn Quốc", "Mì cay", "Mì xào bò", "Bánh canh cua", "Bún mắm", "Bún chả", "Bún riêu", "Bún ốc",
    "Bún thang", "Bánh khọt", "Bánh bèo", "Bánh hỏi", "Chả cá Lã Vọng", "Bò kho", "Gà rô ti", "Thịt nướng lá mắc mật", "Chả giò", "Gỏi gà",
    "Gỏi xoài", "Gỏi bò bóp thấu", "Gỏi ngó sen", "Gà nướng mật ong", "Gà hấp lá chanh", "Heo quay", "Vịt quay", "Thịt nướng", "Chả trứng",
    "Trứng chiên", "Canh bí đỏ", "Canh rau ngót", "Canh mướp đắng", "Canh cải ngọt", "Canh rong biển", "Cà tím nướng mỡ hành", "Đậu hũ chiên",
    "Đậu hũ nhồi thịt", "Đậu sốt cà", "Trứng đúc thịt", "Kho quẹt", "Thịt kho hột vịt", "Lạp xưởng", "Cá kho tộ", "Cá chiên xù", "Cá hấp gừng",
    "Tôm rim", "Tôm chiên xù", "Tôm nướng", "Mực xào", "Mực nướng", "Bạch tuộc nướng", "Ngao hấp", "Hàu nướng phô mai", "Ốc xào me", "Ốc luộc",
    "Cà ri vịt", "Lẩu cá", "Lẩu gà lá é", "Lẩu bò", "Lẩu hải sản", "Cá viên chiên", "Bò viên", "Bánh tráng trộn", "Bánh tráng nướng", "Bắp xào",
    "Xoài lắc", "Cóc dầm", "Bắp luộc", "Khoai lang nướng", "Chè bưởi", "Chè thập cẩm", "Chè đậu đen", "Chè trôi nước", "Chè bà ba", "Chè khoai môn",
    "Sinh tố bơ", "Sinh tố xoài", "Sữa chua mít", "Sữa chua nếp cẩm", "Kem trái dừa", "Kem xôi", "Kem flan", "Trà sữa", "Trà đào", "Trà tắc"
]

let sampleMenuItems: [MenuItem] = dishNames.map { name in
    MenuItem(
        name: name,
        quantity: Float.random(in: 1...3),
        composition: Composition(
            energy: Float.random(in: 50...500),
            salt: Float.random(in: 0.1...2.0),
            glucide: Float.random(in: 5.0...50.0)
        ),
        amount: ["1 phần", "1 bát", "1 đĩa", "1 chén", "1 suất", "vừa ăn", "nhiều", "ít"].randomElement()!
    )
}

func generateRandomMenuItems(count: Int) -> [MenuItem] {
    return (0..<count).map { _ in
        let name = dishNames.randomElement() ?? "Món ăn"
        return MenuItem(
            name: name,
            quantity: Float.random(in: 1...3),
            composition: Composition(
                energy: Float.random(in: 50...500),
                salt: Float.random(in: 0.1...2.0),
                glucide: Float.random(in: 5.0...50.0)
            ),
            amount: ["1 phần", "1 bát", "1 đĩa", "1 chén", "1 suất", "vừa ăn", "nhiều", "ít"].randomElement()!
        )
    }
}
