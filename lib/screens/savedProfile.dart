import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/checkInternetConnection.dart';
import '../controllers/mySqlConnection.dart';
import 'home.dart';

final connection2=MySQLConnection();
int? loginId;
String? email2;
String imageName='';


class savedProfile extends StatefulWidget {
  const savedProfile({Key? key}) : super(key: key);

  @override
  _savedProfileState createState() => _savedProfileState();
}

class _savedProfileState extends State<savedProfile> {

  bool _isReady = false;
  String age = '';
  String gender = '';
  String accent = '';
  String nationality = '';
  String name = '';
  String speechPattern = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _getValueFromPrefs();
    _getUserData();
    getImageName().then((_) {
      build(context);
      setState(() {
        _isReady = true;
      }
      );
    }
    );
  }

  _getUserData() async {
    await CheckInternetConnection.check(context);
    final conn = await connection2.getConnection();

    final results = await conn.query(
        'SELECT * FROM userDetails WHERE email = ?',
        [email2]);

    for (var row in results) {
      setState(() {
        age = row['age'];
        gender = row['gender'];
        accent = row['accent'];
        nationality = row['nationality'];
        name = row['name'];
        speechPattern = row['speechPattern'];
        email = row['email'];
      }
      );
    }
  }

  getImageName() async {

      await CheckInternetConnection.check(context);
      final conn = await connection2.getConnection();
      final results = await conn.query(
          'SELECT image FROM userDetails WHERE email = ?',
          [email2]);

      for (var row in results) {
        imageName = row['image'];
      }
      conn.close();
      return imageName;
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    if (_isReady) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
            onPressed: () =>
            (
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => home()))),),
          title: Text("Profile"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  buildCard(size, context)
                ],
              ),
            ),
          ),
        ),
      );
    }
    else {
      return Stack(
        children: const [
          Positioned(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }
  }


  Widget buildCard(Size size, BuildContext context) {
    String imageUrl = 'https://repmedata.com/profileImage/' +
        imageName.toString();
    if (imageName == null || imageName.isEmpty) {
      imageUrl = 'https://repmedata.com/profileImage/user.png';
    }
    return SizedBox(
      width: size.width * 0.9,
      height: size.height * 1,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                avatar(imageUrl),
                SizedBox(
                  height: size.height * 0.02,
                ),
                userNameHint(),
                nameField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                ageHint(),
                ageField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                genderHint(),
                genderField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                nationalityHint(),
                nationalityField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                accentHint(),
                accentField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                speechPatternHint(),
                speechPatternField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                // emailHint(),
                // emailField(size),
                // SizedBox(
                //   height: size.height * 0.04,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getValueFromPrefs() async {
    await CheckInternetConnection.check(context);
    final prefs = await SharedPreferences.getInstance();
    email2 = prefs.getString('email');
  }

  avatar(imageUrl) {
    return  SizedBox(
              height: 150,
              width: 150,
              child: ClipOval(
                child: CachedNetworkImage(
                  placeholder: (context, imageUrl) =>
                      CircularProgressIndicator(),
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),

          );
  }

  userNameHint() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Username',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),
      ),
    );
  }

  final controller = TextEditingController();

  nameField(Size size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(248, 247, 251, 1),),
      width: size.width * 0.9,
      height: size.height / 15,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit,
              size: 20,),


              onPressed: () async {
                final _controller = TextEditingController(text: name);
                final newName = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Edit name"),
                      content: TextField(
                        controller: _controller,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () {
                            Navigator.of(context).pop(_controller.text);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (newName != null && newName.isNotEmpty) {
                  setState(() {
                    updateName(newName);
                    name = newName;
                  });
                }
              },
            ),

          ],
        ),
      ),
    );
  }

  ageHint() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Age',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),
      ),
    );
  }

  List<String> ageList = <String>[
    '<19',
    '19-29',
    '29-39',
    '39-49',
    '49-59',
    '59-69',
    '69-79',
    '79-89',
    '>89'
  ];

  ageField(Size size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(248, 247, 251, 1),),
      width: size.width * 0.9,
      height: size.height / 15,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(age,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit,
                size: 20,),
              onPressed: () async {
                String? selectedAge = age;
                if (selectedAge == null || !ageList.contains(selectedAge)) {
                  selectedAge = ageList[0];
                }
                List<String> namesListWithSelected = List.from(ageList);
                if (selectedAge != null &&
                    !namesListWithSelected.contains(selectedAge)) {
                  namesListWithSelected.add(selectedAge);
                }
                final newAge = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
                            return
                              AlertDialog(
                                title: Text("Edit age"),

                                content: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedAge,
                                  menuMaxHeight: 150,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedAge = newValue;
                                    });
                                  },
                                  items: namesListWithSelected.map((
                                      String age) {
                                    return DropdownMenuItem<String>(
                                      child: Text(age),
                                      value: age,
                                    );
                                  }).toList(),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      Navigator.of(context).pop(selectedAge);
                                    },
                                  ),
                                ],
                              );
                          }
                      );
                    }
                );
                if (newAge != null && newAge.isNotEmpty) {
                  setState(() {
                    updateAge(newAge);
                    age = newAge;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  genderHint() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Gender',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),
      ),
    );
  }

  List<String> genderList = <String>['Male', 'Female', 'Other'];

  genderField(Size size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(248, 247, 251, 1),),
      width: size.width * 0.9,
      height: size.height / 15,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(gender,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit,
                size: 20,),
              onPressed: () async {
                String? selectedgender = gender;
                if (selectedgender == null ||
                    !genderList.contains(selectedgender)) {
                  selectedgender = genderList[0];
                }
                List<String> namesListWithSelected = List.from(genderList);
                if (selectedgender != null &&
                    !namesListWithSelected.contains(selectedgender)) {
                  namesListWithSelected.add(selectedgender);
                }
                final newgender = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
                            return
                              AlertDialog(
                                title: Text("Edit gender"),

                                content: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedgender,
                                  menuMaxHeight: 150,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedgender = newValue;
                                    });
                                  },
                                  items: namesListWithSelected.map((
                                      String gender) {
                                    return DropdownMenuItem<String>(
                                      child: Text(gender),
                                      value: gender,
                                    );
                                  }).toList(),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      Navigator.of(context).pop(selectedgender);
                                    },
                                  ),
                                ],
                              );
                          }
                      );
                    }
                );
                if (newgender != null && newgender.isNotEmpty) {
                  setState(() {
                    updategender(newgender);
                    gender = newgender;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  nationalityHint() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Nationality',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),
      ),
    );
  }

  List<String> nationalityList = <String>[

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

  nationalityField(Size size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(248, 247, 251, 1),),
      width: size.width * 0.9,
      height: size.height / 15,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(nationality,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit,
                size: 20,),
              onPressed: () async {
                String? selectednationality = nationality;
                if (selectednationality == null ||
                    !nationalityList.contains(selectednationality)) {
                  selectednationality = nationalityList[0];
                }
                List<String> namesListWithSelected = List.from(nationalityList);
                if (selectednationality != null &&
                    !namesListWithSelected.contains(selectednationality)) {
                  namesListWithSelected.add(selectednationality);
                }
                final newnationality = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
                            return
                              AlertDialog(
                                title: Text("Edit nationality"),

                                content: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectednationality,
                                  menuMaxHeight: 150,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectednationality = newValue;
                                    });
                                  },
                                  items: namesListWithSelected.map((
                                      String nationality) {
                                    return DropdownMenuItem<String>(
                                      child: Text(nationality),
                                      value: nationality,
                                    );
                                  }).toList(),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          selectednationality);
                                    },
                                  ),
                                ],
                              );
                          }
                      );
                    }
                );
                if (newnationality != null && newnationality.isNotEmpty) {
                  setState(() {
                    updatenationality(newnationality);
                    nationality = newnationality;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  accentHint() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Accent',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),
      ),
    );
  }

  List<String> accentList = <String>[
    'I have a standard American English Accent',
    'I have a non-native  English Accent '
  ];

  accentField(Size size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(248, 247, 251, 1),),
      width: size.width * 0.9,
      height: size.height / 15,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(accent,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit,
                size: 20,),
              onPressed: () async {
                String? selectedaccent = accent;
                if (selectedaccent == null ||
                    !accentList.contains(selectedaccent)) {
                  selectedaccent = accentList[0];
                }
                List<String> namesListWithSelected = List.from(accentList);
                if (selectedaccent != null &&
                    !namesListWithSelected.contains(selectedaccent)) {
                  namesListWithSelected.add(selectedaccent);
                }
                final newaccent = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
                            return
                              AlertDialog(
                                title: Text("Edit accent"),

                                content: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedaccent,
                                  menuMaxHeight: 150,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedaccent = newValue;
                                    });
                                  },
                                  items: namesListWithSelected.map((
                                      String accent) {
                                    return DropdownMenuItem<String>(
                                      child: Text(accent),
                                      value: accent,
                                    );
                                  }).toList(),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      Navigator.of(context).pop(selectedaccent);
                                    },
                                  ),
                                ],
                              );
                          }
                      );
                    }
                );
                if (newaccent != null && newaccent.isNotEmpty) {
                  setState(() {
                    updateaccent(newaccent);
                    accent = newaccent;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  speechPatternHint() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text('Speech pattern',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12
        ),
      ),
    );
  }

  List<String> speechPatternList = <String>['Typical', 'Atypical'];

  speechPatternField(Size size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(248, 247, 251, 1),),
      width: size.width * 0.9,
      height: size.height / 15,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(speechPattern,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit,
                size: 20,),
              onPressed: () async {
                String? selectedspeechPattern = speechPattern;
                if (selectedspeechPattern == null ||
                    !speechPatternList.contains(selectedspeechPattern)) {
                  selectedspeechPattern = speechPatternList[0];
                }
                List<String> namesListWithSelected = List.from(
                    speechPatternList);
                if (selectedspeechPattern != null &&
                    !namesListWithSelected.contains(selectedspeechPattern)) {
                  namesListWithSelected.add(selectedspeechPattern);
                }
                final newspeechPattern = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
                            return
                              AlertDialog(
                                title: Text("Edit speech pattern"),

                                content: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedspeechPattern,
                                  menuMaxHeight: 150,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedspeechPattern = newValue;
                                    });
                                  },
                                  items: namesListWithSelected.map((
                                      String speechPattern) {
                                    return DropdownMenuItem<String>(
                                      child: Text(speechPattern),
                                      value: speechPattern,
                                    );
                                  }).toList(),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          selectedspeechPattern);
                                    },
                                  ),
                                ],
                              );
                          }
                      );
                    }
                );
                if (newspeechPattern != null && newspeechPattern.isNotEmpty) {
                  setState(() {
                    updatespeechPattern(newspeechPattern);
                    speechPattern = newspeechPattern;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateName(newName) async {
    final conn = await connection2.getConnection();
    await conn.query(
        'UPDATE userDetails SET name = ? WHERE email = ?', [newName, email2]);
  }

  void updateAge(newAge) async {
    final conn = await connection2.getConnection();
    await conn.query(
        'UPDATE userDetails SET age = ? WHERE email = ?', [newAge, email2]);
  }

  void updategender(newgender) async {
    final conn = await connection2.getConnection();
    await conn.query('UPDATE userDetails SET gender = ? WHERE email = ?',
        [newgender, email2]);
  }

  void updateaccent(newaccent) async {
    final conn = await connection2.getConnection();
    await conn.query('UPDATE userDetails SET accent = ? WHERE email = ?',
        [newaccent, email2]);

  }

  void updatespeechPattern(newspeechPattern) async {
    final conn = await connection2.getConnection();
    await conn.query('UPDATE userDetails SET speechPattern = ? WHERE email = ?',
        [newspeechPattern, email2]);
  }

  void updatenationality(newnationality) async {
    final conn = await connection2.getConnection();
    await conn.query('UPDATE userDetails SET nationality = ? WHERE email = ?',
        [newnationality, email2]);
  }
}