<script>
	import { Canvas, DirectionalLight, HemisphereLight, OrbitControls, PerspectiveCamera, Three, useThrelte } from "@threlte/core"
	import { GLTF } from "@threlte/extras"

	const items = [
		{
			url: "/moon.gltf",
			camPos: { x: 100, y: 100, z: 100 },
		},
		{
			url: "/mercury.gltf",
			camPos: { x: 100, y: 20, z: 100 },
		},
		{
			url: "/rock.gltf",
			camPos: { x: 100, y: 100, z: 100 },
		},
	]

	const item = items[Math.floor(Math.random() * items.length)]
</script>

<div>
	<Canvas>
		<PerspectiveCamera position={item.camPos}>
			<OrbitControls autoRotate autoRotateSpeed="10" rotateSpeed="0.1" enableZoom={false}/>
		</PerspectiveCamera>

		<DirectionalLight color={"white"} position={{ x: -15, y: 45, z: 20 }} />
		<HemisphereLight skyColor={"white"} groundColor={"#ac844c"} intensity={0.4} />

		<GLTF url={item.url} />
	</Canvas>
</div>

<style lang="sass">
	div
		position: relative
		width: 100%
		height: 100%
</style>
