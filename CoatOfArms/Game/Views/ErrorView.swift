//
//  ErrrorView.swift
//  CoatOfArms
//
//  Created on 24/9/24.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let style: ErrorViewStyle
    let action: () async -> Void
    
    var body: some View {
        VStack(
            spacing: self.style.spacing
        ) {
            Image(systemName: "exclamationmark.shield.fill")
                .font(Font.system(size: self.style.iconSize))
            
            Text(message)
                .font(.title2)
                .fontWeight(.light)
                .multilineTextAlignment(.center)

            Button(
                action: {
                    Task {
                        await action()
                    }
                },
                label: {
                    Text("Try again")
                        .font(.title2)
                        .padding(.all, 5)
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.borderedProminent)
            .tint(.accent)
            .clipShape(Capsule())
    
        }
        .frame(maxWidth: self.style.width)
    }
}

struct ErrorViewStyle {
    let spacing: CGFloat
    let iconSize: CGFloat
    let width: CGFloat
}

#Preview {
    ErrorView(
        message: "The Internet conncection appears to be offline.",
        style: .default,
        action: {}
    )
}
