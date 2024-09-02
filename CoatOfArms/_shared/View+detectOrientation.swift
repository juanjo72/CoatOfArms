//
//  View+detectOrientation.swift
//  CoatOfArms
//
//  Created on 21/8/24.
//

import SwiftUI

/// View extension to detect device orientation changes
extension View {
    func detectOrientation(_ orientation: Binding<UIDeviceOrientation>) -> some View {
        modifier(DetectOrientation(orientation: orientation))
    }
}

private struct DetectOrientation: ViewModifier {
    @Binding var orientation: UIDeviceOrientation
    
    func body(content: Content) -> some View {
        content
            .onReceive(
                NotificationCenter.default
                    .publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        self.orientation = UIDevice.current.orientation
                    }
    }
}
