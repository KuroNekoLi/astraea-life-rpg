import 'dart:collection';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Presentation-only side of a combatant in the battlefield viewport.
enum CombatStageSide { player, enemy }

/// Terminal result used only to choose the scene's stable visual pose.
enum CombatStageOutcome { active, victory, defeat }

/// A resolved event translated by the application layer into a visual cue.
///
/// This type intentionally has no command, damage, RNG, or rule fields. The
/// cue id should be stable for one resolved event so widget rebuilds do not
/// replay an animation.
enum CombatStageCueKind {
  actorFocus,
  attackHit,
  attackMiss,
  criticalHit,
  cast,
  analysisReveal,
  interrupt,
  victory,
  defeat,
}

@immutable
class CombatStageCombatantView {
  const CombatStageCombatantView({
    required this.id,
    required this.side,
    this.defeated = false,
  }) : assert(id != '');

  final String id;
  final CombatStageSide side;
  final bool defeated;
}

/// Small immutable view of the already-resolved battle state needed to stage
/// placeholder combatant geometry. HUD values and Function Graph data remain
/// in Flutter's accessible overlay.
@immutable
class CombatStageSnapshot {
  CombatStageSnapshot({
    required this.battleId,
    required this.revision,
    required Iterable<CombatStageCombatantView> combatants,
    required this.activeCombatantId,
    required this.outcome,
  }) : combatants = List.unmodifiable(combatants) {
    if (battleId.trim().isEmpty || revision < 0) {
      throw ArgumentError('Battle id and non-negative revision are required.');
    }
    if (this.combatants.map((unit) => unit.id).toSet().length !=
        this.combatants.length) {
      throw ArgumentError('Combatant ids must be unique.');
    }
  }

  final String battleId;
  final int revision;
  final List<CombatStageCombatantView> combatants;
  final String? activeCombatantId;
  final CombatStageOutcome outcome;
}

/// A visual cue derived from a completed combat/function resolution.
@immutable
class CombatStageCue {
  const CombatStageCue({
    required this.id,
    required this.kind,
    this.actorId,
    this.targetId,
  }) : assert(id != '');

  final String id;
  final CombatStageCueKind kind;
  final String? actorId;
  final String? targetId;
}

/// A non-interactive Flame viewport for the battlefield scene.
///
/// The containing Flutter route owns screen-reader text, HUD, Function Graph,
/// controls, interaction, and all domain commands. Place those Flutter widgets
/// as Stack siblings above this viewport. The canvas is clipped, ignores
/// pointer input, and is excluded from semantics.
class CombatBattleStage extends StatefulWidget {
  const CombatBattleStage({
    required this.snapshot,
    this.cue,
    this.reducedMotion = false,
    this.skipAnimations = false,
    this.paused = false,
    super.key,
  });

  final CombatStageSnapshot snapshot;
  final CombatStageCue? cue;
  final bool reducedMotion;
  final bool skipAnimations;
  final bool paused;

  @override
  State<CombatBattleStage> createState() => _CombatBattleStageState();
}

class _CombatBattleStageState extends State<CombatBattleStage>
    with WidgetsBindingObserver {
  late final _CombatStageGame _game;
  late bool _tickerEnabled;
  late bool _appResumed;
  bool _mediaReducedMotion = false;

  bool get _shouldReduceMotion =>
      widget.reducedMotion || _mediaReducedMotion || widget.skipAnimations;

  bool get _shouldPause => widget.paused || !_appResumed || !_tickerEnabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tickerEnabled = true;
    _appResumed =
        SchedulerBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _game = _CombatStageGame(widget.snapshot);
    _game.setReducedMotion(_shouldReduceMotion);
    _game.setPaused(_shouldPause);
    if (widget.cue case final cue?) {
      _game.consumeCue(cue);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tickerEnabled = TickerMode.valuesOf(context).enabled;
    _mediaReducedMotion = MediaQuery.of(context).disableAnimations;
    _game.setReducedMotion(_shouldReduceMotion);
    _game.setPaused(_shouldPause);
  }

  @override
  void didUpdateWidget(covariant CombatBattleStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _game.updateSnapshot(widget.snapshot);
    _game.setReducedMotion(_shouldReduceMotion);
    _game.setPaused(_shouldPause);

    final cue = widget.cue;
    if (cue != null && cue.id != oldWidget.cue?.id) {
      _game.consumeCue(cue);
    }
    if (widget.skipAnimations && !oldWidget.skipAnimations) {
      _game.finishCurrentCue();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appResumed = state == AppLifecycleState.resumed;
    _game.setPaused(_shouldPause);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ClipRect(
    child: ExcludeSemantics(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: GameWidget<_CombatStageGame>(
            game: _game,
            behavior: HitTestBehavior.deferToChild,
            autofocus: false,
          ),
        ),
      ),
    ),
  );
}

