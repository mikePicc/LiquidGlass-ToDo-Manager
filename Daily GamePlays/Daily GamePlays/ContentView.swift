import SwiftUI

struct ContentView: View {
    @State private var todos: [TodoItem] = []
    @State private var showingAddTodo = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidGlassBackground()
                
                VStack(spacing: 0) {
                    LiquidGlassHeader(title: "Today's GamePlay")
                    
                    mainContent
                    
                    Spacer()
                    
                    LiquidGlassAddButton {
                        showingAddTodo = true
                    }
                    .padding(.bottom, 34)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddTodo) {
            AddTodoView { text, priority in
                addTodo(text: text, priority: priority)
            }
        }
        .onAppear {
            loadSampleDataIfNeeded()
        }
    }
    
    private var mainContent: some View {
        Group {
            if todos.isEmpty {
                EmptyStateView()
            } else {
                todoList
            }
        }
    }
    
    private var todoList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(sortedTodos) { todo in
                    TodoRowView(
                        todo: todo,
                        onToggle: { toggleTodo(todo) },
                        onDelete: { deleteTodo(todo) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .animation(.easeInOut(duration: 0.3), value: todos)
        }
    }
    
    // Sort todos: incomplete first, then by priority, then by creation date
    private var sortedTodos: [TodoItem] {
        todos.sorted { first, second in
            if first.isCompleted != second.isCompleted {
                return !first.isCompleted // Incomplete tasks first
            }
            
            if first.priority != second.priority {
                return priorityOrder(first.priority) < priorityOrder(second.priority)
            }
            
            return first.createdAt < second.createdAt
        }
    }
    
    private func priorityOrder(_ priority: Priority) -> Int {
        switch priority {
        case .high: return 0
        case .normal: return 1
        case .low: return 2
        }
    }
}

// MARK: - Todo Management
extension ContentView {
    private func addTodo(text: String, priority: Priority = .normal) {
        let newTodo = TodoItem(text: text, priority: priority)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            todos.append(newTodo)
        }
    }
    
    private func toggleTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                todos[index].isCompleted.toggle()
            }
        }
    }
    
    private func deleteTodo(_ todo: TodoItem) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            todos.removeAll { $0.id == todo.id }
        }
    }
    
    private func loadSampleDataIfNeeded() {
        guard todos.isEmpty else { return }
        
        todos = [
            TodoItem(text: "Make sure to say your prayers!", priority: .high),
            TodoItem(text: "Go to the gym is mandatory", priority: .normal),
            TodoItem(text: "Always gotta exercise the brain - read / write smth", priority: .low)
        ]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
