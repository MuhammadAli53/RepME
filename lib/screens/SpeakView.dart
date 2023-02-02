import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:math' show Random;
import '../controllers/checkInternetConnection.dart';
import '../controllers/mySqlConnection.dart';
import 'package:path_provider/path_provider.dart';
import 'build_profile.dart';
import 'home.dart';
import 'login.dart';

String? email;
final _recordingSession=Record();
late String pathToAudio;
bool _isSpeaking=false;
List<String> strings = [];
int? loginID;
int? sentenceID;
DateTime? currentTime;
final connection=MySQLConnection();
String? mobileDir;
String iosExtension='.m4a';
String androidExtension='.mp3';
String? audioName;
String? nameFile;


class SpeakView extends StatefulWidget {
  const SpeakView({super.key});

  @override
  _MySpeakViewState createState() => _MySpeakViewState();
}
class _MySpeakViewState extends State<SpeakView> {

  bool _isReady = false;

  @override
  void initState() {
    _getValueFromPrefsSpeak();
    getLoginIDSpeak();
    super.initState();
    getSentenceSpeak().then((_) {
      setState(() {
        build(context);
        _isReady = true;
      });
    });
  }

  Future<int?> getLoginIDSpeak() async {
    await CheckInternetConnection.check(context);
    final conn = await connection.getConnection();
    final results = await conn.query(
        'SELECT ID FROM userDetails WHERE email = ?',
        [email]);

    try {
      loginID = results.first[0];
      await conn.close();
      return loginID;
    }
    catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return loginID;
  }

  Future<Results> getSentenceSpeak() async {
    await CheckInternetConnection.check(context);
    final conn = await connection.getConnection();
    final sentencefromDB = await conn.query(
        'SELECT sentence FROM sentencesList');

    for (var row in sentencefromDB) {
      strings.add(row[0]);
    }
    await conn.close();
    return sentencefromDB;
  }

