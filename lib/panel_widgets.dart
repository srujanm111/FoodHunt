import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class PanelHeader extends StatelessWidget {

  final String title;
  final Widget subTitle;
  final Widget actionButton;
  final Function onClose;

  PanelHeader({
    @required this.title,
    @required this.onClose,
    this.subTitle,
    this.actionButton
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _contents(context),
    );
  }

  List<Widget> _contents(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _leading(context),
            _closeButton(),
          ],
        ),
      ),
    );
    if (actionButton != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(20),
          child: actionButton,
        ),
      );
    } else {
      widgets.add(SizedBox(height: 10,));
    }
    widgets.add(ListDivider());
    return widgets;
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
    return GestureDetector(
      onTap: onClose,
      child: Image(
        image: AssetImage('assets/icons/close.png'),
        height: 30,
        width: 30,
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
        ListDivider(edgePadding: 10,)
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

class ListDivider extends StatelessWidget {

  final double edgePadding;

  ListDivider({
    this.edgePadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edgePadding),
      child: Container(
        height: 1,
        color: border,
      ),
    );
  }

}

class PanelTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(12.0))
            ),
          ),
        ],
      ),
    );
  }

}