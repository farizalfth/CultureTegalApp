import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../controllers/analitik_controller.dart';

class AnalitikView extends GetView<AnalitikController> {
  const AnalitikView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              "Dashboard Analitik",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            Text(
              "Big Data Google Maps",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.topLocations.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final int totalReviews = controller.sentimentData['total'] ?? 0;

        return RefreshIndicator(
          onRefresh: () => controller.fetchAnalyticsData(),
          color: AppColors.primary,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(totalReviews),
                const SizedBox(height: 24),
                const Text(
                  "Peringkat Destinasi Tegal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "Berdasarkan volume ulasan tertinggi",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                _buildTopLocationsChart(),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filter Analisis",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _buildLocationFilter(),
                  ],
                ),
                const SizedBox(height: 20),
                if (totalReviews == 0)
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: const Text(
                      "Belum ada data untuk lokasi ini.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else ...[
                  const Text(
                    "Analisis Sentimen Publik",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  _buildSentimentChart(),
                  _buildWordCloudSection(),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLocationFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PopupMenuButton<String>(
        onSelected: controller.changeLocation,
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.filter_list_rounded,
              color: AppColors.primary,
              size: 16,
            ),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Text(
                controller.selectedLocation.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
          ],
        ),
        itemBuilder: (context) => controller.availableLocations.map((loc) {
          return PopupMenuItem<String>(
            value: loc,
            child: Text(loc, style: const TextStyle(fontSize: 13)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoCard(int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Ulasan Eksternal",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.isLoading.value ? "..." : "$total Teranalisis",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentChart() {
    final int positif = controller.sentimentData['positif'] ?? 0;
    final int netral = controller.sentimentData['netral'] ?? 0;
    final int negatif = controller.sentimentData['negatif'] ?? 0;
    final int total = controller.sentimentData['total'] ?? 1;

    final double pctPos = (positif / total);
    final double pctNet = (netral / total);
    final double pctNeg = (negatif / total);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                if (pctPos > 0)
                  Expanded(
                    flex: (pctPos * 100).toInt(),
                    child: Container(height: 12, color: Colors.green.shade500),
                  ),
                if (pctNet > 0)
                  Expanded(
                    flex: (pctNet * 100).toInt(),
                    child: Container(height: 12, color: Colors.amber.shade500),
                  ),
                if (pctNeg > 0)
                  Expanded(
                    flex: (pctNeg * 100).toInt(),
                    child: Container(height: 12, color: Colors.red.shade500),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sentimentLegend(
                "Positif (4-5\u2605)",
                positif,
                pctPos,
                Colors.green.shade500,
              ),
              _sentimentLegend(
                "Netral (3\u2605)",
                netral,
                pctNet,
                Colors.amber.shade500,
              ),
              _sentimentLegend(
                "Negatif (1-2\u2605)",
                negatif,
                pctNeg,
                Colors.red.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sentimentLegend(String label, int count, double pct, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 10, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "${(pct * 100).toStringAsFixed(1)}%",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          "$count Ulasan",
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildTopLocationsChart() {
    final locations = controller.topLocations;
    if (locations.isEmpty) return const SizedBox.shrink();

    int maxCount = locations.first['count'] ?? 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: locations.map((loc) {
          final double ratio = (loc['count'] / maxCount).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        loc['name'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 14,
                        ),
                        Text(
                          " ${loc['rating']}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: ratio,
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      child: Text(
                        "${loc['count']}",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWordCloudSection() {
    if (controller.wordCloudData.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          "Topik Terhangat (Word Cloud)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: controller.wordCloudData.map((item) {
              final word = item['text'] as String;
              final weight = item['value'] as int;
              final double scaledFontSize =
                  10.0 + (weight / 10).clamp(0.0, 12.0);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: scaledFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
