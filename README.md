# Voxelite

It's some sort of thing with voxels.

There's a few interesting things to look at if you view each commit with RawGit:

(you have to zoom out a lot for some of these)

* [staggered chunk generation](https://rawgit.com/1j01/voxelite/2a151fdd029f085cb3c2bac1f15e91e2a87df0f7/index.html)

* [F2 to debug](https://rawgit.com/1j01/voxelite/a13424d1783611c9e18821cb4bc3819692dbc6cc/index.html)

* [Rainbow Stairsphere](https://rawgit.com/1j01/voxelite/8cd8870528dbee0745bbcec65104edfe9f7a6a8b/index.html)

* [some striped dirt](https://rawgit.com/1j01/voxelite/44c8f41ad6ca710e3581b5a78c3356e958bc236e/index.html)

* [dirt and some grass and flowers (cut off really inorganically), and a fun Perlin noise pattern just under the surface of dirt](https://rawgit.com/1j01/voxelite/514f490d74df7d5b2ecadf7378f27ab9e435aba9/index.html)

## VoxelFace

VoxelFace is a different approach to rendering voxels, where all chunks use the same geometry:
layers of quads in each of 3 axes,
textured with slices of what would normally be the mesh.
The faces of voxels become pixels in a texture.

It's probably just straight-up worse than ray marching. But *maybe* it could be faster? Maybe?	
(Probably someone would have done it already, if it was going to be faster.)

RawGit links for commits on the `voxel-face` branch:

* [non-Euclidean aqua rods](https://rawgit.com/1j01/voxelite/62fec519f92fa96b079ce5b28ba06736b3aabc54/index.html)

* ["this isn't gonna work"](https://rawgit.com/1j01/voxelite/657cc59749f3e2ba7fa174d413ebe84dd2a7a7af/index.html)

* [oh hey wait, there is a way to do it! it's slow tho](https://rawgit.com/1j01/voxelite/bc11e4a023c7bd298e9024ee1b8fe084c3a081d5/index.html)

* [switching to BufferGeometry](https://rawgit.com/1j01/voxelite/29bc865f623e3deb2e21fc6ef12a8dd1a911404b/index.html)

* ["Apply nonsense UVs"](https://rawgit.com/1j01/voxelite/d976be9e3467df34f1eba317b772c3aabf67f31d/index.html)

* [rainbow cube of lines](https://rawgit.com/1j01/voxelite/a487a3f97eb8ce5930580cd8a33a8ba4f8b2bc84/index.html)

* [fix the geometry](https://rawgit.com/1j01/voxelite/29e2f8b17f6cb30d7b79f745194d8b7e878fbe9e/index.html)

* [noise cube](https://github.com/1j01/voxelite/commit/40f32be89b830e99163e5f7e231d2e5b71453142)

* [very sparse noise (try zooming in as far as you can)](https://github.com/1j01/voxelite/commit/089779ff5ff55c07b6b065008d5ba5c5e2097559)

### the plan

the plan/todo for VoxelFace is:

* create textures from voxel data. (currently there's just one texture with some shapes drawn on it)

* based on the camera angle, swap out different geometries so that the layers are always ordered from *back to front* to minimize alpha testing.

* could make the textures actually different between the two sides of the same axis,
i.e. have different textures for the six directions instead of the three axes

* could send the voxel data for use in the fragment shader, instead of precomputing textures on the CPU

* could maybe have the chunk geometry generated in a geometry/vertex shader, but I doubt this would be a bottleneck, so there's probably no point!

## Six-Axis SDF

If voxelface doesn't work out (and it probably won't),
I have some ideas about **optimizing a raymarcher**,
based on existing ideas about optimizing raymarchers,
but what seems like the logical next step(s) (to me)

* instead of just signed distance fields (spherical or cuboidal), the idea is to use six distinct fields, one for each direction
	* each field stores the distance to the nearest surface in that direction
	* check for the minimum of the values for each of the 3 directions a ray is going
		* maybe do something fancier/faster for when its direction vector is at least twice as much in one direction as another?
			* (imagine a ray going along above a surface mostly parallel to it but still technically towards it in terms of just the signs of the components of its direction vector)
		* ⚠️ WAIT, FATAL FLAW: the distance to the nearest surface in an arbitrary direction may be smaller than the minimum of the distances in the three cardinal directions.
			* Picture a ray going diagonally towards a corner of a cube. To the left, right, and up (say), it would never meet the cube, but diagonally, it may run into it immediately.
			* Could store instead the distances to any surface in the slab of space between the point and the boundary of the chunk, for each axis, but I'm not sure this would give such a big speedup...
				* Compare a clever bit masking trick done on voxel occupancy masks described in this video: [Doubling the speed of my game's graphics [Voxel Devlog #18]](https://www.youtube.com/watch?v=P2bGF6GPmfc)
					* It only works with small (4^3) voxel chunks, since it needs to fit the bit mask in an int64 (64=4^3 bits), although perhaps could be hierarchically applied to superchunks... he does say "tree" at one point, so maybe he's already doing that
					* (Is it equivalent, though? I don't *think* it's equivalent, and probably this bit masking is a better idea, a truer version of a similar idea)
  				* maybe it's not a fatal flaw, maybe I just had some different conception of it that got lost in translation...  
				  What if instead of storing the nearest distance in a cardinal ray (flawed), or a cardinal plane sweep (correct but not necessarily fast), it stores the nearest distance in a *hemispherical* search. Like, SDF is normally spherical, grid SDF is cuboidal, right? But this would store the closest intersection point of any ray where a given axis is positive (or negative, depending on the side).
	* this would involve a lot more data, six channels per voxel instead of one (excluding regular voxel data like material/color) which might make this less feasible
		* reading from a much larger texture at 6 different points (or from six different textures) might be too big a performance hit
		* if storing it in a texture the same size as with regular signed distance fields, unpacking a value into six values might be too slow and might severely limit the data (highest jump possibility, or well, I guess it could be scaled, e.g. 4 voxels minimum/unit jump, so just the fidelity/level of the optimization (to be clear, the end result would be the same other than speed, I don't mean fidelity of the rendered output))

* while we're storing extra data, why not store that same sort of data for (jumps within) 1. the single chunk and 2. a neighborhood of chunks
	* (using the term neighborhoods rather than groups because they can overlap)
	* when a chunk is modified, it can invalidate chunks within the neighborhood size, but they can fall back to the acceleration just within the individual chunks (see variation below\*)
	* the size could be 3x3x3 or whatever works best (maybe 3x3x1 if chunks are tall, or even 15x15x5 if it turns out this works well for many chunks; but it depends a lot on chunk size!)
	* could maybe even *progressively* reoptimize, in a scanning matter, for the different directions, on the GPU

* (\*variation on above) could store distances in a way where numbers greater than some value represent jumps between a number of chunks (minus said number) instead of voxels within a chunk
	* when chunk data is changed, could mark neighboring chunks (within the max chunk jump distance) as needing reoptimization, and only disable the inter-chunk jumps that are affected, while maintaining the intra-chunk acceleration

* btw for LOD, could render chunks to individual billboards, as opposed to a single skybox texture
	* this way, when a chunk is modified, only it needs to be re-rendered
	* similarly, when a chunk switches to different LOD, only it needs to be re-rendered; with a single skybox texture, even using scissor rendering to selectively update a region, everything behind it would need to be rendered again (potentially many chunks)
	* could use scissors to efficiently update billboards, for far away chunks that are changed by other players in a multiplayer game, for example
	* What should happen if you move laterally?
		* Re-rendering them when a threshold is reached would likely cause a pop and be too expensive.
		* Are they going to be far away enough that it's not a problem? Well, picture this: you can stay at a particular distance from a chunk, and circle all around it. So it would definitely be a problem.
		* Could render the chunk from two different angles, and blend between them based on camera angle and depth information, for a pseudo 3D effect, and switch to new angles as needed, maybe storing old angle renders to avoid unnecessary re-rendering (at least one, making three total angle renders stored, to avoid very quickly needing to re-render when moving across an angular threshold)

* could store depth info, for both billboards and raymarched geometry, in order to integrate other geometry (e.g. a player model) into the scene with depth testing

but idk i've never implemented a ray/path tracer/marcher/caster/renderer

i think i understand them enough to *hypothesize* about some optimizations,
but i really don't know... like how to go about doing them on the GPU
(how the shader accesses the data etc.)
