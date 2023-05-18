// Gradient animation for landing page.

// Stripe WebGl Gradient Animation
// All Credits to Stripe.com
// ScrollObserver functionality to disable animation when not scrolled into view has been disabled and
// commented out for now.
// https://kevinhufnagl.com

// Converting colors to proper format
const normalizeColor = (hexCode: number) => [
	((hexCode >> 16) & 255) / 255,
	((hexCode >> 8) & 255) / 255,
	(255 & hexCode) / 255,
]

;["SCREEN", "LINEAR_LIGHT"].reduce(
	(hexCode, t, n) =>
		Object.assign(hexCode, {
			[t]: n,
		}),
	{}
)

// Essential functionality of WebGl
// t = width
// n = height
class MiniGl {
	public type: any
	public typeFn: any
	public update: any
	public value: any
	public transpose: any
	public attributes: any
	public setTopology: any
	public material: any
	public attributeInstances: any
	public wireframe: any
	public geometry: any
	public normalized: any
	public buffer: any
	public values: any
	public target: any
	public size: any
	public width: any
	public height: any
	public canvas: any
	public gl: any
	public commonUniforms: any
	public debug: any
	public meshes: any
	lastDebugMsg: number | void
	Attribute: any
	Uniform: any

	constructor(
		canvas: any,
		width: number | null,
		height: number | null,
		debug = false
	) {
		const _miniGl = this,
			debug_output =
				-1 !=
				document.location.search.toLowerCase().indexOf("debug=webgl")
		;(_miniGl.canvas = canvas),
			(_miniGl.gl = _miniGl.canvas.getContext("webgl", {
				antialias: true,
			})),
			(_miniGl.meshes = [])
		const context = _miniGl.gl
		width && height && this.setSize(width, height),
			_miniGl.lastDebugMsg,
			(_miniGl.debug =
				// debug && debug_output
				// 	? function (e: any) {
				// 			const t = new Date()
				// 			t - _miniGl.lastDebugMsg > 1e3 &&
				// 				console.log("---"),
				// 				console.log(
				// 					t.toLocaleTimeString() +
				// 						Array(Math.max(0, 32 - e.length)).join(
				// 							" "
				// 						) +
				// 						e +
				// 						": ",
				// 					...Array.from(arguments).slice(1)
				// 				),
				// 				(_miniGl.lastDebugMsg = t as any)
				// 	  }
				// 	: () => {}
				false),
			Object.defineProperties(_miniGl, {
				Material: {
					enumerable: false,
					value: class {
						uniforms: {}
						uniformInstances: any[]
						vertexSource: string
						Source: string
						vertexShader: any
						fragmentShader: any
						program: any
						constructor(
							vertexShaders: any,
							fragments: any,
							uniforms = {}
						) {
							const material = this
							function getShaderByType(type: any, source: any) {
								const shader = context.createShader(type)
								return (
									context.shaderSource(shader, source),
									context.compileShader(shader),
									context.getShaderParameter(
										shader,
										context.COMPILE_STATUS
									) ||
										console.error(
											context.getShaderInfoLog(shader)
										),
									// _miniGl.debug(
									// 	"Material.compileShaderSource",
									// 	{
									// 		source: source,
									// 	}
									// ),
									shader
								)
							}
							const getUniformVariableDeclarations = (
								uniforms:
									| { [s: string]: unknown }
									| ArrayLike<unknown>,
								type: string
							) =>
								Object.entries(uniforms)
									.map(([uniform, value]: any[]) =>
										value.getDeclaration(uniform, type)
									)
									.join("\n")

							;(material.uniforms = uniforms),
								(material.uniformInstances = [])

							const prefix = "precision highp float;"
							;(material.vertexSource = `${prefix}attribute vec4 position;attribute vec2 uv;attribute vec2 uvNorm;${getUniformVariableDeclarations(
								_miniGl.commonUniforms,
								"vertex"
							)}${getUniformVariableDeclarations(
								uniforms,
								"vertex"
							)}${vertexShaders}`),
								(material.Source = `${prefix}${getUniformVariableDeclarations(
									_miniGl.commonUniforms,
									"f"
								)}${getUniformVariableDeclarations(
									uniforms,
									"f"
								)}${fragments}`),
								(material.vertexShader = getShaderByType(
									context.VERTEX_SHADER,
									material.vertexSource
								)),
								(material.fragmentShader = getShaderByType(
									context.FRAGMENT_SHADER,
									material.Source
								)),
								(material.program = context.createProgram()),
								context.attachShader(
									material.program,
									material.vertexShader
								),
								context.attachShader(
									material.program,
									material.fragmentShader
								),
								context.linkProgram(material.program),
								context.getProgramParameter(
									material.program,
									context.LINK_STATUS
								) ||
									console.error(
										context.getProgramInfoLog(
											material.program
										)
									),
								context.useProgram(material.program),
								material.attachUniforms(
									void 0,
									_miniGl.commonUniforms
								),
								material.attachUniforms(
									void 0,
									material.uniforms
								)
						}
						// t = uniform
						attachUniforms(name: any, uniforms: any) {
							// n = material
							const material = this
							void 0 == name
								? Object.entries(uniforms).forEach(
										([name, uniform]) => {
											material.attachUniforms(
												name,
												uniform
											)
										}
								  )
								: "array" == uniforms.type
								? uniforms.value.forEach(
										(uniform: any, i: any) =>
											material.attachUniforms(
												`${name}[${i}]`,
												uniform
											)
								  )
								: "struct" == uniforms.type
								? Object.entries(uniforms.value).forEach(
										([uniform, i]) =>
											material.attachUniforms(
												`${name}.${uniform}`,
												i
											)
								  )
								: // 	_miniGl.debug("Material.attachUniforms", {
								  // 		name: name,
								  // 		uniform: uniforms,
								  //   }),

								  material.uniformInstances.push({
										uniform: uniforms,
										location: context.getUniformLocation(
											material.program,
											name
										),
								  })
						}
					},
				},
				Uniform: {
					enumerable: false,
					value: class {
						type: string
						typeFn: any
						value: undefined
						transpose: any
						excludeFrom: any
						constructor(e: any) {
							;(this.type = "float"), Object.assign(this, e)
							;(this.typeFn =
								{
									float: "1f",
									int: "1i",
									vec2: "2fv",
									vec3: "3fv",
									vec4: "4fv",
									mat4: "Matrix4fv",
								}[this.type] || "1f"),
								this.update()
						}
						update(value?: undefined) {
							void 0 != this.value &&
								context[`uniform${this.typeFn}`](
									value,
									0 == this.typeFn.indexOf("Matrix")
										? this.transpose
										: this.value,
									0 == this.typeFn.indexOf("Matrix")
										? this.value
										: null
								)
						}
						// e - name
						// t - type
						// n - length
						getDeclaration(
							name: string,
							type: any,
							length: number
						) {
							const uniform: any = this
							if (uniform.excludeFrom != type) {
								if ("array" == uniform.type)
									return (
										uniform.value?.[0].getDeclaration(
											name,
											type,
											uniform.value.length
										) +
										`const int ${name}_length=${uniform.value?.length};`
									)
								if ("struct" == uniform.type) {
									let name_no_prefix = name.replace("u_", "")
									return (
										(name_no_prefix =
											name_no_prefix
												.charAt(0)
												.toUpperCase() +
											name_no_prefix.slice(1)),
										`uniform struct ${name_no_prefix} {` +
											Object.entries(uniform.value)
												.map(([name, uniform]: any[]) =>
													uniform
														.getDeclaration(
															name,
															type
														)
														.replace(/^uniform/, "")
												)
												.join("") +
											`} ${name}${
												length > 0 ? `[${length}]` : ""
											};`
									)
								}
								return `uniform ${uniform.type} ${name}${
									length > 0 ? `[${length}]` : ""
								};`
							}
						}
					},
				},
				PlaneGeometry: {
					enumerable: false,
					value: class {
						attributes: {
							position: any
							uv: any
							uvNorm: any
							index: any
						}
						xSegCount: number
						ySegCount: number
						vertexCount: number
						quadCount: number
						width: number
						height: number
						orientation: string
						constructor(
							width?: number,
							height?: number,
							n?: number,
							i?: number,
							orientation?: string
						) {
							context.createBuffer(),
								(this.attributes = {
									position: new _miniGl.Attribute({
										target: context.ARRAY_BUFFER,
										size: 3,
									}),
									uv: new _miniGl.Attribute({
										target: context.ARRAY_BUFFER,
										size: 2,
									}),
									uvNorm: new _miniGl.Attribute({
										target: context.ARRAY_BUFFER,
										size: 2,
									}),
									index: new _miniGl.Attribute({
										target: context.ELEMENT_ARRAY_BUFFER,
										size: 3,
										type: context.UNSIGNED_SHORT,
									}),
								}),
								this.setTopology(n, i),
								this.setSize(width, height, orientation)
						}
						setTopology(e = 1, t = 1) {
							const n = this
							;(n.xSegCount = e),
								(n.ySegCount = t),
								(n.vertexCount =
									(n.xSegCount + 1) * (n.ySegCount + 1)),
								(n.quadCount = n.xSegCount * n.ySegCount * 2),
								(n.attributes.uv.values = new Float32Array(
									2 * n.vertexCount
								)),
								(n.attributes.uvNorm.values = new Float32Array(
									2 * n.vertexCount
								)),
								(n.attributes.index.values = new Uint16Array(
									3 * n.quadCount
								))
							for (let e = 0; e <= n.ySegCount; e++)
								for (let t = 0; t <= n.xSegCount; t++) {
									const i = e * (n.xSegCount + 1) + t
									if (
										((n.attributes.uv.values[2 * i] =
											t / n.xSegCount),
										(n.attributes.uv.values[2 * i + 1] =
											1 - e / n.ySegCount),
										(n.attributes.uvNorm.values[2 * i] =
											(t / n.xSegCount) * 2 - 1),
										(n.attributes.uvNorm.values[2 * i + 1] =
											1 - (e / n.ySegCount) * 2),
										t < n.xSegCount && e < n.ySegCount)
									) {
										const s = e * n.xSegCount + t
										;(n.attributes.index.values[6 * s] = i),
											(n.attributes.index.values[
												6 * s + 1
											] = i + 1 + n.xSegCount),
											(n.attributes.index.values[
												6 * s + 2
											] = i + 1),
											(n.attributes.index.values[
												6 * s + 3
											] = i + 1),
											(n.attributes.index.values[
												6 * s + 4
											] = i + 1 + n.xSegCount),
											(n.attributes.index.values[
												6 * s + 5
											] = i + 2 + n.xSegCount)
									}
								}
							n.attributes.uv.update(),
								n.attributes.uvNorm.update(),
								n.attributes.index.update()
								// _miniGl.debug("Geometry.setTopology", {
								// 	uv: n.attributes.uv,
								// 	uvNorm: n.attributes.uvNorm,
								// 	index: n.attributes.index,
								// })
						}
						setSize(width = 1, height = 1, orientation = "xz") {
							const geometry = this
							;(geometry.width = width),
								(geometry.height = height),
								(geometry.orientation = orientation),
								(geometry.attributes.position.values &&
									geometry.attributes.position.values
										.length ==
										3 * geometry.vertexCount) ||
									(geometry.attributes.position.values =
										new Float32Array(
											3 * geometry.vertexCount
										))
							const o = width / -2,
								r = height / -2,
								segment_width = width / geometry.xSegCount,
								segment_height = height / geometry.ySegCount
							for (
								let yIndex = 0;
								yIndex <= geometry.ySegCount;
								yIndex++
							) {
								const t = r + yIndex * segment_height
								for (
									let xIndex = 0;
									xIndex <= geometry.xSegCount;
									xIndex++
								) {
									const r = o + xIndex * segment_width,
										l =
											yIndex * (geometry.xSegCount + 1) +
											xIndex
									;(geometry.attributes.position.values[
										3 * l + "xyz".indexOf(orientation[0])
									] = r),
										(geometry.attributes.position.values[
											3 * l +
												"xyz".indexOf(orientation[1])
										] = -t)
								}
							}
							geometry.attributes.position.update()
								// _miniGl.debug("Geometry.setSize", {
								// 	position: geometry.attributes.position,
								// })
						}
					},
				},
				Mesh: {
					enumerable: false,
					value: class {
						geometry: any
						material: any
						wireframe: boolean
						attributeInstances: any[]
						constructor(geometry: any, material: any) {
							const mesh = this
							;(mesh.geometry = geometry),
								(mesh.material = material),
								(mesh.wireframe = false),
								(mesh.attributeInstances = []),
								Object.entries(
									mesh.geometry.attributes
								).forEach(([e, attribute]: any[]) => {
									mesh.attributeInstances.push({
										attribute: attribute,
										location: attribute.attach(
											e,
											mesh.material.program
										),
									})
								}),
								_miniGl.meshes.push(mesh)
								// _miniGl.debug("Mesh.constructor", {
								// 	mesh: mesh,
								// })
						}
						draw() {
							context.useProgram(this.material.program),
								this.material.uniformInstances.forEach(
									({ uniform, location }: any) =>
										uniform.update(location)
								),
								this.attributeInstances.forEach(
									({ attribute, location }) =>
										attribute.use(location)
								),
								context.drawElements(
									this.wireframe
										? context.LINES
										: context.TRIANGLES,
									this.geometry.attributes.index.values
										.length,
									context.UNSIGNED_SHORT,
									0
								)
						}
						remove() {
							_miniGl.meshes = _miniGl.meshes.filter(
								(e: this) => e != this
							)
						}
					},
				},
				Attribute: {
					enumerable: false,
					value: class {
						type: any
						normalized: boolean
						buffer: any
						values: undefined
						constructor(e: any) {
							;(this.type = context.FLOAT),
								(this.normalized = false),
								(this.buffer = context.createBuffer()),
								Object.assign(this, e),
								this.update()
						}
						update() {
							void 0 != this.values &&
								(context.bindBuffer(this.target, this.buffer),
								context.bufferData(
									this.target,
									this.values,
									context.STATIC_DRAW
								))
						}
						attach(e: any, t: any) {
							const n = context.getAttribLocation(t, e)
							return (
								this.target == context.ARRAY_BUFFER &&
									(context.enableVertexAttribArray(n),
									context.vertexAttribPointer(
										n,
										this.size,
										this.type,
										this.normalized,
										0,
										0
									)),
								n
							)
						}
						use(e: any) {
							context.bindBuffer(this.target, this.buffer),
								this.target == context.ARRAY_BUFFER &&
									(context.enableVertexAttribArray(e),
									context.vertexAttribPointer(
										e,
										this.size,
										this.type,
										this.normalized,
										0,
										0
									))
						}
					},
				},
			})
		const a = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
		_miniGl.commonUniforms = {
			pm: new _miniGl.Uniform({
				type: "mat4",
				value: a,
			}),
			mm: new _miniGl.Uniform({
				type: "mat4",
				value: a,
			}),
			rs: new _miniGl.Uniform({
				type: "vec2",
				value: [1, 1],
			}),
			aspectRatio: new _miniGl.Uniform({
				type: "float",
				value: 1,
			}),
		}
	}
	setSize(e = 640, t = 480) {
		;(this.width = e),
			(this.height = t),
			(this.canvas.width = e),
			(this.canvas.height = t),
			this.gl.viewport(0, 0, e, t),
			(this.commonUniforms.rs.value = [e, t]),
			(this.commonUniforms.aspectRatio.value = e / t)
			// this.debug("MiniGL.setSize", {
			// 	width: e,
			// 	height: t,
			// })
	}
	// left, right, top, bottom, near, far
	setOrthographicCamera(e = 0, t = 0, n = 0, i = -2e3, s = 2e3) {
		;(this.commonUniforms.pm.value = [
			2 / this.width,
			0,
			0,
			0,
			0,
			2 / this.height,
			0,
			0,
			0,
			0,
			2 / (i - s),
			0,
			e,
			t,
			n,
			1,
		])
			// this.debug("setOrthographicCamera", this.commonUniforms.pm.value)
	}
	render() {
		this.gl.clearColor(0, 0, 0, 0),
			this.gl.clearDepth(1),
			this.meshes.forEach((e: any) => e.draw())
	}
}

