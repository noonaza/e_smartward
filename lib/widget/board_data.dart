import 'package:flutter/material.dart';
import 'package:e_smartward/widget/colors_board.dart';

class DataCard {
  final List<String> petNames;
  final String ownerName;
  final String? petType;
  final String hn;
  final ColorTone tone;
  final List<Widget> cornerIcons;
  final String? images;

  const DataCard( {
    required this.petNames,
    required this.ownerName,
    required this.hn,
    required this.tone,
    required this.cornerIcons,
    required this.petType,
    required this. images,
  });
}
