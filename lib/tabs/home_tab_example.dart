import 'package:Duet_Classified/helpers/current_user.dart';
import 'package:Duet_Classified/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTabExample extends StatelessWidget {
  Future<void> _load(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchFeaturedProducts(CurrentUser.location);
    await Provider.of<Products>(context, listen: false).fetchCategories('en');
    await Provider.of<Products>(context, listen: false).fetchCategories('en');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
