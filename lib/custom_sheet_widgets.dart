import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class SheetHeader extends StatelessWidget {

  final String title;
  final Widget subTitle;
  final Widget actionButton;
  final Function onClose;

  SheetHeader({
    @required this.title,
    @required this.onClose,
    this.subTitle,
    this.actionButton
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _leading(context),
              _closeButton(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: actionButton,
        ),
        Container(
          height: 1,
          color: border,
        ),
      ],
    );
  }

  Widget _leading(BuildContext context) {
    if (subTitle == null) {
      return Text(title, style: Theme.of(context).textTheme.title,);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.title,),
          subTitle,
        ],
      );
    }
  }

  Widget _closeButton() {
    return Container(
      height: 30,
      width: 30,
      child: Center(
        child: Image(image: AssetImage('assets/icons/close.png')),
      ),
    );
  }

}

class ListHeader extends StatelessWidget {

  final String title;
  final Widget trailing;

  ListHeader({
    @required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _rowWidgets(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 1,
            color: border,
          ),
        ),
      ],
    );
  }

  List<Widget> _rowWidgets(BuildContext context) {
    if (trailing != null) {
      return [Text(title, style: Theme.of(context).textTheme.subtitle,), trailing];
    } else {
      return [Text(title, style: Theme.of(context).textTheme.subtitle,)];
    }
  }

}

class ListActionButton extends StatelessWidget {

  final String title;
  final Function onPress;

  ListActionButton({
    @required this.title,
    @required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Text(title, style: Theme.of(context).textTheme.display1,),
    );
  }

}
