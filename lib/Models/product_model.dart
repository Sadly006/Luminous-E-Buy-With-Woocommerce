class ProductModel {
  String? sId;
  String? bengaliName;
  int? objectID;
  String? name;
  String? nameWithoutSubText;
  String? subText;
  int? mrp;
  int? corpPrice;
  int? price;
  Null? shortDesc;
  Null? longDesc;
  String? slug;
  int? doNotApplyDiscounts;
  List<String>? picturesUrls;
  List<Null>? offerPicturesUrls;
  List<int>? recursiveCategories;
  List<int>? categories;
  List<Null>? manufacturers;
  int? blockSale;
  String? sLScore;

  ProductModel(
      {this.sId,
        this.bengaliName,
        this.objectID,
        this.name,
        this.nameWithoutSubText,
        this.subText,
        this.mrp,
        this.corpPrice,
        this.price,
        this.shortDesc,
        this.longDesc,
        this.slug,
        this.doNotApplyDiscounts,
        this.picturesUrls,
        this.offerPicturesUrls,
        this.recursiveCategories,
        this.categories,
        this.manufacturers,
        this.blockSale,
        this.sLScore,
        });

  ProductModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bengaliName = json['bengaliName'];
    objectID = json['objectID'];
    name = json['name'];
    nameWithoutSubText = json['nameWithoutSubText'];
    subText = json['subText'];
    mrp = json['mrp'];
    corpPrice = json['corpPrice'];
    price = json['price'];
    shortDesc = json['shortDesc'];
    longDesc = json['longDesc'];
    slug = json['slug'];
    doNotApplyDiscounts = json['doNotApplyDiscounts'];
    picturesUrls = json['picturesUrls'].cast<String>();
    recursiveCategories = json['recursiveCategories'].cast<int>();
    categories = json['categories'].cast<int>();
  }

}