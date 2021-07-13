class Category {
  int id;
  String name;

  Category(this.id, this.name);

  static List<Category> getCategory() {
    return <Category>[
      Category(1, 'Men'),
      Category(2, 'Women'),
      Category(3, 'Devices'),
      Category(4, 'Gadgets'),
      Category(5, 'Tools'),
    ];
  }
}