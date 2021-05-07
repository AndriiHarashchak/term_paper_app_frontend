import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/office_model.dart';
import 'package:term_paper_app_frontend/pages/offices_page.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class OfficeCreatePage extends StatefulWidget {
  final OperationType type;
  final OfficeModel office;
  OfficeCreatePage({Key key, @required this.type, this.office})
      : super(key: key);
  @override
  _OfficeCreatePageState createState() => _OfficeCreatePageState();
}

class _OfficeCreatePageState extends State<OfficeCreatePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String officeAdress;

  GeneralDataProvider _gdprovider;
  @override
  void initState() {
    super.initState();
    if (widget.type == OperationType.update) {
      officeAdress = widget.office.adress;
    }

    _gdprovider = GeneralDataProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == OperationType.create
            ? "Створення офісу"
            : "Редагування офісу"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            //autovalidateMode: Auto ,
            onWillPop: () async {
              return await confirm(context,
                  title: Text("Скасування"),
                  textOK: Text(widget.type == OperationType.create
                      ? "Відмінити створення"
                      : "Відмінити редагування"),
                  textCancel: Text("Залишитись"),
                  content: Text(widget.type == OperationType.create
                      ? "Ви впевнені, що хочете скаcувати створення нового офісу?"
                      : "Ви впевнені, що хочете скаcувати редагування офісу?")); //true if can be popped
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Назва офісу",
                          hintText: "Введіть назву офісу"),
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : officeAdress,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        officeAdress = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) return "Не може бути пустим";
                        if (text.length < 3) {
                          return "Назва не може бути коротше ніж 3 символи";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(widget.type == OperationType.create
                            ? "Створити офіс"
                            : "Редагувати офіс"),
                        onPressed: () async {
                          String title = widget.type == OperationType.create
                              ? "Зареєструвати"
                              : "Редагувати";
                          if (!await confirm(
                            context,
                            textOK: Text(title),
                            textCancel: Text("Скасувати"),
                            title: Text(widget.type == OperationType.create
                                ? "Створення офісу"
                                : "Редагування офісу"),
                            content: Text(
                                "Ви впевнені, що хочете ${title.toLowerCase()} офіс?"),
                          )) {
                            return;
                          }
                          OfficeModel newOffice =
                              widget.type == OperationType.create
                                  ? await registerOffice()
                                  : await editRegion();
                          if (newOffice != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                    widget.type == OperationType.create
                                        ? "Успішно створено"
                                        : "Успішно редаговано")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => OfficesPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(widget.type == OperationType.create
                                  ? "Не вдалось створити офіс"
                                  : "Не вдалось редагувати офіс"),
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<OfficeModel> registerOffice() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      var response = await _gdprovider.registerOffice(officeAdress);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не може бути пустим";
  }

  Future<OfficeModel> editRegion() async {
    return null;
    //TODO implement in future;
    /* final FormState form = _formKey.currentState;
    if (!form.validate()) return null;
    OfficeModel office =
        OfficeModel(officeId: widget.office.officeId, adress: officeAdress);
    return await _gdprovider.(office); */
  }
}