// Sets initial properties
const e = (object: any, propertyName: PropertyKey, val?: any) => (
	propertyName in object
		? Object.defineProperty(object, propertyName, {
				value: val,
				enumerable: true,
				configurable: true,
				writable: true,
		  })
		: (object[propertyName] = val),
	object
)

// Gradient object
export default class Gradient {
	public width: any
	public minigl: any
	public height: any
	public xSegCount: any
	public conf: any
	public ySegCount: any
	public mesh: any
	public t: any
	public last: any
	public isMetaKey: any
	public isStatic: any
	public animate: any
	public isLoadedClass: any
	public el: any
	public shaderFiles: any
	public computedCanvasStyle: any
	public resize: any
	public uniforms: any
	public activeColors: any
	public freqX: any
	public freqY: any
	public angle: any
	public amp: any
	public seed: any
	public sectionColors: any
	public vertexShader: any
	public material: any
	public geometry: any
	public addIsLoadedClass: any
	public cssVarRetries: any
	public maxCssVarRetries: any

	initGradient(e: any) {}
	constructor(...t: undefined[]) {
		e(this, "el", void 0),
			e(this, "cssVarRetries", 0),
			e(this, "maxCssVarRetries", 200),
			e(this, "angle", 0),
			e(this, "isLoadedClass", false),
			// e(this, "isStatic", o.disableAmbientAnimations()),
			// e(this, "isIntersecting", false),
			e(this, "shaderFiles", void 0),
			e(this, "vertexShader", void 0),
			e(this, "sectionColors", void 0),
			e(this, "computedCanvasStyle", void 0),
			e(this, "conf", void 0),
			e(this, "uniforms", void 0),
			e(this, "t", Math.random() * 10000),
			e(this, "last", 0),
			e(this, "width", void 0),
			e(this, "minWidth", 1100),
			e(this, "height", 600), // 1600
			e(this, "xSegCount", void 0),
			e(this, "ySegCount", void 0),
			e(this, "mesh", void 0),
			e(this, "material", void 0),
			e(this, "geometry", void 0),
			e(this, "minigl", void 0),
			// e(this, "scrollObserver", void 0),
			e(this, "amp", 500),
			e(this, "seed", Math.random() * 1000),
			e(this, "freqX", 14e-5), // 2.4e-4
			e(this, "freqY", 29e-5), // 2.9e-4
			e(this, "freqDelta", 1e-5),
			e(this, "activeColors", [1, 1, 1, 1]),
			e(this, "isMetaKey", false),
			// e(this, "isGradientLegendVisible", false),
			e(this, "resize", () => {
				;(this.width = window.innerWidth),
					this.minigl.setSize(this.width, this.height),
					this.minigl.setOrthographicCamera(),
					(this.xSegCount = Math.ceil(
						this.width * this.conf.density[0]
					)),
					(this.ySegCount = Math.ceil(
						this.height * this.conf.density[1]
					)),
					this.mesh.geometry.setTopology(
						this.xSegCount,
						this.ySegCount
					),
					this.mesh.geometry.setSize(this.width, this.height),
					(this.mesh.material.uniforms.us.value =
						this.width < 600 ? 5 : 6)
			}),
			e(this, "animate", (e: number) => {
				if (!this.shouldSkipFrame(e)) {
					if (
						((this.t += Math.min(e - this.last, 1e3 / 15)),
						(this.last = e),
						false)
					) {
						let e = 160
						this.isMetaKey && (e = -160), (this.t += e)
					}
					;(this.mesh.material.uniforms.ti.value = this.t),
						this.minigl.render()
				}
				if (0 != this.last && this.isStatic)
					return (
						this.minigl.render(), void this.disconnect()
						// this.isIntersecting &&
					)
				this.conf.playing && requestAnimationFrame(this.animate)
			}),
			e(this, "addIsLoadedClass", () => {
				// this.isIntersecting &&
				!this.isLoadedClass &&
					((this.isLoadedClass = true),
					this.el.classList.add("isLoaded"),
					setTimeout(() => {
						this.el.parentElement.classList.add("isLoaded")
					}, 3e3))
			}),
			e(this, "pause", () => {
				this.conf.playing = false
			}),
			e(this, "play", () => {
				requestAnimationFrame(this.animate), (this.conf.playing = true)
			}),
			e(this, "initGradient", (selector: any) => {
				this.el = document.querySelector(selector)
				this.connect()
				return this
			})
	}
	async connect() {
		;(this.shaderFiles = {
			vertex: "varying vec3 vc;void main(){float time=ti*g.ns;vec2 n=rs*uvNorm*g.nF;vec2 st=1.-uvNorm.xy;float tilt=rs.y/2.0*uvNorm.y;float i=rs.x*uvNorm.x/2.0*um.i;float o=rs.x/2.0*um.i*mix(um.offsetBottom,um.offsetTop,uv.y);float N=sn(vec3(n.x*um.nF.x+time*um.nf,n.y*um.nF.y,time*um.ns+um.nw))*um.noiseAmp;N*=1.0-pow(abs(uvNorm.y),2.0);N=max(.0,N);vec3 p=vec3(position.x,position.y+tilt+i+N-o,position.z);if(ua[0]==1.){vc=ub;}for(int i=0;i<u_waveLayers_length;i++){if(ua[i+1]==1.){WaveLayers layer=u_waveLayers[i];float N=smoothstep(layer.nZ,layer.noiseCeil,sn(vec3(n.x*layer.nF.x+time*layer.nf,n.y*layer.nF.y,time*layer.ns+layer.nw))/2.0+.5);vc=bN(vc,layer.color,pow(N,4.));}}gl_Position=pm*mm*vec4(p,1.0);}",
			N: "vec3 m2(vec3 x){return x-floor(x*(1.0/289.0))*289.0;}vec4 m2(vec4 x){return x-floor(x*(1.0/289.0))*289.0;}vec4 p(vec4 x){return m2(((x*34.0)+1.0)*x);}vec4 t(vec4 r){return 1.79284291400159-.85373472095314*r;}float sn(vec3 v){const vec2 C=vec2(1.0/6.0,1.0/3.0);const vec4 D=vec4(.0,.5,1.0,2.0);vec3 i=floor(v+dot(v,C.yyy));vec3 x0=v-i+dot(i,C.xxx);vec3 g=step(x0.yzx,x0.xyz);vec3 l=1.0-g;vec3 i1=min(g.xyz,l.zxy);vec3 i2=max(g.xyz,l.zxy);vec3 x1=x0-i1+C.xxx;vec3 x2=x0-i2+C.yyy;vec3 x3=x0-D.yyy;i=m2(i);vec4 p=p(p(p(i.z+vec4(.0,i1.z,i2.z,1.0))+ i.y+vec4(.0,i1.y,i2.y,1.0))+ i.x+vec4(.0,i1.x,i2.x,1.0));float n_=.142857142857;vec3 ns=n_*D.wyz-D.xzx;vec4 j=p-49.0*floor(p*ns.z*ns.z);vec4 x_=floor(j*ns.z);vec4 y_=floor(j-7.0*x_);vec4 x=x_*ns.x+ns.yyyy;vec4 y=y_*ns.x+ns.yyyy;vec4 h=1.0-abs(x)-abs(y);vec4 b0=vec4(x.xy,y.xy);vec4 b1=vec4(x.zw,y.zw);vec4 s0=floor(b0)*2.0+1.0;vec4 s1=floor(b1)*2.0+1.0;vec4 sh=-step(h,vec4(.0));vec4 a0=b0.xzyw+s0.xzyw*sh.xxyy;vec4 a1=b1.xzyw+s1.xzyw*sh.zzww;vec3 p0=vec3(a0.xy,h.x);vec3 p1=vec3(a0.zw,h.y);vec3 p2=vec3(a1.xy,h.z);vec3 p3=vec3(a1.zw,h.w);vec4 n=t(vec4(dot(p0,p0),dot(p1,p1),dot(p2,p2),dot(p3,p3)));p0*=n.x;p1*=n.y;p2*=n.z;p3*=n.w;vec4 m=max(.6-vec4(dot(x0,x0),dot(x1,x1),dot(x2,x2),dot(x3,x3)),.0);m=m*m;return 42.0*dot(m*m,vec4(dot(p0,x0),dot(p1,x1),dot(p2,x2),dot(p3,x3)));}",
			b: "vec3 bN(vec3 E,vec3 b){return b;}vec3 bN(vec3 E,vec3 b,float o){return(bN(E,b)*o+E*(1.0-o));}float bS(float E,float b){return 1.0-((1.0-E)*(1.0-b));}vec3 bS(vec3 E,vec3 b){return vec3(bS(E.r,b.r),bS(E.g,b.g),bS(E.b,b.b));}vec3 bS(vec3 E,vec3 b,float o){return(bS(E,b)*o+E*(1.0-o));}vec3 bM(vec3 E,vec3 b){return E*b;}vec3 bM(vec3 E,vec3 b,float o){return(bM(E,b)*o+E*(1.0-o));}float bO(float E,float b){return E<.5?(2.0*E*b):(1.0-2.0*(1.0-E)*(1.0-b));}vec3 bO(vec3 E,vec3 b){return vec3(bO(E.r,b.r),bO(E.g,b.g),bO(E.b,b.b));}vec3 bO(vec3 E,vec3 b,float o){return(bO(E,b)*o+E*(1.0-o));}vec3 bH(vec3 E,vec3 b){return bO(b,E);}vec3 bH(vec3 E,vec3 b,float o){return(bH(E,b)*o+E*(1.0-o));}float bs(float E,float b){return(b<.5)?(2.0*E*b+E*E*(1.0-2.0*b)):(sqrt(E)*(2.0*b-1.0)+2.0*E*(1.0-b));}vec3 bs(vec3 E,vec3 b){return vec3(bs(E.r,b.r),bs(E.g,b.g),bs(E.b,b.b));}vec3 bs(vec3 E,vec3 b,float o){return(bs(E,b)*o+E*(1.0-o));}float bC(float E,float b){return(b==1.0)?b:min(E/(1.0-b),1.0);}vec3 bC(vec3 E,vec3 b){return vec3(bC(E.r,b.r),bC(E.g,b.g),bC(E.b,b.b));}vec3 bC(vec3 E,vec3 b,float o){return(bC(E,b)*o+E*(1.0-o));}float s(float E,float b){return(b==.0)?b:max((1.0-((1.0-E)/b)),.0);}vec3 s(vec3 E,vec3 b){return vec3(s(E.r,b.r),s(E.g,b.g),s(E.b,b.b));}vec3 s(vec3 E,vec3 b,float o){return(s(E,b)*o+E*(1.0-o));}float bV(float E,float b){return(b<.5)?s(E,(2.0*b)):bC(E,(2.0*(b-.5)));}vec3 bV(vec3 E,vec3 b){return vec3(bV(E.r,b.r),bV(E.g,b.g),bV(E.b,b.b));}vec3 bV(vec3 E,vec3 b,float o){return(bV(E,b)*o+E*(1.0-o));}float l(float E,float b){return max(b,E);}vec3 l(vec3 E,vec3 b){return vec3(l(E.r,b.r),l(E.g,b.g),l(E.b,b.b));}vec3 l(vec3 E,vec3 b,float o){return(l(E,b)*o+E*(1.0-o));}float bB(float E,float b){return max(E+b-1.0,.0);}vec3 bB(vec3 E,vec3 b){return max(E+b-vec3(1.0),vec3(.0));}vec3 bB(vec3 E,vec3 b,float o){return(bB(E,b)*o+E*(1.0-o));}float bL(float E,float b){return min(E+b,1.0);}vec3 bL(vec3 E,vec3 b){return min(E+b,vec3(1.0));}vec3 bL(vec3 E,vec3 b,float o){return(bL(E,b)*o+E*(1.0-o));}float bl(float E,float b){return b<.5?bB(E,(2.0*b)):bL(E,(2.0*(b-.5)));}vec3 bl(vec3 E,vec3 b){return vec3(bl(E.r,b.r),bl(E.g,b.g),bl(E.b,b.b));}vec3 bl(vec3 E,vec3 b,float o){return(bl(E,b)*o+E*(1.0-o));}",
			f: "varying vec3 vc;void main(){vec3 color=vc;if(ud==1.0){vec2 st=gl_FragCoord.xy/rs.xy;color.g-=pow(st.y+sin(-12.0)*st.x,us)*.4;}gl_FragColor=vec4(color,1.0);}",
		}),
			(this.conf = {
				presetName: "",
				wireframe: false,
				density: [0.06, 0.16],
				zoom: 1,
				rotation: 0,
				playing: true,
			}),
			document.querySelectorAll("canvas").length < 1
				? console.log("DID NOT LOAD HERO STRIPE CANVAS")
				: ((this.minigl = new MiniGl(this.el, null, null, true)),
				  requestAnimationFrame(() => {
						this.el &&
							((this.computedCanvasStyle = getComputedStyle(
								this.el
							)),
							this.waitForCssVars())
				  }))
	}
	disconnect() {
		// this.scrollObserver && this.scrollObserver.disconnect(),
		window.removeEventListener("resize", this.resize)
	}
	initMaterial() {
		this.uniforms = {
			ti: new this.minigl.Uniform({
				value: 0,
			}),
			us: new this.minigl.Uniform({
				value: 10,
			}),
			ud: new this.minigl.Uniform({
				value: "" == this.el.dataset.jsDarkenTop ? 1 : 0,
			}),
			ua: new this.minigl.Uniform({
				value: this.activeColors,
				type: "vec4",
			}),
			g: new this.minigl.Uniform({
				value: {
					nF: new this.minigl.Uniform({
						value: [this.freqX, this.freqY],
						type: "vec2",
					}),
					ns: new this.minigl.Uniform({
						value: 5e-6,
					}),
				},
				type: "struct",
			}),
			um: new this.minigl.Uniform({
				value: {
					i: new this.minigl.Uniform({
						value: Math.sin(this.angle) / Math.cos(this.angle),
					}),
					offsetTop: new this.minigl.Uniform({
						value: -0.5,
					}),
					offsetBottom: new this.minigl.Uniform({
						value: -0.5,
					}),
					nF: new this.minigl.Uniform({
						value: [3, 4],
						type: "vec2",
					}),
					noiseAmp: new this.minigl.Uniform({
						value: this.amp,
					}),
					ns: new this.minigl.Uniform({
						value: 10,
					}),
					nf: new this.minigl.Uniform({
						value: 3,
					}),
					nw: new this.minigl.Uniform({
						value: this.seed,
					}),
				},
				type: "struct",
				excludeFrom: "f",
			}),
			ub: new this.minigl.Uniform({
				value: this.sectionColors[0],
				type: "vec3",
				excludeFrom: "f",
			}),
			u_waveLayers: new this.minigl.Uniform({
				value: [],
				excludeFrom: "f",
				type: "array",
			}),
		}
		for (let e = 1; e < this.sectionColors.length; e += 1)
			this.uniforms.u_waveLayers.value.push(
				new this.minigl.Uniform({
					value: {
						color: new this.minigl.Uniform({
							value: this.sectionColors[e],
							type: "vec3",
						}),
						nF: new this.minigl.Uniform({
							value: [
								2 + e / this.sectionColors.length,
								3 + e / this.sectionColors.length,
							],
							type: "vec2",
						}),
						ns: new this.minigl.Uniform({
							value: 11 + 0.3 * e,
						}),
						nf: new this.minigl.Uniform({
							value: 6.5 + 0.3 * e,
						}),
						nw: new this.minigl.Uniform({
							value: this.seed + 10 * e,
						}),
						nZ: new this.minigl.Uniform({
							value: 0.1,
						}),
						noiseCeil: new this.minigl.Uniform({
							value: 0.63 + 0.07 * e,
						}),
					},
					type: "struct",
				})
			)
		return (
			(this.vertexShader = [
				this.shaderFiles.N,
				this.shaderFiles.b,
				this.shaderFiles.vertex,
			].join("\n")),
			new this.minigl.Material(
				this.vertexShader,
				this.shaderFiles.f,
				this.uniforms
			)
		)
	}
	initMesh() {
		;(this.material = this.initMaterial()),
			(this.geometry = new this.minigl.PlaneGeometry()),
			(this.mesh = new this.minigl.Mesh(this.geometry, this.material))
	}
	shouldSkipFrame = (e: any) =>
		!!window.document.hidden ||
		!this.conf.playing ||
		parseInt(e, 10) % 2 == 0 ||
		void 0

