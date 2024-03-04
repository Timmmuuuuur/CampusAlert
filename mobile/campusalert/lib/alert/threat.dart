enum SyncThreat {
  fire(name: "Fire", pages: [], serialized: 'fire'),
  attacker(name: "Attacker", pages: [], serialized: 'attacker'),
  storm(name: "Severe storm", pages: [], serialized: 'storm');

  const SyncThreat({
    required this.name,
    required this.pages,
    required this.serialized,
  });

  static SyncThreat? fromString(String s) {
    for (var t in SyncThreat.values) {
      if (t.serialized == s) return t;
    }

    return null;
  }

  final String name;
  final List<int> pages;
  final String serialized;
}
