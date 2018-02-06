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

### the plan

the plan/todo for VoxelFace is:

* create textures from voxel data. (currently there's just one texture with some shapes drawn on it)

* based on the camera angle, swap out different geometries so that the layers are always ordered from *back to front* to minimize alpha testing.

* could make the textures actually different between the two sides of the same axis,
i.e. have different textures for the six directions instead of the three axes

* could send the voxel data for use in the fragment shader, instead of precomputing textures on the CPU

* could maybe have the chunk geometry generated in a geometry/vertex shader, but I doubt this would be a bottleneck, so there's probably no point!

## plan b (or is it c? i think it's c, technically)

if voxelface doesn't work out (and it probably won't),
I have some ideas about optimizing a raymarcher,
based on existing ideas about optimizing raymarchers,
but what seems like the logical next step(s) (to me)

* instead of just signed distance fields (spherical or cuboidal), six fields, one for each direction
	* check for the minimum of the values for each of the 3 directions a ray is going
		* maybe do something fancier/faster for when its direction vector is at least twice as much in one direction as another?
			* (imagine a ray going along above a surface mostly parallel to it but still technically towards it in terms of just the signs of the components of its direction vector)
	* this would involve a lot more data, six channels per voxel instead of one (excluding regular voxel data like material/color) which might make this less feasible
		* reading from a much larger texture at 6 different points (or from six different textures) might be too big a performance hit
		* if storing it in a texture the same size as with regular signed distance fields, unpacking a value into six values might be too slow and might severely limit the data (highest jump posibility, or well, I guess it could be scaled, e.g. 4 voxels minimum/unit jump, so just the fidelity/level of the optimization (to be clear, the end result would be the same other than speed, I don't mean fidelity of the rendered output)))

* while we're storing extra data, why not store that same sort of data for (jumps within) 1. the single chunk and 2. a neighborhod of chunks
	* (using the term neighborhoods rather than groups because they can overlap)
	* when a chunk is modified, it can invalidate chunks within the neighborhood size, but they can fall back to the  
	* the size could be 3x3x3 or whatever works best (maybe 3x3x1 if chunks are tall, or even 15x15x5 if it turns out this works well for many chunks; but it depends a lot on chunk size!)
	* could maybe even *progressively* reoptimize, in a scanning matter, for the different directions, on the GPU

but idk i've never implemented a ray/path tracer/marcher/caster/renderer

i think i understand them enough to *hypothesize* about some optimizations,
but i really don't know... like how to go about doing them on the GPU
(how the shader accesses the data etc.)
