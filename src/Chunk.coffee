
@chunks = []

SZ = 150

createChunkGeometry = ->
	
	triangles = SZ * 4 * 3
	geometry = new T.BufferGeometry()
	# indices = new Uint32Array( triangles * 3 )
	# for i in [0..indices.length]
	# 	indices[ i ] = i
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
		
		# positions[positions_index++] = vertices[ 0 ].x
		# positions[positions_index++] = vertices[ 0 ].y
		# positions[positions_index++] = vertices[ 0 ].z
		# positions[positions_index++] = vertices[ 1 ].x
		# positions[positions_index++] = vertices[ 1 ].y
		# positions[positions_index++] = vertices[ 1 ].z
		# positions[positions_index++] = vertices[ 3 ].x
		# positions[positions_index++] = vertices[ 3 ].y
		# positions[positions_index++] = vertices[ 3 ].z
		# 
		# positions[positions_index++] = vertices[ 1 ].x
		# positions[positions_index++] = vertices[ 1 ].y
		# positions[positions_index++] = vertices[ 1 ].z
		# positions[positions_index++] = vertices[ 2 ].x
		# positions[positions_index++] = vertices[ 2 ].y
		# positions[positions_index++] = vertices[ 2 ].z
		# positions[positions_index++] = vertices[ 3 ].x
		# positions[positions_index++] = vertices[ 3 ].y
		# positions[positions_index++] = vertices[ 3 ].z
		
		color = new T.Color "#f0f0f0"
		# color.setHSL(Math.random() * 360, z, z)
		color.setHSL(z / SZ, z, z / SZ)
		
		for vertices_index in [0, 1, 3, 1, 2, 3]
			positions[positions_index++] = vertices[vertices_index].x
			positions[positions_index++] = vertices[vertices_index].y
			positions[positions_index++] = vertices[vertices_index].z
			
			colors[colors_index++] = color.r * 255
			colors[colors_index++] = color.g * 255
			colors[colors_index++] = color.b * 255
		
		# uvs[uvs_index++] = 0
		# uvs[uvs_index++] = 0
		# 
		# uvs[uvs_index++] = 0
		# uvs[uvs_index++] = SZ
		# 
		# uvs[uvs_index++] = SZ
		# uvs[uvs_index++] = 0
		# 
		# uvs[uvs_index++] = 0
		# uvs[uvs_index++] = SZ
		# 
		# uvs[uvs_index++] = SZ
		# uvs[uvs_index++] = SZ
		# 
		# uvs[uvs_index++] = SZ
		# uvs[uvs_index++] = 0
		
		for uv_edge in [
			0, 0,  0, 1,  1, 0
			0, 1,  1, 1,  1, 0
		]
			uvs[uvs_index++] = uv_edge * SZ
		
		for [0..6]
			normals[normals_index++] = normal.x
			normals[normals_index++] = normal.y
			normals[normals_index++] = normal.z
		
	for i in [0..SZ]
		buildPlane 'x', 'y', i, 0
		buildPlane 'z', 'y', i, 0
		buildPlane 'z', 'x', i, 0
	
	# 
	# bufferGeometry.addAttribute 'position', new T.Float32BufferAttribute(positions, 3)
	# bufferGeometry.addAttribute 'normal', new T.Float32BufferAttribute(normals, 3)
	# bufferGeometry.addAttribute 'color', new T.Float32BufferAttribute(colors, 3)
	
	# color = new T.Color()
	# for i in [0..positions.length] by 9
	# 	# colors
	# 	vx = Math.random()
	# 	vy = Math.random()
	# 	vz = Math.random()
	# 	# vx = (positions[ i ] / n * 5) #+ 0.5
	# 	# vy = (positions[ i+1 ] / n * 5) #+ 0.5
	# 	# vz = (positions[ i+2 ] / n * 5) #+ 0.5
	# 	color.setRGB( vx, vy, vz )
	# 	colors[ i ]     = color.r * 255
	# 	colors[ i + 1 ] = color.g * 255
	# 	colors[ i + 2 ] = color.b * 255
	# 	colors[ i + 3 ] = color.r * 255
	# 	colors[ i + 4 ] = color.g * 255
	# 	colors[ i + 5 ] = color.b * 255
	# 	colors[ i + 6 ] = color.r * 255
	# 	colors[ i + 7 ] = color.g * 255
	# 	colors[ i + 8 ] = color.b * 255
	
	# geometry.setIndex( new T.BufferAttribute( indices, 1 ) )
	geometry.addAttribute( 'position', new T.BufferAttribute( positions, 3 ) )
	geometry.addAttribute( 'normal', new T.BufferAttribute( normals, 3, true ) )
	geometry.addAttribute( 'color', new T.BufferAttribute( colors, 3, true ) )
	geometry.addAttribute( 'uv', new T.BufferAttribute( uvs, 2, true ) )
	geometry.computeBoundingSphere()

	return geometry

class @Chunk extends T.Object3D
	@SIZE: SZ # in your face, binary
	constructor: ({@x, @y, @z})->
		super
		
		@position.set @x*SZ, @y*SZ, @z*SZ
		@voxels = new Uint32Array SZ ** 3
		
		@_sullied = no
		
		canvas = document.createElement "canvas"
		canvas.width = canvas.height = SZ
		tex = new T.Texture canvas
		tex.minFilter = T.NearestFilter
		tex.magFilter = T.NearestFilter
		mat = new T.MeshBasicMaterial map: tex, side: T.DoubleSide, vertexColors: T.VertexColors
		mat = new T.MeshBasicMaterial wireframe: yes, vertexColors: T.VertexColors
		# mat = new T.MeshBasicMaterial side: T.DoubleSide, vertexColors: T.VertexColors
		# mat = new T.MeshNormalMaterial #side: T.DoubleSide
		mat.transparent = yes
		mat.alphaTest = 0.5
		
		ctx = canvas.getContext "2d"
		
		ctx.fillStyle = "#005"
		# ctx.fillRect(0, SZ/4, SZ, SZ/2)
		# ctx.fillRect(SZ/4, 0, SZ/2, SZ)
		# ctx.fillRect(0, SZ/4, SZ, Math.sin(x)*SZ/2)
		# ctx.fillRect(SZ/4, 0, Math.sin(y)*SZ/2, SZ)
		
		ctx.fillStyle = "blue"
		ctx.beginPath()
		ctx.arc SZ/2, SZ/2, SZ/3, 0, Math.PI * 2, no
		# ctx.arc SZ/2, SZ/2, SZ/2, 0, Math.PI * 2, no
		# ctx.arc SZ/2, SZ/2, SZ/2 * Math.sin(i/SZ), 0, Math.PI * 2, no
		ctx.fill()
		ctx.fillStyle = "aqua"
		ctx.beginPath()
		# ctx.arc SZ/2, SZ/2, SZ/2-0.01, 0, Math.PI * 2, no
		ctx.arc SZ/2, SZ/2, SZ/3-0.2, 0, Math.PI * 2, no
		ctx.fill()
		tex.needsUpdate = yes
		
		geom = createChunkGeometry()
		mesh = new T.Mesh geom, mat
		@add mesh
		# @frustumCulled = no
		# @doubleSided = yes
		
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
		# for x in [0..SZ]
		# 	for y in [0..SZ]
		# 		for z in [0..SZ]
		# 			@set x, y, z, fn(x+@x*SZ, y+@y*SZ, z+@z*SZ)
	
	update: ->
		@debug.visible = scene.debug
