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
    
    @State private var orientation = UIDevice.current.orientation
    
    // MARK: View
    
    var body: some View {
        Group {
            if self.orientation.isLandscape {
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
        .detectOrientation(self.$orientation)
        .environment(\.deviceOrientation, self.orientation)
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
                    .publisher(for: UIDevice.orientationDidChangeNotification)
            ) { notification in
                self.orientation = UIDevice.current.orientation
            }
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
