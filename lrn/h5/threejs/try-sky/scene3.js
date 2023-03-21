console.log('scene3 loaded');
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
        load_submarine,
        load_satellite,

        setup_stats,
        setup_defaults,
        register_to_button,
        make_signals,
        recieve_signals_from_sat,

        get_signals,
       } from './my_utils.js';

let camera, scene, renderer;
let onRenders = [];
const L = 25;

register_to_button(3,init);
init();

async function init() {
  // setup_stats(onRenders);

  let o = setup_defaults();
  camera = o.camera; scene = o.scene; renderer = o.renderer;
	camera.position.set( 0, 100, 300 );/* x,y,z  (left, up, front)*/

  init_light(scene);
	let {sky,sun} = initSky(scene, renderer);
  initSea(scene);
  let {g1,g2} = await get_submarines();

  add_helpers_orbit(camera, renderer, render,scene, L);
	window.addEventListener( 'resize',makeOnWindowResize(camera,renderer, render));
  render();

  await start_movie({g1,g2});
}


async function start_movie({g1,g2}){
	requestAnimationFrame(animate);
  console.log('Movie started');
  let sat = await load_satellite(4*L,scene);
  // console.log(g1);

  // subtitle
  const cav = document.querySelector('#webgl-output');
  // console.log('The canvas');
  // console.log(cav);
  let para = document.createElement('p');
  para.id = "subtitle";
  cav.appendChild(para);
  let sub;

  // move little subs--------------------------------------------------
  // para.textContent = '1.组队已经完成';
  // await subtitle_on(para);
  // await Promise.all([
  //   establish_team(scene,g1.children[0],g1.children.slice(1),render),
  //   establish_team(scene,g2.children[0],g2.children.slice(1),render),
  // ]);
  // await subtitle_off(para);


  // para.textContent = '2.某个航行器发现目标';
  // await subtitle_on(para);
  // sub = g2.children[2];
  // await emit_signal(sub);
  // await subtitle_off(para);

  // para.textContent = '3.发现目标后，航行器节点共识目标信息。由离中继器最近的航行器向中继器节点上传信息。';
  // await subtitle_on(para);
  // await make_signals(g2.children.slice(1),scene);
  // await cross_signal(g2.children[0],g2.children[3]);
  // await subtitle_off(para);

  para.textContent = '4.中继节点向岸上传输信息，接受新指令';
  await subtitle_on(para);
  await send_signal(sat,g2.children[0]);

  await recieve_signals_from_sat(4*L, scene, 4*L);
  await subtitle_off(para);
  // para.textContent = '5.中继节点共识新任务';
  // await subtitle_on(para);
  // let two_submarines = [g1.children[0], g2.children[0]];
  // await make_signals(two_submarines,scene,500,2);
  // await subtitle_off(para);

  // para.textContent = '6.其他集群指定某个下属航行器作为导航，前往任务目的地支援任务集群';
  // await subtitle_on(para);
  // await move_to_task(g1);
  // await subtitle_off(para);

  // para.textContent = '7.任务航行器受到干扰，通过动态重构，重新组网；';
  // await subtitle_on(para);
  // sub = g2.children[2];     // the sub that recieved the disturbance.
  // await recieve_disturbance(sub);
  // await make_signals(g1.children.slice(1).concat(
  //   g2.children[1], g2.children.slice(3)),scene);
  // // all small submarine but g2[2]
  // await subtitle_off(para);

  // para.textContent = '8.部分航行器改变集群，重新组网，分配角色后继续执行任务；';
  // await subtitle_on(para);
  // await establish_team(scene, g2.children[0],
  //                      g2.children.slice(3).concat(g2.children[1],
  //                                                  g1.children[4]),render);
  // await subtitle_off(para);


  console.log('done');
}

// async function recieve_disturbance(sub){
//   const g = new THREE.TorusGeometry(10,1,10,50);
//   const m = new THREE.MeshPhongMaterial({color: 0xff3333});
//   let s0 = new THREE.Mesh(g,m);  // signal
//   s0.rotateX(0.5*Math.PI);

//   let N = 10;
//   let v = new THREE.Vector3;
//   sub.getWorldPosition(v);
//   s0.position.copy(v);
//   s0.scale.x = N;
//   s0.scale.y = N;

//   scene.add(s0);

//   // animate
//   let t = new TWEEN.Tween(s0.scale).to({x:1,y:1},1000)
//       .repeat(2)
//       .easing(TWEEN.Easing.Quadratic.InOut);
//   await play_this(t);
//   s0.removeFromParent();
// }

