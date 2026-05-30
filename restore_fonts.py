import os
import subprocess

def get_old_content(filepath):
    try:
        # filepath must use forward slashes
        return subprocess.check_output(['git', 'show', f'bed998bf94b6a3506017c2db4a399166448fc636:{filepath}'], stderr=subprocess.DEVNULL).decode('utf-8')
    except subprocess.CalledProcessError:
        return ""

for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file).replace('\\', '/')
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
                
            if 'GoogleFonts.poppins' in content:
                # get old content
                old_content = get_old_content(filepath)
                if not old_content:
                    continue
                
                new_content = content
                
                # Check what was used in the old file
                if 'GoogleFonts.poppins' in old_content and 'GoogleFonts.barlowCondensed' not in old_content and 'GoogleFonts.dmSans' not in old_content:
                    pass # Keep poppins
                elif 'GoogleFonts.barlowCondensed' in old_content and 'GoogleFonts.dmSans' not in old_content:
                    new_content = new_content.replace('GoogleFonts.poppins', 'GoogleFonts.barlowCondensed')
                elif 'GoogleFonts.dmSans' in old_content and 'GoogleFonts.barlowCondensed' not in old_content:
                    new_content = new_content.replace('GoogleFonts.poppins', 'GoogleFonts.dmSans')
                else:
                    # Mixed or other. Default to barlowCondensed for UI elements.
                    new_content = new_content.replace('GoogleFonts.poppins', 'GoogleFonts.barlowCondensed')
                    
                if new_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"Updated {filepath}")

print("Done")
