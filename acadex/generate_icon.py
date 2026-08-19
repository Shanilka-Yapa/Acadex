from PIL import Image
from pathlib import Path

source = Path("assets/images/acadex_logo.jpeg")
output = Path("android/app/src/main/res")

sizes = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

image = Image.open(source).convert("RGBA")

for folder, size in sizes.items():
    folder_path = output / folder
    folder_path.mkdir(parents=True, exist_ok=True)

    resized = image.resize((size, size), Image.Resampling.LANCZOS)
    resized.save(folder_path / "ic_launcher.png")

    print(f"Created {folder}/ic_launcher.png ({size}x{size})")

print("\nAcadex app icons generated successfully!")