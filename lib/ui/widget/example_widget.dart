import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

import 'package:mvvm_example/domain/blocs/users_bloc.dart';
import 'package:mvvm_example/ui/widget/nav_bar_widget.dart';

typedef MyEventCallback = void Function({required int index});
const duration = Duration(milliseconds: 250);

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  static Widget create() {
    return BlocProvider<UsersBloc>(
      create: (context) => UsersBloc(context),
      child: const ExampleWidget(),
    );
  }

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Color _color = Colors.red;
  bool toggle = false;
  final riveFileName = 'assets/rocket.riv';
  Artboard? _artboard;
  final _listKey = GlobalKey<AnimatedListState>();

  var _data = [1, 2, 3, 4];

  void _increment() {
    final int element = (_data.isEmpty ? 0 : _data.last) + 1;
    _data.add(element);
    final index = _data.length - 1;
    _listKey.currentState?.insertItem(index);
  }

  void _removeAt({required int index}) {
    final element = _data.removeAt(index);
    _listKey.currentState?.removeItem(index, (context, animation) {
      return SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$element'),
          )),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: duration, reverseDuration: duration);

    // _controller.addListener(() {
    //   if (_controller.isCompleted) {
    //     _controller.reverse();
    //   } else if (_controller.isDismissed) {
    //     _controller.forward();
    //   }
    //   print(_controller.status);
    // });

    _loadRiveFile();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile.import(bytes);

    // Select an animation by its name
    setState(() => _artboard = file.mainArtboard
      ..addController(
        SimpleAnimation('rocket'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () => {bloc.add(UsersLogoutEvent())},
              child: const Text('Выход')),
        ],
      ),
      drawer: const NavBarWidget(),
      body: SafeArea(
          child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          color: Colors.black,
          child: ScaleTransitionExample(
            controller: _controller,
            color: _color,
          ),

          // child: AnimatedListWidget(
          //   data: _data,
          //   callback: _removeAt,
          //   listKey: _listKey,
          // ),
          // child: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     // Container(
          //     //   height: 400,
          //     //   width: 350,
          //     //   child: _artboard != null
          //     //       ? Rive(
          //     //           artboard: _artboard!,
          //     //           fit: BoxFit.cover,
          //     //         )
          //     //       : Container(),
          //     // ),
          //     // TweenAnimationBuilderExample(
          //     //   toggle: toggle,
          //     // ),
          //     // AnimatedSwitcherExample(
          //     //   toggle: toggle,
          //     // ),
          //     // AnimatedRotationExample(
          //     //   toggle: toggle,
          //     // ),
          //     // AnimatedOpacityExample(
          //     //   toggle: toggle,
          //     // ),
          //     // AnimatedCrossFadeExample(
          //     //   toggle: toggle,
          //     // ),
          //     // AnimatedAlignExample(
          //     //   toggle: toggle,
          //     // ),
          //     // AnimatedDefaultTextStyleWidget(
          //     //   toggle: toggle,
          //     // ),
          //     // AnimatedContainerExample(
          //     //   toggle: toggle,
          //     // ),
          //     // ContainerExample(
          //     //   toggle: toggle,
          //     // ),
          //     const _AgeTitle(),
          //     const _AgeIncrementWidget(),
          //     const _AgeDecrementWidget(),
          //   ],
          // ),
        ),
      )),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.forward(from: 0.0);
                // _controller.repeat(
                //     reverse: true, period: const Duration(seconds: 5));
                // if (_controller.isCompleted) {
                //   _controller.reverse();
                // } else {
                //   _controller.forward();
                // }
                final random = Random();
                _color = Color.fromRGBO(
                  random.nextInt(256),
                  random.nextInt(256),
                  random.nextInt(256),
                  1,
                );
              });
            },
            child: const Icon(Icons.play_arrow),
          ),
          FloatingActionButton(
            onPressed: () => _increment(),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        final age = state.currentUser.age;
        return Text('$age');
      },
    );
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return ElevatedButton(
        onPressed: () => bloc.add(UsersIncrementAgeEvent()),
        child: const Text('+'));
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();

    return ElevatedButton(
        onPressed: () => bloc.add(UsersDecrementAgeEvent()),
        child: const Text('-'));
  }
}

