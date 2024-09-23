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

### VoxelFace Plan

The plan/todo for VoxelFace is:

* Create textures from voxel data. (currently there's just one texture with some shapes drawn on it)

* Based on the camera angle, swap out different geometries so that the layers are always ordered from *back to front* to minimize alpha testing.

* Could make the textures actually different between the two sides of the same axis,
i.e. have different textures for the six directions instead of the three axes

* Could send the voxel data for use in the fragment shader, instead of precomputing textures on the CPU

* Could maybe have the chunk geometry generated in a geometry/vertex shader, but I doubt this would be a bottleneck, so there's probably no point!

## Six-Axis SDF and Octant Distance Fields (ODF)

If VoxelFace doesn't work out (and it probably won't),
I have some ideas about **optimizing a raymarcher**,
based on existing ideas about optimizing raymarchers,
but what seems like the logical next step(s) (to me)

* Instead of just signed distance fields (spherical or cuboidal), the idea is to use six distinct fields, one for each direction
	* Each field stores the distance to the nearest surface in that direction
	* Check for the minimum of the values for each of the 3 directions a ray is going
		* Maybe do something fancier/faster for when its direction vector is at least twice as much in one direction as another?
			* (Imagine a ray going along above a surface mostly parallel to it but still technically towards it in terms of just the signs of the components of its direction vector)
		* ⚠️ WAIT, FATAL FLAW: the distance to the nearest surface in an arbitrary direction may be smaller than the minimum of the distances in the three cardinal directions.
			* Picture a ray going diagonally towards a corner of a cube. To the left, right, and up (say), it would never meet the cube, but diagonally, it may run into it immediately.
			* Could store instead the distances to any surface in the slab of space between the point and the boundary of the chunk, for each axis, but I'm not sure this would give such a big speedup...
				* Compare a clever bit masking trick done on voxel occupancy masks described in this video: [Doubling the speed of my game's graphics [Voxel Devlog #18]](https://www.youtube.com/watch?v=P2bGF6GPmfc)
					* It only works with small (4^3) voxel chunks, since it needs to fit the bit mask in an int64 (64=4^3 bits), although perhaps could be hierarchically applied to superchunks... he does say "tree" at one point, so maybe he's already doing that
					* (Is it equivalent, though? I don't *think* it's equivalent, and probably this bit masking is a better idea, a truer version of a similar idea)
			* (Maybe it's not a fatal flaw, maybe I just had some different conception of it that got lost in translation...)  
			  What if instead of storing the nearest distance in a cardinal ray (flawed), or a cardinal plane sweep (correct but not necessarily fast), it stores the nearest distance in a *hemispherical* search. Like, SDF is normally spherical, right? But this would store the closest intersection point of any ray where a given axis is positive (or negative, depending on the side).
			* (If you have tons and tons of memory, you could store the distance to the nearest surface for every combination of...)
			  Wait, there's only eight combinations of positive and negative for three axes. That would only be 33% more memory, and would shrink the hemisphere to a quarter of a hemisphere (an octant of a sphere), making it a much better approximation of the maximum safe distance to march in any direction. Yes, octants might be the way to go. Octant distance fields. 💡🎱👀
				* Note: need to handle cardinal directions by carefully including zero in the range of vector components for ray angles when calculating the distance fields, in either the positive or negative set of fields (possibly both? would be safest, but not sure it's necessary), and making sure the appropriate field is used when some ray components are zero (if only the positive or only the negative set of fields are inclusive of zero)
				* Also note: Euclidean distance isn't necessarily best for the fields for ray marching a voxel grid, and it's harder to calculate efficiently.
	* This would involve a lot more data, six channels per voxel instead of one (excluding regular voxel data like material/color) which might make this less feasible
		* Reading from a much larger texture at 6 different points (or from six different textures) might be too big a performance hit
		* If storing it in a texture the same size as with regular signed distance fields, unpacking a value into six values might be too slow and might severely limit the data (highest jump possibility, or well, I guess it could be scaled, e.g. 4 voxels minimum/unit jump, so just the fidelity/level of the optimization (to be clear, the end result would be the same other than speed, I don't mean fidelity of the rendered output))

* While we're storing extra data, why not store that same sort of data for (jumps within) 1. the single chunk and 2. a neighborhood of chunks
	* (I'm using the term neighborhoods rather than groups because they can overlap.)
	* When a chunk is modified, it can invalidate chunks within the neighborhood size, but they can fall back to the acceleration just within the individual chunks (see variation below\*)
	* The size could be 3x3x3 or whatever works best (maybe 3x3x1 if chunks are tall, or even 15x15x5 if it turns out this works well for many chunks; but it depends a lot on chunk size!)
	* Could maybe even *progressively* reoptimize, in a scanning matter, for the different directions, on the GPU

* (\*variation on above) Could store distances in a way where numbers greater than some value represent jumps between a number of chunks (minus said number) instead of voxels within a chunk
	* When chunk data is changed, could mark neighboring chunks (within the max chunk jump distance) as needing reoptimization, and only disable the inter-chunk jumps that are affected, while maintaining the intra-chunk acceleration

* BTW for LOD, could render chunks to individual billboards, as opposed to a single skybox texture
	* This way, when a chunk is modified, only it needs to be re-rendered
	* Similarly, when a chunk switches to different LOD, only it needs to be re-rendered; with a single skybox texture, even using scissor rendering to selectively update a region, everything behind it would need to be rendered again (potentially many chunks)
	* Could use scissors to efficiently update billboards, for far away chunks that are changed by other players in a multiplayer game, for example
	* What should happen if you move laterally?
		* Re-rendering them when a threshold is reached would likely cause a pop and be too expensive.
		* Are they going to be far away enough that it's not a problem? Well, picture this: you can stay at a particular distance from a chunk, and circle all around it. So it would definitely be a problem.
		* Could render the chunk from two different angles, and blend between them based on camera angle and depth information, for a pseudo 3D effect, and switch to new angles as needed, maybe storing old angle renders to avoid unnecessary re-rendering (at least one, making three total angle renders stored, to avoid very quickly needing to re-render when moving across an angular threshold)
			* (The parallax shader would have to be significantly cheaper than ray marching, or else, one might as well just ray march the geometry!)
				* (The billboards *could* comprise multiple chunks, which would balance the performance tradeoffs in favor of the billboards, but the same could be done with ray marching rendered chunks...)

* Could store depth info, for both billboards and raymarched geometry, in order to integrate other geometry (e.g. a player model) into the scene with depth testing

* Another idea I had, related to the parallax billboards, is to fully ray march a placeholder cuboid geometry the size of a chunk, in order to render chunks
	* Pro: sections of the screen where there are no chunks would not be ray marched
	* Pro: less ray marching steps, since the rays can start from the boundary of the chunk rather than the camera (either by projecting onto the chunk cuboid, or by using a depth map from pre-rendering the scene's depth at low resolution, combined with other parts of a [beam optimization described here](https://www.youtube.com/watch?v=P2bGF6GPmfc))
	* Pro: chunks can be arbitrarily oriented, allowing for things like destructible terrain that breaks into chunks with physics, complex character models, etc. with a single rendering method
	* Con: occluded chunks may be rendered... right? or can the shader bail out by looking at the depth buffer after some chunks have already rendered? (would have to render front-to-back for that to work)
	* How would reflections work? would rays be able to cross chunk boundaries?
	* When I thought of this idea in the past I thought it was a really cool idea but probably wouldn't work in practice (or else people would be doing it, right?) Well it turns out [it is feasible](https://www.youtube.com/watch?v=h81I8hR56vQ), and is apparently the basis of a really impressive voxel engine (assuming it's survived whatever rewrites). Douglas Dwyer, the engine's author, calls it "parallax ray marching".
	* ((If you rendered a depth buffer of just the chunk boundaries and use that to inform where rays should start, you could also use that depth buffer as a stencil (whether using the stencil buffer, if that applies here (never used it) or just bailing out of the shader if the depth is infinite) and render everything in one pass, BUT it would have cases where it would need many more ray marching steps than a single chunk, if the ray goes through multiple chunks, since the depth info would only be for the nearest chunk even though chunks are only partially opaque, so it would be back to square one in the worst case, which would be a common case.))

I may have never implemented a ray/path tracer/marcher/caster/renderer before but I think I understand them enough to *hypothesize* about some optimizations.
