class PredictionModel {
  String? description;
  String? id;
  int? distanceMeters;
  String? placeId;
  String? reference;

  PredictionModel(
      {this.description,
        this.id,
        this.distanceMeters,
        this.placeId,
        this.reference});

  PredictionModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    distanceMeters = json['distance_meters'];
    placeId = json['place_id'];
    reference = json['reference'];
  }

}