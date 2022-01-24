import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/payment.dart';
import 'package:luminous_e_buy/Screens/payment_method.dart';

import 'new_address_popup.dart';

class SelectAddress extends StatefulWidget {
  SelectAddress({Key? key, required this.cost}) : super(key: key);
  double cost;

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  final _formKey2 = GlobalKey<FormState>();

  int selectedAddress =1;

  getColor(int id, int selected){
    if(id==selected) {
      selectedAddress = id;
      return Colors.grey[500];
    }
  }

  getAddress(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.location_on,
          color: Colors.grey,
        ),
        Text(
          addressList[selectedAddress]["address"],
          style: const TextStyle(
            color: Colors.grey,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Container(
              height: 40.0,
              width: displayWidth(context)*0.45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                    "Add New Address",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    )
                ),
              )
            ),
          ),
          onTap: () {
            NewAddressPopUp().NewAddress(_formKey2, context, setState);
          },
        ),
        SizedBox(
          height: displayHeight(context)*0.71,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, index){
                      return GestureDetector(
                        onTap: (){
                          selectedAddress = index;
                          setState(() {});
                        },
                        child: Container(
                          width: displayWidth(context),
                          color: getColor(addressList[index]["id"], selectedAddress),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                        child: Icon(Icons.location_on, size: 20, color: Theme.of(context).primaryColor,)
                                    ),
                                    const Padding(padding: EdgeInsets.all(5)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(padding: EdgeInsets.only(top: 10)),
                                        Text(addressList[index]['title'], style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w500),),
                                        const Padding(padding: EdgeInsets.only(top: 3)),
                                        Text(addressList[index]['address'], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 12),),
                                        Text(addressList[index]['city'], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 12),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              Container(
                                height: 0.15,
                                color: Theme.of(context).accentColor,
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
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Container(
              height: 50.0,
              width: displayWidth(context)*0.9,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Text(
                "Review Payment",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
              ),
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => Payment(cost: widget.cost, addressId: selectedAddress,),
              builder: (context) => PaymentMethod(cost: widget.cost, selectedAddress: selectedAddress,),
            )
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text("My Address",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 18.0,
              )
            ),
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
