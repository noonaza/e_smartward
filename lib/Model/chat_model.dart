// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  int? id;

  String? type_message;
  String? message;
  int? create_by;
  String? create_date;
  int? update_by;
  String? update_date;
  String? visit_number;
 String? create_by_name;
  ChatModel({
    this.id,
    this.type_message,
    this.message,
    this.create_by,
    this.create_date,
    this.update_by,
    this.update_date,
    this.visit_number,
    this.create_by_name,
  });

  ChatModel copyWith({
    int? id,
    String? type_message,
    String? message,
    int? create_by,
    String? create_date,
    int? update_by,
    String? update_date,
    String? visit_number,
    String? create_by_name,
  }) {
    return ChatModel(
      id: id ?? this.id,
      type_message: type_message ?? this.type_message,
      message: message ?? this.message,
      create_by: create_by ?? this.create_by,
      create_date: create_date ?? this.create_date,
      update_by: update_by ?? this.update_by,
      update_date: update_date ?? this.update_date,
      visit_number: visit_number ?? this.visit_number,
      create_by_name: create_by_name ?? this.create_by_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type_message': type_message,
      'message': message,
      'create_by': create_by,
      'create_date': create_date,
      'update_by': update_by,
      'update_date': update_date,
      'visit_number': visit_number,
      'create_by_name': create_by_name,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] != null ? map['id'] as int : null,
      type_message: map['type_message'] != null ? map['type_message'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      create_by: map['create_by'] != null ? map['create_by'] as int : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as int : null,
      update_date: map['update_date'] != null ? map['update_date'] as String : null,
      visit_number: map['visit_number'] != null ? map['visit_number'] as String : null,
      create_by_name: map['create_by_name'] != null ? map['create_by_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, type_message: $type_message, message: $message, create_by: $create_by, create_date: $create_date, update_by: $update_by, update_date: $update_date, visit_number: $visit_number, create_by_name: $create_by_name)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.type_message == type_message &&
      other.message == message &&
      other.create_by == create_by &&
      other.create_date == create_date &&
      other.update_by == update_by &&
      other.update_date == update_date &&
      other.visit_number == visit_number &&
      other.create_by_name == create_by_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type_message.hashCode ^
      message.hashCode ^
      create_by.hashCode ^
      create_date.hashCode ^
      update_by.hashCode ^
      update_date.hashCode ^
      visit_number.hashCode ^
      create_by_name.hashCode;
  }
}

class ChatMessage {
   String text;
   bool isMe;
  DateTime time;
   String? createByName;
  String? type;
  String? date;
   int? id;
  
  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.createByName,
    this.type,
    this.date,
    this.id,
  });

  ChatMessage copyWith({
    String? text,
    bool? isMe,
    DateTime? time,
    String? createByName,
    String? type,
    String? date,
    int? id,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      time: time ?? this.time,
      createByName: createByName ?? this.createByName,
      type: type ?? this.type,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'isMe': isMe,
      'time': time.millisecondsSinceEpoch,
      'createByName': createByName,
      'type': type,
      'date': date,
      'id': id,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: (map['text'] ?? '') as String,
      isMe: (map['isMe'] ?? false) as bool,
      time: DateTime.fromMillisecondsSinceEpoch((map['time']??0) as int),
      createByName: map['createByName'] != null ? map['createByName'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMessage(text: $text, isMe: $isMe, time: $time, createByName: $createByName, type: $type, date: $date, id: $id)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;
  
    return 
      other.text == text &&
      other.isMe == isMe &&
      other.time == time &&
      other.createByName == createByName &&
      other.type == type &&
      other.date == date &&
      other.id == id;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      isMe.hashCode ^
      time.hashCode ^
      createByName.hashCode ^
      type.hashCode ^
      date.hashCode ^
      id.hashCode;
  }
}

class CreateChat {
  String? visit_id;
   int? tl_common_users_id;
   String? type_message;
   String? message;
  CreateChat({
    this.visit_id,
    this.tl_common_users_id,
    this.type_message,
    this.message,
  });

  CreateChat copyWith({
    String? visit_id,
    int? tl_common_users_id,
    String? type_message,
    String? message,
  }) {
    return CreateChat(
      visit_id: visit_id ?? this.visit_id,
      tl_common_users_id: tl_common_users_id ?? this.tl_common_users_id,
      type_message: type_message ?? this.type_message,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'visit_id': visit_id,
      'tl_common_users_id': tl_common_users_id,
      'type_message': type_message,
      'message': message,
    };
  }

  factory CreateChat.fromMap(Map<String, dynamic> map) {
    return CreateChat(
      visit_id: map['visit_id'] != null ? map['visit_id'] as String : null,
      tl_common_users_id: map['tl_common_users_id'] != null ? map['tl_common_users_id'] as int : null,
      type_message: map['type_message'] != null ? map['type_message'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateChat.fromJson(String source) => CreateChat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreateChat(visit_id: $visit_id, tl_common_users_id: $tl_common_users_id, type_message: $type_message, message: $message)';
  }

  @override
  bool operator ==(covariant CreateChat other) {
    if (identical(this, other)) return true;
  
    return 
      other.visit_id == visit_id &&
      other.tl_common_users_id == tl_common_users_id &&
      other.type_message == type_message &&
      other.message == message;
  }

  @override
  int get hashCode {
    return visit_id.hashCode ^
      tl_common_users_id.hashCode ^
      type_message.hashCode ^
      message.hashCode;
  }
}
