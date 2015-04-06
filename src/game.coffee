

# cube = new THREE.Mesh(
# 	new THREE.CubeGeometry(100, 100, 100)
# 	new THREE.MeshBasicMaterial(color: 0xff00ff)
# )
# scene.add cube
# console.log scene

# v = new Voxel {x: 0, y: 0, z: 0}
# scene.add v

@world = new World

# for x in [-10..10]
# 	for z in [-10..10]
# 		for y in [0..Math.random()*5]
# 			@world.set {x, y, z}, yes

# for x in [-10..10]
# 	for z in [-10..10]
# 		for y in [0..Math.random()*x*z/5]
# 			@world.set {x, y, z}, yes

# palette = (v for k, v of THREE.ColorKeywords when Math.random() < 0.1)
# palette = (v for k, v of THREE.ColorKeywords when k.match /en/) # green
# palette = (v for k, v of THREE.ColorKeywords when k.match /ne/) # ice
# palette = (v for k, v of THREE.ColorKeywords when k.match /se/)
# palette = (v for k, v of THREE.ColorKeywords when k.match /ra/)
palette = (v for k, v of THREE.ColorKeywords when k.match /oi/)

r = 40
ir = r-4
for x in [-r..r]
	for y in [-r..r]
		for z in [-r..r]
			world.set {x, y, z},
				if ir*ir <= x*x + y*y + z*z <= r*r
					# 0xafaf0f
					# 0xffffff * (~~(Math.random()/3))
					# 0xffffff * (~~(Math.random()*15))/15
					# palette[~~(Math.random()*palette.length)]
					# x*y*z*z
					# (x/r*255)**1 +
					# (y/r*255)**2 +
					# (z/r*255)**3
					# (x/r)*(255**1) +
					# (y/r)*(255**2) +
					# (z/r)*(255**3)
					(x/r/2*255)**1 +
					(y/r/2*255)**2 +
					(z/r/2*255)**3
				else
					0


# world.add @player = new Player
# world.carve 0, 0, 0



do animate = ->
	world.update()
	controls.update()
	renderer.render scene, camera
	requestAnimationFrame animate

