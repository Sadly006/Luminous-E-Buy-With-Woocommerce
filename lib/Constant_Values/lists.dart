List<dynamic> productList = [];
List<dynamic> previousOrderProductList = [];
List<dynamic> orderList = [];
List<dynamic> relatedProductList = [];
List<dynamic> newArrival = [];
List<dynamic> topPicks = [];
List<dynamic> forYou = [];

List<dynamic> pList = [];

List<Map<String, dynamic>> addressList = [
  {"id": 0, "title": "Home", "first_name": "Taosif", "last_name": "Sadly", "contact_number": "01640682045", "address": "250 Panthapath", "city": "Dhaka", "country": "Bangladesh", "email": "taosifsadly@gmail.com"},
  {"id": 1, "title": "Office", "first_name": "Taosif", "last_name": "Sadly", "contact_number": "01640682045", "address": "Mirpur DOHS", "city": "Dhaka", "country": "Bangladesh", "email": "taosifsadly@gmail.com"},
  {"id": 2, "title": "Home", "first_name": "Taosif", "last_name": "Sadly", "contact_number": "01640682045", "address": "Maijdee, Noakhali", "city": "Noakhali", "country": "Bangladesh", "email": "taosifsadly@gmail.com"},
];

List<String> carousalImageList = [
  "https://i.pinimg.com/564x/fa/9f/f1/fa9ff1e4a97f5197145647c34ebc2371.jpg",
  "https://i.pinimg.com/564x/c5/f2/84/c5f284dbcc453329e05f746f845a10c9.jpg",
  "https://images.pexels.com/photos/5624985/pexels-photo-5624985.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://i.pinimg.com/564x/64/a0/81/64a08106bab408afcf926e1b2c568c7b.jpg",
];

List<String> categoryNameList = [
  "Gadgets",
  "Accessories",
  "Groceries",
  "Electronics",
  "Bags",
  "Face Masks",
  "Footwear"
];

