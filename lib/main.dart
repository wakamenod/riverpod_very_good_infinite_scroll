import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

part 'main.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<String>> build() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(10, (i) => 'ToDo Item $i');
  }

  Future<void> fetchTodo() async {
    final previousState = await future;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 1));
      return previousState +
          List.generate(10, (i) => 'ToDo Item ${previousState.length + i}');
    });
  }
}

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Example'),
        ),
        body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final AsyncValue<List<String>> val = ref.watch(todoListProvider);

            return InfiniteList(
              itemCount: val.value?.length ?? 0,
              isLoading: val.isLoading,
              onFetchData: ref.read(todoListProvider.notifier).fetchTodo,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: Text(val.value?[index] ?? ''),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
