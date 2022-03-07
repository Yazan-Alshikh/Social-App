class PostModel {
  String name;
  String uid;
  String image;
  String text;
  String postimage;
  String datetime;

  PostModel({
    this.uid,
    this.name,
    this.image,
    this.text,
    this.datetime,
    this.postimage
  });

  PostModel.fromjson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    image = json['image'];
    text = json['text'];
    datetime = json['datetime'];
    postimage = json['postimage'];
  }

  Map<String, dynamic> ToMap() {
    return {
      'name': name,
      'uid': uid,
      'image': image,
      'text': text,
      'datetime': datetime,
      'postimage': postimage,
    };
  }
}
