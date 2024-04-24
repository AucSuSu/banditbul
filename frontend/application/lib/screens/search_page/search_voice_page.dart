import 'package:flutter/material.dart';
import 'package:frontend/util/title_bar.dart';

class SearchVoicePage extends StatefulWidget {
  const SearchVoicePage({super.key});

  @override
  _SearchVoicePageState createState() => _SearchVoicePageState();
}

class _SearchVoicePageState extends State<SearchVoicePage> {
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
                    '음성 검색 페이지',
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
