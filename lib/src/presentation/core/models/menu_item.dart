class MenuItem {
  const MenuItem({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.rank,
    this.likes = 0,
    this.dislikes = 0,
    this.description,
    this.isAvailable,
  });

  final String? id;
  final String name;
  final String price;
  final String imageUrl;
  final int? rank;
  final int likes;
  final int dislikes;
  final String? description;
  final bool? isAvailable;
}
