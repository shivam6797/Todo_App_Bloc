import 'package:bloc_sqlite_db_app/bloc/db_bloc.dart';
import 'package:bloc_sqlite_db_app/bloc/db_event.dart';
import 'package:bloc_sqlite_db_app/bloc/db_state.dart';
import 'package:bloc_sqlite_db_app/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  String selectedCategory = "Personal";
  int selectedPriority = 2; // Default Medium Priority
  TodoModel? todo; // Yeh null ho sakta hai agar naye task ke liye aaye hain

 bool _isInitialized = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_isInitialized) {  // Sirf pehli baar set hoga
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is TodoModel) {
      todo = args;
      titleController.text = todo!.title;
      descriptionController.text = todo!.description ?? "";
      dueDateController.text = todo!.dueDate ?? "";
      selectedCategory = todo!.category;
      selectedPriority = todo!.priority;
    }
    _isInitialized = true;
  }
}


  @override
  Widget build(BuildContext context) {
    bool isUpdating = todo != null;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xFFFEC89A),
        centerTitle: true,
        title: Text(
          isUpdating ? "Update Task" : "Add New Task",
          style: TextStyle(
              color: AppColors.darkBlack,
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: AppColors.darkBlack),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 16, right: 16, left: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFAF0),
                Color(0xFFFDF3E7),
                Color(0xFFFAE8D2),
              ],
            ),
          ),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      cursorColor: AppColors.darkBlack,
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        labelStyle: TextStyle(
                            color: AppColors.darkBlack,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.darkBlack, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.darkBlack, width: 1.0),
                        ),
                      ),
                      style: TextStyle(
                          color: AppColors.darkBlack,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      validator: (value) =>
                          value!.isEmpty ? "Title cannot be empty" : null,
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      cursorColor: AppColors.darkBlack,
                      controller: descriptionController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        labelText: "Description",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Enter msg here..",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.darkBlack),
                        labelStyle: TextStyle(
                            color: AppColors.darkBlack,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.darkBlack, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.darkBlack, width: 1.0),
                        ),
                      ),
                      style: TextStyle(
                          color: AppColors.darkBlack,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      maxLines: 6,
                    ),
                    SizedBox(height: 25),
                    DropdownButtonFormField<String>(
                      isDense: true,
                      borderRadius: BorderRadius.circular(10),
                      value: selectedCategory,
                      items: ["Personal", "Work", "Shopping", "Other"]
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Container(
                                    width: 100,
                                    alignment: Alignment.centerLeft,
                                    child: Text(category)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                      style: TextStyle(
                          color: AppColors.darkBlack,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: "Category",
                        labelStyle: TextStyle(
                            color: AppColors.darkBlack,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.darkBlack, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.darkBlack, width: 1.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: dueDateController,
                      style: TextStyle(
                          color: AppColors.darkBlack,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: "Due Date",
                        labelStyle: TextStyle(
                            color: AppColors.darkBlack,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.darkBlack, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.darkBlack, width: 1.0),
                        ),
                        suffixIcon: Icon(
                          FontAwesomeIcons.calendarDays,
                          color: AppColors.darkBlack,
                          size: 20,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dueDateController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Priority",
                      style: TextStyle(
                          color: AppColors.darkBlack,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChoiceChip(
                          labelPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          label: Text(
                            "Low",
                            style: TextStyle(
                                color: AppColors.darkBlack,
                                fontSize: 13,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold),
                          ),
                          selected: selectedPriority == 1,
                          onSelected: (_) {
                            setState(() {
                              selectedPriority = 1;
                            });
                          },
                        ),
                        ChoiceChip(
                          labelPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          label: Text(
                            "Medium",
                            style: TextStyle(
                                color: AppColors.darkBlack,
                                fontSize: 13,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold),
                          ),
                          selected: selectedPriority == 2,
                          onSelected: (_) {
                            setState(() {
                              selectedPriority = 2;
                            });
                          },
                        ),
                        ChoiceChip(
                          labelPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          label: Text(
                            "High",
                            style: TextStyle(
                                color: AppColors.darkBlack,
                                fontSize: 13,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold),
                          ),
                          selected: selectedPriority == 3,
                          onSelected: (_) {
                            setState(() {
                              selectedPriority = 3;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                    BlocListener<DBBloc, DBState>(
                      listener: (context, state) {
                        if (state is DBLoadedState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xFFFEC89A),
                              content: Text(
                                isUpdating
                                    ? "Task Updated Successfully"
                                    : "Task Added Successfully",
                                style: TextStyle(
                                  color: AppColors.darkBlack,
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );

                          // Sirf DBLoadedState me hi pop karna
                          Navigator.pop(context);
                        } else if (state is DBErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                state.errorMsg,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            TodoModel newTodo = TodoModel(
                              id: todo?.id,
                              title: titleController.text,
                              description: descriptionController.text,
                              category: selectedCategory,
                              priority: selectedPriority,
                              dueDate: dueDateController.text.isNotEmpty
                                  ? dueDateController.text
                                  : null,
                              createdAt:
                                  todo?.createdAt ?? DateTime.now().toString(),
                            );
                            if (isUpdating) {
                              context
                                  .read<DBBloc>()
                                  .add(UpdateTodoEvent(updateTodo: newTodo));
                            } else {
                              context
                                  .read<DBBloc>()
                                  .add(AddTodoEvent(newTodo: newTodo));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFEC89A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          "Save Task",
                          style: TextStyle(
                            color: AppColors.darkBlack,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
