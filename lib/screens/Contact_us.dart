import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class contactUs extends StatefulWidget {
  const contactUs({Key? key}) : super(key: key);

  @override
  State<contactUs> createState() => _contactUsState();
}

class _contactUsState extends State<contactUs> {



  @override
  Widget build(BuildContext context) {


    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: ()  =>(
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>  home()))),),
        title: Text("Contact Details"),
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
    return SizedBox(
      width: size.width * 0.8,
      height: size.height * 0.8,
      child: Column(
        children: [
          Expanded(

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                logo(),
                SizedBox(
                  height: size.height * 0.02,
                ),

                contactUs(size),
                SizedBox(
                  height: size.height * 0.1,
                ),

                email(size),
                SizedBox(
                  height: size.height * 0.04,
                ),

                mobile(size,context),
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

  logo() {
    return Padding(
        padding: EdgeInsets.all(1),
        child: Container(
          height: 250,
          child: InkWell(
            // onTap: () {
            //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  login()));
            // },
            child: Image.asset("assets/logo.png"),
          ),
        )
    );
  }




Widget contactUs(Size size) {
  return Text(
    'Contact Us',
    style: GoogleFonts.inter(
      fontSize: 28.0,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget email(Size size) {
  return  Text('Email: info@repmedata.com',
    style: GoogleFonts.inter(
      fontSize: 20.0,
      color: Colors.black,
      fontWeight: FontWeight.w500,

    ),
  );  }
}

mobile(Size size,BuildContext context)  {

  return  Text('Phone: +1 416-882-5705',
    style: GoogleFonts.inter(
      fontSize: 20.0,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),

  );
}