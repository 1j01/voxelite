
class @World
	constructor: ->
		@chunks = {}
	
	at = (v3)->
		"#{~~v3.x}, #{~~v3.y}, #{~~v3.z}"
	
	getChunk: (v3)->
		x = v3.x // Chunk.SIZE
		y = v3.y // Chunk.SIZE
		z = v3.z // Chunk.SIZE
		@chunks[at {x, y, z}] ?= new Chunk {x, y, z}
	
	get: (v3)->
		@getChunk(v3).get(
			~~v3.x %% Chunk.SIZE
			~~v3.y %% Chunk.SIZE
			~~v3.z %% Chunk.SIZE
		)
	
	set: (v3, v)->
		return unless v
		@getChunk(v3).set(
			~~v3.x %% Chunk.SIZE
			~~v3.y %% Chunk.SIZE
			~~v3.z %% Chunk.SIZE
			v
		)
	
	update: ->
		chunk.update() for chunk in chunks
