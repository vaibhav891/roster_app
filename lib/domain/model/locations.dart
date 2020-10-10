class LocationsList {
  List<Locations> locations;

  LocationsList({this.locations});

  LocationsList.fromJson(Map<String, dynamic> json) {
    if (json['Locations'] != null) {
      locations = new List<Locations>();
      json['Locations'].forEach((v) {
        locations.add(new Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.locations != null) {
      data['Locations'] = this.locations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locations {
  int id;
  String name;
  String address;
  String city;
  String state;
  String country;
  int radiusInMeter;
  Location location;

  Locations({
    this.id,
    this.name,
    this.address,
    this.city,
    this.state,
    this.country,
    this.radiusInMeter,
    this.location,
  });

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    radiusInMeter = json['radiusInMeter'];
    location = json['location'] != null ? new Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['radiusInMeter'] = this.radiusInMeter;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Location {
  double latitude;
  double longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
