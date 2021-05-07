import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:term_paper_app_frontend/Models/post_model.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/pages/service_create_page.dart';
import 'package:term_paper_app_frontend/pages/services_page.dart';
import 'package:term_paper_app_frontend/providers/general_data_provider.dart';

class PostRegistrationPage extends StatefulWidget {
  final OperationType type;
  final PostModel post;
  PostRegistrationPage({Key key, @required this.type, this.post})
      : super(key: key);
  @override
  _PostRegistrationPageState createState() => _PostRegistrationPageState();
}

class _PostRegistrationPageState extends State<PostRegistrationPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String decription;
  String _postName;
  String _basicSalary;

  List<RegionModel> regions;
  GeneralDataProvider _gdprovider;
  @override
  void initState() {
    super.initState();
    if (widget.type == OperationType.update) {
      decription = widget.post.description;
      _postName = widget.post.postName;
      _basicSalary = widget.post.basicSalary.toString();
    }

    _gdprovider = GeneralDataProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == OperationType.create
            ? "Створення посади"
            : "Редагування посади"),
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
                      ? "Ви впевнені, що хочете скаcувати створення нової посади?"
                      : "Ви впевнені, що хочете скаcувати редагування посади?")); //true if can be popped
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
                          labelText: "Назва посади",
                          hintText: "Введіть назву посади"),
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : widget.post.postName,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _postName = value;
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
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Опис", hintText: "Введіть опис посади"),
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : widget.post.description,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        decription = value;
                      },
                      validator: validate,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Базова заробітня плата",
                          hintText: "Введіть базову заробітню плату"),
                      initialValue: widget.type == OperationType.create
                          ? ""
                          : widget.post.basicSalary.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _basicSalary = value;
                      },
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Поле не може бути пустим";
                        }
                        if (double.tryParse(text) == null) {
                          return "Неправильно введене значення";
                        }
                        double value = double.parse(text);
                        if (value < 5000)
                          return "Значення не може бути менше 5000";
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
                            ? "Створити посаду"
                            : "Редагувати посаду"),
                        onPressed: () async {
                          String title = widget.type == OperationType.create
                              ? "Зареєструвати"
                              : "Редагувати";
                          if (!await confirm(
                            context,
                            textOK: Text(title),
                            textCancel: Text("Скасувати"),
                            title: Text(widget.type == OperationType.create
                                ? "Реєстрація послуги"
                                : "Редагування послуги"),
                            content: Text(
                                "Ви впевнені, що хочете ${title.toLowerCase()} посаду?"),
                          )) {
                            return;
                          }
                          PostModel newPost =
                              widget.type == OperationType.create
                                  ? await registerPost()
                                  : await editPost();
                          if (newPost != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                    widget.type == OperationType.create
                                        ? "Успішно створено"
                                        : "Успішно редаговано")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ServicesPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(widget.type == OperationType.create
                                  ? "Не вдалось створити посаду"
                                  : "Не вдалось редагувати посаду"),
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

  Future<PostModel> registerPost() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return null;
    } else {
      PostModel post = PostModel(
        postName: _postName,
        description: decription,
        basicSalary: double.parse(_basicSalary),
      );
      var response = await _gdprovider.registerPost(post);
      return response;
    }
  }

  String validate(String text) {
    if (text.isNotEmpty && text.length > 2) return null;
    return "Поле не може бути пустим";
  }

  Future<PostModel> editPost() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) return null;
    PostModel editedPost = PostModel(
      postId: widget.post.postId,
      postName: _postName,
      description: decription,
      basicSalary: double.parse(_basicSalary),
    );
    return await _gdprovider.updatePost(editedPost);
  }
}
