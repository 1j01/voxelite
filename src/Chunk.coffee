
@chunks = []

SZ = 50

class ChunkGeometry extends T.Geometry
	constructor: ()->
		super
		
		buildPlane = (u, v, z, materialIndex)=>
			vertices_offset = @vertices.length
			
			w = switch u + v
				when "xy", "yx" then "z"
				when "xz", "zx" then "y"
				when "zy", "yz" then "x"
			
			normal = new T.Vector3
			
			normal[w] = 1
			
			for ix in [0..1]
				for iy in [0..1]
					vector = new T.Vector3
					vector[u] = ix * SZ
					vector[v] = iy * SZ
					vector[w] = z
					@vertices.push vector
			
			a = 0 + vertices_offset
			b = 2 + vertices_offset
			c = 3 + vertices_offset
			d = 1 + vertices_offset
			
			uva = new T.Vector2 0, 0
			uvb = new T.Vector2 0, 1
			uvc = new T.Vector2 1, 1
			uvd = new T.Vector2 1, 0
			
			face = new T.Face3 a, b, d
			face.normal.copy normal
			face.vertexNormals.push normal.clone(), normal.clone(), normal.clone()
			face.materialIndex = materialIndex
			
			@faces.push face
			@faceVertexUvs[0].push [uva, uvb, uvd]
			
			face = new T.Face3 b, c, d
			face.normal.copy normal
			face.vertexNormals.push normal.clone(), normal.clone(), normal.clone()
			face.materialIndex = materialIndex
			
			@faces.push face
			@faceVertexUvs[0].push [uvb.clone(), uvc, uvd.clone()]
		
		for i in [0..SZ]
			buildPlane 'x', 'y', i, 0
			# buildPlane 'z', 'y', i, 0
			# buildPlane 'z', 'x', i, 0

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
		mat = new T.MeshBasicMaterial map: tex, side: T.DoubleSide
		mat.transparent = yes
		
		ctx = canvas.getContext "2d"
		ctx.fillStyle = "blue"
		ctx.beginPath()
		ctx.arc SZ/2, SZ/2, SZ/2, 0, Math.PI * 2, no
		# ctx.arc SZ/2, SZ/2, SZ/2 * Math.sin(i/SZ), 0, Math.PI * 2, no
		ctx.fill()
		ctx.fillStyle = "aqua"
		ctx.beginPath()
		ctx.arc SZ/2, SZ/2, SZ/2-0.01, 0, Math.PI * 2, no
		ctx.fill()
		tex.needsUpdate = yes
		
		geom = new ChunkGeometry
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
		# for x in [0..SZ]
		# 	for y in [0..SZ]
		# 		for z in [0..SZ]
		# 			@set x, y, z, fn(x+@x*SZ, y+@y*SZ, z+@z*SZ)
	
	update: ->
		@debug.visible = scene.debug
