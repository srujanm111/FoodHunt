import 'package:flutter/material.dart';
import 'package:food_hunt/base_page.dart';

enum SlideDirection{
  UP,
  DOWN,
}

enum PanelState{
  OPEN,
  CLOSED
}

class SlidingUpPanel extends StatefulWidget {

  /// The Widget that slides into view. When the
  /// panel is collapsed and if [collapsed] is null,
  /// then top portion of this Widget will be displayed;
  /// otherwise, [collapsed] will be displayed overtop
  /// of this Widget.
  final Widget panel;

  /// The Widget that lies underneath the sliding panel.
  /// This Widget automatically sizes itself
  /// to fill the screen.
  final Widget body;

  /// The height of the sliding panel when fully collapsed.
  final double minHeight;

  /// The height of the sliding panel when fully open.
  final double maxHeight;

  /// If non-null, the corners of the sliding panel sheet are rounded by this [BorderRadiusGeometry].
  final BorderRadiusGeometry borderRadius;

  /// Set to false to not show a shadow under the panel.
  final bool showShadow;

  /// The color to fill the background of the sliding panel sheet.
  final Color color;

  /// Set to false to not to render the sheet the [panel] sits upon.
  /// This means that only the [body], [collapsed], and the [panel]
  /// Widgets will be rendered.
  /// Set this to false if you want to achieve a floating effect or
  /// want more customization over how the sliding panel
  /// looks like.
  final bool renderPanelSheet;

  /// If non-null, this can be used to control the state of the panel.
  final PanelController controller;

  /// If non-null, this callback
  /// is called as the panel slides around with the
  /// current position of the panel. The position is a double
  /// between 0.0 and 1.0 where 0.0 is fully collapsed and 1.0 is fully open.
  final void Function(double position) onPanelSlide;

  /// If non-null, this callback is called when the
  /// panel is fully opened
  final VoidCallback onPanelOpened;

  /// If non-null, this callback is called when the panel
  /// is fully collapsed.
  final VoidCallback onPanelClosed;

  /// Allows toggling of the draggability of the SlidingUpPanel.
  /// Set this to false to prevent the user from being able to drag
  /// the panel up and down. Defaults to true.
  final bool isDraggable;

  /// Either SlideDirection.UP or SlideDirection.DOWN. Indicates which way
  /// the panel should slide. Defaults to UP. If set to DOWN, the panel attaches
  /// itself to the top of the screen and is fully opened when the user swipes
  /// down on the panel.
  final SlideDirection slideDirection;

  /// The default state of the panel; either PanelState.OPEN or PanelState.CLOSED.
  /// This value defaults to PanelState.CLOSED which indicates that the panel is
  /// in the closed position and must be opened. PanelState.OPEN indicates that
  /// by default the Panel is open and must be swiped closed by the user.
  final PanelState defaultPanelState;

  SlidingUpPanel({
    Key key,
    @required this.panel,
    this.body,
    this.minHeight = 100.0,
    this.maxHeight = 500.0,
    this.borderRadius,
    this.showShadow = true,
    this.color = Colors.white,
    this.renderPanelSheet = true,
    this.controller,
    this.onPanelSlide,
    this.onPanelOpened,
    this.onPanelClosed,
    this.isDraggable = true,
    this.slideDirection = SlideDirection.UP,
    this.defaultPanelState = PanelState.CLOSED
  }) : super(key: key);

  @override
  _SlidingUpPanelState createState() => _SlidingUpPanelState();
}

class _SlidingUpPanelState extends State<SlidingUpPanel> with SingleTickerProviderStateMixin {

  AnimationController _ac;

  @override
  void initState(){
    super.initState();

    _ac = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: widget.defaultPanelState == PanelState.CLOSED ? 0.0 : 1.0 //set the default panel state (i.e. set initial value of _ac)
    )..addListener((){
      setState((){});

      if(widget.onPanelSlide != null) widget.onPanelSlide(_ac.value);

      if(widget.onPanelOpened != null && _ac.value == 1.0) widget.onPanelOpened();

      if(widget.onPanelClosed != null && _ac.value == 0.0) widget.onPanelClosed();
    });

