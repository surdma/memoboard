import 'package:board/hasher/hasher.dart';
import 'package:equatable/equatable.dart';

class QuestionModel extends Equatable {
  final String uniqueId;
  final String question;
  final String answer;
  final String explanation;
  final String topicName;
  final String difficultyLevel;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String quizType;

  QuestionModel({
    required this.uniqueId,
    required this.question,
    required this.answer,
    required this.explanation,
    required this.topicName,
    required this.difficultyLevel,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.quizType,
  });

  Map<String, dynamic> toMap() {
    return {
      'unique_id': uniqueId,
      'question': question,
      'answer': answer,
      'explanation': explanation,
      'topic_name': topicName,
      'difficulty_level': difficultyLevel,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'quiz_type': quizType,
    };
  }

  factory QuestionModel.fromJson(Map<String, dynamic> map) {
    print(map['unique_id'].toString());
    try {
      return QuestionModel(
        uniqueId: map['unique_id'].toString(),
        question: QuestionHasher.encrpter(map['question'].toString()),
        answer: QuestionHasher.encrpter(map['answer'].toString()),
        explanation: QuestionHasher.encrpter(map['explanation'].toString()),
        topicName: QuestionHasher.encrpter(map['topic_name'].toString()),
        difficultyLevel:
            QuestionHasher.encrpter(map['difficulty_level'].toString()),
        optionA: QuestionHasher.encrpter(map['option_a'].toString()),
        optionB: QuestionHasher.encrpter(map['option_b'].toString()),
        optionC: QuestionHasher.encrpter(map['option_c'].toString()),
        optionD: QuestionHasher.encrpter(map['option_d'].toString()),
        quizType: map['quiz_type'].toString(),
      );
    } catch (e, stack) {
      print("Question Model Error [$e] Stack Trace [$stack]");
      throw Exception(e);
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        uniqueId,
        question,
        answer,
        explanation,
        topicName,
        difficultyLevel,
        optionA,
        optionB,
        optionC,
        optionD,
        quizType,
      ];
}
