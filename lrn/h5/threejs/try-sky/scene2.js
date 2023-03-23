console.log('scene2 loaded');
import * as THREE from 'three';

import { GUI } from 'three/addons/libs/lil-gui.module.min.js';
import TWEEN from './public/tween.esm.js';
import {establish_team,
        subtitle_on, subtitle_off, play_this,
        play_these, play_section,
        visitChildren,
        initSea,

        add_helpers_orbit,
        init_light,
        initSky,
        makeOnWindowResize,

        load_relay,
        load_submarine,

        setup_stats,
        setup_defaults,

        register_to_button,
       } from './my_utils.js';

let camera, scene, renderer;
let onRenders = [];
const L = 25;

register_to_button(2,init);
// init();
// for now, we play scene 2 by default, comment out the above line on export.
// Maybe it's more reasonable to play scene 1 on launch.

//// the following is refactored into above function
// let b = document.querySelector("#my-button-2");
// b.addEventListener("click", () => {
//   let b = document.querySelector("#three-output");
//   if (b) {
//     let s = document.querySelector("#subtitle");
//     s.remove();
//     console.log('Removing existing scene');
//     b.remove();
//   }
//   console.log("Playing scene 2");
//   init();
// });

async function init() {
  // setup_stats(onRenders);
  let o = setup_defaults();
  camera = o.camera; scene = o.scene; renderer = o.renderer;
	camera.position.set( 0, 100, 200 );/* x,y,z  (left, up, front)*/
	// camera.position.set( 0, 500, 0 );/* x,y,z  (left, up, front)*/
	// camera.position.set( 0, 0, 300 );/* x,y,z  (left, up, front)*/

  init_light(scene);
	let {sky,sun} = initSky(scene, renderer);
  initSea(scene, renderer, camera ,onRenders);
  let g1 = await get_submarines();

  add_helpers_orbit(camera, renderer, render,scene, L);
	window.addEventListener( 'resize',makeOnWindowResize(camera,renderer, render));
  render();

  await start_movie(g1);
}


async function start_movie(g1){
	requestAnimationFrame(animate);
  console.log('Movie started');
  // console.log(g1);

  // subtitle
  const cav = document.querySelector('#webgl-output');
  // console.log('The canvas');
  // console.log(cav);
  let para = document.createElement('p');
  para.id = "subtitle";
  cav.appendChild(para);

  para.textContent = '1.组队已经完成，准备接受指令';
  await subtitle_on(para);
  await establish_team(scene,g1.children[0],g1.children.slice(1),render);
  await subtitle_off(para);

  await play_section(para, '2.中继点收到任务指令及地点',
                     async () =>
                      get_destination(g1)
                    );

  await play_section(para,
                     '3.中继点被分配为导航角色并执行导航',
                     async () =>
                     navigate_there(g1)
                    );

  para.textContent = '4.到达任务执行地，中继点分配任务角色';
  await subtitle_on(para);
  await establish_team(scene,g1.children[0],g1.children.slice(1),render);
  await distribute_task(g1);
  await subtitle_off(para);

  para.textContent = '5.任务角色分配完毕，开始执行任务';
  await subtitle_on(para);
  await start_task(g1);
  await subtitle_off(para);

  console.log('done');

}

async function start_task(g1){
  let ts = [];
  for (let sub of g1.children.slice(1)){
    // console.log(sub.rotation);
    let dv = new THREE.Vector3();
    let R = 0.8 * L * Math.random(); // distance to move
    dv.setFromCylindricalCoords(R,sub.userData.a,0);
    let v0 = sub.position.clone(); // destination
    v0.add(dv);

    let t = new TWEEN.Tween(sub.position).to({
      x:v0.x,
      y:v0.y,
      z:v0.z,
    },1500);
    ts.push(t);
  }
  await play_these(ts);
}

async function distribute_task(g1){
  let ts = [];
  for (let [i,sub] of g1.children.slice(1).entries()){
    let theta = Math.PI * Math.random() * 0.5; // a random accute angle

    let v = new THREE.Vector3(); // position of this submarine
    sub.getWorldPosition(v);

    let a;                      // angle to change
    if (i == 0){
      a = -Math.PI/2 - theta;
    }else if (i == 1){
      a = -theta;
    } else if (i == 2){
      a = -2* Math.PI + Math.PI/2 + theta; // make it rotate smaller
    }else if (i == 3){
      a = theta;
    } else {
      throw new Error("Error");
    }
    // console.log(sub.rotation);

    let t = new TWEEN.Tween(sub.rotation).to({y: a},2000);
    ts.push(t);
    sub.userData.a = a;
  }
  await play_these(ts);
}

