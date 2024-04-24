import 'package:flutter/material.dart';
import 'package:frontend/util/title_bar.dart';

class SearchTextPage extends StatefulWidget {
  const SearchTextPage({super.key});

  @override
  _SearchTextPageState createState() => _SearchTextPageState();
}

class _SearchTextPageState extends State<SearchTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TitleBar(),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '텍스트 검색 페이지',
                    style: TextStyle(
                      color: Colors.yellow[200],
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