class _CombatStageGame extends FlameGame {
  _CombatStageGame(CombatStageSnapshot snapshot) : _snapshot = snapshot {
    world.add(_BattlefieldScene(this));
  }

  CombatStageSnapshot _snapshot;
  CombatStageCue? _cue;
  final LinkedHashSet<String> _consumedCueIds = LinkedHashSet<String>();
  double _elapsed = 0;
  double _cueElapsed = 0;
  bool _reducedMotion = false;
  bool _externallyPaused = false;
  bool _disposed = false;

  CombatStageSnapshot get snapshot => _snapshot;
  CombatStageCue? get cue => _cue;
  bool get isReducedMotion => _reducedMotion;

  double get cueProgress {
    final cue = _cue;
    if (cue == null) return 1;
    if (_reducedMotion) return 1;
    final duration = _durationFor(cue.kind);
    return (_cueElapsed / duration).clamp(0.0, 1.0);
  }

  double get elapsed => _elapsed;

  void updateSnapshot(CombatStageSnapshot snapshot) {
    // Snapshot replacement changes only the stable pose; it never replays an
    // earlier event. The battle id is included in cue identity by callers.
    _snapshot = snapshot;
  }

  void consumeCue(CombatStageCue cue) {
    if (!_consumedCueIds.add(cue.id)) return;
    if (_consumedCueIds.length > 96) {
      _consumedCueIds.remove(_consumedCueIds.first);
    }
    _cue = cue;
    _cueElapsed = _reducedMotion ? _durationFor(cue.kind) : 0;
  }

  void setReducedMotion(bool reduced) {
    if (_reducedMotion == reduced) return;
    _reducedMotion = reduced;
    if (reduced) finishCurrentCue();
  }

  void setPaused(bool paused) {
    if (_disposed || _externallyPaused == paused) return;
    _externallyPaused = paused;
    if (paused) {
      pauseEngine();
    } else {
      resumeEngine();
    }
  }

  void finishCurrentCue() {
    final cue = _cue;
    if (cue != null) _cueElapsed = _durationFor(cue.kind);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_externallyPaused) return;
    _elapsed += dt;
    if (_cue case final cue?) {
      _cueElapsed = (_cueElapsed + dt).clamp(0, _durationFor(cue.kind));
    }
  }

  @override
  void onDispose() {
    _disposed = true;
    super.onDispose();
  }

  static double _durationFor(CombatStageCueKind kind) => switch (kind) {
    CombatStageCueKind.actorFocus => .48,
    CombatStageCueKind.attackHit => .72,
    CombatStageCueKind.attackMiss => .66,
    CombatStageCueKind.criticalHit => .88,
    CombatStageCueKind.cast => .82,
    CombatStageCueKind.analysisReveal => .62,
    CombatStageCueKind.interrupt => .84,
    CombatStageCueKind.victory => .96,
    CombatStageCueKind.defeat => .9,
  };
}

