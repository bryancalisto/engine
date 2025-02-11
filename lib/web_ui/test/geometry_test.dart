// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This is testing some of the named constants.
// ignore_for_file: use_named_constants

import 'dart:math' as math show sqrt;
import 'dart:math' show pi;

import 'package:test/bootstrap/browser.dart';
import 'package:test/test.dart';

import 'package:ui/ui.dart';

void main() {
  internalBootstrapBrowserTest(() => testMain);
}

void testMain() {
  test('Offset.direction', () {
    expect(const Offset(0.0, 0.0).direction, 0.0);
    expect(const Offset(0.0, 1.0).direction, pi / 2.0);
    expect(const Offset(0.0, -1.0).direction, -pi / 2.0);
    expect(const Offset(1.0, 0.0).direction, 0.0);
    expect(const Offset(1.0, 1.0).direction, pi / 4.0);
    expect(const Offset(1.0, -1.0).direction, -pi / 4.0);
    expect(const Offset(-1.0, 0.0).direction, pi);
    expect(const Offset(-1.0, 1.0).direction, pi * 3.0 / 4.0);
    expect(const Offset(-1.0, -1.0).direction, -pi * 3.0 / 4.0);
  });
  test('Offset.fromDirection', () {
    expect(Offset.fromDirection(0.0, 0.0), const Offset(0.0, 0.0));
    expect(Offset.fromDirection(pi / 2.0).dx,
        closeTo(0.0, 1e-12)); // aah, floating point math. i love you so.
    expect(Offset.fromDirection(pi / 2.0).dy, 1.0);
    expect(Offset.fromDirection(-pi / 2.0).dx, closeTo(0.0, 1e-12));
    expect(Offset.fromDirection(-pi / 2.0).dy, -1.0);
    expect(Offset.fromDirection(0.0), const Offset(1.0, 0.0));
    expect(Offset.fromDirection(pi / 4.0).dx,
        closeTo(1.0 / math.sqrt(2.0), 1e-12));
    expect(Offset.fromDirection(pi / 4.0).dy,
        closeTo(1.0 / math.sqrt(2.0), 1e-12));
    expect(Offset.fromDirection(-pi / 4.0).dx,
        closeTo(1.0 / math.sqrt(2.0), 1e-12));
    expect(Offset.fromDirection(-pi / 4.0).dy,
        closeTo(-1.0 / math.sqrt(2.0), 1e-12));
    expect(Offset.fromDirection(pi).dx, -1.0);
    expect(Offset.fromDirection(pi).dy, closeTo(0.0, 1e-12));
    expect(Offset.fromDirection(pi * 3.0 / 4.0).dx,
        closeTo(-1.0 / math.sqrt(2.0), 1e-12));
    expect(Offset.fromDirection(pi * 3.0 / 4.0).dy,
        closeTo(1.0 / math.sqrt(2.0), 1e-12));
    expect(Offset.fromDirection(-pi * 3.0 / 4.0).dx,
        closeTo(-1.0 / math.sqrt(2.0), 1e-12));
    expect(Offset.fromDirection(-pi * 3.0 / 4.0).dy,
        closeTo(-1.0 / math.sqrt(2.0), 1e-12));
    expect(Offset.fromDirection(0.0, 2.0), const Offset(2.0, 0.0));
    expect(
        Offset.fromDirection(pi / 6, 2.0).dx, closeTo(math.sqrt(3.0), 1e-12));
    expect(Offset.fromDirection(pi / 6, 2.0).dy, closeTo(1.0, 1e-12));
  });
  test('Size.aspectRatio', () {
    expect(const Size(0.0, 0.0).aspectRatio, 0.0);
    expect(const Size(-0.0, 0.0).aspectRatio, 0.0);
    expect(const Size(0.0, -0.0).aspectRatio, 0.0);
    expect(const Size(-0.0, -0.0).aspectRatio, 0.0);
    expect(const Size(0.0, 1.0).aspectRatio, 0.0);
    expect(const Size(0.0, -1.0).aspectRatio, -0.0);
    expect(const Size(1.0, 0.0).aspectRatio, double.infinity);
    expect(const Size(1.0, 1.0).aspectRatio, 1.0);
    expect(const Size(1.0, -1.0).aspectRatio, -1.0);
    expect(const Size(-1.0, 0.0).aspectRatio, -double.infinity);
    expect(const Size(-1.0, 1.0).aspectRatio, -1.0);
    expect(const Size(-1.0, -1.0).aspectRatio, 1.0);
    expect(const Size(3.0, 4.0).aspectRatio, 3.0 / 4.0);
  });
  test('Radius.clamp() operates as expected', () {
    final RRect rrectMin = RRect.fromLTRBR(1, 3, 5, 7,
      const Radius.circular(-100).clamp(minimum: Radius.zero));

    expect(rrectMin.left, 1);
    expect(rrectMin.top, 3);
    expect(rrectMin.right, 5);
    expect(rrectMin.bottom, 7);
    expect(rrectMin.trRadius, equals(const Radius.circular(0)));
    expect(rrectMin.blRadius, equals(const Radius.circular(0)));

    final RRect rrectMax = RRect.fromLTRBR(1, 3, 5, 7,
      const Radius.circular(100).clamp(maximum: const Radius.circular(10)));

    expect(rrectMax.left, 1);
    expect(rrectMax.top, 3);
    expect(rrectMax.right, 5);
    expect(rrectMax.bottom, 7);
    expect(rrectMax.trRadius, equals(const Radius.circular(10)));
    expect(rrectMax.blRadius, equals(const Radius.circular(10)));

    final RRect rrectMix = RRect.fromLTRBR(1, 3, 5, 7,
      const Radius.elliptical(-100, 100).clamp(minimum: Radius.zero, maximum: const Radius.circular(10)));

    expect(rrectMix.left, 1);
    expect(rrectMix.top, 3);
    expect(rrectMix.right, 5);
    expect(rrectMix.bottom, 7);
    expect(rrectMix.trRadius, equals(const Radius.elliptical(0, 10)));
    expect(rrectMix.blRadius, equals(const Radius.elliptical(0, 10)));

    final RRect rrectMix1 = RRect.fromLTRBR(1, 3, 5, 7,
      const Radius.elliptical(100, -100).clamp(minimum: Radius.zero, maximum: const Radius.circular(10)));

    expect(rrectMix1.left, 1);
    expect(rrectMix1.top, 3);
    expect(rrectMix1.right, 5);
    expect(rrectMix1.bottom, 7);
    expect(rrectMix1.trRadius, equals(const Radius.elliptical(10, 0)));
    expect(rrectMix1.blRadius, equals(const Radius.elliptical(10, 0)));
  });
  test('Radius.clampValues() operates as expected', () {
    final RRect rrectMin = RRect.fromLTRBR(1, 3, 5, 7,
      const Radius.circular(-100).clampValues(minimumX: 0, minimumY: 0));

    expect(rrectMin.left, 1);
    expect(rrectMin.top, 3);
    expect(rrectMin.right, 5);
    expect(rrectMin.bottom, 7);
    expect(rrectMin.trRadius, equals(const Radius.circular(0)));
    expect(rrectMin.blRadius, equals(const Radius.circular(0)));

    final RRect rrectMax = RRect.fromLTRBR(1, 3, 5, 7,
      const Radius.circular(100).clampValues(maximumX: 10, maximumY: 20));

    expect(rrectMax.left, 1);
    expect(rrectMax.top, 3);
    expect(rrectMax.right, 5);
    expect(rrectMax.bottom, 7);
    expect(rrectMax.trRadius, equals(const Radius.elliptical(10, 20)));
    expect(rrectMax.blRadius, equals(const Radius.elliptical(10, 20)));

    final RRect rrectMix = RRect.fromLTRBR(1, 3, 5, 7,
      const Radius.elliptical(-100, 100).clampValues(minimumX: 5, minimumY: 6, maximumX: 10, maximumY: 20));

    expect(rrectMix.left, 1);
    expect(rrectMix.top, 3);
    expect(rrectMix.right, 5);
    expect(rrectMix.bottom, 7);
    expect(rrectMix.trRadius, equals(const Radius.elliptical(5, 20)));
    expect(rrectMix.blRadius, equals(const Radius.elliptical(5, 20)));

    final RRect rrectMix2 = RRect.fromLTRBR(1, 3, 5, 7,
      const Radius.elliptical(100, -100).clampValues(minimumX: 5, minimumY: 6, maximumX: 10, maximumY: 20));

    expect(rrectMix2.left, 1);
    expect(rrectMix2.top, 3);
    expect(rrectMix2.right, 5);
    expect(rrectMix2.bottom, 7);
    expect(rrectMix2.trRadius, equals(const Radius.elliptical(10, 6)));
    expect(rrectMix2.blRadius, equals(const Radius.elliptical(10, 6)));
  });
}
