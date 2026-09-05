import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// A tiny offline animation engine.
///
/// Each exercise is described as two or three key poses of a simple stick
/// figure. The widget eases between them and back again, which reads as
/// "start position \u2192 movement \u2192 return position" without shipping a single
/// video, Lottie or Rive file. The whole library is a few kilobytes of code and
/// therefore always available offline.
class Pose {
  final Offset head, neck, hip;
  final Offset kneeL, ankleL, kneeR, ankleR;
  final Offset elbowL, handL, elbowR, handR;

  const Pose({
    this.head = const Offset(.50, .13),
    this.neck = const Offset(.50, .24),
    this.hip = const Offset(.50, .52),
    this.kneeL = const Offset(.455, .72),
    this.ankleL = const Offset(.455, .92),
    this.kneeR = const Offset(.545, .72),
    this.ankleR = const Offset(.545, .92),
    this.elbowL = const Offset(.42, .38),
    this.handL = const Offset(.42, .50),
    this.elbowR = const Offset(.58, .38),
    this.handR = const Offset(.58, .50),
  });

  static Offset _l(Offset a, Offset b, double t) =>
      Offset(lerpDouble(a.dx, b.dx, t)!, lerpDouble(a.dy, b.dy, t)!);

  static Pose lerp(Pose a, Pose b, double t) => Pose(
        head: _l(a.head, b.head, t),
        neck: _l(a.neck, b.neck, t),
        hip: _l(a.hip, b.hip, t),
        kneeL: _l(a.kneeL, b.kneeL, t),
        ankleL: _l(a.ankleL, b.ankleL, t),
        kneeR: _l(a.kneeR, b.kneeR, t),
        ankleR: _l(a.ankleR, b.ankleR, t),
        elbowL: _l(a.elbowL, b.elbowL, t),
        handL: _l(a.handL, b.handL, t),
        elbowR: _l(a.elbowR, b.elbowR, t),
        handR: _l(a.handR, b.handR, t),
      );
}

/// Reusable base positions.
const Pose _stand = Pose();

const Pose _quad = Pose(
  head: Offset(.20, .46),
  neck: Offset(.30, .48),
  hip: Offset(.62, .48),
  kneeL: Offset(.62, .68),
  ankleL: Offset(.70, .78),
  kneeR: Offset(.64, .70),
  ankleR: Offset(.72, .80),
  elbowL: Offset(.28, .62),
  handL: Offset(.28, .78),
  elbowR: Offset(.31, .63),
  handR: Offset(.31, .79),
);

const Pose _plankHands = Pose(
  head: Offset(.20, .46),
  neck: Offset(.29, .48),
  hip: Offset(.58, .52),
  kneeL: Offset(.73, .58),
  ankleL: Offset(.88, .64),
  kneeR: Offset(.74, .60),
  ankleR: Offset(.89, .66),
  elbowL: Offset(.27, .62),
  handL: Offset(.27, .78),
  elbowR: Offset(.30, .63),
  handR: Offset(.30, .79),
);

const Pose _supine = Pose(
  head: Offset(.18, .64),
  neck: Offset(.27, .66),
  hip: Offset(.56, .68),
  kneeL: Offset(.70, .68),
  ankleL: Offset(.86, .70),
  kneeR: Offset(.71, .70),
  ankleR: Offset(.87, .72),
  elbowL: Offset(.34, .72),
  handL: Offset(.44, .74),
  elbowR: Offset(.35, .74),
  handR: Offset(.45, .76),
);

const Pose _prone = Pose(
  head: Offset(.22, .62),
  neck: Offset(.30, .64),
  hip: Offset(.58, .66),
  kneeL: Offset(.72, .66),
  ankleL: Offset(.86, .66),
  kneeR: Offset(.73, .68),
  ankleR: Offset(.87, .68),
  elbowL: Offset(.16, .62),
  handL: Offset(.06, .62),
  elbowR: Offset(.17, .64),
  handR: Offset(.07, .64),
);

