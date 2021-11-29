import 'package:new_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'SignUp.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);
        //  Navigator.pushReplacementNamed(context, "/");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Welcome()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        // ignore: unused_local_variable
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
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

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                child: Image(
                  image: AssetImage(
                    'assets/login.png',
                  ),
                  width: 200,
                  height: 200,
                ),
              ),
            ),

            Container(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                  children: [
                
                    Padding(
                      // padding: const EdgeInsets.all(20),
                      padding: const EdgeInsets.only(bottom:10, top: 0, left:20, right: 20),
                      
                    child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.email), onPressed: null),
                      Expanded(
                      child: TextFormField(
                        validator: (value) => EmailValidator.validate(value)
                            ? null
                            : "Please enter a valid email",
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'abcd@mail.com',
                        ),
                        onSaved: (input) => _email = input,
                      ),
                    ),]
                    ),),

                    Padding(
                      // padding: const EdgeInsets.all(20),
                      padding: const EdgeInsets.only(bottom:20, top: 0, left:20, right: 20),
                    child: Row(
                      children: <Widget>[
                      IconButton(icon: Icon(Icons.visibility_off_outlined), onPressed: null),
                      Expanded(
                      child: TextFormField(
                        // ignore: missing_return
                        validator: (input) {
                          if (input.length < 6)
                            return 'Password is miminum 6 character with uppercase\nand a character';
                        },

                        decoration: InputDecoration(
                          hintText: "Password",
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        onSaved: (input) => _password = input,
                      ),
                    ),],),),

                    //forget password section
                  
                    FlatButton(
                      onPressed: () {
                        //forgot password screen
                      },
                      textColor: Colors.blue,
                      child: Text('Forgot Password ?'),
                    ),

                    // ignore: deprecated_member_use
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      // padding: EdgeInsets.only(left: 30, right: 30),
                      onPressed: login,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),

            Container(
              child: Row(
                children: <Widget>[
                  Text('Does not have account?'),
                  // ignore: deprecated_member_use
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: navigateToSignUp,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),

            
          ],
        ),
      ),
    ));
  }
}
