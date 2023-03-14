console.log('main.js loaded');
import * as THREE from 'three';

import { GUI } from 'three/addons/libs/lil-gui.module.min.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { Sky } from 'three/addons/objects/Sky.js';
import {OBJLoader} from 'three/examples/jsm/loaders/OBJLoader';
import Stats from 'three/examples/jsm/libs/stats.module';

let camera, scene, renderer, stats;
let sky, sun;
let functionsToRender = [];

init();

async function init() {
  setup_stats();
  setup_defaults();

  init_light();
	let sky = initSky();
  initSea();
  let submarines = await get_submarines();

  add_helpers_orbit();
  setup_selector(submarines);
  const gui = new GUI();
  configGUI(gui,sky);
	window.addEventListener( 'resize', onWindowResize );

  render();
}

async function get_submarines(){
  const g = new THREE.Group();
  console.log(`Adding submarines`);
  let L = 50;
  let s = 1.2;                    // the scale of smaller submarine
  let m = await load_submarine();
  m.name = '主潜艇';
  g.add(m);

  let submarines = [m];
  // Method 1: just clone --------------------------------------------------
  let n = 1;
  for (let i of [-1,1]){
    for (let j of [-1,1]){
      let m1 = m.clone();
      m1.position.set(i*L,0,j*L);
      m1.name = `小潜艇${n}号`;
      submarines.push(m1);
      m1.scale.set(s,s,s);
      g.add(m1);
      n++;
    }
  }
  g.name = '潜艇group';

  scene.add(g);
  console.log(g);
  return g.children;
  // [BETA] Method 2: instanced-mesh --------------------------------------------------
  // const m2 = new THREE.InstancedMesh(m.geometry, m.material,4);
  // let count = 0;
  // for (let i of [-1,1]){
  //   for (let j of [-1,1]){
  //     const matrix = new THREE.Matrix4();
  //     matrix.makeTranslation(i*L,0,j*L);
  //     m2.setMatrixAt(count,matrix);
  //     count += 1;
  //   }
  // }
  // scene.add(m2);

  async function load_submarine(){
    let mat = new THREE.MeshPhongMaterial({color: 0x666666});

    // use model --------------------------------------------------
    // let l = new OBJLoader();
    // let m = await l.loadAsync('./public/submarine.obj');
    // let s = 2;
    // m.scale.set(s,s,s);
    // // m.translate()
    // visitChildren(m, (ch) => {ch.recieveShadow = true; ch.castShadow = true; ch.material = mat;});

    // DEBUG: use cube --------------------------------------------------
    let  n = 10;
    const geom = new THREE.BoxGeometry(n,n,n);
    let m = new THREE.Mesh(geom, mat);

    return m;
  }
}

let pointer,raycaster, intersects;
let intersected = null;
function setup_selector(objs){
  // let objs = scene.getObjectByName('group').children;
  // console.log(`setting up selector for ${JSON.stringify(objs[0])}`);
  console.log(objs);
  raycaster = new THREE.Raycaster();

  pointer = {x: -1, y: -1};
  document.addEventListener('click', (event) => {
    console.log('.');
    pointer.x = (event.clientX / window.innerWidth) * 2 - 1;
    pointer.y = -(event.clientY / window.innerHeight) * 2 + 1;
    render();
  });

  functionsToRender.push(()=>{
    if (raycaster) {
      // console.log(`got raycaster`);
      raycaster.setFromCamera(pointer, camera);
      intersects = raycaster.intersectObjects(objs,false);
      if (intersects.length > 0) {
        console.log(intersects[0].object.name);
      }
    }
  });
}

function setup_stats(){
  stats = new Stats();
  functionsToRender.push(()=>{stats.update();});
  document.body.appendChild(stats.dom);
}
function initSky() {
	// Add Sky
	sky = new Sky();
	sky.scale.setScalar( 450000 );
	scene.add( sky );

	sun = new THREE.Vector3();

  return sky;
}

function configGUI(gui,sky){
  /// GUI
  const effectController = {
	  elevation: 2,
	  azimuth: -160,
	  exposure: renderer.toneMappingExposure
  };

	function guiChanged() {
		const uniforms = sky.material.uniforms;
		const phi = THREE.MathUtils.degToRad( 90 - effectController.elevation );
		const theta = THREE.MathUtils.degToRad( effectController.azimuth );
		sun.setFromSphericalCoords( 1, phi, theta );
		uniforms[ 'sunPosition' ].value.copy( sun );

		renderer.toneMappingExposure = effectController.exposure;
    render();
	}
	gui.add( effectController, 'elevation', 0, 90, 0.1 ).onChange( guiChanged );
	gui.add( effectController, 'azimuth', - 180, 180, 0.1 ).onChange( guiChanged );
	gui.add( effectController, 'exposure', 0, 1, 0.0001 ).onChange( guiChanged );
	guiChanged();
}

function initSea(){
  console.log('sea initialized');
  let n = 500;
  const g = new THREE.CylinderGeometry(n,n,n);
  // const m = new THREE.MeshBasicMaterial({
  // const m = new THREE.MeshPhysicalMaterial({
  const m = new THREE.MeshToonMaterial({
    color: 0x001e0f,
    opacity: 0.5,
    transparent:true,
    side: THREE.DoubleSide,
  });

  const sea = new THREE.Mesh(g,m);
  sea.position.y = -n/2;
  // sea.rotation.set(Math.PI/-2, 0 ,0);
  scene.add(sea);
}

function init_light(){
  // add subtle ambient lighting
  const ambienLight = new THREE.AmbientLight(0xffffff);
  scene.add(ambienLight);
  // add spotlight for the shadows
  const spotLight = new THREE.SpotLight(0xffffff);
  spotLight.position.set(0, 10000, 0);
  spotLight.castShadow = true;
  scene.add(spotLight);

}

function onWindowResize() {
	camera.aspect = window.innerWidth / window.innerHeight;
	camera.updateProjectionMatrix();

	renderer.setSize( 0.1 * window.innerWidth, 0.1* window.innerHeight );
	render();
}
function render() {
	renderer.render( scene, camera );
  for (let fn of functionsToRender){
    fn();
}
}
function setup_defaults(){
  /* aspect ratio, near, far */
	camera = new THREE.PerspectiveCamera( 60, window.innerWidth / window.innerHeight, 0.1, 2000 );
	camera.position.set( 0, 100, 200 );/* x,y,z  (left, up, front)*/
	scene = new THREE.Scene();
  // render setting and add to
	renderer = new THREE.WebGLRenderer();
	renderer.setPixelRatio( window.devicePixelRatio );
	renderer.setSize( window.innerWidth, window.innerHeight );
	renderer.outputEncoding = THREE.sRGBEncoding;
	renderer.toneMapping = THREE.ACESFilmicToneMapping;
	renderer.toneMappingExposure = 0.5;
	document.body.appendChild( renderer.domElement );
}

function add_helpers_orbit(){
  // helpers
	const grid_helper = new THREE.GridHelper( 100, 4, 0xffffff, 0xffffff );
	scene.add( grid_helper );
  const axes_helper = new THREE.AxesHelper(50);
	scene.add( axes_helper );
  /* listen to 'change */
	const controls = new OrbitControls( camera, renderer.domElement );
	controls.addEventListener( 'change', render );
	controls.maxPolarAngle = Math.PI / 2; // cannot look from bottom up
	controls.enableZoom = false;
	controls.enablePan = false;
}

function visitChildren(object, fn){
  if (object.children && object.children.length > 0) {
    for (const child of object.children) {
      visitChildren(child, fn);
    }
  } else {
    fn(object);
  }
}
