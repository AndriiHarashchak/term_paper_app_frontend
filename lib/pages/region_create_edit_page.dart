import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/pages/regions_page.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class RegionCreateEditPage extends StatefulWidget {
  final OperationType type;
  final RegionModel region;
  RegionCreateEditPage({Key key, @required this.type, this.region})
      : super(key: key);
  @override
  _RegionCreateEditPageState createState() => _RegionCreateEditPageState();
}

class _RegionCreateEditPageState extends State<RegionCreateEditPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String regionName;

  GeneralDataProvider _gdprovider;
  @override
  void initState() {
    super.initState();
    if (widget.type == OperationType.update) {
      regionName = widget.region.regionName;
    }

    _gdprovider = GeneralDataProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == OperationType.create
            ? "Створення регіону"
            : "Редагування регіону"),
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
                      ? "Ви впевнені, що хочете скаcувати створення нового регіону?"
                      : "Ви впевнені, що хочете скаcувати редагування регіону?")); //true if can be popped
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
                          labelText: "Назва регіону",
                          hintText: "Введіть назву регіону"),
                      initialValue:
                          widget.type == OperationType.create ? "" : regionName,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        regionName = value;
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
                            ? "Створити регіон"
                            : "Редагувати регіон"),
                        onPressed: () async {
                          String title = widget.type == OperationType.create
                              ? "Зареєструвати"
                              : "Редагувати";
                          if (!await confirm(
                            context,
                            textOK: Text(title),
                            textCancel: Text("Скасувати"),
                            title: Text(widget.type == OperationType.create
                                ? "Створення регіону"
                                : "Редагування регіону"),
                            content: Text(
                                "Ви впевнені, що хочете ${title.toLowerCase()} регіон?"),
                          )) {
                            return;
                          }
                          RegionModel newRegion =
                              widget.type == OperationType.create
                                  ? await registerRegion()
                                  : await editRegion();
                          if (newRegion != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                    widget.type == OperationType.create
                                        ? "Успішно створено"
                                        : "Успішно редаговано")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => RegionsPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(widget.type == OperationType.create
                                  ? "Не вдалось створити регіон"
                                  : "Не вдалось редагувати регіон"),
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

  Future<RegionModel> registerRegion() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      RegionModel region = new RegionModel(regionName: regionName);
      var response = await _gdprovider.registerRegion(region);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не може бути пустим";
  }

  Future<RegionModel> editRegion() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) return null;
    RegionModel region =
        RegionModel(regionId: widget.region.regionId, regionName: regionName);
    return await _gdprovider.updateRegion(region);
  }
}
