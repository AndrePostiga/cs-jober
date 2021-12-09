import 'dart:io';
import 'package:flutter/material.dart';
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

  String _image =
      "https://firebasestorage.googleapis.com/v0/b/jober-7722a.appspot.com/o/images%2Favatar.png?alt=media&token=0b1f609f-071d-47f1-a4c3-881971b54d67";

  String _btnStoreMsg = "Gravar e ir pra tela do SWIPE";

  List<DropdownMenuItem<int>> _dropDownUserTypesItens =
      <DropdownMenuItem<int>>[];
  int _userTypeId = 0;
  int _maxSearchDistance = 10;
  List<String> _skillsArr = <String>[];

  final _nameController = TextEditingController();
  final _linkedinUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();

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
    var user = await _userRegisterVM
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _dropDownUserTypesItens = _getDropDownUserTypesItems(userTypes);
      if (user != null) {
        _image = user.photoUrl.isEmpty
            ? "https://firebasestorage.googleapis.com/v0/b/jober-7722a.appspot.com/o/images%2Favatar.png?alt=media&token=0b1f609f-071d-47f1-a4c3-881971b54d67"
            : user.photoUrl;
        _nameController.text = user.name;
        _linkedinUrlController.text = user.linkedinUrl;
        _descriptionController.text = user.linkedinUrl;
        _maxSearchDistance = user.maxSearchDistance;
        _userTypeId = user.typeId;
        _skillsArr = user.skills;
        _skillsController.text = _skillsArr.join(",");
      } else {
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

  Future _saveAndRedirectToSwipePage(BuildContext context) async {
    try {
      await _userRegisterVM.createOrUpdateUserByFirebaseAuthUid(
          FirebaseAuth.instance.currentUser!.uid,
          _nameController.text,
          _linkedinUrlController.text,
          _image,
          _userTypeId,
          _descriptionController.text,
          _maxSearchDistance,
          _skillsController.text.split(","));
    } catch (e) {
      _btnStoreMsg = e.toString();
    }

    await AppNavigator.navigateToSwipePage(context);
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
                  SizedBox(
                      child: Image.network(_image), width: 300, height: 300),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: PopupMenuButton<PhotoOptions>(
                        child: const Text("Defina sua Foto para o JOBer"),
                        onSelected: _optionSelected,
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            child: Text("Tirar Foto usando a Câmera"),
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
                  const Text("Escolha o tipo de usuário"),
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
                  Text("Distância máxima para encontrarmos: " +
                      (_userTypeId == 0 ? "Recrutadores" : "Candidatos") +
                      " => " +
                      _maxSearchDistance.toString() +
                      "KM."),
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
                  TextButton(
                      onPressed: () {
                        _saveAndRedirectToSwipePage(context);
                      },
                      child: Text(_btnStoreMsg))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
