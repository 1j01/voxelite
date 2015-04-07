
@world = new World

# r = 10

# for x in [-r..r]
# 	for z in [-r..r]
# 		for y in [0..Math.random()*5]
# 			@world.set {x, y, z},
# 				~~(Math.random()*255)*255*255

# for x in [-r..r]
# 	for z in [-r..r]
# 		for y in [0..Math.random()*x*z/5]
# 			@world.set {x, y, z},
# 				(x/r*255)**1 +
# 				(y/r*255)**2 +
# 				(z/r*255)**3

# palette = (v for k, v of THREE.ColorKeywords when Math.random() < 0.1)
# palette = (v for k, v of THREE.ColorKeywords when k.match /en/) # green
# palette = (v for k, v of THREE.ColorKeywords when k.match /ne/) # ice
# palette = (v for k, v of THREE.ColorKeywords when k.match /se/)
# palette = (v for k, v of THREE.ColorKeywords when k.match /ra/)
# palette = (v for k, v of THREE.ColorKeywords when k.match /oi/)

r = 25#40
ir = 0#r-4
world.generate (x, y, z)->
	if ir*ir <= x*x + y*y + z*z <= r*r
		# 0xafaf0f
		# 0xffffff * (~~(Math.random()/3))
		# 0xffffff * (~~(Math.random()*15))/15
		# palette[~~(Math.random()*palette.length)]
		x*y*z*z
		# (x/r*255)**1 +
		# (y/r*255)**2 +
		# (z/r*255)**3
	else
		0
	# 0xffffff * Math.random()


# world.get {x: 0, y: 0, z: 0}

# console.profile "Generate World (Data)"
# r*=2
# for x in [-r..r]
# 	for y in [-r..r]
# 		for z in [-r..r]
# 			world.get {x, y, z}
# console.profileEnd "Generate World (Data)"
# 
# # world.add @player = new Player
# # world.carve 0, 0, 0
# 
# console.profile "Generate Meshes"
# world.update()
# console.profileEnd "Generate Meshes"

# TRIGGER CHUNK GENERATION
for x in [-r*2..r] by r
	for y in [-r*2..r] by r
		for z in [-r*2..r] by r
			do (x, y, z)->
				setTimeout ->
					world.get {x, y, z}
				, Math.random() * 5000

do animate = ->
	world.update()
	controls.update()
	renderer.render scene, camera
	requestAnimationFrame animate

