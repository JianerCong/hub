import * as THREE from 'three';

import {OrbitControls} from 'three/examples/jsm/controls/OrbitControls';
import {GUI} from 'lil-gui';
import Stats from 'three/examples/jsm/libs/stats.module';
import {OBJLoader} from 'three/examples/jsm/loaders/OBJLoader';
import {visitChildren} from './utils';

let stats, scene, camera, renderer;

function setup_defaults(){
  stats = new Stats();
  document.body.appendChild(stats.dom);
  // create a scene, that will hold all our elements such as objects, cameras and lights.
  scene = new THREE.Scene();
  // create a camera, which defines where we're looking at.
  camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
  // create a render and set the size
  renderer = new THREE.WebGLRenderer();
  renderer.setClearColor(new THREE.Color(0x000000));
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.shadowMap.enabled = true;

  // position and point the camera to the center of the scene --------------------------------------------------
  camera.position.x = -30;
  camera.position.y = 40;
  camera.position.z = 30;
  camera.lookAt(scene.position);

}

function init_plane(){
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
  scene.add(plane);
}

function init_cube(){
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
  return cube;
}

function init_light(){
  // add subtle ambient lighting
  const ambienLight = new THREE.AmbientLight(0x353535);
  scene.add(ambienLight);
  // add spotlight for the shadows
  const spotLight = new THREE.SpotLight(0xffffff);
  spotLight.position.set(-10, 20, -5);
  spotLight.castShadow = true;
  scene.add(spotLight);
}


async function load_submarine(){
  let mat = new THREE.MeshPhongMaterial({color: 0xaaaaaa});
  let l = new OBJLoader();

  let m = await l.loadAsync('./public/submarine.obj');
  let s = 1;
  m.scale.set(s,s,s);
  // m.translate()
  visitChildren(m, (ch) => {
    ch.recieveShadow = true;
    ch.castShadow = true;
    ch.material = mat;
  }
               );
  scene.add(m);
}

function init() {
  setup_defaults();




  init_plane();
  init_light();
  load_submarine();




  // add the output of the renderer to the html element
  document.getElementById("webgl-output").appendChild(renderer.domElement);
  // GUI --------------------------------------------------
  const controls = {rotationSpeed : 0.01,};
  const gui = new GUI();
  gui.add(controls, 'rotationSpeed', 0, 0.05,0.01);
  const o = new OrbitControls(camera,renderer.domElement);

  // render --------------------------------------------------
  render();
  var step = 0;                 // use var to make it global
  function render() {
    // update the stats and the controls
    stats.update();

    // render using requestAnimationFrame
    requestAnimationFrame(render);
    renderer.render(scene, camera);
  }
}

init();
