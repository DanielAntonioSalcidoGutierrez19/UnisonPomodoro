import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_design_trivia/screens/theme_colors.dart';
import 'configuracion_pomodoro.dart';

class BienvenidaPantalla extends StatefulWidget {
  const BienvenidaPantalla({super.key});

  @override
  State<BienvenidaPantalla> createState() => _BienvenidaPantallaState();
}

class _BienvenidaPantallaState extends State<BienvenidaPantalla>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              'assets/images/hojapapel2.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: AppColors.workColor.withOpacity(0.04),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 8),

                    Text(
                      '¿Qué es el\nPomodoro? 🍅',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.patrickHand(
                        fontSize: width * 0.10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Tu técnica favorita de productividad',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.patrickHand(
                        fontSize: width * 0.048,
                        color: AppColors.ink.withOpacity(0.55),
                      ),
                    ),

                    const SizedBox(height: 24),

                    _infoCard(
                      color: AppColors.workColor,
                      emoji: '🧠',
                      titulo: '¿En qué consiste?',
                      descripcion:
                          'La técnica Pomodoro divide tu tiempo en bloques de trabajo enfocado, '
                          'separados por pequeños descansos. ¡Así tu mente rinde al máximo!',
                      width: width,
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [

                        Expanded(
                          child: _miniCard(
                            color: AppColors.accent,
                            emoji: '⏱',
                            titulo: 'Trabaja',
                            descripcion: 'Bloques de\nenfoque total',
                            width: width,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _miniCard(
                            color: AppColors.breakColor,
                            emoji: '🌿',
                            titulo: 'Descansa',
                            descripcion: 'Pausas para\nrecargar energía',
                            width: width,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 14),

                    _infoCard(
                      color: AppColors.accent,
                      emoji: '📋',
                      titulo: '¿Cómo funciona?',
                      descripcion: '',
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _paso('1', '🍅', 'Elige cuánto tiempo trabajar',
                              AppColors.workColor),
                          _paso('2', '▶️', 'Inicia el temporizador',
                              AppColors.accent),
                          _paso('3', '🌿', 'Descansa cuando termine',
                              AppColors.breakColor),
                          _paso('4', '🔄', 'Repite los ciclos que quieras',
                              AppColors.ink),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _infoCard(
                      color: AppColors.breakColor,
                      emoji: '✨',
                      titulo: 'Beneficios',
                      descripcion: '',
                      width: width,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip('Más concentración', AppColors.workColor),
                          _chip('Menos fatiga', AppColors.breakColor),
                          _chip('Mayor productividad', AppColors.accent),
                          _chip('Mejor gestión del tiempo', AppColors.ink),
                          _chip('Reduce la procrastinación', AppColors.workColor),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      '¡Presiona para empezar!',
                      style: GoogleFonts.patrickHand(
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _BouncingImage(
                      imagePath: 'assets/images/inicio.png',
                      width: width * 0.28,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ConfiguracionPomodoro(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _infoCard({
    required Color color,
    required String emoji,
    required String titulo,
    required String descripcion,
    required double width,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: GoogleFonts.patrickHand(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color == AppColors.ink ? AppColors.ink : color,
                ),
              ),
            ],
          ),

          if (descripcion.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              descripcion,
              style: GoogleFonts.patrickHand(
                fontSize: 17,
                color: AppColors.ink.withOpacity(0.75),
                height: 1.4,
              ),
            ),
          ],

          if (child != null) ...[
            const SizedBox(height: 12),
            child,
          ],

        ],
      ),
    );
  }


  Widget _miniCard({
    required Color color,
    required String emoji,
    required String titulo,
    required String descripcion,
    required double width,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(
            titulo,
            style: GoogleFonts.patrickHand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: GoogleFonts.patrickHand(
              fontSize: 14,
              color: AppColors.ink.withOpacity(0.65),
              height: 1.3,
            ),
          ),

        ],
      ),
    );
  }


  Widget _paso(String numero, String emoji, String texto, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [

          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              numero,
              style: GoogleFonts.patrickHand(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),

          const SizedBox(width: 10),
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),

          Expanded(
            child: Text(
              texto,
              style: GoogleFonts.patrickHand(
                fontSize: 17,
                color: AppColors.ink.withOpacity(0.8),
              ),
            ),
          ),

        ],
      ),
    );
  }


  Widget _chip(String texto, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Text(
        texto,
        style: GoogleFonts.patrickHand(
          fontSize: 14,
          color: color == AppColors.ink ? AppColors.ink : color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


class _BouncingImage extends StatefulWidget {

  final String imagePath;
  final double width;
  final VoidCallback onTap;

  const _BouncingImage({
    required this.imagePath,
    required this.width,
    required this.onTap,
  });

  @override
  State<_BouncingImage> createState() => _BouncingImageState();
}

class _BouncingImageState extends State<_BouncingImage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Image.asset(widget.imagePath, width: widget.width),
      ),
    );
  }
}