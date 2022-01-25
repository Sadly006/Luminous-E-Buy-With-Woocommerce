import 'package:flutter/material.dart';

class RatingFunctions {
  getShopRating(int id, List profile){
    if(profile[id]["rating"]==0){
      return Row(
        children: const [
          Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          )
        ],
      );
    }
    else if(profile[id]["rating"]>0 && profile[id]["rating"]<2){
      return Row(
        children: [
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          )
        ],
      );
    }
    else if(profile[id]["rating"]>=2 && profile[id]["rating"]<3){
      return Row(
        children: [
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          )
        ],
      );
    }
    else if(profile[id]["rating"]>=3 && profile[id]["rating"]<4){
      return Row(
        children: [
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          )
        ],
      );
    }
    else if(profile[id]["rating"]>=4 && profile[id]["rating"]<5){
      return Row(
        children: [
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          Icon(
            Icons.star,
            size: 15,
            color: Colors.deepOrange[900],
          ),
          const Icon(
            Icons.star,
            size: 15,
            color: Colors.white,
          )
        ],
      );
    }
  }

}