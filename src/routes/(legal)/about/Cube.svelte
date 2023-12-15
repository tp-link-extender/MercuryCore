<script lang="ts">
	import { createEventDispatcher } from "svelte"
	import { tweened, spring } from "svelte/motion"
	import { T } from "@threlte/core"
	import { interpolateLab } from "d3-interpolate"

	export let i: number, j: number

	const dispatch = createEventDispatcher(),
		opacity = spring(Math.random() + (-j - i / 2 - 5) / 12),
		scale = spring(0, {
			stiffness: 0.1,
			damping: 1,
		}),
		clicked = new Map<string, "hovered" | "clicked">()

	let colour = tweened(interpolateLab("#6c2fb9", "#321f9c")(Math.random()), {
			duration: 500,
			interpolate: interpolateLab,
		}),
		clickable = false

	setTimeout(() => {
		clickable = true
	}, 3000)
</script>

<T.Mesh
	position={[i, j + $scale, -i - j]}
	on:pointerenter={() => {
		if (!clickable || clicked.get(`${i},${j}`)) return
		clicked.set(`${i},${j}`, "hovered")

		scale.set(-j)
		opacity.set(1)
		dispatch("moved")
	}}
	on:pointerdown={e => {
		e.stopPropagation()
		if (!clickable || $scale != -j || clicked.get(`${i},${j}`) == "clicked")
			return
		clicked.set(`${i},${j}`, "clicked")
		colour.set("red")
		dispatch("clicked")
	}}>
	<T.BoxGeometry />
	<T.MeshStandardMaterial
		color={$colour}
		args={[
			{
				transparent: true,
				opacity: $opacity,
			},
		]} />
</T.Mesh>
