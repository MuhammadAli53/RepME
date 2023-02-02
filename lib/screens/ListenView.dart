import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rep_me/screens/build_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show Random;
import 'package:path/path.dart' as path;
import '../controllers/checkInternetConnection.dart';
import '../controllers/mySqlConnection.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'login.dart';

String? email1;
String? voiceName1;
int? loginID1;
int? sentID;
late String audioPath1;
final voicePlayer = AssetsAudioPlayer();
bool _playAudio = false;
bool isFavourite = false;
List<String> strings1 = [];
late Duration duration1;
List<String> sentenceListFromDatabase = [];
DateTime currentTime1 = DateTime.now();
final connection1=MySQLConnection();
late String sentence1;
String iosExtension='.m4a';
String androidExtension='.mp3';

class ListenView extends StatefulWidget {

  @override
  _MyListenViewState createState() => _MyListenViewState();
}

class _MyListenViewState extends State<ListenView> {

  final audioPlayer = AssetsAudioPlayer();
  bool _isReady = false;

  @override
  void initState() {
    _getValueFromPrefs();
    getLoginID();
    super.initState();
    getSentence().then((_) {
      build(context);
      setState(() {
        _isReady = true;
      }
      );
    }
    );
  }
  Future<int?> getLoginID() async {
    await CheckInternetConnection.check(context);
    final conn = await connection1.getConnection();

    final results = await conn.query(
        'SELECT ID FROM userDetails WHERE email = ?',
        [email1]);

    try{
      loginID1 = results.first[0];
      await conn.close();
      return loginID1;
    }
    catch(e)
    {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<Results> getSentence() async{
    await CheckInternetConnection.check(context);
    final conn = await connection1.getConnection();
    final sentencefromDB = await conn.query('SELECT sentence FROM sentencesList');
    var row;
    for ( row in sentencefromDB) {
      strings1.add(row[0]);
    }

    await conn.close();
    return sentencefromDB;
  }

  _getValueFromPrefs() async {
    await CheckInternetConnection.check(context);
    final prefs = await SharedPreferences.getInstance();
    email1 = prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) {

      Random random = Random();

      int randomNumber = random.nextInt(10);

      sentence1 = strings1[randomNumber];

      final size = MediaQuery.of(context).size;


      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        child: Scaffold(


          appBar: AppBar(

            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.help),
                onPressed: () async{
                  await Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => WebviewScaffold(
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
              onPressed: ()  =>
                  backPressed(),
            ),

            title: Text("Voice collection"),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
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
                                tapOnPlay(),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                textToListen(size,sentence1),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0,10,10,0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap:  () {
                                            setState(() {
                                              sentID = null;
                                              if(_playAudio) {
                                                _playAudio = !_playAudio;
                                                _iconData = _playAudio
                                                    ? Icons.pause
                                                    : Icons.play_arrow;
                                                voicePlayer.stop();
                                              }
                                              textToListen(size, sentence1);
                                            });

                                        },
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            width: size.width / 6,
                                            height: size.height / 22,
                                            decoration: BoxDecoration(
                                              color:  Color(0xff153194),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.06,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 0,
                                        child: InkWell(
                                            onTap: () {
                                              if(sentID==null)
                                              {
                                                Fluttertoast.showToast(
                                                    msg: 'Listen first',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white);

                                              }
                                              else {
                                                  addReaction('like');
                                                  setState(() {
                                                    if(_playAudio) {
                                                      _playAudio = !_playAudio;
                                                      _iconData = _playAudio
                                                          ? Icons.pause
                                                          : Icons.play_arrow;
                                                      voicePlayer.stop();
                                                    }
                                                    textToListen(size, sentence1);
                                                    isFavourite = !isFavourite;
                                                  });
                                                }
                                            },
                                            child:  Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFFD9D9D9),
                                              ),
                                              child: Row(
                                                children: const [
                                                  CircleAvatar(
                                                    backgroundColor: Color(0xFFD9D9D9),
                                                    child: Icon(
                                                      Icons.thumb_up_off_alt_outlined,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Text('Yes', style: TextStyle(color: Colors.black)),
                                                  SizedBox(width: 12),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                      const Expanded(
                                          flex: 1,
                                          child: Divider(
                                            color: Color(0xFF000000),
                                          )
                                      ),
                                      Expanded(
                                          flex: 0,
                                          child:playButton()
                                      ),
                                      const Expanded(
                                          flex: 1,
                                          child: Divider(
                                            color: Color(0xFF000000),
                                          )),
                                      Expanded(
                                        flex: 0,
                                        child: InkWell(
                                            onTap: () {
                                              if(sentID==null)
                                              {
                                                Fluttertoast.showToast(
                                                    msg: 'Listen first',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white);
                                              }
                                              else {
                                                // if (_playAudio) {
                                                //   Fluttertoast.showToast(
                                                //       msg: 'Click on Pause button',
                                                //       toastLength: Toast.LENGTH_SHORT,
                                                //       gravity: ToastGravity.BOTTOM,
                                                //       timeInSecForIosWeb: 1,
                                                //       backgroundColor: Colors.yellowAccent,
                                                //       textColor: Colors.black);
                                                // }
                                                // else {
                                                  addReaction('disLike');
                                                  setState(() {
                                                    if(_playAudio) {
                                                      _playAudio = !_playAudio;
                                                      _iconData = _playAudio
                                                          ? Icons.pause
                                                          : Icons.play_arrow;
                                                      voicePlayer.stop();
                                                    }
                                                    isFavourite;
                                                    textToListen(size, sentence1);
                                                  });
                                                }

                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xFFD9D9D9),
                                              ),
                                              child: Row(
                                                children: const [
                                                  CircleAvatar(
                                                    backgroundColor: Color(0xFFD9D9D9),
                                                    child: Icon(
                                                      Icons.thumb_down_off_alt_sharp,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  // add some space between the icon and text
                                                  Text('No', style: TextStyle(color: Colors.black)),
                                                  SizedBox(width: 12),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
        ),

      );
    }
    else {
      return  Stack(
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
  backPressed() async{
    sentID==null;
    await CheckInternetConnection.check(context);
    if(_playAudio==true)
    {
      setState(() {
        _playAudio = !_playAudio;
        _iconData = _playAudio ? Icons.pause : Icons.play_arrow;
      });
      await voicePlayer.stop();
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  home()));
  }

  void addReaction(String reaction) async {
    Fluttertoast.showToast(
        msg: 'Submitted reaction',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white
    );

    try{
      var response = await http.post(
          Uri.parse(
              "https://repmedata.com/uploadData/insertReaction.php"),
          body: {
            "reaction": reaction,
            "loginID": loginID1.toString(),
            "sentenceID": sentID.toString(),
          }
      );
      sentID = null;
    }
    catch(e) {

      Fluttertoast.showToast(
          msg: 'Error to submit reaction',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white
      );
    }
  }
}
class playButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}
IconData _iconData = Icons.play_arrow;
class _MyButtonState extends State<playButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFFebba16),
          child: IconButton(
            onPressed:()=>
            {
              if(!_playAudio)
                {
                  getSentenceID(sentence1, context),
                }
              else
                {
                  setState(() {
                    _playAudio = !_playAudio;
                    _iconData = _playAudio ? Icons.pause : Icons.play_arrow;
                  }),
                  voicePlayer.stop(),
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
  Future<int?> getSentenceID(String sentence, BuildContext context) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text('Downloading voice...'),
            ],
          ),
        );
      },
    );

    await CheckInternetConnection.check(context);

    final conn = await connection1.getConnection();

    final results = await conn.query(
        'SELECT ID FROM sentencesList WHERE sentence = ?', [sentence]);

    sentID = results.first[0];

    if (Platform.isIOS) {
      final voiceName = await conn.query(
          'SELECT fileName,sentenceID,extension FROM audioFile WHERE sentenceID = ? AND extension = ?',
          [sentID, '.m4a']);

      var row;

      Random random1 = Random();

      if (voiceName.length == 0) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: "This voice is not available");
        sentID = null;
      }
      else {
        int randomNumber1 = random1.nextInt(voiceName.length);

        try {
          for (row in voiceName) {
            strings1.add(row[randomNumber1]);
          }
        }
        catch (e) {
          print(e);
        }
        String? directory;
        String fileName = row['fileName'];

        String extension = row['extension'];

        print(extension.toString() + 'extension');
        final directory1 = await getApplicationDocumentsDirectory();
        directory = directory1.path;
        audioPath1 = ('$directory/$fileName$iosExtension');
        print(directory + 'jjjjjjjj');

        print(voiceName);

        print(audioPath1);

        downloadFile(audioPath1, fileName, context, sentID!);
      }
    }
    else if (Platform.isAndroid) {
      final voiceName = await conn.query(
          'SELECT fileName,sentenceID,extension FROM audioFile WHERE sentenceID = ? AND extension = ?',
          [sentID, '.mp3']);
      var row;

      Random random1 = Random();

      if (voiceName.length == 0) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: "This voice is not available");
        sentID = null;
      }
      else {
        int randomNumber1 = random1.nextInt(voiceName.length);

        try {
          for (row in voiceName) {
            strings1.add(row[randomNumber1]);
          }
        }
        catch (e) {
          print(e);
        }
        String? directory;
        String fileName = row['fileName'];

        String extension = row['extension'];

        print(extension.toString() + 'extension');

        directory = '/sdcard/Download/VoiceCollection/';
        audioPath1 = ('$directory$fileName$androidExtension');
        print(directory + 'jjjjjjjj');

        print(voiceName);

        print(audioPath1);

        downloadFile(audioPath1, fileName, context, sentID!);
      }
      await conn.close();
    }
  }

  Future<void> playFunc(String audioPath, BuildContext context) async {

    await CheckInternetConnection.check(context);

    if (loginID1.toString() == 'null') {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          msg: "Please Login first to validate");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => login()));
      await voicePlayer.stop();
      sentID = null;
      loginID1 = null;
    }
    else {
      setState(() {
        _playAudio = !_playAudio;
        _iconData = _playAudio ? Icons.pause : Icons.play_arrow;
      });
      const snackBar = SnackBar(
        content: Padding(padding: EdgeInsets.all(8), child:
        Text('Did they accurately speak sentence?',
            textAlign: TextAlign.center),),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      voicePlayer.open(
        Audio.file(audioPath),
        autoStart: true,
        showNotification: true,
        volume: 100);
      duration1 = voicePlayer.currentPosition.value;
      print(duration1);
      voicePlayer.currentPosition.listen((duration) {
        print('Duration: $duration');
      });
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

  void downloadFile(String pathToAudio, String fileName, BuildContext context,
      int sentID1) async {
    await CheckInternetConnection.check(context);
    print(sentID1);
    print(loginID1);
    print(email1);
    requestStorage();

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      if (email1.toString() == 'null') {
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            msg: "Please Login first to validate");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => login()));
        await voicePlayer.stop();
        sentID = null;
        loginID1 = null;
      }
      else if (loginID1.toString() == 'null') {
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            msg: "Please add your details");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Profile()));
        await voicePlayer.stop();
        sentID = null;
        loginID1 = null;
      }
      else {
        Directory dir = Directory(path.dirname(pathToAudio));

        print(dir.path + 'dir');
        print(fileName + 'fileName');

        if (dir != null) {
          String? savePath;
          if (Platform.isIOS) {
            savePath = "${dir.path}/$fileName$iosExtension";
            fileName = fileName + iosExtension;
          }
          else if (Platform.isAndroid) {
            savePath = "${dir.path}/$fileName$androidExtension";
            fileName = fileName + androidExtension;
          }

          print(savePath! + 'egfewuic');

          if (await File(savePath).exists()) {
            print('The file has already been downloaded');
            playFunc(savePath, context);
          }
          else {
            try {
              await Dio().download(
                  "https://repmedata.com/library/$fileName",
                  savePath,
                  onReceiveProgress: (received, total) {}
              );
              playFunc(pathToAudio, context);
              print("File is saved to download folder.");
            } on DioError catch (e) {
              Fluttertoast.showToast(
                  msg: 'This voice is not available',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white);
              print(e.message.toString() + 'gtdgh');
            }
          }
        }
        else {
          Navigator.pop(context);
          print("No permission to read and write.");
        }
        Navigator.pop(context);
      }
    }
  }
}

  tapOnPlay() {
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
                  child: Icon(Icons.play_circle),
                ),
                TextSpan(
                  text: 'did they accurately speak sentence? Press like/dislike button below.',
                )
              ],
            ),
          )
      ),
    );
  }

  Widget textToListen(Size size, String sentence) {
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


// try{
//
//
//   var request = http.MultipartRequest('GET', Uri.parse(uploadAudioUrl));
//
//   request.files.add(await http.MultipartFile.fromPath('audio', fileToUpload.path));
//
//   var response= await request.send();
//
//   if (response.statusCode == 200) {
//
//     Navigator.pop(context);
//     Fluttertoast.showToast(
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         msg: "Submitted successfully");
//
//     Navigator.pop(context);
//     playFunc(pathToAudio);
//     fileName='';
//     pathToAudio='';
//
//
//
//     print('Audio file successfully uploaded to the server!');
//   } else {
//     Navigator.pop(context);
//     Fluttertoast.showToast(
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         msg: "An error occurred while uploading the audio file to the server");
//   }
// }
// catch(e){
//   if (kDebugMode) {
//     Navigator.pop(context);
//     Fluttertoast.showToast(
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         msg: e.toString());
//     //  print(e.toString());
//   }
// }

// FTPConnect ftpConnect = FTPConnect(
//     'ftp.repmedata.com', user: 'library@repmedata.com',
//     pass: 'Ali@RepMe',
//     port: 21);
//
// await ftpConnect.connect();
//
// File fileToDownload = File(pathToAudio);
//
// await ftpConnect.downloadFile(fileName,fileToDownload);
//
// Navigator.pop(context);
//
// playFunc(pathToAudio);
//
// pathToAudio='';
//
// await ftpConnect.disconnect();



