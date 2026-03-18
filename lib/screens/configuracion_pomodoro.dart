import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_design_trivia/screens/theme_colors.dart';
import 'pomodoro_pantalla.dart';

class ConfiguracionPomodoro extends StatefulWidget {
  const ConfiguracionPomodoro({super.key});

  @override
  State<ConfiguracionPomodoro> createState() => _ConfiguracionPomodoroState();
}

class _ConfiguracionPomodoroState extends State<ConfiguracionPomodoro> {

  int trabajo = 25;
  int descanso = 5;
  int ciclos = 4;

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
              color: null,
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // ── Botón atrás manual arriba a la izquierda ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, size: 28),
                          color: AppColors.ink,
                          tooltip: 'Regresar',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),

                    Text(
                      '⚙️ Configura tu sesión',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.patrickHand(
                        fontSize: width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Tarjeta de configuración ──
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.60),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.ink.withOpacity(0.5), width: 2),
                      ),
                      child: Column(
                        children: [

                          _buildCounter(
                            label: 'Trabajo',
                            emoji: '🍅',
                            sublabel: 'minutos',
                            value: trabajo,
                            min: 1,
                            max: 60,
                            color: AppColors.workColor,
                            onChanged: (v) => setState(() => trabajo = v),
                          ),

                          const SizedBox(height: 4),
                          Divider(
                              color: AppColors.ink.withOpacity(0.15),
                              height: 32),

                          _buildCounter(
                            label: 'Descanso',
                            emoji: '🌿',
                            sublabel: 'minutos',
                            value: descanso,
                            min: 1,
                            max: 30,
                            color: AppColors.breakColor,
                            onChanged: (v) => setState(() => descanso = v),
                          ),

                          Divider(
                              color: AppColors.ink.withOpacity(0.15),
                              height: 32),

                          _buildCounter(
                            label: 'Ciclos',
                            emoji: '🔄',
                            sublabel: 'repeticiones',
                            value: ciclos,
                            min: 1,
                            max: 8,
                            color: AppColors.accent,
                            onChanged: (v) => setState(() => ciclos = v),
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ── Botón Comenzar ──
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PomodoroScreen(
                                workMinutes: trabajo,
                                breakMinutes: descanso,
                                totalCycles: ciclos,
                              ),
                            ),
                          );
                        },
                        icon: const Text('🍅',
                            style: TextStyle(fontSize: 22)),
                        label: Text(
                          'Comenzar',
                          style: GoogleFonts.patrickHand(
                            fontSize: 26,
                            color: AppColors.ink,
                          ),
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
                              horizontal: 40, vertical: 14),
                        ),
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

  // ── Widget contador con + y − ─────────────────────────────────────────────

  Widget _buildCounter({
    required String label,
    required String emoji,
    required String sublabel,
    required int value,
    required int min,
    required int max,
    required Color color,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        // ── Etiqueta izquierda ──
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.patrickHand(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  sublabel,
                  style: GoogleFonts.patrickHand(
                    fontSize: 13,
                    color: AppColors.ink.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Controles − valor + ──
        Row(
          children: [

            _counterButton(
              icon: Icons.remove_rounded,
              color: color,
              onTap: value > min ? () => onChanged(value - 1) : null,
            ),

            const SizedBox(width: 12),

            Container(
              width: 52,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: GoogleFonts.patrickHand(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),

            const SizedBox(width: 12),

            _counterButton(
              icon: Icons.add_rounded,
              color: color,
              onTap: value < max ? () => onChanged(value + 1) : null,
            ),

          ],
        ),
      ],
    );
  }

  // ── Botón circular + / − ──────────────────────────────────────────────────

  Widget _counterButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final bool enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? color : color.withOpacity(0.15),
          border: Border.all(
            color: enabled ? color : color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: 22,
          color: enabled ? Colors.white : color.withOpacity(0.4),
        ),
      ),
    );
  }
}