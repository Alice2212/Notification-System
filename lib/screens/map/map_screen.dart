import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../blocs/application_bloc.dart';


class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({ Key  key }) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}


class _GoogleMapScreenState extends State<GoogleMapScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<void> requestPermission() async 
    { await Permission.location.request(); }
  }

  

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.red[400],
         elevation: 1,
        title:Text('Google Map '),
        actions: [],
        ),

      body: (applicationBloc.currentLocation == null)
      ?Center(child: CircularProgressIndicator(),)
      :ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Location'
            ),
          ),
          Container(
            height: 300,
            child: GoogleMap(
            myLocationEnabled: true,
            // onMapCreated: onMapCreated,
            // markers: _marker,
            initialCameraPosition: CameraPosition(
              target: LatLng(applicationBloc.currentLocation.latitude,applicationBloc.currentLocation.longitude),
              zoom: 15,
              )
        ),
          ),
        ],
         
      )
    );
  }
}