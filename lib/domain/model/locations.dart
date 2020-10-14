class LocationsList {
  List<Sites> sites;

  LocationsList({this.sites});

  LocationsList.fromJson(Map<String, dynamic> json) {
    if (json['sites'] != null) {
      sites = new List<Sites>();
      json['sites'].forEach((v) {
        sites.add(new Sites.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sites != null) {
      data['sites'] = this.sites.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sites {
  int id;
  String name;
  String address;
  String city;
  String state;
  String country;
  String zipCode;
  int radiusInMeter;
  String company;
  Location location;

  Sites(
      {this.id,
      this.name,
      this.address,
      this.city,
      this.state,
      this.country,
      this.zipCode,
      this.radiusInMeter,
      this.company,
      this.location});

  Sites.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipCode = json['zipCode'];
    radiusInMeter = json['radiusInMeter'];
    company = json['company'];
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
    data['zipCode'] = this.zipCode;
    data['radiusInMeter'] = this.radiusInMeter;
    data['company'] = this.company;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Location {
  double latitude;
  double longitude;

  Location({this.latitude, this.longitude});

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
