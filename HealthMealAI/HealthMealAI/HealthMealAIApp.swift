//
//  HealthMealAIApp.swift
//  HealthMealAI
//
//  Created by Phucnd on 8/7/25.
//

import SwiftUI

@main
struct HealthMealAIApp: App {
    @StateObject private var progressManager = ProgressManager.shared
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainListView()
                if progressManager.isShowing {
                    ZStack {
                        Color.black.opacity(0.001)
                            .ignoresSafeArea()
                        VStack(spacing: 16) {
                            ActivityIndicator(
                                isAnimating: .constant(true),
                                style: .large
                            ).foregroundColor(.white)
                            if let message = progressManager.message {
                                Text(message)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding()
                        //.background(Color.gray.opacity(0.3))
                        .cornerRadius(12)
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: progressManager.isShowing)
                    .allowsHitTesting(true)
                }
            }
            .environmentObject(progressManager)
        }
    }
}



// -- MARK: Global Environment

class ProgressManager: ObservableObject {
    static let shared = ProgressManager()
    
    @Published var isShowing: Bool = false
    @Published var message: String? = nil
    
    private init() {}
    
    func show(message: String? = nil) {
        DispatchQueue.main.async {
            self.message = message
            self.isShowing = true
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.isShowing = false
            self.message = nil
        }
    }
}

