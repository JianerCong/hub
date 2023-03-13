import * as THREE from 'three';

import {OrbitControls} from 'three/examples/jsm/controls/OrbitControls';
import {GUI} from 'lil-gui';

import Stats from 'three/examples/jsm/libs/stats.module';

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

  // position and point the camera to the center of the scene
  camera.position.x = -30;
  camera.position.y = 40;
  camera.position.z = 30;
  camera.lookAt(scene.position);


  var geometry = new THREE.SphereGeometry(3000, 60, 40);  
  const loader = new THREE.TextureLoader;
  const texture = loader.load('./sky.jpeg');
  const material = new THREE.MeshPhongMaterial({color: 0xffffff});
  material.map = texture;
  const skyBox = new THREE.Mesh(geometry, material);  
  skyBox.scale.set(-1, 1, 1);  
  skyBox.eulerOrder = 'XZY';  
  skyBox.renderDepth = 1000.0;  
  scene.add(skyBox);  


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
    bouncingSpeed : 0.01,
  };
  const gui = new GUI();
  gui.add(controls, 'rotationSpeed', 0, 0.05,0.01);
  gui.add(controls, 'bouncingSpeed', 0, 0.05,0.01);

  // orbit --------------------------------------------------
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
