import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_design_trivia/screens/theme_colors.dart';
import 'principal.dart';

class ResumenPantalla extends StatelessWidget {

  final int ciclos;
  final int trabajoTotal;
  final int descansoTotal;

  const ResumenPantalla({
    super.key,
    required this.ciclos,
    required this.trabajoTotal,
    required this.descansoTotal,
  });

  String getMensaje() {
    if (ciclos <= 2) return "¡Buen inicio! Cada sesión cuenta. 💪";
    if (ciclos <= 5) return "¡Gran concentración! Eres imparable. 🔥";
    return "¡Nivel maestro de productividad! 🏆";
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [

          
          Positioned.fill(
            child: Image.asset(
              "assets/images/hojapapel2.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: AppColors.workColor.withOpacity(0.06),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                  
                    Text(
                      "🎉 ¡Sesión completada!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.patrickHand(
                        fontSize: width * 0.09,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),

                    const SizedBox(height: 36),

              
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statCard('🍅', 'Ciclos', '$ciclos',
                            AppColors.workColor),
                        _statCard('⏱', 'Trabajo', '$trabajoTotal min',
                            AppColors.accent),
                        _statCard('🌿', 'Descanso', '$descansoTotal min',
                            AppColors.breakColor),
                      ],
                    ),

                    const SizedBox(height: 40),

                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.60),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.ink.withOpacity(0.4),
                            width: 2),
                      ),
                      child: Text(
                        getMensaje(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.patrickHand(
                          fontSize: 24,
                          color: AppColors.workColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ── Botón nueva sesión ──
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Principal()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 26),
                      label: Text(
                        "Nueva sesión",
                        style: GoogleFonts.patrickHand(fontSize: 26),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.workColor,
                        elevation: 0,
                        side: BorderSide(
                            color: AppColors.workColor, width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String emoji, String label, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.patrickHand(
                fontSize: 13,
                color: AppColors.ink,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.patrickHand(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}