//
//  PredictMenuViewModel.swift
//  HealthMealAI
//
//  Created by Phucnd on 26/7/25.
//

import Foundation
import Combine

class PredictMenuViewModel: ObservableObject {
    enum ButtonSizeStyle {
        case big, small
    }
    
    @Published var suggestedMenus: [MenuItem]
    @Published var actions: [BottomSheetType] = [.search, .history, .mySetMenu, .takePhoto, .inputPhoto]
    @Published var uuids: [UUID] = []
    // show error message
    @Published var showError = false
    var errorMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()
    private var latestTask: Task<Void, Never>? = nil
    
    init() {
        let items = sampleMenuItems.shuffled().prefix(50)
        self.suggestedMenus = Array(items)
        self.actions = actions
        
        // setup observer for suggested menus
        $uuids
            .removeDuplicates()
            .map { ids in
                Future<[MenuItem]?, Never> { [weak self] promise in
                    guard let self = self else {
                        promise(.success(nil))
                        return
                    }
                    
                    // Cancel previous task
                    self.latestTask?.cancel()
                    
                    self.latestTask = Task {
                        do {
                            try Task.checkCancellation()
                            let items = try await self.reloadSuggestedMenus(ids: ids)
                            promise(.success(items))
                        } catch {
                            if Task.isCancelled {
                                print("❌ Task was cancelled before execution")
                            } else {
                                await MainActor.run {
                                    self.showError = true
                                    self.errorMessage = error.localizedDescription
                                }
                                print("Task failed: \(error)")
                            }
                            promise(.success(nil))
                        }
                    }
                }
            }
            .switchToLatest()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                print("Received new suggested menus: \(items.count)")
                self?.suggestedMenus = items
            }
            .store(in: &cancellables)
        
    }
    
    func reloadSuggestedMenus(ids: [UUID]) async throws -> [MenuItem] {
        print("🔵 Reloading suggested menus with ids: \(ids)")
        // wait random time to simulate network delay (longer minimum for burst scenarios)
        try await Task.sleep(nanoseconds: UInt64.random(in: 300_000_000...800_000_000))
        try Task.checkCancellation()
        // filter out the items with the given ids
        let items = sampleMenuItems.filter { !ids.contains($0.id) }
            .shuffled()
            .prefix(10)
        
        print("🟢 Finished reloading suggested menus: \(items.count)")
        
        try Task.checkCancellation()
        // randomly throw an error
        return Array(items)
    }
}
