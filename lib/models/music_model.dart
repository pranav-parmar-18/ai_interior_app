class Music {
  int? id;
  String name;
  String description;
  String lyrics;
  String filePath;
  String imagePath;
  int? isFavorite;

  Music({
    this.id,
    required this.name,
    required this.description,
    required this.lyrics,
    required this.filePath,
    required this.imagePath,
    required this.isFavorite,
  });

  // Convert object to map (for database storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lyrics': lyrics,
      'filePath': filePath,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
    };
  }

  // Convert map to object (for retrieval)
  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      lyrics: map['lyrics'],
      filePath: map['filePath'],
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'],
    );
  }
}
