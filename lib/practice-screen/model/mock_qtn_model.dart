class MockQuestionModel {
  final String questionId; // Should be non-nullable
  final String? question;
  final List<String>? options;

  MockQuestionModel({required this.questionId, this.question, this.options});

  factory MockQuestionModel.fromJson(Map<String, dynamic> json) {
    final questionId = json['questionId']?.toString();
    if (questionId == null || questionId.isEmpty) {
      throw FormatException('Invalid questionId in JSON: $json');
    }
    return MockQuestionModel(
      questionId: questionId,
      question: json['question'],
      options: List<String>.from(json['options'] ?? []),
    );
  }
}
