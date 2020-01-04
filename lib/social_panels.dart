import 'package:flutter/material.dart';
import 'package:food_hunt/panel_widgets.dart';

import 'base_page.dart';

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
          Controls.of(context).changePanel(SocialListPanel(MediaQuery.of(context).size.height));
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
    widgets.addAll(_friendsNearYouList());
    widgets.add(SizedBox(height: 10,));
    widgets.add(_buttons());
    widgets.add(SizedBox(height: 10,));
    widgets.addAll(_leaderboardList());
    widgets.add(SizedBox(height: 20,));
    return widgets;
  }

  List<Widget> _friendsNearYouList() {
    List<Widget> widgets  = [];

    return widgets;
  }

  Widget _buttons() {
    return Row(
      children: <Widget>[
        
      ],
    );
  }

  List<Widget> _leaderboardList() {
    List<Widget> widgets  = [];

    return widgets;
  }

}