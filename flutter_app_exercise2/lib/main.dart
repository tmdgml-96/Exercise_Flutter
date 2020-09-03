import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}
/*
* main함수는 이렇게도 쓸 수 있다.
*
* void main() => runApp(new MyApp());
* */

// 홈 화면 자체와 같이 움직임 없는 것들 구현
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo 2020 09 02',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'icon ratation'),
    );
  }
}

// 움직이는 동적인 아이콘들
class MyHomePage extends StatefulWidget {
  // key - value 형식의 생성자 만드는 방법.
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// MyHomePage가 가지는 State 만들어 주어야 함.
class _MyHomePageState extends State<MyHomePage> {




  var _position = 0.0; //내부변수 position 추가

  // 하나면 child, 여러 개가 가능하면 children.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Slider(
              value: _position, // 초기값은 0.0이 아니라 _position으로 주기.
              onChanged: (var position) {
                //setState로 position update
                setState(() {
                  _position = position;
                });
              },
              //리스너 구현 아직은 null
              // dart에서 함수는 객체
            ),
            //Icon(Icons.accessibility_new),
            //Icon(Icons.accessibility_new)
            Transform.rotate(angle: _position*2,child: Icon(Icons.accessibility_new),),
            Transform.rotate(angle: _position*2*3.14,child: Icon(Icons.accessibility_new),),

          ],
        ),
      ),
    );
  }
}
