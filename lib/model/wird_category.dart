class Wird_Category {
  final String wird_cat_id;
  final String wird_cat_title;

  const Wird_Category({
    this.wird_cat_id,
    this.wird_cat_title,
  });

  factory Wird_Category.fromJson(Map<String, dynamic> json) => Wird_Category(
        wird_cat_id: json['wird_cat_id'],
        wird_cat_title: json['wird_cat_title'],
      );

  Map<String, dynamic> toJson() => {
        'wird_cat_id': wird_cat_id,
        'wird_cat_title': wird_cat_title,
      };
}
