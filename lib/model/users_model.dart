class UsersModel {
  String name;
  String email;
  String phone;
  String uid;
  String image;
  String cover;
  String bio;


  UsersModel(
      {this.uid, this.email, this.phone, this.name,this.image,this.cover,this.bio});

  UsersModel.fromjson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uid = json['uid'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }

  Map<String, dynamic> ToMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
      'image':image,
      'cover':cover,
      'bio':bio,
    };
  }
}