/// All animation archetypes, keyed by `Exercise.anim`.
const Map<String, List<Pose>> kPoseSets = {
  'march': [
    Pose(
      kneeL: Offset(.44, .62),
      ankleL: Offset(.47, .78),
      elbowR: Offset(.60, .34),
      handR: Offset(.60, .23),
    ),
    Pose(
      kneeR: Offset(.56, .62),
      ankleR: Offset(.53, .78),
      elbowL: Offset(.40, .34),
      handL: Offset(.40, .23),
    ),
  ],
  'highknees': [
    Pose(
      head: Offset(.50, .11),
      neck: Offset(.50, .22),
      hip: Offset(.50, .50),
      kneeL: Offset(.42, .52),
      ankleL: Offset(.46, .68),
      elbowR: Offset(.60, .30),
      handR: Offset(.60, .19),
    ),
    Pose(
      head: Offset(.50, .11),
      neck: Offset(.50, .22),
      hip: Offset(.50, .50),
      kneeR: Offset(.58, .52),
      ankleR: Offset(.54, .68),
      elbowL: Offset(.40, .30),
      handL: Offset(.40, .19),
    ),
  ],
  'fastfeet': [
    Pose(
      head: Offset(.50, .16),
      neck: Offset(.50, .27),
      hip: Offset(.50, .55),
      kneeL: Offset(.44, .70),
      ankleL: Offset(.44, .86),
      kneeR: Offset(.57, .72),
      ankleR: Offset(.57, .92),
      elbowL: Offset(.40, .40),
      handL: Offset(.44, .48),
      elbowR: Offset(.60, .40),
      handR: Offset(.56, .48),
    ),
    Pose(
      head: Offset(.50, .16),
      neck: Offset(.50, .27),
      hip: Offset(.50, .55),
      kneeL: Offset(.44, .72),
      ankleL: Offset(.44, .92),
      kneeR: Offset(.57, .70),
      ankleR: Offset(.57, .86),
      elbowL: Offset(.40, .40),
      handL: Offset(.44, .48),
      elbowR: Offset(.60, .40),
      handR: Offset(.56, .48),
    ),
  ],
  'jack': [
    _stand,
    Pose(
      kneeL: Offset(.36, .70),
      ankleL: Offset(.28, .90),
      kneeR: Offset(.64, .70),
      ankleR: Offset(.72, .90),
      elbowL: Offset(.34, .24),
      handL: Offset(.27, .09),
      elbowR: Offset(.66, .24),
      handR: Offset(.73, .09),
    ),
  ],
  'plankjack': [
    _plankHands,
    Pose(
      head: Offset(.20, .46),
      neck: Offset(.29, .48),
      hip: Offset(.58, .52),
      kneeL: Offset(.73, .52),
      ankleL: Offset(.88, .48),
      kneeR: Offset(.74, .66),
      ankleR: Offset(.89, .78),
      elbowL: Offset(.27, .62),
      handL: Offset(.27, .78),
      elbowR: Offset(.30, .63),
      handR: Offset(.30, .79),
    ),
  ],
  'squat': [
    _stand,
    Pose(
      head: Offset(.50, .30),
      neck: Offset(.50, .40),
      hip: Offset(.50, .66),
      kneeL: Offset(.39, .74),
      ankleL: Offset(.46, .92),
      kneeR: Offset(.61, .74),
      ankleR: Offset(.54, .92),
      elbowL: Offset(.40, .48),
      handL: Offset(.32, .44),
      elbowR: Offset(.60, .48),
      handR: Offset(.68, .44),
    ),
  ],
  'squatrock': [
    Pose(
      head: Offset(.46, .34),
      neck: Offset(.46, .44),
      hip: Offset(.46, .70),
      kneeL: Offset(.34, .74),
      ankleL: Offset(.42, .92),
      kneeR: Offset(.60, .74),
      ankleR: Offset(.54, .92),
      elbowL: Offset(.40, .52),
      handL: Offset(.36, .60),
      elbowR: Offset(.56, .52),
      handR: Offset(.60, .60),
    ),
    Pose(
      head: Offset(.54, .34),
      neck: Offset(.54, .44),
      hip: Offset(.54, .70),
      kneeL: Offset(.40, .74),
      ankleL: Offset(.46, .92),
      kneeR: Offset(.66, .74),
      ankleR: Offset(.58, .92),
      elbowL: Offset(.44, .52),
      handL: Offset(.40, .60),
      elbowR: Offset(.60, .52),
      handR: Offset(.64, .60),
    ),
  ],
  'jumpsquat': [
    Pose(
      head: Offset(.50, .30),
      neck: Offset(.50, .40),
      hip: Offset(.50, .66),
      kneeL: Offset(.39, .74),
      ankleL: Offset(.46, .92),
      kneeR: Offset(.61, .74),
      ankleR: Offset(.54, .92),
      elbowL: Offset(.42, .50),
      handL: Offset(.38, .60),
      elbowR: Offset(.58, .50),
      handR: Offset(.62, .60),
    ),
    Pose(
      head: Offset(.50, .06),
      neck: Offset(.50, .17),
      hip: Offset(.50, .45),
      kneeL: Offset(.45, .64),
      ankleL: Offset(.45, .82),
      kneeR: Offset(.55, .64),
      ankleR: Offset(.55, .82),
      elbowL: Offset(.38, .20),
      handL: Offset(.34, .06),
      elbowR: Offset(.62, .20),
      handR: Offset(.66, .06),
    ),
  ],
  'lunge': [
    _stand,
    Pose(
      head: Offset(.50, .20),
      neck: Offset(.50, .31),
      hip: Offset(.50, .58),
      kneeL: Offset(.36, .76),
      ankleL: Offset(.28, .90),
      kneeR: Offset(.63, .70),
      ankleR: Offset(.63, .92),
      elbowL: Offset(.44, .44),
      handL: Offset(.46, .56),
      elbowR: Offset(.56, .44),
      handR: Offset(.54, .56),
    ),
  ],
  'laterallunge': [
    _stand,
    Pose(
      head: Offset(.42, .22),
      neck: Offset(.43, .33),
      hip: Offset(.44, .60),
      kneeL: Offset(.34, .74),
      ankleL: Offset(.28, .92),
      kneeR: Offset(.62, .74),
      ankleR: Offset(.74, .92),
      elbowL: Offset(.40, .46),
      handL: Offset(.36, .56),
      elbowR: Offset(.50, .46),
      handR: Offset(.48, .56),
    ),
  ],
  'calfraise': [
    _stand,
    Pose(
      head: Offset(.50, .09),
      neck: Offset(.50, .20),
      hip: Offset(.50, .48),
      kneeL: Offset(.455, .68),
      ankleL: Offset(.455, .86),
      kneeR: Offset(.545, .68),
      ankleR: Offset(.545, .86),
      elbowL: Offset(.42, .34),
      handL: Offset(.42, .46),
      elbowR: Offset(.58, .34),
      handR: Offset(.58, .46),
    ),
  ],
  'wallsit': [
    Pose(
      head: Offset(.60, .28),
      neck: Offset(.60, .39),
      hip: Offset(.60, .64),
      kneeL: Offset(.40, .66),
      ankleL: Offset(.40, .90),
      kneeR: Offset(.42, .68),
      ankleR: Offset(.42, .92),
      elbowL: Offset(.54, .52),
      handL: Offset(.50, .62),
      elbowR: Offset(.56, .54),
      handR: Offset(.52, .64),
    ),
    Pose(
      head: Offset(.60, .30),
      neck: Offset(.60, .41),
      hip: Offset(.60, .66),
      kneeL: Offset(.40, .68),
      ankleL: Offset(.40, .90),
      kneeR: Offset(.42, .70),
      ankleR: Offset(.42, .92),
      elbowL: Offset(.54, .54),
      handL: Offset(.50, .64),
      elbowR: Offset(.56, .56),
      handR: Offset(.52, .66),
    ),
  ],
  'hinge': [
    _stand,
    Pose(
      head: Offset(.26, .40),
      neck: Offset(.35, .43),
      hip: Offset(.56, .52),
      kneeL: Offset(.54, .72),
      ankleL: Offset(.54, .92),
      kneeR: Offset(.56, .72),
      ankleR: Offset(.56, .92),
      elbowL: Offset(.38, .52),
      handL: Offset(.46, .62),
      elbowR: Offset(.40, .54),
      handR: Offset(.48, .64),
    ),
  ],
  'kickback': [
    _quad,
    Pose(
      head: Offset(.20, .46),
      neck: Offset(.30, .48),
      hip: Offset(.62, .48),
      kneeL: Offset(.74, .48),
      ankleL: Offset(.78, .32),
      kneeR: Offset(.64, .70),
      ankleR: Offset(.72, .80),
      elbowL: Offset(.28, .62),
      handL: Offset(.28, .78),
      elbowR: Offset(.31, .63),
      handR: Offset(.31, .79),
    ),
  ],
  'bridge': [
    Pose(
      head: Offset(.18, .66),
      neck: Offset(.27, .68),
      hip: Offset(.52, .74),
      kneeL: Offset(.68, .60),
      ankleL: Offset(.76, .80),
      kneeR: Offset(.69, .62),
      ankleR: Offset(.77, .82),
      elbowL: Offset(.32, .76),
      handL: Offset(.42, .80),
      elbowR: Offset(.33, .78),
      handR: Offset(.43, .82),
    ),
    Pose(
      head: Offset(.18, .66),
      neck: Offset(.27, .66),
      hip: Offset(.52, .58),
      kneeL: Offset(.68, .56),
      ankleL: Offset(.76, .80),
      kneeR: Offset(.69, .58),
      ankleR: Offset(.77, .82),
      elbowL: Offset(.32, .76),
      handL: Offset(.42, .80),
      elbowR: Offset(.33, .78),
      handR: Offset(.43, .82),
    ),
  ],
  'pushup': [
    _plankHands,
    Pose(
      head: Offset(.20, .58),
      neck: Offset(.29, .59),
      hip: Offset(.58, .60),
      kneeL: Offset(.73, .63),
      ankleL: Offset(.88, .66),
      kneeR: Offset(.74, .65),
      ankleR: Offset(.89, .68),
      elbowL: Offset(.22, .66),
      handL: Offset(.27, .78),
      elbowR: Offset(.25, .67),
      handR: Offset(.30, .79),
    ),
  ],
  'pikepush': [
    Pose(
      head: Offset(.26, .48),
      neck: Offset(.34, .44),
      hip: Offset(.62, .22),
      kneeL: Offset(.74, .48),
      ankleL: Offset(.84, .74),
      kneeR: Offset(.75, .50),
      ankleR: Offset(.85, .76),
      elbowL: Offset(.28, .60),
      handL: Offset(.26, .78),
      elbowR: Offset(.31, .61),
      handR: Offset(.29, .79),
    ),
    Pose(
      head: Offset(.22, .66),
      neck: Offset(.32, .56),
      hip: Offset(.62, .26),
      kneeL: Offset(.74, .50),
      ankleL: Offset(.84, .74),
      kneeR: Offset(.75, .52),
      ankleR: Offset(.85, .76),
      elbowL: Offset(.22, .64),
      handL: Offset(.26, .78),
      elbowR: Offset(.25, .65),
      handR: Offset(.29, .79),
    ),
  ],
  'dip': [
    Pose(
      head: Offset(.38, .28),
      neck: Offset(.40, .38),
      hip: Offset(.44, .60),
      kneeL: Offset(.64, .62),
      ankleL: Offset(.80, .74),
      kneeR: Offset(.65, .64),
      ankleR: Offset(.81, .76),
      elbowL: Offset(.34, .48),
      handL: Offset(.34, .62),
      elbowR: Offset(.36, .50),
      handR: Offset(.36, .64),
    ),
    Pose(
      head: Offset(.38, .38),
      neck: Offset(.40, .48),
      hip: Offset(.44, .70),
      kneeL: Offset(.64, .68),
      ankleL: Offset(.80, .74),
      kneeR: Offset(.65, .70),
      ankleR: Offset(.81, .76),
      elbowL: Offset(.30, .52),
      handL: Offset(.34, .62),
      elbowR: Offset(.32, .54),
      handR: Offset(.36, .64),
    ),
  ],
  'plank': [
    Pose(
      head: Offset(.18, .50),
      neck: Offset(.27, .52),
      hip: Offset(.56, .55),
      kneeL: Offset(.72, .60),
      ankleL: Offset(.88, .65),
      kneeR: Offset(.73, .62),
      ankleR: Offset(.89, .67),
      elbowL: Offset(.25, .72),
      handL: Offset(.13, .74),
      elbowR: Offset(.28, .73),
      handR: Offset(.16, .75),
    ),
    Pose(
      head: Offset(.18, .51),
      neck: Offset(.27, .53),
      hip: Offset(.56, .57),
      kneeL: Offset(.72, .61),
      ankleL: Offset(.88, .66),
      kneeR: Offset(.73, .63),
      ankleR: Offset(.89, .68),
      elbowL: Offset(.25, .72),
      handL: Offset(.13, .74),
      elbowR: Offset(.28, .73),
      handR: Offset(.16, .75),
    ),
  ],
  'sideplank': [
    Pose(
      head: Offset(.18, .40),
      neck: Offset(.27, .46),
      hip: Offset(.58, .58),
      kneeL: Offset(.74, .66),
      ankleL: Offset(.90, .74),
      kneeR: Offset(.75, .67),
      ankleR: Offset(.91, .75),
      elbowL: Offset(.25, .62),
      handL: Offset(.16, .74),
      elbowR: Offset(.34, .30),
      handR: Offset(.38, .18),
    ),
    Pose(
      head: Offset(.18, .44),
      neck: Offset(.27, .50),
      hip: Offset(.58, .68),
      kneeL: Offset(.74, .72),
      ankleL: Offset(.90, .76),
      kneeR: Offset(.75, .73),
      ankleR: Offset(.91, .77),
      elbowL: Offset(.25, .64),
      handL: Offset(.16, .74),
      elbowR: Offset(.34, .34),
      handR: Offset(.38, .22),
    ),
  ],
  'shouldertap': [
    _plankHands,
    Pose(
      head: Offset(.20, .46),
      neck: Offset(.29, .48),
      hip: Offset(.58, .52),
      kneeL: Offset(.73, .58),
      ankleL: Offset(.88, .64),
      kneeR: Offset(.74, .60),
      ankleR: Offset(.89, .66),
      elbowL: Offset(.24, .58),
      handL: Offset(.31, .50),
      elbowR: Offset(.30, .63),
      handR: Offset(.30, .79),
    ),
  ],
  'plankreach': [
    _plankHands,
    Pose(
      head: Offset(.20, .46),
      neck: Offset(.29, .48),
      hip: Offset(.58, .52),
      kneeL: Offset(.73, .58),
      ankleL: Offset(.88, .64),
      kneeR: Offset(.74, .60),
      ankleR: Offset(.89, .66),
      elbowL: Offset(.18, .50),
      handL: Offset(.06, .46),
      elbowR: Offset(.30, .63),
      handR: Offset(.30, .79),
    ),
  ],
  'mountainclimber': [
    _plankHands,
    Pose(
      head: Offset(.20, .46),
      neck: Offset(.29, .48),
      hip: Offset(.58, .52),
      kneeL: Offset(.44, .60),
      ankleL: Offset(.52, .70),
      kneeR: Offset(.74, .60),
      ankleR: Offset(.89, .66),
      elbowL: Offset(.27, .62),
      handL: Offset(.27, .78),
      elbowR: Offset(.30, .63),
      handR: Offset(.30, .79),
    ),
  ],
  'bearcrawl': [
    Pose(
      head: Offset(.20, .46),
      neck: Offset(.30, .48),
      hip: Offset(.62, .50),
      kneeL: Offset(.62, .66),
      ankleL: Offset(.70, .78),
      kneeR: Offset(.64, .68),
      ankleR: Offset(.72, .80),
      elbowL: Offset(.28, .62),
      handL: Offset(.28, .78),
      elbowR: Offset(.31, .63),
      handR: Offset(.31, .79),
    ),
    Pose(
      head: Offset(.16, .46),
      neck: Offset(.26, .48),
      hip: Offset(.58, .50),
      kneeL: Offset(.58, .64),
      ankleL: Offset(.66, .78),
      kneeR: Offset(.62, .68),
      ankleR: Offset(.72, .80),
      elbowL: Offset(.20, .60),
      handL: Offset(.18, .78),
      elbowR: Offset(.31, .63),
      handR: Offset(.31, .79),
    ),
  ],
  'burpee': [
    _stand,
    Pose(
      head: Offset(.46, .40),
      neck: Offset(.46, .50),
      hip: Offset(.52, .70),
      kneeL: Offset(.44, .78),
      ankleL: Offset(.50, .92),
      kneeR: Offset(.60, .78),
      ankleR: Offset(.56, .92),
      elbowL: Offset(.34, .62),
      handL: Offset(.30, .84),
      elbowR: Offset(.38, .64),
      handR: Offset(.34, .86),
    ),
    _plankHands,
  ],
  'skater': [
    Pose(
      head: Offset(.38, .20),
      neck: Offset(.40, .31),
      hip: Offset(.44, .58),
      kneeL: Offset(.36, .74),
      ankleL: Offset(.30, .92),
      kneeR: Offset(.56, .70),
      ankleR: Offset(.66, .80),
      elbowL: Offset(.30, .40),
      handL: Offset(.22, .46),
      elbowR: Offset(.48, .46),
      handR: Offset(.44, .56),
    ),
    Pose(
      head: Offset(.62, .20),
      neck: Offset(.60, .31),
      hip: Offset(.56, .58),
      kneeL: Offset(.44, .70),
      ankleL: Offset(.34, .80),
      kneeR: Offset(.64, .74),
      ankleR: Offset(.70, .92),
      elbowL: Offset(.52, .46),
      handL: Offset(.56, .56),
      elbowR: Offset(.70, .40),
      handR: Offset(.78, .46),
    ),
  ],
  'shadowbox': [
    Pose(
      elbowL: Offset(.34, .34),
      handL: Offset(.22, .30),
      elbowR: Offset(.56, .34),
      handR: Offset(.54, .24),
      kneeL: Offset(.44, .72),
      ankleL: Offset(.40, .92),
      kneeR: Offset(.56, .72),
      ankleR: Offset(.60, .92),
    ),
    Pose(
      elbowL: Offset(.44, .34),
      handL: Offset(.46, .24),
      elbowR: Offset(.66, .34),
      handR: Offset(.78, .30),
      kneeL: Offset(.44, .72),
      ankleL: Offset(.40, .92),
      kneeR: Offset(.56, .72),
      ankleR: Offset(.60, .92),
    ),
  ],
  'deadbug': [
    Pose(
      head: Offset(.18, .66),
      neck: Offset(.27, .68),
      hip: Offset(.56, .70),
      kneeL: Offset(.62, .50),
      ankleL: Offset(.74, .50),
      kneeR: Offset(.64, .52),
      ankleR: Offset(.76, .52),
      elbowL: Offset(.30, .56),
      handL: Offset(.30, .42),
      elbowR: Offset(.33, .58),
      handR: Offset(.33, .44),
    ),
    Pose(
      head: Offset(.18, .66),
      neck: Offset(.27, .68),
      hip: Offset(.56, .70),
      kneeL: Offset(.70, .64),
      ankleL: Offset(.88, .68),
      kneeR: Offset(.64, .52),
      ankleR: Offset(.76, .52),
      elbowL: Offset(.18, .56),
      handL: Offset(.06, .58),
      elbowR: Offset(.33, .58),
      handR: Offset(.33, .44),
    ),
  ],
  'birddog': [
    _quad,
    Pose(
      head: Offset(.20, .46),
      neck: Offset(.30, .48),
      hip: Offset(.62, .48),
      kneeL: Offset(.74, .46),
      ankleL: Offset(.90, .44),
      kneeR: Offset(.64, .70),
      ankleR: Offset(.72, .80),
      elbowL: Offset(.20, .46),
      handL: Offset(.06, .44),
      elbowR: Offset(.31, .63),
      handR: Offset(.31, .79),
    ),
  ],
  'hollow': [
    Pose(
      head: Offset(.20, .60),
      neck: Offset(.29, .62),
      hip: Offset(.56, .68),
      kneeL: Offset(.72, .62),
      ankleL: Offset(.88, .58),
      kneeR: Offset(.73, .64),
      ankleR: Offset(.89, .60),
      elbowL: Offset(.16, .58),
      handL: Offset(.06, .56),
      elbowR: Offset(.17, .60),
      handR: Offset(.07, .58),
    ),
    Pose(
      head: Offset(.20, .62),
      neck: Offset(.29, .64),
      hip: Offset(.56, .70),
      kneeL: Offset(.72, .64),
      ankleL: Offset(.88, .62),
      kneeR: Offset(.73, .66),
      ankleR: Offset(.89, .64),
      elbowL: Offset(.16, .60),
      handL: Offset(.06, .60),
      elbowR: Offset(.17, .62),
      handR: Offset(.07, .62),
    ),
  ],
  'legraise': [
    Pose(
      head: Offset(.18, .68),
      neck: Offset(.27, .70),
      hip: Offset(.56, .72),
      kneeL: Offset(.58, .52),
      ankleL: Offset(.60, .32),
      kneeR: Offset(.60, .54),
      ankleR: Offset(.62, .34),
      elbowL: Offset(.34, .76),
      handL: Offset(.46, .78),
      elbowR: Offset(.35, .78),
      handR: Offset(.47, .80),
    ),
    Pose(
      head: Offset(.18, .68),
      neck: Offset(.27, .70),
      hip: Offset(.56, .72),
      kneeL: Offset(.72, .68),
      ankleL: Offset(.88, .66),
      kneeR: Offset(.73, .70),
      ankleR: Offset(.89, .68),
      elbowL: Offset(.34, .76),
      handL: Offset(.46, .78),
      elbowR: Offset(.35, .78),
      handR: Offset(.47, .80),
    ),
  ],
  'bicycle': [
    Pose(
      head: Offset(.22, .62),
      neck: Offset(.30, .66),
      hip: Offset(.56, .70),
      kneeL: Offset(.50, .54),
      ankleL: Offset(.58, .46),
      kneeR: Offset(.72, .66),
      ankleR: Offset(.88, .64),
      elbowL: Offset(.32, .54),
      handL: Offset(.24, .58),
      elbowR: Offset(.42, .58),
      handR: Offset(.30, .60),
    ),
    Pose(
      head: Offset(.22, .62),
      neck: Offset(.30, .66),
      hip: Offset(.56, .70),
      kneeL: Offset(.72, .68),
      ankleL: Offset(.88, .66),
      kneeR: Offset(.52, .56),
      ankleR: Offset(.60, .48),
      elbowL: Offset(.42, .58),
      handL: Offset(.30, .60),
      elbowR: Offset(.32, .54),
      handR: Offset(.24, .58),
    ),
  ],
  'kneetuck': [
    Pose(
      head: Offset(.28, .40),
      neck: Offset(.34, .50),
      hip: Offset(.46, .70),
      kneeL: Offset(.60, .54),
      ankleL: Offset(.68, .64),
      kneeR: Offset(.62, .56),
      ankleR: Offset(.70, .66),
      elbowL: Offset(.30, .60),
      handL: Offset(.26, .78),
      elbowR: Offset(.32, .62),
      handR: Offset(.28, .80),
    ),
    Pose(
      head: Offset(.28, .44),
      neck: Offset(.34, .54),
      hip: Offset(.46, .72),
      kneeL: Offset(.68, .64),
      ankleL: Offset(.88, .62),
      kneeR: Offset(.70, .66),
      ankleR: Offset(.90, .64),
      elbowL: Offset(.30, .62),
      handL: Offset(.26, .80),
      elbowR: Offset(.32, .64),
      handR: Offset(.28, .82),
    ),
  ],
  'superman': [
    _prone,
    Pose(
      head: Offset(.22, .54),
      neck: Offset(.30, .58),
      hip: Offset(.58, .66),
      kneeL: Offset(.72, .62),
      ankleL: Offset(.86, .56),
      kneeR: Offset(.73, .64),
      ankleR: Offset(.87, .58),
      elbowL: Offset(.16, .52),
      handL: Offset(.06, .48),
      elbowR: Offset(.17, .54),
      handR: Offset(.07, .50),
    ),
  ],
  'catcow': [
    Pose(
      head: Offset(.20, .52),
      neck: Offset(.30, .50),
      hip: Offset(.62, .50),
      kneeL: Offset(.62, .68),
      ankleL: Offset(.70, .78),
      kneeR: Offset(.64, .70),
      ankleR: Offset(.72, .80),
      elbowL: Offset(.28, .62),
      handL: Offset(.28, .78),
      elbowR: Offset(.31, .63),
      handR: Offset(.31, .79),
    ),
    Pose(
      head: Offset(.20, .42),
      neck: Offset(.30, .44),
      hip: Offset(.62, .44),
      kneeL: Offset(.62, .68),
      ankleL: Offset(.70, .78),
      kneeR: Offset(.64, .70),
      ankleR: Offset(.72, .80),
      elbowL: Offset(.28, .60),
      handL: Offset(.28, .78),
      elbowR: Offset(.31, .61),
      handR: Offset(.31, .79),
    ),
  ],
  'downdog': [
    Pose(
      head: Offset(.26, .48),
      neck: Offset(.34, .44),
      hip: Offset(.62, .20),
      kneeL: Offset(.74, .48),
      ankleL: Offset(.84, .76),
      kneeR: Offset(.75, .50),
      ankleR: Offset(.85, .78),
      elbowL: Offset(.28, .60),
      handL: Offset(.26, .78),
      elbowR: Offset(.31, .61),
      handR: Offset(.29, .79),
    ),
    Pose(
      head: Offset(.26, .48),
      neck: Offset(.34, .44),
      hip: Offset(.62, .22),
      kneeL: Offset(.72, .46),
      ankleL: Offset(.80, .68),
      kneeR: Offset(.75, .52),
      ankleR: Offset(.85, .78),
      elbowL: Offset(.28, .60),
      handL: Offset(.26, .78),
      elbowR: Offset(.31, .61),
      handR: Offset(.29, .79),
    ),
  ],
  'childpose': [
    Pose(
      head: Offset(.24, .64),
      neck: Offset(.34, .62),
      hip: Offset(.64, .56),
      kneeL: Offset(.66, .74),
      ankleL: Offset(.80, .78),
      kneeR: Offset(.68, .76),
      ankleR: Offset(.82, .80),
      elbowL: Offset(.18, .66),
      handL: Offset(.06, .68),
      elbowR: Offset(.19, .68),
      handR: Offset(.07, .70),
    ),
    Pose(
      head: Offset(.24, .66),
      neck: Offset(.34, .64),
      hip: Offset(.64, .58),
      kneeL: Offset(.66, .76),
      ankleL: Offset(.80, .80),
      kneeR: Offset(.68, .78),
      ankleR: Offset(.82, .82),
      elbowL: Offset(.18, .68),
      handL: Offset(.06, .70),
      elbowR: Offset(.19, .70),
      handR: Offset(.07, .72),
    ),
  ],
  'fold': [
    Pose(
      head: Offset(.34, .40),
      neck: Offset(.38, .50),
      hip: Offset(.44, .72),
      kneeL: Offset(.62, .74),
      ankleL: Offset(.80, .76),
      kneeR: Offset(.63, .76),
      ankleR: Offset(.81, .78),
      elbowL: Offset(.46, .52),
      handL: Offset(.58, .62),
      elbowR: Offset(.47, .54),
      handR: Offset(.59, .64),
    ),
    Pose(
      head: Offset(.44, .52),
      neck: Offset(.44, .58),
      hip: Offset(.44, .74),
      kneeL: Offset(.62, .76),
      ankleL: Offset(.80, .78),
      kneeR: Offset(.63, .78),
      ankleR: Offset(.81, .80),
      elbowL: Offset(.56, .60),
      handL: Offset(.70, .70),
      elbowR: Offset(.57, .62),
      handR: Offset(.71, .72),
    ),
  ],
  'legsup': [
    Pose(
      head: Offset(.16, .70),
      neck: Offset(.26, .72),
      hip: Offset(.58, .74),
      kneeL: Offset(.60, .52),
      ankleL: Offset(.62, .30),
      kneeR: Offset(.62, .54),
      ankleR: Offset(.64, .32),
      elbowL: Offset(.28, .80),
      handL: Offset(.40, .84),
      elbowR: Offset(.29, .82),
      handR: Offset(.41, .86),
    ),
    Pose(
      head: Offset(.16, .71),
      neck: Offset(.26, .73),
      hip: Offset(.58, .75),
      kneeL: Offset(.60, .53),
      ankleL: Offset(.62, .32),
      kneeR: Offset(.62, .55),
      ankleR: Offset(.64, .34),
      elbowL: Offset(.28, .81),
      handL: Offset(.40, .85),
      elbowR: Offset(.29, .83),
      handR: Offset(.41, .87),
    ),
  ],
  'figurefour': [
    Pose(
      head: Offset(.18, .70),
      neck: Offset(.27, .72),
      hip: Offset(.56, .74),
      kneeL: Offset(.60, .54),
      ankleL: Offset(.72, .60),
      kneeR: Offset(.66, .58),
      ankleR: Offset(.60, .74),
      elbowL: Offset(.36, .66),
      handL: Offset(.50, .60),
      elbowR: Offset(.38, .68),
      handR: Offset(.52, .62),
    ),
    Pose(
      head: Offset(.18, .70),
      neck: Offset(.27, .72),
      hip: Offset(.56, .74),
      kneeL: Offset(.56, .50),
      ankleL: Offset(.68, .56),
      kneeR: Offset(.62, .54),
      ankleR: Offset(.56, .70),
      elbowL: Offset(.34, .62),
      handL: Offset(.46, .56),
      elbowR: Offset(.36, .64),
      handR: Offset(.48, .58),
    ),
  ],
  'hipflexor': [
    Pose(
      head: Offset(.44, .28),
      neck: Offset(.44, .38),
      hip: Offset(.46, .62),
      kneeL: Offset(.34, .78),
      ankleL: Offset(.26, .88),
      kneeR: Offset(.62, .68),
      ankleR: Offset(.62, .90),
      elbowL: Offset(.40, .50),
      handL: Offset(.44, .60),
      elbowR: Offset(.52, .50),
      handR: Offset(.56, .60),
    ),
    Pose(
      head: Offset(.48, .26),
      neck: Offset(.48, .36),
      hip: Offset(.50, .60),
      kneeL: Offset(.34, .78),
      ankleL: Offset(.26, .88),
      kneeR: Offset(.64, .68),
      ankleR: Offset(.64, .90),
      elbowL: Offset(.44, .48),
      handL: Offset(.48, .58),
      elbowR: Offset(.56, .48),
      handR: Offset(.60, .58),
    ),
  ],
  'quadstretch': [
    Pose(
      kneeL: Offset(.48, .70),
      ankleL: Offset(.40, .58),
      kneeR: Offset(.55, .72),
      ankleR: Offset(.55, .92),
      elbowL: Offset(.44, .48),
      handL: Offset(.42, .60),
      elbowR: Offset(.62, .34),
      handR: Offset(.72, .30),
    ),
    Pose(
      kneeL: Offset(.48, .70),
      ankleL: Offset(.42, .56),
      kneeR: Offset(.55, .72),
      ankleR: Offset(.55, .92),
      elbowL: Offset(.44, .46),
      handL: Offset(.42, .58),
      elbowR: Offset(.62, .32),
      handR: Offset(.72, .28),
    ),
  ],
  'calfstretch': [
    Pose(
      head: Offset(.56, .18),
      neck: Offset(.54, .29),
      hip: Offset(.46, .54),
      kneeL: Offset(.36, .72),
      ankleL: Offset(.30, .92),
      kneeR: Offset(.58, .70),
      ankleR: Offset(.62, .92),
      elbowL: Offset(.62, .30),
      handL: Offset(.74, .28),
      elbowR: Offset(.64, .32),
      handR: Offset(.76, .30),
    ),
    Pose(
      head: Offset(.58, .20),
      neck: Offset(.56, .31),
      hip: Offset(.44, .56),
      kneeL: Offset(.34, .74),
      ankleL: Offset(.28, .92),
      kneeR: Offset(.58, .72),
      ankleR: Offset(.62, .92),
      elbowL: Offset(.64, .32),
      handL: Offset(.76, .30),
      elbowR: Offset(.66, .34),
      handR: Offset(.78, .32),
    ),
  ],
  'chestopener': [
    Pose(
      elbowL: Offset(.30, .34),
      handL: Offset(.20, .26),
      elbowR: Offset(.58, .38),
      handR: Offset(.56, .50),
    ),
    Pose(
      head: Offset(.54, .14),
      neck: Offset(.53, .25),
      elbowL: Offset(.28, .32),
      handL: Offset(.16, .24),
      elbowR: Offset(.62, .38),
      handR: Offset(.62, .50),
    ),
  ],
  'seatedtwist': [
    Pose(
      head: Offset(.42, .32),
      neck: Offset(.42, .42),
      hip: Offset(.42, .70),
      kneeL: Offset(.58, .70),
      ankleL: Offset(.74, .78),
      kneeR: Offset(.56, .74),
      ankleR: Offset(.72, .82),
      elbowL: Offset(.34, .54),
      handL: Offset(.30, .68),
      elbowR: Offset(.50, .52),
      handR: Offset(.58, .62),
    ),
    Pose(
      head: Offset(.36, .32),
      neck: Offset(.38, .42),
      hip: Offset(.42, .70),
      kneeL: Offset(.58, .70),
      ankleL: Offset(.74, .78),
      kneeR: Offset(.56, .74),
      ankleR: Offset(.72, .82),
      elbowL: Offset(.28, .52),
      handL: Offset(.24, .66),
      elbowR: Offset(.48, .50),
      handR: Offset(.56, .58),
    ),
  ],
  'neckrelease': [
    Pose(head: Offset(.45, .15), neck: Offset(.50, .25)),
    Pose(head: Offset(.55, .15), neck: Offset(.50, .25)),
  ],
  'shoulderroll': [
    Pose(elbowL: Offset(.40, .36), handL: Offset(.41, .49), elbowR: Offset(.60, .36), handR: Offset(.59, .49)),
    Pose(elbowL: Offset(.43, .40), handL: Offset(.43, .52), elbowR: Offset(.57, .40), handR: Offset(.57, .52)),
  ],
  'armcircle': [
    Pose(elbowL: Offset(.36, .30), handL: Offset(.24, .24), elbowR: Offset(.64, .30), handR: Offset(.76, .24)),
    Pose(elbowL: Offset(.36, .42), handL: Offset(.26, .54), elbowR: Offset(.64, .42), handR: Offset(.74, .54)),
    Pose(elbowL: Offset(.38, .24), handL: Offset(.34, .10), elbowR: Offset(.62, .24), handR: Offset(.66, .10)),
  ],
  'hipcircle': [
    Pose(
      hip: Offset(.44, .52),
      kneeL: Offset(.44, .72),
      kneeR: Offset(.54, .72),
      elbowL: Offset(.38, .40),
      handL: Offset(.44, .50),
      elbowR: Offset(.56, .40),
      handR: Offset(.50, .50),
    ),
    Pose(
      hip: Offset(.56, .52),
      kneeL: Offset(.46, .72),
      kneeR: Offset(.56, .72),
      elbowL: Offset(.50, .40),
      handL: Offset(.56, .50),
      elbowR: Offset(.62, .40),
      handR: Offset(.62, .50),
    ),
  ],
  'anklerock': [
    Pose(
      head: Offset(.53, .13),
      neck: Offset(.52, .24),
      hip: Offset(.50, .52),
      ankleL: Offset(.44, .90),
      ankleR: Offset(.53, .90),
    ),
    Pose(
      head: Offset(.47, .13),
      neck: Offset(.48, .24),
      hip: Offset(.50, .52),
      ankleL: Offset(.47, .90),
      ankleR: Offset(.56, .90),
    ),
  ],
  'sidebend': [
    Pose(
      head: Offset(.42, .17),
      neck: Offset(.45, .27),
      hip: Offset(.52, .52),
      elbowL: Offset(.36, .28),
      handL: Offset(.30, .12),
      elbowR: Offset(.56, .42),
      handR: Offset(.54, .54),
    ),
    Pose(
      head: Offset(.58, .17),
      neck: Offset(.55, .27),
      hip: Offset(.48, .52),
      elbowL: Offset(.44, .42),
      handL: Offset(.46, .54),
      elbowR: Offset(.64, .28),
      handR: Offset(.70, .12),
    ),
  ],
  'torsotwist': [
    Pose(
      elbowL: Offset(.36, .38),
      handL: Offset(.30, .48),
      elbowR: Offset(.54, .36),
      handR: Offset(.42, .40),
    ),
    Pose(
      elbowL: Offset(.46, .36),
      handL: Offset(.58, .40),
      elbowR: Offset(.64, .38),
      handR: Offset(.70, .48),
    ),
  ],
  'legswing': [
    Pose(
      kneeL: Offset(.40, .66),
      ankleL: Offset(.32, .78),
      kneeR: Offset(.55, .72),
      ankleR: Offset(.55, .92),
      elbowR: Offset(.64, .36),
      handR: Offset(.72, .34),
    ),
    Pose(
      kneeL: Offset(.52, .70),
      ankleL: Offset(.62, .84),
      kneeR: Offset(.55, .72),
      ankleR: Offset(.55, .92),
      elbowR: Offset(.64, .36),
      handR: Offset(.72, .34),
    ),
  ],
  'inchworm': [
    _stand,
    Pose(
      head: Offset(.36, .48),
      neck: Offset(.40, .56),
      hip: Offset(.50, .68),
      kneeL: Offset(.52, .78),
      ankleL: Offset(.52, .92),
      kneeR: Offset(.54, .78),
      ankleR: Offset(.54, .92),
      elbowL: Offset(.34, .66),
      handL: Offset(.30, .84),
      elbowR: Offset(.36, .68),
      handR: Offset(.32, .86),
    ),
    _plankHands,
  ],
  'breathe': [
    Pose(elbowL: Offset(.42, .38), handL: Offset(.44, .50), elbowR: Offset(.58, .38), handR: Offset(.56, .50)),
    Pose(
      head: Offset(.50, .11),
      neck: Offset(.50, .22),
      elbowL: Offset(.36, .28),
      handL: Offset(.32, .14),
      elbowR: Offset(.64, .28),
      handR: Offset(.68, .14),
    ),
  ],
};

