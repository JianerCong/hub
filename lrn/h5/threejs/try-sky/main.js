console.log('main.js loaded');
import * as THREE from 'three';
import './style.css';

import { GUI } from 'three/addons/libs/lil-gui.module.min.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { Sky } from 'three/addons/objects/Sky.js';
import {OBJLoader} from 'three/examples/jsm/loaders/OBJLoader';
import Stats from 'three/examples/jsm/libs/stats.module';
import TWEEN from './public/tween.esm.js';

let camera, scene, renderer, stats;
let sky, sun;
let onRenders = [];
const L = 50;

init();

async function init() {
  // setup_stats();
  setup_defaults();

  init_light();
	let sky = initSky();
  initSea();
  let {g1,g2} = await get_submarines();

  add_helpers_orbit();
  // configGUI(new GUI(),sky);
	window.addEventListener( 'resize', onWindowResize );
  render();

  await start_movie({g1,g2});
}

function animate(time) {
	requestAnimationFrame(animate);
	TWEEN.update(time);
  render();
}


async function start_movie({g1,g2}){
	requestAnimationFrame(animate);
  console.log('Movie started');
  // console.log(g1);

  // subtitle
  const subtitle_transition_ms = 1000;
  const cav = document.querySelector('#webgl-output');
  // console.log('The canvas');
  // console.log(cav);
  let para = document.createElement('p');
  para.id = "subtitle";
  cav.appendChild(para);

  // move little subs--------------------------------------------------
  let small_submarines = g1.children.slice(1).concat(g2.children.slice(1));
  // console.log('小潜艇群');
  // console.log(small_submarines);

  await play_section('1.中继器通过卫星受到组队命令',async () => await recieve_signals());
  await play_section('2.p2p身份认证，通过后入网并共识',async () => await make_signals(small_submarines));
  await play_section('3.执行组队命令',async () => await move_small_submarines(small_submarines));

  para.textContent = '4.完成组队';
  await subtitle_on(para);
  await Promise.all([establish_team(g1), establish_team(g2)]);
  // await subtitle_off(para);

  console.log('done');

  async function establish_team(g1){
    const geom = new THREE.SphereGeometry(2,8,8);
    const mat = new THREE.MeshPhongMaterial({color: 0x3333ff * Math.random(),});

    let v0 = new THREE.Vector3();
    g1.children[0].getWorldPosition(v0);    // position of main submarine

    let ts = [];
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
    }
    await play_these(ts);
}

  async function make_signals(small_submarines){
    const g = new THREE.TorusGeometry(10,1,10,50);
    // radius,tube r_sag, t_sag, arc

    // // create a small donut around a submarine
    // let sub = small_submarines[0];

    // animate
    const N = 10;
    const ms = 1000;
    const DELAY = 500;
    // let t = new TWEEN.Tween(s.scale).to({x:N,y:N},ms).repeat(3);
    // await play_this(t);
    // s.removeFromParent();
    let ts = [];
    for (let sub of small_submarines){
      const m = new THREE.MeshPhongMaterial({color: 0x3333ff * Math.random(),});
      let s0 = new THREE.Mesh(g,m);  // signal
      s0.rotateX(0.5*Math.PI);

      let v = new THREE.Vector3;
      sub.getWorldPosition(v);
      s0.position.copy(v);

      scene.add(s0);

      // animate
      let t = new TWEEN.Tween(s0.scale).to({x:N,y:N},ms)
          .repeat(3)
          .delay(DELAY*Math.random())
        .easing(TWEEN.Easing.Quadratic.InOut);
      ts.push(
        new Promise((res, rej)=>{
          t.start().onComplete(
            () => {
              s0.removeFromParent();
              res();
            }
          );
        }));
    }
    return Promise.all(ts);
}

  async function play_section(t,fn){
    para.textContent = t;
    await subtitle_on(para);
    await fn();
    await subtitle_off(para);
  }

  async function recieve_signals(){
    // Create the signal mesh
    const g = new THREE.TorusGeometry(10,1,10,6,Math.PI);
    // radius,tube r_sag, t_sag, arc
    const m = new THREE.MeshLambertMaterial({
      color: 0xaa330a,
      opacity: 0.7,
      transparent: true
    });
    let s = new THREE.Mesh(g,m);  // signal
    s.translateY(3*L);            // move to sky
    s.rotateZ(Math.PI);

    let s2 = s.clone();           // right signal

    s.translateX(-2*L);
    s2.translateX(2*L);

    scene.add(s);
    scene.add(s2);


    let ms = 500;
    let t = new TWEEN.Tween(s.position).to({y:10},ms).repeat(3);
    let t2 = new TWEEN.Tween(s2.position).to({y:10},ms).repeat(3);
    await play_these([t,t2]);
    s.removeFromParent();
    s2.removeFromParent();
}

  async function move_small_submarines(small_submarines){

    let ani_small_submarines = [];
    let ms = 5000;
    for (let s of small_submarines){
      // console.log(s);
      ani_small_submarines.push(new TWEEN.Tween(s.position)
                                .to({x: s.userData.myX, y: s.userData.myY, z: s.userData.myZ,},ms)
                                .easing(TWEEN.Easing.Quadratic.Out));
      ani_small_submarines.push(new TWEEN.Tween(s.rotation)
                                .to({y: 0},ms)
                                .easing(TWEEN.Easing.Quadratic.Out));
    }
    await play_these(ani_small_submarines);
}

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
}

