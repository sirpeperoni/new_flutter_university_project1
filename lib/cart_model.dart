

import 'package:flutter/cupertino.dart';
import 'package:university/resources/resources.dart';



class Product{
  final int id;
  final String title;
  final String description;
  final int cost;
  final String imageName;
  final int categoryId;
  final String imageNameCart;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.imageName,
    required this.categoryId,
    required this.imageNameCart
  });

  Product.fromJson(Map<String, Object?> json) 
  : this(
    title: json['title']! as String, 
    id: json['id']! as int,
    description: json['description']! as String,
    cost: json['cost']! as int,
    imageName: json['imageName']! as String,
    categoryId: json['categoryId']! as int,
    imageNameCart:json['imageNameCart']! as String
  );

  Product copyWith({
    int? id,
    String? title,
    String? description,
    int? cost,
    String? imageName,
    int? categoryId,
    String? imageNameCart,
  }){
    return Product(id: id ?? this.id, 
    title: title ?? this.title, 
    description: description ?? this.description, 
    cost: cost ?? this.cost, 
    imageName: imageName ?? this.imageName, 
    categoryId: categoryId ?? this.categoryId, 
    imageNameCart: imageNameCart ?? this.imageNameCart
  );
  }

  Map<String, Object?> toJson(){
    return {
      "id":id,
      "title":title,
      "description":description,
      "cost":cost,
      "imageName":imageName,
      "categoryId":categoryId,
      "imageNameCart":imageNameCart
    };
  }
}

class OrderHistoryItem{
  final int amount;
  final String name;
  final String imageUrl;
  final int price;
  final int total;
  final String userId;
  OrderHistoryItem({
    required this.amount,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.total,
    required this.userId
  });

  OrderHistoryItem.fromJson(Map<String, Object?> json) 
  : this(
    amount: json['amount']! as int, 
    name: json['name']! as String,
    imageUrl: json['imageUrl']! as String,
    price: json['price']! as int,
    total: json['total']! as int,
    userId: json['userId']! as String 
  );

  OrderHistoryItem copyWith({
    int? amount,
    String? name,
    String? imageUrl,
    int? price,
    int? total,
    String? userId
  }){
    return OrderHistoryItem(amount: amount ?? this.amount, 
    name: name ?? this.name, 
    imageUrl: imageUrl ?? this.imageUrl, 
    price: price ?? this.price, 
    total: total ?? this.total, 
    userId: userId ?? this.userId
  );
  }

  Map<String, Object?> toJson(){
    return {
      "amount":amount,
      "name":name,
      "imageUrl":imageUrl,
      "price":price,
      "total":total,
      "userId":userId
    };
  }
}

class Users{
  final String name;
  final String email;
  final String imageUrl;
  final String number;
  final String rights;
  final String userId;

  Users({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.number,
    required this.rights,
    required this.userId
  });

  Users.fromJson(Map<String, Object?> json) 
  : this(
    name: json['name']! as String, 
    email: json['email']! as String,
    imageUrl: json['imageUrl']! as String,
    number: json['number']! as String,
    rights: json['rights']! as String,
    userId: json['userId']! as String 
  );

  Users copyWith({
    String? name,
    String? email,
    String? imageUrl,
    String? number,
    String? rights,
    String? userId
  }){
    return Users(name: name ?? this.name, 
    email: email ?? this.email, 
    imageUrl: imageUrl ?? this.imageUrl, 
    number: number ?? this.number, 
    rights: rights ?? this.rights,
    userId: userId ?? this.userId,  
  );
  }

  Map<String, Object?> toJson(){
    return {
      "name":name,
      "email":email,
      "imageUrl":imageUrl,
      "number":number,
      "rights":rights,
      "userId":userId,
    };
  }
}


class CartModel extends ChangeNotifier{
  var _products = [
    Product(id: 1, title: "Chocolate Cupcake", description: "A Chocolate cupcake is a savory delight that combines a crumbly, buttery crust with a creamy and cheesy filling. These mini treats offer a harmonious blend of sweet and savory flavors, making them a versatile and mouthwatering snack or appetizer. Enjoy them warm for a delightful fusion of textures and flavors.", cost: 224, imageName: Images.rectangle25, categoryId: 1, imageNameCart: Images.cart2),
    Product(id: 2, title: "Strawberry CupCake", description: "A strawberry cupcake is a savory delight that combines a crumbly, buttery crust with a creamy and cheesy filling. These mini treats offer a harmonious blend of sweet and savory flavors, making them a versatile and mouthwatering snack or appetizer. Enjoy them warm for a delightful fusion of textures and flavors.", cost: 209, imageName: Images.rectangle19, categoryId: 2, imageNameCart: Images.cart3),
    Product(id: 3, title: "Cheese CupCake", description: "A cheese cupcake is a savory delight that combines a crumbly, buttery crust with a creamy and cheesy filling. These mini treats offer a harmonious blend of sweet and savory flavors, making them a versatile and mouthwatering snack or appetizer. Enjoy them warm for a delightful fusion of textures and flavors.", cost: 190, imageName: Images.rectangle17, categoryId: 1, imageNameCart: Images.cart),
    Product(id: 4, title: "Fruity Cupcake", description: "A Fruity cupcake is a savory delight that combines a crumbly, buttery crust with a creamy and cheesy filling. These mini treats offer a harmonious blend of sweet and savory flavors, making them a versatile and mouthwatering snack or appetizer. Enjoy them warm for a delightful fusion of textures and flavors.", cost: 219, imageName: Images.rectangle21, categoryId: 3, imageNameCart: Images.cart),
    Product(id: 5, title: "Mix Chocolate CupCake", description: "A Mix Chocolate cupcake is a savory delight that combines a crumbly, buttery crust with a creamy and cheesy filling. These mini treats offer a harmonious blend of sweet and savory flavors, making them a versatile and mouthwatering snack or appetizer. Enjoy them warm for a delightful fusion of textures and flavors.", cost: 170, imageName: Images.rectangle23, categoryId: 4, imageNameCart: Images.cart),
    
  ];

  void setProducts(List<Product> products){
    _products = products;
  }


  final List _cartItems = <Product>[];
  final List _cartItemsCounts = [];
  get cartItems => _cartItems;
  get cartItemsCounts => _cartItemsCounts;



  get shopItems => _products;

  void addItemToCart(int index, int count) {
    _cartItems.add(_products[index - 1]);
    _cartItemsCounts.add(count);
    notifyListeners();
  }


  void increment(int index){
    _cartItemsCounts[index]++;
    notifyListeners();
  }
  void decrement(int index){
    if(_cartItemsCounts[index] != 1){
      _cartItemsCounts[index]--;
    } else{
      _cartItems.removeAt(index);
    _cartItemsCounts.removeAt(index);
    }
    notifyListeners();
  }

  void removeItemToCart(int index, int count) {
    _cartItems.removeAt(index);
    _cartItemsCounts.removeAt(index);
    notifyListeners();
  }

  void removeItemsFromCart(){
    int count = _cartItems.length;
    for(int i = 0; i < count; i++){
      _cartItems.removeAt(0);
      _cartItemsCounts.removeAt(0);
    }
    notifyListeners();
  }

  String calculateTotal(){
    int totalPrice = 0;
    for(int i = 0; i < _cartItems.length; i++){
      int cost = _cartItems[i].cost;
      int count = _cartItemsCounts[i];
      totalPrice += cost * count;
    }
    return totalPrice.toString();
  }
}