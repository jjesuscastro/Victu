// ignore_for_file: unused_field

class UserData {
  String id = "";
  String displayName = "";
  bool isMale = true;
  int age = 0;
  int height = 0;
  int weight = 0;

  UserData(this.id, this.displayName, this.isMale, this.age, this.height,
      this.weight);

  void setId(String _id) {
    id = _id;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'isMale': isMale,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }
}

UserData createUserData(value) {
  Map<String, dynamic> attributes = {
    'id': '',
    'displayName': '',
    'isMale': '',
    'age': 0,
    'height': 0,
    'weight': 0,
  };

  value.forEach((key, value) => {attributes[key] = value});

  UserData userData = UserData(
      attributes['id'],
      attributes['displayName'],
      attributes['isMale'],
      attributes['age'],
      attributes['height'],
      attributes['weight']);

  return userData;
}
