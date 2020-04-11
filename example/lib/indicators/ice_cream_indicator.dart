import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ParalaxConfig {
  final int level;
  final AssetImage image;

  const ParalaxConfig({
    this.level,
    this.image,
  });
}

class IceCreamIndicator extends StatefulWidget {
  final Widget child;

  const IceCreamIndicator({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _IceCreamIndicatorState createState() => _IceCreamIndicatorState();
}

class _IceCreamIndicatorState extends State<IceCreamIndicator>
    with SingleTickerProviderStateMixin {
  static const _assets = <ParalaxConfig>[
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/cup2.png"),
      level: 0,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/spoon.png"),
      level: 1,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/ice1.png"),
      level: 3,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/ice3.png"),
      level: 4,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/ice2.png"),
      level: 2,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/cup.png"),
      level: 0,
    ),
    ParalaxConfig(
      image: AssetImage("assets/ice_cream_indicator/mint.png"),
      level: 5,
    ),
  ];

  static const _indicatorSize = 150.0;

  IndicatorState _prevState;
  AnimationController _spoonController;
  @override
  void initState() {
    _spoonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  static final _spoonTween = CurveTween(curve: Curves.easeInOut);
  static const double _imageSize = 150.0;
  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: _indicatorSize,
      onRefresh: () => Future.delayed(const Duration(seconds: 4)),
      child: widget.child,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget _) {
                final currentState = controller.state;
                if (_prevState == IndicatorState.armed &&
                    currentState == IndicatorState.loading) {
                  _spoonController.repeat(reverse: true);
                } else if (_prevState == IndicatorState.loading &&
                    _prevState != currentState) {
                  _spoonController.stop();
                } else if (currentState == IndicatorState.idle &&
                    _prevState != currentState) {
                  _spoonController..value = 0.0;
                }
                _prevState = currentState;
                return SizedBox(
                  height: controller.value * _indicatorSize,
                  child: Stack(
                    children: <Widget>[
                      for (int i = 0; i < _assets.length; i++)
                        if (i == 1)
                          AnimatedBuilder(
                            animation: _spoonController,
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                (-_assets[i].level) *
                                        (20.0 *
                                            (controller.value.clamp(1.0, 1.5) -
                                                1.0)) +
                                    10,
                              ),
                              child: OverflowBox(
                                maxHeight: _imageSize,
                                minHeight: _imageSize,
                                child: Image(
                                  image: _assets[i].image,
                                  fit: BoxFit.contain,
                                  height: _imageSize,
                                ),
                              ),
                            ),
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: (-_spoonTween
                                        .transform(_spoonController.value)) *
                                    1.25,
                                child: child,
                              );
                            },
                          )
                        else
                          Transform.translate(
                            offset: Offset(
                              0,
                              (-_assets[i].level) *
                                      (20.0 *
                                          (controller.value.clamp(1.0, 1.5) -
                                              1.0)) +
                                  10,
                            ),
                            child: OverflowBox(
                              maxHeight: _imageSize,
                              minHeight: _imageSize,
                              child: Image(
                                image: _assets[i].image,
                                fit: BoxFit.contain,
                                height: _imageSize,
                              ),
                            ),
                          )
                    ],
                  ),
                );
              },
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, controller.value * _indicatorSize),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _spoonController.dispose();
    super.dispose();
  }
}
