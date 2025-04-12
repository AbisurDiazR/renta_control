class Payment {
  final String key;
  final String name;

  Payment({
    required this.key,
    required this.name
  });

  Map<String, dynamic> toMap(){
    return {
      'key': key,
      'name': name
    };
  }
}