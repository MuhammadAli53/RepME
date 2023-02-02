import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/editTextBackground.dart';
import 'login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class forgot_password extends StatefulWidget {
   forgot_password({Key? key}) : super(key: key);

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const login())),
        ),
        title: Text("Voice collection"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildCard(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.8,
      height: size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                forgotTitle(30),
                SizedBox(
                  height: size.height * 0.06,
                ),

                emailTextHint(size),
                emailTextField(size),
                SizedBox(
                  height: size.height * 0.06,
                ),
                sendCode(size),

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

  Widget forgotTitle(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF000000),
          letterSpacing: 2,
        ),
        children: const [
          TextSpan(
            text: 'Forgot password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  emailTextHint(Size size) {
    return Column(
      children: const <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
              "Email"
          ),
        ),
      ],
    );
  }

  Widget emailTextField(Size size) {
    return Container(
      height: 50,

      decoration:  BoxDecoration(
        borderRadius:  BorderRadius.circular(15),
        color: const Color.fromRGBO(248, 247, 251, 1),
      ),


      child:  TextField(


        controller: email,
          cursorColor: Colors.black,
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.start,
          decoration: editTextDecoration.copyWith(
              hintText: 'Enter your email'
          )
      ),
    );
  }



  Widget sendCode(Size size)  {
    return InkWell(

      child: Container(
        alignment: Alignment.center,
        height: size.height / 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color(0xFF000000),
        ),
        child: Text(
          'Send code',
          style: GoogleFonts.inter(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        if (email.text == '') {
          Fluttertoast.showToast(
              msg: 'Email should not be empty',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white
          );
        }
        else {

          try {
            _auth.sendPasswordResetEmail(email: email.text);
            Fluttertoast.showToast(
                msg: 'An email sent to your entered email',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white
            );
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                  return login();
                }));
          }
          catch(e)
          {
            Fluttertoast.showToast(
                msg: e.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white
            );
          }

        }
      },
    );
  }
}


