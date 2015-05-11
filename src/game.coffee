
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
# palette = (v for k, v of THREE.ColorKeywords when k.match /gr/)
# palette = (v for k, v of THREE.ColorKeywords when k.match /wh/)
palette = (v for k, v of THREE.ColorKeywords when k.match /ay/)

# simplex = new SimplexNoise

noise.seed 1337 # out of 0x10000 (?)

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
		unless (
			# Math.sin(x/26.3) - Math.sin(y/20.1) > Math.sin(z/20.2) and
			Math.sin(x/56.3) - Math.sin(y/50.1) - Math.sin(z/40.2) > 0.1
		)
			r = Math.random()
			if r < 0.1
				0x382410
			else if r < 0.2
				0x2C1A0C
			else
				0x23150A
		else
			# 0xffee55 -
			# (0xffee55 * (~~(noise.simplex3(x/20, y/20, z/20)*5)/5)) + 1
			# (((0xffee55 * (~~(noise.simplex3(x/20, y/20, z/20)*5)/5))*0.9)>>>66) + 1111
			# 0xffffff -
			palette[~~((noise.simplex3(x/20, y/20, z/20)+1)/2*palette.length)] or 0x111111
	
	else if Math.sin(x/56.3) - Math.sin((y - 10)/50.1) > Math.sin(z/40.2)
		displaced_x = x + noise.simplex2(x/5, y/50)/200
		displaced_z = z + noise.simplex2(z/5, y/50)/200
		if (
			# Math.sin(x/56.3) - Math.sin((y - 20)/50.1) + Math.sin(x+z/100.3)/3 < Math.sin(z/43.2) and
			# # Math.sin(x/56.3) - Math.sin(y/50.1) + Math.sin(x+z/100.3)/3 < Math.sin(z/43.2) and
			# Math.sin(x/56.3) - Math.sin((y - 20)/50.1) > Math.sin(z/40.2) and
			# # Math.sin(z/56.3) - Math.sin(y/50.1) + Math.sin(z+x/100.3)/3 < Math.sin(x/43.2)
			# # Math.sin(y/56.3) - Math.sin(x/50.1) + Math.sin(y+z/100.3)/3 < Math.sin(z/43.2)
			# Math.sin(z + x/5) < 0
			# # 1
			# noise.simplex2(x, z) > 0.3
			# noise.simplex2(displaced_x/2, displaced_z/2) > 0.7
			noise.simplex2(displaced_x, displaced_z) > 0.3
		)
			r = noise.simplex3(x, y/50, z) + 0.5 #Math.random()
			# 0x010101
			if r < 0.3
				0x5B811A
				# 0x77A028
				# 0x408504
			else if r < 0.9
				0x3A8205
			else
				0x114100
		
		else
			# blue crystals/fungus/whatever
			displaced_x = x/5 + noise.simplex2(x/5, y/50)*3
			displaced_z = z/5 + noise.simplex2(z/5, y/50)*3
			if noise.simplex2(displaced_x/50, displaced_z/50) > 0.7
				r = noise.simplex3(x, y/50, z) + 0.5 #Math.random()
				if r < 0.3
					0xffefaf*0.6/16
				else if r < 0.9
					0xffffcf*0.8/16
				else
					0xfffafa*0.8/16


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
gr = 100
for x in [-gr..gr] by Chunk.SIZE
	for y in [-gr..gr] by Chunk.SIZE
		for z in [-gr..gr] by Chunk.SIZE
			do (x, y, z)->
				# setTimeout ->
					world.get {x, y, z}
				# , Math.random() * 5000

do animate = ->
	world.update()
	controls.update()
	renderer.render scene, camera
	requestAnimationFrame animate

window.onkeydown = (e)->
	# console.log e.keyCode
	if e.keyCode is 113 # F2
		scene.debug = not scene.debug
