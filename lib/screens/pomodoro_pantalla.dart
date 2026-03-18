import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_design_trivia/screens/theme_colors.dart';
import 'package:flutter_design_trivia/screens/notification_service.dart';
import 'resumen_pantalla.dart';
import 'principal.dart';

class PomodoroScreen extends StatefulWidget {

  final int workMinutes;
  final int breakMinutes;
  final int totalCycles;

  const PomodoroScreen({
    super.key,
    required this.workMinutes,
    required this.breakMinutes,
    required this.totalCycles,
  });

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {

  late int totalTime;
  late int timeLeft;

  Timer? _timer;

  int currentCycle = 1;
  bool isBreak = false;
  bool isPaused = false;
  bool _blockFinishing = false;

  late AnimationController breatheController;
  final AudioPlayer player = AudioPlayer();

  static const _frases = [
    "¡Tú puedes! 💪",
    "Enfoque total 🎯",
    "Un paso a la vez 🚀",
    "¡Casi listo! ⭐",
    "Eres increíble 🔥",
    "¡Sigue así! 🌟",
    "Concentración máxima 🧠",
    "¡Vas muy bien! 👏",
  ];

  @override
  void initState() {
    super.initState();
    totalTime = widget.workMinutes * 60;
    timeLeft = totalTime;

    breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _blockFinishing = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (isPaused) return;

      if (timeLeft <= 0 && !_blockFinishing) {
        _blockFinishing = true;
        t.cancel();
        _onBlockFinished();
      } else if (!_blockFinishing) {
        setState(() => timeLeft--);
      }
    });
  }

  Future<void> _onBlockFinished() async {
    await _playBell();

    try {
      await NotificationService.showNotification(
        isBreak: !isBreak,
        cycle: currentCycle,
        totalCycles: widget.totalCycles,
      );
    } catch (e) {
      debugPrint('Notificación falló: $e');
    }

    if (!mounted) return;

    if (!isBreak) {
      setState(() {
        isBreak = true;
        totalTime = widget.breakMinutes * 60;
        timeLeft = totalTime;
      });
      startTimer();
    } else {
      if (currentCycle < widget.totalCycles) {
        setState(() {
          currentCycle++;
          isBreak = false;
          totalTime = widget.workMinutes * 60;
          timeLeft = totalTime;
        });
        startTimer();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResumenPantalla(
              ciclos: widget.totalCycles,
              trabajoTotal: widget.totalCycles * widget.workMinutes,
              descansoTotal: widget.totalCycles * widget.breakMinutes,
            ),
          ),
        );
      }
    }
  }

  Future<void> _playBell() async {
    try {
      await player.play(AssetSource('sounds/bell.mp3'));
    } catch (_) {}
  }

  void _togglePause() {
    setState(() => isPaused = !isPaused);
    if (!isPaused) {
      breatheController.repeat(reverse: true);
    } else {
      breatheController.stop();
    }
  }

  Future<void> _confirmAbandon() async {
    final wasRunning = !isPaused;
    if (wasRunning) setState(() => isPaused = true);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF1FAEE),
        title: Text(
          '¿Abandonar sesión?',
          textAlign: TextAlign.center, 
          style: GoogleFonts.patrickHand(
              fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink),
        ),
        content: Text(
          'Se perderá el progreso actual.',
          textAlign: TextAlign.center, 
          style: GoogleFonts.patrickHand(fontSize: 18, color: AppColors.ink),
        ),
        actionsAlignment: MainAxisAlignment.center, 
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar',
                style: GoogleFonts.patrickHand(
                    fontSize: 18, color: AppColors.accent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Sí, salir',
                style: GoogleFonts.patrickHand(
                    fontSize: 18, color: AppColors.workColor)),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Principal()),
        (route) => false,
      );
    } else {
      if (wasRunning) setState(() => isPaused = false);
    }
  }

  String formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    breatheController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        totalTime > 0 ? 1 - (timeLeft / totalTime) : 1.0;
    final width = MediaQuery.of(context).size.width;
    final Color activeColor =
        isBreak ? AppColors.breakColor : AppColors.workColor;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmAbandon();
      },
      child: Scaffold(
        body: Stack(
          children: [

            Positioned.fill(
              child: Image.asset('assets/images/hojapapel2.png',
                  fit: BoxFit.cover),
            ),

            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                color: isBreak
                    ? AppColors.breakColor.withOpacity(0.12)
                    : AppColors.workColor.withOpacity(0.08),
              ),
            ),

            SafeArea(
              child: Column(
                children: [

                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 28),
                        color: AppColors.ink,
                        tooltip: 'Abandonar sesión',
                        onPressed: _confirmAbandon,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Text(
                                isBreak ? '🌿 ¡Descansa!' : '🍅 ¡Enfócate!',
                                key: ValueKey(isBreak),
                                style: GoogleFonts.patrickHand(
                                  fontSize: width * 0.09,
                                  fontWeight: FontWeight.bold,
                                  color: activeColor,
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.2, vertical: 8),
                              child: Divider(
                                color: activeColor.withOpacity(0.4),
                                thickness: 1.5,
                              ),
                            ),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 6),
                              decoration: BoxDecoration(
                                color: activeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: activeColor, width: 1.5),
                              ),
                              child: Text(
                                'Ciclo $currentCycle de ${widget.totalCycles}',
                                style: GoogleFonts.patrickHand(
                                  fontSize: 20,
                                  color: activeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(widget.totalCycles, (i) {
                                final done = i < currentCycle - 1;
                                final current = i == currentCycle - 1;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  child: done
                                      ? const Text('🍅',
                                          style: TextStyle(fontSize: 20))
                                      : AnimatedContainer(
                                          duration: const Duration(milliseconds: 400),
                                          width: current ? 16 : 10,
                                          height: current ? 16 : 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: current
                                                ? activeColor
                                                : activeColor.withOpacity(0.25),
                                            border: Border.all(
                                                color: activeColor, width: 1.5),
                                          ),
                                        ),
                                );
                              }),
                            ),

                            const SizedBox(height: 24),

                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.55),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                    color: AppColors.ink.withOpacity(0.4),
                                    width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: activeColor.withOpacity(0.18),
                                    blurRadius: 24,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: AnimatedBuilder(
                                animation: breatheController,
                                builder: (ctx, child) => Transform.scale(
                                  scale: breatheController.value,
                                  child: child,
                                ),
                                child: CustomPaint(
                                  painter: SketchCircle(progress, isBreak),
                                  child: SizedBox(
                                    width: 240,
                                    height: 240,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [

                                        Transform.scale(
                                          scale: 0.6 + progress * 1.4,
                                          child: Image.asset(
                                            isBreak
                                                ? 'assets/images/descanso.png'
                                                : 'assets/images/tomato.png',
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          formatTime(timeLeft),
                                          style: GoogleFonts.patrickHand(
                                            fontSize: 46,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.ink,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.12),
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: activeColor.withOpacity(0.15),
                                  border: Border.all(
                                      color: activeColor.withOpacity(0.4),
                                      width: 1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        activeColor),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            FloatingActionButton.extended(
                              onPressed: _togglePause,
                              backgroundColor: Colors.white,
                              foregroundColor: activeColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: activeColor, width: 2.5),
                              ),
                              icon: Icon(
                                isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                size: 30,
                              ),
                              label: Text(
                                isPaused ? 'Reanudar' : 'Pausar',
                                style: GoogleFonts.patrickHand(fontSize: 24),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              _frases[(currentCycle - 1) % _frases.length],
                              style: GoogleFonts.patrickHand(
                                fontSize: 20,
                                color: activeColor.withOpacity(0.85),
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 16),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SketchCircle extends CustomPainter {

  final double progress;
  final bool isBreak;

  SketchCircle(this.progress, this.isBreak);

  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final random = Random(42);

    final bgPaint = Paint()
      ..color = isBreak
          ? AppColors.breakColor.withOpacity(0.08)
          : AppColors.workColor.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    final basePaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        center,
        radius + random.nextDouble() * 3,
        basePaint,
      );
    }

    final progressPaint = Paint()
      ..color = isBreak ? AppColors.breakColor : AppColors.workColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SketchCircle old) =>
      old.progress != progress || old.isBreak != isBreak;
}