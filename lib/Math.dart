
import 'dart:math';

class CoordMath {
  
  static Point polarToCartesian(Point center, double r, double radian) {
    return Point(center.x + r * cos(radian), center.y + r * sin(radian));
  }
}

class MathLine {
  /// y = kx + c
  static double calculateY(x, {k = 0, c = 0}) {
    return k * x + c;
  }

  ///Calculate the param K in y = kx +c
  static double calculateK(Point p1, Point p2) {
    if (p1.x == p2.x) return 0;
    return (p2.y - p1.y) / (p2.x - p1.x);
  }

  ///Calculate the param C in y = kx +c
  static double calculateC(Point p1, Point p2) {
    return p1.y - calculateK(p1, p2) * p1.x;
  }
}
