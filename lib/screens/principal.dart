import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_design_trivia/screens/theme_colors.dart';
import 'bienvenida.dart'; 

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      body: Stack(
        children: [

          // ── Fondo ──
          Positioned.fill(
            child: Image.asset(
              "assets/images/hojapapel2.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // ── Título ──
                    Text(
                      "Pomodoro UNISON",
                      style: GoogleFonts.patrickHand(
                        fontSize: width * 0.10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Logo ──
                    Image.asset(
                      'assets/images/logo.png',
                      width: width * 0.50,
                    ),

                    const SizedBox(height: 28),

                    // ── Tarjeta de integrantes ──
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.08),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.60),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.ink.withOpacity(0.5), width: 2),
                      ),
                      child: Column(
                        children: [

                          Text(
                            "Integrantes",
                            style: GoogleFonts.patrickHand(
                              fontSize: width * 0.065,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text("• Barajas Miranda Zihary Leticia",
                              style: GoogleFonts.patrickHand(
                                  fontSize: width * 0.05,
                                  color: AppColors.ink)),

                          Text("• Jose Jose Alex Gabi",
                              style: GoogleFonts.patrickHand(
                                  fontSize: width * 0.05,
                                  color: AppColors.ink)),

                          Text("• Salcido Gutierrez Daniel Antonio",
                              style: GoogleFonts.patrickHand(
                                  fontSize: width * 0.05,
                                  color: AppColors.ink)),

                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Leyenda ──
                    Text(
                      "Presiona para comenzar",
                      style: GoogleFonts.patrickHand(
                        fontSize: width * 0.055,
                        color: AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Botón imagen con efecto de escala ──
                    _BouncingImage(
                      imagePath: 'assets/images/inicio.png',
                      width: width * 0.28,
                      onTap: () => Navigator.push( // ✅ único cambio aquí
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BienvenidaPantalla(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Botón con efecto rebote ──────────────────────────────────────────────────

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