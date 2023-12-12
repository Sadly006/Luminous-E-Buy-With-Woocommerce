import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  final List<dynamic> productList;
  final int index;
  ImageView({Key? key, required this.productList, required this.index}) : super(key: key);

  getImage(){
    if(productList[index]["images"].length!=0){
      return NetworkImage(
        productList[index]["images"][0]["src"].toString(),
      );
    }
    else{
      return const AssetImage(
        "assets/no-image.png",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: PhotoView(
          imageProvider: getImage(),
        ),
      ),
    );
  }
}
