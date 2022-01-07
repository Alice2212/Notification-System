import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistressMap extends StatefulWidget {
  final String user_id;
  const DistressMap({ Key key, this.user_id}) : super(key: key);

  @override
  _DistressMapState createState() => _DistressMapState();
}

class _DistressMapState extends State<DistressMap> {

  final loc.Location location = loc.Location();
   GoogleMapController _controller;
   bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('distress').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
          if(_added){
            myMap(snapshot);
          }

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return GoogleMap(
            mapToolbarEnabled: true,
            mapType: MapType.normal,
            markers:{
              Marker(
                position: LatLng(
              snapshot.data.docs.singleWhere((element) => 
              element.id == widget.user_id)['latitude'],
              
              snapshot.data.docs.singleWhere((element) => 
              element.id == widget.user_id)['longtitude'],
              ),


              markerId: MarkerId('id'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)
              )
            },
            initialCameraPosition: CameraPosition(
              target:LatLng(
                snapshot.data.docs.singleWhere((element) => 
                element.id == widget.user_id)['latitude'],

                 snapshot.data.docs.singleWhere((element) => 
                element.id == widget.user_id)['longtitude'],
              ),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller)async{
              setState(() {
                _controller = controller;
                _added = true;
                print(widget.user_id);
              });
            },

          );
        }
      ),

      
    );
  }


Future<void>myMap(AsyncSnapshot<QuerySnapshot>snapshot)async{
  await _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
    snapshot.data.docs.singleWhere((element) => 
    element.id == widget.user_id)['latitude'],

    snapshot.data.docs.singleWhere((element) =>
    element.id == widget.user_id)['longitude'],
  ),
  zoom: 15.0
  )));
}
}