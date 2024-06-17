import 'dart:convert';

import 'package:fluent/common/dio/dio.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/widgets/text.dart';
import 'package:fluent/widgets/waveform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedbackTestScreen extends ConsumerStatefulWidget {
  FeedbackTestScreen({super.key});

  @override
  ConsumerState<FeedbackTestScreen> createState() => _FeedbackTestScreenState();
}

class _FeedbackTestScreenState extends ConsumerState<FeedbackTestScreen> {
  // final String problemScript = "Watching the LA Dodgers baseball game is one of my dreams to achieve. I really want to go watch the game during this schedule.";
  // final String userScript = "Watching the Alley Dart in space for game he swallowed my dream to a cheek I really wanted to go to watch the game during this schedule.";

  final String problemScript = "This is a correct sentence. This is a correct SENTENCE";
  final String userScript = "This is a correct SENTENCE This is a correct SENTENCE";

  List<int> incorrectIndices = [];
  bool isLoading = true;

  List<TextSpan> highlightDifferences(String userScript, List<int> incorrectIndices) {
    List<TextSpan> spans = [];
    List<String> words = userScript.split(' ');

    int charIndex = 0;

    for (String word in words) {
      bool hasIncorrectChar = false;

      for (int i = 0; i < word.length; i++) {
        if (incorrectIndices.contains(charIndex + i)) {
          hasIncorrectChar = true;
          break;
        }
      }

      spans.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(
            color: hasIncorrectChar ? Colors.red : Colors.grey,
            fontSize: 15.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            wordSpacing: 2,
            height: 4.5, // 줄간격
          )
        )
      );

      charIndex += word.length + 1; // 공백 추가
    }

    return spans;
  }


  Future<void> loadIncorrectIndexList(String correctSentence, String givenSentence) async {
    final dio = ref.read(dioProvider);
    final requestData = {
      'correctSentence': correctSentence.toUpperCase(),
      'givenSentence': givenSentence.toUpperCase(),
    };

    try {
      final response = await dio.post('${Env.serverEndpoint}/api/compare', data: jsonEncode(requestData));

      if (response.statusCode == 200) {
        final result = response.data;
        setState(() {
          incorrectIndices = List<int>.from(result).reversed.toList();
          print('[LOG] SUCCESS COMPARE : $incorrectIndices');
          isLoading = false;
        });
      }
    } catch (e) {
      print('[ERR] REQUEST COMPARE ERROR : $e');
    }

  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadIncorrectIndexList(problemScript, userScript);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SafeArea(child: Scaffold(
        body: Center(
          child: waveForm(),
        ),
      ));
    }
    else {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.7,
            margin: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
              bottom: 5.0,
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 35.0, vertical: 25.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SectionText(
                    text: 'Feedback',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 20),

                // 문제 --> 문제 길이에 따라 fontSize 조절하는 작업 필요
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    radius: const Radius.circular(10.0),
                    thickness: 5.0,
                    trackVisibility: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    userScript,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.transparent,
                                      wordSpacing: 2,
                                      height: 5, // 줄간격
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    problemScript,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      wordSpacing: 2,
                                      height: 4, // 줄간격
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 35,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.6,
                                    child: RichText(
                                        text: TextSpan(
                                          children: highlightDifferences(userScript, incorrectIndices),
                                        )
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 다시 듣기 / 다음 문제 / 음성 녹음
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  children: [
                    // 다시 듣기
                    ElevatedButton(
                      onPressed: () {
                        // 레퍼런스 음성 파일 다시 재생하기
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                        Colors.blueAccent.withOpacity(0.9),
                        foregroundColor: Colors.white,
                        iconColor: Colors.white,
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(45),
                        ),
                        minimumSize: const Size(120, 0),
                      ),
                      child: Column(
                        children: [
                          const FaIcon(
                              FontAwesomeIcons.headphones),
                          const SizedBox(height: 3),
                          SectionText(
                            text: 'Listen',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