List<String> categoryImageList = [
  "https://images.pexels.com/photos/3981749/pexels-photo-3981749.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://images.pexels.com/photos/115566/pexels-photo-115566.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://images.pexels.com/photos/6157056/pexels-photo-6157056.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://images.pexels.com/photos/4033005/pexels-photo-4033005.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://images.pexels.com/photos/8818649/pexels-photo-8818649.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://images.pexels.com/photos/3873177/pexels-photo-3873177.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  "https://images.pexels.com/photos/1456706/pexels-photo-1456706.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
];
//
// List<Map<String, dynamic>> newArivalList = [
//   {"name": "Razer BlackWidow V3 Mini HyperSpeed - Green Switch", "price": 179.99, "image": "https://images.unsplash.com/photo-1613160717888-faa82cdb8a94?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjR8fGdhbWluZyUyMGtleWJvYXJkfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60", "discount": 0, "shopId": 1, "brand": "Razer", "logo": "https://assets2.razerzone.com/images/pnx.assets/09a0c71116e39ef8c882159300d66e29/quad_damage-th.jpg"},
//   {"name": "Beats Solo 3", "price": 200, "image": "https://images.pexels.com/photos/1591/technology-music-sound-things.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260", "discount": 0, "shopId": 2, "brand": "BeatsByDre", "logo": "https://cdn.mos.cms.futurecdn.net/kwyUDPNptGShKsQ7tNMhcn-970-80.jpg.webp"},
//   {"name": "Samsung Galaxy Note 6", "price": 500, "image": "https://images.pexels.com/photos/214487/pexels-photo-214487.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 10, "shopId": 3, "brand": "Samsung", "logo": "https://www.nicepng.com/png/full/386-3864555_samsung-logo-black-samsung-icon-black-and-white.png"},
//   {"name": "IPhone 10", "price": 999, "image": "https://images.pexels.com/photos/3586249/pexels-photo-3586249.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 30, "shopId": 4, "brand": "Apple", "logo": "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png?Monday,%2025-Oct-2021%2000:55:31%20GMT"},
// ];
//
// List<Map<String, dynamic>> topPickList = [
//   {"name": "Veloce Legion 30", "price": 240, "image": "https://images.pexels.com/photos/100582/pexels-photo-100582.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 5, "brand": "Veloce", "logo": "http://velocebike.com/bangladesh/wp-content/uploads/sites/8/2020/10/Veloce-Logo_Text_Veloce-1-1-1.png"},
//   {"name": "Adidas UltraBoost", "price": 237, "image": "https://images.pexels.com/photos/1407354/pexels-photo-1407354.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 5, "shopId": 6, "brand": "Adidas", "logo": "https://1757140519.rsc.cdn77.org/blog/wp-content/uploads/2020/03/the-5th-logo.png"},
//   {"name": "Jackson Pro Series Spectra", "price": 165, "image": "https://images.pexels.com/photos/5902807/pexels-photo-5902807.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 7, "brand": "Jackson", "logo": "https://seeklogo.com/images/J/Jackson_Guitars-logo-AB2975A0FD-seeklogo.com.png"},
//   {"name": "Besus Pro", "price": 85, "image": "https://images.pexels.com/photos/1279107/pexels-photo-1279107.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 8, "brand": "Besus", "logo": "https://seeklogo.com/images/J/Jackson_Guitars-logo-AB2975A0FD-seeklogo.com.png"},
// ];
//
// List<Map<String, dynamic>> forYouList = [
//   {"name": "Cleaner(Local)", "price": 9, "image": "https://images.pexels.com/photos/5217774/pexels-photo-5217774.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 9, "brand": "Local Store", "logo": "https://images.creativemarket.com/0.1.0/ps/1703464/910/607/m1/fpnw/wm0/find-bag-local-shop-pin-store-shopping-logo-02-.jpg?1611079644&s=03d770b122e1989fa2f775ff550d155c&fmt=webp"},
//   {"name": "Lotto Face Mask", "price": 2, "image": "https://images.pexels.com/photos/6461515/pexels-photo-6461515.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 8, "shopId": 10, "brand": "Lotto", "logo": "https://seeklogo.com/images/L/Lotto-logo-18CDC5D50B-seeklogo.com.png"},
//   {"name": "Nikon D6", "price": 6499, "image": "https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 11, "brand": "Nikon", "logo": "https://image.shutterstock.com/image-photo/image-260nw-279017711.jpg"},
//   {"name": "Xiaomi Bluetooth Basic", "price": 29, "image": "https://images.pexels.com/photos/7156886/pexels-photo-7156886.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 10, "shopId": 12, "brand": "Xiaomi", "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Xiaomi_logo.svg/200px-Xiaomi_logo.svg.png"},
// ];
//
// List<Map<String, dynamic>> productList = [
//   {"name": "Razer BlackWidow V3 Mini HyperSpeed - Green Switch", "price": 179.99, "image": "https://images.pexels.com/photos/1010496/pexels-photo-1010496.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 1, "brand": "Razer", "logo": "https://assets2.razerzone.com/images/pnx.assets/09a0c71116e39ef8c882159300d66e29/quad_damage-th.jpg"},
//   {"name": "Beats Solo 3", "price": 200, "image": "https://images.pexels.com/photos/1591/technology-music-sound-things.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260", "discount": 0, "shopId": 2, "brand": "BeatsByDre", "logo": "https://cdn.mos.cms.futurecdn.net/kwyUDPNptGShKsQ7tNMhcn-970-80.jpg.webp"},
//   {"name": "Samsung Galaxy Note 6", "price": 500, "image": "https://images.pexels.com/photos/214487/pexels-photo-214487.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 10, "shopId": 3, "brand": "Samsung", "logo": "https://www.nicepng.com/png/full/386-3864555_samsung-logo-black-samsung-icon-black-and-white.png"},
//   {"name": "IPhone 10", "price": 999, "image": "https://images.pexels.com/photos/3586249/pexels-photo-3586249.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 30, "shopId": 4, "brand": "Apple", "logo": "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png?Monday,%2025-Oct-2021%2000:55:31%20GMT"},
//   {"name": "Veloce Legion 30", "price": 240, "image": "https://images.pexels.com/photos/100582/pexels-photo-100582.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 5, "brand": "Veloce", "logo": "http://velocebike.com/bangladesh/wp-content/uploads/sites/8/2020/10/Veloce-Logo_Text_Veloce-1-1-1.png"},
//   {"name": "Adidas UltraBoost", "price": 237, "image": "https://images.pexels.com/photos/1407354/pexels-photo-1407354.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 5, "shopId": 6, "brand": "Adidas", "logo": "https://1757140519.rsc.cdn77.org/blog/wp-content/uploads/2020/03/the-5th-logo.png"},
//   {"name": "Jackson Pro Series Spectra", "price": 165, "image": "https://images.pexels.com/photos/5902807/pexels-photo-5902807.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 7, "brand": "Jackson", "logo": "https://seeklogo.com/images/J/Jackson_Guitars-logo-AB2975A0FD-seeklogo.com.png"},
//   {"name": "Besus Pro", "price": 85, "image": "https://images.pexels.com/photos/1279107/pexels-photo-1279107.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 8, "brand": "Besus", "logo": "https://seeklogo.com/images/J/Jackson_Guitars-logo-AB2975A0FD-seeklogo.com.png"},
//   {"name": "Cleaner(Local)", "price": 9, "image": "https://images.pexels.com/photos/5217774/pexels-photo-5217774.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 9, "brand": "Local Store", "logo": "https://images.creativemarket.com/0.1.0/ps/1703464/910/607/m1/fpnw/wm0/find-bag-local-shop-pin-store-shopping-logo-02-.jpg?1611079644&s=03d770b122e1989fa2f775ff550d155c&fmt=webp"},
//   {"name": "Lotto Face Mask", "price": 2, "image": "https://images.pexels.com/photos/6461515/pexels-photo-6461515.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 8, "shopId": 10, "brand": "Lotto", "logo": "https://seeklogo.com/images/L/Lotto-logo-18CDC5D50B-seeklogo.com.png"},
//   {"name": "Nikon D6", "price": 6499, "image": "https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 11, "brand": "Nikon", "logo": "https://image.shutterstock.com/image-photo/image-260nw-279017711.jpg"},
//   {"name": "Xiaomi Bluetooth Basic", "price": 29, "image": "https://images.pexels.com/photos/7156886/pexels-photo-7156886.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 10, "shopId": 12, "brand": "Xiaomi", "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Xiaomi_logo.svg/200px-Xiaomi_logo.svg.png"},
//   {"name": "Cadburry Bubbles", "price": 2.5, "image": "https://images.pexels.com/photos/7538069/pexels-photo-7538069.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500", "discount": 0, "shopId": 13, "brand": "CadBurry", "logo": "https://www.cadbury.co.uk/~/media/cadburydev/uk/images/common/logo.png"}
// ];
//
List<String> productName = <String>[
  "Rolex Yacht Master",
  "Samsung Galaxy Note 5",
  "One Plus 3",
  "One Plus 6t",
  "Nike Air 3",
  "Adidas Racer TR21",
];