// import { TransformControls } from 'three/examples/jsm/controls/TransformControls';

async function navigate_there(g1){
  let ms = 2000;

  let ts = [];
  for (let sub of g1.children){
    let t = new TWEEN.Tween(sub.rotation)
        .to({y:-0.5*Math.PI},ms)
        .easing(TWEEN.Easing.Quadratic.InOut)
        .delay(0.5 * ms * Math.random())
    ;
    ts.push(t);
  }
  await play_these(ts);

  ts = [];


  ms = 8000;
  let t = new TWEEN.Tween(g1.position)
      .to({x: -4*L},ms)
      .easing(TWEEN.Easing.Quadratic.InOut);
  ts.push(t);

  let o = {t:0};

  for (let sub of g1.children.slice(1)){
    sub.userData.oldY = sub.position.y;
    // console.log(sub.position);
    const A = 0.5*L;
    const n = 2;

    let t = new TWEEN.Tween(o)
        .to({t:1},ms)
        .onUpdate(function(o){
          // sub.position.x = sub.userData.oldX + o.t*l;
          sub.position.y = sub.userData.oldY + A*Math.sin(2*Math.PI*o.t*n);
        }).delay(0.1*ms*Math.random())
        .easing(TWEEN.Easing.Quadratic.InOut);
    ;
    // const controls = new TransformControls(camera, renderer.domElement);
    // controls.attach(sub);
    // scene.add(controls);
    // play_this(t);

    ts.push(t);
  }
  await play_these(ts);
}

// async function get_destination(g1){
//   let dest = -4*L;

//   // add a small ball m
//   const geom = new THREE.SphereGeometry(2,8,8);
//   const mat = new THREE.MeshPhongMaterial({color: 0xff2211});
//   let m = new THREE.Mesh(geom,mat); // small ball
//   scene.add(m);

//   let v0 = new THREE.Vector3();
//   g1.children[0].getWorldPosition(v0);    // position of main submarine
//   // console.log(g1.children[0]);
//   let v = new THREE.Vector3(dest, 0,0);
//   let o = {t:0};
//   let ms = 500;
//   let t = new TWEEN.Tween(o).to({t:1},ms)
//       .repeat(3)
//       .onUpdate(()=>{
//         m.position.lerpVectors(v0,v,o.t);
//         render();
//       });
//   await play_this(t);
//   m.removeFromParent();
// }

async function get_destination(g1){
  let dest = -4*L;
  const map = new THREE.TextureLoader().load( './public/location_masked.png' );
  const material = new THREE.SpriteMaterial( { map: map,
                                               color: 0xffffff,
                                               opacity: 0
                                             } );
  const m = new THREE.Sprite( material );

  m.scale.set(20, 20, 1);
  m.position.set(dest,10,0);
  scene.add( m );

  // yoyo=ture makes the number of repeat matters ⇒
  // odd ⇒ 有，even ⇒ 无
  let t = new TWEEN.Tween(m.material).to({opacity:1},500).repeat(5).yoyo(true);
  await play_this(t);
}

async function get_submarine_group(){
  const g = new THREE.Group();
  // console.log(`Adding submarines`);
  let m = await load_relay();
  m.name = '主潜艇';
  g.add(m);

  // let submarines = [m];
  // Method 1: just clone --------------------------------------------------
  let s = 0.1;                    // the scale of smaller submarine
  m = await load_submarine();
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

      m1.name = `小潜艇${n}`;
      // submarines.push(m1);
      m1.scale.set(s,s,s);
      g.add(m1);
      n++;
    }
  }
  return g;
}


// Out of the region, it will be cropped.
async function get_submarines(){
  let g1 = await get_submarine_group();
  g1.translateX(6*L);
  g1.name = '潜艇1群';

  scene.add(g1);
  return g1;
}


function render() {renderer.render( scene, camera ); for (let fn of onRenders){fn();}}
function animate(time) {requestAnimationFrame(animate); TWEEN.update(time); render();}
