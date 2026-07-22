import fontforge

with open("./icons/positions.txt") as f:
    positions = {int(line.strip(), 16) for line in f if line.strip()}

font = fontforge.open("./icons/Icons.woff2")

# Select glyphs we want to keep
for glyph in font.glyphs():
    if glyph.unicode in positions:
        print("selecting", glyph.glyphname, hex(glyph.unicode))
        font.selection.select(("more",None), glyph)

font.selection.invert()
font.clear() # remove everything else

font.generate("./static/fonts/Icons.woff2")
font.close()
