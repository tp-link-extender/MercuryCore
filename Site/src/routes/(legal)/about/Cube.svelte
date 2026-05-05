<script lang="ts">
	import { T } from "@threlte/core"
	import { interpolateLab } from "d3-interpolate"
	import { Spring, Tween } from "svelte/motion"

	const {
		i,
		j,
		onmoved,
		onclicked
	}: { i: number; j: number; onmoved: () => void; onclicked: () => void } =
		$props()

	const opacity = new Spring(0)
	$effect(() => {
		opacity.set(Math.random() + (-j - i / 2 - 5) / 12)
	})
	const clicked = new Map<string, "hovered" | "clicked">()
	const scale = new Spring(0, {
		stiffness: 0.1,
		damping: 1
	})

	let colour = new Tween(
		interpolateLab("#6c2fb9", "#321f9c")(Math.random()),
		{
			duration: 500,
			interpolate: interpolateLab
		}
	)
	let clickable = false

	setTimeout(() => {
		clickable = true
	}, 3000)
</script>

<T.Mesh
	position={[i, j + scale.current, -i - j]}
	on:pointerenter={() => {
		if (!clickable || clicked.get(`${i},${j}`)) return
		clicked.set(`${i},${j}`, "hovered")

		scale.set(-j)
		opacity.set(1)
		onmoved()
	}}
	on:pointerdown={e => {
		e.stopPropagation()
		if (
			!clickable ||
			$scale !== -j ||
			clicked.get(`${i},${j}`) === "clicked"
		)
			return
		clicked.set(`${i},${j}`, "clicked")
		colour.set("red")
		onclicked()
	}}>
	<T.BoxGeometry />
	<T.MeshStandardMaterial
		color={colour.current}
		args={[
			{
				transparent: true,
				opacity: opacity.current
			}
		]} />
</T.Mesh>
