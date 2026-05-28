import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  int count = 0;
  for (final file in files) {
    String content = file.readAsStringSync();
    String original = content;
    
    // Globally replace color: Colors.black, and color: Colors.black)
    content = content.replaceAll(
      "color: Colors.black,", 
      "color: const Color(0xFFE65100),"
    );
    content = content.replaceAll(
      "color: Colors.black)", 
      "color: const Color(0xFFE65100))"
    );
    
    // We must undo any .withOpacity replacements
    content = content.replaceAll("const Color(0xFFE65100).withOpacity", "Colors.black.withOpacity");
    // Undo shadow colors just in case
    content = content.replaceAll("BoxShadow(color: const Color(0xFFE65100)", "BoxShadow(color: Colors.black");
    // Also fix any BoxShadow(color: Colors.black, -> which got turned to const Color(...)
    // Shadows usually have withOpacity, but if there's a strict Colors.black in BoxShadow we'll ignore it.
    
    if (content != original) {
      file.writeAsStringSync(content);
      count++;
      print('Updated: ${file.path}');
    }
  }
  print('Total files updated: $count');
}