/// Draws a single exercise animation, looping start -> movement -> start.
class ExerciseAnimation extends StatefulWidget {
  final String anim;
  final Color color;
  final double strokeWidth;

  /// Pause the loop (used when the workout timer is paused).
  final bool playing;

  const ExerciseAnimation({
    super.key,
    required this.anim,
    required this.color,
    this.strokeWidth = 7,
    this.playing = true,
  });

  @override
  State<ExerciseAnimation> createState() => _ExerciseAnimationState();
}

class _ExerciseAnimationState extends State<ExerciseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.playing) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant ExerciseAnimation old) {
    super.didUpdateWidget(old);
    if (widget.playing && !_c.isAnimating) {
      _c.repeat(reverse: true);
    } else if (!widget.playing && _c.isAnimating) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final poses = kPoseSets[widget.anim] ?? kPoseSets['breathe']!;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final eased = Curves.easeInOut.transform(_c.value);
        final span = poses.length - 1;
        final scaled = (eased * span).clamp(0, span.toDouble());
        final i = scaled.floor().clamp(0, span - 1 < 0 ? 0 : span - 1);
        final t = span == 0 ? 0.0 : scaled - i;
        final pose = span == 0
            ? poses.first
            : Pose.lerp(poses[i], poses[i + 1], t);
        return CustomPaint(
          painter: _FigurePainter(
            pose: pose,
            color: widget.color,
            stroke: widget.strokeWidth,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _FigurePainter extends CustomPainter {
  final Pose pose;
  final Color color;
  final double stroke;

  _FigurePainter({required this.pose, required this.color, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Offset p(Offset o) => Offset(o.dx * size.width, o.dy * size.height);

    final line = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final floor = Paint()
      ..color = color.withValues(alpha: .16)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * .06, size.height * .955),
      Offset(size.width * .94, size.height * .955),
      floor,
    );

    // Limbs, drawn slightly lighter on the far side for a sense of depth.
    final far = Paint()
      ..color = color.withValues(alpha: .45)
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      Path()
        ..moveTo(p(pose.hip).dx, p(pose.hip).dy)
        ..lineTo(p(pose.kneeR).dx, p(pose.kneeR).dy)
        ..lineTo(p(pose.ankleR).dx, p(pose.ankleR).dy),
      far,
    );
    canvas.drawPath(
      Path()
        ..moveTo(p(pose.neck).dx, p(pose.neck).dy)
        ..lineTo(p(pose.elbowR).dx, p(pose.elbowR).dy)
        ..lineTo(p(pose.handR).dx, p(pose.handR).dy),
      far,
    );

    canvas.drawLine(p(pose.neck), p(pose.hip), line);
    canvas.drawPath(
      Path()
        ..moveTo(p(pose.hip).dx, p(pose.hip).dy)
        ..lineTo(p(pose.kneeL).dx, p(pose.kneeL).dy)
        ..lineTo(p(pose.ankleL).dx, p(pose.ankleL).dy),
      line,
    );
    canvas.drawPath(
      Path()
        ..moveTo(p(pose.neck).dx, p(pose.neck).dy)
        ..lineTo(p(pose.elbowL).dx, p(pose.elbowL).dy)
        ..lineTo(p(pose.handL).dx, p(pose.handL).dy),
      line,
    );

    final headR = size.shortestSide * .062;
    canvas.drawCircle(
      p(pose.head),
      headR,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.drawLine(p(pose.head), p(pose.neck), line);
  }

  @override
  bool shouldRepaint(covariant _FigurePainter old) =>
      old.pose != pose || old.color != color;
}
