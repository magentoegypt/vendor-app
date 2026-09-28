import '../../../../core/utils/json_parser.dart';

class CountryListModel {
  String? id;
  String? twoLetterAbbreviation;
  String? threeLetterAbbreviation;
  String? fullNameLocale;
  String? fullNameEnglish;

  /// The country's states or provinces, where the store has a list (empty for
  /// countries whose state is typed freely).
  List<CountryRegion> availableRegions = [];

  CountryListModel(
      {this.id,
        this.twoLetterAbbreviation,
        this.threeLetterAbbreviation,
        this.fullNameLocale,
        this.fullNameEnglish,
        List<CountryRegion>? availableRegions})
      : availableRegions = availableRegions ?? [];

  CountryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    twoLetterAbbreviation = json['two_letter_abbreviation'];
    threeLetterAbbreviation = json['three_letter_abbreviation'];
    fullNameLocale = json['full_name_locale'];
    fullNameEnglish = json['full_name_english'];
    availableRegions = JsonParser.toList(json['available_regions'], CountryRegion.fromJson) ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['two_letter_abbreviation'] = this.twoLetterAbbreviation;
    data['three_letter_abbreviation'] = this.threeLetterAbbreviation;
    data['full_name_locale'] = this.fullNameLocale;
    data['full_name_english'] = this.fullNameEnglish;
    data['available_regions'] = this.availableRegions.map((region) => region.toJson()).toList();
    return data;
  }

  /// The saved state of a profile in this country's list: by id, or else by
  /// the name or code the profile kept.
  CountryRegion? regionFor({int? regionId, String? region}) {
    for (final option in availableRegions) {
      if (regionId != null && option.id == regionId) return option;
    }
    final text = (region ?? '').trim().toLowerCase();
    if (text.isEmpty) return null;
    for (final option in availableRegions) {
      if (option.name?.toLowerCase() == text || option.code?.toLowerCase() == text) return option;
    }
    return null;
  }
}

class CountryRegion {
  int? id;
  String? code;
  String? name;

  CountryRegion({this.id, this.code, this.name});

  CountryRegion.fromJson(Map<String, dynamic> json) {
    id = JsonParser.toInt(json['id']);
    code = JsonParser.toStr(json['code']);
    name = JsonParser.toStr(json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'code': code, 'name': name};
}