/// Self-authored procedural geometry for placeholder staging. All motion is
/// driven by [_CombatStageGame] presentation time and cues; no gameplay state
/// is calculated here.
class _BattlefieldScene extends Component
    with HasGameReference<_CombatStageGame> {
  _BattlefieldScene(this._stageGame);

  final _CombatStageGame _stageGame;

  @override
  void render(Canvas canvas) {
    final width = _stageGame.canvasSize.x;
    final height = _stageGame.canvasSize.y;
    if (width <= 0 || height <= 0) return;

    final bounds = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff111b3c), Color(0xff26355e), Color(0xff111a35)],
          stops: [0, .62, 1],
        ).createShader(bounds),
    );
    _drawAtmosphere(canvas, width, height);
    _drawArchitecture(canvas, width, height);
    _drawArenaFloor(canvas, width, height);

    final player = _firstUnit(CombatStageSide.player);
    final enemy = _firstUnit(CombatStageSide.enemy);
    if (player != null) _drawPlayer(canvas, width, height, player.id);
    if (enemy != null) _drawConstruct(canvas, width, height, enemy.id);
    _drawCue(canvas, width, height);
  }

  CombatStageCombatantView? _firstUnit(CombatStageSide side) {
    for (final unit in _stageGame.snapshot.combatants) {
      if (unit.side == side) return unit;
    }
    return null;
  }

  void _drawAtmosphere(Canvas canvas, double width, double height) {
    final phase = _stageGame.elapsed;
    final motePaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 20; i++) {
      final x = ((i * 79.0 + 31) % width).toDouble();
      final y = (height * (.08 + ((i * 37) % 53) / 100));
      final pulse =
          _stageGame.snapshot.outcome == CombatStageOutcome.active &&
              !_stageGame.isReducedMotion
          ? .18 + .14 * (math.sin(phase * .75 + i) + 1) / 2
          : .22;
      motePaint.color = const Color(0xffb7dcff).withValues(alpha: pulse);
      canvas.drawCircle(Offset(x, y), i % 4 == 0 ? 1.7 : 1.0, motePaint);
    }
  }

  void _drawArchitecture(Canvas canvas, double width, double height) {
    final horizon = height * .55;
    final archPaint = Paint()
      ..color = const Color(0xff7894d1).withValues(alpha: .28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, width * .002);
    final fillPaint = Paint()
      ..color = const Color(0xff27385f).withValues(alpha: .5);
    for (final centerX in [width * .13, width * .87]) {
      final arch = Path()
        ..moveTo(centerX - width * .09, horizon)
        ..lineTo(centerX - width * .09, horizon - height * .22)
        ..quadraticBezierTo(
          centerX,
          horizon - height * .42,
          centerX + width * .09,
          horizon - height * .22,
        )
        ..lineTo(centerX + width * .09, horizon);
      canvas.drawPath(arch, fillPaint);
      canvas.drawPath(arch, archPaint);
      canvas.drawRect(
        Rect.fromLTWH(
          centerX - width * .105,
          horizon - height * .045,
          width * .21,
          height * .045,
        ),
        fillPaint,
      );
    }

    final spirePaint = Paint()
      ..color = const Color(0xff8ea7dc).withValues(alpha: .22)
      ..style = PaintingStyle.fill;
    final spire = Path()
      ..moveTo(width * .43, horizon)
      ..lineTo(width * .45, horizon - height * .24)
      ..lineTo(width * .47, horizon)
      ..close()
      ..moveTo(width * .53, horizon)
      ..lineTo(width * .55, horizon - height * .24)
      ..lineTo(width * .57, horizon)
      ..close();
    canvas.drawPath(spire, spirePaint);
  }

  void _drawArenaFloor(Canvas canvas, double width, double height) {
    final horizon = height * .58;
    final floorRect = Rect.fromLTWH(0, horizon, width, height - horizon);
    canvas.drawRect(
      floorRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff26385f), Color(0xff111b35)],
        ).createShader(floorRect),
    );
    final floorLine = Paint()
      ..color = const Color(0xff8199cb).withValues(alpha: .16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var row = 1; row <= 4; row++) {
      final y = horizon + (height - horizon) * row / 5;
      canvas.drawLine(Offset(0, y), Offset(width, y), floorLine);
    }
    for (var column = -3; column <= 3; column++) {
      final x = width * .5 + column * width * .14;
      canvas.drawLine(
        Offset(width * .5, horizon),
        Offset(x, height),
        floorLine,
      );
    }
    final platform = Rect.fromCenter(
      center: Offset(width * .5, height * .8),
      width: width * .63,
      height: height * .25,
    );
    canvas.drawOval(
      platform,
      Paint()
        ..color = const Color(0xff6e89c3).withValues(alpha: .12)
        ..style = PaintingStyle.fill,
    );
    canvas.drawOval(platform, floorLine..strokeWidth = 1.4);
  }

  void _drawPlayer(Canvas canvas, double width, double height, String id) {
    final isActing = _stageGame.snapshot.activeCombatantId == id;
    final cue = _stageGame.cue;
    final p = _stageGame.cueProgress;
    final baseX = width * .28;
    final floorY = height * .83;
    var lunge = 0.0;
    if (cue?.actorId == id &&
        (cue!.kind == CombatStageCueKind.attackHit ||
            cue.kind == CombatStageCueKind.attackMiss ||
            cue.kind == CombatStageCueKind.criticalHit)) {
      lunge = _lunge(p) * width * .13;
    }
    final targetRecoil =
        cue?.targetId == id &&
        (cue?.kind == CombatStageCueKind.attackHit ||
            cue?.kind == CombatStageCueKind.criticalHit);
    final recoil = targetRecoil ? _impact(p) * -width * .025 : 0.0;
    final idle = _stageGame.isReducedMotion
        ? 0.0
        : math.sin(_stageGame.elapsed * 2.2) * height * .008;
    final center = Offset(baseX + lunge + recoil, floorY - idle);

    _drawContactRing(canvas, center, width * .072, isActing);
    final scale = math.min(width * .00033, height * .0027);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    final cape = Path()
      ..moveTo(-23, -123)
      ..lineTo(30, -121)
      ..lineTo(61, -7)
      ..lineTo(11, -23)
      ..lineTo(-36, -5)
      ..close();
    canvas.drawPath(
      cape,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xff6289d2), Color(0xff263c78)],
        ).createShader(const Rect.fromLTWH(-36, -123, 97, 118)),
    );
    final body = Path()
      ..moveTo(-22, -120)
      ..lineTo(25, -120)
      ..lineTo(40, -56)
      ..lineTo(24, -27)
      ..lineTo(-18, -27)
      ..lineTo(-38, -57)
      ..close();
    canvas.drawPath(
      body,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xffd7e4ff), Color(0xff6079ab)],
        ).createShader(const Rect.fromLTWH(-38, -120, 78, 93)),
    );
    canvas.drawCircle(
      const Offset(0, -151),
      27,
      Paint()..color = const Color(0xffffd8c8),
    );
    final hair = Path()
      ..moveTo(-25, -166)
      ..lineTo(-44, -196)
      ..lineTo(-12, -184)
      ..lineTo(6, -205)
      ..lineTo(13, -181)
      ..lineTo(38, -191)
      ..lineTo(25, -161)
      ..close();
    canvas.drawPath(hair, Paint()..color = const Color(0xffa9c4ff));
    canvas.drawCircle(
      const Offset(-9, -153),
      2.5,
      Paint()..color = const Color(0xff40588e),
    );
    canvas.drawCircle(
      const Offset(9, -153),
      2.5,
      Paint()..color = const Color(0xff40588e),
    );
    canvas.drawLine(
      const Offset(21, -92),
      const Offset(62, -160),
      Paint()
        ..color = const Color(0xffd8e8ff)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      const Offset(62, -160),
      7,
      Paint()..color = const Color(0xff8ce8ff),
    );
    canvas.restore();
  }

  void _drawConstruct(Canvas canvas, double width, double height, String id) {
    final isActing = _stageGame.snapshot.activeCombatantId == id;
    final cue = _stageGame.cue;
    final p = _stageGame.cueProgress;
    final baseX = width * .72;
    final floorY = height * .83;
    final lunge =
        cue?.actorId == id &&
            (cue!.kind == CombatStageCueKind.attackHit ||
                cue.kind == CombatStageCueKind.attackMiss ||
                cue.kind == CombatStageCueKind.criticalHit)
        ? _lunge(p) * -width * .13
        : 0.0;
    final targetRecoil =
        cue?.targetId == id &&
        (cue?.kind == CombatStageCueKind.attackHit ||
            cue?.kind == CombatStageCueKind.criticalHit);
    final recoil = targetRecoil ? _impact(p) * width * .025 : 0.0;
    final idle = _stageGame.isReducedMotion
        ? 0.0
        : math.sin(_stageGame.elapsed * 1.35) * height * .01;
    final isVictoryPose =
        _stageGame.snapshot.outcome == CombatStageOutcome.victory;
    final isDefeated = _firstUnit(CombatStageSide.enemy)?.defeated ?? false;
    final center = Offset(
      baseX + lunge + recoil,
      floorY - idle + (isVictoryPose || isDefeated ? height * .025 : 0),
    );
    _drawContactRing(canvas, center, width * .1, isActing);

    final scale = math.min(width * .00039, height * .0031);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale, isVictoryPose || isDefeated ? scale * .78 : scale);
    final armor = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xffd99b57), Color(0xff715244), Color(0xff293857)],
      ).createShader(const Rect.fromLTWH(-100, -145, 200, 145));
    final shadowPaint = Paint()..color = const Color(0xff121b2b);
    final leg = Path()
      ..moveTo(-63, -30)
      ..lineTo(-52, 6)
      ..lineTo(-67, 26)
      ..lineTo(-43, 24)
      ..lineTo(-23, -9)
      ..lineTo(15, -8)
      ..lineTo(42, 22)
      ..lineTo(64, 22)
      ..lineTo(49, -25)
      ..close();
    canvas.drawPath(leg, shadowPaint);
    final tail = Path()
      ..moveTo(-85, -73)
      ..quadraticBezierTo(-137, -120, -119, -143)
      ..quadraticBezierTo(-116, -104, -75, -99)
      ..close();
    canvas.drawPath(tail, armor);
    final body = Path()
      ..moveTo(-83, -92)
      ..lineTo(-48, -127)
      ..lineTo(19, -129)
      ..lineTo(71, -93)
      ..lineTo(86, -45)
      ..lineTo(52, -22)
      ..lineTo(-54, -25)
      ..lineTo(-89, -51)
      ..close();
    canvas.drawPath(body, armor);
    final head = Path()
      ..moveTo(38, -112)
      ..lineTo(79, -130)
      ..lineTo(112, -104)
      ..lineTo(126, -77)
      ..lineTo(100, -50)
      ..lineTo(60, -59)
      ..close();
    canvas.drawPath(head, armor);
    final horn = Paint()..color = const Color(0xffd5c39f);
    final horns = Path()
      ..moveTo(78, -119)
      ..lineTo(92, -157)
      ..lineTo(97, -116)
      ..close()
      ..moveTo(106, -105)
      ..lineTo(136, -131)
      ..lineTo(118, -92)
      ..close();
    canvas.drawPath(horns, horn);
    final runePaint = Paint()
      ..color = const Color(0xff7fe3ff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    for (final runeX in [-43.0, 0.0, 43.0]) {
      final rune = Path()
        ..moveTo(runeX, -94)
        ..lineTo(runeX + 11, -81)
        ..lineTo(runeX, -68)
        ..lineTo(runeX - 11, -81)
        ..close();
      canvas.drawPath(rune, runePaint);
    }
    canvas.drawCircle(
      const Offset(105, -88),
      5,
      Paint()..color = const Color(0xffffd792),
    );
    canvas.restore();
  }

  void _drawContactRing(
    Canvas canvas,
    Offset center,
    double radius,
    bool active,
  ) {
    final ring = Paint()
      ..color = active
          ? const Color(0xff8ce8ff).withValues(alpha: .65)
          : const Color(0xff9db4dd).withValues(alpha: .28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = active ? 2.4 : 1.2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 4),
        width: radius * 2,
        height: radius * .44,
      ),
      ring,
    );
  }

  void _drawCue(Canvas canvas, double width, double height) {
    final cue = _stageGame.cue;
    if (cue == null) return;
    final progress = _ease(_stageGame.cueProgress);
    if (progress >= 1) return;

    final playerX = width * .28;
    final enemyX = width * .72;
    final player = _firstUnit(CombatStageSide.player);
    final enemy = _firstUnit(CombatStageSide.enemy);
    final actorX = cue.actorId == enemy?.id ? enemyX : playerX;
    final targetX = cue.targetId == player?.id ? playerX : enemyX;
    final centerY = height * .56;
    final opacity = (1 - progress).clamp(0.0, 1.0);

    switch (cue.kind) {
      case CombatStageCueKind.actorFocus:
        final focusX = cue.actorId == enemy?.id ? enemyX : playerX;
        canvas.drawCircle(
          Offset(focusX, height * .82),
          width * (.055 + progress * .015),
          Paint()
            ..color = const Color(0xff8ce8ff).withValues(alpha: opacity * .26)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      case CombatStageCueKind.attackHit:
      case CombatStageCueKind.attackMiss:
      case CombatStageCueKind.criticalHit:
        final isMiss = cue.kind == CombatStageCueKind.attackMiss;
        final critical = cue.kind == CombatStageCueKind.criticalHit;
        final direction = targetX >= actorX ? 1.0 : -1.0;
        final yOffset = isMiss ? height * .19 : 0.0;
        final beam = Paint()
          ..color =
              (critical ? const Color(0xffffdc95) : const Color(0xffa8eaff))
                  .withValues(alpha: opacity * .9)
          ..strokeWidth = critical ? 5 : 3
          ..strokeCap = StrokeCap.round;
        final startX = actorX + direction * width * .055;
        final endX = startX + (targetX - startX) * progress;
        final y = centerY + yOffset;
        canvas.drawLine(Offset(startX, y), Offset(endX, y), beam);
        if (critical) {
          canvas.drawLine(
            Offset(startX, y + 7),
            Offset(endX, y + 7),
            beam..strokeWidth = 1.5,
          );
        }
        if (!isMiss && progress > .5) {
          final impactProgress = ((progress - .5) * 2).clamp(0.0, 1.0);
          canvas.drawCircle(
            Offset(targetX, centerY),
            width * (.012 + impactProgress * .022),
            Paint()..color = const Color(0xffffefd4).withValues(alpha: opacity),
          );
        }
      case CombatStageCueKind.cast:
        final hasTarget = cue.targetId != null;
        final orbPosition = hasTarget
            ? Offset(actorX + (targetX - actorX) * progress, centerY)
            : Offset(actorX, height * .52 - progress * height * .04);
        canvas.drawCircle(
          orbPosition,
          width * .018 * (1 + .25 * math.sin(progress * math.pi)),
          Paint()..color = const Color(0xff8ce8ff).withValues(alpha: opacity),
        );
        canvas.drawCircle(
          orbPosition,
          width * .034,
          Paint()
            ..color = const Color(0xff8ce8ff).withValues(alpha: opacity * .36)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      case CombatStageCueKind.analysisReveal:
        final scanX = -width * .1 + width * 1.2 * progress;
        canvas.drawLine(
          Offset(scanX, height * .22),
          Offset(scanX, height * .75),
          Paint()
            ..shader =
                LinearGradient(
                  colors: [
                    const Color(0xff8ce8ff).withValues(alpha: 0),
                    const Color(0xffb8f5ff).withValues(alpha: opacity * .86),
                    const Color(0xff8ce8ff).withValues(alpha: 0),
                  ],
                ).createShader(
                  Rect.fromLTWH(scanX - 18, height * .22, 36, height * .53),
                )
            ..strokeWidth = 3,
        );
      case CombatStageCueKind.interrupt:
        final radius = width * (.015 + progress * .11);
        final ringPaint = Paint()
          ..color = const Color(0xffa9f4ff).withValues(alpha: opacity * .82)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawCircle(Offset(targetX, centerY), radius, ringPaint);
        final crack = Path()
          ..moveTo(targetX - width * .05, centerY - height * .018)
          ..lineTo(targetX - width * .015, centerY + height * .012)
          ..lineTo(targetX + width * .006, centerY - height * .006)
          ..lineTo(targetX + width * .045, centerY + height * .02);
        canvas.drawPath(
          crack,
          Paint()
            ..color = const Color(0xffe9fbff).withValues(alpha: opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round,
        );
      case CombatStageCueKind.victory:
        _drawOutcomeRays(
          canvas,
          width,
          height,
          progress,
          const Color(0xffffd995),
        );
      case CombatStageCueKind.defeat:
        final shade = Paint()
          ..color = const Color(0xff070d20).withValues(alpha: progress * .24);
        canvas.drawRect(Rect.fromLTWH(0, 0, width, height), shade);
    }
  }

  void _drawOutcomeRays(
    Canvas canvas,
    double width,
    double height,
    double progress,
    Color color,
  ) {
    final paint = Paint()
      ..color = color.withValues(alpha: (1 - progress) * .52)
      ..strokeWidth = 1.6;
    for (var i = 0; i < 7; i++) {
      final x = width * (.2 + i * .1);
      final top = height * (.2 + (i % 3) * .07);
      canvas.drawLine(
        Offset(x, top),
        Offset(x + (i.isEven ? 1 : -1) * width * .03, top + height * .12),
        paint,
      );
    }
  }

  static double _ease(double value) => Curves.easeOutCubic.transform(value);

  static double _lunge(double value) {
    if (value < .32) return Curves.easeInCubic.transform(value / .32);
    if (value < .66) return 1;
    return 1 - Curves.easeOutCubic.transform((value - .66) / .34);
  }

  static double _impact(double value) {
    if (value < .4 || value > .72) return 0;
    final t = (value - .4) / .32;
    return math.sin(t * math.pi) * (1 - t * .25);
  }
}
