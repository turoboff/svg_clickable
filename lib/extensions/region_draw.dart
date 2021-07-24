import 'package:flutter/material.dart';

class RegionDraw {
  String path;
  String diagramName; // Right vs left
  String primaryName;
  String detailedName;
  String groupName;
  Color color;

  RegionDraw(this.diagramName, this.primaryName, this.detailedName,
      this.groupName, this.color, this.path);
}
