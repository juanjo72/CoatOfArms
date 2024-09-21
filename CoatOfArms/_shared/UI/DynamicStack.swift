//
//  DynamicStack.swift
//  CoatOfArms
//
//  Created on 21/8/24.
//

import SwiftUI

/// View using VStack or HStack based on device's orientation (portrait or lanscape)
struct DynamicStack<
    Content: View
>: View {
    
    // MARK: Injected
    
    private let spacing: CGFloat?
    @ViewBuilder private var content: () -> Content
    
    // MARK: State
    
    @Environment(\.deviceOrientation) private var deviceOrientation
    
    // MARK: View
    
    var body: some View {
        Group {
            if self.deviceOrientation.isLandscape {
                HStack(
                    spacing: spacing,
                    content: self.content
                )
            } else {
                VStack(
                    spacing: self.spacing,
                    content: self.content
                )
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.content = content
    }
}
