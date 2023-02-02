import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/mySqlConnection.dart';
import '../model/user_details.dart';
import '../screens/login.dart';
import '../screens/savedProfile.dart';
import '../screens/Contact_us.dart';
import '../controllers/authentication.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';


GoogleSignInAccount? googleSignInAccount;
UserDetails? userDetails;
String? emailNavBar;
String? userNameNavBar;
String? imageName;
String? imageUrl;
final connection=MySQLConnection();



_getValueFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  emailNavBar = prefs.getString('email');
}


class NavBar extends StatefulWidget {

  @override
  _NavBarState createState() => _NavBarState();
}
bool isUserLoggedIn=false;
class _NavBarState extends State<NavBar> {

  Future<void> checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isUserLoggedIn = true;
      });
    } else {
      setState(() {
        isUserLoggedIn = false;
      });
    }
  }
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getValueFromPrefs();
    checkLoginStatus();
    getImageName().then((_) {
      build(context);
      setState(() {
        _isReady = true;
      });});
  }
  _getUserData() async {
    final conn = await connection.getConnection();
    final results = await conn.query('SELECT name FROM userDetails WHERE email = ?', [emailNavBar]);
    for (var row in results) {
      setState(() {
        userNameNavBar = row['name'];
      });
    }
  }
  getImageName() async {
    final conn = await connection.getConnection();
    final results = await conn.query('SELECT image FROM userDetails WHERE email = ?', [emailNavBar]);
    var row;
    for ( row in results) {
      setState(() {
        imageName = row['image'];
      });
    }
    conn.close();
    return imageName;
  }


  @override
  Widget build(BuildContext context) {
    if (_isReady) {

      imageUrl = 'https://repmedata.com/profileImage/$imageName';
      if (imageName == null) {
        imageUrl = 'https://repmedata.com/profileImage/user.png';
      }
      if (kDebugMode) {
        print('${imageName}sbduyfgcbnm');
      }
      if (kDebugMode) {
        print('${emailNavBar}sbduyfgcbnm');
      }


      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName:  Text(userNameNavBar?? 'User Name'),
              accountEmail: Text(emailNavBar ?? 'User Email'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: CachedNetworkImage(
                    placeholder: (context, imageUrl) => CircularProgressIndicator(),
                    imageUrl: imageUrl!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  )
                ),
              ),

              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Partnerships'),
              leading: const Icon(Icons.support),
              onTap: () => Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => WebviewScaffold(
                    url: "https://repmedata.com/partnership.html",
                    appBar: AppBar(
                      title: Text("Partnerships"),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('RepME Legal Terms'),
              onTap: () =>  Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => WebviewScaffold(
                    url: "https://repmedata.com/repmeleageterms.html",
                    appBar: AppBar(
                      title: Text("RepMe Legal Terms"),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Notice'),
              onTap: () =>    Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => WebviewScaffold(
                    url: "https://repmedata.com/privacynotice.html",
                    appBar: AppBar(
                      title: Text("Privacy Notice"),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Mission'),
              onTap: () => Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => WebviewScaffold(
                    url: "https://repmedata.com/mission.html",
                    appBar: AppBar(
                      title: Text("Mission"),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () =>
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return savedProfile();
                      })),
            ),
            ListTile(

              title: const Text('Contact Details'),
              leading: const Icon(Icons.perm_contact_cal),
              onTap: () =>Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>  contactUs())),
            ),

            ListTile(

              title: Text(isUserLoggedIn ? 'Logout' : 'Exit'),
              leading: Icon(isUserLoggedIn ? Icons.logout : Icons.exit_to_app),
              onTap: () {
                _goToLoginScreen(context);
              },
            ),
          ],
        ),

      );
    }
    else
    {
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
}
void _goToLoginScreen(BuildContext context) async{
  imageName = null;
  userNameNavBar='User Name';
  emailNavBar=='null';
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
  await Authentication.signOut(context: context);
  await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const login()));
}






