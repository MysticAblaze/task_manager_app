import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../services/parse_service.dart';
import 'login_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ParseObject> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);
    final tasks = await ParseService.getTasks();
    setState(() {
      _tasks = tasks;
      _loading = false;
    });
  }

  void _logout() async {
    await ParseService.logout();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _deleteTask(String objectId) async {
    final success = await ParseService.deleteTask(objectId);
    if (success) {
      _loadTasks();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Task deleted')));
    }
  }

  void _toggleDone(ParseObject task) async {
    await ParseService.updateTask(
      task.objectId!,
      task.get<String>('title') ?? '',
      task.get<String>('description') ?? '',
      !(task.get<bool>('isDone') ?? false),
    );
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TaskFormScreen()));
          _loadTasks();
        },
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('No tasks yet. Tap + to add one!'))
              : RefreshIndicator(
                  onRefresh: _loadTasks,
                  child: ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      final isDone = task.get<bool>('isDone') ?? false;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Checkbox(
                            value: isDone,
                            onChanged: (_) => _toggleDone(task),
                          ),
                          title: Text(
                            task.get<String>('title') ?? '',
                            style: TextStyle(
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle:
                              Text(task.get<String>('description') ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.indigo),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TaskFormScreen(task: task),
                                    ),
                                  );
                                  _loadTasks();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () =>
                                    _deleteTask(task.objectId!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}