import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useSearchReset({
  required TextEditingController controller,
  required ValueNotifier<String> keyword,
  ScrollController? scrollController,
  VoidCallback? onReset,
}) {
  useEffect(() {
    void listener() {
      final text = controller.text;
      if (text.trim().isEmpty && keyword.value.isNotEmpty) {
        keyword.value = '';

        if (scrollController != null && scrollController.hasClients) {
          scrollController.jumpTo(0);
        }

        onReset?.call();
      }
    }

    controller.addListener(listener);
    return () => controller.removeListener(listener);
  }, [controller, keyword, scrollController, onReset]);
}