<script>
	import { Canvas, DirectionalLight, HemisphereLight, OrbitControls, PerspectiveCamera } from "@threlte/core"
	import { GLTF } from "@threlte/extras"
</script>

<div>
	<Canvas>
		<PerspectiveCamera position={{ x: 100, y: 100, z: 100 }}>
			<OrbitControls autoRotate enabled={false}/>
		</PerspectiveCamera>

		<DirectionalLight color={"white"} position={{ x: -15, y: 45, z: 20 }} />
		<HemisphereLight skyColor={"white"} groundColor={"#ac844c"} intensity={0.4} />

		<GLTF url="/moon.gltf" />
	</Canvas>
</div>

<style lang="sass">
	div
		position: relative
		width: 100%
		height: 100%
</style>
