enum MeasurementType {
  g,
  kg,
  pcs;

  String toJson() => name;
  static MeasurementType fromJson(String json) => values.byName(json);
}
