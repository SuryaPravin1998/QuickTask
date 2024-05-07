import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    'SSATF53Flmn3P2d3mA3zWlwtFbX84oW0h2gmNgam',
    'https://parseapi.back4app.com/',
    clientKey: 'LrexPutDi758NHbAR7MBMFeUBV9lv65pXxJtEkhQ',
    autoSendSessionId: true,
    debug: true,
  );

  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'Qt_Icon.png',
          width: 1280,
          height: 720,
        ),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Row(
          children: [
            Image.asset(
              'Qt_PageIcon.png',
              width: 50, 
              height: 50,
            ),
            SizedBox(width: 8),
            Text('Quick Task',style: TextStyle(
              color: Colors.amber, 
            ),textAlign: TextAlign.center),

          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },

              child: Text('Sign Up'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Quick Task',style: TextStyle(
          color: Colors.amber,
        )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6 || value.length > 10) {
                      return 'Password must be between 6 and 10 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUp(context);
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(BuildContext context) async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final user = ParseUser(username, password, email);
    user.set<String>('email', email);

    try {
      final response = await user.signUp();
      if (response.success) {
        _showSnackBar(context, 'User created successfully');
        _clearFields();
        Navigator.pop(context);
      } else {
        _showSnackBar(context, response.error!.message);
      }
    } catch (e) {
      print('Error signing up: $e');
      _showSnackBar(context, 'An error occurred while signing up');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFields() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }
}


class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Quick Task',style: TextStyle(
            color: Colors.amber, 
          ),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final user = ParseUser(_usernameController.text, _passwordController.text,
        _usernameController.text);

    try {
      var response = await user.login();
      if (response.success) {
        _usernameController.clear();
        _passwordController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login successful')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.error!.message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to log in: $e')));
    }
  }
}

