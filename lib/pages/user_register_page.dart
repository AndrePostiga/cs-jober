import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grupolaranja20212/models/user_type.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';
import 'package:grupolaranja20212/view_models/user_register_view_model.dart';

enum PhotoOptions { camera, library }

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  _UserRegisterPage createState() => _UserRegisterPage();
}

class _UserRegisterPage extends State<UserRegisterPage> {
  final UserRegisterViewModel _userRegisterVM = UserRegisterViewModel();
  final _formKey = GlobalKey<FormState>();

  String _image = Constants.userDefaultPhoto;

  String _btnStoreMsg = "Gravar";

  List<DropdownMenuItem<int>> _dropDownUserTypesItens =
      <DropdownMenuItem<int>>[];
  int _userTypeId = 0;
  int _maxSearchDistance = 10;
  List<String> _skillsArr = <String>[];

  final _nameController = TextEditingController();
  final _linkedinUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _birthDayController = TextEditingController();
  final _birthMonthController = TextEditingController();
  final _birthYearController = TextEditingController();

  List<DropdownMenuItem<int>> _getDropDownUserTypesItems(
      List<UserType> dropDownUserTypesItens) {
    List<DropdownMenuItem<int>> items = <DropdownMenuItem<int>>[];
    for (UserType userType in dropDownUserTypesItens) {
      items.add(
          DropdownMenuItem(value: userType.id, child: Text(userType.type)));
    }
    return items;
  }

  void _selectPhotoFromPhotoLibrary() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var imgString = await _userRegisterVM.uploadPhoto(File(pickedFile.path));

