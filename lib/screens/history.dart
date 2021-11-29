import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';


class Histories extends StatefulWidget {
  const Histories({ Key key }) : super(key: key);

  @override
  _HistoriesState createState() => _HistoriesState();
}

class _HistoriesState extends State<Histories> {
  @override
  Widget build(BuildContext context) {
    //final detailed = Provider.of<List<Detail>>(context);
    return Scaffold(
      appBar: AppBar(
        
         backgroundColor: Colors.red[400],
         elevation: 1,
        title: Text('USERS HISTORY'),
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
        actions: [
          
        ],),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
      //   builder: (context, snapshot){
      //     return ListView.builder(
      //       itemCount: snapshot.data.docs.length,
      //       itemBuilder:(context, index){
      //         DocumentSnapshot user = snapshot.data.docs[index];
      //         if(snapshot.data == null) return CircularProgressIndicator();
      //         snapshot.data.docs.forEach((doc){
      //           ListTile(title: Text(doc['mobileNumber'].toString()),);
      //         });
      //         return CircularProgressIndicator();
      //   },
      //   );
      //   }
      // )
      body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount : snapshot.data.docs.length,
            itemBuilder: (_,index){
              return Card(
                color: Colors.grey[300],
                elevation: 10.0,
                child: Container(
                  child: InkWell(
                    onTap: (){},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          
                        Container(
                          color:Colors.grey[300],
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 20.0),
                            child: Text('HISTORIES'),
                          ),
                        ),
                        Text(
                          snapshot.data.docs[index]["address"].toString()+",",
                          style: new TextStyle(fontSize:21.0,fontWeight:FontWeight.bold
                          ),
                        ),
                        Text(
                          snapshot.data.docs[index]["dob"].toString()+",",
                          style: new TextStyle(fontSize:21.0,fontWeight:FontWeight.bold
                          ),
                        ),
                          Padding(
                              padding:EdgeInsets.only(left:0.0,top: 0.0),
                               child: Container(
                                  width: 280,
                                  child: Text(snapshot.data.docs[index]["mobileNumber"].toString()+',',
                                      style: new TextStyle(fontSize:18.0,fontWeight:FontWeight.normal),
                                      ),
                                ),
                            ),
                      ],
                    ),
                  ),
                ),
                      ]
                  )
              )
            )
          );
          
            }
          );
        }
      )
      // StreamBuilder(
      //     stream: FirebaseFirestore.instance.collection('users').snapshots(),
      //     builder: (context, snapshot) {
      //       if (snapshot.data==null) {
      //         return Center(
      //           child: CircularProgressIndicator(
      //             valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      //           ),
      //         );
      //       } 
      //         snapshot.data.docs.forEach((doc) {
                
      //             print('current value = ${doc['address']}'); //var1
                 
      //         });
      //         return CircularProgressIndicator(
      //           backgroundColor: Colors.blue,
      //         );
      //       }
          
      // )
    );
  }
}