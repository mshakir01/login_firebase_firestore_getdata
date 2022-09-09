import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/ui/login.dart';
import 'package:firebase/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "Name Loading";
  String email = "Email Loading";

  @override
  void initState() {
    super.initState();
    getData();

    for (int i = 0; i < latlong.length; i++) {
      _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: latlong[i],
          infoWindow: InfoWindow(
            title: "Realy Cool Place",

          ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {
        _polyline.add(Polyline(polylineId: PolylineId('1'),
            points: latlong,
          color: Colors.blue

        ));
      });

    }
  }

  void getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    print("user${user!.uid.toString()}");
    var vari = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(user.uid)
        .get();
    setState(() {
      name = vari.data()!['name'];
      print("asdfghjk${name.toString()}");
      email = vari.data()!['email'];
    });
  }

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  final auth = FirebaseAuth.instance;
  Completer<GoogleMapController> _controller = Completer();

  Future<Position> getCurrentLoaction() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error ${error.toString()}");
    });
    return await Geolocator.getCurrentPosition();
  }

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  List<LatLng> latlong = [
    LatLng(34.034026, 71.428005),
    LatLng(33.984772, 71.449405),
  ];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(34.034026, 71.428005),
    zoom: 14,
  );

  List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.6844, 73.0479),
        infoWindow: InfoWindow(title: 'some Info ')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(

          onPressed: () {
            getCurrentLoaction().then((value) {
              print(
                  value.latitude.toString() + "" + value.longitude.toString());
            });
          },
          child: Icon(Icons.add),
          
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                // color: Colors.orange,
                child: DrawerHeader(
                  child: Column(
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.h,
                        child: CircleAvatar(
                          child: Container(
                            width: 110.w,
                            height: 110.h,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://image.shutterstock.com/image-photo/portrait-happy-mid-adult-man-260nw-1812937819.jpg"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    leading: const Text("Name "),
                    title: Text(name),
                  ),
                  Divider(
                    height: 2,
                  ),
                  ListTile(
                    leading: const Text("Email "),
                    title: Text(email),
                  ),
                  Divider(
                    height: 2,
                  ),
                  InkWell(
                      onTap: () {
                        print("hellloword");
                        getData();
                      },
                      child: Text(
                        "data",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("DashBoard"),
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen())).onError(
                          (error, stackTrace) =>
                              Utils().toastMessage(error.toString()))
                    });
              },
              icon: Icon(Icons.logout),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
        body: GoogleMap(
          markers: _markers,
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: false,
          polylines: _polyline,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
  }
}