class ContainerExample extends StatelessWidget {
  final bool toggle;
  const ContainerExample({super.key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: toggle ? Colors.red : Colors.green,
      padding: toggle ? const EdgeInsets.all(40) : const EdgeInsets.all(80),
      width: toggle ? 100 : 400,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      ),
    );
  }
}

class AnimatedContainerExample extends StatelessWidget {
  final bool toggle;
  const AnimatedContainerExample({super.key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      color: toggle ? Colors.red : Colors.green,
      padding: toggle ? const EdgeInsets.all(40) : const EdgeInsets.all(80),
      width: toggle ? 100 : 400,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      ),
    );
  }
}

class AnimatedDefaultTextStyleWidget extends StatelessWidget {
  final bool toggle;
  const AnimatedDefaultTextStyleWidget({super.key, required this.toggle});

  static const styleOne = TextStyle(fontSize: 50, color: Colors.red);
  static const styleTwo = TextStyle(fontSize: 16, color: Colors.green);

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: duration,
      style: toggle ? styleOne : styleTwo,
      child: const Text('Hello WOrld'),
    );
  }
}

class AnimatedAlignExample extends StatelessWidget {
  final bool toggle;
  const AnimatedAlignExample({super.key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: duration,
      alignment: toggle ? Alignment.topLeft : Alignment.bottomRight,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      ),
    );
  }
}

class AnimatedCrossFadeExample extends StatelessWidget {
  final bool toggle;
  const AnimatedCrossFadeExample({super.key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: duration,
      crossFadeState:
          toggle ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      ),
      secondChild: Container(
        width: 150,
        height: 150,
        color: Colors.green,
      ),
    );
  }
}

class AnimatedOpacityExample extends StatelessWidget {
  final bool toggle;
  const AnimatedOpacityExample({super.key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: duration,
      opacity: toggle ? 0 : 1,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      ),
    );
  }
}

class AnimatedRotationExample extends StatelessWidget {
  final bool toggle;
  const AnimatedRotationExample({super.key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      duration: duration,
      turns: toggle ? 0 : 20 * pi,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
      ),
    );
  }
}

class AnimatedSwitcherExample extends StatelessWidget {
  final bool toggle;
  const AnimatedSwitcherExample({super.key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      child: toggle
          ? Container(
              key: const ValueKey(0),
              width: 50,
              height: 50,
              color: Colors.blue,
            )
          : Container(
              key: const ValueKey(1),
              width: 150,
              height: 150,
              color: Colors.red,
            ),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
    );
  }
}

class TweenAnimationBuilderExample extends StatelessWidget {
  final bool toggle;
  static final _forwarTween = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  );
  const TweenAnimationBuilderExample({super.key, required this.toggle});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: toggle ? _forwarTween : ReverseTween(_forwarTween),
      duration: duration,
      builder: (context, Color? color, Widget? child) {
        return ColorFiltered(
          child: child,
          colorFilter: ColorFilter.mode(color!, BlendMode.modulate),
        );
      },
      child: Image.asset('images/sun.jpg'),
    );
    // return TweenAnimationBuilder(
    //   duration: duration,
    //   tween: Tween(
    //     begin: toggle ? 0.0 : 1.0,
    //     end: toggle ? 1.0 : 0.0,
    //   ),
    //   builder: (BuildContext context, value, _) {
    //     return Opacity(
    //       opacity: value,
    //       child: SizedBox(
    //         height: 200 * value,
    //         width: 200 * value,
    //         child: Container(color: Colors.red),
    //       ),
    //     );
    //   },
    // );
  }
}

class AnimatedListWidget extends StatelessWidget {
  final List<int> data;
  final MyEventCallback callback;
  final GlobalKey<AnimatedListState> listKey;
  const AnimatedListWidget(
      {super.key,
      required this.data,
      required this.callback,
      required this.listKey});

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      initialItemCount: data.length,
      itemBuilder: (context, index, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: GestureDetector(
            onTap: () => callback(index: index),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${data[index]}'),
              )),
            ),
          ),
        );
      },
    );
  }
}

class ScaleTransitionExample extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  const ScaleTransitionExample({
    Key? key,
    required this.controller,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1,
      sizeFactor: controller,
      child: Container(
        width: 100,
        height: 200,
        color: color,
      ),
    );
  }
}