List<Map<String, dynamic>> wishList = [];

List<dynamic> cartList = [];

List<String> cartIndexId = [];

List<Map<String, dynamic>> shops = [
  {"id": 1, "brand": "Razer", "logo": "https://assets2.razerzone.com/images/pnx.assets/09a0c71116e39ef8c882159300d66e29/quad_damage-th.jpg", "rating": 4.8},
  {"id": 2, "brand": "BeatsByDre", "logo": "https://cdn.mos.cms.futurecdn.net/kwyUDPNptGShKsQ7tNMhcn-970-80.jpg.webp", "rating": 4.5},
  {"id": 3, "brand": "Samsung", "logo": "https://www.nicepng.com/png/full/386-3864555_samsung-logo-black-samsung-icon-black-and-white.png", "rating": 3.9},
  {"id": 4, "brand": "Apple", "logo": "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png?Monday,%2025-Oct-2021%2000:55:31%20GMT", "rating": 4.3},
  {"id": 5, "brand": "Veloce", "logo": "http://velocebike.com/bangladesh/wp-content/uploads/sites/8/2020/10/Veloce-Logo_Text_Veloce-1-1-1.png", "rating": 3.6},
  {"id": 6, "brand": "Adidas", "logo": "https://1757140519.rsc.cdn77.org/blog/wp-content/uploads/2020/03/the-5th-logo.png", "rating": 4.5},
  {"id": 7, "brand": "Jackson", "logo": "https://seeklogo.com/images/J/Jackson_Guitars-logo-AB2975A0FD-seeklogo.com.png", "rating": 1.2},
  {"id": 8, "brand": "Besus", "logo": "https://seeklogo.com/images/J/Jackson_Guitars-logo-AB2975A0FD-seeklogo.com.png", "rating": 2.5},
  {"id": 9, "brand": "Local Store", "logo": "https://images.creativemarket.com/0.1.0/ps/1703464/910/607/m1/fpnw/wm0/find-bag-local-shop-pin-store-shopping-logo-02-.jpg?1611079644&s=03d770b122e1989fa2f775ff550d155c&fmt=webp", "rating": 3.3},
  {"id": 10, "brand": "Lotto", "logo": "https://seeklogo.com/images/L/Lotto-logo-18CDC5D50B-seeklogo.com.png", "rating": 1.9},
  {"id": 11, "brand": "Nikon", "logo": "https://image.shutterstock.com/image-photo/image-260nw-279017711.jpg", "rating": 4.8},
  {"id": 12, "brand": "Xiaomi", "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Xiaomi_logo.svg/200px-Xiaomi_logo.svg.png", "rating": 2.1},
  {"id": 13, "brand": "CadBurry", "logo": "https://www.cadbury.co.uk/~/media/cadburydev/uk/images/common/logo.png", "rating": 5}
];

List<Map<String, dynamic>> followingShops = [

];
//
Map<String, dynamic> cart = {};

List<Map<String, dynamic>> positionList = [
  {"title": "taosifsadly@gmail.com", "name": "Taosif Sadly", "lat": 23.751131, "lon": 90.387167},
  {"title": "taosifsadlyts7@gmail.com", "name": "Taosif", "lat": 23.81, "lon": 90.3700},
  {"title": "taosifsadlyts6@gmail.com", "name": "Sadly", "lat": 23.82, "lon": 90.3771193},
  {"title": "tanjil@gmail.com", "name": "Tanjil", "lat": 23.83, "lon": 90.3771193},
  {"title": "monirujjaman@gmail.com", "name": "Sadly", "lat": 23.85, "lon": 90.39}
];
//
//
