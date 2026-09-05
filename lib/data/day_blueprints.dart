/// The complete 30-day program, expressed as data.
///
/// Each day names the exercises used by every section. The concrete workout
/// (rounds, work, rest, exercise variation) is produced by `PlanBuilder` from
/// the day number, the user's fitness level, the chosen duration tier and the
/// challenge level, so one blueprint serves 4 durations x 3 levels.
///
/// Lists are authored at their longest. Shorter duration tiers take a prefix
/// of each list, which is why a 90-minute session contains genuinely different
/// work rather than repeated rounds of the 30-minute one.
class DayBlueprint {
  final int day;
  final String title;
  final String focus;
  final bool recovery;

  final List<String> warmup; // 5
  final List<String> circuitA; // 5
  final List<String> circuitB; // 4
  final List<String> strength; // 3
  final List<String> conditioning; // 3
  final List<String> core; // 3
  final List<String> cooldown; // 5

  const DayBlueprint({
    required this.day,
    required this.title,
    required this.focus,
    required this.warmup,
    required this.circuitA,
    required this.circuitB,
    required this.strength,
    required this.conditioning,
    required this.core,
    required this.cooldown,
    this.recovery = false,
  });

  bool get isFinal => day == 30;

  String get phase {
    if (day <= 5) return 'Foundation';
    if (day <= 10) return 'Foundation + Endurance';
    if (day <= 15) return 'Strength & Conditioning';
    if (day <= 20) return 'Intermediate Progression';
    if (day <= 25) return 'Performance';
    if (day <= 29) return 'Final Preparation';
    return 'Final Challenge';
  }
}

/// Shorthand pools reused across days.
const _wUp = ['w_march', 'w_armcircle', 'w_hipcircle', 'w_torsotwist', 'w_anklerock'];
const _wUpper = ['w_march', 'w_armcircle', 'w_shoulderroll', 'w_catcow', 'w_sidebend'];
const _wLower = ['w_march', 'w_hipcircle', 'w_legswing', 'w_squatrock', 'w_anklerock'];
const _wCardio = ['w_march', 'w_stepjack', 'w_armcircle', 'w_torsotwist', 'w_legswing'];
const _wFull = ['w_march', 'w_armcircle', 'w_hipcircle', 'w_inchworm', 'w_squatrock'];

const _coolBasic = ['m_hamstring', 'm_quad', 'm_chestopener', 'm_seatedtwist', 'm_breathe'];
const _coolLower = ['m_hamstring', 'm_hipflexor', 'm_quad', 'm_calfstretch', 'm_breathe'];
const _coolUpper = ['m_chestopener', 'm_seatedtwist', 'm_neck', 'm_childpose', 'm_breathe'];
const _coolFull = ['m_childpose', 'm_hamstring', 'm_hipflexor', 'm_chestopener', 'm_breathe'];
const _coolDeep = ['m_downdog', 'm_figurefour', 'm_hipflexor', 'm_childpose', 'm_breathe'];

class Program {
  const Program._();

  static DayBlueprint day(int d) => days[d.clamp(1, 30) - 1];

