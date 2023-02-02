import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rep_me/screens/build_profile.dart';
import 'package:rep_me/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/editTextBackground.dart';
import '../Widgets/google_sign_in_button.dart';
import '../controllers/checkInternetConnection.dart';
import '../controllers/authentication.dart';
import 'forgot_password.dart';
import 'home.dart';

final _googleSignIn = GoogleSignIn();
GoogleSignInAccount? googleSignInAccount;
class login extends StatefulWidget  {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _passwordVisible = false;
  bool _checkBox = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice collection"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor:  Colors.white,
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
      height: size.height * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.06,
                ),
                signInTitle(30),
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
                  height: size.height * 0.04,
                ),
                // buildRemember(size),
                // SizedBox(
                //   height: size.height * 0.02,
                // ),
                signInButton(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                PasswordForget(),
                SizedBox(
                  height: size.height * 0.02,
                ),
                buildNoAccountText(),
                SizedBox(
                  height: size.height * 0.02,
                ),
                google_Button(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                buildFooter(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                exploreAsGuest(size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTitle(double fontSize) {
    return  Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              fontSize: fontSize,
              color: const Color(0xFF000000),
              letterSpacing: 2,
            ),
            children: const [
              TextSpan(
                text: 'LOGIN',
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
          textInputAction: TextInputAction.next,
          decoration: editTextDecoration.copyWith(
              hintText: 'Enter your email'
      )
      ),
    );
  }

  passwordTextHint(Size size) {
    return Column(
      children: const <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
              "Password"
          ),
        ),
      ],
    );
  }

  Widget passwordTextField(Size size) {
    return Container(
      height: 50,

      decoration:  BoxDecoration(
        borderRadius:  BorderRadius.circular(15),
        color: const Color.fromRGBO(248, 247, 251, 1),
      ),


      child:  TextFormField(

        controller: password,
          cursorColor: Colors.black,
          keyboardType: TextInputType.text,
          obscureText: !_passwordVisible,
          textAlign: TextAlign.start,
        textInputAction: TextInputAction.done,

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

  Widget buildRemember(Size size) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 20.0,
            height: 20.0,
           child: Checkbox(

              activeColor: Colors.green,
              checkColor: Colors.white,
              value: _checkBox,
              onChanged: (value) {
                setState(() {
                  _checkBox = value!;
                });
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'Remember me',
            style: GoogleFonts.inter(
              fontSize: 15.0,
              color: const Color(0xFF000000),
            ),
          ),
        ],
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

          'Login',
          style: GoogleFonts.inter(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: ()async {

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
        else if(password.text.length<6)
          {
            Fluttertoast.showToast(
                msg: 'Password should be 6 or more characters',
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
          prefs.remove('email');


          FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.toString(), password: password.text.toString())
              .then((uid) => {

            Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                msg: "Logged in Successfully"),

            prefs.setString('email',email.text),

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                  return  home();
                })),
          })
              .catchError((e) {
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


  //Password

  Widget PasswordForget() {

    return Column(

      children:<Widget>[

        Align(

          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  forgot_password()));
            },
            child: const Text("Forgot Password?",
                style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold),
          ),
            ),
          ),
      ],
    );
  }

  Widget buildNoAccountText() {
    return Row(
      children: <Widget>[
        const Expanded(
            flex: 1,
            child: Divider(
              color: Color(0xFF000000),
            )),
        Expanded(
          flex: 0,
          child: Text(
            'OR continue with',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
        const Expanded(
            flex: 1,
            child: Divider(
              color: Color(0xFF000000),
            )),
      ],
    );
  }

  Widget google_Button(Size size) {

    return FutureBuilder(

              future: Authentication.initializeFirebase(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error initializing Firebase');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return GoogleSignInButton();
                }
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ),
                );
              },
    );
  }

  Widget buildFooter(Size size) {

    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.02),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children:  [
            const TextSpan(
              text: 'Need an account? ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(

              text: 'Signup',
              style: const TextStyle(
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,

              ),
              recognizer: TapGestureRecognizer()..onTap = () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const signup()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget exploreAsGuest(Size size) {

    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>  home()));
      },
      child: Container(

      alignment: Alignment.center,
      height: size.height / 15,

       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
        color: const Color(0xddd9d9d9),
      ),
        child: Text(
          'Explore as Guest',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}