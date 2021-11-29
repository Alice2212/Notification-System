import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/models/emergency.dart';
import 'package:new_app/screens/tab/description.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencePage extends StatefulWidget {
  const EmergencePage({Key key}) : super(key: key);

  @override
  _EmergencePageState createState() => _EmergencePageState();
}

class _EmergencePageState extends State<EmergencePage> {
  final number = '08138808281';

  Emergence emerg = Emergence();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);
    var lati = position.latitude;
    var longi = position.longitude;
    // setState(() {
    //    locationMessage = "$lati, $longi";
    // });

    final User user = _auth.currentUser;
    final uid = user.uid;
    print(uid);
    return users.doc(uid).collection("emergence").add({
      "emergence": "Please help am in emergency",
      "latitude": lati,
      "longitude": longi
    });
  }

  User user;

  bool isLoggedIn = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User UserCredential = _auth.currentUser;
    await UserCredential?.reload();
    UserCredential = _auth.currentUser;

    if (UserCredential != null) {
      setState(() {
        this.user = UserCredential;
        this.isLoggedIn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    //final emergenceProvider = Provider.of<  EmergenceProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // text before button
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 0.0),
              child: Text(
                "Emergency help needed?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[800],
                    // fontWeight: FontWeight.w500,
                    fontFamily: 'Open Sans',
                    fontSize: 20),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 0.0),
              child: Text(
                "Just tap the button ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[400],
                    // fontWeight: FontWeight.w500,
                    fontFamily: 'Open Sans',
                    fontSize: 20),
              ),
            ),

            // end text before button

            SizedBox(
              height: 50,
            ),
            AvatarGlow(
              endRadius: 80,
              glowColor: Colors.red[800],
              duration: Duration(milliseconds: 9000),
              repeat: true,
              repeatPauseDuration: Duration(milliseconds: 300),
              child: Material(
                //elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.red[400],
                  child: MaterialButton(
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: addUser),
                ),
              ),
            ),

            Container(
                child: Container(
              width: 330,
              height: 200,
              padding: new EdgeInsets.only(top: 50.0, left: 25.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 0.0, left: 5.0, right: 5.0),
                        child: Text(
                          "Want to add description of emergency event, click the button ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[400],
                              // fontWeight: FontWeight.w500,
                              fontFamily: 'Open Sans',
                              fontSize: 20),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailReportPage()),
                          );
                        },
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        color: Colors.blue,
                      ),
                    ],
                  )),
            )),
          ],
        ),
      ),
    );
  }
}
