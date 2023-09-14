import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/address_details.dart';
import 'package:luminous_e_buy/Screens/order_history.dart';
import 'package:luminous_e_buy/Screens/payment_history.dart';
import 'package:luminous_e_buy/Screens/profile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/product_functions.dart';
import 'Authentications/sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileOverview extends StatefulWidget {
  const ProfileOverview({Key? key}) : super(key: key);

  @override
  _ProfileOverviewState createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  XFile? imageFile;
  ImagePicker imagePicker = ImagePicker();
  late String name;
  late String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker;
  }

  dpPicker(BuildContext context, ImagePicker imagePicker, XFile? imageFile) {
    return showMaterialModalBottomSheet(
      expand: false,
      enableDrag: true,
      bounce: true,
      context: context,
      builder: (context) => SizedBox(
          height: 50,
          width: displayWidth(context) * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(2)),
              const Icon(Icons.image),
              const Padding(padding: EdgeInsets.all(2)),
              TextButton(
                onPressed: () async {
                  imageFile = (await imagePicker.pickImage(
                      source: ImageSource.gallery));
                },
                child: Text(
                  "Select Profile Picture",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      dpPicker(context, imagePicker, imageFile);
                    },
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  Text(
                    info['name'].toString(),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).highlightColor),
                  ),
                  const Padding(padding: EdgeInsets.all(2)),
                  Text(
                    info['email'].toString(),
                    style: const TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              cartList.length.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).highlightColor),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "In Cart",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              wishList.length.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).highlightColor),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "In WishList",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "05",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).highlightColor),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Total Ordered",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 0.2,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (() async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (prefs.getString('token') == 'true') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrderHistory(),
                                  ));
                            } else {
                              showToast(
                                'SignIn to view this page!',
                                context: context,
                                backgroundColor:
                                    const Color.fromRGBO(255, 182, 193, 1),
                                textStyle: const TextStyle(color: Colors.black),
                                animation: StyledToastAnimation.slideFromLeft,
                                reverseAnimation: StyledToastAnimation.fade,
                                position: StyledToastPosition.bottom,
                                animDuration: const Duration(seconds: 1),
                                duration: const Duration(seconds: 3),
                                curve: Curves.elasticOut,
                                reverseCurve: Curves.linear,
                              );
                            }
                          }),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.featured_play_list,
                                    size: 30,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Orders",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (() async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (prefs.getString('token') == 'true') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(),
                                  ));
                            } else {
                              showToast(
                                'SignIn to view this page!',
                                context: context,
                                backgroundColor:
                                    const Color.fromRGBO(255, 182, 193, 1),
                                textStyle: const TextStyle(color: Colors.black),
                                animation: StyledToastAnimation.slideFromLeft,
                                reverseAnimation: StyledToastAnimation.fade,
                                position: StyledToastPosition.bottom,
                                animDuration: const Duration(seconds: 1),
                                duration: const Duration(seconds: 3),
                                curve: Curves.elasticOut,
                                reverseCurve: Curves.linear,
                              );
                            }
                          }),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (() async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (prefs.getString('token') == 'true') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddressDetails(),
                                  ));
                            } else {
                              showToast(
                                'SignIn to view this page!',
                                context: context,
                                backgroundColor:
                                    const Color.fromRGBO(255, 182, 193, 1),
                                textStyle: const TextStyle(color: Colors.black),
                                animation: StyledToastAnimation.slideFromLeft,
                                reverseAnimation: StyledToastAnimation.fade,
                                position: StyledToastPosition.bottom,
                                animDuration: const Duration(seconds: 1),
                                duration: const Duration(seconds: 3),
                                curve: Curves.elasticOut,
                                reverseCurve: Curves.linear,
                              );
                            }
                          }),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Addresses",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.message_rounded,
                                  size: 30,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Messages",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 0.2,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: const BoxDecoration(
                            color: Colors.lightGreenAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.notifications_none,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(
                          "Notification",
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).highlightColor),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    onTap: (() async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (prefs.getString('token') == 'true') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentHistory(),
                            ));
                      } else {
                        showToast(
                          'SignIn to view this page!',
                          context: context,
                          backgroundColor:
                              const Color.fromRGBO(255, 182, 193, 1),
                          textStyle: const TextStyle(color: Colors.black),
                          animation: StyledToastAnimation.slideFromLeft,
                          reverseAnimation: StyledToastAnimation.fade,
                          position: StyledToastPosition.bottom,
                          animDuration: const Duration(seconds: 1),
                          duration: const Duration(seconds: 3),
                          curve: Curves.elasticOut,
                          reverseCurve: Curves.linear,
                        );
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              color: Colors.deepOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.payment_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          Text(
                            "Payment History",
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).highlightColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            childCount: 1,
          ))
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('token');
                  prefs.setString('userName', 'Unknown');
                  prefs.setString('email', 'Unknown');
                  cart.clear();
                  cartList.clear();
                  wishList.clear();
                  ProductFunction().setCartMemory();
                  Navigator.popUntil(context, ModalRoute.withName(''));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ));
                },
                child: const Text("Logout"),
              )),
        ),
      ],
    );
  }
}
