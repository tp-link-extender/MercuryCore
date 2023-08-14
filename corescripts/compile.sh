echo "Processing corescripts..."
for file in lua/[0-9]*.lua; do
	darklua process -c dense.json5 $file processed/$(basename "$file")
done

echo "Processing other corescripts..."
for file in lua/[a-z]*.lua; do
	darklua process -c lines.json5 $file processed/$(basename "$file")
done
