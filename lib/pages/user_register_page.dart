import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user_type.dart';
import 'package:grupolaranja20212/view_models/user_register_view_model.dart';

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  _UserRegisterPage createState() => _UserRegisterPage();
}

class _UserRegisterPage extends State<UserRegisterPage> {
  final UserRegisterViewModel _userRegisterVM = UserRegisterViewModel();
  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<int>> _dropDownUserTypesItens =
      <DropdownMenuItem<int>>[];
  int _userTypeId = 0;
  int _maxSearchDistance = 10;
  final _nameController = TextEditingController();
  final _linkedinUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<DropdownMenuItem<int>> _getDropDownUserTypesItems(
      List<UserType> dropDownUserTypesItens) {
    List<DropdownMenuItem<int>> items = <DropdownMenuItem<int>>[];
    for (UserType userType in dropDownUserTypesItens) {
      items.add(
          DropdownMenuItem(value: userType.id, child: Text(userType.type)));
    }
    return items;
  }

  Future _initVars() async {
    var userTypes = await _userRegisterVM.getUserTypes();
    setState(() {
      _dropDownUserTypesItens = _getDropDownUserTypesItems(userTypes);
      _userTypeId = userTypes[0].id;
    });
  }

  @override
  void initState() {
    super.initState();
    _initVars();
  }

  void changedDropDownUserTypeItem(int? selectedUserTypeId) {
    setState(() {
      _userTypeId = selectedUserTypeId ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro do Usuário',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Registro do Usuário'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("Escolha o tipo de usuário"),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                  ),
                  DropdownButton(
                    value: _userTypeId,
                    items: _dropDownUserTypesItens,
                    onChanged: changedDropDownUserTypeItem,
                  ),
                  Text("Qual distância máxima para encontrarmos: " +
                      (_userTypeId == 0 ? "Recrutadores" : "Candidatos")),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                  ),
                  Slider(
                    value: _maxSearchDistance.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: _maxSearchDistance.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _maxSearchDistance = value.toInt();
                      });
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Informe seu nome";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Nome"),
                  ),
                  TextFormField(
                    controller: _linkedinUrlController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Informe a URL do seu perfil do LinkedIn";
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: "URL do seu LinkedIn"),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Informe sua descrição profissional";
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: "Sua descrição"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
