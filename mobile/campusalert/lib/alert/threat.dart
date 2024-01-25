enum SyncThreat {
  fire(name: "Fire", pages: []),
  attacker(name: "Attacker", pages: []),
  storm(name: "Severe storm", pages: []);

  const SyncThreat({
    required this.name,
    required this.pages,
  });

  final String name;
  final List<int> pages;
}
