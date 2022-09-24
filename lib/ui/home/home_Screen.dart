import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/ui/home/add_post.dart';
import 'package:firebase/ui/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../auth/login/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "Name Loading";
  String email = "Email Loading";

  final auth = FirebaseAuth.instance;

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
        _polyline.add(Polyline(
            polylineId: PolylineId('1'), points: latlong, color: Colors.blue));
      });
    }
  }

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

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

  final ref = FirebaseDatabase.instance.ref('post');
  final searchController = TextEditingController();

  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //
      //   onPressed: () {
      //     getCurrentLoaction().then((value) {
      //       print(
      //           value.latitude.toString() + "" + value.longitude.toString());
      //     });
      //   },
      //   child: Icon(Icons.add),
      //
      // ),
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: TextFormField(
              controller: searchController,
              onChanged: (String value) {
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 5.w),
                ),
                hintText: "Search",
              ),
            ),
          ),
          // Expanded(
          //     child: StreamBuilder(
          //   stream: ref.onValue,
          //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //
          //     if (!snapshot.hasData) {
          //       log("message${snapshot.data?.snapshot.children.length}");
          //       return Center(child: CircularProgressIndicator());
          //     } else {
          //       Map<dynamic, dynamic> map =
          //           snapshot.data!.snapshot.value as dynamic;
          //       List<dynamic> list=[];
          //       list.clear();
          //       list=map.values.toList();
          //       log("list ${list.toString()}");
          //       return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(list[index]['title']),
          //               subtitle: Text(list[index]['id']),
          //             );
          //           });
          //     }
          //   },
          // )),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Text("Loading"),
                itemBuilder: (context, snapshot, animation, index) {
                  final titile = snapshot.child('title').value.toString();
                  if (searchController.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(titile,snapshot.child('id').value.toString());
                              },
                              title: Text("Edit"),
                              leading: Icon(Icons.edit),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: () {
                                ref.child(snapshot.child('id').value.toString()).remove().then((value) {
                                  Utils().toastMessage('id${snapshot.child('id').value.toString()}');
                                  log("testing ${ref}");
                                });

                                Navigator.pop(context);
                              },
                              title: Text("Delete"),
                              leading: Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (titile.toLowerCase().contains(
                      searchController.text.toLowerCase().toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),

      // GoogleMap(
      //   markers: _markers,
      //   mapType: MapType.normal,
      //   myLocationEnabled: true,
      //   compassEnabled: false,
      //   polylines: _polyline,
      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //   },
      // )
    );
  }

  Future<void> showMyDialog(String title,String id ) async {
    editController.text=title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("update"),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(hintText: 'Edit Text'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title' :editController.text.toLowerCase()
                    }).then((value) {
                      Utils().toastMessage('Post Updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text("Update")),
            ],
          );
        });
  }
}
