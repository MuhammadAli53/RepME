import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Widgets/nav_bar.dart';
import 'ListenView.dart';
import 'SpeakView.dart';


class home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar (
        title: const Text("Voice collection"),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 1,
                  child: Column(
                    children: [
                      Expanded(

                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            avatarField(),
                            solveTheDataProblem(size),
                            SizedBox(
                              height: size.height * 0.1,
                            ),

                            donateYourVoice(size,context),
                            SizedBox(
                              height: size.height * 0.04,
                            ),

                            helpUsValidate(size,context),
                            SizedBox(
                              height: size.height * 0.02,
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
    );
  }


  avatarField() {
    return Padding(
        padding: EdgeInsets.all(1),
        child: SizedBox(
          child: InkWell(
            child: Image.asset("assets/logo.png"),
          ),
        )
    );
  }



  Widget solveTheDataProblem(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color.fromRGBO(248, 247, 251, 1)
      ),
      child: Text(
        'Solve the data problem',
        style: GoogleFonts.inter(
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget donateYourVoice(Size size,BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  SpeakView()));
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color(0xFF153194),
        ),
        child: Text(
          'Donate your voice',
          style: GoogleFonts.inter(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );  }
}

helpUsValidate(Size size,BuildContext context)  {

  return InkWell(
    onTap: () =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  ListenView())),
    child: Container(
      alignment: Alignment.center,
      height: size.height / 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color:  Color(0xFF153194),
      ),
      child:  Text('Help us validate',
        style: GoogleFonts.inter(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
