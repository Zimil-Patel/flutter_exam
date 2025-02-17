class Contact {
  int? id;
  String name, phone, email, category;
  int isFavourite;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.category,
    this.isFavourite = 0,
  });

  // factory
  factory Contact.fromJson(Map map) => Contact(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        email: map['email'],
        category: map['category'],
        isFavourite: map['isFavourite'],
      );

  // convert to map
  static Map<String, Object?> toMap(Contact contact) {
    return {
      'id': contact.id,
      'name': contact.name,
      'phone': contact.phone,
      'email': contact.email,
      'category': contact.category,
      'isFavourite': contact.isFavourite,
    };
  }
}
