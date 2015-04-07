
@chunks = []

voxel_mat = new T.MeshBasicMaterial
	# wireframe: yes
	color: 0xffffff
	side: T.DoubleSide # @FIXME
	vertexColors: T.FaceColors

# voxel_mat = new T.MeshPhongMaterial
# 	color: 0xffffff
# 	vertexColors: T.FaceColors

class @Chunk extends T.Object3D
	@SIZE: SZ = 20 # ha
	constructor: ({@x, @y, @z})->
		super
		
		@position.set @x*SZ, @y*SZ, @z*SZ
		@voxels = new Uint32Array(SZ ** 3)
		
		@_sullied = no
		
		@debug = new THREE.BoxHelper
		@debug.scale.set SZ/2, SZ/2, SZ/2
		@debug.position.set SZ/2, SZ/2, SZ/2
		@add @debug
		
		scene.add @
		
		chunks.push @
	
	get: (x, y, z)->
		@voxels[x*SZ*SZ + y*SZ + z]
	
	set: (x, y, z, v)->
		@voxels[x*SZ*SZ + y*SZ + z] = v
		@_sullied = yes
	
	init: (fn)->
		for x in [0..SZ]
			for y in [0..SZ]
				for z in [0..SZ]
					@set x, y, z, fn(x+@x*SZ, y+@y*SZ, z+@z*SZ)
	
	update: ->
		@debug.visible = scene.debug
		if @_sullied
			@_sullied = no
			scene.remove @mesh if @mesh
			# geometry = new GreedyGeometry @voxels, [SZ, SZ, SZ]
			geometry = new MonotoneGeometry @voxels, [SZ, SZ, SZ]
			geometry.computeFaceNormals()
			# geometry.computeVertexNormals()
			@mesh = new T.Mesh(
				geometry
				voxel_mat
			)
			@add @mesh
