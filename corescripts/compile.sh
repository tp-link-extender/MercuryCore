echo "Processing corescripts..."
for file in luau/[0-9]*.luau; do
	darklua process -c dense.json5 $file processed/$(basename "${file::-1}")
done

echo "Processing other corescripts..."
for file in luau/[a-z]*.luau; do
	darklua process -c lines.json5 $file processed/$(basename "${file::-1}")
done
