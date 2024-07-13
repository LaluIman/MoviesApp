//
//  SkeletonView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 13/07/24.
//

import SwiftUI

// Shimmer Configuration
public struct ShimmerConfiguration {
    public var gradient: Gradient
    public var duration: Double
    public var opacity: Double

    public static var `default`: ShimmerConfiguration {
        ShimmerConfiguration(
            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.1), Color.white.opacity(0.2)]),
            duration: 2.0, // Increased duration for smoother animation
            opacity: 0.6
        )
    }
}

// Shimmering View
public struct ShimmeringView<Content: View>: View {
    private let content: () -> Content
    private let configuration: ShimmerConfiguration
    @State private var offset: CGFloat = -1 // Start off-screen

    public init(configuration: ShimmerConfiguration, @ViewBuilder content: @escaping () -> Content) {
        self.configuration = configuration
        self.content = content
    }

    public var body: some View {
        ZStack {
            content()
            LinearGradient(
                gradient: configuration.gradient,
                startPoint: .leading,
                endPoint: .trailing
            )
            .opacity(configuration.opacity)
            .blendMode(.screen)
            .offset(x: offset)
            .onAppear {
                withAnimation(Animation.linear(duration: configuration.duration).repeatForever(autoreverses: false)) {
                    offset = UIScreen.main.bounds.width // Move across the screen
                }
            }
        }
    }
}

// Shimmer Modifier
public struct ShimmerModifier: ViewModifier {
    let configuration: ShimmerConfiguration
    
    public func body(content: Content) -> some View {
        ShimmeringView(configuration: configuration) { content }
    }
}

// Shimmer Modifier Extension
public extension View {
    func shimmer(configuration: ShimmerConfiguration = .default) -> some View {
        modifier(ShimmerModifier(configuration: configuration))
    }
}

// Skeleton View
public struct SkeletonView: View {
    public var width: CGFloat = 100
    public var height: CGFloat = 100
    public var cornerRadius: CGFloat = 10
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(LinearGradient(
                gradient: Gradient(colors: [.gray.opacity(0.3), .gray.opacity(0.1), .gray.opacity(0.3)]),
                startPoint: .leading,
                endPoint: .trailing
            ))
            .frame(width: width, height: height)
            .opacity(0.6)
            .shimmer(configuration: .default) // Apply shimmer modifier
    }
}

