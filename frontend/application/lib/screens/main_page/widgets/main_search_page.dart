import 'package:flutter/material.dart';
import 'package:frontend/screens/search_page/search_page.dart';
import 'package:frontend/util/dotted_border_text.dart';
import 'package:frontend/util/title_bar.dart';
import 'package:get/get.dart';

class MainSearchPage extends StatelessWidget {
  const MainSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleBar(),
      body: Stack(
        children: <Widget>[
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/star_background.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // 위에 올라갈 위젯들
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(40, 45, 40, 50),
                width: double.infinity,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 50),
                        DottedBorderText(
                          text: '검색방식을 선택해주세요',
                          textStyle: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        )
                      ],
                    ),
                    // 이미지 넣는 곳
                    Positioned(
                      top: 5,
                      left: MediaQuery.of(context).size.width / 2 - 35 - 40,
                      // 화면상의 가로 넓이에서 이미지의 width 70의 반과 container의 margin 30을 빼서 중앙에 배치
                      child: Image.asset(
                        'assets/images/bandi_bug.png',
                        width: 70, // 이미지 크기 설정
                        height: 70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: Column(
                  children: [
                    // 버튼의 가장 큰 부분을 GestureDetector로 감싸서 클릭 이벤트를 추가
                    GestureDetector(
                      onTap: () {
                        // 버튼을 클릭했을 때 수행하는 동작
                        print('음성으로 검색하기 버튼 클릭');
                        Get.to(
                          () => const SearchPage(
                            initialIndex: 0,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF1FFCA),
                          borderRadius:
                              BorderRadius.circular(35), // 버튼을 둥글게 만들기 위한 속성
                        ),
                        width: double.infinity,
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/images/search_voice.png',
                                width: 200,
                                height: 150,
                              ),
                              const Text(
                                '음성으로 검색하기',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 버튼의 가장 큰 부분을 GestureDetector로 감싸서 클릭 이벤트를 추가
                    GestureDetector(
                      onTap: () {
                        // 버튼을 클릭했을 때 수행하는 동작
                        print('문자로 검색하기 버튼 클릭');
                        Get.to(
                          () => const SearchPage(initialIndex: 1),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF1FFCA),
                          borderRadius:
                              BorderRadius.circular(35), // 버튼을 둥글게 만들기 위한 속성
                        ),
                        width: double.infinity,
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/images/search_text.png',
                                width: 200,
                                height: 150,
                              ),
                              const Text(
                                '문자로 검색하기',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
