import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/image.picker.controller.dart';
import '../Widgets/editTextBackground.dart';
import '../controllers/checkInternetConnection.dart';
import '../controllers/mySqlConnection.dart';
import 'home.dart';
import 'login.dart';

String? emaill;
String? emailDataBase;
var results;
final connection2=MySQLConnection();

getEmailfromDatabase(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  emaill = prefs.getString('email');
  final conn = await connection2.getConnection();

   results = await conn.query(
      'SELECT * FROM userDetails WHERE email = ?',
      [emaill]);

  print(emaill.toString()+'jhewbdjhsgj');
  print(results.toString()+'hsjkgfdjhwgejh');


  if(results.isNotEmpty)
    {
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  home()));
      Fluttertoast.showToast(
          msg: 'Welcome back',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
    }
  await conn.close();
  return emailDataBase;
}

class Profile extends StatelessWidget {

    Profile({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {

    getEmailfromDatabase(context);

    final size = MediaQuery.of(context).size;

    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.white), onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const login())); },
        ),
        title: const Text("Build profile"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
                child: buildCard(size,context)
          ),
        ),
      ),
    );
  }
}

Widget buildCard(Size size, BuildContext context) {

  return SizedBox(
    width: size.width * 0.9,
    height: size.height * 1.2,
    child: Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              const ProfileAvatar(),
              avatarHint(),
              SizedBox(
                height: size.height * 0.02,
              ),
              userNameHint(),
              userNameTextField(),
              SizedBox(
                height: size.height * 0.02,
              ),
              ageHint(),
              const ageClass(),
              SizedBox(
                height: size.height * 0.02,
              ),
              genderHint(),
              const genderClass(),
              SizedBox(
                height: size.height * 0.02,
              ),
              nationalityHint(),
              const nationalityClass(),
              SizedBox(
                height: size.height * 0.02,
              ),
              accentHint(),
              const accentClass(),
              SizedBox(
                height: size.height * 0.02,
              ),
              speechPatternHint(),
              const speechPatternClass(),
              SizedBox(
                height: size.height * 0.02,
              ),
              privacyPolicy(context),
              SizedBox(
                height: size.height*0.06,
              ),
              save(size,context),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

TextEditingController UserName = TextEditingController();

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CheckboxController());
    final controller = Get.put(ImagePickerController());
    return SizedBox(

      width: Get.size.width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Material(
            color: Colors.grey,
            shape: const CircleBorder(),
            child: Container(

              padding: EdgeInsets.all(Get.size.height * 0.001),
              child: Obx(() => InkWell(
                  onTap: () {controller.getImage(isCamera: false);},
                  child: CircleAvatar(
                      radius: Get.size.height * 0.07,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: FileImage(File(controller.image.value.path))
                  )
              ),
              ),
            ),

          ),
        ],
      ),
    );
  }
}

avatarHint() {
  return Column(
    children: const <Widget>[
      Align(
        alignment: Alignment.center,
        child: Text(
            "Create avatar"
        ),
      ),
    ],
  );
}

userNameHint() {
  return const SizedBox(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text("Username"),
    ),
  );
}

Widget userNameTextField() {

  return Container(
    decoration:  BoxDecoration(
      borderRadius:  BorderRadius.circular(15),
      color: const Color.fromRGBO(248, 247, 251, 1),
    ),

    child:  TextField(
        controller: UserName,
        cursorColor: Colors.black,
        keyboardType: TextInputType.name,
        textAlign: TextAlign.start,
        decoration: editTextDecoration.copyWith(
            hintText: 'Enter your name'
        )
    ),
  );
}

ageHint() {
  return const Align(
    alignment: Alignment.centerLeft,
    child: Text(
      'Age',
    ),
  );
}

class ageClass extends StatelessWidget {
  const ageClass({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(

      alignment: Alignment.center,
      height: size.height / 15,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(15.0),
        color: const Color.fromRGBO(248, 247, 251, 1),
        border: Border.all(color: Colors.black,width:0.5),

      ),

      child: Padding(

        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Obx(() => DropdownButton(
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          menuMaxHeight: 150,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 0,
          ),
          onChanged: (newValue) {
            ageController.setAge(newValue as String);
          },

          value:  ageController.selectedAge.value,

          items: ageController.ageList.map((selectedItem) {
            return DropdownMenuItem(
              value: selectedItem,
              child: Text(
                selectedItem,
              ),
            );
          }).toList(),
        )),
      ),
    );
  }
}

genderHint() {
  return  const
  Align(
    alignment: Alignment.centerLeft,
    child: Text(
        "Gender"),
  );
}

