import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController {
  late final WebViewController webViewController;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final String urlString =
        Get.arguments as String? ?? 'https://tegalculture.id';

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(urlString));
  }
}
