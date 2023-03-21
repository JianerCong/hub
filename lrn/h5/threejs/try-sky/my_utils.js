import TWEEN from './public/tween.esm.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import * as THREE from 'three';

// async function establish_team_old(scene,main_sub, small_subs,render){
//   // const geom = new THREE.SphereGeometry(2,8,8);
//   const mat = new THREE.MeshPhongMaterial({color:
//                                            0xaa0000
//                                            + 0x00ffff * Math.random() * 0.3
//                                            ,});

//   let v0 = new THREE.Vector3();
//   main_sub.getWorldPosition(v0);    // position of main submarine

//   let ts = [];
//   let balls = [];
//   for (let sub of small_subs){
//     // let m = new THREE.Mesh(geom,mat);
//     // m.position.copy(v0);
//     // scene.add(m);
//     // r,width-seg,height-seg

//     // let sub = g1.children.slice(1)[0];
//     let o = {t:0};
//     const ms = 800;

//     let v = new THREE.Vector3();
//     sub.getWorldPosition(v);    // position of this small sub

//     // // animate
//     // let t = new TWEEN.Tween(o).to({t:1},ms)
//     //     .repeat(3).yoyo(true)
//     //     .onUpdate(()=>{
//     //       m.position.lerpVectors(v0,v,o.t);
//     //       render();
//     //     });
//     // ts.push(t);

//     // balls.push(m);
//   }

//   // await play_these(ts);
//   // balls.forEach((m) => m.removeFromParent());
// }

