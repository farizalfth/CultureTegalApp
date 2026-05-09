import 'package:get/get.dart';
import '../../../data/models/umkm_model.dart';

class UmkmController extends GetxController {
  var selectedCategoryIndex = 0.obs;

  final RxList<UmkmModel> allProducts = <UmkmModel>[
    UmkmModel(
      id: "p1",
      name: "Batik Tegalan Klasik",
      price: "Rp250.000",
      storeName: "Batik Berkah",
      image: "https://www.wartabahari.com/wp-content/uploads/2017/10/baatik-tegal.jpg",
      category: "Fashion",
      rating: 4.8,
    ),
    UmkmModel(
      id: "p2",
      name: "Teh Poci Tanah Liat",
      price: "Rp45.000",
      storeName: "Teh Asli Tegal",
      image: "https://upload.wikimedia.org/wikipedia/commons/c/c3/Teh_Poci_Gula_Batu.jpg",
      category: "Kriya",
      rating: 4.9,
    ),
    UmkmModel(
      id: "p3",
      name: "Kerupuk Antor Bumbu",
      price: "Rp15.000",
      storeName: "Camilan Ibu Siti",
      image: "https://rricoid-assets.obs.ap-southeast-4.myhuaweicloud.com/berita/Semarang/o/1722830394570-WhatsApp_Image_2024-08-05_at_10.24.02_(1)/1axbz9w27i10r66.jpeg",
      category: "Kuliner",
      rating: 4.7,
    ),
    UmkmModel(
      id: "p4",
      name: "Kaos Galgil Tegal",
      price: "Rp85.000",
      storeName: "Galgil Store",
      image: "https://infotegal.com/wp-content/uploads/2014/10/kaos-galgil-tegal.jpg",
      category: "Fashion",
      rating: 4.6,
    ),
  ].obs;

  List<UmkmModel> get filteredProducts {
    if (selectedCategoryIndex.value == 0) return allProducts;
    final categories = ["Semua", "Kuliner", "Fashion", "Kriya"];
    String cat = categories[selectedCategoryIndex.value];
    return allProducts.where((p) => p.category == cat).toList();
  }

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
  }
}