import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/services/todo_services.dart';

import '../utils/snackbar_helper.dart';
class AddTodoPage extends StatefulWidget {
  final Map?todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
bool isEdit=false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo=widget.todo;
    if(todo!=null)
      {
        isEdit=true;
        final title= todo['title'];
        final description= todo['description'];
        titleController.text=title;
        descriptionController.text=description;
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              isEdit?'Edit Todo': 'Add Todo',
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Description'),

              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEdit? updateData:submitData,

              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    isEdit?'Update':'Submit',
                ),
              ),
            )

          ],
        )
    );
  }
  Future<void> updateData() async {
    final todo=widget.todo;
    if(todo==null){
      print('You cannot call updated without todo data');
      return;
    }
    final id=todo['_id'];


    //https://api.nstack.in/v1/todos/65d9fd3453b31801f8f40de8


    final isSuccess = await TodoService.updateTodo(id, body);

    if (isSuccess) {

      showSuccessMessage(context, message: 'Updating Success');
    }
    else {
      showErrorMessage(context, message: 'Updating Failed');
    }
  }


  Future<void> submitData() async {


    final isSuccess = await TodoService.addTodo(body);
    if (isSuccess) {
      titleController.text='';
      descriptionController.text='';
      showSuccessMessage(context, message:'Creation Success');
    }
    else {
     showErrorMessage(context, message:'Creation Failed');
    }
  }

  Map get body{

    final title = titleController.text;
    final description = descriptionController.text;
return{
      "title": title,
      "description": description,
      "is_completed": false,
    };

  }

}
