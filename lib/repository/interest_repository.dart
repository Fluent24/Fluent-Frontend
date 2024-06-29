import 'package:flutter/material.dart';
import 'package:fluent/models/interest.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 사용자 관심사 기본 주제
final List<Interest> interests = [
  Interest(
    label: '여행',
    icon: FontAwesomeIcons.plane,
    color: Colors.blueAccent,
  ),
  Interest(
    label: '연애',
    icon: FontAwesomeIcons.gratipay,
    color: Colors.pinkAccent,
  ),
  Interest(
    label: '운동',
    icon: FontAwesomeIcons.dumbbell,
    color: Colors.black54,
  ),
  Interest(
    label: '회의',
    icon: FontAwesomeIcons.personChalkboard,
    color: Colors.green,
  ),
  Interest(
    label: '음식',
    icon: FontAwesomeIcons.utensils,
    color: Colors.orangeAccent,
  ),
  Interest(
    label: '영화',
    icon: FontAwesomeIcons.video,
    color: Colors.brown,
  ),
  Interest(
    label: '음악',
    icon: FontAwesomeIcons.compactDisc,
    color: Colors.black87,
  ),
];