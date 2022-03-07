class MessageModel {
  String senderid;
  String receiverid;
  String text;
  String datetime;

  MessageModel ({this.text,this.datetime,this.receiverid,this.senderid});

  MessageModel.fromjson(Map<String,dynamic> json)
  {
    senderid = json['senderid'];
    receiverid = json['receiverid'];
    text = json['text'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> ToMap() {
    return {
      'senderid': senderid,
      'receiverid': receiverid,
      'text': text,
      'datetime': datetime,
    };
  }
}