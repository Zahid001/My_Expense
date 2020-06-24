import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addExpense;

  NewTransaction(this.addExpense);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final expenseController = TextEditingController();
  DateTime selectedDate;
/*
  void removeToTrash(String id){
    _transactions.removeWhere((element) {
        element.id == id;
    }); 
  }
*/
  void addTransaction() {
    if (expenseController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(expenseController.text);

    if (enteredTitle.isEmpty == true ||
        (enteredAmount <= 0) ||
        selectedDate == null) {
      return;
    }

    widget.addExpense(titleController.text,
        double.parse(expenseController.text), selectedDate);
    Navigator.of(context).pop();
  }

  void getCalender() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).viewInsets.left + 50,
                right: MediaQuery.of(context).viewInsets.right + 50,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    onSubmitted: (_) => addTransaction,
                  ),
                  TextField(
                    controller: expenseController,
                    decoration: InputDecoration(
                      labelText: 'Expense',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => addTransaction,
                  ),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'No date selected!'
                                : DateFormat.yMEd().format(selectedDate),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            child: Text('Choose date'),
                            onPressed: getCalender,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Expense'),
                    textColor: Colors.white,
                    color: Colors.pink,
                    onPressed: addTransaction,
                  ),
                  Container(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).viewInsets.left + 20,
                right: MediaQuery.of(context).viewInsets.right + 20,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    onSubmitted: (_) => addTransaction,
                  ),
                  TextField(
                    controller: expenseController,
                    decoration: InputDecoration(
                      labelText: 'Expense',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => addTransaction,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 12,
                      left: 8,
                      bottom: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'No date selected!'
                                : DateFormat.yMEd().format(selectedDate),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            child: Text('Choose date'),
                            onPressed: getCalender,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Expense'),
                    textColor: Colors.white,
                    color: Colors.pink,
                    onPressed: addTransaction,
                  ),
                  Container(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
  }
}
