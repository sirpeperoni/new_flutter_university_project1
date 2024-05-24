import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:university/Theme/app_colors.dart';
import 'package:university/Theme/text_styles.dart';
import 'package:university/cart_model.dart';
import 'package:university/resources/resources.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product}) : _product = product;
  final Product _product;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _itemCount = 1;
  dynamic cost;
  int total = 0;
  int constCost = 0;
  decrement(){
    if(_itemCount != 1){
      setState(() {
        _itemCount--;
        total = cost * _itemCount;
      });
    }
  }
  increment(){
      setState(() {
        _itemCount++;
        total = cost * _itemCount;
      });
  }
  @override
  void initState(){
    super.initState();
    cost = widget._product.cost;
    total = cost;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30,),
          const HeaderWithBackButton(),
          const SizedBox(height: 30,),
          Center(child: ProductDetailsImage(widget: widget)),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Text(
              widget._product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 45,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: RawMaterialButton(
                  onPressed: () {decrement();},
                  elevation: 2.0,
                  fillColor: AppColors.mainOrange,
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.remove,
                    size: 15.0,
                  ),
                ),
              ),
              Text(_itemCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              RawMaterialButton(
                onPressed: () {increment();},
                elevation: 2.0,
                fillColor: AppColors.mainOrange,
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  size: 15.0,
                ),
              ),
              const SizedBox(width: 30,),
              Text("$total RUB", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),)
            ],
          ),
          const SizedBox(height: 30,),
          
          Consumer<CartModel>(builder: (context, value, child) => 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                Expanded(child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: SizedBox(
                        height: 60,
                        child: MaterialButton(
                          color: AppColors.mainOrange,
                          onPressed: () {                             
                              Provider.of<CartModel>(context, listen: false).addItemToCart(widget.product.id, _itemCount);
                              Navigator.of(context).pushReplacementNamed('/cart');
                          },
                          child: const Text(
                            "Add to Cart",
                            style: TextStyles.buttonText,
                          ),
                        ),
                      ),
                    ),
                    ),
              ],
            ),
          ),),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: SizedBox(
              width: 300,
              child: Text(
                widget._product.description
              ),
            ),
          )
        ],)
    );
  }
}

class ProductDetailsImage extends StatelessWidget {
  const ProductDetailsImage({
    super.key,
    required this.widget,
  });

  final ProductDetails widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 309,
      height: 240,
      decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black.withOpacity(0.2)),
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ]
    ),
          clipBehavior: Clip.hardEdge,
          child: Image.network(widget._product.imageName, fit: BoxFit.fill));
  }
}








class HeaderWithBackButton extends StatelessWidget {
  const HeaderWithBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const BackButtonHeader(),
              const SizedBox(width: 60),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), 
                  border: Border.all(width: 1, color: AppColors.mainOrange), 
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: const Text("Product Details", style: TextStyle(color: AppColors.mainOrange)),
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
      icon: Image.asset(Images.backButton),
    );
  }
}