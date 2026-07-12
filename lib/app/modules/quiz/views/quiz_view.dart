import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() {
          return Text(
            controller.isQuizStarted.value
                ? "Jawab Kuis"
                : "Daftar Kuis Sejarah",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          );
        }),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () {
            if (controller.isQuizStarted.value) {
              controller.isQuizStarted.value = false;
            } else {
              Get.back();
            }
          },
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.quizzes.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.quizzes.isEmpty) {
          return Center(
            child: Text(
              "Tidak ada kuis tersedia saat ini.",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          );
        }

        if (!controller.isQuizStarted.value) {
          return _buildQuizListGate();
        }

        return _buildQuizActiveAnswering();
      }),
    );
  }

  Widget _buildQuizListGate() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.quizzes.length,
      itemBuilder: (context, index) {
        final quiz = controller.quizzes[index];
        final String cultureName = quiz['culture_name'] ?? 'Umum';
        final String? cultureId = quiz['culture_id'];
        final bool isSolved = quiz['is_solved'] ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSolved ? Colors.green.shade100 : Colors.grey.shade100,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSolved
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isSolved ? "Selesai" : "Belum Dikerjakan",
                      style: TextStyle(
                        color: isSolved
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "+${quiz['poin_reward']} Poin",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                cultureName,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                quiz['pertanyaan'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (cultureId != null)
                    OutlinedButton.icon(
                      onPressed: () => Get.toNamed(
                        Routes.DETAIL_BUDAYA,
                        arguments: cultureId,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(110, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      icon: const Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.accent,
                        size: 12,
                      ),
                      label: const Text(
                        "Pelajari Sejarah",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => controller.startSelectedQuiz(quiz),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSolved
                          ? Colors.grey.shade100
                          : AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(100, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: Text(
                      isSolved ? "Ulas Kuis" : "Mulai",
                      style: TextStyle(
                        color: isSolved ? Colors.grey.shade600 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizActiveAnswering() {
    final quiz = controller.activeQuiz.value!;
    final options = quiz['opsi_jawaban'] as Map<String, dynamic>;
    final bool isAlreadySolvedBefore = quiz['is_solved'] ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Kuis: ${quiz['culture_name']}",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "+${quiz['poin_reward']} Poin",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            quiz['pertanyaan'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 30),
          ...options.entries.map((entry) {
            final String key = entry.key;
            final String value = entry.value;

            return Obx(() {
              final bool isSelected = controller.selectedAnswer.value == key;
              final bool isAnswered =
                  controller.isAnswered.value || isAlreadySolvedBefore;
              final String correctAns = quiz['jawaban_benar'];

              Color cardColor = Colors.white;
              Color textColor = Colors.black87;
              BorderSide borderSide = BorderSide(color: Colors.grey.shade200);

              if (isSelected) {
                cardColor = AppColors.accent.withOpacity(0.1);
                borderSide = const BorderSide(
                  color: AppColors.accent,
                  width: 2,
                );
                textColor = AppColors.accent;
              }

              if (isAnswered) {
                if (key == correctAns) {
                  cardColor = Colors.green.shade50;
                  borderSide = BorderSide(
                    color: Colors.green.shade600,
                    width: 2,
                  );
                  textColor = Colors.green.shade700;
                } else if (isSelected && key != correctAns) {
                  cardColor = Colors.red.shade50;
                  borderSide = BorderSide(color: Colors.red.shade600, width: 2);
                  textColor = Colors.red.shade700;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: isAnswered
                      ? null
                      : () => controller.selectedAnswer.value = key,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.fromBorderSide(borderSide),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              key,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          }),
          const SizedBox(height: 40),
          Obx(() {
            final bool isAnswered =
                controller.isAnswered.value || isAlreadySolvedBefore;
            final bool isSelected = controller.selectedAnswer.value.isNotEmpty;

            if (isAlreadySolvedBefore) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Kuis ini sudah selesai dijawab rill sebelumnya. Poin Kuis tidak dapat diklaim ulang.",
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (!isAnswered) {
              return ElevatedButton(
                onPressed: isSelected
                    ? () => controller.submitQuizAnswer()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Kunci Jawaban",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: controller.isCorrect.value
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        controller.isCorrect.value
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                        color: controller.isCorrect.value
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.isCorrect.value
                              ? "Jawabanmu Benar! +${controller.pointsEarned.value} Poin ditambahkan."
                              : "Jawaban kurang tepat. Coba pelajari sejarah objek ini lagi ya!",
                          style: TextStyle(
                            color: controller.isCorrect.value
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.isQuizStarted.value = false;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Kembali ke Daftar Kuis",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
