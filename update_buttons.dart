import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  int count = 0;
  for (final file in files) {
    String content = file.readAsStringSync();
    String original = content;
    
    // Support screen button texts
    content = content.replaceAll(
      "style: TextStyle(color: Colors.black, fontSize: 16)", 
      "style: TextStyle(color: const Color(0xFFE65100), fontSize: 16)"
    );
    
    // Support screen icons
    content = content.replaceAll(
      "Icon(Icons.add, color: Colors.black)", 
      "Icon(Icons.add, color: const Color(0xFFE65100))"
    );
    content = content.replaceAll(
      "Icon(Icons.chat_bubble_outline, color: Colors.black)", 
      "Icon(Icons.chat_bubble_outline, color: const Color(0xFFE65100))"
    );
    content = content.replaceAll(
      "Icon(issue.icon, color: Colors.black,", 
      "Icon(issue.icon, color: const Color(0xFFE65100),"
    );

    // General primary button texts mapped previously from white to black
    if (file.path.contains('cart_screen.dart') || 
        file.path.contains('items_screen.dart') || 
        file.path.contains('product_detail_screen.dart') ||
        file.path.contains('checkout_screen.dart')) {
      
      content = content.replaceAll(
        "color: Colors.black,", 
        "color: const Color(0xFFE65100),"
      );
      content = content.replaceAll(
        "color: Colors.black)", 
        "color: const Color(0xFFE65100))"
      );
    }
    
    // Exclude unintended replacements (e.g., text that should be dark)
    // Actually, in items_screen, product_detail_screen, cart_screen, the only `Colors.black` we introduced was for buttons!
    // But let's fix any `withOpacity` that might have been hit:
    content = content.replaceAll("const Color(0xFFE65100).withOpacity", "Colors.black.withOpacity");
    // Revert BoxShadow color if it got hit
    content = content.replaceAll("BoxShadow(color: const Color(0xFFE65100)", "BoxShadow(color: Colors.black");

    if (content != original) {
      file.writeAsStringSync(content);
      count++;
      print('Updated: ${file.path}');
    }
  }
  print('Total files updated: $count');
}
