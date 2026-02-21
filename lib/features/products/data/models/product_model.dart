class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final double? rating;
  final String thumbnail;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.images,
    this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      rating: (json['rating'] as num?)?.toDouble(),
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
