import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/models.dart';

class ExploreController extends GetxController {
  final PageController pageController = PageController();
  var currentSliderIndex = 0.obs;
  var selectedCategoryIndex = 0.obs;
  var activeSliderItems = <CultureModel>[].obs;
  Timer? _timer;

  final List<CultureModel> allData = [
    CultureModel(
      id: "0",
      title: "Klenteng Tek Hay Kiong",
      subtitle: "Simbol Toleransi & Akulturasi",
      description:
          "Klenteng Tek Hay Kiong merupakan klenteng tertua di Kota Tegal yang didirikan pada abad ke-17. Bangunan ini tidak hanya menjadi tempat ibadah bagi umat Tri Dharma, tetapi juga menjadi simbol keharmonisan budaya dan toleransi yang sangat kuat di Kota Tegal. Arsitekturnya yang megah dipenuhi dengan ukiran-ukiran artistik khas Tionghoa kuno, dengan dominasi warna merah dan emas yang melambangkan keberuntungan serta kebahagiaan. Setiap sudut bangunan ini menyimpan cerita sejarah panjang mengenai perjalanan leluhur masyarakat Tionghoa di pesisir utara Jawa. Pada hari-hari besar seperti Imlek atau Cap Go Meh, klenteng ini menjadi pusat perhatian dengan berbagai festival budaya yang menarik ribuan wisatawan dari berbagai daerah.",
      image:
          "https://jogja.disway.id/upload/large/3890eacea4baf2dc08f8300d079fec8a.jpeg",
      category: "Tradisi",
      latitude: -6.8642,
      longitude: 109.1384,
      isSlider: true,
      builtYear: "Abad 17",
      subLocation: "Tegal Barat",
      duration: "45-60 mnt",
      distance: "1.2 km",
      funFact:
          "Nama 'Tek Hay Kiong' memiliki arti harfiah 'Istana Penenang Samudra'.",
      gallery: [
        "https://assets.promediateknologi.id/crop/0x0:0x0/1200x0/webp/photo/2022/02/01/1658411902.jpg",
        "https://jogja.disway.id/upload/large/3890eacea4baf2dc08f8300d079fec8a.jpeg",
      ],
      facilities: [
        FacilityModel(id: "f1", name: "Spot Foto", icon: "camera"),
        FacilityModel(id: "f2", name: "Area Parkir", icon: "parking"),
      ],
      reviews: [
        ReviewModel(
          id: "r0",
          userName: "Laksmana",
          userAvatar: "https://i.pravatar.cc/150?img=11",
          date: "3 hari lalu",
          rating: 5.0,
          comment: "Tempat yang sangat tenang dan penuh nilai sejarah tinggi.",
        ),
      ],
    ),
    CultureModel(
      id: "1",
      title: "Gedung Birao (SCS)",
      subtitle: "Lawang Sewunya Tegal",
      description:
          "Gedung bersejarah peninggalan Belanda yang megah dengan arsitektur klasik yang masih terawat sangat baik hingga saat ini.",
      image:
          "https://madosijateng.com/uploads/202209093030102104-DSC09666_11zon.jpg",
      category: "Sejarah",
      latitude: -6.8617,
      longitude: 109.1384,
      isSlider: true,
      builtYear: "1913",
      subLocation: "Tegal Timur",
      duration: "30-45 mnt",
      distance: "1.5 km",
      funFact:
          "Gedung ini dirancang oleh arsitek terkemuka Belanda, Henri Maclaine Pont.",
      gallery: [
        "https://madosijateng.com/uploads/202209093030102104-DSC09666_11zon.jpg",
      ],
      facilities: [
        FacilityModel(id: "f1", name: "Area Parkir", icon: "parking"),
      ],
      reviews: [
        ReviewModel(
          id: "r1",
          userName: "Andi Rahman",
          userAvatar: "https://i.pravatar.cc/150?img=1",
          date: "2 hari lalu",
          rating: 5.0,
          comment: "Tempat bersejarah yang sangat bagus.",
        ),
      ],
    ),
    CultureModel(
      id: "2",
      title: "Tahu Aci Tegal",
      subtitle: "Kuliner Khas Paling Populer",
      description:
          "Tahu goreng dengan isian adi gurih yang renyah di luar dan kenyal di dalam. Sangat nikmat dimakan bersama teh poci.",
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQviHVXAO_su-hxtU7dqtrRCwBZMM0BotQGBs1hwfk9b_4_uJ0e-Njlzm2_dIjurP5kD8-00rKiMNkG9XSjQ3sKxQr_Fs3Ig_FwD8p84g&s=10",
      category: "Kuliner",
      latitude: -6.8700,
      longitude: 109.1300,
      isSlider: true,
      builtYear: "Legendaris",
      subLocation: "Jl. AR. Hakim",
      duration: "15-20 mnt",
      distance: "0.8 km",
      funFact: "Tahu aci asli Tegal menggunakan tahu kuning yang padat.",
      gallery: [
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQviHVXAO_su-hxtU7dqtrRCwBZMM0BotQGBs1hwfk9b_4_uJ0e-Njlzm2_dIjurP5kD8-00rKiMNkG9XSjQ3sKxQr_Fs3Ig_FwD8p84g&s=10",
      ],
      facilities: [
        FacilityModel(id: "f2", name: "Area Makan", icon: "restaurant"),
      ],
      reviews: [
        ReviewModel(
          id: "r2",
          userName: "Siti Aminah",
          userAvatar: "https://i.pravatar.cc/150?img=5",
          date: "1 hari lalu",
          rating: 4.8,
          comment: "Rasanya juara, wajib beli kalau ke Tegal.",
        ),
      ],
    ),
    CultureModel(
      id: "3",
      title: "Pantai Alam Indah",
      subtitle: "Wisata Bahari Ikonik",
      description:
          "Pantai yang menawarkan keindahan sunset dan berbagai fasilitas rekreasi air untuk keluarga.",
      image:
          "https://visitjawatengah.jatengprov.go.id/assets/images/alam-indah-beach.jpg",
      category: "Wisata",
      latitude: -6.8500,
      longitude: 109.1400,
      isSlider: true,
      builtYear: "Alami",
      subLocation: "Mintaragen",
      duration: "1-2 jam",
      distance: "3.2 km",
      funFact:
          "Di sini terdapat Monumen Bahari yang menyimpan alat tempur asli.",
      gallery: [
        "https://visitjawatengah.jatengprov.go.id/assets/images/alam-indah-beach.jpg",
      ],
      facilities: [
        FacilityModel(id: "f3", name: "Toilet Umum", icon: "toilet"),
      ],
      reviews: [
        ReviewModel(
          id: "r3",
          userName: "Budi",
          userAvatar: "https://i.pravatar.cc/150?img=3",
          date: "5 jam lalu",
          rating: 4.5,
          comment: "Pasirnya bersih dan ombaknya tenang.",
        ),
      ],
    ),
    CultureModel(
      id: "4",
      title: "Batik Tegalan",
      subtitle: "Warisan Budaya Mendunia",
      description:
          "Batik Tegalan memiliki ciri khas warna-warna gelap dan motif yang tegas menggambarkan karakter masyarakat pesisir.",
      image:
          "https://asset.kompas.com/crops/En36rOebrLoFmlPusvTXHcwuNik=/132x43:823x504/750x500/data/photo/2023/06/16/648c7d59d1e20.png",
      category: "Tradisi",
      latitude: -6.8800,
      longitude: 109.1200,
      isSlider: true,
      builtYear: "Abad 19",
      subLocation: "Kampung Batik",
      duration: "1 jam",
      distance: "4.5 km",
      funFact: "Motif 'Beras Tumpah' adalah salah satu motif paling terkenal.",
      gallery: [
        "https://asset.kompas.com/crops/En36rOebrLoFmlPusvTXHcwuNik=/132x43:823x504/750x500/data/photo/2023/06/16/648c7d59d1e20.png",
      ],
      facilities: [
        FacilityModel(id: "f4", name: "Toko Souvenir", icon: "store"),
      ],
      reviews: [
        ReviewModel(
          id: "r4",
          userName: "Dewi",
          userAvatar: "https://i.pravatar.cc/150?img=10",
          date: "3 hari lalu",
          rating: 5.0,
          comment: "Kualitas kainnya luar biasa bagus.",
        ),
      ],
    ),
    CultureModel(
      id: "5",
      title: "Warteg Bahari",
      subtitle: "Sentra UMKM Kuliner",
      description:
          "Warung Tegal yang menjadi representasi kemandirian ekonomi masyarakat Tegal di seluruh Indonesia.",
      image:
          "https://awsimages.detik.net.id/community/media/visual/2024/03/14/catat-5-warteg-enak-puluhan-lauk-ini-buka-24-jam-cocok-buat-sahur-3_169.jpeg?w=600&q=90",
      category: "UMKM",
      latitude: -6.8900,
      longitude: 109.1500,
      isSlider: true,
      builtYear: "Modern",
      subLocation: "Seluruh Kota",
      duration: "30 mnt",
      distance: "2.1 km",
      funFact:
          "Warteg awalnya muncul dari kebutuhan makan pekerja proyek di Jakarta.",
      gallery: [
        "https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/panturapost/2023/09/Warteg.jpg",
      ],
      facilities: [
        FacilityModel(id: "f5", name: "Area Makan", icon: "restaurant"),
      ],
      reviews: [
        ReviewModel(
          id: "r5",
          userName: "Eko",
          userAvatar: "https://i.pravatar.cc/150?img=12",
          date: "1 minggu lalu",
          rating: 4.7,
          comment: "Menu pilihannya banyak dan murah meriah.",
        ),
      ],
    ),
    CultureModel(
      id: "6",
      title: "Masjid Agung Tegal",
      subtitle: "Ikon Religi & Sejarah",
      description:
          "Masjid utama kota dengan desain yang menggabungkan unsur modern dan tradisional.",
      image:
          "https://slawifm.com/wp-content/uploads/2025/04/menelusuri-jejak-islam-agama-mayoritas-di-tegal.jpg",
      category: "Sejarah",
      latitude: -6.8672,
      longitude: 109.1380,
      isSlider: true,
      builtYear: "1825",
      subLocation: "Alun-Alun",
      duration: "30 mnt",
      distance: "0.5 km",
      funFact:
          "Menara masjid ini dapat terlihat dari kejauhan di jalur pantura.",
      gallery: [
        "https://slawifm.com/wp-content/uploads/2025/04/menelusuri-jejak-islam-agama-mayoritas-di-tegal.jpg",
      ],
      facilities: [
        FacilityModel(id: "f6", name: "Tempat Ibadah", icon: "mosque"),
      ],
      reviews: [
        ReviewModel(
          id: "r6",
          userName: "Hadi",
          userAvatar: "https://i.pravatar.cc/150?img=15",
          date: "1 hari lalu",
          rating: 5.0,
          comment: "Sangat tenang untuk beribadah.",
        ),
      ],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _updateSliderItems();
  }

  void _updateSliderItems() {
    List<CultureModel> filtered;
    if (selectedCategoryIndex.value == 0) {
      filtered = allData.where((p) => p.isSlider).toList();
      filtered.shuffle();
    } else {
      String cat = [
        "Semua",
        "Sejarah",
        "Tradisi",
        "Kuliner",
        "Wisata",
        "UMKM",
      ][selectedCategoryIndex.value];
      filtered = allData.where((p) => p.category == cat && p.isSlider).toList();
    }
    activeSliderItems.value = filtered.take(5).toList();
    _startAutoSlider();
  }

  void _startAutoSlider() {
    _timer?.cancel();
    currentSliderIndex.value = 0;
    if (pageController.hasClients) pageController.jumpToPage(0);
    if (activeSliderItems.isEmpty) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      int max = activeSliderItems.length;
      if (max > 1) {
        if (currentSliderIndex.value < max - 1) {
          currentSliderIndex.value++;
        } else {
          currentSliderIndex.value = 0;
        }
        if (pageController.hasClients) {
          pageController.animateToPage(
            currentSliderIndex.value,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutQuart,
          );
        }
      }
    });
  }

  List<CultureModel> get filteredPlaces {
    if (selectedCategoryIndex.value == 0) return allData;
    String cat = [
      "Semua",
      "Sejarah",
      "Tradisi",
      "Kuliner",
      "Wisata",
      "UMKM",
    ][selectedCategoryIndex.value];
    return allData.where((p) => p.category == cat).toList();
  }

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
    _updateSliderItems();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
