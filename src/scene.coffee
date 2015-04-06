
# SCENE
@scene = new T.Scene

# CAMERA
WIDTH = window.innerWidth
HEIGHT = window.innerHeight
ASPECT = WIDTH / HEIGHT
FOV = 45
NEAR = 0.1
FAR = 20000
@camera = new T.PerspectiveCamera(FOV, ASPECT, NEAR, FAR)
scene.add(camera)
camera.position.set(15, 55, 40)
camera.lookAt(scene.position)

# RENDERER
@renderer = 
	if Detector.webgl
		new T.WebGLRenderer(antialias: yes)
	else
		new T.CanvasRenderer()

renderer.setSize(WIDTH, HEIGHT)
renderer.setClearColor(0x2f2f2f)
document.body.appendChild(renderer.domElement)

window.onresize = ->
	WIDTH = window.innerWidth
	HEIGHT = window.innerHeight
	ASPECT = WIDTH / HEIGHT
	
	renderer.setSize(WIDTH, HEIGHT)
	camera.aspect = ASPECT
	camera.updateProjectionMatrix()


# CONTROLS
@controls = new T.OrbitControls(camera, renderer.domElement)

# LIGHTING
# light = new T.PointLight(0xffffff, 1, 10000)
# light.position.set(0, 100, 0)
# scene.add light

# scene.add new T.AmbientLight(0x222222)
# 
# # SKYBOX/FOG
# skyBoxGeometry = new T.BoxGeometry(10000, 10000, 10000)
# skyBoxMaterial = new T.MeshBasicMaterial(color: 0xaabDf0, side: T.BackSide)
# skyBox = new T.Mesh(skyBoxGeometry, skyBoxMaterial)
# scene.add skyBox
