import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/providers/userManagement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _password,
      _email,
      _name,
      _mobileNumber,
      _photoUrl,
      _dob,
      _address,
      _occupation,
      _currentLocation;
  //Timestamp _dob;
  String _selectedGender = 'male';

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        // Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  navigateToSignIn() async {
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
    Navigator.pushReplacementNamed(context, "Login");
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      if (user != null) {
        await _auth.currentUser
            .updateProfile(displayName: _name, photoURL: _photoUrl);
        userManagement(_name, _occupation, _currentLocation, _dob, _address,
            _mobileNumber, _photoUrl);
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Registeration Successfully"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                    "The password provided is to weak \n(uppercase,atleast 7 character and a character)"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'))
                ],
              );
            });
      } else if (e.code == 'email already exist-in-use') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("Account aleady exists for the email"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'))
                ],
              );
            });
      } //print(e);
    } catch (e) {
      showError(e.errormessage);
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    //String _selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 20),
                  child: Text(
                    "BIO DATA",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding( 
                  padding: EdgeInsets.only(top:5.0, bottom: 0.0),
                  child: Text(
                    "Please Fill the form ",
                    textAlign: TextAlign.center,
                    style:TextStyle(
                      color: Colors.grey[400],
                      // fontWeight: FontWeight.w500,
                      fontFamily: 'Open Sans',
                      fontSize: 20),
                  ),),
               
              ],
            ),
            Container(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        // child: CircleAvatar(
                        //   radius: 50,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(80),
                        //     child: _image == null
                        //         ? Icon(
                        //             Icons.photo_camera,
                        //             color: Colors.white,
                        //           )
                        //         : Image.file(
                        //             _image,
                        //             fit: BoxFit.cover,
                        //           ),
                        //   ),
                        //   backgroundColor: Colors.grey[400],
                        // )
                     ),
                    ),

                    // name field
                    Padding(
                      padding: const EdgeInsets.only(
                          top:10, bottom: 0, left: 25, right: 25),
                          child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.person_add_alt),
                              onPressed: null),
                          Expanded(
                      child: TextFormField(
                        // ignore: missing_return
                        validator: (input) {
                          if (input.isEmpty) return 'Enter Name';
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                         // prefix: Icon(Icons.person),
                          //  border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(20.0),
                          //   //border:BorderRadius.circular(10),
                          // )
                          // border:BorderRadius.circular(10),
                        ),

                        onSaved: (input) => _name = input,
                      ),
                    ),],),),

                    // Email field
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 5, left: 25, right: 25),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.email_rounded),
                              onPressed: null),
                          Expanded(
                      child: TextFormField(
                        validator: (value) => EmailValidator.validate(value)
                            ? null
                            : "Please enter a valid email",
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'abcd@mail.com',
                         // prefix: Icon(Icons.email_sharp),
                        ),
                        onSaved: (input) => _email = input,
                      ),
                          ),
                      ],
                          ),
                    ),

                    //Phone number field
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 25, right: 25),
                        child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.call),
                              onPressed: null),
                          Expanded(
                        child: TextFormField(
                          // ignore: missing_return
                          validator: (input) {
                            if (input.isEmpty) return 'enter mobile number';
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                           // prefix: Icon(Icons.call),
                          //    border: OutlineInputBorder(
                          //   //borderRadius: BorderRadius.circular(20.0),
                          //   //border:BorderRadius.circular(10),
                          // )
                            //border:BorderRadius.circular(10),
                          ),
                          obscureText: true,
                          onSaved: (input) => _mobileNumber = input,
                        )),],),),

                    //Gender field
                    Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 25, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select gender:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ListTile(
                              leading: Radio(
                                value: 'male',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                              title: Text('Male'),
                            ),
                            ListTile(
                              leading: Radio(
                                value: 'female',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                              title: Text('Female'),
                            ),
                            // SizedBox(height: 25),
                            // Text(_selectedGender == 'male'
                            //     ? 'Hello gentlement!'
                            //     : 'Hi lady!')
                          ],
                        )),

                    // Date of birth field
                    Padding(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 25, right: 25),
                        child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.date_range),
                              onPressed: null),
                          Expanded(    
                        child: DateTimePicker(
                          initialValue: '',
                          type: DateTimePickerType.date,
                          dateLabelText: 'Select Date of Birth',
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          validator: (value) {
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Date of Birth',
                          //      border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(20.0),
                          //   //border:BorderRadius.circular(10),
                          // ),
                           //   prefix: Icon(Icons.date_range)
                           ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _dob = value;
                              });
                            }
                          },
                        )),],),),

                    //Address field
                    SizedBox(height: 10, width: 50,),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 25, right: 25),
                            child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.location_city_rounded),
                              onPressed: null),
                          Expanded(
                        child: TextFormField(
                          // ignore: missing_return
                          validator: (input) {
                            if (input.isEmpty) return 'Enter Address';
                          },

                          decoration: InputDecoration(
                            labelText: 'Address',
                          //   prefix: Icon(Icons.location_city),
                          //    border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(20.0),
                          //   //border:BorderRadius.circular(10),
                          // )
                            //border:BorderRadius.circular(10),
                          ),
                          onSaved: (input) => _address = input,
                        )),],),),

                    // Occupation field
                    // Padding(
                    //     padding: EdgeInsets.only(
                    //         top: 5, bottom: 5, left: 25, right: 25),
                    //     child: TextFormField(
                    //       // ignore: missing_return
                    //       validator: (input) {
                    //         if (input.isEmpty) return 'Enter Occupation';
                    //       },

                    //       decoration: InputDecoration(
                    //         labelText: 'Occupation',
                    //         prefix: Icon(Icons.work_off_outlined),
                    //          border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(20.0),
                    //         //border:BorderRadius.circular(10),
                    //       )
                    //         //border:BorderRadius.circular(10),
                    //       ),
                    //       onSaved: (input) => _occupation = input,
                    //     )),

                    //Password field
                    SizedBox(height: 5),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 25, right: 25),
                            child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.lock_rounded),
                              onPressed: null),
                          Expanded(
                        child: TextFormField(
                          // ignore: missing_return
                          validator: Validators.compose([
                            Validators.required('Password is required'),
                            // Validators.minLength(
                            //     8, 'Name cannot be less than 8 characters'),
                            //Validators.maxLength(10, 'Name cannot be greater than 10 characters'),
                            //Validators: Validators.max(5, 'Value greater than 5 not allowed'),
                            Validators.required('Password is required'),
                            Validators.patternString(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                'Invalid Password')
                          ]),

                          decoration: InputDecoration(
                            labelText: 'Password',
                          //   prefix: Icon(Icons.lock_rounded),
                            
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(20.0),
                          //   //border:BorderRadius.circular(10),
                          // )
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input,
                        )),],),),

                    //location field
                    // Padding(
                    //     padding: EdgeInsets.all(25),
                    // child: TextFormField(
                    //   // ignore: missing_return
                    //   validator: (input) {
                    //     if (input.isEmpty) return 'Enter current Location';
                    //   },

                    //   decoration: InputDecoration(
                    //       labelText: 'Current Location',
                    //       prefix: Icon(
                    //         Icons.location_on,
                    //     )),
                    //   onSaved: (input) => _currentLocation = input,
                    // )),
                    SizedBox(height: 10, width: 50,),
                    RaisedButton(
                      //padding: EdgeInsets.only(left: 30, right: 30),
                      onPressed: signUp,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      color: Colors.blue,
                    ),

                    Container(
                      child: Row(
                        children: <Widget>[
                          Text('Already have an account?'),
                          // ignore: deprecated_member_use
                          FlatButton(
                            textColor: Colors.blue,
                            child: Text(
                              'Sign In',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: navigateToSignIn,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}