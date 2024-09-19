//
//  View+detectOrientationChanges.swift
//  CoatOfArms
//
//  Created on 19/9/24.
//

import SwiftUI

/// View extension to detect device orientation changes
extension View {
    func detectOrientationChanges() -> some View {
        modifier(DetectOrientation())
    }
}

private struct DetectOrientation: ViewModifier {
    @State private var orientation = UIDevice.current.orientation
    
    func body(content: Content) -> some View {
        content
            .onReceive(
                NotificationCenter.default
                    .publisher(for: UIDevice.orientationDidChangeNotification)
            ) { notification in
                self.orientation = UIDevice.current.orientation
            }
            .environment(\.deviceOrientation, self.orientation)
    }
}

private struct DeviceOrientationKey: EnvironmentKey {
    static let defaultValue: UIDeviceOrientation = .unknown
}

extension EnvironmentValues {
    var deviceOrientation: UIDeviceOrientation {
        get { self[DeviceOrientationKey.self] }
        set { self[DeviceOrientationKey.self] = newValue }
    }
}