class genderClass extends StatelessWidget {


  const genderClass({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(

      alignment: Alignment.center,
      height: size.height / 15,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(15.0),
        color: const Color.fromRGBO(248, 247, 251, 1),
        border: Border.all(color: Colors.black,width:0.5),

      ),

      child: Padding(

        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),


        child: Obx(() => DropdownButton(
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          menuMaxHeight: 150,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 0,
          ),
          onChanged: (newValue) {
            genderController.setGender(newValue as String);
          },
          value: genderController.selectedGender.value,
          items: genderController.genderList.map((selectedItem) {
            return DropdownMenuItem(
              value: selectedItem,
              child: Text(
                selectedItem,
              ),
            );
          }).toList(),
        )),
      ),
    );
  }
}

nationalityHint() {
  return const Align(
    alignment: Alignment.centerLeft,
    child: Text(
        "Nationality"),
  );
}

class nationalityClass extends StatelessWidget {
  const nationalityClass({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(

      alignment: Alignment.center,
      height: size.height / 15,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(15.0),
        color: const Color.fromRGBO(248, 247, 251, 1),
        border: Border.all(color: Colors.black,width:0.5),

      ),

      child: Padding(

        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),


        child: Obx(() => DropdownButton(
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          menuMaxHeight: 150,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 0,
          ),
          onChanged: (newValue) {
            nationalityController.setNationality(newValue as String);
          },
          value: nationalityController.selectedNationality.value,
          items: nationalityController.nationalityList.map((selectedItem) {
            return DropdownMenuItem(

              value: selectedItem,
              child: Text(
                selectedItem,
              ),
            );
          }).toList(),
        )),
      ),

    );
  }
}

accentHint() {
  return
    const Align(
      alignment: Alignment.centerLeft,
      child: Text("Accent"),
    );
}

class accentClass extends StatelessWidget {
  const accentClass({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(

      alignment: Alignment.center,
      height: size.height / 15,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(15.0),
        color: const Color.fromRGBO(248, 247, 251, 1),
        border: Border.all(color: Colors.black,width:0.5),

      ),

      child: Padding(

        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),


        child: Obx(() => DropdownButton(
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          menuMaxHeight: 150,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 0,
          ),
          onChanged: (newValue) {
            accentController.setAccent(newValue as String);
          },
          value: accentController.selectedAccent.value,
          items: accentController.accentList.map((selectedItem) {
            return DropdownMenuItem(

              value: selectedItem,
              child: Text(
                selectedItem,
              ),
            );
          }).toList(),
        )),
      ),

    );
  }
}

speechPatternHint() {
  return  const Align(
    alignment: Alignment.centerLeft,
    child: Text(
        "Speech pattern"),
  );
}

class speechPatternClass extends StatelessWidget {
  const speechPatternClass({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(

      alignment: Alignment.center,
      height: size.height / 15,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(15.0),
        color: const Color.fromRGBO(248, 247, 251, 1),
        border: Border.all(color: Colors.black,width:0.5),

      ),

      child: Padding(

        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),


        child: Obx(() => DropdownButton(
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          menuMaxHeight: 150,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 0,
          ),
          onChanged: (newValue) {
            speechPatternController.setSpeechPattern(newValue as String);
          },
          value: speechPatternController.selectedSpeechPattern.value,
          items: speechPatternController.speechPatterntList.map((selectedItem) {
            return DropdownMenuItem(

              value: selectedItem,
              child: Text(
                selectedItem,
              ),
            );
          }).toList(),
        )),
      ),

    );
  }
}

