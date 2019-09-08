import 'package:flutter/material.dart';

class Screen{
  Size screenSize;

  Screen(this.screenSize);

  double wp(percentage) {
    return percentage / 100 * screenSize.width;
  }

  double hp(percentage) {
    return percentage / 100 * screenSize.height;
  }

  double wp2(double percentage, double min) {
    double _ret = percentage / 100 * screenSize.width;
    if (_ret < min){
      return min;
    }
    return _ret;
  }

  double hp2(double percentage, double min) {
    double _ret = percentage / 100 * screenSize.height;
    if (_ret < min){
      return min;
    }
    return _ret;
  }

  double wp3(double percentage, double min, double max) {
    double _ret = percentage / 100 * screenSize.width;
    if (_ret < min){
      return min;
    }
    if (_ret > max){
      return max;
    }
    return _ret;
  }

  double hp3(double percentage, double min, double max) {
    double _ret = percentage / 100 * screenSize.height;
    if (_ret < min){
      return min;
    }
    if (_ret > max){
      return max;
    }
    return _ret;
  }
}