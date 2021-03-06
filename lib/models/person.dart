import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uri/uri.dart';
import 'package:html_character_entities/html_character_entities.dart';

part 'person.g.dart';

@JsonSerializable(nullable: true)
class Person {
  @JsonKey(name: 'first_name')
  String firstName;

  @JsonKey(name: 'last_name')
  String lastName;

  String gender;

  @JsonKey(name: 'preceding_titles')
  String precedingTitles;

  @JsonKey(name: 'postpositioned_titles')
  String postpositionedTitles;

  @JsonKey(name: 'card_uri')
  String tissUri;

  @JsonKey(name: 'picture_uri')
  String pictureUri;

  @JsonKey(name: 'preview_picture_uri')
  String previewPictureUri;

  @JsonKey(name: 'main_email')
  String email;

  @JsonKey(name: 'other_emails')
  List<String> otherEmails;

  @JsonKey(name: 'main_phone_number')
  String phoneNumber;

  // This text is HTML encoded!
  // I know, its cracy but you need to use getAdditionalInfos if you want to
  // get it decoded.
  //@JsonKey(name: 'additional_infos', includeIfNull: false)
  @JsonKey(name: 'additional_infos')
  List<String> rawAdditionalInfos;

  List<Employee> employee;
  Student student;

  Person();

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  String getName() {
    return "$firstName $lastName";
  }

  String getNameWithTitles() {
    String name = this.firstName + " " + this.lastName;

    if (this.precedingTitles != null) {
      name = precedingTitles + " " + name;
    }

    if (this.postpositionedTitles != null) {
      name += " " + this.postpositionedTitles;
    }

    return name;
  }

  String getGender() {
    if (this.gender == null) return "unbekannt";

    if (this.gender == 'M')
      return "männlich";
    else if (this.gender == 'W')
      return "weiblich";
    else
      return this.gender;
  }

  String getTissUrl() {
    if (this.tissUri != null) {
      return "https://tiss.tuwien.ac.at" + this.tissUri;
    }

    return null;
  }

  String getPictureUrl() {
    if (this.pictureUri != null) {
      return "https://tiss.tuwien.ac.at" + this.pictureUri;
    }

    return "https://www.tuwien.at/apple-touch-icon.png";
  }

  String getPreviewPictureUrl() {
    if (this.pictureUri != null) {
      return "https://tiss.tuwien.ac.at" + this.previewPictureUri;
    }

    return "https://www.tuwien.at/apple-touch-icon.png";
  }

  String getShortDescription() {
    String description = "";

    if (this.employee != null && this.student != null) {
      description = this.gender == "W"
          ? "Studentin und Mitarbeiterin"
          : "Student und Mitarbeiter";
    } else if (this.employee != null) {
      description = this.gender == "W" ? "Mitarbeiterin" : "Mitarbeiter";
    } else if (this.student != null) {
      description = this.gender == "W" ? "Studentin" : "Student";
      description += ", seit ${this.student.getMatriculationYear()}";
    } else {
      description = "keine Information";
    }

    if (this.employee != null) {
      for (Employee e in this.employee) {
        description += ", ${e.function}";
      }
    }

    return description;
  }

  String getShareText() {
    String s = "${getNameWithTitles()}\n\n${getShortDescription()}\n\n$email";
    if (this.phoneNumber != null) s += "\n\n$phoneNumber";
    s += "\n\n${getTissUrl()}";
    return s;
  }
}

@JsonSerializable(nullable: true)
class Student {
  @JsonKey(name: 'matriculation_number')
  String matriculationNumber;

  Student(this.matriculationNumber);

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  String getMatriculationYear() {
    String jjString = matriculationNumber[1] + matriculationNumber[2];
    int jj = int.parse(jjString);
    if (jj < 40) return "20$jjString";
    return "19$jjString";
  }
}

@JsonSerializable(nullable: true)
class Employee {
  @JsonKey(name: 'org_ref')
  Organisation orgRef;

  String function;

  Room room;

  @JsonKey(name: 'phone_numbers')
  List<String> phoneNumbers;

  List<Website> websites;

  Employee();

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}

@JsonSerializable(nullable: true)
class Organisation {
  @JsonKey(name: 'tiss_id')
  int tissId;

  @JsonKey(name: 'name_de')
  String name;

  Organisation();

  factory Organisation.fromJson(Map<String, dynamic> json) =>
      _$OrganisationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganisationToJson(this);

  String getTissUrl() {
    return "https://tiss.tuwien.ac.at/adressbuch/adressbuch/orgeinheit/" +
        tissId.toString();
  }
}

@JsonSerializable(nullable: true)
class Room {
  @JsonKey(name: 'room_code')
  String roomCode;

  Address address;

  Room();

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  // Return a link to https://tuw-maps.tuwien.ac.at which highlights the room.
  // Note to reader: it took me f***ing 30mins to figure out where I could get
  // a map to highlight the room because TISS uses an internal code to show you
  // the room which the API does not give you.
  String getMapUrl() {
    var template =
        new UriTemplate("https://tuw-maps.tuwien.ac.at/?q={room}#map");
    return template.expand({'room': this.roomCode});
  }
}

@JsonSerializable(nullable: true)
class Address {
  String street;

  @JsonKey(name: 'zip_code')
  String zipCode;

  String city;

  String country;

  Address();

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String toString() {
    String text = "$street, $zipCode $city";
    if (country != 'AT') text += " ($country)";
    return text;
  }
}

@JsonSerializable(nullable: true)
class Website {
  String uri;

  String title;

  Website();

  factory Website.fromJson(Map<String, dynamic> json) =>
      _$WebsiteFromJson(json);

  Map<String, dynamic> toJson() => _$WebsiteToJson(this);
}