async function get_submarine_group(){
  const g = new THREE.Group();
  // console.log(`Adding submarines`);
  let s = 1.2;                    // the scale of smaller submarine
  let m = await load_submarine();
  m.name = '主潜艇';
  g.add(m);

  // let submarines = [m];
  // Method 1: just clone --------------------------------------------------
  let n = 1;
  for (let i of [-1,1]){
    for (let j of [-1,1]){
      let m1 = m.clone();
      m1.translateX(i*L);
      m1.translateZ(j*L);
      m1.translateY(-L);

      // store the right values
      m1.userData.myX = m1.position.x;
      m1.userData.myY = m1.position.y;
      m1.userData.myZ = m1.position.z;

      let random_amount = 0.5*L;
      // Add some randomness to position
      m1.position.addScaledVector(
        new THREE.Vector3(
          Math.random(),
          Math.random(),
          Math.random(),
        ),
        L
      );
      m1.rotation.y = Math.PI * Math.random();

      m1.name = `小潜艇`;
      // submarines.push(m1);
      m1.scale.set(s,s,s);
      g.add(m1);
      n++;
    }
  }
  return g;

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
}

// Out of the region, it will be cropped.
async function get_submarines(){
  let g1 = await get_submarine_group();
  g1.translateX(-2*L);
  g1.name = '潜艇1群';
  let g2 = g1.clone();
  g2.translateX(4*L);
  g1.name = '潜艇2群';

  scene.add(g1);
  scene.add(g2);
  // console.log(g1);
  return {g1,g2};

}


function setup_stats(){
  stats = new Stats();
  onRenders.push(()=>{stats.update();});
  document.body.appendChild(stats.dom);

}
function initSky() {
	// Add Sky
	sky = new Sky();
	sky.scale.setScalar( 450000 );
	scene.add( sky );

	sun = new THREE.Vector3();
	const uniforms = sky.material.uniforms;
	const phi = THREE.MathUtils.degToRad( 90 - 0 );
	const theta = THREE.MathUtils.degToRad( -160);
	sun.setFromSphericalCoords( 1, phi, theta );
	uniforms[ 'sunPosition' ].value.copy( sun );
	renderer.toneMappingExposure =  renderer.toneMappingExposure;

  return sky;
}

function initSun() {
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

  let div = document.querySelector("#webgl-output");
  // console.log(div.getBoundingClientRect().width);
  // console.log(div.getBoundingClientRect().height);
  let w = div.getBoundingClientRect().width;
  let h = div.getBoundingClientRect().height;

	camera.aspect = w / h;
	camera.updateProjectionMatrix();

	renderer.setSize( w, h );
	render();
}

function render() {
	renderer.render( scene, camera );
  for (let fn of onRenders){
    fn();
}
}
function setup_defaults(){
  let div = document.querySelector("#webgl-output");
  let w = div.getBoundingClientRect().width;
  let h = div.getBoundingClientRect().height;
  // console.log(`w=${w},h=${h}`);

  /* aspect ratio, near, far */
	camera = new THREE.PerspectiveCamera( 60, w/h, 0.1, 2000 );
	camera.position.set( 150, 160, 300 );/* x,y,z  (left, up, front)*/
	scene = new THREE.Scene();
  // render setting and add to
	renderer = new THREE.WebGLRenderer();
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
  dom.id = "three-output";
  div.appendChild(dom);
}

function add_helpers_orbit(){
  // helpers
	// const grid_helper = new THREE.GridHelper( 300, 6, 0xffffff, 0xffffff );
	// scene.add( grid_helper );
  // const axes_helper = new THREE.AxesHelper(50);
	// scene.add( axes_helper );
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
