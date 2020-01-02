import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt/custom_sheet_widgets.dart';

import 'constants.dart';

class RecipesPage extends StatefulWidget {

  @override
  State createState() => _RecipesPageState();

}

class _RecipesPageState extends State<RecipesPage> {

  @override
  Widget build(BuildContext context) {
    return SheetHeader(title: "Recipes", onClose: () {}, subTitle: sub(), actionButton: button(),);
  }

  Widget sub() {
    return Row(
      children: <Widget>[
        Text("Restaurant •"),
        Container(
          height: 19,
          width: 19,
          child: Image(image: AssetImage('assets/icons/icons8-cent.png'), color: green,)
        ),
        Text("20"),
      ],
    );
  }

  Widget button() {
    return CupertinoButton(
      color: primary,

      child: Text("Start Hunt"),
      onPressed: () {},
    );
  }

}