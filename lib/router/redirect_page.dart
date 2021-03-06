//
// Copyright 2021 Free TON Wallet Team
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import "package:flutter/src/animation/animation.dart" show Animation;
import "package:flutter/widgets.dart"
    show
        BuildContext,
        Page,
        PageRouteBuilder,
        Route,
        State,
        StatefulWidget,
        Text,
        ValueKey,
        Widget,
        WidgetsFlutterBinding;

import "../widgets/layout/my_scaffold.dart" show MyScaffold;

import "app_route_data.dart" show AppRouteDataMain;

class RedirectPage extends Page<AppRouteDataMain> {
  final void Function(String location, String? state) onChangeRoute;
  final String location;
  final String? state;

  RedirectPage(
    this.onChangeRoute,
    this.location, [
    this.state,
  ]) : super(key: ValueKey<Object>(RedirectPage));

  @override
  Route<AppRouteDataMain> createRoute(BuildContext context) {
    return PageRouteBuilder<AppRouteDataMain>(
      settings: this,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> animation2) {
        // final tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero);
        // final curveTween = CurveTween(curve: Curves.easeInOut);
        // return SlideTransition(
        //   position: animation.drive(curveTween).drive(tween),
        //   child: BookDetailsScreen(
        //     key: ValueKey(book),
        //     book: book,
        //   ),
        // );
        return _RedirectScreen(this.onChangeRoute, this.location, this.state);
      },
    );
  }
}

class _RedirectScreen extends StatefulWidget {
  final void Function(String location, String? state) onChangeRoute;
  final String location;
  final String? state;

  _RedirectScreen(this.onChangeRoute, this.location, this.state);

  @override
  State<StatefulWidget> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<_RedirectScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    Future<void>.delayed(Duration(seconds: 0), () {
      this.widget.onChangeRoute(this.widget.location, this.widget.state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Text("Redirecting..."),
    );
  }
}
