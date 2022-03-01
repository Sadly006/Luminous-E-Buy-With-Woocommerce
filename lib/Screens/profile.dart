import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant_Values/lists.dart';
import '../Services/product_functions.dart';
import 'Authentications/sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? imageFile;
  ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker;
  }

  dpPicker(BuildContext context, ImagePicker imagePicker, XFile? imageFile){
    return showMaterialModalBottomSheet(
      expand: false,
      enableDrag: true,
      bounce: true,
      context: context,
      builder: (context) =>SizedBox(
          height: 50,
          width: displayWidth(context)*0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(2)),
              const Icon(Icons.image),
              const Padding(padding: EdgeInsets.all(2)),
              TextButton(
                onPressed: () async {
                  imageFile = (await imagePicker.pickImage(source: ImageSource.gallery));

                },
                child: Text(
                  "Select Profile Picture",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList(delegate: SliverChildBuilderDelegate(
                  (BuildContext context, index){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 20, 0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text("Edit",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    GestureDetector(
                      onTap: (){
                        dpPicker(context, imagePicker, imageFile);
                      },
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network("https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(info['name'].toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(20)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                          child: Text("Contact Information",
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          width: displayWidth(context)*1,
                          child: Card(
                            color: Theme.of(context).backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [

                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                      color: Colors.lightGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.mail,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const Padding(padding: EdgeInsets.all(5)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                      Text(info['email'].toString(),
                                        style: Theme.of(context).textTheme.headline6,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.home,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Residence",
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Text("Panthapath, Dhaka",
                                      style: Theme.of(context).textTheme.headline6,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.phone,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phone Number",
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Text("01640682045",
                                      style: Theme.of(context).textTheme.headline6,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                          child: Text("Contact Information",
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          width: displayWidth(context)*1,
                          child: Card(
                            color: Theme.of(context).backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [

                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                      color: Colors.lightGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.mail,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const Padding(padding: EdgeInsets.all(5)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                      Text("taosifsadly@gmail.com",
                                        style: Theme.of(context).textTheme.headline6,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.home,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Residence",
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Text("Panthapath, Dhaka",
                                      style: Theme.of(context).textTheme.headline6,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.phone,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phone Number",
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Text("01640682045",
                                      style: Theme.of(context).textTheme.headline6,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                          child: Text("Contact Information",
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          width: displayWidth(context)*1,
                          child: Card(
                            color: Theme.of(context).backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [

                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                      color: Colors.lightGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.mail,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  const Padding(padding: EdgeInsets.all(5)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                      Text("taosifsadly@gmail.com",
                                        style: Theme.of(context).textTheme.headline6,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.home,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Residence",
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Text("Panthapath, Dhaka",
                                      style: Theme.of(context).textTheme.headline6,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.phone,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phone Number",
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    Text("01640682045",
                                      style: Theme.of(context).textTheme.headline6,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              childCount: 1,
            )
            )
          ],
        ),
      )
    );
  }
}
