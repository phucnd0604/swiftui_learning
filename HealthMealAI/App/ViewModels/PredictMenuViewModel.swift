//
//  PredictMenuViewModel.swift
//  HealthMealAI
//
//  Created by Phucnd on 26/7/25.
//

import Foundation

class PredictMenuViewModel: ObservableObject {
    enum ButtonSizeStyle {
        case big, small
    }
    
    @Published var suggestedMenus: [MenuItem]
    @Published var actions: [BottomSheetType] = [.search, .history, .mySetMenu, .takePhoto, .inputPhoto]
    
    init() {
        let items = sampleMenuItems.shuffled().prefix(50)
        self.suggestedMenus = Array(items)
        self.actions = actions
    }
    
    func reloadSuggestedMenus(ids: [UUID]) {
        let items = sampleMenuItems.filter({ item in
            !ids.contains(item.id)
        }).shuffled()
            .prefix(50)
        self.suggestedMenus = Array(items)
    }
}
