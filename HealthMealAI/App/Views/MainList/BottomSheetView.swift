//
//  BottomSheetView.swift
//  HealthMealAI
//
//  Created by Phucnd on 25/7/25.
//

import SwiftUI

enum BottomSheetPosition: CaseIterable {
    case minimal
    case normal
    case expanded

    static func offset(for position: BottomSheetPosition, screenHeight: CGFloat = UIScreen.main.bounds.height) -> CGFloat {
        switch position {
        case .minimal:
            return screenHeight - 100
        case .normal:
            return screenHeight * 0.5
        case .expanded:
            return 200
        }
    }
    
    static func offsetBottom(for position: BottomSheetPosition, screenHeight: CGFloat = UIScreen.main.bounds.height) -> CGFloat {
        switch position {
        case .minimal:
            return 100
        case .normal:
            return screenHeight * 0.5
        case .expanded:
            return screenHeight * 0.5
        }
    }
}

struct BottomSheetView<Content: View>: View {
    let content: Content
    @GestureState private var dragOffset: CGFloat = 0
    @Binding var position: BottomSheetPosition

    init(position: Binding<BottomSheetPosition>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._position = position
    }

    var body: some View {
        GeometryReader { geo in
            let screenHeight = UIScreen.main.bounds.height

            let yOffset = BottomSheetPosition.offset(for: position, screenHeight: screenHeight)

            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 60, height: 6)
                    .padding(.vertical, 8)

                content
                    .frame(height: max(0, screenHeight - (yOffset + dragOffset) - 30))
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -2)
            .frame(maxWidth: .infinity, alignment: .top)
            .offset(y: min(
                BottomSheetPosition.offset(for: .minimal, screenHeight: screenHeight),
                max(BottomSheetPosition.offset(for: .expanded, screenHeight: screenHeight), yOffset + dragOffset)
            ))
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        let proposedOffset = value.translation.height
                        let currentOffset = BottomSheetPosition.offset(for: position, screenHeight: geo.size.height)
                        let newOffset = currentOffset + proposedOffset

                        let minOffset = BottomSheetPosition.offset(for: .expanded, screenHeight: geo.size.height)
                        let maxOffset = BottomSheetPosition.offset(for: .minimal, screenHeight: geo.size.height)

                        if newOffset < minOffset {
                            state = minOffset - currentOffset
                        } else if newOffset > maxOffset {
                            state = maxOffset - currentOffset
                        } else {
                            state = proposedOffset
                        }
                    }
                    .onEnded { value in
                        let direction = value.translation.height

                        let next: BottomSheetPosition = {
                            if direction > 100 {
                                // Dragging down
                                if position == .expanded { return .normal }
                                else { return .minimal }
                            } else if direction < -100 {
                                // Dragging up
                                if position == .minimal { return .normal }
                                else { return .expanded }
                            }
                            return position
                        }()
                        withAnimation(.easeInOut) {
                            position = next
                        }
                    }
            )
            .animation(.interpolatingSpring(mass: 1.0, stiffness: 200, damping: 20, initialVelocity: 10), value: dragOffset + yOffset)
        }
        .ignoresSafeArea()
    }
}
