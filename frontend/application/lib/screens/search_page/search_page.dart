import 'package:flutter/material.dart';
import 'package:frontend/screens/main_page/main_page.dart';
import 'package:frontend/screens/search_page/search_text_page.dart';
import 'package:frontend/screens/search_page/search_voice_page.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late int _selectedIndex;
  static final List<Widget> _pages = <Widget>[
    const SearchVoicePage(), // Voice Search 페이지
    const SearchTextPage(), // Text Search 페이지
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      floatingActionButton: SizedBox(
        // 홈 버튼을 감싸는 컨테이너
        width: 120,
        height: 120,
        child: FloatingActionButton(
          onPressed: () {
            // 홈 버튼 클릭 시 호출될 메소드
            Get.offAll(() => const MainPage());
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ), // 홈 아이콘
          backgroundColor: Colors.white,
          child: const Column(
            // 홈버튼 아이콘에 관한 코드
            mainAxisSize: MainAxisSize.min, // Column 위젯이 필요한 만큼의 공간만 차지하도록 설정
            mainAxisAlignment: MainAxisAlignment.center, // 자식을 중앙으로 정렬
            children: [
              Icon(
                Icons.home,
                size: 45,
                color: Colors.black,
              ),
              Text(
                '메인',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ), // 홈 버튼의 배경 색
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // 중앙에 위치시키기
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.black, // BottomAppBar와 Floating 버튼 사이의 색
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(), // 중앙에 노치를 만들기
          notchMargin: 25.0,
          color: const Color(0xffF1FFCA), // BottomAppBar의 배경 색
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_pages.length + 1, (index) {
              if (index == 1) {
                // 중앙 홈 버튼 위치에는 공간을 만들어둡니다.
                return const SizedBox(
                    width: 100); // FloatingActionButton의 공간을 만듭니다.
              }
              int tabIndex = index > 1 ? index - 1 : index; // 홈 버튼으로 인한 인덱스 조정
              return InkWell(
                onTap: () => _onItemTapped(tabIndex),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    children: <Widget>[
                      // 인덱스에 따른 아이콘과 텍스트
                      Icon(
                        tabIndex == 0 ? Icons.mic : Icons.search,
                        color: _selectedIndex == tabIndex
                            ? Colors.black
                            : Colors.blueGrey,
                        size: 30,
                      ),
                      Text(
                        tabIndex == 0 ? '음성 검색' : '텍스트 검색',
                        style: TextStyle(
                          color: _selectedIndex == tabIndex
                              ? Colors.black
                              : Colors.blueGrey,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
