
class @Voxel
	constructor: ({x, y, z})->
		cube = new THREE.Mesh(
			new THREE.CubeGeometry(1, 1, 1)
			new THREE.MeshNormalMaterial()
		)
		cube.position.x = x
		cube.position.y = y
		cube.position.z = z
		return cube
	
