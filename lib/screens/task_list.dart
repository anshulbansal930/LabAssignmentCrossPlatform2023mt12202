import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/helpers/helper_service.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../main.dart';
import 'package:flutter_demo/services/task_service.dart';
import 'package:flutter_demo/widgets/common_header.dart';

/// Represents a task with title, due date, completion status, and description.
class Task {
  String? id;
  String title = '';
  DateTime dueDate = DateTime.now();
  bool completed = false;
  String? description = '';
  Task({
    required this.title,
    required this.dueDate,
  });
}

/// Displays the list of tasks with filtering, searching, and sorting capabilities.
class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

/// State class for TaskList, manages fetching, filtering, and displaying tasks.
class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  TaskService taskService = TaskService();
  HelperService helperService = HelperService();

  // Filter state
  String statusFilter = 'All';
  final List<String> statusOptions = ['All', 'Completed', 'Pending'];

  // Search and sort state
  String searchQuery = '';
  bool sortAscending = false;
  final TextEditingController searchController = TextEditingController();

  /// Fetches tasks from the server and updates the local task list.
  Future<void> fetch() async {
    try {
      await Parse().initialize(applicationId, parseURL,
          clientKey: clientKey, autoSendSessionId: true);

      ParseUser user = await ParseUser.currentUser();

      final queryBuilder = QueryBuilder(ParseObject('Tasks'))
        ..whereEqualTo('user', user.username)
        ..orderByDescending('dueDate');
      final response = await queryBuilder.query();
      List<Task> results = [];
      if (response.success && response.results != null) {
        for (var o in response.results!) {
          Task task = Task(title: o['title'], dueDate: (o['dueDate'] as DateTime).toLocal());
          task.id = o['objectId'];
          task.description = o['description'];
          task.completed = o['completed'];
          results.add(task);
        }
      }
      setState(() {
        tasks = results;
      });
    } catch (e) {
      // Handle error properly
    }
  }

  /// Returns the filtered and sorted list of tasks based on status and search query.
  List<Task> get filteredTasks {
    List<Task> filtered = tasks;
    // Status filter
    if (statusFilter != 'All') {
      filtered = filtered.where((t) => statusFilter == 'Completed' ? t.completed : !t.completed).toList();
    }
    // Search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (t.description ?? '').toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    // Sort by due date
    filtered.sort((a, b) => sortAscending
        ? a.dueDate.compareTo(b.dueDate)
        : b.dueDate.compareTo(a.dueDate));
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by task name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Text(
                    'Filter by Status',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...statusOptions.map((option) {
                    final bool isSelected = statusFilter == option;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(option),
                        selected: isSelected,
                        selectedColor: Colors.blueAccent,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.blueGrey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) {
                          setState(() {
                            statusFilter = option;
                          });
                        },
                        elevation: isSelected ? 6 : 0,
                        pressElevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    );
                  }),
                  // Sort button
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Tooltip(
                      message: sortAscending ? 'Sort by Date Ascending' : 'Sort by Date Descending',
                      child: IconButton(
                        icon: Icon(
                          sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            sortAscending = !sortAscending;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Card(
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          await Navigator.of(context).pushNamed(
                            '/view-details',
                            arguments: {'task': task},
                          );
                          await fetch();
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
                          leading: Icon(
                            task.completed ? Icons.alarm_off_rounded : Icons.alarm,
                            color: task.completed
                                ? Colors.green
                                : DateTime.now().compareTo(task.dueDate) > 0
                                    ? Colors.red
                                    : Colors.blueAccent,
                            size: 32,
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.description ?? '',
                                style: TextStyle(color: Colors.blueGrey.shade600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.dueDate != null
                                    ? DateFormat('dd-MM-yyyy').format(task.dueDate)
                                    : 'No due date set',
                                style: TextStyle(
                                  color: (DateTime.now().isAfter(task.dueDate))
                                      ? Colors.red
                                      : Colors.blueGrey.shade400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: DateFormat('dd-MM-yyyy').format(task.dueDate),
                                icon: Icon(
                                  task.completed
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: task.completed
                                      ? Colors.green
                                      : DateTime.now().compareTo(task.dueDate) > 0
                                          ? Colors.red
                                          : Colors.blueAccent,
                                ),
                                onPressed: () async {
                                  task.completed = !task.completed;
                                  TaskService taskService = TaskService();
                                  bool success = await taskService.save(task);
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Success',
                                    desc:
                                        'Task ${task.title} is marked ${task.completed ? 'Completed' : 'Incompleted'}!',
                                  ).show();
                                  if (success) {
                                    await fetch();
                                  }
                                },
                              ),
                              IconButton(
                                tooltip: DateFormat('dd-MM-yyyy').format(task.dueDate),
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                                onPressed: () async {
                                  bool success = await taskService.delete(task.id!);
                                  await AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.rightSlide,
                                    title: 'Success',
                                    desc:
                                        '${task.completed ? 'Completed' : 'Incompleted'}Task ${task.title} is deleted successfully!',
                                  ).show();
                                  if (success) {
                                    await fetch();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onPressed: () async {
                  await Navigator.of(context).pushNamed(
                    '/',
                  );
                  await fetch();
                },
                child: const Icon(Icons.home, color: Colors.blueAccent),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: Colors.blueAccent,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onPressed: () async {
                  await Navigator.of(context).pushNamed(
                    '/view-details',
                    arguments: {'task': Task(title: '', dueDate: DateTime.now())},
                  );
                  await fetch();
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onPressed: () async {
                  final ParseUser parseUser = await ParseUser.currentUser();
                  final result = await parseUser.logout();
                  if (result.success) {
                    await AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'Logout Success',
                      desc: 'You have successfully logged out.',
                    ).show();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (route) => false,
                    );
                  } else {
                    helperService.showMessage(context, 'Error logging out',
                        error: true);
                  }
                },
                child: const Icon(Icons.logout_rounded, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
