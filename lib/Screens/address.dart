import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import 'package:luminous_e_buy/Screens/payment.dart';

class Address extends StatefulWidget {
  Address({Key? key, required this.cost}) : super(key: key);
  double cost;

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {

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
          addressList[selectedAddress]["location"],
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
              child: Align(
                alignment: Alignment.center,
                child: Text(
                    "Add New Address",
                    style: Theme.of(context).textTheme.headline5
                ),
              )
            ),
          ),
          onTap: () => debugPrint("Order Done!"),
        ),
        SizedBox(
          height: displayHeight(context)*0.71,
          child: CustomScrollView(
            slivers: [
              SliverList(delegate: SliverChildBuilderDelegate(
                    (BuildContext context, index){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedAddress = index;
                        _getAddressList();
                        getAddress();
                      });
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
                                    Text(addressList[index]['location'], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 12),),
                                    Text(addressList[index]['district'], style: TextStyle(color: Theme.of(context).accentColor, fontSize: 12),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
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
                "Place Order",
                style: Theme.of(context).textTheme.headline4
              ),
            ),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Payment(cost: widget.cost,),
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
