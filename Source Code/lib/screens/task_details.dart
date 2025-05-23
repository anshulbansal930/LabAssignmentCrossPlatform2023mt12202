import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/helpers/helper_service.dart';
import 'package:flutter_demo/screens/task_list.dart';
import 'package:flutter_demo/services/task_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_demo/widgets/common_header.dart';

/// Displays the details of a single task, allowing editing and updating.
class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

/// State class for TaskDetails, manages the UI and logic for viewing and editing a task.
class _TaskDetailsState extends State<TaskDetails> {
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  TaskService taskService = TaskService();
  HelperService helperService = HelperService();
  late Task task;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic> data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        task = data['task'] as Task;
        _titleController = TextEditingController(text: task.title);
        _descriptionController = TextEditingController(text: task.description);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: dueDate =  24{task.dueDate}');
    if (_titleController == null || _descriptionController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final InputDecoration inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.blueGrey.shade700),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent.shade100, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      prefixIconColor: Colors.blueAccent,
    );
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe3f0ff), Color(0xFFf8fbff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CommonHeader(),
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      keyboardType: TextInputType.multiline,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Title',
                        prefixIcon: const Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Description',
                        prefixIcon: const Icon(Icons.description_outlined),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SwitchListTile(
                      title: const Text('Completed', style: TextStyle(fontWeight: FontWeight.w600)),
                      value: task.completed,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey.shade300,
                      inactiveTrackColor: Colors.grey.shade200,
                      onChanged: (bool value) {
                        setState(() {
                          task.completed = value;
                        });
                      },
                      secondary: Icon(
                        task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task.completed ? Colors.green : Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: task.dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != task.dueDate) {
                          setState(() {
                            task.dueDate = DateTime(picked.year, picked.month, picked.day);
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blueAccent.shade100, width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.calendar_today, color: Colors.blueAccent),
                                SizedBox(width: 10),
                                Text(
                                  'Due Date',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Text(
                              task.dueDate != null
                                  ? DateFormat('dd-MM-yyyy').format(task.dueDate)
                                  : 'No due date set',
                              style: TextStyle(
                                color: (DateTime.now().isAfter(task.dueDate))
                                    ? Colors.red
                                    : Colors.blueGrey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          elevation: WidgetStateProperty.all(8),
                          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.blueAccent.shade700;
                              }
                              return Colors.blueAccent;
                            },
                          ),
                        ),
                        onPressed: () async {
                          task.title = _titleController!.text;
                          task.description = _descriptionController!.text;
                          bool existingTask = task.id != null;
                          await taskService.save(task);
                          await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'Success',
                            desc:
                                'Task \'${task.title}\' ${existingTask ? 'updated' : 'saved'} successfully!',
                          ).show();
                          if (mounted) {
                            Navigator.of(context).pop(task);
                          }
                        },
                        child: const Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
