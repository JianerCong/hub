import * as THREE from 'three';

import {OrbitControls} from 'three/examples/jsm/controls/OrbitControls';
import {GUI} from 'lil-gui';

import Stats from 'three/examples/jsm/libs/stats.module';
import {Water} from './my-water-cls';


function init() {
  const stats = new Stats();
  document.body.appendChild(stats.dom);
  // create a scene, that will hold all our elements such as objects, cameras and lights.
  const scene = new THREE.Scene();
  // create a camera, which defines where we're looking at.
  const camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
  // create a render and set the size
  const renderer = new THREE.WebGLRenderer();
  renderer.setClearColor(new THREE.Color(0x000000));
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.shadowMap.enabled = true;

  // create the ground plane --------------------------------------------------
  const planeGeometry = new THREE.PlaneGeometry(60, 20, 1, 1);
  const planeMaterial = new THREE.MeshLambertMaterial({ color: 0xffffff });
  const plane = new THREE.Mesh(planeGeometry, planeMaterial);
  plane.receiveShadow = true;
  // rotate and position the plane
  plane.rotation.x = -0.5 * Math.PI;
  plane.position.x = 15;
  plane.position.y = 0;
  plane.position.z = 0;
  // add the plane to the scene
  // scene.add(plane);















  // create a cube --------------------------------------------------
  const cubeGeometry = new THREE.BoxGeometry(4, 4, 4);
  const cubeMaterial = new THREE.MeshLambertMaterial({ color: 0xff0000 });
  const cube = new THREE.Mesh(cubeGeometry, cubeMaterial);
  cube.castShadow = true;
  // position the cube
  cube.position.x = -4;
  cube.position.y = 3;
  cube.position.z = 0;
  // add the cube to the scene
  scene.add(cube);

	// Load textures		
	var waterNormals = new THREE.TextureLoader().load('./public/waternormals.jpg');
	waterNormals.wrapS = waterNormals.wrapT = THREE.RepeatWrapping;
	// Add light
	var directionalLight = new THREE.DirectionalLight(0xffff55, 1);
	directionalLight.position.set(-600, 300, 600);
	scene.add(directionalLight);
	// Create the water effect
	let water = new Water(renderer, camera, scene, {
		textureWidth: 256,
		textureHeight: 256,
		waterNormals: waterNormals,
		alpha: 	0.8,
		sunDirection: directionalLight.position.normalize(),
		sunColor: 0xffffff,
		// waterColor: 0x001e0f,
		waterColor: 0x33aaff,
		betaVersion: 0,
		side: THREE.DoubleSide
	});
	var aMeshMirror = new THREE.Mesh(
		new THREE.PlaneGeometry(20000, 20000, 10, 10), 
		water.material
	);
	aMeshMirror.add(water);
	aMeshMirror.rotation.x = - Math.PI * 0.5;
	scene.add(aMeshMirror);




















  // position and point the camera to the center of the scene --------------------------------------------------
  camera.position.x = -30;
  camera.position.y = 40;
  camera.position.z = 30;
  camera.lookAt(scene.position);

  // add subtle ambient lighting
  const ambienLight = new THREE.AmbientLight(0x353535);
  scene.add(ambienLight);

  // add spotlight for the shadows
  const spotLight = new THREE.SpotLight(0xffffff);
  spotLight.position.set(-10, 20, -5);
  spotLight.castShadow = true;
  scene.add(spotLight);

  // add the output of the renderer to the html element
  document.getElementById("webgl-output").appendChild(renderer.domElement);

  // GUI --------------------------------------------------
  const controls = {
    rotationSpeed : 0.01,
  };
  const gui = new GUI();
  gui.add(controls, 'rotationSpeed', 0, 0.05,0.01);

  // orbit --------------------------------------------------
  const o = new OrbitControls(camera,renderer.domElement);


  // render --------------------------------------------------
  render();
  var step = 0;                 // use var to make it global
  function render() {
    // update the stats and the controls
    stats.update();

    water.render();
		water.material.uniforms.time.value += 1.0 / 60.0;

    // rotate the cube around its axes
    cube.rotation.x += controls.rotationSpeed;
    cube.rotation.y += controls.rotationSpeed;
    cube.rotation.z += controls.rotationSpeed;


    // render using requestAnimationFrame
    requestAnimationFrame(render);
    renderer.render(scene, camera);
  }
}

init();

