class CountryListModel {
  String? id;
  String? twoLetterAbbreviation;
  String? threeLetterAbbreviation;
  String? fullNameLocale;
  String? fullNameEnglish;

  CountryListModel(
      {this.id,
        this.twoLetterAbbreviation,
        this.threeLetterAbbreviation,
        this.fullNameLocale,
        this.fullNameEnglish});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    twoLetterAbbreviation = json['two_letter_abbreviation'];
    threeLetterAbbreviation = json['three_letter_abbreviation'];
    fullNameLocale = json['full_name_locale'];
    fullNameEnglish = json['full_name_english'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['two_letter_abbreviation'] = this.twoLetterAbbreviation;
    data['three_letter_abbreviation'] = this.threeLetterAbbreviation;
    data['full_name_locale'] = this.fullNameLocale;
    data['full_name_english'] = this.fullNameEnglish;
    return data;
  }
}