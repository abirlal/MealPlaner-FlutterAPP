// lib/models/menu_model.dart

class MenuItem {
  final String menuName;
  final String menuType;
  final String menuSubtype;
  final String menuTag;
  final String menuImageUrl;
  final int vendorId;
  final int menuId;

  MenuItem({
    required this.menuName,
    required this.menuType,
    required this.menuSubtype,
    required this.menuTag,
    required this.menuImageUrl,
    required this.vendorId,
    required this.menuId,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menuName: json['menu_name'],
      menuType: json['menu_type'],
      menuSubtype: json['menu_subtype'],
      menuTag: json['menu_tag'],
      menuImageUrl: json['menu_image'],
      vendorId: json['vendor_id'],
      menuId: json['menu_id'],
    );
  }
}