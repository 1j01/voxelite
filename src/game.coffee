
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

@palette = (v for k, v of THREE.ColorKeywords when Math.random() < 0.1)
palette = [16119260, 14596231, 16744272, 12433259, 3100495, 16766720, 11393254, 2142890, 16777184, 9662683, 3978097, 16770229, 8421376, 13468991, 16119285]
# palette = (v for k, v of THREE.ColorKeywords when k.match /en/) # green
# palette = (v for k, v of THREE.ColorKeywords when k.match /ne/) # ice
# palette = (v for k, v of THREE.ColorKeywords when k.match /se/)
# palette = (v for k, v of THREE.ColorKeywords when k.match /ra/)
# palette = (v for k, v of THREE.ColorKeywords when k.match /oi/)

r = 40
ir = 0#r-4
world.generate (x, y, z)->
	if x*x + y*y + z*z <= r*r*(1+Math.cos(x/y/z))
		# 0xafaf0f
		# 0xffffff * (~~(Math.random()/3))
		# 0xffffff * (~~(Math.random()*15))/15
		# palette[~~(Math.random()*palette.length)]
		palette[~~((x/y/z)*palette.length)]
		# x*y*z*z
		# (x/r*255)**3 +
		# (y/r*255)**1 +
		# (z/r*255)**2
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
gr = r * 4
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
