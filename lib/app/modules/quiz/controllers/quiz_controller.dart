import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../data/service/auth_service.dart';
import '../../../data/service/user_service.dart';
import '../../../data/models/user_model.dart';

class QuizController extends GetxController {
  final String baseUrl = dotenv.env['FLASK_API_URL'] ?? '';
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  var quizzes = <dynamic>[].obs;
  var isQuizStarted = false.obs;
  var activeQuiz = Rxn<dynamic>();

  var selectedAnswer = "".obs;
  var isAnswered = false.obs;
  var isCorrect = false.obs;
  var pointsEarned = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuizzesData();
  }

  Future<void> loadQuizzesData() async {
    try {
      isLoading.value = true;
      final dynamic argId = Get.arguments;

      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final String requestPath = argId != null && argId is String
          ? '$cleanBase/quizzes/culture/$argId'
          : '$cleanBase/quizzes';

      final response = await http.get(
        Uri.parse(requestPath),
        headers: {'Authorization': 'Bearer ${_authService.currentToken}'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        quizzes.assignAll(data);
      } else {
        quizzes.assignAll(_getFallbackQuizzes());
      }
    } catch (e) {
      quizzes.assignAll(_getFallbackQuizzes());
    } finally {
      isLoading.value = false;
    }
  }

  void startSelectedQuiz(dynamic quiz) {
    activeQuiz.value = quiz;
    selectedAnswer.value = "";
    isAnswered.value = false;
    isCorrect.value = false;
    pointsEarned.value = 0;
    isQuizStarted.value = true;
  }

  Future<void> submitQuizAnswer() async {
    if (selectedAnswer.value.isEmpty || isAnswered.value) return;

    try {
      isLoading.value = true;
      final String quizId = activeQuiz.value['id'];

      final String cleanBase = baseUrl.endsWith('/api/v1')
          ? baseUrl
          : '$baseUrl/api/v1';
      final response = await http.post(
        Uri.parse('$cleanBase/quizzes/$quizId/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_authService.currentToken}',
        },
        body: json.encode({'jawaban': selectedAnswer.value}),
      );

      isAnswered.value = true;

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        isCorrect.value = result['correct'] ?? false;
        pointsEarned.value = result['points_earned'] ?? 0;
        if (isCorrect.value) {
          _markQuizAsSolvedLocally(quizId);
        }
        await UserService.to.refreshUserData();
      } else {
        isCorrect.value =
            selectedAnswer.value == activeQuiz.value['jawaban_benar'];
        pointsEarned.value = isCorrect.value
            ? activeQuiz.value['poin_reward']
            : 0;
        if (isCorrect.value) {
          _markQuizAsSolvedLocally(quizId);
          final currentUser = UserService.to.user.value;
          if (currentUser != null) {
            final currentPoints =
                int.tryParse(currentUser.points.replaceAll('.', '')) ?? 0;
            final newPoints = currentPoints + pointsEarned.value;
            UserService.to.user.value = UserModel(
              id: currentUser.id,
              name: currentUser.name,
              email: currentUser.email,
              profilePicture: currentUser.profilePicture,
              points: newPoints.toString(),
            );
          }
        }
      }
    } catch (e) {
      final String quizId = activeQuiz.value['id'];
      isCorrect.value =
          selectedAnswer.value == activeQuiz.value['jawaban_benar'];
      pointsEarned.value = isCorrect.value
          ? activeQuiz.value['poin_reward']
          : 0;
      isAnswered.value = true;
      if (isCorrect.value) {
        _markQuizAsSolvedLocally(quizId);
        final currentUser = UserService.to.user.value;
        if (currentUser != null) {
          final currentPoints =
              int.tryParse(currentUser.points.replaceAll('.', '')) ?? 0;
          final newPoints = currentPoints + pointsEarned.value;
          UserService.to.user.value = UserModel(
            id: currentUser.id,
            name: currentUser.name,
            email: currentUser.email,
            profilePicture: currentUser.profilePicture,
            points: newPoints.toString(),
          );
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _markQuizAsSolvedLocally(String quizId) {
    int index = quizzes.indexWhere((q) => q['id'] == quizId);
    if (index != -1) {
      var updated = Map<String, dynamic>.from(quizzes[index]);
      updated['is_solved'] = true;
      quizzes[index] = updated;
    }
  }

  List<dynamic> _getFallbackQuizzes() {
    return [
      {
        "id": "e0000000-0000-0000-0000-000000000001",
        "culture_id": "8501f741-2345-41d4-a716-446655440000",
        "culture_name": "Klenteng Tek Hay Kiong",
        "pertanyaan":
            "Apa arti harfiah dari nama Klenteng tertua di Tegal, Tek Hay Kiong?",
        "opsi_jawaban": {
          "A": "Istana Penyejuk Jiwa",
          "B": "Istana Penenang Samudra",
          "C": "Gerbang Kemakmuran Pesisir",
          "D": "Kuil Keselamatan Pelaut",
        },
        "jawaban_benar": "B",
        "poin_reward": 50,
        "is_solved": false,
      },
      {
        "id": "e0000000-0000-0000-0000-000000000002",
        "culture_id": "8501f741-2345-41d4-a716-446655440000",
        "culture_name": "Gedung Birao (SCS)",
        "pertanyaan":
            "Siapakah arsitek Belanda terkemuka yang merancang kemegahan Gedung Birao (SCS) Tegal?",
        "opsi_jawaban": {
          "A": "Henri Maclaine Pont",
          "B": "Thomas Karsten",
          "C": "H.P. Berlage",
          "D": "J.F.L. Blankenberg",
        },
        "jawaban_benar": "A",
        "poin_reward": 50,
        "is_solved": false,
      },
    ];
  }
}
