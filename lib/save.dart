
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:university/Theme/app_colors.dart';
import 'package:university/Theme/text_styles.dart';
import 'package:university/cart_model.dart';
import 'package:university/resources/resources.dart';


class Category{
  final int categoryId;
  final String category;

  Category({
    required this.categoryId,
    required this.category
  }); 
}









class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Advert(),
          Expanded(flex: 5,child: SearchWidgetAndListView(),),
        ]
          ),
    );
  }
}

class Advert extends StatelessWidget {
  const Advert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, top: 35, right: 20),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const Image(
                image: AssetImage(
                  Images.rectangle10,
                  ),
                  fit: BoxFit.fill,
              )
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const Image(
              image: AssetImage(Images.roundedRectangle),
            )
          ),
          const Positioned(
            left: 20,
            bottom: 60,
            child: Text(
              "Delightful Baked",
              style: TextStyles.advertiseText,
            )
          ),
          const Positioned(
            left: 20,
            bottom: 20,
            child: Text(
              "Creations",
              style: TextStyles.advertiseText,
            )
          ),
        ],
      ),
    );
  }
}



class SearchWidgetAndListView extends StatefulWidget {
  const SearchWidgetAndListView({super.key});

  @override
  State<SearchWidgetAndListView> createState() => _SearchWidgetAndListViewState();
}

class _SearchWidgetAndListViewState extends State<SearchWidgetAndListView> {
  final model = CartModel();
  
  final _categories = [
      Category(categoryId: 0, category: "All"),
      Category(categoryId: 1, category: "Cupcake"),
      Category(categoryId: 2, category: "Desert"),
      Category(categoryId: 3, category: "Bread"),
      Category(categoryId: 4, category: "Drinks"),
  ];
  
  

  int _selectedIndex = 0;
  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  var _filteredProducts = <Product>[];

  final _searchController = TextEditingController();


  void _searchProducts() {
    final query = _searchController.text;
    log(query);
    if(query.isNotEmpty){
      if(_selectedIndex == 0){
        _filteredProducts = model.shopItems.where((Product product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      }else{
        _filteredProducts = _filteredProducts.where((Product product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      }
    } else {
      _filteredProducts = model.shopItems;
      _selectedIndex = 0;
    }
    setState(() {});
  }

  void _categoryProducts(){
    final query = _selectedIndex;
    if(query != 0){
      _filteredProducts = model.shopItems.where((Product product) {
        return product.categoryId == query;
      }).toList();
    }else{
      _filteredProducts = model.shopItems;
    }
  }

  @override
    void initState() {

    super.initState();
    _filteredProducts = model.shopItems;
    _searchController.addListener(_searchProducts);
  }
   @override
     Widget build(BuildContext context) {
    return 
        Column(
          children:[
          Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: "Search product",
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0)
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: ColoredBox(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Categories", 
                    style: TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Scrollbar(
                  child: SizedBox(
                    height: 52,
                    child: ListView.builder(
                      itemCount: _categories.length, 
                      itemExtent: 120,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        var category = _categories[index];
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: DecoratedBox(
                          decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black.withOpacity(0.2)),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            color: _selectedIndex == index  ? AppColors.mainOrange : Colors.white,
                            child: InkWell(
                              onTap: () => {
                                _onSelected(index),
                                _categoryProducts()
                              },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(category.category),
                                    ],
                                  ),
                                     )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    ),
                  ],
                ),
              ),
            ),
            GridViewProducts(filteredProducts: _filteredProducts),
          ]
        );
  }
}

class GridViewProducts extends StatelessWidget {
  const GridViewProducts({
    super.key,
    required List<Product> filteredProducts,
  }) : _filteredProducts = filteredProducts;

  final List<Product> _filteredProducts;
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
      padding: const EdgeInsets.only(left: 20,),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: _filteredProducts.length,
      itemBuilder: (BuildContext context, int index) {
        final product = _filteredProducts[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Stack(
            children: [
              GridViewProductsItemDecoration(product: product),
              GridViewProductsItemButton(product: product,),
            ],
          ),
        );
      }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                ),
    );
  }
}

class GridViewProductsItemDecoration extends StatelessWidget {
  const GridViewProductsItemDecoration({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
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
      clipBehavior: Clip.hardEdge,
      child: GridViewProductsItem(product: product),
    );
  }
}

class GridViewProductsItemButton extends StatefulWidget {
  const GridViewProductsItemButton({
    super.key,
    required Product product
  }) : _product = product;
  final Product _product;

  @override
  State<GridViewProductsItemButton> createState() => _GridViewProductsItemButtonState();
}

class _GridViewProductsItemButtonState extends State<GridViewProductsItemButton> {
  void _onProductTap(Product product){
    final product0 = product;
    Navigator.of(context).pushNamed('/home/product_details', arguments: product0,);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => {
            _onProductTap(widget._product)
          },
        ),
      ),
    );
  }
}

class GridViewProductsItem extends StatelessWidget {
  const GridViewProductsItem({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Image(image: AssetImage(product.imageName), fit: BoxFit.fill,
          )),
        const SizedBox(width: 15, ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            product.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            "${product.cost} RUB",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}


























