import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tba/shared/lists.dart';
// import 'package:tba/styles/style.dart';
import 'package:tba/db/sqlite_helper.dart';
import 'package:tba/services/router.dart';
import 'package:tba/pages/records/all.dart';
import 'package:tba/shared/snackbar_messages.dart';
import 'package:tba/styles/colors.dart';
import 'package:tba/services/preprocessor.dart';
import 'package:tba/services/date_time_helper.dart';

class InputIncomePage extends StatelessWidget {
  const InputIncomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Enter income'),
          centerTitle: true,
          backgroundColor: myGreen,
        ),
        body: Center(
          child: Container(
            // child: Text('Enter income!'),
            child: IncomeForm(),
          ),
        ));
  }
}

class IncomeForm extends StatefulWidget {
  const IncomeForm({Key? key}) : super(key: key);

  @override
  _IncomeFormState createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _incomeFormKey = GlobalKey<FormState>();

    TextEditingController incomeDate = TextEditingController();
  String? incomeSource;
  String? incomeAmount;

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
        incomeDate.text = formatDisplayedDate('$picked');
      });
  }

  @override
  Widget build(BuildContext context) {
    DateTime moment = DateTime.now();
    return Container(
      child: Form(
        key: _incomeFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
              margin: EdgeInsets.only(bottom: 20.0),
              padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
              child: Text(DateTimeHelper().dateInWords(moment), style: TextStyle(fontWeight: FontWeight.bold, color: myGreen, fontSize: 18.0),),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: incomeDate,
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
                    isExpanded: true, 
                    decoration: InputDecoration(labelText: 'Source of income'),
                    // hint: Text('Source of income'),
                    items: MyItemList().incomeList,
                    validator: (val) => val == null
                      ? 'Please select source of income!'
                      : null,
                    onChanged: (val) =>
                        setState(() => incomeSource = val as String?),
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.only(bottom: 10.0), 
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter amount!' : null,
                    onChanged: (val) => setState(() {
                      incomeAmount = val;
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
                          .localToDbFormat(incomeDate.text) ?? ts;
                        if (_incomeFormKey.currentState!.validate()) {
                          String parsedIncomeAmount =
                            InputHandler().moneyCheck(incomeAmount!);
                        SQLiteDatabaseHelper().insertRow('income',
                          incomeSource ?? '', parsedIncomeAmount, userSelectedDate).then((value) {
                            if(value != null) {
                              SnackBarMessage().saveSuccess(context);
                              PageRouter().navigateToPage(AllRecords(), context);
                            }
                          }); 
                      }
                      },
                      child: Text('SAVE'),
                      style:
                          ElevatedButton.styleFrom(primary: myGreen),
                    ),
                  )
                ],
              ),
            ],
          ),
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
