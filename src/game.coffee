
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

# @palette = (v for k, v of THREE.ColorKeywords when Math.random() < 0.1)
# palette = (v for k, v of THREE.ColorKeywords when k.match /en/) # green
# palette = (v for k, v of THREE.ColorKeywords when k.match /ne/) # ice
# palette = (v for k, v of THREE.ColorKeywords when k.match /se/)
# palette = (v for k, v of THREE.ColorKeywords when k.match /ra/)
# palette = (v for k, v of THREE.ColorKeywords when k.match /oi/)

world.generate (x, y, z)->
	# unless Math.sin(x/56.3) - Math.sin(y/50.1) < Math.sin(z/40.2)
	# unless Math.sin(x/56.3) - Math.sin(y/50.1) + Math.sin(x*z/100.3)/3 < Math.sin(z/43.2)
	# 	r = Math.random()
	# 	if r < 0.1
	# 		0x382410
	# 	else if r < 0.2
	# 		0x2C1A0C
	# 	else
	# 		0x23150A
	if Math.sin(x/56.3) - Math.sin(y/50.1) > Math.sin(z/40.2)
		if Math.sin(x/56.3) - Math.sin(y/50.1) + Math.sin(x+z/100.3)/3 < Math.sin(z/43.2)
			0x010101
		else
			r = Math.random()
			if r < 0.1
				0x382410
			else if r < 0.2
				0x2C1A0C
			else
				0x23150A


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
gr = 80
for x in [-gr..gr] by Chunk.SIZE
	for y in [-gr..gr] by Chunk.SIZE
		for z in [-gr..gr] by Chunk.SIZE
			do (x, y, z)->
				setTimeout ->
					world.get {x, y, z}
				, Math.random() * 5000

do animate = ->
	world.update()
	controls.update()
	renderer.render scene, camera
	requestAnimationFrame animate

window.onkeydown = (e)->
	# console.log e.keyCode
	if e.keyCode is 113 # F2
		scene.debug = not scene.debug
