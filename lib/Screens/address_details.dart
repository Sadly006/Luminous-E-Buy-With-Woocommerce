import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/new_address_popup.dart';

class AddressDetails extends StatefulWidget {
  const AddressDetails({Key? key}) : super(key: key);

  @override
  _AddressDetailsState createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  final _formKey = GlobalKey<FormState>();

  int selectedAddress = 1;

  getColor(int id, int selected) {
    if (id == selected) {
      selectedAddress = id;
      return Theme.of(context).canvasColor;
    }
  }

  getAddress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: Theme.of(context).highlightColor,
        ),
        Text(
          addressList[selectedAddress]["address"],
          style: TextStyle(
            color: Theme.of(context).highlightColor,
            fontSize: 16.0,
          ),
        )
      ],
    );
  }

  _getAddressList() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            NewAddressPopUp().NewAddress(_formKey, context, setState);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Container(
                height: 40.0,
                width: displayWidth(context) * 0.45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Add New Address",
                      style: Theme.of(context).textTheme.headline5),
                )),
          ),
        ),
        SizedBox(
          height: displayHeight(context) * 0.71,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAddress = index;
                          _getAddressList();
                          getAddress();
                        });
                      },
                      child: Container(
                        width: displayWidth(context),
                        color:
                            getColor(addressList[index]["id"], selectedAddress),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 10, 5, 5),
                                      child: Icon(
                                        Icons.location_on,
                                        size: 20,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  const Padding(padding: EdgeInsets.all(5)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                      Text(
                                        addressList[index]['title'],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .highlightColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 3)),
                                      Text(
                                        addressList[index]['address'],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .highlightColor,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        addressList[index]['city'],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .highlightColor,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            Container(
                              height: 0.15,
                              color: Theme.of(context).highlightColor,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: addressList.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("My Address",
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 20.0,
                )),
            getAddress(),
          ],
        ),
        // titleSpacing: 1.3,
        centerTitle: true,
      ),
      body: _getAddressList(),
    );
  }
}
