import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'prioritze',
      theme: ThemeData(
        primaryColor: const Color(0xFFAB47BC),
        hintColor: const Color(0xFFBA68C8),
      ),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  late TextEditingController taskController; // Declare taskController
  String selectedFilter = 'All';
  String title = "All Tasks";

  @override
  void initState() {
    super.initState();
    taskController = TextEditingController(); // Initialize taskController
    loadTodos();
  }

  void loadTodos() async {
    try{
      print("loading");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? todoList = prefs.getStringList('todos');
      if (todoList != null) {
        setState(() {
          todos = todoList.map((json) => Todo.fromJson(jsonDecode(json))).toList();
        });
      }
    }catch(e){
      print("error loading:$e");
    }
    }


  void saveTodos() async {
    try{
      print("saving");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> todoList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
      prefs.setStringList('todos', todoList);
    }catch(e){
      print("error saving:$e");
    }

  }

  void addTodo(String task) {
    setState(() {
      todos.insert(
        0,
        Todo(
          task: task,
          status: TodoStatus.undone,
        ),
      );
      saveTodos();
    });
  }

  void markAsDone(int index) {
    setState(() {
      todos[index].status = todos[index].status == TodoStatus.done
          ? TodoStatus.undone
          : TodoStatus.done;
      saveTodos();
    });
  }
  void markAsInProgress(int index) {
    setState(() {
      todos[index].isInProgress = true;
      saveTodos();
    });
  }

  void markAsUndone(int index) {
    setState(() {
      todos[index].isInProgress = false;
      todos[index].status = TodoStatus.undone;
      saveTodos();
    });
  }

  void deleteTask(int index) {
    setState(() {
      todos.removeAt(index);
      saveTodos();
    });
  }
  void updateTitle(){
    if (selectedFilter == 'All') {
      title = 'All Tasks';
    } else if (selectedFilter == 'Undone') {
      title = 'Undone Tasks';
    } else if (selectedFilter == 'Done') {
      title = 'Completed Tasks';
    } else if (selectedFilter == 'In Progress') {
      title = 'Tasks in Progress';
    }
  }
  bool tasksSatisfyFilter() {
    // Implement your logic to check if there are tasks that satisfy the selected filter
    if (selectedFilter == 'All') {
      return true;
    } else if (selectedFilter == 'Undone') {
      // Return true if there are undone tasks
      return todos.any((task) => task.status != TodoStatus.done);
    } else if (selectedFilter == 'Done') {
      // Return true if there are done tasks
      return todos.any((task) => task.status == TodoStatus.done);
    } else if (selectedFilter == 'In Progress') {
      // Return true if there are in-progress tasks
      return todos.any((task) => task.isInProgress);
    } else if (selectedFilter == 'Canceled') {
      // Return true if there are canceled tasks
      return todos.any((task) => task.status == TodoStatus.canceled);
    }
    return false;
  }
  @override
  void dispose(){
    saveTodos();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prioritize'),
        centerTitle: true,
        backgroundColor: const Color(0xFFAB47BC),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                 title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                      updateTitle();
                    });
                  },
                  items: <String>['All', 'Undone', 'Done', 'In Progress']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  dropdownColor: const Color(0xFFBA68C8),
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8),

                ),
              ],
            ),
          ),

          Expanded(
            child: (todos.isEmpty|| !tasksSatisfyFilter())
                ? Container(
                  margin: const EdgeInsets.fromLTRB(62, 0, 0, 0),
                  child: SvgPicture.string(
              '''
              <svg xmlns="http://www.w3.org/2000/svg" data-name="Layer 1" width="430.91406" height="559.70956" viewBox="0 0 430.91406 559.70956" xmlns:xlink="http://www.w3.org/1999/xlink"><path d="M689.29823,324.68445q0,4.785-.31006,9.49a143.75442,143.75442,0,0,1-13.46973,52.19c-.06006.14-.13037.27-.18994.4-.36035.76-.73047,1.52-1.11035,2.27a142.03868,142.03868,0,0,1-7.6499,13.5,144.462,144.462,0,0,1-118.56006,66.72l1.43018,82.24,18.6499-9.82,3.33008,6.33-21.83985,11.5,2.66992,152.74.02979,2.04-14.41992,1.21.02978-.05,4.54-246.18a144.17482,144.17482,0,0,1-102-44.38c-.90967-.94-1.81006-1.91-2.68994-2.87-.04-.04-.06982-.08-.1001-.11a144.76758,144.76758,0,0,1-26.33984-40.76c.14014.16.29.31.43017.47a144.642,144.642,0,0,1,68.57959-186.38c.5-.25,1.01026-.49,1.51026-.74a144.75207,144.75207,0,0,1,187.52978,56.93c.88037,1.48005,1.73047,2.99006,2.5503,4.51A143.85218,143.85218,0,0,1,689.29823,324.68445Z" transform="translate(-384.54297 -170.14522)" fill="#e5e5e5"/><circle cx="198.2848" cy="502.61836" r="43.06733" fill="#2f2e41"/><rect x="210.6027" y="532.22265" width="38.58356" height="13.08374" fill="#2f2e41"/><ellipse cx="249.45884" cy="534.4033" rx="4.08868" ry="10.90314" fill="#2f2e41"/><rect x="201.6027" y="531.22265" width="38.58356" height="13.08374" fill="#2f2e41"/><ellipse cx="240.45884" cy="533.4033" rx="4.08868" ry="10.90314" fill="#2f2e41"/><path d="M541.051,632.71229c-3.47748-15.5738,7.63866-31.31043,24.82866-35.14881s33.94421,5.67511,37.42169,21.2489-7.91492,21.31769-25.10486,25.156S544.5285,648.28608,541.051,632.71229Z" transform="translate(-384.54297 -170.14522)" fill="#ab47bc"/><path d="M599.38041,670.31119a10.75135,10.75135,0,0,1-10.33984-7.12305,1,1,0,0,1,1.896-.63672c1.51416,4.50782,6.69825,6.86524,11.55457,5.25342a9.60826,9.60826,0,0,0,5.57251-4.74756,8.23152,8.23152,0,0,0,.48547-6.33789,1,1,0,0,1,1.896-.63672,10.217,10.217,0,0,1-.59229,7.86817,11.62362,11.62362,0,0,1-6.73218,5.75244A11.87976,11.87976,0,0,1,599.38041,670.31119Z" transform="translate(-384.54297 -170.14522)" fill="#fff"/><path d="M618.56452,676.16463a9.57244,9.57244,0,1,1-17.04506,8.71737h0l-.00855-.01674c-2.40264-4.70921.91734-7.63227,5.62657-10.03485S616.162,671.45547,618.56452,676.16463Z" transform="translate(-384.54297 -170.14522)" fill="#fff"/><path d="M772.27559,716.2189h-381a1,1,0,0,1,0-2h381a1,1,0,0,1,0,2Z" transform="translate(-384.54297 -170.14522)" fill="#3f3d56"/><ellipse cx="567.22606" cy="706.64241" rx="7.50055" ry="23.89244" transform="translate(-543.03826 -6.10526) rotate(-14.4613)" fill="#2f2e41"/><path d="M645.50888,621.42349H629.12323a.77274.77274,0,0,1-.51881-1.3455l14.90017-13.49467h-13.7669a.77274.77274,0,0,1,0-1.54548h15.77119a.77275.77275,0,0,1,.51881,1.34551L631.12753,619.878h14.38135a.77274.77274,0,1,1,0,1.54548Z" transform="translate(-384.54297 -170.14522)" fill="#cbcbcb"/><path d="M666.37288,597.46853H649.98723a.77275.77275,0,0,1-.51881-1.34551l14.90017-13.49466h-13.7669a.77274.77274,0,0,1,0-1.54548h15.77119a.77274.77274,0,0,1,.51881,1.3455l-14.90016,13.49467h14.38135a.77274.77274,0,1,1,0,1.54548Z" transform="translate(-384.54297 -170.14522)" fill="#cbcbcb"/><path d="M657.1,571.19534H640.71434a.77274.77274,0,0,1-.51881-1.3455l14.90017-13.49467H641.3288a.77274.77274,0,0,1,0-1.54548H657.1a.77275.77275,0,0,1,.51881,1.34551l-14.90016,13.49466H657.1a.77274.77274,0,0,1,0,1.54548Z" transform="translate(-384.54297 -170.14522)" fill="#cbcbcb"/><path d="M770.66217,347.522,783.457,337.28854c-9.93976-1.09662-14.0238,4.32429-15.69525,8.615-7.76532-3.22446-16.21881,1.00136-16.21881,1.00136l25.6001,9.29375A19.37209,19.37209,0,0,0,770.66217,347.522Z" transform="translate(-384.54297 -170.14522)" fill="#3f3d56"/><path d="M403.66217,180.522,416.457,170.28854c-9.93976-1.09662-14.0238,4.32429-15.69525,8.615-7.76532-3.22446-16.21881,1.00136-16.21881,1.00136l25.6001,9.29375A19.37209,19.37209,0,0,0,403.66217,180.522Z" transform="translate(-384.54297 -170.14522)" fill="#3f3d56"/><path d="M802.66217,215.522,815.457,205.28854c-9.93976-1.09662-14.0238,4.32429-15.69525,8.615-7.76532-3.22446-16.21881,1.00136-16.21881,1.00136l25.6001,9.29375A19.37209,19.37209,0,0,0,802.66217,215.522Z" transform="translate(-384.54297 -170.14522)" fill="#3f3d56"/></svg>
              ''',
              width:400,
              height:400,
            ),
                )
                : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                if (selectedFilter != 'All') {
                  if (selectedFilter == 'Undone' &&
                      todos[index].status != TodoStatus.undone) {
                    return Container(); // Skip rendering if not 'Undone'
                  }
                  if (selectedFilter == 'Done' &&
                      todos[index].status != TodoStatus.done) {
                    return Container(); // Skip rendering if not 'Done'
                  }
                  if (selectedFilter == 'In Progress' &&
                      (!todos[index].isInProgress ||
                          todos[index].status == TodoStatus.done)) {
                    return Container(); // Skip rendering if not 'In Progress'
                  }
                  if (selectedFilter == 'Canceled' &&
                      todos[index].status != TodoStatus.canceled) {
                    return Container(); // Skip rendering if not 'Canceled'
                  }
                }
                return Column(
                  children: [
                    ListTile(
                      leading: Checkbox(
                        activeColor: const Color(0xFFBA68C8),
                        value: todos[index].status == TodoStatus.done,
                        onChanged: (bool? value) {
                          if (value != null) {
                            markAsDone(index);
                          }
                        },
                      ),
                      title: Row(
                        children: [
                          if (todos[index].isInProgress && todos[index].status != TodoStatus.done)
                            const Icon(Icons.access_time, color: Color(0xFFBA68C8)),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              todos[index].task,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                decoration: todos[index].status == TodoStatus.done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!todos[index].isInProgress &&
                              todos[index].status != TodoStatus.done)
                            IconButton(
                              icon: const Icon(Icons.play_arrow, color: Colors.green,),
                              onPressed: () {
                                markAsInProgress(index);
                              },
                            ),
                          if (todos[index].isInProgress &&
                              todos[index].status != TodoStatus.done)
                            IconButton(
                              icon: const Icon(Icons.stop, color: Colors.red,),
                              onPressed: () {
                                markAsUndone(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red,),
                              onPressed: () {
                                deleteTask(index);
                              },
                            ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(

                        thickness: 2.0,
                        color: Color(0xFFBA68C8),
                      ),
                    ),
                  ],
                );
              },
            )





          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Color(0xFFBA68C8)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                IconButton(
                  onPressed: () {
                    String task = taskController.text.trim();
                    if (task.isNotEmpty) {
                      addTodo(task);
                      taskController.clear();
                    }
                  },

                  icon:const Icon(
                      Icons.send,
                    color: Color(0xFFAB47BC),
                  ),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Todo {
  String task;
  TodoStatus status;
  bool isInProgress;

  Todo({
    required this.task,
    this.status = TodoStatus.undone,
    this.isInProgress = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      task: json['task'] as String,
      status: TodoStatus.values[json['status'] as int],
      isInProgress: json['isInProgress'] as bool,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'status': status.index,
      'isInProgress': isInProgress,
    };
  }
}

enum TodoStatus { undone, inProgress,done, canceled }
