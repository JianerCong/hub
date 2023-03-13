console.log('main.js loaded');
import * as THREE from 'three';

import { GUI } from 'three/addons/libs/lil-gui.module.min.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { Sky } from 'three/addons/objects/Sky.js';

let camera, scene, renderer;

let sky, sun;

init();
render();

function initSky() {

	// Add Sky
	sky = new Sky();
	sky.scale.setScalar( 450000 );
	scene.add( sky );

	sun = new THREE.Vector3();

	/// GUI
	const effectController = {
		turbidity: 2,
		rayleigh: 3,
		mieCoefficient: 0.005,
		mieDirectionalG: 0.7,
		elevation: 2,
		azimuth: 90,
		exposure: renderer.toneMappingExposure
	};
	function guiChanged() {
		const uniforms = sky.material.uniforms;

		const phi = THREE.MathUtils.degToRad( 90 - effectController.elevation );
		const theta = THREE.MathUtils.degToRad( effectController.azimuth );

		sun.setFromSphericalCoords( 1, phi, theta );

		uniforms[ 'sunPosition' ].value.copy( sun );

		renderer.toneMappingExposure = effectController.exposure;
		renderer.render( scene, camera );

	}
	const gui = new GUI();
	gui.add( effectController, 'elevation', 0, 90, 0.1 ).onChange( guiChanged );
	gui.add( effectController, 'azimuth', - 180, 180, 0.1 ).onChange( guiChanged );
	gui.add( effectController, 'exposure', 0, 1, 0.0001 ).onChange( guiChanged );
	guiChanged();
}


function onWindowResize() {
	camera.aspect = window.innerWidth / window.innerHeight;
	camera.updateProjectionMatrix();

	renderer.setSize( 0.1 * window.innerWidth, 0.1* window.innerHeight );
	render();
}

function render() {
	renderer.render( scene, camera );
}

function init() {

  /* aspect ratio, near, far */
	camera = new THREE.PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 0.1, 2000 );
	camera.position.set( 0, 100, 200 );/* x,y,z  (left, up, front)*/
	scene = new THREE.Scene();

  // helpers
	const grid_helper = new THREE.GridHelper( 100, 4, 0xffffff, 0xffffff );
	scene.add( grid_helper );
  const axes_helper = new THREE.AxesHelper(50);
	scene.add( axes_helper );

  // render setting and add to 
	renderer = new THREE.WebGLRenderer();
	renderer.setPixelRatio( window.devicePixelRatio );
	renderer.setSize( window.innerWidth, window.innerHeight );
	renderer.outputEncoding = THREE.sRGBEncoding;
	renderer.toneMapping = THREE.ACESFilmicToneMapping;
	renderer.toneMappingExposure = 0.5;
	document.body.appendChild( renderer.domElement );

  /* listen to 'change */
	const controls = new OrbitControls( camera, renderer.domElement );
	controls.addEventListener( 'change', render );
	controls.maxPolarAngle = Math.PI / 2; // cannot look from bottom up
	controls.enableZoom = false;
	controls.enablePan = false;

	initSky();
	window.addEventListener( 'resize', onWindowResize );

}