Widget save(Size size, BuildContext context) {

  return InkWell(
    onTap: () {

       if(controller.image.value.name.isEmpty)
      {
      Fluttertoast.showToast(
      msg: 'Please add your avatar',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white
      );
       
      }
      else if (UserName.text == '') {
         
        Fluttertoast.showToast(
            msg: 'User name should not be empty',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
      else if( ageController.selectedAge.toString()=='Select')
      {
         
        Fluttertoast.showToast(
            msg: 'Please add your age',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
      else if( genderController.selectedGender.toString()=='Select')
      {
         
        Fluttertoast.showToast(
            msg: 'Please add your gender',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
      else if( nationalityController.selectedNationality.toString()=='Select')
      {
         
        Fluttertoast.showToast(
            msg: 'Please add your nationality',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
      else if( accentController.selectedAccent.toString()=='Select')
      {
         
        Fluttertoast.showToast(
            msg: 'Please add your accent',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
      else if(speechPatternController.selectedSpeechPattern.toString()=='Select')
      {
         
        Fluttertoast.showToast(
            msg: 'Please add your speech pattern',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
      else if(!Get.find<CheckboxController>()._checkBox.value)
      {
         
        Fluttertoast.showToast(
            msg: 'Check privacy policy first',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white
        );
      }
      else {
         showDialog(
           context: context,
           barrierDismissible: false,
           builder: (context) {
             return AlertDialog(
               content: Row(
                 children: const [
                   CircularProgressIndicator(),
                   SizedBox(width: 10),
                   Text('Building profile...'),
                 ],
               ),
             );
           },
         );
    sendData(context);
      }
    },
    child: Container(
      alignment: Alignment.center,
      height: size.height / 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: const Color(0xFF000000),
      ),
      child: Text(
        'Save',
        style: GoogleFonts.inter(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Future sendData(BuildContext context) async {

  await CheckInternetConnection.check(context);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("name", UserName.text);

    try {
      var response = await http.post(
          Uri.parse("https://repmedata.com/uploadData/insertUserDetails.php"),
          body: {
            "email": emaill,
            "name": UserName.text,
            "accent": accentController.selectedAccent.toString(),
            "age": ageController.selectedAge.toString(),
            "gender": genderController.selectedGender.toString(),
            "image": controller.image.value.name.toString(),
            "nationality": nationalityController.selectedNationality.toString(),
            "speechPattern": speechPatternController.selectedSpeechPattern.toString()
          }
      );
    }
    catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'System error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
      print(e.toString());
    }
    uploadImage(context);

}

Future<void> uploadImage(BuildContext context) async {
  String uploadAudioUrl = 'https://repmedata.com/uploadImage.php';
  try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadAudioUrl));

      request.files.add(await http.MultipartFile.fromPath(
          'image', controller.image.value.path.toString()));

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Profile saved successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>  home()));

        print('Image file successfully uploaded to the server!');
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: "An error occurred while uploading the image file to the server");
      }
    }
    catch (e) {
      if (kDebugMode) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: 'System error');
        //  print(e.toString());
      }
    }
  }

privacyPolicy(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
       Obx(() =>
          GestureDetector(
            onTap: () {
              Get.find<CheckboxController>().toggleCheckbox();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Get.find<CheckboxController>()._checkBox.value ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Icon(
                Get.find<CheckboxController>()._checkBox.value ? Icons.check : Icons.check_box_outline_blank_outlined,
                color: Colors.white,
              ),
            ),
          ),
       ),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 8, 0, 0),
  child: GestureDetector(
  onTap: () {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => WebviewScaffold(
          url: "https://repmedata.com/privacynotice.html",
          appBar: AppBar(
            title: Text("Privacy policy"),
          ),
        ),
      ),
    );
    },
        child:Text.rich(
          TextSpan(
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: const Color(0xFF000000),
            ),
            children: const [
              TextSpan(
                text: 'Privacy policy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '\nI am okay with you handling this info\nas you explain in ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Privacy Policy.',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    ],
  );
}

AgeController ageController = AgeController();
GenderController genderController = GenderController();
AccentController accentController = AccentController();
NationalityController nationalityController = NationalityController();
SpeechPatternController speechPatternController = SpeechPatternController();
final controller = Get.put(ImagePickerController());

class AgeController extends GetxController {

  var selectedAge = "Select".obs;

  List<String> ageList = <String>['Select','<19','19-29', '29-39', '39-49','49-59','59-69','69-79','79-89','>89'];

  void setAge(String age) {
    selectedAge.value = age;
  }
}

class GenderController extends GetxController {

  var selectedGender = "Select".obs;

  List<String> genderList =<String>['Select','Male', 'Female', 'Other'];

  void setGender(String gender) {
    selectedGender.value = gender;
  }
}

class NationalityController extends GetxController {

  var selectedNationality = "Select".obs;

  List<String> nationalityList =<String>['Select',

    'Afghan',
    'Albanian',
    'Algerian',
    'American',
    'Andorran',
    'Angolan',
    'Antiguans',
    'Argentinean',
    'Armenian',
    'Australian',
    'Austrian',
    'Azerbaijani',
    'Bahamian',
    'Bahraini',
    'Bangladeshi',
    'Barbadian',
    'Barbudans',
    'Batswana',
    'Belarusian',
    'Belgian',
    'Belizean',
    'Beninese',
    'Bhutanese',
    'Bolivian',
    'Bosnian',
    'Brazilian',
    'British',
    'Bruneian',
    'Bulgarian',
    'Burkinabe',
    'Burmese',
    'Burundian',
    'Cambodian',
    'Cameroonian',
    'Canadian',
    'CapeVerdean',
    'CentralAfrican',
    'Chadian',
    'Chilean',
    'Chinese',
    'Colombian',
    'Comoran',
    'Congolese',
    'CostaRican',
    'Croatian',
    'Cuban',
    'Cypriot',
    'Czech',
    'Danish',
    'Djibouti',
    'Dominican',
    'Dutch',
    'EastTimorese',
    'Ecuadorean',
    'Egyptian',
    'Emirian',
    'EquatorialGuinean',
    'Eritrean',
    'Estonian',
    'Ethiopian',
    'Fijian',
    'Filipino',
    'Finnish',
    'French',
    'Gabonese',
    'Gambian',
    'Georgian',
    'German',
    'Ghanaian',
    'Greek',
    'Grenadian',
    'Guatemalan',
    'GuineaBissauan',
    'Guinean',
    'Guyanese',
    'Haitian',
    'Herzegovinian',
    'Honduran',
    'Hungarian',
    'IKiribati',
    'Icelander',
    'Indian',
    'Indonesian',
    'Iranian',
    'Iraqi',
    'Irish',
    'Israeli',
    'Italian',
    'Ivorian',
    'Jamaican',
    'Japanese',
    'Jordanian',
    'Kazakhstani',
    'Kenyan',
    'KittianandNevisian',
    'Kuwaiti',
    'Kyrgyz',
    'Laotian',
    'Latvian',
    'Lebanese',
    'Liberian',
    'Libyan',
    'Liechtensteiner',
    'Lithuanian',
    'Luxembourger',
    'Macedonian',
    'Malagasy',
    'Malawian',
    'Malaysian',
    'Maldivian',
    'Malian',
    'Maltese',
    'Marshallese',
    'Mauritanian',
    'Mauritian',
    'Mexican',
    'Micronesian',
    'Moldovan',
    'Monacan',
    'Mongolian',
    'Moroccan',
    'Mosotho',
    'Motswana',
    'Mozambican',
    'Namibian',
    'Nauruan',
    'Nepalese',
    'NewZealander',
    'NiVanuatu',
    'Nicaraguan',
    'Nigerian',
    'Nigerien',
    'NorthKorean',
    'NorthernIrish',
    'Norwegian',
    'Omani',
    'Pakistani',
    'Palauan',
    'Panamanian',
    'PapuaNewGuinean',
    'Paraguayan',
    'Peruvian',
    'Polish',
    'Portuguese',
    'Qatari',
    'Romanian',
    'Russian',
    'Rwandan',
    'SaintLucian',
    'Salvadoran',
    'Samoan',
    'SanMarinese',
    'SaoTomean',
    'Saudi',
    'Scottish',
    'Senegalese',
    'Serbian',
    'Seychellois',
    'SierraLeonean',
    'Singaporean',
    'Slovakian',
    'Slovenian',
    'SolomonIslander',
    'Somali',
    'SouthAfrican',
    'SouthKorean',
    'Spanish',
    'SriLankan',
    'Sudanese',
    'Surinamer',
    'Swazi',
    'Swedish',
    'Swiss',
    'Syrian',
    'Taiwanese',
    'Tajik',
    'Tanzanian',
    'Thai',
    'Togolese',
    'Tongan',
    'TrinidadianorTobagonian',
    'Tunisian',
    'Turkish',
    'Tuvaluan',
    'Ugandan',
    'Ukrainian',
    'Uruguayan',
    'Uzbekistani',
    'Venezuelan',
    'Vietnamese',
    'Welsh',
    'Yemenite',
    'Zambian',
    'Zimbabwean'
  ];

  void setNationality(String nationality) {
    selectedNationality.value = nationality;
  }
}

class AccentController extends GetxController {

  var selectedAccent = "Select".obs;

  List<String> accentList = <String>['Select','I have a standard American English Accent', 'I have a non-native  English Accent '];

  void setAccent(String accent) {
    selectedAccent.value = accent;
  }
}

class SpeechPatternController extends GetxController {

  var selectedSpeechPattern = "Select".obs;

  List<String> speechPatterntList = <String>['Select','Typical', 'Atypical'];

  void setSpeechPattern(String speechPattern) {
    selectedSpeechPattern.value = speechPattern;
  }
}


class CheckboxController extends GetxController {
  final _checkBox = false.obs;

  void toggleCheckbox() {
    _checkBox.value = !_checkBox.value;
  }
}