// /lib/models/foodItem_model.dart



class FoodItem {
  final int id;
  final String name;
  final String description;
  final String highlight;
  final String imageUrl;
  final double rating;
  final int numberOfRating;
  final double price;
  final String slug;
  final String tag;
  final String vendorName;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.highlight,
    required this.imageUrl,
    required this.rating,
    required this.numberOfRating,
    required this.price,
    required this.slug,
    required this.tag,
    required this.vendorName,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: int.parse(json['item_id']),
      name: json['item_name'],
      description: json['item_desc'],
      highlight: json['item_highlight'],
      imageUrl: json['item_imageUrl'] ?? 'default_image',
      rating: json['item_rating'].toDouble(),
      numberOfRating: json['item_numberOfRating'],
      price: json['item_price'].toDouble(),
      slug: json['item_slug'] ?? '',
      tag: json['item_tag'],
      vendorName: json['vendor_name'],
    );
  }
}