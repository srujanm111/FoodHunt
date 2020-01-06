import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt/data_widgets.dart';
import 'package:food_hunt/game_manager.dart';
import 'package:food_hunt/main_panel.dart';
import 'package:food_hunt/panel_widgets.dart';

import 'base_page.dart';
import 'constants.dart';
import 'data_classes.dart';

class SocialListPanel extends Panel {

  static final double scale = 0.7;

  SocialListPanel(double screenHeight) : super(panelHeightOpen: screenHeight * scale, panelHeightClosed: 193);

  @override
  State createState() => _SocialListPanelState();

}

class _SocialListPanelState extends State<SocialListPanel> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PanelTab(),
        PanelHeader(title: "Social", onClose: () {
          Controls.of(context).changePanel(MainPanel(MediaQuery.of(context).size.height));
        },),
        Container(
          height: MediaQuery.of(context).size.height * SocialListPanel.scale - 80,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: _contents(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _contents() {
    List<Widget> widgets  = [];
    widgets.add(SizedBox(height: 15,));
    widgets.addAll(_friendsNearYouList());
    widgets.add(SizedBox(height: 10,));
    widgets.add(_buttons());
    widgets.add(SizedBox(height: 20,));
    widgets.addAll(_leaderBoardList());
    widgets.add(SizedBox(height: 20,));
    return widgets;
  }

  List<Widget> _friendsNearYouList() {
    List<Widget> widgets  = [];
    widgets.add(ListHeader(title: "Friends Near You",));
    for (Friend friend in GameManager.instance.storedGameData.friends) {
      widgets.add(FriendItem(friend: friend,));
      widgets.add(ListDivider(edgePadding: 15,));
    }
    widgets.removeLast();
    return widgets;
  }

  Widget _buttons() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: _friendButton("Add Friend", "Scan QR Code", () {}),
            ),
            SizedBox(width: 20,),
            Flexible(
              flex: 1,
              child: _friendButton("Allow Friend", "Show QR Code", () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _friendButton(String mainText, String subText, Function onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(mainText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: white),),
              Text(subText, style: TextStyle(fontSize: 14, color: white),),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _leaderBoardList() {
    List<Widget> widgets  = [];
    widgets.add(ListHeader(title: "Leader Board",));
    // create a sorted list of all people in contacts and create friend widgets
    return widgets;
  }

}