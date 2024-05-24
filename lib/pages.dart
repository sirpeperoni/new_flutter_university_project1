import 'package:flutter/material.dart';
import 'package:university/Theme/app_colors.dart';
import 'package:university/cart.dart';
import 'package:university/home_page.dart';
import 'package:university/profile.dart';


class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {

  


  int _selectedTab = 0;
  bool _isVisible = true;

  void onSelectTab(int index){
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
      if(_selectedTab == 1){
        _isVisible = false;
      }else{
        _isVisible = true;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    const items = [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ""
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ""
            ) 
          ];


    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: [
          const HomePage(),
          const CartWidget(),
          ProfileWidget(),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: _isVisible,
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          selectedItemColor: AppColors.mainOrange,
          unselectedItemColor: AppColors.mainLightGrey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: items,
          onTap: onSelectTab,
        ),
      ),
    );
  }
}


