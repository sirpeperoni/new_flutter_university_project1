import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university/Theme/app_colors.dart';
import 'package:university/Theme/text_styles.dart';
import 'package:university/auth.dart';
import 'package:university/cart_model.dart';
import 'package:university/database_services.dart';
import 'package:university/resources/resources.dart';
import 'dart:developer';


class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final DatabaseSercvice _databaseService = DatabaseSercvice();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: 
        StreamBuilder(
          stream: _databaseService.getProducts(),
          builder: (context, snapshot) {
            List products = snapshot.data?.docs ?? [];
            List<Product> products0 = [];
            for(int i = 0; i < products.length; i++){
              Product product = products[i].data();
              products0.add(product);
            }
            return CartItem(products: products0,);
          }
        )
    );
  }
}

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.products,
  });
  final List<Product> products;
  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var query = "";

  final DatabaseSercvice _databaseService = DatabaseSercvice();
  final _searchController = TextEditingController();
      void searchCartProducts(){
        query = _searchController.text;
        log(query);
        setState(() {});
      }    
      @override
      void initState(){
        super.initState();
        _searchController.addListener(searchCartProducts);
      }        
  

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    return Consumer<CartModel>(
      builder: (context, value, child){
        value.setProducts(widget.products);
        var filteredCart = value.cartItems.where((Product product){
                  return product.title.toLowerCase().contains(query.toLowerCase()) ? true : false;}
                ).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            const HeaderWithBackButton(),
            const SizedBox(height: 15,),
            const Row(
              children: [
                SizedBox(width: 40,),
                SizedBox(
                            width: 280,
                            child: Text("Please Double Check Your Order! ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                labelText: "Search My Order",
                filled: true,
                fillColor: Colors.white.withAlpha(235),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0)
              ),
              ),
            ),
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text("My Order", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: query.isEmpty ? value.cartItems.length : filteredCart.length,
                itemBuilder: (context, index)
                {
                  return Column(
                    children: [
                      Container(
                        width: 300,
                        height: 150,
                        decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                        ),
                        ]
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Image.network(
                                filteredCart[index].imageNameCart,
                                height: 150,
                                fit: BoxFit.fill,
                                )
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 29,),
                                    SizedBox(width:100, child: Text(filteredCart[index].title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),)),
                                    const SizedBox(height: 5,),
                                    SizedBox(width: 100, child: Text("${filteredCart[index].cost * value.cartItemsCounts[index]} RUB")),
                                    Row(
                                    children: [
                                    const SizedBox(width: 70,),
                                    SizedBox(
                                      width: 20,
                                      child: RawMaterialButton(
                                        onPressed: () {value.decrement(index);},
                                        padding: EdgeInsets.zero,
                                        fillColor: AppColors.mainOrange,
                                        shape: const CircleBorder(),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(value.cartItemsCounts[index].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                    const SizedBox(width: 10,),
                                    SizedBox(
                                      width: 20,
                                      child: RawMaterialButton(
                                        onPressed: () {value.increment(index);},
                                        fillColor: AppColors.mainOrange,
                                        shape: const CircleBorder(),
                                        child: const Icon(
                                          Icons.add,
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                                  ],
                                ),
                              ),
                              
                            ],
                            
                        ),
                      ),
                      const SizedBox(height: 20,)
                      
                    ],
                  );
                })
          ),
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.only(left: 20, top: 25, right: 20, bottom: 25),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 38,
                            offset: const Offset(0, 2),
                        ),
                  ]
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          const Text("Total", style: TextStyle(color: AppColors.mainLightGrey,),),
                          Text("${value.calculateTotal()} RUB")
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black.withOpacity(0.2)),
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            color:  AppColors.mainOrange,
                          ),
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            onPressed: () async {
                              for(int i = 0; i < value.cartItems.length; i++){
                                log(i.toString());
                                OrderHistoryItem item = OrderHistoryItem(
                                  amount: value.cartItemsCounts[i],
                                  name: value.cartItems[i].title, 
                                  imageUrl: value.cartItems[i].imageNameCart, 
                                  price: value.cartItems[i].cost, 
                                  total: (value.cartItemsCounts[i] * value.cartItems[i].cost),
                                  userId: user!.uid
                                );
                                await _databaseService.addOrder(item);
                              }
                              Provider.of<CartModel>(context, listen: false).removeItemsFromCart();
                            },
                            child: const Text(
                              "Checkout",
                              style: TextStyle(fontSize: 14, color: AppColors.mainWhite
                            ),
                          ),
                                            ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
      }
    );
  }
}










class HeaderWithBackButton extends StatelessWidget {
  const HeaderWithBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButtonHeader(),
              SizedBox(width: 35),
              Header(),
            ],
          );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Image(image: AssetImage(Images.ellipse1)),
        SizedBox(width: 10,),
        Text(
          "bakery and patisserie", 
          style: TextStyles.headerText,
        )
      ],
    );
  }
}

class BackButtonHeader extends StatelessWidget {
  const BackButtonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 25),
      onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
      icon: Image.network("https://firebasestorage.googleapis.com/v0/b/universityflutterproject.appspot.com/o/Back%20Button.png?alt=media&token=b7bde95c-f9be-43f0-8259-91d8429d8a3b"),
    );
  }
}