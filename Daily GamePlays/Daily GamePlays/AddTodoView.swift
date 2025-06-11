import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var todoText = ""
    @State private var selectedPriority: Priority = .normal
    @FocusState private var isTextFieldFocused: Bool
    
    let onAdd: (String, Priority) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidGlassBackground()
                
                VStack(spacing: 24) {
                    headerSection
                    
                    todoInputSection
                    
                    prioritySection
                    
                    Spacer()
                    
                    actionButtons
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Add New Task")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("What do you need to get done today?")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var todoInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Task Description")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("Enter task...", text: $todoText)
                .textFieldStyle(CompatibleLiquidGlassTextFieldStyle())
                .focused($isTextFieldFocused)
                .submitLabel(.done)
                .onSubmit {
                    addTodoIfValid()
                }
        }
    }
    
    private var prioritySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                ForEach(Priority.allCases, id: \.self) { priority in
                    CompatiblePriorityButton(
                        priority: priority,
                        isSelected: selectedPriority == priority
                    ) {
                        selectedPriority = priority
                    }
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button("Add Task") {
                addTodoIfValid()
            }
            .buttonStyle(CompatibleLiquidGlassButtonStyle())
            .disabled(todoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.secondary)
            .padding(.bottom, 20)
        }
    }
    
    private func addTodoIfValid() {
        let trimmedText = todoText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            onAdd(trimmedText, selectedPriority)
            dismiss()
        }
    }
}

// MARK: - Compatible Components for iOS 14+

struct CompatibleLiquidGlassTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground).opacity(0.8))
                    .background(
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
                    )
                    .overlay(
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
                    )
            )
    }
}

struct CompatibleLiquidGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
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
            )
            .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct CompatiblePriorityButton: View {
    let priority: Priority
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(priorityText)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : priorityColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? priorityColor.opacity(0.8) : Color(.systemBackground).opacity(0.8))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            priorityColor.opacity(isSelected ? 0.0 : 0.6),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
    
    private var priorityText: String {
        switch priority {
        case .low: return "Low"
        case .normal: return "Normal"
        case .high: return "High"
        }
    }
    
    private var priorityColor: Color {
        switch priority {
        case .low: return .green
        case .normal: return .blue
        case .high: return .red
        }
    }
}

// MARK: - Original Priority Button Component (keep for reference)
struct PriorityButton: View {
    let priority: Priority
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(priorityText)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : priorityColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(buttonBackground)
                .overlay(buttonStroke)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
    
    private var priorityText: String {
        switch priority {
        case .low: return "Low"
        case .normal: return "Normal"
        case .high: return "High"
        }
    }
    
    private var priorityColor: Color {
        switch priority {
        case .low: return .green
        case .normal: return .blue
        case .high: return .red
        }
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(isSelected ? priorityColor.opacity(0.8) : priorityColor.opacity(0.03))
    }
    
    private var buttonStroke: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                priorityColor.opacity(isSelected ? 0.0 : 0.6),
                lineWidth: 1
            )
    }
}
