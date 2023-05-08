import * as THREE from "three"
import { OBJLoader } from "three/addons/loaders/OBJLoader.js"
import { DecalGeometry } from "three/addons/geometries/DecalGeometry"

const brickToHex = {
	1: 0xf2f3f3,
	5: 0xd7c59a,
	9: 0xe8bac8,
	11: 0x80bbdc,
	18: 0xcc8e69,
	21: 0xc4281c,
	23: 0x0d69ac,
	24: 0xf5cd30,
	26: 0x1b2a35,
	28: 0x287f47,
	29: 0xa1c48c,
	37: 0x4b974b,
	38: 0xa05f35,
	101: 0xda867a,
	102: 0x6e99ca,
	104: 0x6b327c,
	105: 0xe29b40,
	106: 0xda8541,
	107: 0x008f9c,
	119: 0xa4bd47,
	125: 0xeab892,
	135: 0x74869d,
	141: 0x27462d,
	151: 0x789082,
	153: 0x957977,
	192: 0x694028,
	194: 0xa3a2a5,
	199: 0x635f62,
	208: 0xe5e4df,
	217: 0x7c5c46,
	226: 0xfdea8d,
	1001: 0xf8f8f8,
	1002: 0xcdcdcd,
	1003: 0x111111,
	1004: 0xff0000,
	1006: 0xb480ff,
	1007: 0xa34b4b,
	1008: 0xc1be42,
	1009: 0xffff00,
	1010: 0x0000ff,
	1011: 0x002060,
	1012: 0x2154b9,
	1013: 0x04afec,
	1014: 0xaa5500,
	1015: 0xaa00aa,
	1016: 0xff66cc,
	1017: 0xffaf00,
	1018: 0x12eed4,
	1019: 0x00ffff,
	1020: 0x00ff00,
	1021: 0x3a7d15,
	1022: 0x7f8e64,
	1023: 0x8c5b9f,
	1024: 0xafddff,
	1025: 0xffc9c9,
	1026: 0xb1a7ff,
	1027: 0x9ff3e9,
	1028: 0xccffcc,
	1029: 0xffffcc,
	1030: 0xffcc99,
	1031: 0x6225d1,
	1032: 0xff00bf,
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
	root.material.color.set(brickToHex[bodyColours.Head])

	const decalMesh = new THREE.Mesh(
		new DecalGeometry(
			root,
			new THREE.Vector3(0, 0.06, 1),
			new THREE.Euler(0, 0, 0),
			new THREE.Vector3(1.25, 1.25, 1)
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
	root.material.color.set(brickToHex[bodyColours.LeftArm])
	scene.add(root)
})
objLoader.load("./limb.obj", (root: any) => {
	root = root.children[0]
	root.position.set(-1.5, 0, 0)
	root.material.color.set(brickToHex[bodyColours.RightArm])
	scene.add(root)
})
// objLoader.load("./limb.obj", (root: any) => {
// 	root = root.children[0]
// 	root.position.set(0.5, -2, 0)
// 	root.material.color.set(brickToHex[bodyColours.LeftLeg])
// 	scene.add(root)
// })
// objLoader.load("./limb.obj", (root: any) => {
//	root = root.children[0]
// 	root.position.set(-0.5, -2, 0)
// 	root.material.color.set(brickToHex[bodyColours.RightLeg])
// 	scene.add(root)
// })

objLoader.load("./torso.obj", (root: any) => {
	root = root.children[0]
	root.material.color.set(brickToHex[bodyColours.Torso])
	scene.add(root)
})

camera.position.set(0, 1.5, 4)
camera.lookAt(0, 1.5, 0)
scene.add(camera)

document.body.appendChild(renderer.domElement)

function animate() {
	requestAnimationFrame(animate)
	renderer.render(scene, camera)
}
animate()
