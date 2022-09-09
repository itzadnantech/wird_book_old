import 'dart:ffi';

class Wird {
  final String wird_cat_id;
  final String wird_sub_cat_id;
  final String wird_id;
  final String wird_description;
  final String wird_audio_link;

  const Wird({
    this.wird_cat_id,
    this.wird_sub_cat_id,
    this.wird_id,
    this.wird_description,
    this.wird_audio_link,
  });

  factory Wird.fromJson(Map<String, dynamic> json) => Wird(
        wird_cat_id: json['wird_cat_id'],
        wird_sub_cat_id: json['wird_sub_cat_id'],
        wird_id: json['wird_id'],
        wird_description: json['wird_description'],
        wird_audio_link: json['wird_audio_link'],
      );

  Map<String, dynamic> toJson() => {
        'wird_cat_id': wird_cat_id,
        'wird_sub_cat_id': wird_sub_cat_id,
        'wird_id': wird_id,
        'wird_description': wird_description,
        'wird_audio_link': wird_audio_link,
      };
}
