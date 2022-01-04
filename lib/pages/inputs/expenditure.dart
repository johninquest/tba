import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tba/services/date_time_helper.dart';
import 'package:tba/shared/snackbar_messages.dart';
import 'package:tba/styles/colors.dart';
import 'package:tba/shared/lists.dart';
import 'package:tba/db/sqlite_helper.dart';
import 'package:tba/services/router.dart';
import 'package:tba/services/preprocessor.dart';
import 'package:tba/pages/records/all.dart';

class InputExpenditurePage extends StatelessWidget {
  // const InputExpenditure({ Key? key })//  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Enter expenditure'),
          centerTitle: true,
          backgroundColor: myRed,
        ),
        body: Center(
          child: ExpenditureForm(),
        ));
  }
}

class ExpenditureForm extends StatefulWidget {
  const ExpenditureForm({Key? key}) : super(key: key);

  @override
  _ExpenditureFormState createState() => _ExpenditureFormState();
}

class _ExpenditureFormState extends State<ExpenditureForm> {
  final _expenditureFormKey = GlobalKey<FormState>();

  //Form values
  TextEditingController expenditureDate = TextEditingController();
  String? expenditureSource;
  String? expenditureAmount;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        expenditureDate.text = formatDisplayedDate('$picked');
      });
  }

  @override
  Widget build(BuildContext context) {
    DateTime moment = DateTime.now();
    return Form(
      key: _expenditureFormKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
              child: Text(
                DateTimeHelper().dateInWords(moment),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: myRed, fontSize: 18.0),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: expenditureDate,
                  enabled: true,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Date'),
                  keyboardType: TextInputType.number,
                  onTap: () => _selectDate(context),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: DropdownButtonFormField(
                  decoration:
                      InputDecoration(labelText: 'Reason for expenditure'),
                  items: MyItemList().expenditureList,
                  validator: (val) => val == null
                      ? 'Please select reason for expenditure'
                      : null,
                  onChanged: (val) => setState(() {
                    expenditureSource = val as String?;
                  }),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter amount';
                    }
                  },
                  onChanged: (val) => setState(() {
                    expenditureAmount = val;
                  }),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('CANCEL'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      String ts = DateTimeHelper().toDbFormat(moment);
                      String userSelectedDate = DateTimeHelper()
                          .localToDbFormat(expenditureDate.text) ?? ts;
                       if (_expenditureFormKey.currentState!.validate()) {
                        String parsedExpenditureAmount =
                            InputHandler().moneyCheck(expenditureAmount!);
                        SQLiteDatabaseHelper()
                            .insertRow('expenditure', expenditureSource ?? '',
                                parsedExpenditureAmount, userSelectedDate)
                            .then((value) {
                          if (value != null) {
                            SnackBarMessage().saveSuccess(context);
                            PageRouter().navigateToPage(AllRecords(), context);
                          }
                        });
                      }
                    },
                    child: Text('SAVE'),
                    style: ElevatedButton.styleFrom(primary: myRed),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

formatDisplayedDate(String dt) {
  if (DateTime.tryParse(dt) != null && dt != '') {
    DateTime parsedDatTime = DateTime.parse(dt);
    DateFormat cmrDateFormat = DateFormat('dd/MM/yyyy');
    String toCmrDateFormat = cmrDateFormat.format(parsedDatTime);
    return toCmrDateFormat;
  } else {
    return '--/--/----';
  }
}
