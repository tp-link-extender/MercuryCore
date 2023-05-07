import * as THREE from "three"
import { OBJLoader } from "three/addons/loaders/OBJLoader.js"
import { DecalGeometry } from "three/addons/geometries/DecalGeometry.js"

const brickToHex = {
	1: "F2F3F3",
	5: "D7C59A",
	9: "E8BAC8",
	11: "80BBDC",
	18: "CC8E69",
	21: "C4281C",
	23: "0D69AC",
	24: "F5CD30",
	26: "1B2A35",
	28: "287F47",
	29: "A1C48C",
	37: "4B974B",
	38: "A05F35",
	101: "DA867A",
	102: "6E99CA",
	104: "6B327C",
	105: "E29B40",
	106: "DA8541",
	107: "008F9C",
	119: "A4BD47",
	125: "EAB892",
	135: "74869D",
	141: "27462D",
	151: "789082",
	153: "957977",
	192: "694028",
	194: "A3A2A5",
	199: "635F62",
	208: "E5E4DF",
	217: "7C5C46",
	226: "FDEA8D",
	1001: "F8F8F8",
	1002: "CDCDCD",
	1003: "111111",
	1004: "FF0000",
	1006: "B480FF",
	1007: "A34B4B",
	1008: "C1BE42",
	1009: "FFFF00",
	1010: "0000FF",
	1011: "002060",
	1012: "2154B9",
	1013: "04AFEC",
	1014: "AA5500",
	1015: "AA00AA",
	1016: "FF66CC",
	1017: "FFAF00",
	1018: "12EED4",
	1019: "00FFFF",
	1020: "00FF00",
	1021: "3A7D15",
	1022: "7F8E64",
	1023: "8C5B9F",
	1024: "AFDDFF",
	1025: "FFC9C9",
	1026: "B1A7FF",
	1027: "9FF3E9",
	1028: "CCFFCC",
	1029: "FFFFCC",
	1030: "FFCC99",
	1031: "6225D1",
	1032: "FF00BF",
}

let bodyColours = {
	Head: 24,
	Torso: 23,
	LeftArm: 24,
	RightArm: 24,
	// LeftLeg: 119,
	// RightLeg: 119,
}

const params: any = new Proxy(new URLSearchParams(window.location.search), {
	get: (searchParams, prop: any) => searchParams.get(prop),
})

if (params.c) bodyColours = JSON.parse(params.c)

const scene = new THREE.Scene()
const camera = new THREE.PerspectiveCamera(30)
const objLoader = new OBJLoader()

const renderer = new THREE.WebGLRenderer({ alpha: true })
renderer.setSize(150, 150)
scene.add(new THREE.HemisphereLight(0xffffff, 0))

objLoader.load("./head.obj", (root: any) => {
	root = root.children[0]
	root.position.set(0, 1.5, 0)
	root.material.color.set(parseInt("0x" + brickToHex[bodyColours.Head]))

	const decalMesh = new THREE.Mesh(
		new DecalGeometry(
			root,
			new THREE.Vector3(0, 0.06, 1.5),
			new THREE.Euler(0, 0, 0),
			new THREE.Vector3(1.25, 1.25, 2)
		),
		new THREE.MeshBasicMaterial({
			map: new THREE.TextureLoader().load("./smile.webp"),
			transparent: true,
			color: 0xff0000,
			polygonOffset: true,
			polygonOffsetFactor: -4,
		})
	)
	decalMesh.position.set(0, 1.5, 0)

	scene.add(root, decalMesh)
})

objLoader.load("./limb.obj", (root: any) => {
	root = root.children[0]
	root.position.set(1.5, 0, 0)
	root.material.color.set(parseInt("0x" + brickToHex[bodyColours.LeftArm]))
	scene.add(root)
})
objLoader.load("./limb.obj", (root: any) => {
	root = root.children[0]
	root.position.set(-1.5, 0, 0)
	root.material.color.set(parseInt("0x" + brickToHex[bodyColours.RightArm]))
	scene.add(root)
})
// objLoader.load("./limb.obj", (root: any) => {
// 	root = root.children[0]
// 	root.position.set(0.5, -2, 0)
// 	root.material.color.set(parseInt("0x" + brickToHex[bodyColours.LeftLeg]))
// 	scene.add(root)
// })
// objLoader.load("./limb.obj", (root: any) => {
// 	root = root.children[0]
// 	root.position.set(-0.5, -2, 0)
// 	root.material.color.set(parseInt("0x" + brickToHex[bodyColours.RightLeg]))
// 	scene.add(root)
// })

objLoader.load("./torso.obj", (root: any) => {
	root = root.children[0]
	root.position.set(0.07, 0, 0)
	root.material.color.set(parseInt("0x" + brickToHex[bodyColours.Torso]))
	scene.add(root)
})

document.body.appendChild(renderer.domElement)

const boom = new THREE.Group()
boom.add(camera)
scene.add(boom)
camera.position.set(0, 1.5, 4) // this sets the boom's length
camera.lookAt(0, 1.5, 0) // camera looks at the boom's zero

function animate() {
	requestAnimationFrame(animate)
	// boom.rotation.y += 0.02
	// boom.rotation.x += 0.02
	renderer.render(scene, camera)
}
animate()
