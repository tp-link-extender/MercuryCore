echo "Processing corescripts..."
for file in ./corescripts/luau/[0-9]*.luau; do
	darklua process -c dense.json5 $file ./corescripts/processed/$(basename "${file::-1}")
done

echo "Processing libraries..."
darklua process -c dense.json5 ./corescripts/Libraries/Fusion/init.luau ./corescripts/processed/10000001.lua
darklua process -c bundle.json5 ./corescripts/Libraries/Red/init.luau ./corescripts/processed/10000002.lua

echo "Processing other corescripts..."
for file in ./corescripts/luau/[a-z]*.luau; do
	darklua process -c lines.json5 $file ./corescripts/processed/$(basename "${file::-1}")
done
