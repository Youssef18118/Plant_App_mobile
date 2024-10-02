class GuideModel {
  List<GuideData>? data;
  int? to;
  int? perPage;
  int? currentPage;
  int? from;
  int? lastPage;
  int? total;

  GuideModel(
      {this.data,
      this.to,
      this.perPage,
      this.currentPage,
      this.from,
      this.lastPage,
      this.total});

  GuideModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GuideData>[];
      json['data'].forEach((v) {
        data!.add(GuideData.fromJson(v));
      });
    }
    to = json['to'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    total = json['total'];
  }


}

class GuideData {
  int? id;
  int? speciesId;
  String? commonName;
  List<String>? scientificName;
  List<Section>? section;

  GuideData(
      {this.id,
      this.speciesId,
      this.commonName,
      this.scientificName,
      this.section});

  GuideData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    speciesId = json['species_id'];
    commonName = json['common_name'];
    scientificName = json['scientific_name'].cast<String>();
    if (json['section'] != null) {
      section = <Section>[];
      json['section'].forEach((v) {
        section!.add(Section.fromJson(v));
      });
    }
  }

  
}

class Section {
  int? id;
  String? type;
  String? description;

  Section({this.id, this.type, this.description});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    description = json['description'];
  }
}