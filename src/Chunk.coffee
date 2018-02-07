
@chunks = []

SZ = 32 #150

createChunkGeometry = ->
	
	triangles = SZ * 2 * 3
	geometry = new T.BufferGeometry()
	positions = new Float32Array( triangles * 3 * 3 )
	normals = new Int16Array( triangles * 3 * 3 )
	colors = new Uint8Array( triangles * 3 * 3 )
	uvs = new Uint8Array( triangles * 3 * 2 )
	
	positions_index = 0
	normals_index = 0
	uvs_index = 0
	colors_index = 0
	
	buildPlane = (u, v, z, materialIndex)=>
		
		w = switch u + v
			when "xy", "yx" then "z"
			when "xz", "zx" then "y"
			when "zy", "yz" then "x"
		
		normal = new T.Vector3
		normal[w] = 1
		
		vertices = []
		for ix in [0..1]
			for iy in [0..1]
				vector = new T.Vector3
				vector[u] = ix * SZ
				vector[v] = iy * SZ
				vector[w] = z
				vertices.push vector
		
		color = new T.Color
		# color.setHSL(Math.random(), z/SZ, z/SZ)
		# color.setHSL(z / SZ, z, 0.7)
		# color.setHSL(((u.charCodeAt(0)/1.2 + v.charCodeAt(0)*2.5)%5)/5, z, z / SZ)
		# color.setHSL(((u.charCodeAt(0)*53.6 + v.charCodeAt(0)*2.5)%5)/5, 1, z / SZ)
		
		for vertices_index in [0, 1, 3, 0, 2, 3]
			positions[positions_index++] = vertices[vertices_index].x
			positions[positions_index++] = vertices[vertices_index].y
			positions[positions_index++] = vertices[vertices_index].z
			
			colors[colors_index++] = color.r * 255
			colors[colors_index++] = color.g * 255
			colors[colors_index++] = color.b * 255
		
		for uv_edge in [
			0, 1,  1, 1,  1, 0
			0, 1,  1, 1,  1, 0
		]
			uvs[uvs_index++] = uv_edge
		
		for [0..6]
			normals[normals_index++] = normal.x
			normals[normals_index++] = normal.y
			normals[normals_index++] = normal.z
		
	for i in [0..SZ]
		buildPlane 'x', 'y', i, 0
		buildPlane 'z', 'y', i, 0
		buildPlane 'z', 'x', i, 0
	
	geometry.addAttribute( 'position', new T.BufferAttribute( positions, 3 ) )
	geometry.addAttribute( 'normal', new T.BufferAttribute( normals, 3, true ) )
	geometry.addAttribute( 'color', new T.BufferAttribute( colors, 3, true ) )
	geometry.addAttribute( 'uv', new T.BufferAttribute( uvs, 2 ) )
	geometry.computeBoundingSphere()

	return geometry

class @Chunk extends T.Object3D
	@SIZE: SZ
	constructor: ({@x, @y, @z})->
		super
		
		@position.set @x*SZ, @y*SZ, @z*SZ
		@voxels = new Uint32Array SZ ** 3
		
		@_sullied = no
		
		canvas = document.createElement "canvas"
		canvas.width = SZ
		canvas.height = SZ * SZ
		tex = new T.Texture canvas
		tex.minFilter = T.NearestFilter
		tex.magFilter = T.NearestFilter
		mat = new T.MeshBasicMaterial map: tex, side: T.DoubleSide, vertexColors: T.VertexColors
		# mat = new T.MeshBasicMaterial wireframe: yes, vertexColors: T.VertexColors
		mat.transparent = yes
		mat.alphaTest = 0.5

		# document.body.appendChild canvas
		# canvas.style.position = "absolute"
		# canvas.style.right = "0"
		# canvas.style.top = "0"

		ctx = canvas.getContext "2d"
		image_data = ctx.createImageData(SZ, SZ * SZ)
		for x in [0..SZ]
			for y in [0..SZ]
				for z in [0..SZ]
					index = (x + y * SZ + z * SZ * SZ) * 4
					value = @get(x, y, z)
					# console.log value
					# if value
					if Math.random() < 0.001
						# color = new THREE.Color value
						# image_data.data[index + 0] = color.r * 255
						# image_data.data[index + 1] = color.g * 255
						# image_data.data[index + 2] = color.b * 255
						image_data.data[index + 0] = Math.random() * 255
						image_data.data[index + 1] = Math.random() * 255
						image_data.data[index + 2] = Math.random() * 255
						image_data.data[index + 3] = 255
		ctx.putImageData(image_data, 0, 0)

		# ctx.fillStyle = "red"
		# ctx.fillRect(0, 0, canvas.width, canvas.height)

		tex.needsUpdate = yes
		
		geom = createChunkGeometry()
		mesh = new T.Mesh geom, mat
		@add mesh
		
		debug_container = new T.Object3D
		debug_mesh = new T.Mesh new T.BoxGeometry SZ, SZ, SZ
		@debug = new T.BoxHelper debug_mesh
		debug_container.add @debug
		debug_container.position.set SZ/2, SZ/2, SZ/2
		@add debug_container
		
		scene.add @
		
		chunks.push @
	
	get: (x, y, z)->
		@voxels[x*SZ*SZ + y*SZ + z]
	
	set: (x, y, z, v)->
		@_sullied = yes
		@voxels[x*SZ*SZ + y*SZ + z] = v
	
	init: (fn)->
		for x in [0..SZ]
			for y in [0..SZ]
				for z in [0..SZ]
					@set x, y, z, fn(x+@x*SZ, y+@y*SZ, z+@z*SZ)
	
	update: ->
		@debug.visible = scene.debug
