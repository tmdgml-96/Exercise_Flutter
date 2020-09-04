import 'dart:async';
import 'dart:convert';
//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// as로 name 주고 간단하게 사용.
import 'model/store.dart' as Store;
import 'model/store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corona Mask Inventory Check',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// stful 입력하면, statefulWidget 자동 생성
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // data 불러오게 List 만들어주기
  final stores = List<MaskStore>(); // List<name>에서 name은 class name과 동일해야 함.

  // 로딩 중인지 확인하는 변수 만들기
  var isLoading = true; // 어차피 처음 실핼할 때 앱이 실행 준비 중이므로 true로 만들기.

  Future fetch() async {

    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json';
    var response = await http.get(url);

    final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));

    // print(jsonResult['stores']); // log check

    // store 내용만
    final jsonStores = jsonResult['stores'];

    setState(() {
      // --------------상태 변경 부분
      // stores 내용  List에 담기
      stores.clear(); // 새로고침을 위해
      // 갯수만큼 넣기
      // jsonStores type은 dynamic type. 따라서 반복할 수 있는 타입(forEach이용해서 반복하기).
      // e는 간단히 적기 위해 e = element
      jsonStores.forEach((e) {
        // MaskStore store = MaskStore.fromJson(e);
        // stores.add(store);
        // 간략하게 줄여서
        stores.add(MaskStore.fromJson(e));
        //---------------  하지만 이걸로는 변경된 화면을 그릴 수 없음
        //---------------  따라서 setState로 김싸주기
      });
    });
    // isLoading complete
    isLoading = false;
  }

  // 자동으로 호출을 하도록.
  @override
  void initState() {
    super.initState();
    fetch();
  }

  /*예제 돌려보는 함수 만들어보자*
  //
  Future fetch() async {
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json';
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
*/

  @override
  Widget build(BuildContext context) {
  //var isLoading = false;

    return Scaffold(
        appBar: AppBar(
          //재고 있는 장소를 실시간으로 변경해주려면 $ 넣기
          title: Text('Mask : ${stores.length}'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                fetch();
              },
            ),
          ],
        ), // 이 영역에 앱바 아이콘 넣을 수 있음.
        body: isLoading
            ? loadingWidget()
            : ListView(
                // 로딩 ?(이면) 함수 실행하고, 아니면 리스트뷰 보여주기

                // map()함수는 변경한다는 함수
                // => 는 ramda 방식
                // ??은 null이 있을 때 ''로 표기하라는 의미
                children: stores.map((e) {
                  return ListTile(
                    title: Text(e.name),
                    subtitle: Text(e.addr),
                    //leading은 왼쪽 끝에 위치하게끔 만든다.
                    // trailing은 오른쪽 끝
                    leading: Text(e.remainStat ?? '매진'),
                  );
                }).toList(),
              ));
  }

  // isLoading 메소드 별도로 빼기
  Widget loadingWidget() {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text('Loading....'),
          CircularProgressIndicator(),

        ],
      ),
    );
  }
}
