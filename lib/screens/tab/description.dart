import 'package:date_time_picker/date_time_picker.dart';
import 'package:new_app/blocs/application_bloc.dart';
import 'package:new_app/providers/details_provider.dart';
// import 'package:new_app/screens/components/speechText.dart';//
import 'package:new_app/screens/home.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:new_app/screens/components/cameraWidget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comment_box/comment/comment.dart';

class DetailReportPage extends StatefulWidget {
  const DetailReportPage({Key key}) : super(key: key);

  @override
  _DetailReportPageState createState() => _DetailReportPageState();
}

class _DetailReportPageState extends State<DetailReportPage> {
  //final GlobalKey<FormState>_formKey = GlobalKey<FormState>();

  TextEditingController _subject = new TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _currentLocation = TextEditingController();
  TextEditingController _doi = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FlutterTts _flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    speak() async {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1);
      await _flutterTts.speak("Hep! Help!! Help!!!");
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
                    child: Text('OK')),
              ],
            );
          });
    }

    final detailedProvider = Provider.of<DetailedProvider>(context);
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 1,
        title: Text('Emegency description'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Welcome()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        //reverse:true,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _subject,
                        // ignore: missing_return
                        validator: (input) {
                          if (input.isEmpty) return 'Emergency details';
                        },

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                            hintText: "Enter emergency descripiton",
                             labelText: 'Emergency subject',
                         
                        ),
                        onChanged: (value) {
                          detailedProvider.changeSubject(value);
                          detailedProvider.changeDoi();
                        },
                        //onSaved: (input)=>_name=input,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _address,
                        // ignore: missing_return
                        validator: (input) {
                          if (input.isEmpty) return 'Enter the address';
                        },

                        decoration: InputDecoration(
                            
                            labelText: 'Address',
                            hintText: 'Enter Address'),
                        onChanged: (value) {
                          detailedProvider.changeaAddress(value);
                          detailedProvider.changeCurrentLatitude(applicationBloc
                              .currentLocation.latitude
                              .toString());
                          detailedProvider.changeCurrentLongitude(
                              applicationBloc.currentLocation.longitude
                                  .toString());
                        },
                        //onSaved: (input)=>_email=input,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 260,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _description,
                              maxLines: 3,
                              // ignore: missing_return
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Description';
                              },

                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter emergency desription',
                                labelText: 'Description of the event',
                              ),
                              onChanged: (value) {
                                detailedProvider.changeDescription(value);
                              },
                             
                            ),
                          ),
                        ),

                        // AvatarGlow(
                        //   // animate: isListening,
                        // endRadius: 30,
                        // glowColor: Colors.grey[700],
                        // child: IconButton(
                        //   icon: Icon(Icons.mic_none,
                        //     color: Colors.black,
                        //       size: 30,
                        //       ),
                        //       onPressed: (){
                        //         Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder:(context)=> SpeechToText(),
                        //       ),
                        //     );
                        //       },

                        //   ),
                        // ),
                      ],
                    ),

                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Text(
                        "Add images",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.indigo[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CameraComponent(),
                    ),

                    RaisedButton(
                      onPressed: () {
                        try {
                          detailedProvider.saveDetail(
                            subject: _subject.text.trim(),
                            address: _address.text.trim(),
                            description: _description.text.trim(),
                            doi: DateTime.now(),
                            latitude: applicationBloc.currentLocation.latitude
                                .toString(),
                            longitude: applicationBloc.currentLocation.longitude
                                .toString(),
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //title: Text('ERROR'),
                                  content: Text("Report successfully"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'))
                                  ],
                                );
                              });
                        } catch (error) {
                          showError(error);
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),

            // Row(
            //             children: [
            //               CircleAvatar(
            //                 backgroundColor: Colors.orangeAccent,
            //                 child: IconButton(
            //                   icon: Icon(
            //                     Icons.add_a_photo,
            //                     color: Colors.black,
            //                     ),
            //                     onPressed: () {  },
            //                 ),
            //                 ),

            //                 CircleAvatar(
            //                 backgroundColor: Colors.orangeAccent,
            //                 child: IconButton(
            //                   icon: Icon(
            //                     Icons.record_voice_over,
            //                     color: Colors.black,
            //                     ),
            //                     onPressed: () {
            //                       speak();
            //                      },
            //                 ),
            //                 ),

            //             ],
            //           ),
          ],
        ),
      ),
    );
  }

//   Future toggleRecording()=>SpeechApi.toggleRecording(
//     onResult: (text)=>setState(()=> this.text = text,
//     ),
//     onListening: (isListening) {
//        setState(()=>this.isListening = isListening);
//     });
}
