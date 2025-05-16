class AllQuestionModel {
  int? id; // Changed from String? to int?
  int? allQuestionModelId;
  String? title;
  int? numberOfQuestions;
  int? askableQuestions;
  List<Question>? questions;

  AllQuestionModel({
    this.id,
    this.allQuestionModelId,
    this.title,
    this.numberOfQuestions,
    this.askableQuestions,
    this.questions,
  });

  factory AllQuestionModel.fromJson(Map<String, dynamic> json) {
    return AllQuestionModel(
      id: json['id'] as int?, // Now matches int type
      allQuestionModelId: json['allQuestionModelId'] as int?,
      title: json['title'] as String?,
      numberOfQuestions: json['numberOfQuestions'] as int?,
      askableQuestions: json['askableQuestions'] as int?,
      questions:
          json['questions'] != null
              ? List<Question>.from(
                json['questions'].map((q) => Question.fromJson(q)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'allQuestionModelId': allQuestionModelId,
      'title': title,
      'numberOfQuestions': numberOfQuestions,
      'askableQuestions': askableQuestions,
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
    return data;
  }
}

class Question {
  int? sId;
  String? question;
  List<dynamic>? options;
  String? correctAnswer;

  Question({this.sId, this.question, this.options, this.correctAnswer});

  Question.fromJson(Map<String, dynamic> json) {
    sId = json['id'] as int?;
    question = json['question'];
    options = json['options'].cast<dynamic>();
    correctAnswer = json['correct_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = sId;
    data['question'] = question;
    data['options'] = options;
    data['correct_answer'] = correctAnswer;
    return data;
  }
}