  _getValueFromPrefsSpeak() async {
    await CheckInternetConnection.check(context);
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      Random random = Random();

      int randomNumber = random.nextInt(10);

      String sentence = strings[randomNumber];

      getSentenceIDSpeak(sentence);

      final size = MediaQuery
          .of(context)
          .size;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        child: Scaffold(
          appBar: AppBar(

            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.help),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebviewScaffold(
                            url: "https://repmedata.com/help.html",
                            appBar: AppBar(
                              title: Text("Help"),
                            ),
                          ),
                    ),
                  );
                },
              ),
            ],

            leading: IconButton(

              icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
              onPressed: () =>
                  backPressed(),

            ),

            title: Text("Voice collection"),
            centerTitle: true,
          ),
          body: SafeArea(child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: size.width * 1,
                  height: size.height * 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            tapOnMic(),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            textToSpeak(size, sentence),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  InkWell(
                                    onTap: ()  {

                                        setState(() {
                                          if(_isSpeaking) {
                                            mobileDir = '';
                                            pathToAudio = '';
                                            audioName = '';
                                            _recordingSession.stop();
                                            _isSpeaking = !_isSpeaking;
                                            _iconData =
                                            _isSpeaking ? Icons.pause : Icons
                                                .mic;
                                          }
                                        });
                                        textToSpeak(size, sentence);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: size.width / 6,
                                      height: size.height / 22,
                                      decoration: BoxDecoration(
                                        color: Color(0xff153194),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text(
                                            'Next',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: ()  {

                                      if(_isSpeaking) {
                                        setState(() {
                                          mobileDir = '';
                                          pathToAudio = '';
                                          audioName = '';
                                          _recordingSession.stop();
                                          _isSpeaking = !_isSpeaking;
                                          _iconData = _isSpeaking ? Icons.pause : Icons.mic;
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: size.width / 6,
                                      height: size.height / 22,
                                      decoration: BoxDecoration(
                                        color: const Color(0xddd9d9d9),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text(
                                            'Cancel',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Row(
                                              children: const [
                                                CircularProgressIndicator(),
                                                SizedBox(width: 10),
                                                Text(
                                                    'Submitting your voice...'),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                      submitRecord();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: size.width / 6,
                                      height: size.height / 22,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child:
                                          Text('Submit',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.06,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                recordBtton(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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


  Future<int?> getSentenceIDSpeak(String sentence) async {
    await CheckInternetConnection.check(context);
    final conn = await connection.getConnection();

    final results = await conn.query(
        'SELECT ID FROM sentencesList WHERE sentence = ?',
        [sentence]);
    sentenceID = results.first[0];

    await conn.close();
    return sentenceID;
  }

  tapOnMic() {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: 'Tap',
                ),
                WidgetSpan(
                  child: Icon(Icons.mic_outlined),
                ),
                TextSpan(
                  text: 'and read the sentence aloud than press submit button to upload voice.',
                )
              ],
            ),
          )
      ),
    );
  }

  textToSpeak(Size size, String sentence) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Container(
          alignment: Alignment.center,
          height: size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0xFFD9D9D9),
          ),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text(
            sentence,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 26.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitRecord() async {
    Directory directory;
    if (Platform.isAndroid) {
      directory = Directory(path.dirname(pathToAudio));
      if (!directory.existsSync()) {
        directory.createSync();
      }
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      if (!directory.existsSync()) {
        directory.createSync();
      }
    }

    await CheckInternetConnection.check(context);
    //  await _recordingSession.stop();

    if (email.toString() == 'null') {
      mobileDir = '';
      pathToAudio = '';
      audioName = '';
      _isSpeaking == false;
      sentenceID == null;

      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          msg: "Please Login first to record");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => login())
      );
    }
    else if (loginID.toString() == 'null') {
      mobileDir = '';
      pathToAudio = '';
      audioName = '';
      _isSpeaking == false;
      sentenceID == null;
      print(email.toString() + 'jsdkgfc');

      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          msg: "Please add your details");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Profile())
      );
    }
    else if (_isSpeaking) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          msg: "Click on Pause button");
    }
    else {
      print('${sentenceID}sentenceID');
      print('${loginID}loginId');
      print('${email}email');
      if (mobileDir == '' || loginID == null || sentenceID == null ||
          audioName == '') {
        Navigator.pop(context);
        print('something empty');
      }
      else {
        try {
          if (Platform.isAndroid) {
            var response = await http.post(
                Uri.parse(
                    "https://repmedata.com/uploadData/insertAudioDetails.php"),
                body: {
                  "audioFilepath": mobileDir,
                  "loginID": '$loginID',
                  "sentenceID": '$sentenceID',
                  "fileName": nameFile,
                  "createdAt": currentTime.toString(),
                  "extension": androidExtension,
                }
            );
          }
          else if (Platform.isIOS) {
            var response = await http.post(
                Uri.parse(
                    "https://repmedata.com/uploadData/insertAudioDetails.php"),
                body: {
                  "audioFilepath": mobileDir,
                  "loginID": '$loginID',
                  "sentenceID": '$sentenceID',
                  "fileName": nameFile,
                  "createdAt": currentTime.toString(),
                  "extension": iosExtension,
                }
            );
          }
        }
        catch (e) {
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              msg: "Nothing to submit");
          Navigator.pop(context);
        }
      }
      sendToServer(context);
    }
  }
  backPressed() async {
    await CheckInternetConnection.check(context);
    if (_isSpeaking == true) {
      await _recordingSession.stop();
    }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => home()));
  }
}
class recordBtton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}
IconData _iconData = Icons.mic;
class _MyButtonState extends State<recordBtton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black,
          child: IconButton(
            onPressed: () =>
            {
              if (!_isSpeaking) {

                startRecording(context),
              } else
                {
                  setState(() {
                    _isSpeaking = !_isSpeaking;
                    _iconData = _isSpeaking ? Icons.pause : Icons.mic;
                  }),
                  _recordingSession.stop(),
                }
            },
            icon: Icon(
              _iconData,
              color: Colors.white,
              size: 30,
            ),
          ),
        )
    );
  }


  void requestMicrophone() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      print("Permission is granted for Microphone");
    }
    else if (status.isDenied) {
      if (await Permission.microphone
          .request()
          .isGranted) {
        print("Permission was granted for Microphone");
      }
      else if (await Permission.microphone
          .request()
          .isPermanentlyDenied) {
        openAppSettings();
        print("Permission was Permanently Denied for Microphone");
      }
    }
  }

  void requestStorage() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      print("Permission is granted for Storage");
    }
    else if (status.isDenied) {
      if (await Permission.storage
          .request()
          .isGranted) {
        print("Permission was granted for Storage");
      }
      else if (await Permission.storage
          .request()
          .isPermanentlyDenied) {
        openAppSettings();
        print("Permission was Permanently Denied for Storage");
      }
    }
  }

  Future<void> startRecording(BuildContext context) async {
    currentTime = DateTime.now();

    mobileDir = '/sdcard/Download/VoiceCollection/';
    nameFile = 'recording${currentTime?.hour}${currentTime
        ?.minute}${currentTime?.second}';
    audioName = '$nameFile$androidExtension';

    print(audioName.toString() + 'audioName');

    if (Platform.isIOS) {
      final directory1 = await getApplicationDocumentsDirectory();
      pathToAudio =
      "${directory1.path}/recording${currentTime?.hour}${currentTime
          ?.minute}${currentTime?.second}$iosExtension";
    }
    else if (Platform.isAndroid) {
      pathToAudio = "$mobileDir/$audioName";
    }

    print(pathToAudio + 'jregfhjgwhjs');

    if (await _recordingSession.hasPermission()) {
      setState(() {
        _isSpeaking = !_isSpeaking;
        _iconData = _isSpeaking ? Icons.pause : Icons.mic;
      });
      final snackBar = SnackBar(
        content: Padding(padding: EdgeInsets.all(8), child:
        Text('Recording start, Read the sentence aloud!',
            textAlign: TextAlign.center),),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      await _recordingSession.start(
        path: pathToAudio,
        encoder: AudioEncoder.aacLc,
      );
    }

    StreamSubscription recorderSubscription = _recordingSession.onStateChanged()
        .listen((e) {});

    recorderSubscription.cancel();
  }
}

Future<void> sendToServer(BuildContext context) async {


    await CheckInternetConnection.check(context);
    File fileToUpload = File(pathToAudio);

    String uploadAudioUrl = 'https://repmedata.com/uploadAudio.php';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadAudioUrl));

      request.files.add(
          await http.MultipartFile.fromPath('audio', fileToUpload.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            msg: "Submitted successfully");

        mobileDir = '';
        pathToAudio = '';
        audioName = '';
        _isSpeaking == false;
        sentenceID == null;

        print('Audio file successfully uploaded to the server!');
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: "An error occurred while uploading the audio file to the server");
      }
    }
    catch (e) {
      if (kDebugMode) {
       // Navigator.pop(context);
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: 'There is no voice to submit');
      }

  }
}