    _ac.value = 0.2;

    widget.controller?._addListeners(
      _close,
      _open,
      _hide,
      _show,
      _setPanelPosition,
      _animatePanelToPosition,
      _getPanelPosition,
      _isPanelAnimating,
      _isPanelOpen,
      _isPanelClosed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.slideDirection == SlideDirection.UP ? Alignment.bottomCenter : Alignment.topCenter,
      children: <Widget>[


        //make the back widget take up the entire back side
        widget.body != null ? Positioned(
          top: 0.0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: widget.body,
          ),
        ) : Container(),


        //the backdrop to overlay on the body
        Container(),

        //the actual sliding part
        GestureDetector(
          onVerticalDragUpdate: widget.isDraggable ? _onDrag : null,
          onVerticalDragEnd: widget.isDraggable ? _onDragEnd : null,
          child: Container(
            height: _ac.value * (widget.maxHeight - widget.minHeight),
            decoration: widget.renderPanelSheet ? BoxDecoration(
              borderRadius: widget.borderRadius,
              boxShadow: widget.showShadow ? <BoxShadow>[
                BoxShadow(
                  blurRadius: 8.0,
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                )
              ] : null,
              color: widget.color,
            ) : null,
            child: Stack(
              children: <Widget>[

                //open panel
                Positioned(
                    top: widget.slideDirection == SlideDirection.UP ? 0.0 : null,
                    bottom: widget.slideDirection == SlideDirection.DOWN ? 0.0 : null,
                    width:  MediaQuery.of(context).size.width,
                    child: Container(
                      height: widget.maxHeight,
                      child: widget.panel,
                    )
                ),

                // collapsed panel
                Positioned(
                  top: widget.slideDirection == SlideDirection.UP ? 0.0 : null,
                  bottom: widget.slideDirection == SlideDirection.DOWN ? 0.0 : null,
                  width:  MediaQuery.of(context).size.width,
                  child: Container(
                    height: widget.minHeight,
                    child: Opacity(
                      opacity: 1.0 - _ac.value,

                      // if the panel is open ignore pointers (touch events) on the collapsed
                      // child so that way touch events go through to whatever is underneath
                      child: IgnorePointer(
                        ignoring: _isPanelOpen(),
                        child: Container(),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),

      ],
    );
  }

  @override
  void dispose(){
    _ac.dispose();
    super.dispose();
  }

  void _onDrag(DragUpdateDetails details){
    if(widget.slideDirection == SlideDirection.UP)
      _ac.value -= details.primaryDelta / (widget.maxHeight - widget.minHeight);
    else
      _ac.value += details.primaryDelta / (widget.maxHeight - widget.minHeight);
  }

  void _onDragEnd(DragEndDetails details){
    double minFlingVelocity = 365.0;

    //let the current animation finish before starting a new one
    if(_ac.isAnimating) return;

    //check if the velocity is sufficient to constitute fling
    if(details.velocity.pixelsPerSecond.dy.abs() >= minFlingVelocity){
      double visualVelocity = - details.velocity.pixelsPerSecond.dy / (widget.maxHeight - widget.minHeight);

      if(widget.slideDirection == SlideDirection.DOWN)
        visualVelocity = -visualVelocity;

      _ac.animateTo(visualVelocity < 0 ? 0.2 : 1);

      return;
    }

    // check if the controller is already halfway there
    if(_ac.value > 0.6)
      _open();
    else
      _close();
  }



  //---------------------------------
  //PanelController related functions
  //---------------------------------

  //close the panel
  void _close(){
    //_ac.fling(velocity: -1.0);
    _ac.animateTo(0.2,);
  }

  //open the panel
  void _open(){
    _ac.fling(velocity: 1.0);
  }

  //hide the panel (completely offscreen)
  void _hide(){
    _ac.fling(velocity: -1.0);
  }

  //show the panel (in collapsed mode)
  void _show(){
    _ac.fling(velocity: -1.0);
  }

  //set the panel position to value - must
  //be between 0.0 and 1.0
  void _setPanelPosition(double value){
    assert(0.0 <= value && value <= 1.0);
    _ac.value = value;
  }

  //set the panel position to value - must
  //be between 0.0 and 1.0
  void _animatePanelToPosition(double value){
    assert(0.0 <= value && value <= 1.0);
    _ac.animateTo(value);
  }

  //get the current panel position
  //returns the % offset from collapsed state
  //as a decimal between 0.0 and 1.0
  double _getPanelPosition(){
    return _ac.value;
  }

  //returns whether or not
  //the panel is still animating
  bool _isPanelAnimating(){
    return _ac.isAnimating;
  }

  //returns whether or not the
  //panel is open
  bool _isPanelOpen(){
    return _ac.value == 1.0;
  }

  //returns whether or not the
  //panel is closed
  bool _isPanelClosed(){
    return _ac.value == 0.0;
  }

}








class PanelController{
  VoidCallback _closeListener;
  VoidCallback _openListener;
  VoidCallback _hideListener;
  VoidCallback _showListener;
  Function(double value) _setPanelPositionListener;
  Function(double value) _setAnimatePanelToPositionListener;
  double Function() _getPanelPositionListener;
  bool Function() _isPanelAnimatingListener;
  bool Function() _isPanelOpenListener;
  bool Function() _isPanelClosedListener;

  void _addListeners(
      VoidCallback closeListener,
      VoidCallback openListener,
      VoidCallback hideListener,
      VoidCallback showListener,
      Function(double value) setPanelPositionListener,
      Function(double value) setAnimatePanelToPositionListener,
      double Function() getPanelPositionListener,
      bool Function() isPanelAnimatingListener,
      bool Function() isPanelOpenListener,
      bool Function() isPanelClosedListener,
      ){
    this._closeListener = closeListener;
    this._openListener = openListener;
    this._hideListener = hideListener;
    this._showListener = showListener;
    this._setPanelPositionListener = setPanelPositionListener;
    this._setAnimatePanelToPositionListener = setAnimatePanelToPositionListener;
    this._getPanelPositionListener = getPanelPositionListener;
    this._isPanelAnimatingListener = isPanelAnimatingListener;
    this._isPanelOpenListener = isPanelOpenListener;
    this._isPanelClosedListener = isPanelClosedListener;
  }

  /// Closes the sliding panel to its collapsed state (i.e. to the  minHeight)
  void close(){
    _closeListener();
  }

  /// Opens the sliding panel fully
  /// (i.e. to the maxHeight)
  void open(){
    _openListener();
  }

  /// Hides the sliding panel (i.e. is invisible)
  void hide(){
    _hideListener();
  }

  /// Shows the sliding panel in its collapsed state
  /// (i.e. "un-hide" the sliding panel)
  void show(){
    _showListener();
  }

  /// Sets the panel position (without animation).
  /// The value must between 0.0 and 1.0
  /// where 0.0 is fully collapsed and 1.0 is completely open.
  void setPanelPosition(double value){
    assert(0.0 <= value && value <= 1.0);
    _setPanelPositionListener(value);
  }

  /// Animates the panel position to the value.
  /// The value must between 0.0 and 1.0
  /// where 0.0 is fully collapsed and 1.0 is completely open
  void animatePanelToPosition(double value){
    assert(0.0 <= value && value <= 1.0);
    _setAnimatePanelToPositionListener(value);
  }

  /// Gets the current panel position.
  /// Returns the % offset from collapsed state
  /// to the open state
  /// as a decimal between 0.0 and 1.0
  /// where 0.0 is fully collapsed and
  /// 1.0 is full open.
  double getPanelPosition(){
    return _getPanelPositionListener();
  }

  /// Returns whether or not the panel is
  /// currently animating.
  bool isPanelAnimating(){
    return _isPanelAnimatingListener();
  }

  /// Returns whether or not the
  /// panel is open.
  bool isPanelOpen(){
    return _isPanelOpenListener();
  }

  /// Returns whether or not the
  /// panel is closed.
  bool isPanelClosed(){
    return _isPanelClosedListener();
  }

}