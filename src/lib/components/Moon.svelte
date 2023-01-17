<script>
	import { Canvas, DirectionalLight, HemisphereLight, OrbitControls, PerspectiveCamera, Three, useThrelte } from "@threlte/core"
	import { GLTF } from "@threlte/extras"

	const items = [
		{
			url: "/landing/moon.gltf",
			camPos: { x: 100, y: 100, z: 100 },
		},
		{
			url: "/landing/mercury.gltf",
			camPos: { x: 100, y: 20, z: 100 },
		},
		{
			url: "/landing/rock.gltf",
			camPos: { x: 100, y: 100, z: 100 },
		},
	]

	const item = items[Math.floor(Math.random() * items.length)]
</script>

<Canvas>
	<PerspectiveCamera position={item.camPos}>
		<OrbitControls autoRotate autoRotateSpeed={10} rotateSpeed={0.1} panSpeed={0.1} enableZoom={false} />
	</PerspectiveCamera>

	<DirectionalLight color="white" position={{ x: -15, y: 45, z: 20 }} />
	<HemisphereLight skyColor="white" groundColor="#ac844c" intensity={0.4} />

	<GLTF url={item.url} />
</Canvas>
