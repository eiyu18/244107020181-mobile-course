import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  Todo(this.title, {this.done = false});
  final String title;
  final bool done;

  Todo copyWith({String? title, bool? done}) =>
      Todo(title ?? this.title, done: done ?? this.done);
}

class TodoListNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // To test Step 2 of your lab, uncomment the line below:
    // throw Exception('Failed to connect to the server');
    
    return [];
  }

  Future<void> add(String title) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 1)); // simulate save time
      final currentTodos = state.value ?? [];
      return [...currentTodos, Todo(title)];
    });
  }

  void toggle(int index) {
    if (state.value == null) return;
    final todos = [...state.value!];
    todos[index] = todos[index].copyWith(done: !todos[index].done);
    state = AsyncData(todos);
  }

  void remove(int index) {
    if (state.value == null) return;
    final todos = [...state.value!]..removeAt(index);
    state = AsyncData(todos);
  }
}

final todoListProvider =
    AsyncNotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);