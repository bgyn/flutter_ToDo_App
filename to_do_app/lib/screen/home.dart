import 'package:flutter/material.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:to_do_app/model/todo.dart';
import 'package:to_do_app/widget/todo_item.dart';

class home extends StatefulWidget {
  home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final todolist = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _foundToDo = todolist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppbar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          children: [
            Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed)
                        todoItem(
                          todo: todo,
                          onToDoChange: _handleToDoChange,
                          onDeleteItem: _onDeleteItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                        right: 10,
                        left: 10,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: InputDecoration(
                          hintText: 'Add a new todo item',
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5, right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        _addToDoItem(_todoController.text);
                        setState(() {});
                      },
                      child: Text(
                        '+',
                        style: TextStyle(fontSize: 30),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: tdBlue,
                          minimumSize: Size(55, 55),
                          elevation: 10),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          hintStyle: TextStyle(color: tdGrey),
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: tdBGColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
          ),
          Container(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpg'),
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _onDeleteItem(String id) {
    setState(() {
      todolist.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String todo) {
    todolist.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(), todoText: todo));
    _todoController.clear();
  }

  void _runFilter(String enterKeyword) {
    List<ToDo> results = [];
    if (enterKeyword.isEmpty) {
      results = todolist;
    } else {
      results = todolist
          .where((item) =>
              item.todoText!.toLowerCase().contains(enterKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }
}
