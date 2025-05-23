import 'package:flutter/material.dart';
import 'dart:async';

import 'package:stock_landy/screens/prevision.dart';
import 'package:stock_landy/screens/achat/create.dart';
import 'package:stock_landy/screens/category/categories.dart';
import 'package:stock_landy/layout/appbar.dart';
import 'package:stock_landy/layout/drawer.dart';
import 'package:stock_landy/layout/bottom_navigation_bar.dart';
import 'package:stock_landy/screens/customer/customers.dart';
import 'package:stock_landy/screens/order/orders.dart';
import 'package:stock_landy/screens/product/products.dart';
import 'package:stock_landy/screens/supplier/suppliers.dart';
import 'package:stock_landy/screens/vente/create.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late List<bool> _visibleList;
  final int itemCount = 8;

  @override
  void initState() {
    super.initState();
    _visibleList = List.generate(itemCount, (index) => false);
    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < itemCount; i++) {
      Future.delayed(Duration(milliseconds: 150 * i), () {
        if (mounted) {
          setState(() => _visibleList[i] = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(title: 'Stock Landy'),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(itemCount, (index) {
          return _buildAnimatedCard(index);
        }),
      ),
    );
  }

  Widget _buildAnimatedCard(int index) {
    final data = [
      [Icons.inventory, 'Produits', true, const ShowProducts()],
      [Icons.category, 'Categories', false, const ShowCategories()],
      [Icons.person, 'Clients', false, const ShowCustomers()],
      [Icons.shopping_cart, 'Commandes', true, const ShowOrders()],
      [Icons.business_center, 'Fournisseurs', true, const ShowSuppliers()],
      [Icons.payment, 'Achats', false, const CreateBuy()],
      [Icons.attach_money, 'Ventes', false, const CreateSell()],
      [Icons.timeline, 'Previsions', true, const PrevisionScreen()],
    ];

    final icon = data[index][0] as IconData;
    final label = data[index][1] as String;
    final isGreen = data[index][2] as bool;
    final screen = data[index][3] as Widget;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _visibleList[index] ? 1.0 : 0.0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 500),
        scale: _visibleList[index] ? 1.0 : 0.8,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => screen));
          },
          child: Card(
            elevation: 8,
            color: isGreen ? Colors.green : Colors.brown,
            margin: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
