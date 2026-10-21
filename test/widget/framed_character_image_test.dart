import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nocturne/features/scene_player/presentation/widgets/framed_character_image.dart';
import 'package:nocturne/features/stories/domain/models/sprite_framing.dart';

// A 1×1 transparent PNG: the widget's geometry doesn't depend on the pixels.
final _png = MemoryImage(
  Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, //
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
    0x42, 0x60, 0x82,
  ]),
);

void main() {
  group('FramedCharacterImage.imageRect', () {
    test('the full shot is the whole area, so any image keeps its old contain layout', () {
      const size = Size(540, 960);
      expect(FramedCharacterImage.imageRect(size, 0), Offset.zero & size);
    });

    for (final size in const [Size(393, 873), Size(540, 960), Size(1280, 720)]) {
      test('knee shot on $size: head in the upper part, cut on the bottom edge, centered', () {
        final rect = FramedCharacterImage.imageRect(size, 1);

        final headTop = rect.top + rect.height * FramedCharacterImage.spriteHeadInset;
        final cut = rect.top + rect.height * FramedCharacterImage.kneesVisibleFraction;
        expect(headTop / size.height, closeTo(FramedCharacterImage.kneesHeadroom, 1e-9));
        expect(cut, closeTo(size.height, 1e-9));
        expect(rect.center.dx, closeTo(size.width / 2, 1e-9));
        expect(rect.width / rect.height, closeTo(FramedCharacterImage.spriteAspectRatio, 1e-9));

        // A real close-up: bigger than the whole figure in the full shot,
        // which on a tall screen is bound by the width.
        final fullHeight = size.height < size.width / FramedCharacterImage.spriteAspectRatio
            ? size.height
            : size.width / FramedCharacterImage.spriteAspectRatio;
        expect(rect.height, greaterThan(fullHeight));
      });
    }

    for (final size in const [Size(393, 873), Size(540, 960), Size(1280, 720)]) {
      test('waist shot on $size: head in the upper part, cut at half the figure, closer than the knee shot', () {
        final rect = FramedCharacterImage.imageRect(size, 2);
        final knees = FramedCharacterImage.imageRect(size, 1);

        final headTop = rect.top + rect.height * FramedCharacterImage.spriteHeadInset;
        final cut = rect.top + rect.height * FramedCharacterImage.waistVisibleFraction;
        expect(headTop / size.height, closeTo(FramedCharacterImage.kneesHeadroom, 1e-9));
        expect(cut, closeTo(size.height, 1e-9));
        expect(rect.center.dx, closeTo(size.width / 2, 1e-9));
        expect(rect.height, greaterThan(knees.height));
      });
    }
    test('in between, the rectangle moves continuously', () {
      const size = Size(540, 960);
      final a = FramedCharacterImage.imageRect(size, 0.49);
      final b = FramedCharacterImage.imageRect(size, 0.51);
      expect((a.height - b.height).abs(), lessThan(10));
      expect((a.top - b.top).abs(), lessThan(10));
    });
  });

  testWidgets('switching the shot animates the image instead of jumping', (tester) async {
    tester.view.physicalSize = const Size(540, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    Widget build(SpriteFraming framing) => Directionality(
      textDirection: TextDirection.ltr,
      child: FramedCharacterImage(image: _png, framing: framing),
    );
    Rect imageRect() => tester.getRect(find.byType(Image));

    await tester.pumpWidget(build(SpriteFraming.full));
    expect(imageRect(), const Rect.fromLTWH(0, 0, 540, 960));

    await tester.pumpWidget(build(SpriteFraming.knees));
    await tester.pump(FramedCharacterImage.duration ~/ 2);
    final halfway = imageRect();
    final target = FramedCharacterImage.imageRect(const Size(540, 960), 1);
    expect(target.height, greaterThan(960));
    expect(halfway.height, greaterThan(960));
    expect(halfway.height, lessThan(target.height));

    await tester.pumpAndSettle();
    expect(imageRect(), target);
  });
}
