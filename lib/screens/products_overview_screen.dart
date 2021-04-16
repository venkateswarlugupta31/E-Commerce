import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';
import 'package:shop/providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavoritesData = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSEtProducts(); Doesn't work

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSEtProducts();
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // This will run after the widget has been fully initialized to say but before build ran for the first time.
    // It will, however, unlike initState, run more often multiple times and not just when this get created
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSEtProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MyShop",
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavoritesData = true;
                } else {
                  _showOnlyFavoritesData = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text("Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("All"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, childOutside) => Badge(
              child: childOutside,
              value: cart.itemCount.toString(),
              color: null,
            ),
            child: IconButton(
              // childOutSide, so that each time it won't be built
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () =>
                  {Navigator.of(context).pushNamed(CartScreen.routeName)},
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavoritesData),
    );
  }
}