class HomeScreen extends StatelessWidget {
  void _navigateToRecycleBin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecycleBinScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return true;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Quick Task',style: TextStyle(
              color: Colors.amber,
            ),),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  _showSignOutDialog(context);
                },
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.amber,
              labelColor: Colors.amber,
              tabs: [
                Tab(text: 'Add Task'),
                Tab(text: 'Tasks'),
                Tab(icon: Icon(Icons.archive)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AddTaskScreen(),
              ViewTaskScreen(),
              ArchivedTasksScreen(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _navigateToRecycleBin(context);
            },
            child: Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _signOut(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      ParseUser? currentUser = await ParseUser.currentUser();
      if (currentUser != null) {
        await currentUser.logout();
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user is currently logged in.'),
          ),
        );
      }
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out: $e'),
        ),
      );
    }
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate)
      setState(() {
        _dueDate = picked;
      });
  }

  void _addTask(BuildContext context) async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      ParseUser? currentUser = await ParseUser.currentUser();
      if (currentUser != null) {
        String formattedDueDate =
        DateFormat('yyyy-MM-dd').format(_dueDate);
        ParseObject task = ParseObject('Task')
          ..set('title', title)
          ..set('description', description)
          ..set('dueDate', formattedDueDate) 
          ..set('flagDelete', 0)
          ..set('flagArchive', 0)
          ..set('user', currentUser);

        try {
          await task.save();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task added successfully'),
            ),
          );
          Navigator.of(context)
              .pushReplacementNamed('/home'); 
        } catch (e) {
          print('Error saving task: $e'); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add task: $e'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not logged in'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter task title and description'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task',style: TextStyle(
          color: Colors.black54, 
        ),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Due Date: ${DateFormat('dd/MM/yyyy').format(_dueDate)}',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDueDate(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addTask(context),
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewTaskScreen extends StatefulWidget {
  @override
  _ViewTaskScreenState createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  List<ParseObject> tasks = [];
  bool isLoading = false;

  void addRestoredTask(ParseObject restoredTask) {
    setState(() {
      tasks.add(restoredTask);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    ParseUser? currentUser = await ParseUser.currentUser();
    if (currentUser != null) {
      QueryBuilder<ParseObject> queryBuilder =
      QueryBuilder<ParseObject>(ParseObject('Task'))
        ..whereEqualTo('flagDelete', 0) 
        ..whereEqualTo('flagArchive', 0) 
        ..whereEqualTo('user', currentUser)
        ..orderByDescending('createdAt');

      try {
        ParseResponse response = await queryBuilder.query();
        if (response.success && response.results != null) {
          List<ParseObject> results = response.results as List<ParseObject>;
          setState(() {
            tasks = results;
            isLoading = false;
          });
        } else {
          print('Error fetching tasks: ${response.error!.message}');
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching tasks: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('User is not logged in');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToTaskDetails(ParseObject task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    );
  }

  Future<void> _toggleCompleted(ParseObject task) async {
    bool isCompleted = task.get('isCompleted') ?? false;
    bool newCompletedValue = !isCompleted;

    task.set('isCompleted', newCompletedValue);

    try {
      await task.save();

      setState(() {
        tasks.forEach((t) {
          if (t.objectId == task.objectId) {
            t.set('isCompleted', newCompletedValue);
          }
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text('Task ${newCompletedValue ? 'completed' : 'incomplete'}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update task: $e'),
        ),
      );
    }
  }

  Future<void> _editTask(BuildContext context, ParseObject task) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    ).then((_) {
      _fetchTasks();
    });
  }

  Future<void> _archiveTask(BuildContext context, ParseObject task) async {
    task.set('flagArchive', 1); 
    try {
      await task.save();
      setState(() {
        tasks.remove(task);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task archived successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to archive task: $e'),
        ),
      );
    }
  }

  Future<void> _deleteTask(BuildContext context, ParseObject task) async {
    task.set('flagDelete', 1);
    try {
      await task.save();  
      setState(() {
        tasks.remove(task);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task temporarily deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete task: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Tasks',style: TextStyle(
          color: Colors.black54,
        ),),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : tasks.isEmpty
          ? Center(
        child: Text('No tasks found'),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final bool isCompleted =
              tasks[index].get('isCompleted') ?? false;
          return ListTile(
            title: Text(tasks[index].get('title') ?? ''),
            subtitle: Text(tasks[index].get('dueDate') ?? ''),
            onTap: () => _navigateToTaskDetails(tasks[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isCompleted)
                  Tooltip(
                      message: 'Click here to Modify this Task',
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTask(context, tasks[index]),
                      )),
                if (!isCompleted)
                  Tooltip(
                      message: 'Click here to archive this task',
                      child: IconButton(
                        icon: Icon(Icons.archive),
                        onPressed: () =>
                            _archiveTask(context, tasks[index]),
                      )),
                Tooltip(
                    message: 'Toggle to mark the Task as Complete',
                    child: Switch(
                      value: isCompleted,
                      onChanged: (_) => _toggleCompleted(tasks[index]),
                    )),
                Tooltip(
                    message: 'Click here to Temporarily Delete this Task',
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTask(context, tasks[index]),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TaskDetailsScreen extends StatelessWidget {
  final ParseObject task;

  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details',style: TextStyle(
          color: Colors.black54, 
        ),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${task.get('title') ?? ''}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${task.get('description') ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Due Date: ${task.get('dueDate') ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final ParseObject task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.task.get('title') ?? '');
    _descriptionController =
        TextEditingController(text: widget.task.get('description') ?? '');
    //_dueDate = widget.task.get('dueDate') ?? DateTime.now();

    String dueDateString = widget.task.get('dueDate');
    _dueDate = DateTime.parse(dueDateString ?? '');
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      if (_dueDate != null) {
        String formattedDueDate =
        DateFormat('yyyy-MM-dd').format(_dueDate);
        print(
            'Formatted Due Date: $formattedDueDate'); 
        widget.task
          ..set('title', title)
          ..set('description', description)
          ..set('dueDate', formattedDueDate);

        try {
          await widget.task.save(); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task updated successfully'),
            ),
          );
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update task: $e'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a due date'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter task title and description'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task',style: TextStyle(
          color: Colors.black54, 
        ),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Due Date: ${DateFormat('dd/MM/yyyy').format(_dueDate)}',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDueDate(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class ArchivedTasksScreen extends StatefulWidget {
  @override
  _ArchivedTasksScreenState createState() => _ArchivedTasksScreenState();
}
class _ArchivedTasksScreenState extends State<ArchivedTasksScreen> {
  List<ParseObject> archivedTasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchArchivedTasks();
  }

  Future<void> _fetchArchivedTasks() async {
    setState(() {
      isLoading = true;
    });

    ParseUser? currentUser = await ParseUser.currentUser();
    if (currentUser != null) {
      QueryBuilder<ParseObject> queryBuilder =
      QueryBuilder<ParseObject>(ParseObject('Task'));
      queryBuilder.whereEqualTo('user', currentUser);
      queryBuilder.whereEqualTo('flagArchive', 1); 
      queryBuilder.orderByDescending('createdAt');

      try {
        ParseResponse response = await queryBuilder.query();
        if (response.success && response.results != null) {
          List<ParseObject> results = response.results as List<ParseObject>;
          setState(() {
            archivedTasks = results;
            isLoading = false;
          });
        } else {
          print('Error fetching archived tasks: ${response.error!.message}');
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching archived tasks: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('User is not logged in');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _restoreTask(BuildContext context, ParseObject task) async {
    try {
      task.set('flagArchive', 0); 
      await task.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task restored successfully'),
        ),
      );

      _fetchArchivedTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to restore task: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Tasks',style: TextStyle(
          color: Colors.black54, 
        ),),
      ),
      body: isLoading
          ? Center(
          child: CircularProgressIndicator()
      )
          : archivedTasks.isEmpty
          ? Center(
        child: Text('No archived tasks found'),
      )
          : ListView.builder(
        itemCount: archivedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(archivedTasks[index].get('title') ?? ''),
            subtitle:
            Text(archivedTasks[index].get('dueDate') ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.restore),
              onPressed: () {
                _restoreTask(context, archivedTasks[index]);
                setState(() {
                  archivedTasks.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class RecycleBinScreen extends StatefulWidget {
  @override
  _RecycleBinScreenState createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  List<ParseObject> deletedTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchDeletedTasks();
  }

  Future<void> _fetchDeletedTasks() async {
    ParseUser? currentUser = await ParseUser.currentUser();
    if (currentUser != null) {
      QueryBuilder<ParseObject> queryBuilder =
      QueryBuilder<ParseObject>(ParseObject('Task'));
      queryBuilder.whereEqualTo('user', currentUser);
      queryBuilder.whereEqualTo('flagDelete', 1); 
      queryBuilder.orderByDescending('createdAt');

      try {
        ParseResponse response = await queryBuilder.query();
        if (response.success && response.results != null) {
          setState(() {
            deletedTasks = response.results as List<ParseObject>;
          });
        } else {
          print('Error fetching deleted tasks: ${response.error!.message}');
        }
      } catch (e) {
        print('Error fetching deleted tasks: $e');
      }
    }
  }

  Future<void> _moveToHistory(ParseObject task) async {
    try {
      task.set('flagDelete', 0);  
      await task.save();
      _fetchDeletedTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task moved to history successfully'),
        ),
      );

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to move task to history: $e'),
        ),
      );
    }
  }

  Future<void> _permanentlyDeleteTask(ParseObject task) async {
    try {
      await task.delete();
      _fetchDeletedTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task permanently deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete task: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Bin',style: TextStyle(
          color: Colors.black54, 
        ),),
      ),
      body: ListView.builder(
        itemCount: deletedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(deletedTasks[index].get('title')),
            subtitle: Text(deletedTasks[index].get('description')),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: 'Restore',
                  child: IconButton(
                    icon: Icon(Icons.restore),
                    onPressed: () => _moveToHistory(deletedTasks[index]),
                  ),
                ),
                Tooltip(
                  message: 'Permanently Delete',
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _permanentlyDeleteTask(deletedTasks[index]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