async function establish_team(scene,main_sub, small_subs,render,fade_out=true){

  const mat = new THREE.MeshPhongMaterial({color:
                                           0x3333ff,
                                           // + 0x00ffff * Math.random() * 0.3,
                                           opacity: 0,
                                           blending: THREE.AdditiveBlending,
                                           emissive: 0xffffff,
                                           emissiveIntensity:0,
                                           });
  let v0 = new THREE.Vector3();
  main_sub.getWorldPosition(v0);    // position of main submarine

  let fades = [];
  let fades_fn = [];

  let ts = [];
  let tubes = [];
  for (let sub of small_subs){
    // let sub = g1.children.slice(1)[0];
    let o = {t:0};
    const ms = 800;

    let v = new THREE.Vector3();
    sub.getWorldPosition(v);    // position of this small sub
    let tube_geom = new THREE.TubeGeometry(
      new THREE.LineCurve3(v0,v),
      1,                       // tabular segment
      1,                        // radius
    );

    let tube = new THREE.Mesh(tube_geom,mat);
    let t = new TWEEN.Tween(tube.material).to({emissiveIntensity:1,opacity:1},500).repeat(4).yoyo(true);

    // fade out
    if (fade_out){
      fades.push(new TWEEN.Tween(tube.material).to({emissiveIntensity:0,opacity:0},500));
      fades_fn.push(()=> tube.removeFromParent());
    }

    scene.add(tube);
    ts.push(t);
    tubes.push(tube);
  }

  // the nearby submarines
  // console.log(small_subs);
  let m = [1,3,0,2];            // the entries to connect
  for (let i = 0;i < m.length; i++){
    let i_next = m[i];

    // console.log(`\ni_next: ${i_next}`);
    // console.log(small_subs[i].position);
    // console.log(small_subs[i_next].position);

    let v = new THREE.Vector3();
    small_subs[i].getWorldPosition(v);    // position of this small sub
    let v1 = new THREE.Vector3();
    small_subs[i_next].getWorldPosition(v1);    // position of this small sub

    let tube_geom = new THREE.TubeGeometry(
      new THREE.LineCurve3(v,v1),
      1,                       // tabular segment
      1,                        // radius
    );
    let tube = new THREE.Mesh(tube_geom,mat);
    let t = new TWEEN.Tween(tube.material).to({emissiveIntensity:1,opacity:1},500).repeat(4).yoyo(true);

    // fade out
    if (fade_out){
      fades.push(new TWEEN.Tween(tube.material).to({emissiveIntensity:0,opacity:0},500));
      fades_fn.push(()=> tube.removeFromParent());
    }

    scene.add(tube);
    ts.push(t);
    tubes.push(tube);
  }

  await play_these(ts);
  if (fade_out) {
    await play_these(fades, fades_fn);
  }

  // return  these tubes, can be deleted
  return tubes;
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


async function play_these(ts,fns=null){
  // fns: onComplete functions.
  // console.log(`play_these called,fns is ${fns}`);
  if (fns){
    return Promise.all(ts.map((e,i) => play_this(e,fns[i])));
  }else{
    // console.log('no fns supplied');
    return Promise.all(ts.map((e,i) => play_this(e))); // by default, i is passed to play_this's second arg
}
}

async function play_this(t, fn=null){
  // console.log(`play with fn=${fn}`);
  if (fn){
    return new Promise((resolve, reject) =>{
      t.start().onComplete(()=>{
        fn();
        resolve();
      });
    });
  }else{
    // console.log('no fn supplied');
    return new Promise((resolve, reject) =>{
      t.start().onComplete(resolve);
    });
}
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
  // console.log('sea initialized');
  let n = 500;
  const g = new THREE.CylinderGeometry(n,n,n);
  // const m = new THREE.MeshBasicMaterial({
  // const m = new THREE.MeshPhysicalMaterial({
  const m = new THREE.MeshToonMaterial({
    color: 0x00211a,
    opacity: 0.7,
    transparent:true,
    side: THREE.DoubleSide,
    // blending: THREE.AdditiveBlending,
    // blending: THREE.MultiplyBlending,
    // depth: THREE.AlwaysDepth
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

async function load_satellite(H,scene){
  let mat = new THREE.MeshPhongMaterial({color: 0x666666});

  // use model --------------------------------------------------
  let l = new OBJLoader();
  let m = await l.loadAsync('./public/satellite.obj');
  let s = 0.5;
  m.scale.set(s,s,s);
  visitChildren(m, (ch) => {ch.recieveShadow = true; ch.castShadow = true; ch.material = mat;});

  // DEBUG: use cube --------------------------------------------------
  // let  n = 10;
  // const geom = new THREE.BoxGeometry(n,n,n);
  // let m = new THREE.Mesh(geom, mat);
  m.rotateY(Math.PI);
  m.position.set(0,0,s*260);


  // A group for translating the origin
  const g = new THREE.Group();
  g.add(m);

  g.position.set(0,H,0);
  // g.rotateX(-Math.PI*0.5);

  let t = new TWEEN.Tween(g.rotation).to({z:Math.PI*2},10000).repeat(Infinity).start();
  let t2 = new TWEEN.Tween(g.rotation).to({y:Math.PI*2},20000).repeat(Infinity).start();
  let t3 = new TWEEN.Tween(g.rotation).to({x:Math.PI*2},40000).repeat(Infinity).start();
  scene.add(g);

  return g;
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

async function make_signals(small_submarines,scene,ms=1000,repeat=2,DELAY=500){
  const g = new THREE.TorusGeometry(10,1,10,50);
  // radius,tube r_sag, t_sag, arc

  // // create a small donut around a submarine
  // let sub = small_submarines[0];

  // animate
  const N = 10;
  // let t = new TWEEN.Tween(s.scale).to({x:N,y:N},ms).repeat(3);
  // await play_this(t);
  // s.removeFromParent();
  let ts = [];
  for (let sub of small_submarines){
    const m = new THREE.MeshPhongMaterial({
      color: 0xffffff * Math.random(),
      opacity: 0.5,
      blending: THREE.AdditiveBlending,
      emissive: 0xaaaaaa,
    });
    let s0 = new THREE.Mesh(g,m);  // signal
    s0.rotateX(0.5*Math.PI);

    let v = new THREE.Vector3;
    sub.getWorldPosition(v);
    s0.position.copy(v);

    scene.add(s0);

    // animate
    let t = new TWEEN.Tween(s0.scale).to({x:N,y:N},ms)
        .repeat(repeat)
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


async function get_signals(scene,v0,v1,ms=1000,N=3){
  console.log('getting signals');
  const g = new THREE.TorusGeometry(10,1,10,6,Math.PI);
  // radius,tube r_sag, t_sag, arc
  const m = new THREE.MeshLambertMaterial({
    color: 0xaa330a,
    opacity: 0.7,
    // transparent: true
    emissive: 0xffffff,
    // needsUpdate:true,
  });
  let s = new THREE.Mesh(g,m);  // signal

  s.position.copy(v0);            // move to the satellite position
  s.lookAt(v1);                   // look at the v1 position
  s.rotateY(Math.PI/2);
  s.rotateZ(Math.PI/2);


    let fns = [];
    let ts = [];
    // Create the signal mesh
    for (let i = 0; i < N;i++){
      // --------------------------------------------------
      let s0 = s.clone();

      s0.material.color = new THREE.Color(0xffffff * Math.random());

      let t = new TWEEN.Tween(s0.position).to(v1,ms).repeat(2);
      let d = i*ms/N;

      // scene.add(s0);
      // scene.add(s2);
      t.onStart(()=>{scene.add(s0);});
      t.delay(d).repeatDelay(0);

      ts.push(t);
      fns.push(() => {s0.removeFromParent();});
  }
  return {ts,fns};
}

async function recieve_signals_from_sat(X,scene){
  const L = 50;
  const H = 4* L;

  const v0 = new THREE.Vector3(0,H,0);
  const v1 = new THREE.Vector3(X,0,0);
  const v2 = new THREE.Vector3(-X,0,0);

  let o1 = await get_signals(scene,v0,v1);
  let o2 = await get_signals(scene,v0,v2);
  let ts = o1.ts.concat(o2.ts);
  let fns = o1.fns.concat(o2.fns);
  // console.log(ts);
  await play_these(ts,fns);

}


export {
  establish_team, subtitle_on, subtitle_off,
        play_this, play_these, play_section,visitChildren,

        initSea,

        add_helpers_orbit,
        init_light,
        initSky,
        makeOnWindowResize,
        load_submarine,
        load_satellite,
        setup_stats,
        setup_defaults,
        register_to_button,

        make_signals,
        recieve_signals_from_sat,
  get_signals,
       }
