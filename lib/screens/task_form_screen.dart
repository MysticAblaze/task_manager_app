import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../services/parse_service.dart';

class TaskFormScreen extends StatefulWidget {
  final ParseObject? task;
  const TaskFormScreen({super.key, this.task});
  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.task?.get<String>('title') ?? '');
    _descController = TextEditingController(
        text: widget.task?.get<String>('description') ?? '');
  }

  void _save() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title cannot be empty')));
      return;
    }
    setState(() => _loading = true);
    bool success;
    if (widget.task == null) {
      success = await ParseService.createTask(
          _titleController.text.trim(), _descController.text.trim());
    } else {
      success = await ParseService.updateTask(
        widget.task!.objectId!,
        _titleController.text.trim(),
        _descController.text.trim(),
        widget.task!.get<bool>('isDone') ?? false,
      );
    }
    setState(() => _loading = false);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to save task')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: 'Task Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}