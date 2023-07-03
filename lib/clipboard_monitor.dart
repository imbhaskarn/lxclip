import 'dart:convert';
import 'dart:io';

class ClipboardMonitor {
  late Process _process;
  late Function(String) _callback;

  void onChange(Function(String) callback) {
    _callback = callback;

    _startMonitoring();
  }

  void _startMonitoring() {
    _process = Process.start(
      'xclip',
      ['-selection', 'clipboard', '-loop', '1', '-verbose'],
      runInShell: true,
    ) as Process;

    _process.stdout.transform(utf8.decoder).listen((data) {
      // Extract clipboard content from the output
      final clipboardContent = _extractClipboardContent(data);

      if (clipboardContent != null) {
        _callback(clipboardContent);
      }
    });

    _process.stderr.transform(utf8.decoder).listen((data) {
      // Handle any error or diagnostic messages from xclip
      // ignore: avoid_print
      print('Error: $data');
    });
  }

  void stopMonitoring() {
    _process.kill();
  }

  String? _extractClipboardContent(String output) {
    const startMarker = 'selection/clipboard CUT_BUFFER0';
    const endMarker = 'selection/clipboard ';

    final startIndex = output.indexOf(startMarker);
    if (startIndex == -1) {
      return null;
    }

    final endIndex = output.indexOf(endMarker, startIndex + startMarker.length);
    if (endIndex == -1) {
      return null;
    }

    return output.substring(startIndex + startMarker.length, endIndex).trim();
  }
}
