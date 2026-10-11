"""Downloads the fonts the offline build bundles into assets/google_fonts/.

Online builds let the google_fonts package fetch fonts on first use; the
offline build turns that off (see lib/features/offline/offline_mode.dart)
and ships them instead. google_fonts picks a bundled file up by name —
"<Family>-<Variant>.ttf", e.g. CormorantGaramond-SemiBoldItalic.ttf — so
that's how they're saved here.

Families: the app font (Manrope) plus every font named by a scene-player
skin preset (lib/features/scene_player/presentation/theme/
scene_player_skin.dart). All are licensed under the SIL Open Font License,
which allows bundling. Add a family here when a preset starts using one.

    python tool/fetch_offline_fonts.py
"""

import pathlib
import re
import urllib.request

FAMILIES = {
    # family: (weights, has italics)
    "Manrope": ([200, 300, 400, 500, 600, 700, 800], False),
    "Cormorant Garamond": ([300, 400, 500, 600, 700], True),
    "Lora": ([400, 500, 600, 700], True),
    "Playfair Display": ([400, 500, 600, 700, 800, 900], True),
}

WEIGHT_NAMES = {
    100: "Thin", 200: "ExtraLight", 300: "Light", 400: "Regular", 500: "Medium",
    600: "SemiBold", 700: "Bold", 800: "ExtraBold", 900: "Black",
}

OUT = pathlib.Path(__file__).resolve().parent.parent / "assets" / "google_fonts"


def variant_name(weight: int, italic: bool) -> str:
    if not italic:
        return WEIGHT_NAMES[weight]
    return "Italic" if weight == 400 else WEIGHT_NAMES[weight] + "Italic"


def fetch(url: str) -> bytes:
    # A plain user agent makes the CSS API answer with whole .ttf files
    # rather than woff2 split into per-script subsets.
    request = urllib.request.Request(url, headers={"User-Agent": "curl/8"})
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for family, (weights, italics) in FAMILIES.items():
        if italics:
            axes = "ital,wght@" + ";".join(f"{i},{w}" for i in (0, 1) for w in weights)
        else:
            axes = "wght@" + ";".join(str(w) for w in weights)
        css = fetch(f"https://fonts.googleapis.com/css2?family={family.replace(' ', '+')}:{axes}").decode()

        faces = re.findall(
            r"font-style:\s*(\w+);\s*font-weight:\s*(\d+);.*?src:\s*url\((\S+?)\)", css, flags=re.S
        )
        if len(faces) != len(weights) * (2 if italics else 1):
            raise SystemExit(f"{family}: expected every weight, got {len(faces)} faces")

        for style, weight, url in faces:
            name = f"{family.replace(' ', '')}-{variant_name(int(weight), style == 'italic')}.ttf"
            target = OUT / name
            if not target.exists():
                target.write_bytes(fetch(url))
            print(f"{name}  {target.stat().st_size // 1024} KB")


if __name__ == "__main__":
    main()
