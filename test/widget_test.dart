// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

const int waveCount = 35;

List<double> normolizeWave(List<double> waveSize) {
  var result = List<double>.filled(waveCount, 0);
  int chunkSize = waveSize.length > waveCount 
    ? (waveSize.length / waveCount).ceil()
    : 1;
  int chunkCount = (waveSize.length / chunkSize).ceil();

  for(int chunkPosition = 0; chunkPosition < chunkCount; chunkPosition++) {
    double chunkItemsValue = 0;
    for(int itemIndex = 0; itemIndex < chunkSize; itemIndex++) {
      int index = chunkPosition * chunkSize + itemIndex;
      
      if(index >= waveSize.length) {
        break;
      }

      chunkItemsValue += waveSize[index];
    }
    result[chunkPosition] = chunkItemsValue / chunkSize;
  }
  return result;
}

void test1() {
  var size = 100;
  var waveSize = List<double>.filled(size, 0);

  for(int i = 0 ; i < size; i++) {
    waveSize[i] = Random().nextDouble() * 100;
  }

  normolizeWave(waveSize);
}

void test2() {
  var size = 20;
  var waveSize = List<double>.filled(size, 0);

  for(int i = 0 ; i < size; i++) {
    waveSize[i] = Random().nextDouble() * 100;
  }

  normolizeWave(waveSize);
}

void main() {
  test1();
  test2();
}