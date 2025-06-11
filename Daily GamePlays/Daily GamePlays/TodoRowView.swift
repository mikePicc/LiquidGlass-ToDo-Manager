import SwiftUI

struct TodoRowView: View {
    let todo: TodoItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            CheckboxView(isCompleted: todo.isCompleted, onToggle: onToggle)
            
            TodoTextView(todo: todo)
            
            Spacer()
            
            DeleteButton(onDelete: onDelete)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(todoRowBackground)
        .shadow(color: todo.priority.color.opacity(0.5), radius: 10, x: 0, y: 5)
    }
    
    private var todoRowBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.ultraThinMaterial)
            .background(glassBg)
            .overlay(glassStroke)
    }
    
    private var glassBg: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    private var glassStroke: some View {
        RoundedRectangle(cornerRadius: 16)
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

// MARK: - Checkbox Component
struct CheckboxView: View {
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 28, height: 28)
                    .overlay(checkboxStroke)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.blue)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isCompleted)
    }
    
    private var checkboxStroke: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.6),
                        Color.purple.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 2
            )
    }
}

// MARK: - Todo Text Component
struct TodoTextView: View {
    let todo: TodoItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(todo.text)
                .font(.body)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)
                .strikethrough(todo.isCompleted)
                .animation(.easeInOut(duration: 0.2), value: todo.isCompleted)
            
            // Optional: Show creation time for completed tasks
            if todo.isCompleted {
                Text("Completed")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .opacity(0.7)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.001)) // transparent background to let the shadow show
                .shadow(color: todo.priority.color.opacity(0.5), radius: 6, x: 0, y: 4)
        )
    }
}

// MARK: - Delete Button Component
struct DeleteButton: View {
    let onDelete: () -> Void
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: { showingAlert = true }) {
            Image(systemName: "trash")
                .font(.system(size: 16))
                .foregroundColor(.red.opacity(0.7))
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Task", isPresented: $showingAlert) {
            Button("Delete", role: .destructive, action: onDelete)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this task?")
        }
    }
}
