class Window {
  WindowBase open(String url, String name, [String? options]) {
    throw UnimplementedError();
  }
}

abstract class WindowBase {}

Window get window => Window();
