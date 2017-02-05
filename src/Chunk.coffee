
@chunks = []

SZ = 150

createChunkGeometry = ->
	
	# bufferGeometry = new THREE.BufferGeometry()

	# positions = []
	# normals = []
	# colors = []
	
	triangles = 500000
	geometry = new THREE.BufferGeometry()
	# indices = new Uint32Array( triangles * 3 )
	# for i in [0..indices.length]
	# 	indices[ i ] = i
	positions = new Float32Array( triangles * 3 * 3 )
	normals = new Int16Array( triangles * 3 * 3 )
	colors = new Uint8Array( triangles * 3 * 3 )
	
	positions_index = 0
	normals_index = 0
	
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
		
		# a = 0 + vertices_offset
		# b = 2 + vertices_offset
		# c = 3 + vertices_offset
		# d = 1 + vertices_offset
		
		# positions[i + 0] vertices[ 0 ].x
		# positions[i + 1] vertices[ 0 ].y
		# positions[i + 2] vertices[ 0 ].z
		# positions[i + 3] vertices[ 1 ].x
		# positions[i + 4] vertices[ 1 ].y
		# positions[i + 5] vertices[ 1 ].z
		# positions[i + 6] vertices[ 2 ].x
		# positions[i + 7] vertices[ 2 ].y
		# positions[i + 8] vertices[ 2 ].z
		
		positions[positions_index++] = vertices[ 0 ].x
		positions[positions_index++] = vertices[ 0 ].y
		positions[positions_index++] = vertices[ 0 ].z
		positions[positions_index++] = vertices[ 1 ].x
		positions[positions_index++] = vertices[ 1 ].y
		positions[positions_index++] = vertices[ 1 ].z
		positions[positions_index++] = vertices[ 3 ].x
		positions[positions_index++] = vertices[ 3 ].y
		positions[positions_index++] = vertices[ 3 ].z
		
		positions[positions_index++] = vertices[ 1 ].x
		positions[positions_index++] = vertices[ 1 ].y
		positions[positions_index++] = vertices[ 1 ].z
		positions[positions_index++] = vertices[ 2 ].x
		positions[positions_index++] = vertices[ 2 ].y
		positions[positions_index++] = vertices[ 2 ].z
		positions[positions_index++] = vertices[ 3 ].x
		positions[positions_index++] = vertices[ 3 ].y
		positions[positions_index++] = vertices[ 3 ].z
		
		for [0..6]
			normals[normals_index++] = normal.x
			normals[normals_index++] = normal.y
			normals[normals_index++] = normal.z
		
		# normals.push normal.x
		# normals.push normal.y
		# normals.push normal.z
		# normals.push normal.x
		# normals.push normal.y
		# normals.push normal.z
		# normals.push normal.x
		# normals.push normal.y
		# normals.push normal.z
		
		uva = new T.Vector2 0, 0
		uvb = new T.Vector2 0, 1
		uvc = new T.Vector2 1, 1
		uvd = new T.Vector2 1, 0
		
		# 
		# face = new T.Face3 a, b, d
		# face.normal.copy normal
		# face.vertexNormals.push normal.clone(), normal.clone(), normal.clone()
		# face.materialIndex = materialIndex
		# 
		# @faces.push face
		# @faceVertexUvs[0].push [uva, uvb, uvd]
		# 
		# face = new T.Face3 b, c, d
		# face.normal.copy normal
		# face.vertexNormals.push normal.clone(), normal.clone(), normal.clone()
		# face.materialIndex = materialIndex
		# 
		# @faces.push face
		# @faceVertexUvs[0].push [uvb.clone(), uvc, uvd.clone()]
		
	for i in [0..SZ]
		buildPlane 'x', 'y', i, 0
		buildPlane 'z', 'y', i, 0
		buildPlane 'z', 'x', i, 0
	
	# 
	# bufferGeometry.addAttribute 'position', new THREE.Float32BufferAttribute(positions, 3)
	# bufferGeometry.addAttribute 'normal', new THREE.Float32BufferAttribute(normals, 3)
	# bufferGeometry.addAttribute 'color', new THREE.Float32BufferAttribute(colors, 3)
	
	color = new THREE.Color()
	n = 800; n2 = n/2 # triangles spread in the cube
	# d = 12; d2 = d/2 # individual triangle size
	# pA = new THREE.Vector3()
	# pB = new THREE.Vector3()
	# pC = new THREE.Vector3()
	# cb = new THREE.Vector3()
	# ab = new THREE.Vector3()
	for i in [0..positions.length] by 9
		# positions
		x = Math.random() * n - n2
		y = Math.random() * n - n2
		z = Math.random() * n - n2
		# ax = x + Math.random() * d - d2
		# ay = y + Math.random() * d - d2
		# az = z + Math.random() * d - d2
		# bx = x + Math.random() * d - d2
		# b_y = y + Math.random() * d - d2
		# bz = z + Math.random() * d - d2
		# cx = x + Math.random() * d - d2
		# cy = y + Math.random() * d - d2
		# cz = z + Math.random() * d - d2
		# positions[ i ]     = ax
		# positions[ i + 1 ] = ay
		# positions[ i + 2 ] = az
		# positions[ i + 3 ] = bx
		# positions[ i + 4 ] = b_y
		# positions[ i + 5 ] = bz
		# positions[ i + 6 ] = cx
		# positions[ i + 7 ] = cy
		# positions[ i + 8 ] = cz
		# flat face normals
		# pA.set( ax, ay, az )
		# pB.set( bx, b_y, bz )
		# pC.set( cx, cy, cz )
		# cb.subVectors( pC, pB )
		# ab.subVectors( pA, pB )
		# cb.cross( ab )
		# cb.normalize()
		# nx = cb.x
		# ny = cb.y
		# nz = cb.z
		# normals[ i ]     = nx * 32767
		# normals[ i + 1 ] = ny * 32767
		# normals[ i + 2 ] = nz * 32767
		# normals[ i + 3 ] = nx * 32767
		# normals[ i + 4 ] = ny * 32767
		# normals[ i + 5 ] = nz * 32767
		# normals[ i + 6 ] = nx * 32767
		# normals[ i + 7 ] = ny * 32767
		# normals[ i + 8 ] = nz * 32767
		# colors
		vx = ( x / n ) + 0.5
		vy = ( y / n ) + 0.5
		vz = ( z / n ) + 0.5
		color.setRGB( vx, vy, vz )
		colors[ i ]     = color.r * 255
		colors[ i + 1 ] = color.g * 255
		colors[ i + 2 ] = color.b * 255
		colors[ i + 3 ] = color.r * 255
		colors[ i + 4 ] = color.g * 255
		colors[ i + 5 ] = color.b * 255
		colors[ i + 6 ] = color.r * 255
		colors[ i + 7 ] = color.g * 255
		colors[ i + 8 ] = color.b * 255
	
	# geometry.setIndex( new THREE.BufferAttribute( indices, 1 ) )
	geometry.addAttribute( 'position', new THREE.BufferAttribute( positions, 3 ) )
	geometry.addAttribute( 'normal', new THREE.BufferAttribute( normals, 3, true ) )
	geometry.addAttribute( 'color', new THREE.BufferAttribute( colors, 3, true ) )
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
		# mat = new T.MeshBasicMaterial map: tex, side: T.DoubleSide
		mat = new T.MeshBasicMaterial side: T.DoubleSide, vertexColors: THREE.VertexColors
		# mat = new T.MeshNormalMaterial #side: T.DoubleSide
		# mat.transparent = yes
		# mat.alphaTest = 0.5
		
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
