import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  int count = 0;
  for (final file in files) {
    String content = file.readAsStringSync();
    String original = content;
    
    // Replace the old slate blue with deep orange
    content = content.replaceAll('0xFF82C8E5', '0xFFE65100');
    
    if (content != original) {
      file.writeAsStringSync(content);
      count++;
      print('Updated: ${file.path}');
    }
  }
  print('Total files updated: $count');
}