	init() {
		this.initGradientColors(),
			this.initMesh(),
			this.resize(),
			requestAnimationFrame(this.animate),
			window.addEventListener("resize", this.resize)
	}
	// Waiting for the css variables to become available, usually on page load before we can continue.
	// Using default colors assigned below if no variables have been found after maxCssVarRetries
	waitForCssVars() {
		if (
			this.computedCanvasStyle &&
			-1 !=
				this.computedCanvasStyle
					.getPropertyValue("--gradient-color-1")
					.indexOf("#")
		)
			this.init(), this.addIsLoadedClass()
		else {
			if ((this.cssVarRetries += 1 > this.maxCssVarRetries))
				return (
					(this.sectionColors = [
						16711680, 16711680, 16711935, 65280, 255,
					]),
					void this.init()
				)

			requestAnimationFrame(() => this.waitForCssVars())
		}
	}
	// Initializes the four section colors by retrieving them from css variables.
	initGradientColors() {
		this.sectionColors = [
			"--gradient-color-1",
			"--gradient-color-2",
			"--gradient-color-3",
			"--gradient-color-4",
		]
			.map(cssPropertyName => {
				let hex = this.computedCanvasStyle
					.getPropertyValue(cssPropertyName)
					.trim()
				// Check if shorthand hex value was used and double the length so the conversion in normalizeColor will work.
				if (4 == hex.length) {
					const hexTemp = hex
						.substring(1)
						.split("")
						.map((hexTemp: any) => hexTemp + hexTemp)
						.join("")
					hex = `#${hexTemp}`
				}
				return hex && `0x${hex.substring(1)}`
			})
			.filter(Boolean)
			.map(normalizeColor)
	}
}

/*
	Finally initializing the Gradient class,assigning a canvas to it and calling Gradient.connect() which initializes everything,

	Here are some default property values you can change anytime:
	Amplitude: Gradient.amp = 0
	Colors: Gradient.sectionColors (if you change colors,use normalizeColor(#hexValue)) before you assign it.
*/
