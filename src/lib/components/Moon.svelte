<script lang="ts">
	// The component that controls the 3D object on the landing page.

	import { Canvas, DirectionalLight, HemisphereLight, OrbitControls, PerspectiveCamera } from "@threlte/core"
	import { GLTF } from "@threlte/extras"

	const items = [
		{
			name: "moon",
			camPos: { x: 100, y: 100, z: 100 },
		},
		{
			name: "mercury",
			camPos: { x: 100, y: 20, z: 100 },
		},
		{
			name: "rock",
			camPos: { x: 100, y: 100, z: 100 },
		},
		{
			name: "mercury2",
			camPos: { x: 100, y: 20, z: 100 },
		},
	]

	const item = items[Math.floor(Math.random() * items.length)]
</script>

<Canvas>
	<PerspectiveCamera position={item.camPos}>
		<OrbitControls autoRotate autoRotateSpeed={Math.random() > 0.5 ? 10 : -10} rotateSpeed={0.1} enablePan={false} panSpeed={0.1} enableZoom={false} />
	</PerspectiveCamera>

	<DirectionalLight color="white" position={{ x: -15, y: 45, z: 20 }} />
	<HemisphereLight skyColor="white" groundColor="#ac844c" intensity={0.4} />

	<GLTF url="/landing/{item.name}.glb" />
</Canvas>
