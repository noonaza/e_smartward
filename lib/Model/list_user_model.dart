// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListUserModel {
  int? id;
  String? full_name;
  String? email;
  String? employee_id;
  String? name_th;
  String? name_en;
  String? title_name_en;
  String? user_login;
  String? pass_user;
  String? site_id;
  String? site_name;
  String? department_id;
  String? department_name;
  String? sub_department_id;
  String? sub_department_name;
  String? position_id;
  String? position_detail;
  String? position_name;
  String? status;
  String? role_id;
  String? admin_site;
  String? create_by;
  String? create_date;
  String? update_by;
  String? update_date;
  String? delete_by;
  String? delete_date;
  String? access_token;
  ListUserModel({
    this.id,
    this.full_name,
    this.email,
    this.employee_id,
    this.name_th,
    this.name_en,
    this.title_name_en,
    this.user_login,
    this.pass_user,
    this.site_id,
    this.site_name,
    this.department_id,
    this.department_name,
    this.sub_department_id,
    this.sub_department_name,
    this.position_id,
    this.position_detail,
    this.position_name,
    this.status,
    this.role_id,
    this.admin_site,
    this.create_by,
    this.create_date,
    this.update_by,
    this.update_date,
    this.delete_by,
    this.delete_date,
    this.access_token,
  });

  ListUserModel copyWith({
    int? id,
    String? full_name,
    String? email,
    String? employee_id,
    String? name_th,
    String? name_en,
    String? title_name_en,
    String? user_login,
    String? pass_user,
    String? site_id,
    String? site_name,
    String? department_id,
    String? department_name,
    String? sub_department_id,
    String? sub_department_name,
    String? position_id,
    String? position_detail,
    String? position_name,
    String? status,
    String? role_id,
    String? admin_site,
    String? create_by,
    String? create_date,
    String? update_by,
    String? update_date,
    String? delete_by,
    String? delete_date,
    String? access_token,
  }) {
    return ListUserModel(
      id: id ?? this.id,
      full_name: full_name ?? this.full_name,
      email: email ?? this.email,
      employee_id: employee_id ?? this.employee_id,
      name_th: name_th ?? this.name_th,
      name_en: name_en ?? this.name_en,
      title_name_en: title_name_en ?? this.title_name_en,
      user_login: user_login ?? this.user_login,
      pass_user: pass_user ?? this.pass_user,
      site_id: site_id ?? this.site_id,
      site_name: site_name ?? this.site_name,
      department_id: department_id ?? this.department_id,
      department_name: department_name ?? this.department_name,
      sub_department_id: sub_department_id ?? this.sub_department_id,
      sub_department_name: sub_department_name ?? this.sub_department_name,
      position_id: position_id ?? this.position_id,
      position_detail: position_detail ?? this.position_detail,
      position_name: position_name ?? this.position_name,
      status: status ?? this.status,
      role_id: role_id ?? this.role_id,
      admin_site: admin_site ?? this.admin_site,
      create_by: create_by ?? this.create_by,
      create_date: create_date ?? this.create_date,
      update_by: update_by ?? this.update_by,
      update_date: update_date ?? this.update_date,
      delete_by: delete_by ?? this.delete_by,
      delete_date: delete_date ?? this.delete_date,
      access_token: access_token ?? this.access_token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'full_name': full_name,
      'email': email,
      'employee_id': employee_id,
      'name_th': name_th,
      'name_en': name_en,
      'title_name_en': title_name_en,
      'user_login': user_login,
      'pass_user': pass_user,
      'site_id': site_id,
      'site_name': site_name,
      'department_id': department_id,
      'department_name': department_name,
      'sub_department_id': sub_department_id,
      'sub_department_name': sub_department_name,
      'position_id': position_id,
      'position_detail': position_detail,
      'position_name': position_name,
      'status': status,
      'role_id': role_id,
      'admin_site': admin_site,
      'create_by': create_by,
      'create_date': create_date,
      'update_by': update_by,
      'update_date': update_date,
      'delete_by': delete_by,
      'delete_date': delete_date,
      'access_token': access_token,
    };
  }

  factory ListUserModel.fromMap(Map<String, dynamic> map) {
    return ListUserModel(
      id: map['id'] != null ? map['id'] as int : null,
      full_name: map['full_name'] != null ? map['full_name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      employee_id: map['employee_id'] != null ? map['employee_id'] as String : null,
      name_th: map['name_th'] != null ? map['name_th'] as String : null,
      name_en: map['name_en'] != null ? map['name_en'] as String : null,
      title_name_en: map['title_name_en'] != null ? map['title_name_en'] as String : null,
      user_login: map['user_login'] != null ? map['user_login'] as String : null,
      pass_user: map['pass_user'] != null ? map['pass_user'] as String : null,
      site_id: map['site_id'] != null ? map['site_id'] as String : null,
      site_name: map['site_name'] != null ? map['site_name'] as String : null,
      department_id: map['department_id'] != null ? map['department_id'] as String : null,
      department_name: map['department_name'] != null ? map['department_name'] as String : null,
      sub_department_id: map['sub_department_id'] != null ? map['sub_department_id'] as String : null,
      sub_department_name: map['sub_department_name'] != null ? map['sub_department_name'] as String : null,
      position_id: map['position_id'] != null ? map['position_id'] as String : null,
      position_detail: map['position_detail'] != null ? map['position_detail'] as String : null,
      position_name: map['position_name'] != null ? map['position_name'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      role_id: map['role_id'] != null ? map['role_id'] as String : null,
      admin_site: map['admin_site'] != null ? map['admin_site'] as String : null,
      create_by: map['create_by'] != null ? map['create_by'] as String : null,
      create_date: map['create_date'] != null ? map['create_date'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      update_date: map['update_date'] != null ? map['update_date'] as String : null,
      delete_by: map['delete_by'] != null ? map['delete_by'] as String : null,
      delete_date: map['delete_date'] != null ? map['delete_date'] as String : null,
      access_token: map['access_token'] != null ? map['access_token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListUserModel.fromJson(String source) =>
      ListUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListUserModel(id: $id, full_name: $full_name, email: $email, employee_id: $employee_id, name_th: $name_th, name_en: $name_en, title_name_en: $title_name_en, user_login: $user_login, pass_user: $pass_user, site_id: $site_id, site_name: $site_name, department_id: $department_id, department_name: $department_name, sub_department_id: $sub_department_id, sub_department_name: $sub_department_name, position_id: $position_id, position_detail: $position_detail, position_name: $position_name, status: $status, role_id: $role_id, admin_site: $admin_site, create_by: $create_by, create_date: $create_date, update_by: $update_by, update_date: $update_date, delete_by: $delete_by, delete_date: $delete_date, access_token: $access_token)';
  }

  @override
  bool operator ==(covariant ListUserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.full_name == full_name &&
      other.email == email &&
      other.employee_id == employee_id &&
      other.name_th == name_th &&
      other.name_en == name_en &&
      other.title_name_en == title_name_en &&
      other.user_login == user_login &&
      other.pass_user == pass_user &&
      other.site_id == site_id &&
      other.site_name == site_name &&
      other.department_id == department_id &&
      other.department_name == department_name &&
      other.sub_department_id == sub_department_id &&
      other.sub_department_name == sub_department_name &&
      other.position_id == position_id &&
      other.position_detail == position_detail &&
      other.position_name == position_name &&
      other.status == status &&
      other.role_id == role_id &&
      other.admin_site == admin_site &&
      other.create_by == create_by &&
      other.create_date == create_date &&
      other.update_by == update_by &&
      other.update_date == update_date &&
      other.delete_by == delete_by &&
      other.delete_date == delete_date &&
      other.access_token == access_token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      full_name.hashCode ^
      email.hashCode ^
      employee_id.hashCode ^
      name_th.hashCode ^
      name_en.hashCode ^
      title_name_en.hashCode ^
      user_login.hashCode ^
      pass_user.hashCode ^
      site_id.hashCode ^
      site_name.hashCode ^
      department_id.hashCode ^
      department_name.hashCode ^
      sub_department_id.hashCode ^
      sub_department_name.hashCode ^
      position_id.hashCode ^
      position_detail.hashCode ^
      position_name.hashCode ^
      status.hashCode ^
      role_id.hashCode ^
      admin_site.hashCode ^
      create_by.hashCode ^
      create_date.hashCode ^
      update_by.hashCode ^
      update_date.hashCode ^
      delete_by.hashCode ^
      delete_date.hashCode ^
      access_token.hashCode;
  }
}
