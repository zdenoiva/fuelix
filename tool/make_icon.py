"""Generates the Fuelix launcher icon (Android mipmaps + adaptive foreground)."""

from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
RES = ROOT / "android" / "app" / "src" / "main" / "res"

SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

GREEN_TOP = (17, 178, 124)
GREEN_BOTTOM = (9, 113, 82)
WHITE = (255, 255, 255)
ACCENT = (198, 255, 120)


def gradient(size: int) -> Image.Image:
    image = Image.new("RGB", (size, size), GREEN_TOP)
    draw = ImageDraw.Draw(image)
    for y in range(size):
        t = y / max(1, size - 1)
        color = tuple(
            round(GREEN_TOP[i] + (GREEN_BOTTOM[i] - GREEN_TOP[i]) * t)
            for i in range(3)
        )
        draw.line([(0, y), (size, y)], fill=color)
    return image


def draw_pump(image: Image.Image, scale: float = 1.0) -> None:
    size = image.size[0]
    draw = ImageDraw.Draw(image, "RGBA")
    cx = size / 2
    cy = size / 2
    unit = size * scale

    body_w = unit * 0.34
    body_h = unit * 0.46
    left = cx - body_w * 0.55
    top = cy - body_h * 0.5
    right = left + body_w
    bottom = top + body_h
    radius = unit * 0.07

    # Hose first so the body covers its start.
    draw.line(
        [
            (right + unit * 0.01, top + unit * 0.06),
            (right + unit * 0.12, top + unit * 0.10),
            (right + unit * 0.12, bottom - unit * 0.10),
            (right + unit * 0.03, bottom - unit * 0.06),
        ],
        fill=WHITE,
        width=max(2, round(unit * 0.05)),
        joint="curve",
    )

    draw.rounded_rectangle(
        [left, top, right, bottom], radius=radius, fill=WHITE
    )

    # Display window.
    pad = unit * 0.055
    draw.rounded_rectangle(
        [
            left + pad,
            top + pad * 1.3,
            right - pad,
            top + unit * 0.20,
        ],
        radius=unit * 0.02,
        fill=GREEN_BOTTOM,
    )

    # Small accent droplet on the window.
    drop_r = unit * 0.035
    dx = right - pad - drop_r * 1.4
    dy = top + pad * 1.3 + unit * 0.075
    draw.ellipse(
        [dx - drop_r, dy - drop_r, dx + drop_r, dy + drop_r], fill=ACCENT
    )

    # Base plate.
    draw.rounded_rectangle(
        [
            left - unit * 0.05,
            bottom,
            right + unit * 0.05,
            bottom + unit * 0.045,
        ],
        radius=unit * 0.02,
        fill=WHITE,
    )


def main() -> None:
    for folder, size in SIZES.items():
        target = RES / folder / "ic_launcher.png"
        target.parent.mkdir(parents=True, exist_ok=True)

        icon = gradient(size).convert("RGBA")
        draw_pump(icon, scale=0.92)
        icon.save(target)

        # Adaptive foreground: transparent, content inside the safe zone.
        fg_size = round(size * 108 / 48)
        foreground = Image.new("RGBA", (fg_size, fg_size), (0, 0, 0, 0))
        draw_pump(foreground, scale=0.62)
        foreground.save(RES / folder / "ic_launcher_foreground.png")

    anydpi = RES / "mipmap-anydpi-v26"
    anydpi.mkdir(parents=True, exist_ok=True)
    (anydpi / "ic_launcher.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@color/ic_launcher_background" />\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground" />\n'
        "</adaptive-icon>\n",
        encoding="utf-8",
    )

    values = RES / "values" / "colors.xml"
    values.parent.mkdir(parents=True, exist_ok=True)
    values.write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        "<resources>\n"
        '    <color name="ic_launcher_background">#0E9F6E</color>\n'
        "</resources>\n",
        encoding="utf-8",
    )
    print("icons written")


if __name__ == "__main__":
    main()
