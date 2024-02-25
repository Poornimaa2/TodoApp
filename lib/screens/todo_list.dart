import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_page.dart';
import 'package:http/http.dart'as http;
import 'package:todo_app/services/todo_services.dart';

import '../utils/snackbar_helper.dart';
import '../widget/todo_cart.dart';


class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading=true;
  List items=[];
 @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Todo List'),
      ),
          body: Visibility(
            visible: isLoading,
            child:  Center(child: CircularProgressIndicator(),),
            replacement: RefreshIndicator(
              onRefresh: fetchTodo,
              child: Visibility(
                visible: items.isNotEmpty,
                replacement: Center(
                  child:Text('NO TODO ITEM',
                  style: Theme.of(context).textTheme.headline3,
                ),
                ),
                child: ListView.builder(
                  itemCount: items.length,
                    padding: EdgeInsets.all(9),
                    itemBuilder: (context, index){
                    final item=items[index] as Map;
                    final id=item['_id']as String;
                
                    return  TodoCard(
                      index: index,
                      item: item,
                      deleteById: deleteById,
                      navigateEdit: navigateToEditPage,


                    );
                    },
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
        onPressed:navigateToAddPage,
        label: const Text('Add Todo'),
    ),
    );
  }
  Future<void> navigateToEditPage(Map item)async{
    final route=MaterialPageRoute(
      builder: (context)=> AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async{
 final route=MaterialPageRoute(
     builder: (context)=>const AddTodoPage(),
 );
 await Navigator.push(context, route);
 setState(() {
   isLoading=true;
 });
 fetchTodo();
  }

  Future<void> deleteById(String id) async{
   final isSuccess=await TodoService.deleteById(id);
   if(isSuccess){
   final filtered=items.where((element) => element['_id']!=id).toList();
   setState(() {
     items=filtered;
   });
   }
   else{
     showErrorMessage(context,message:'DELETION FAILED');
   }


}

  Future<void> fetchTodo() async {
   final response= await TodoService.fetchTodos();

    if (response!=null) {

      setState(() {
        items = response;
      });
    }
    else{
      showErrorMessage(context,message:'SOMETHING WENT WRONG..');
    }

    setState(() {
      isLoading = false;
    });
  }



}
