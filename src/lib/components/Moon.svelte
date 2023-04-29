<script lang="ts">
	// The component that controls the 3D object
	// on the landing and maintenance pages.

	import { Canvas, T } from "@threlte/core"
	import { GLTF, OrbitControls } from "@threlte/extras"

	const { PerspectiveCamera, DirectionalLight, HemisphereLight } = T

	const items = [
		{
			name: "moon",
			camPos: [100, 60, 100],
		},
		{
			name: "mercury",
			camPos: [100, 20, 100],
		},
		{
			name: "rock",
			camPos: [100, 100, 100],
		},
		{
			name: "mercury2",
			camPos: [100, 20, 100],
		},
		// {
		// 	name: "planetMercury",
		// 	camPos: [100, 40, 100],
		// },
	]

	export let item = items[Math.floor(Math.random() * items.length)]
</script>

<Canvas>
	<PerspectiveCamera makeDefault position={item.camPos}>
		<OrbitControls
			autoRotate
			autoRotateSpeed={Math.random() > 0.5 ? 10 : -10}
			rotateSpeed={0.1}
			enablePan={false}
			panSpeed={0.1}
			enableZoom={false} />
	</PerspectiveCamera>

	<DirectionalLight color="white" position={[15, 45, 20]} />
	<HemisphereLight skyColor="white" groundColor="#7531ff" intensity={0.4} />

	<GLTF url="/landing/{item.name}.glb" />
</Canvas>
