import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/editTextBackground.dart';
import '../controllers/checkInternetConnection.dart';
import 'build_profile.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                    return const login();
                  })),
        ),
        title: const Text("Voice collection"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildCard(size),
              ],
            ),
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
                SignupTitle(30),
                SizedBox(
                  height: size.height * 0.06,
                ),
                emailTextHint(size),
                emailTextField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                passwordTextHint(size),
                passwordTextField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                confirmPaswordTextHint(size),
                confirmPasswordField(size),
                SizedBox(
                  height: size.height * 0.04,
                ),
                signInButton(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                buildFooter(size),
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

  Widget SignupTitle(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF000000),
          letterSpacing: 2,
        ),
        children: const [
          TextSpan(
            text: 'SIGN UP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  emailTextHint(Size size) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
          "Email"
      ),
    );
  }


  Widget emailTextField(Size size) {
    return Container(
      height: 50,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromRGBO(248, 247, 251, 1),
      ),

      child: TextField(

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


  passwordTextHint(Size size) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
          "Password"
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return Container(
      height: 50,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromRGBO(248, 247, 251, 1),
      ),


      child: TextField(

        controller: password,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        obscureText: !_passwordVisible,
        textAlign: TextAlign.start,


        decoration: editTextDecoration.copyWith(
          hintText: 'Enter your password',
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,

              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              },
              );
            },
          ),
        ),
      ),
    );
  }

  confirmPaswordTextHint(Size size) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
          "Re-enter password"
      ),
    );
  }

  Widget confirmPasswordField(Size size) {
    return Container(
      height: 50,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromRGBO(248, 247, 251, 1),
      ),

      child: TextField(

        controller: confirmPassword,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        obscureText: !_confirmPasswordVisible,
        textAlign: TextAlign.start,

        decoration: editTextDecoration.copyWith(
          hintText: 'Re-enter password',

          suffixIcon: IconButton(
            icon: Icon(
              _confirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,

              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget signInButton(Size size) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: size.height / 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color(0xFF000000),
        ),
        child: Text(

          'Signup',
          style: GoogleFonts.inter(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () async {
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
        else if (password.text.length < 6) {
          Fluttertoast.showToast(
              msg: 'Password should be 6 or more characters',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white
          );
        }
        else if (confirmPassword.text != password.text) {
          Fluttertoast.showToast(
              msg: 'Passwords are not matching',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white
          );
        }
        else {
          await CheckInternetConnection.check(context);
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("email", email.text);

          FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email.text.toString(), password: password.text.toString())
              .then((uid) =>
          {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>  Profile())),

            Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                msg: "Signed up Successfully"),

          }
            ,).
          catchError((e) {
            Fluttertoast.showToast(
              timeInSecForIosWeb: 3,
              gravity: ToastGravity.BOTTOM,
              msg: e.toString(),
            );
          });
        }
      },
    );
  }

  Widget buildFooter(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.03),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: [
            const TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(

              text: 'Login',
              style: const TextStyle(
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,

              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const login()));
                },
            ),
          ],
        ),
      ),
    );
  }
}