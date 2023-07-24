enum UserType {
  none,
  consumer,
  vendor,
  farmer;

  String toJson() => name;
  static UserType fromJson(String json) => values.byName(json);
}