      setState(() {
        _image = imgString;
      });
    }
  }

  void _selectPhotoFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      var imgString = await _userRegisterVM.uploadPhoto(File(pickedFile.path));

      setState(() {
        _image = imgString;
      });
    }
  }

  void _optionSelected(PhotoOptions option) {
    switch (option) {
      case PhotoOptions.camera:
        _selectPhotoFromCamera();
        break;
      case PhotoOptions.library:
        _selectPhotoFromPhotoLibrary();
        break;
    }
  }

  Future _initVars() async {
    var userTypes = await _userRegisterVM.getUserTypes();

    var firebaseUser = FirebaseAuth.instance.currentUser;

    var user =
        await _userRegisterVM.getUserByFirebaseAuthUid(firebaseUser!.uid);

    setState(() {
      _dropDownUserTypesItens = _getDropDownUserTypesItems(userTypes);
      if (user != null) {
        var birthDateParts = user.birthDate.split('-');
        _image =
            user.photoUrl.isEmpty ? Constants.userDefaultPhoto : user.photoUrl;
        _nameController.text = user.name;
        _linkedinUrlController.text = user.linkedinUrl;
        _descriptionController.text = user.description;
        _maxSearchDistance = user.maxSearchDistance;
        _userTypeId = user.typeId;
        _skillsArr = user.skills;
        _skillsController.text = _skillsArr.join(",");
        _birthDayController.text = birthDateParts[2];
        _birthMonthController.text = birthDateParts[1];
        _birthYearController.text = birthDateParts[0];
      } else {
        _nameController.text = firebaseUser.displayName ?? "";
        _image = firebaseUser.photoURL ?? Constants.userDefaultPhoto;
        _userTypeId = userTypes[0].id;
      }
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

  bool _isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future _save(BuildContext context) async {
    try {
      var skillsList =
          _skillsController.text.toUpperCase().split(",").toSet().toList();

      // tratamento pra evitar salvar array de skills c 1 string vazia caso n tenha skill nenhuma
      if (skillsList.length == 1) {
        if (skillsList.first == "") {
          skillsList = <String>[];
        }
      }

      if (_nameController.text.isEmpty) {
        throw "Preencha o seu nome";
      }

      if (_birthYearController.text.isEmpty) {
        throw "Preencha o ano do seu nascimento";
      } else {
        if (!_isNumeric(_birthYearController.text)) {
          throw "Preencha um ano de nascimento v??lido";
        } else {
          var year = int.parse(_birthYearController.text);
          if (year < 1) {
            throw "Preencha um ano superior a 1";
          }
        }
      }

      if (_birthMonthController.text.isEmpty) {
        throw "Preencha o m??s do seu nascimento";
      } else {
        if (!_isNumeric(_birthMonthController.text)) {
          throw "Preencha um m??s de nascimento v??lido";
        } else {
          var month = int.parse(_birthMonthController.text);
          if (month > 12 || month < 1) {
            throw "Preencha um m??s entre 1(janeiro) e 12(dezembro)";
          }
        }
      }

      if (_birthDayController.text.isEmpty) {
        throw "Preencha o dia do seu nascimento";
      } else {
        if (!_isNumeric(_birthDayController.text)) {
          throw "Preencha um dia de nascimento v??lido";
        } else {
          var day = int.parse(_birthDayController.text);
          if (day > 31 || day < 1) {
            throw "Preencha um dia entre 1 e 31";
          }
        }
      }
      setState(() {
        _btnStoreMsg = "Aguarde...";
      });

      await _userRegisterVM.createOrUpdateUserByFirebaseAuthUid(
          FirebaseAuth.instance.currentUser!.uid,
          _nameController.text,
          _linkedinUrlController.text,
          _image,
          _userTypeId,
          _descriptionController.text,
          _maxSearchDistance,
          skillsList,
          _birthYearController.text +
              '-' +
              _birthMonthController.text +
              '-' +
              _birthDayController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Grava????o realizada com sucesso!"),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _btnStoreMsg = "Gravar";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(child: Image.network(_image), width: 300, height: 300),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.purple),
                    ),
                    onPressed: () {},
                    child: PopupMenuButton<PhotoOptions>(
                      child: const Text("Defina sua Foto para o JOBer"),
                      onSelected: _optionSelected,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          child: Text("Tirar Foto usando a C??mera"),
                          value: PhotoOptions.camera,
                        ),
                        const PopupMenuItem(
                            child: Text("Seleciona uma foto da galeria"),
                            value: PhotoOptions.library)
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                ),
                const Text("Escolha o tipo de usu??rio"),
                Container(
                  padding: const EdgeInsets.all(4.0),
                ),
                DropdownButton(
                  value: _userTypeId,
                  items: _dropDownUserTypesItens,
                  onChanged: changedDropDownUserTypeItem,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                ),
                Text("Dist??ncia m??xima para encontrarmos: " +
                    (_userTypeId == 0 ? "Recrutadores" : "Candidatos") +
                    " => " +
                    _maxSearchDistance.toString() +
                    "KM."),
                Container(
                  padding: const EdgeInsets.all(16.0),
                ),
                Slider(
                  activeColor: Colors.purple,
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
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
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
                          controller: _skillsController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Informe " +
                                  (_userTypeId == 0
                                      ? "suas habilitades"
                                      : "as habilidades que procura") +
                                  " separadas por ','";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: (_userTypeId == 0
                                      ? "Suas habilitades"
                                      : "Liste as habilidades que procura") +
                                  " (separadas por ',')"),
                        ),
                        TextFormField(
                          controller: _linkedinUrlController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Informe a URL do seu perfil do LinkedIn";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: "URL do seu LinkedIn"),
                        ),
                        Text('Sua data de nascimento:'),
                        Row(
                          children: [
                            Flexible(
                                child: TextFormField(
                              controller: _birthDayController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Dia';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(hintText: "Dia"),
                            )),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: TextFormField(
                              controller: _birthMonthController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'M??s';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(hintText: "M??s"),
                            )),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: TextFormField(
                              controller: _birthYearController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ano';
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(hintText: "Ano"),
                            )),
                          ],
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Informe sua descri????o profissional";
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: "Sua descri????o"),
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70.0,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            _save(context);
                          },
                          child: Text(_btnStoreMsg)),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      height: 70.0,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            AppNavigator.navigateToLogoutPage(context);
                          },
                          child: const Text('logout')),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
