import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/Authenticate/all_distress.dart';
import 'package:new_app/screens/home.dart';
//import 'package:form_demo_app/sign_up.dart';

class AdminLoginPage extends StatefulWidget {
  AdminLoginPage({Key key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLoginPage> {
  String email, password;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        // ignore: unused_local_variable
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("Login Successfully"),
                actions: [
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => AllDistress(),
                          ),
                        );
                      },
                      child: Text('OK'))
                ],
              );
            });
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Welcome()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("No user found for that email. "),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                );
              });
        } else if (e.code == 'wrong-password') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Wrong password provided for that user"),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                );
              });
        }
      } catch (e) {
        showError(e.errormessage);
        //print('this is the error'+ e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
         backgroundColor: Colors.red[400],
         elevation: 1,
        title: Text('Admin'),
        leading: IconButton(
          onPressed: (){
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Welcome()));
          },
          icon: Icon(
            Icons.arrow_back
            ),
          ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // login section
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Login in',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),



                  //form section
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: 'abcd@email.com',
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),

                    //validating email field
                    //  validator: (String value){
                    //         if(value.isEmpty)
                    //         {
                    //           return 'Please a Enter';
                    //         }
                    //         if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                    //           return 'Please a valid Email';
                    //         }
                    //         return null;
                    //       },
                    //       onSaved: (String value){
                    //         email = value;
                    //       },
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      // hintText: '',
                      suffixIcon: Icon(Icons.visibility_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 30.0,
                  ),
                  // ignore: deprecated_member_use
                 
                  Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      onPressed: () {
                        login();
                      },
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
}
