import TWEEN from './public/tween.esm.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import * as THREE from 'three';

async function establish_team(scene,g1,render){
  const geom = new THREE.SphereGeometry(2,8,8);
  const mat = new THREE.MeshPhongMaterial({color: 0x3333aa + 0x330033 * Math.random(),});

  let v0 = new THREE.Vector3();
  g1.children[0].getWorldPosition(v0);    // position of main submarine

  let ts = [];
  let balls = [];
  for (let sub of g1.children.slice(1)){
    let m = new THREE.Mesh(geom,mat);
    m.position.copy(v0);
    scene.add(m);
    // r,width-seg,height-seg

    // let sub = g1.children.slice(1)[0];
    let o = {t:0};
    const ms = 800;

    let v = new THREE.Vector3();
    sub.getWorldPosition(v);    // position of this small sub
    // animate
    let t = new TWEEN.Tween(o).to({t:1},ms)
        .repeat(3).yoyo(true)
        .onUpdate(()=>{
          m.position.lerpVectors(v0,v,o.t);
          render();
        });
    ts.push(t);

    balls.push(m);
  }
  await play_these(ts);
  balls.forEach((m) => m.removeFromParent());
}


const subtitle_transition_ms = 1000;

async function subtitle_on(para,ms=subtitle_transition_ms){
  // use tween
  let o = {opacity: 0};
  let fade_in = new TWEEN.Tween(o)
      .to({opacity:1},ms).onUpdate((obj)=>{
        para.style.opacity = `${obj.opacity}`;
      });
  return play_this(fade_in);
}

async function subtitle_off(para,ms=subtitle_transition_ms){
  // use tween
  let o = {opacity: 1};
  let fade_in = new TWEEN.Tween(o)
      .to({opacity:0},ms).onUpdate((obj)=>{
        para.style.opacity = `${obj.opacity}`;
      });
  return play_this(fade_in);
}


async function play_these(ts){
  return Promise.all(ts.map(play_this));
}

async function play_this(t){
  // console.log('play');
  return new Promise((resolve, reject) =>{
    t.start().onComplete(resolve);
  });
}


async function play_section(para,t,fn){
  para.textContent = t;
  await subtitle_on(para);
  await fn();
  await subtitle_off(para);
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

function add_helpers_orbit(camera, renderer, render,scene, L){
  // helpers
	const grid_helper = new THREE.GridHelper( L * 12, 12, 0xffffff, 0xffffff );
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

function initSea(scene){
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

function init_light(scene){
  // add subtle ambient lighting
  const ambienLight = new THREE.AmbientLight(0xffffff);
  scene.add(ambienLight);
  // add spotlight for the shadows
  const spotLight = new THREE.SpotLight(0xffffff);
  spotLight.position.set(0, 10000, 0);
  spotLight.castShadow = true;
  scene.add(spotLight);

}

import { Sky } from 'three/addons/objects/Sky.js';
function initSky(scene, renderer) {
	// Add Sky
	let sky = new Sky();
	sky.scale.setScalar( 450000 );
	scene.add( sky );

	let sun = new THREE.Vector3();
	const uniforms = sky.material.uniforms;
	const phi = THREE.MathUtils.degToRad( 90 - 0 );
	const theta = THREE.MathUtils.degToRad( -160);
	sun.setFromSphericalCoords( 1, phi, theta );
	uniforms[ 'sunPosition' ].value.copy( sun );
	renderer.toneMappingExposure =  renderer.toneMappingExposure;

  return {sky, sun};
}


function makeOnWindowResize(camera,renderer, render){
  return () => {
    let div = document.querySelector("#webgl-output");
    // console.log(div.getBoundingClientRect().width);
    // console.log(div.getBoundingClientRect().height);
    let w = div.getBoundingClientRect().width;
    let h = div.getBoundingClientRect().height;

	  camera.aspect = w / h;
	  camera.updateProjectionMatrix();

	  renderer.setSize( w, h );
	  render();
  };
}

import {OBJLoader} from 'three/examples/jsm/loaders/OBJLoader';
async function load_submarine(){
  let mat = new THREE.MeshPhongMaterial({color: 0x666666});

  // use model --------------------------------------------------
  let l = new OBJLoader();
  let m = await l.loadAsync('./public/submarine.obj');
  let s = 2;
  m.scale.set(s,s,s);
  // m.translate()
  visitChildren(m, (ch) => {ch.recieveShadow = true; ch.castShadow = true; ch.material = mat;});

  // DEBUG: use cube --------------------------------------------------
  // let  n = 10;
  // const geom = new THREE.BoxGeometry(n,n,n);
  // let m = new THREE.Mesh(geom, mat);
  return m;
}

import Stats from 'three/examples/jsm/libs/stats.module';
function setup_stats(onRenders){
  let stats = new Stats();
  onRenders.push(()=>{stats.update();});
  document.body.appendChild(stats.dom);

}

function setup_defaults(id="three-output"){
  let div = document.querySelector("#webgl-output");
  let w = div.getBoundingClientRect().width;
  let h = div.getBoundingClientRect().height;
  // console.log(`w=${w},h=${h}`);

  /* aspect ratio, near, far */
	let camera = new THREE.PerspectiveCamera( 60, w/h, 0.1, 2000 );
	let scene = new THREE.Scene();
  // render setting and add to
	let renderer = new THREE.WebGLRenderer();
	renderer.setPixelRatio( window.devicePixelRatio );
	renderer.outputEncoding = THREE.sRGBEncoding;
	renderer.toneMapping = THREE.ACESFilmicToneMapping;
	renderer.toneMappingExposure = 0.5;
	// document.body.appendChild( renderer.domElement );

  // Out of the region, it will be cropped.
	// renderer.setSize( window.innerWidth, window.innerHeight);
	renderer.setSize(w,h);
  let dom = renderer.domElement;
  // console.log(dom);
  dom.id = id;
  div.appendChild(dom);
  return {camera, scene, renderer};
}


function register_to_button(n,init_fn,){
  let b = document.querySelector(`#my-button-${n}`);
  b.addEventListener("click", () => {
    let b = document.querySelector("#three-output");
    if (b) {
      let s = document.querySelector("#subtitle");
      s.remove();
      console.log('Removing existing scene');
      b.remove();
    }
    console.log(`Playing scene ${n}`);
    init_fn();
  });
}

export {establish_team, subtitle_on, subtitle_off,
        play_this, play_these, play_section,visitChildren,

        initSea,

        add_helpers_orbit,
        init_light,
        initSky,
        makeOnWindowResize,
        load_submarine,
        setup_stats,
        setup_defaults,
        register_to_button
       }
