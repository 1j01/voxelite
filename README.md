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

### the plan

the plan/todo for VoxelFace is:

* create textures from voxel data. (currently there's just one texture with some shapes drawn on it)

* based on the camera angle, swap out different geometries so that the layers are always ordered from *back to front* to minimize alpha testing.

* could make the textures actually different between the two sides of the same axis,
i.e. have different textures for the six directions instead of the three axes

* could send the voxel data for use in the fragment shader, instead of precomputing textures on the CPU

* could maybe have the chunk geometry generated in a geometry/vertex shader, but I doubt this would be a bottleneck, so there's probably no point!
