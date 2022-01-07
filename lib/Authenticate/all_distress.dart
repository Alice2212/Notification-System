import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_app/Authenticate/admin_login.dart';

import 'DistressMap.dart';

class AllDistress extends StatefulWidget {
  const AllDistress({Key key}) : super(key: key);

  @override
  _AllDistressState createState() => _AllDistressState();
}

class _AllDistressState extends State<AllDistress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         backgroundColor: Colors.red[400],
         elevation: 1,
          title: Text("All Distress"),
          centerTitle: true,
          leading: IconButton(
          onPressed: (){
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminLoginPage()));
          },
          icon: Icon(
            Icons.arrow_back
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("distress").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("No Data currently"));
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                break;
              default:
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error));
                } else {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Snapshot error ${snapshot.error}"));
                  } else {
                    var values = snapshot.data;
                    if (values.docs.length == 0) {
                      return Center(child: Text("No Data Currently"));
                    } else {
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var currentSnapshot =
                              snapshot.data.docs[index].data();

                          print("CURRENT SNAPSHOT ==> $currentSnapshot");
                          var date = new DateTime.fromMicrosecondsSinceEpoch(
                              currentSnapshot["doi"].seconds);
                          var nowDate =
                              DateFormat("yMMMEd").format(DateTime.now());
                          var obtainedDate = DateFormat("yMMMEd").format(date);

                          return ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey, shape: BoxShape.circle),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                    future: FirebaseFirestore.instance
                                        .collection("users")
                                        .where("uid",
                                            isEqualTo:
                                                currentSnapshot["senderId"])
                                        .get(),
                                    builder: (context, snapshot) {
                                      print(
                                          "Snapshot data ===> ${snapshot.data.docs[0].data()}");
                                      return Text(snapshot.data.docs[0]
                                          .data()["displayName"]);
                                    }),
                                SizedBox(height: 5),
                                Text(currentSnapshot["suject"]),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentSnapshot["address"]),
                                SizedBox(height: 5),
                                Text(currentSnapshot["description"]),
                                SizedBox(height: 5),
                               // Text(
                                //
                                //    "Latitude: ${currentSnapshot["latitude"]}, Longitude: ${currentSnapshot["longitude"]}")
                              
                                Text(snapshot.data.docs[index]['latitude'].toString()),
                                Text(snapshot.data.docs[index]['latitude'].toString()),

                                Container(
                                    height: 300,
                                    child: GoogleMap(
                                    myLocationEnabled: true,
                                    // onMapCreated: onMapCreated,
                                    // markers:{
                                    //   Marker(icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta))
                                    // } ,
                                       initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                          double.parse(snapshot.data.docs[index]['latitude']),double.parse(snapshot.data.docs[index]['longitude'])),
                                        zoom: 15,
                                        )
                                    ),
                                ),

                              ],
                            ),
                        // trailing: Text(obtainedDate),
                        trailing: IconButton(
                          onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DistressMap(user_id: snapshot.data.docs[index].id)));
                        },           icon: Icon(Icons.map)
                        )
                        //   DistressMap(user_id: snapshot.data.docs[index].id)
                        //   ));
                        //   },)
                          );
                        },
                      );
                    }
                  }
                }
            }
          },
        ));
  }
}
