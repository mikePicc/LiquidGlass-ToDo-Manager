//
//  LiquidGlassComponents.swift
//  Daily GamePlays
//
//  Created by Michael Piccerillo on 6/10/25.
//

import SwiftUI

// MARK: - Header Component
struct LiquidGlassHeader: View {
    let title: String
    
    var body: some View {
        ZStack {
            // Glass background
            RoundedRectangle(cornerRadius: 0)
                .fill(.ultraThinMaterial)
                .background(glassBg)
                .overlay(glassStroke)
            
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(titleGradient)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .frame(height: 100)
    }
    
    private var glassBg: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.3),
                Color.white.opacity(0.1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var glassStroke: some View {
        RoundedRectangle(cornerRadius: 0)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.4),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 0.5
            )
    }
    
    private var titleGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.primary,
                Color.primary.opacity(0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Add Button Component
struct LiquidGlassAddButton: View {
    let action: () -> Void
    var shadowColor: Color = .blue.opacity(0.3)
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                Text("Add Task")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(buttonTextGradient)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(buttonBackground)
            .shadow(color: shadowColor, radius: 15, x: 0, y: 8)
        }
        .buttonStyle(SpringButtonStyle())
    }
    
    private var buttonTextGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white, Color.white.opacity(0.9)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(buttonBgGradient)
            .overlay(buttonStroke)
    }
    
    private var buttonBgGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.8),
                Color.purple.opacity(0.6)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var buttonStroke: some View {
        RoundedRectangle(cornerRadius: 25)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.4),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 1
            )
    }
}

// MARK: - Empty State Component
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(iconGradient)
            
            Text("All set for tomorrow!")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Add your first task to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 60)
    }
    
    private var iconGradient: LinearGradient {
        LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Background Component
struct LiquidGlassBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.1),
                Color.purple.opacity(0.05),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Button Styles
struct SpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct LiquidGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(textGradient)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(buttonBackground)
            .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
    
    private var textGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white, Color.white.opacity(0.9)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.8),
                        Color.purple.opacity(0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Text Field Style
struct LiquidGlassTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(textFieldBackground)
    }
    
    private var textFieldBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.ultraThinMaterial)
            .background(glassBg)
            .overlay(glassStroke)
    }
    
    private var glassBg: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    private var glassStroke: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 0.5
            )
    }
}