async function recieve_disturbance(sub){
  const map = new THREE.TextureLoader().load( './public/error_no_bg.png' );
  const material = new THREE.SpriteMaterial( { map: map,
                                               color: 0xffffff,
                                               opacity: 0,
                                               depthFunc: THREE.AlwaysDepth
                                               // blending: THREE.AdditiveBlending
                                             } );
  const m = new THREE.Sprite( material );
  m.scale.set(10, 10, 1);

  let v = new THREE.Vector3;
  sub.getWorldPosition(v);


  m.position.copy(v);
  scene.add( m );
  let t = new TWEEN.Tween(m.material).to({opacity:1},500).repeat(Infinity).yoyo(true).start();
  await new Promise((resolve) => {setTimeout(resolve, 2000);});
  // let N = 10;
}
async function move_to_task(g1){
  let ms = 3000;
  // Rotate the navigating submarine
  let sub = g1.children[4];
  let t = new TWEEN.Tween(sub.rotation)
      .to({y:0.5*Math.PI},ms)
      .easing(TWEEN.Easing.Quadratic.InOut);
  await play_this(t);
  await make_signals([sub],scene,1000,1);

  // Rotate the rest of group
  let ts = [];
  for (let sub of g1.children.slice(0,4)){
    let t = new TWEEN.Tween(sub.rotation)
        .to({y:0.5*Math.PI},ms)
        .easing(TWEEN.Easing.Quadratic.InOut)
        .delay(0.5 * ms * Math.random())
    ;
    ts.push(t);
  }
  await play_these(ts);

  // Move the whole group
  t = new TWEEN.Tween(g1.position)
    .to({x: 0},5000)
    .easing(TWEEN.Easing.Quadratic.InOut);
  await play_this(t);

}

async function send_signal(m1,m2){
  const v0 = new THREE.Vector3();
  m1.getWorldPosition(v0);
  const v1 = new THREE.Vector3();
  m2.getWorldPosition(v1);

  const {ts,fns} = await get_signals(scene,v1,v0,1000,2);
  await play_these(ts,fns);
}

async function emit_signal(sub){
  const g = new THREE.TorusGeometry(10,1,10,50);
  const m = new THREE.MeshPhongMaterial({color: 0xff0505});
  let s0 = new THREE.Mesh(g,m);  // signal
  s0.rotateX(0.5*Math.PI);

  let v = new THREE.Vector3;
  sub.getWorldPosition(v);
  s0.position.copy(v);

  scene.add(s0);

  let N = 10;
  // animate
  let t = new TWEEN.Tween(s0.scale).to({x:N,y:N},1000)
      .repeat(3)
      .easing(TWEEN.Easing.Quadratic.In);
  await play_this(t);
  s0.removeFromParent();
}

async function get_submarine_group(scale=1){
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
      m1.translateX(scale * i*L);
      m1.translateZ(scale * j*L);
      // for debug purpose,
      m1.translateY(-L);


      let random_amount = 0.5*L;
      // Add some randomness to position

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
  const dist = 8 * L;
  let g1 = await get_submarine_group();
  g1.translateX(- dist/2);
  g1.name = '潜艇1群';

  let g2 = await get_submarine_group(2);
  g2.translateX(dist /2);
  g1.name = '潜艇2群';

  g2.children[3].translateX(-L);
  g2.children[3].translateZ(L); // the closer child

  // add some randomness to group1
  for (let sub of g2.children.slice(1)){
    // console.log(sub);
    sub.position.addScaledVector(new THREE.Vector3(Math.random(), Math.random(), Math.random(),), 0.5 * L);
    sub.rotation.y = 2 * Math.PI * Math.random();
    sub.rotation.x = 0.2 * Math.PI * Math.random();

    // add some animation to group 1
    sub.userData.oldY = sub.position.y;
    let t = new TWEEN.Tween(sub.position)
        .to({y: sub.userData.oldY + 0.5* L * Math.random()},2000).repeat(Infinity).yoyo(true).start();
}


  scene.add(g1);
  scene.add(g2);
  // console.log(g1);
  return {g1,g2};
}

async function cross_signal(m1,m2){
  const v0 = new THREE.Vector3();
  m1.getWorldPosition(v0);
  const v1 = new THREE.Vector3();
  m2.getWorldPosition(v1);

  const {ts,fns} = await get_signals(scene,v1,v0,1000,2);
  const o2 = await get_signals(scene,v0,v1,1000,2,0x0033aa);
  await play_these(ts.concat(o2.ts),fns.concat(o2.fns));
}

function render() {renderer.render( scene, camera ); for (let fn of onRenders){fn();}}
function animate(time) {requestAnimationFrame(animate); TWEEN.update(time); render();}
