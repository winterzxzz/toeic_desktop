// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:toeic_desktop/data/models/ui_models/question.dart';

part 'question.g.dart';

List<Question> questionFromJson(String str) =>
    List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class Question {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "number")
  int number;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "audio")
  String? audio;
  @JsonKey(name: "paragraph")
  String? paragraph;
  @JsonKey(name: "option1")
  dynamic option1;
  @JsonKey(name: "option2")
  dynamic option2;
  @JsonKey(name: "option3")
  dynamic option3;
  @JsonKey(name: "option4")
  dynamic option4;
  @JsonKey(name: "correctanswer")
  Correctanswer correctanswer;
  @JsonKey(name: "options")
  List<Option> options;
  @JsonKey(name: "question")
  String? question;

  Question({
    required this.id,
    required this.number,
    this.image,
    this.audio,
    this.paragraph,
    required this.option1,
    required this.option2,
    required this.option3,
    this.option4,
    required this.correctanswer,
    required this.options,
    this.question,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  QuestionModel toQuestionModel() {
    int part;

    if (number >= 1 && number <= 6) {
      part = 1;
    } else if (number >= 7 && number <= 31) {
      part = 2;
    } else if (number >= 32 && number <= 70) {
      part = 3;
    } else if (number >= 71 && number <= 100) {
      part = 4;
    } else if (number >= 101 && number <= 130) {
      part = 5;
    } else if (number >= 131 && number <= 146) {
      part = 6;
    } else {
      part = 7;
    }

    return QuestionModel(
      id: id,
      image: image,
      audio: audio,
      paragraph: paragraph,
      question: question,
      option1: option1.toString(),
      option2: option2.toString(),
      option3: option3.toString(),
      option4: option4.toString(),
      options: options,
      correctAnswer: correctanswer.value,
      part: part,
      userAnswer: null,
    );
  }
}

enum Correctanswer {
  @JsonValue("A")
  A,
  @JsonValue("B")
  B,
  @JsonValue("C")
  C,
  @JsonValue("D")
  D
}

extension CorrectanswerExtension on Correctanswer {
  String get value => correctanswerValues.reverse[this]!;
}

final correctanswerValues = EnumValues({
  "A": Correctanswer.A,
  "B": Correctanswer.B,
  "C": Correctanswer.C,
  "D": Correctanswer.D
});

@JsonSerializable()
class Option {
  @JsonKey(name: "id")
  Correctanswer id;
  @JsonKey(name: "content")
  dynamic content;

  Option({
    required this.id,
    required this.content,
  });

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}