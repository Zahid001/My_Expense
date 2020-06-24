import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:my_expense/widgets/chart.dart';
import 'package:my_expense/widgets/new_transaction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_expense/model/transaction.dart';
import 'widgets/transactionList.dart';


void main() {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.pinkAccent,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'My Expenses',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();

  final expenseController = TextEditingController();
  bool _showChart = false;
  
  List<Transaction> _transactions = [
    // Transaction(id: '1', title: 'Mobile', amount: 1200.0, date: DateTime.now()),
    // Transaction(id: '2', title: 'Pen', amount: 5.0, date: DateTime.now()),
    // Transaction(id: '3', title: 'Paper', amount: 30.0, date: DateTime.now()),
  ];

  

  void _addTransaction(String title, double amount, DateTime selectedDate) {
    final newTransaction = Transaction(
        title: title,
        amount: amount,
        date: selectedDate,
        id: DateTime.now().toString());

    setState(() {
      _transactions.add(newTransaction);
    });
  }

  void startTransactionModal(BuildContext buildContext) {
    showModalBottomSheet(
      context: buildContext,
      builder: (_) {
        return NewTransaction(_addTransaction);
      },
      isScrollControlled: true,
    );
  }

  void removeToTrash(String id) {
    setState(() {
      _transactions.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  // void save(List<Transaction> transactions) async {
  //       final prefs = await SharedPreferences.getInstance();
  //       final key = 'my_int_key';
  //       final value = transactions;
  //       prefs.setString(key, value);
  //       print('saved $value');
  //     }

  // void read() async {
  //       final prefs = await SharedPreferences.getInstance();
  //       final key = 'my_int_key';
  //       final value = prefs.getInt(key) ?? 0;
  //       print('read: $value');
  //     }

  List<Transaction> get _recentTransactions {
    return _transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('My Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                  ),
                  onTap: () {
                    startTransactionModal(context);
                  },
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'My Expenses',
              style: GoogleFonts.palanquin(),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    startTransactionModal(context);
                  }),
            ],
          );
    final transactionList = Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(
            transactions: _transactions, deleteTransaction: removeToTrash));

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart',
                  style: Theme.of(context).textTheme.title,
                  ),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      })
                ],
              ),
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appbar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  :
                  //NewTransaction(_addTransaction),

                  _transactions.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'No Transaction!!!!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )
                      : transactionList,
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appbar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape)
              _transactions.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'No Transaction!!!!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  : transactionList,
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appbar,
            child: body,
          )
        : Scaffold(
            appBar: appbar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      startTransactionModal(context);
                    }),
          );
  }
}
