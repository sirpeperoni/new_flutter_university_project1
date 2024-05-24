import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:university/auth.dart';
import 'package:university/cart_model.dart';

const String PRODUCTS_COLLECTION_REF = "product";
const String ORDER_HISTORY_COLLECTION_REF = "order_history";
const String ORDER_USERS_COLLECTION_REF = "users";

class DatabaseSercvice{
  final _firestore = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;
  late final CollectionReference _productsRef;
  late final CollectionReference _orderHistoryRef;
  late final CollectionReference _usersRef;
  DatabaseSercvice(){
    _productsRef = _firestore.collection(PRODUCTS_COLLECTION_REF).withConverter<Product>(
      fromFirestore: (snapshots, _) => Product.fromJson(
            snapshots.data()!,
          ), 
      toFirestore: (snapshots, _) => snapshots.toJson());
      
    _orderHistoryRef = _firestore.collection(ORDER_HISTORY_COLLECTION_REF).withConverter<OrderHistoryItem>(
      fromFirestore: (snapshots, _) => OrderHistoryItem.fromJson(
            snapshots.data()!,
          ), 
      toFirestore: (snapshots, _) => snapshots.toJson()) as CollectionReference<OrderHistoryItem?>;

    _usersRef = _firestore.collection(ORDER_USERS_COLLECTION_REF).withConverter<Users>(
      fromFirestore: (snapshots, _) => Users.fromJson(
            snapshots.data()!,
          ), 
      toFirestore: (snapshots, _) => snapshots.toJson()) as CollectionReference<Users?>;
  }

  Stream<QuerySnapshot> getProducts(){
    return _productsRef.snapshots();
  }

  Stream<QuerySnapshot> getOrders(){
    return _orderHistoryRef.where("userId",isEqualTo: user?.uid).snapshots();
  }

  Stream<QuerySnapshot> getUser(){
    return _usersRef.where("userId",isEqualTo: user?.uid).snapshots();
  }

  //////////////// User
  void addUser(Users user) async {
    _usersRef.add(user);
  }

  void updateUser(AsyncSnapshot<QuerySnapshot<Object?>> userId, Users profile) async {
    print(userId.data?.docs.first.id.characters.toString());
    await _usersRef.doc(userId.data?.docs.first.id.characters.toString()).update(profile.toJson());
  }
  ////////////////////


  void addProduct(Product product) async {
    _productsRef.add(product);
  }

  Future<void> addOrder(OrderHistoryItem orderItem) async {
    _orderHistoryRef.add(orderItem);
  }

  void updateOrder(String orderId, OrderHistoryItem orderItem) {
    _orderHistoryRef.doc("D0epojCnUyd0M0Rgi618").update(orderItem.toJson());
  }

  void deleteOrder(String orderId) {
    _orderHistoryRef.doc(orderId).delete();
  }
}