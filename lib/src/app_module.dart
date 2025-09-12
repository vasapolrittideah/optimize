import 'package:core/core.dart';

class AppModule {
  AppModule._();

  static void init() {
    final List<BaseModule> modules = [CoreModule()];
    for (var module in modules) {
      module.setupDependencies();
    }
  }
}