  static const List<DayBlueprint> days = [
    // ------------------------------------------------------- WEEK 1 (1-7)
    DayBlueprint(
      day: 1,
      title: 'Full Body Foundation',
      focus: 'Learn the shapes. Move slowly and breathe.',
      warmup: _wFull,
      circuitA: ['l_chairsquat', 'u_wallpush', 'l_glutebridge', 'c_birddog', 'l_calfraise'],
      circuitB: ['l_hiphinge', 'u_supermanpull', 'w_stepjack', 'c_deadbug'],
      strength: ['l_chairsquat', 'u_inclinepush', 'l_glutebridge'],
      conditioning: ['k_march', 'w_stepjack', 'k_shadowbox'],
      core: ['c_kneeplank', 'c_deadbug', 'c_birddog'],
      cooldown: _coolBasic,
    ),
    DayBlueprint(
      day: 2,
      title: 'Lower Body Basics',
      focus: 'Hips and legs, controlled tempo.',
      warmup: _wLower,
      circuitA: ['l_chairsquat', 'l_glutebridge', 'l_reverselunge', 'l_calfraise', 'l_hiphinge'],
      circuitB: ['l_sumosquat', 'l_kickback', 'l_wallsit', 'w_squatrock'],
      strength: ['l_squat', 'l_glutebridge', 'l_calfraise'],
      conditioning: ['k_march', 'k_shadowbox', 'w_stepjack'],
      core: ['c_deadbug', 'c_kneeplank', 'c_superman'],
      cooldown: _coolLower,
    ),
    DayBlueprint(
      day: 3,
      title: 'Upper Body + Core',
      focus: 'Pushing, pulling and a steady midsection.',
      warmup: _wUpper,
      circuitA: ['u_wallpush', 'u_supermanpull', 'u_chairdip', 'c_kneeplank', 'w_armcircle'],
      circuitB: ['u_inclinepush', 'c_birddog', 'u_supermanpull', 'c_deadbug'],
      strength: ['u_inclinepush', 'u_chairdip', 'u_supermanpull'],
      conditioning: ['k_shadowbox', 'k_march', 'w_stepjack'],
      core: ['c_kneeplank', 'c_sideplank', 'c_superman'],
      cooldown: _coolUpper,
    ),
    DayBlueprint(
      day: 4,
      title: 'Easy Cardio + Mobility',
      focus: 'Raise the heart rate gently, then open the hips.',
      warmup: _wCardio,
      circuitA: ['w_stepjack', 'k_march', 'k_shadowbox', 'w_torsotwist', 'l_calfraise'],
      circuitB: ['k_skater', 'w_stepjack', 'k_march', 'w_squatrock'],
      strength: ['l_glutebridge', 'u_supermanpull', 'l_hiphinge'],
      conditioning: ['k_march', 'k_shadowbox', 'k_skater'],
      core: ['c_deadbug', 'c_birddog', 'c_kneeplank'],
      cooldown: _coolDeep,
    ),
    DayBlueprint(
      day: 5,
      title: 'Full Body Strength',
      focus: 'First real strength day. Quality over speed.',
      warmup: _wFull,
      circuitA: ['l_squat', 'u_inclinepush', 'l_reverselunge', 'u_supermanpull', 'l_glutebridge'],
      circuitB: ['l_wallsit', 'u_chairdip', 'l_calfraise', 'c_birddog'],
      strength: ['l_squat', 'u_kneepush', 'l_glutebridge'],
      conditioning: ['w_stepjack', 'k_march', 'k_shadowbox'],
      core: ['c_kneeplank', 'c_deadbug', 'c_superman'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 6,
      title: 'Light Conditioning',
      focus: 'Simple intervals with plenty of recovery.',
      warmup: _wCardio,
      circuitA: ['w_stepjack', 'l_squat', 'k_march', 'u_wallpush', 'k_shadowbox'],
      circuitB: ['k_skater', 'l_reverselunge', 'k_march', 'c_kneeplank'],
      strength: ['l_glutebridge', 'u_inclinepush', 'l_hiphinge'],
      conditioning: ['k_march', 'w_stepjack', 'k_skater'],
      core: ['c_deadbug', 'c_kneeplank', 'c_birddog'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 7,
      title: 'Recovery & Mobility',
      focus: 'A real recovery day with a real task: move and breathe.',
      recovery: true,
      warmup: ['w_march', 'w_shoulderroll', 'w_catcow', 'w_hipcircle', 'w_anklerock'],
      circuitA: ['m_downdog', 'm_hipflexor', 'm_hamstring', 'm_chestopener', 'm_figurefour'],
      circuitB: ['m_seatedtwist', 'm_calfstretch', 'm_quad', 'w_catcow'],
      strength: ['c_birddog', 'l_glutebridge', 'c_deadbug'],
      conditioning: ['k_march', 'w_stepjack', 'k_shadowbox'],
      core: ['c_deadbug', 'c_birddog', 'c_kneeplank'],
      cooldown: ['m_childpose', 'm_neck', 'm_legsupwall', 'm_figurefour', 'm_breathe'],
    ),

    // ------------------------------------------------------ WEEK 2 (8-14)
    DayBlueprint(
      day: 8,
      title: 'Full Body Endurance',
      focus: 'Longer work intervals, shorter rests.',
      warmup: _wFull,
      circuitA: ['l_squat', 'u_kneepush', 'l_reverselunge', 'c_plank', 'w_stepjack'],
      circuitB: ['l_glutebridge', 'u_supermanpull', 'l_calfraise', 'c_deadbug'],
      strength: ['l_squat', 'u_inclinepush', 'l_slbridge'],
      conditioning: ['k_jacks', 'k_march', 'k_shadowbox'],
      core: ['c_plank', 'c_deadbug', 'c_superman'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 9,
      title: 'Lower Body Endurance',
      focus: 'More repetitions with honest form.',
      warmup: _wLower,
      circuitA: ['l_squat', 'l_reverselunge', 'l_glutebridge', 'l_wallsit', 'l_calfraise'],
      circuitB: ['l_sumosquat', 'l_kickback', 'l_laterallunge', 'l_hiphinge'],
      strength: ['l_squat', 'l_slbridge', 'l_calfraise'],
      conditioning: ['k_march', 'k_skater', 'w_stepjack'],
      core: ['c_deadbug', 'c_plank', 'c_superman'],
      cooldown: _coolLower,
    ),
    DayBlueprint(
      day: 10,
      title: 'Upper Body + Core Endurance',
      focus: 'Push, pull, brace. Repeat.',
      warmup: _wUpper,
      circuitA: ['u_kneepush', 'u_supermanpull', 'u_chairdip', 'c_plank', 'w_armcircle'],
      circuitB: ['u_inclinepush', 'c_sideplank', 'u_supermanpull', 'c_birddog'],
      strength: ['u_kneepush', 'u_chairdip', 'u_supermanpull'],
      conditioning: ['k_shadowbox', 'k_jacks', 'k_march'],
      core: ['c_plank', 'c_sideplank', 'c_deadbug'],
      cooldown: _coolUpper,
    ),
    DayBlueprint(
      day: 11,
      title: 'Cardio Intervals',
      focus: 'First proper interval day. Work, then recover fully.',
      warmup: _wCardio,
      circuitA: ['k_jacks', 'l_squat', 'k_march', 'k_skater', 'k_shadowbox'],
      circuitB: ['k_fastfeet', 'l_reverselunge', 'w_stepjack', 'c_plank'],
      strength: ['l_squat', 'u_kneepush', 'l_glutebridge'],
      conditioning: ['k_jacks', 'k_skater', 'k_fastfeet'],
      core: ['c_plank', 'c_bicycle', 'c_deadbug'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 12,
      title: 'Full Body Strength Circuit',
      focus: 'Multi-exercise circuits with a strength bias.',
      warmup: _wFull,
      circuitA: ['l_squat', 'u_kneepush', 'l_splitsquat', 'u_supermanpull', 'c_plank'],
      circuitB: ['l_glutebridge', 'u_chairdip', 'l_wallsit', 'c_birddog'],
      strength: ['l_squat', 'u_pushup', 'l_slbridge'],
      conditioning: ['k_jacks', 'k_mountainclimber', 'k_march'],
      core: ['c_plank', 'c_legraise', 'c_superman'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 13,
      title: 'Conditioning Density',
      focus: 'Keep moving; rest is short but real.',
      warmup: _wCardio,
      circuitA: ['k_jacks', 'l_squat', 'k_mountainclimber', 'u_kneepush', 'k_skater'],
      circuitB: ['k_stepbackburpee', 'l_reverselunge', 'k_fastfeet', 'c_plank'],
      strength: ['l_squat', 'u_kneepush', 'l_calfraise'],
      conditioning: ['k_mountainclimber', 'k_jacks', 'k_skater'],
      core: ['c_plank', 'c_bicycle', 'c_kneetuck'],
      cooldown: _coolDeep,
    ),
    DayBlueprint(
      day: 14,
      title: 'Recovery & Mobility',
      focus: 'Two weeks in. Restore range and calm the system.',
      recovery: true,
      warmup: ['w_march', 'w_catcow', 'w_hipcircle', 'w_shoulderroll', 'w_legswing'],
      circuitA: ['m_downdog', 'm_hipflexor', 'm_hamstring', 'm_figurefour', 'm_chestopener'],
      circuitB: ['m_seatedtwist', 'm_quad', 'm_calfstretch', 'w_catcow'],
      strength: ['c_birddog', 'l_glutebridge', 'c_deadbug'],
      conditioning: ['k_march', 'k_shadowbox', 'w_stepjack'],
      core: ['c_deadbug', 'c_birddog', 'c_kneeplank'],
      cooldown: ['m_childpose', 'm_legsupwall', 'm_neck', 'm_figurefour', 'm_breathe'],
    ),

    // ----------------------------------------------------- WEEK 3 (15-21)
    DayBlueprint(
      day: 15,
      title: 'Halfway Full Body',
      focus: 'A benchmark day. Notice how much easier Day 1 would feel now.',
      warmup: _wFull,
      circuitA: ['l_squat', 'u_pushup', 'l_reverselunge', 'c_plank', 'k_jacks'],
      circuitB: ['l_slbridge', 'u_chairdip', 'l_wallsit', 'c_sideplank'],
      strength: ['l_splitsquat', 'u_pushup', 'l_slbridge'],
      conditioning: ['k_mountainclimber', 'k_jacks', 'k_skater'],
      core: ['c_plank', 'c_legraise', 'c_bicycle'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 16,
      title: 'Lower Body Progression',
      focus: 'Squat and lunge variations, tighter control.',
      warmup: _wLower,
      circuitA: ['l_squat', 'l_splitsquat', 'l_laterallunge', 'l_slbridge', 'l_calfraise'],
      circuitB: ['l_sumosquat', 'l_wallsit', 'l_kickback', 'l_hiphinge'],
      strength: ['l_splitsquat', 'l_slbridge', 'l_wallsit'],
      conditioning: ['k_skater', 'k_jacks', 'k_fastfeet'],
      core: ['c_plank', 'c_deadbug', 'c_legraise'],
      cooldown: _coolLower,
    ),
    DayBlueprint(
      day: 17,
      title: 'Upper Body Progression',
      focus: 'Push-up progressions and shoulder control.',
      warmup: _wUpper,
      circuitA: ['u_pushup', 'u_supermanpull', 'u_pikepush', 'u_chairdip', 'c_plank'],
      circuitB: ['u_widepush', 'c_sideplank', 'u_supermanpull', 'u_shouldertap'],
      strength: ['u_tempopush', 'u_pikepush', 'u_chairdip'],
      conditioning: ['k_shadowbox', 'k_jacks', 'k_mountainclimber'],
      core: ['c_plank', 'c_sideplank', 'c_hollow'],
      cooldown: _coolUpper,
    ),
    DayBlueprint(
      day: 18,
      title: 'Cardio + Core',
      focus: 'Intervals paired with bracing work.',
      warmup: _wCardio,
      circuitA: ['k_jacks', 'k_mountainclimber', 'k_skater', 'c_plank', 'k_fastfeet'],
      circuitB: ['k_stepbackburpee', 'c_bicycle', 'k_highknees', 'c_sideplank'],
      strength: ['l_squat', 'u_pushup', 'l_glutebridge'],
      conditioning: ['k_highknees', 'k_mountainclimber', 'k_jacks'],
      core: ['c_hollow', 'c_bicycle', 'c_legraise'],
      cooldown: _coolDeep,
    ),
    DayBlueprint(
      day: 19,
      title: 'Full Body Strength',
      focus: 'Heavier feeling variations, longer rests where earned.',
      warmup: _wFull,
      circuitA: ['l_splitsquat', 'u_pushup', 'l_slbridge', 'u_pikepush', 'c_plank'],
      circuitB: ['l_wallsit', 'u_chairdip', 'l_laterallunge', 'c_birddog'],
      strength: ['l_splitsquat', 'u_tempopush', 'l_slbridge'],
      conditioning: ['k_jacks', 'k_bearcrawl', 'k_skater'],
      core: ['c_plank', 'c_hollow', 'c_superman'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 20,
      title: 'Conditioning Blocks',
      focus: 'Longer working periods, honest short rests.',
      warmup: _wCardio,
      circuitA: ['k_stepbackburpee', 'l_squat', 'k_mountainclimber', 'u_pushup', 'k_highknees'],
      circuitB: ['k_bearcrawl', 'l_reverselunge', 'k_plankjack', 'c_plank'],
      strength: ['l_squat', 'u_pushup', 'l_calfraise'],
      conditioning: ['k_highknees', 'k_plankjack', 'k_skater'],
      core: ['c_bicycle', 'c_hollow', 'c_kneetuck'],
      cooldown: _coolDeep,
    ),
    DayBlueprint(
      day: 21,
      title: 'Recovery & Mobility',
      focus: 'Deload on purpose so week four can be strong.',
      recovery: true,
      warmup: ['w_march', 'w_catcow', 'w_shoulderroll', 'w_hipcircle', 'w_anklerock'],
      circuitA: ['m_downdog', 'm_figurefour', 'm_hipflexor', 'm_hamstring', 'm_chestopener'],
      circuitB: ['m_seatedtwist', 'm_calfstretch', 'm_quad', 'w_catcow'],
      strength: ['c_birddog', 'l_glutebridge', 'c_deadbug'],
      conditioning: ['k_march', 'w_stepjack', 'k_shadowbox'],
      core: ['c_deadbug', 'c_birddog', 'c_kneeplank'],
      cooldown: ['m_childpose', 'm_legsupwall', 'm_neck', 'm_figurefour', 'm_breathe'],
    ),

    // ----------------------------------------------------- WEEK 4 (22-28)
    DayBlueprint(
      day: 22,
      title: 'Full Body Performance',
      focus: 'Denser circuits. Keep the quality, keep the pace.',
      warmup: _wFull,
      circuitA: ['l_squat', 'u_pushup', 'l_splitsquat', 'k_mountainclimber', 'c_plank'],
      circuitB: ['l_slbridge', 'u_pikepush', 'k_skater', 'c_sideplankdip'],
      strength: ['l_splitsquat', 'u_tempopush', 'l_slbridge'],
      conditioning: ['k_burpee', 'k_highknees', 'k_plankjack'],
      core: ['c_hollow', 'c_legraise', 'c_bicycle'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 23,
      title: 'Lower Body Performance',
      focus: 'Legs under a real workload.',
      warmup: _wLower,
      circuitA: ['l_squat', 'l_splitsquat', 'l_laterallunge', 'l_wallsit', 'l_slbridge'],
      circuitB: ['l_jumpsquat', 'l_kickback', 'l_calfraise', 'l_hiphinge'],
      strength: ['l_splitsquat', 'l_jumpsquat', 'l_slbridge'],
      conditioning: ['k_skater', 'k_highknees', 'k_fastfeet'],
      core: ['c_plank', 'c_legraise', 'c_superman'],
      cooldown: _coolLower,
    ),
    DayBlueprint(
      day: 24,
      title: 'Upper Body + Core Performance',
      focus: 'Harder pushing, harder bracing.',
      warmup: _wUpper,
      circuitA: ['u_pushup', 'u_pikepush', 'u_shouldertap', 'u_supermanpull', 'c_plank'],
      circuitB: ['u_widepush', 'u_plankreach', 'u_chairdip', 'c_sideplankdip'],
      strength: ['u_tempopush', 'u_pikepush', 'u_chairdip'],
      conditioning: ['k_mountainclimber', 'k_plankjack', 'k_jacks'],
      core: ['c_hollow', 'c_bicycle', 'c_kneetuck'],
      cooldown: _coolUpper,
    ),
    DayBlueprint(
      day: 25,
      title: 'Cardio Density',
      focus: 'Longer work, minimal wasted rest.',
      warmup: _wCardio,
      circuitA: ['k_burpee', 'k_highknees', 'k_mountainclimber', 'k_skater', 'k_plankjack'],
      circuitB: ['k_bearcrawl', 'l_jumpsquat', 'k_fastfeet', 'c_plank'],
      strength: ['l_squat', 'u_pushup', 'l_slbridge'],
      conditioning: ['k_burpee', 'k_highknees', 'k_bearcrawl'],
      core: ['c_hollow', 'c_bicycle', 'c_legraise'],
      cooldown: _coolDeep,
    ),
    DayBlueprint(
      day: 26,
      title: 'Strength + Cardio Combo',
      focus: 'Everything you have built, in one session.',
      warmup: _wFull,
      circuitA: ['l_splitsquat', 'u_pushup', 'k_burpee', 'l_slbridge', 'c_plank'],
      circuitB: ['l_jumpsquat', 'u_pikepush', 'k_mountainclimber', 'c_sideplankdip'],
      strength: ['l_splitsquat', 'u_tempopush', 'l_jumpsquat'],
      conditioning: ['k_burpee', 'k_plankjack', 'k_highknees'],
      core: ['c_hollow', 'c_legraise', 'c_bicycle'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 27,
      title: 'Strength + Core Focus',
      focus: 'Controlled strength work and a demanding core block.',
      warmup: _wUpper,
      circuitA: ['u_tempopush', 'l_splitsquat', 'u_pikepush', 'l_slbridge', 'u_shouldertap'],
      circuitB: ['u_widepush', 'l_wallsit', 'u_chairdip', 'u_plankreach'],
      strength: ['u_tempopush', 'l_splitsquat', 'l_slbridge'],
      conditioning: ['k_bearcrawl', 'k_skater', 'k_jacks'],
      core: ['c_hollow', 'c_sideplankdip', 'c_legraise'],
      cooldown: _coolFull,
    ),
    DayBlueprint(
      day: 28,
      title: 'Active Recovery',
      focus: 'Deliberate easy day so Day 30 has fresh legs.',
      recovery: true,
      warmup: ['w_march', 'w_catcow', 'w_hipcircle', 'w_shoulderroll', 'w_legswing'],
      circuitA: ['m_downdog', 'm_hipflexor', 'm_figurefour', 'm_hamstring', 'm_chestopener'],
      circuitB: ['m_seatedtwist', 'm_quad', 'm_calfstretch', 'w_catcow'],
      strength: ['c_birddog', 'l_glutebridge', 'c_deadbug'],
      conditioning: ['k_march', 'w_stepjack', 'k_shadowbox'],
      core: ['c_deadbug', 'c_birddog', 'c_kneeplank'],
      cooldown: ['m_childpose', 'm_legsupwall', 'm_neck', 'm_figurefour', 'm_breathe'],
    ),

    // ------------------------------------------------------- FINISH (29-30)
    DayBlueprint(
      day: 29,
      title: 'Finale Primer',
      focus: 'Moderate, sharp and short. Rehearse tomorrow, do not race it.',
      warmup: _wFull,
      circuitA: ['l_squat', 'u_pushup', 'k_jacks', 'c_plank', 'l_slbridge'],
      circuitB: ['l_reverselunge', 'u_supermanpull', 'k_skater', 'c_deadbug'],
      strength: ['l_squat', 'u_kneepush', 'l_glutebridge'],
      conditioning: ['k_jacks', 'k_skater', 'k_march'],
      core: ['c_plank', 'c_deadbug', 'c_birddog'],
      cooldown: _coolDeep,
    ),
    DayBlueprint(
      day: 30,
      title: 'The 30-Day Finish Challenge',
      focus: 'Warm-up, full-body circuit, strength, cardio, core, cooldown.',
      warmup: _wFull,
      circuitA: ['l_squat', 'u_pushup', 'l_splitsquat', 'k_burpee', 'c_plank'],
      circuitB: ['l_jumpsquat', 'u_pikepush', 'k_mountainclimber', 'c_sideplankdip'],
      strength: ['u_tempopush', 'l_splitsquat', 'l_slbridge'],
      conditioning: ['k_burpee', 'k_highknees', 'k_plankjack'],
      core: ['c_hollow', 'c_legraise', 'c_bicycle'],
      cooldown: _coolDeep,
    ),
  ];

  /// One original message per day for the first challenge.
  static const List<String> quotes = [
    'Starting is the whole trick. Everything after this is repetition.',
    'You do not have to feel ready. You only have to begin.',
    'Skill comes from repeating a movement, not from punishing yourself.',
    'A plain, unimpressive session still counts in full.',
    'This week is about proving the habit is possible.',
    'Slightly harder than yesterday is exactly enough.',
    'Rest is part of the plan, not a break from it.',
    'Effort you can repeat beats effort you can brag about.',
    'Your legs know this work now. Let them do it.',
    'Ten days in, the excuse list is a lot shorter.',
    'Strength is mostly patience with a timer running.',
    'Move well first. Moving fast can wait.',
    'The middle of a challenge is where the habit actually sets.',
    'Recovering properly is a training decision, not a day off.',
    'Halfway. Everything you built so far is still with you.',
    'Small progressions, taken seriously, add up quickly.',
    'Control the movement and the difficulty takes care of itself.',
    'Steady breathing is a skill. Practise it today.',
    'You have already handled days you thought you could not.',
    'Twenty days of showing up is a real thing to own.',
    'Slow down today so next week can be strong.',
    'Density, not drama. Keep the pace honest.',
    'Your legs have earned this level of work.',
    'Finish every repetition the way you started it.',
    'Five days left. Stay steady rather than heroic.',
    'This is the part where consistency starts to show.',
    'Tired is fine. Careless is not.',
    'Recover well today; the finish deserves fresh legs.',
    'One measured day, then the finish line.',
    'Last day. Take it at your pace and enjoy the finish.',
  ];

  /// New messages for repeat challenges (Level 2 and above).
  static const List<String> quotesLevel2 = [
    'Round two. You already know the hardest part is opening the app.',
    'Same thirty days, a stronger version of you starting them.',
    'You are not learning the movements now. You are owning them.',
    'Add control before you add speed.',
    'The base is built. Today you build on it.',
    'Repeat what worked. Adjust what did not.',
    'Recovery still earns its place in the week.',
    'Endurance is just consistency with a heartbeat.',
    'Your second challenge should feel different, not impossible.',
    'Ten days of proof that the first thirty were not luck.',
    'Hold the standard even when the timer gets long.',
    'Technique first, tempo second, intensity last.',
    'You are past the point where motivation decides this.',
    'Ease off today on purpose. That is strength too.',
    'Halfway again, and the halfway point feels closer than before.',
    'Progress now is quieter, but it is still progress.',
    'A clean repetition is worth two rushed ones.',
    'Let the breath set the pace.',
    'Consistency has made this normal. That is the whole goal.',
    'Twenty days again. Different body, same discipline.',
    'Back off today so the last stretch stays sharp.',
    'Keep the rests honest and the work will look after itself.',
    'Push where you are strong, protect where you are not.',
    'Every session you finish is one you never have to make up.',
    'Nearly there. Steady beats spectacular.',
    'Combine everything today and trust the preparation.',
    'Fatigue is information, not an instruction.',
    'Rest properly. The finish is two days away.',
    'Light and sharp today. Save it for tomorrow.',
    'Second finish line. Take a moment when you cross it.',
  ];

  /// Short message shown on the completion screen.
  static const List<String> completions = [
    'You showed up on day one. That is the hardest one done.',
    'Two for two. The pattern is starting.',
    'Upper body handled. Notice how much steadier that felt.',
    'Heart rate up, hips open, day banked.',
    'First strength day complete. Good work.',
    'Conditioning done without going into the red. Exactly right.',
    'Recovery finished properly. That was the assignment.',
    'Longer intervals, and you stayed with them.',
    'Your legs did more today than they did on day two.',
    'Double figures. Ten days in the bank.',
    'Intervals done. Full recoveries taken. Well managed.',
    'That circuit had real strength work in it. Nice.',
    'You held the pace when the rests got short.',
    'A proper reset day. Your week four will thank you.',
    'Halfway through the challenge. Momentum is real now.',
    'Harder squat variations, controlled the whole way.',
    'Push-up progressions handled. That is measurable progress.',
    'Cardio and core together is no small session.',
    'Strong day. Everything felt heavier and you finished anyway.',
    'Long working blocks, and you stayed honest with the rests.',
    'You deloaded on purpose. That takes discipline too.',
    'Dense circuits, finished clean.',
    'That was a serious leg session. Well done.',
    'Upper body and core, both under real load. Finished.',
    'Five to go, and you just handled the busiest cardio day yet.',
    'Strength and conditioning combined. This is week-four fitness.',
    'Controlled strength plus a hard core block. Complete.',
    'Recovery taken seriously. Fresh legs for the finish.',
    'Primed and ready. Tomorrow is the finish.',
    'Thirty days. You finished the whole challenge.',
  ];

  static const Map<int, String> milestones = {
    1: 'Getting Started',
    7: 'First Week Complete',
    10: 'Building Momentum',
    15: 'Halfway Champion',
    20: 'Strong Habit',
    25: 'Final Stretch',
    30: '30-Day Finisher',
  };

  static String quoteFor(int day, int challengeLevel) {
    final i = (day.clamp(1, 30)) - 1;
    return challengeLevel <= 1 ? quotes[i] : quotesLevel2[i];
  }

  static String completionFor(int day) => completions[(day.clamp(1, 30)) - 1];
}
