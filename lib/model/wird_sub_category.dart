class Wird_Sub_Category {
  final String wird_cat_id;
  final String wird_sub_cat_id;
  final String wird_sub_cat_title;
  final String wird_audio_link;

  const Wird_Sub_Category({
    required this.wird_cat_id,
    required this.wird_sub_cat_id,
    required this.wird_sub_cat_title,
    required this.wird_audio_link,
  });

  factory Wird_Sub_Category.fromJson(Map<String, dynamic> json) =>
      Wird_Sub_Category(
        wird_cat_id: json['wird_cat_id'],
        wird_sub_cat_id: json['wird_sub_cat_id'],
        wird_sub_cat_title: json['wird_sub_cat_title'],
        wird_audio_link: json['wird_audio_link'],
      );

  Map<String, dynamic> toJson() => {
        'wird_cat_id': wird_cat_id,
        'wird_sub_cat_id': wird_sub_cat_id,
        'wird_sub_cat_title': wird_sub_cat_title,
        'wird_audio_link': wird_audio_link,
      };
}
