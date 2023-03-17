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
        setup_stats,
        setup_defaults,
        register_to_button,
        make_signals,

       } from './my_utils.js';

let camera, scene, renderer;
let onRenders = [];
const L = 25;

register_to_button(3,init);
init();

async function init() {
  setup_stats(onRenders);

  let o = setup_defaults();
  camera = o.camera; scene = o.scene; renderer = o.renderer;
	camera.position.set( 0, 100, 200 );/* x,y,z  (left, up, front)*/

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
  // console.log(g1);

  // subtitle
  const cav = document.querySelector('#webgl-output');
  // console.log('The canvas');
  // console.log(cav);
  let para = document.createElement('p');
  para.id = "subtitle";
  cav.appendChild(para);

  // move little subs--------------------------------------------------
  // para.textContent = '1.组队已经完成';
  // await subtitle_on(para);
  // await Promise.all([establish_team(scene,g1,render), establish_team(scene,g2,render)]);
  // await subtitle_off(para);


  // para.textContent = '2.某个航行器发现目标';
  // await subtitle_on(para);
  // let sub = g2.children[2];
  // await emit_signal(sub);
  // await subtitle_off(para);

  // para.textContent = '3.发现目标后，航行器节点共识目标信息，并向中继器节点上传信息。';
  // await subtitle_on(para);
  // await make_signals(g2.children.slice(1),scene);
  // await subtitle_off(para);

  para.textContent = '4.中继节点向岸上传输信息，接受新指令';
  await subtitle_on(para);

  // Create the signal mesh
  const g = new THREE.TorusGeometry(10,1,10,6,Math.PI);
  // radius,tube r_sag, t_sag, arc
  const m = new THREE.MeshLambertMaterial({
    color: 0xaa330a,
    opacity: 0.7,
    transparent: true
  });

  let s = new THREE.Mesh(g,m);  // signal
  // s.translateY(4*L);            // move to sky
  s.translateX(4*L);            // move to sky

  scene.add(s);

  let ms = 500;
  let t = new TWEEN.Tween(s.position).to({y:100},ms).repeat(3);
  await play_this(t);

  s.removeFromParent();
  await subtitle_off(para);

  console.log('done');
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
      // m1.translateY(-L);


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
    // sub.position.addScaledVector(new THREE.Vector3(Math.random(), Math.random(), Math.random(),), 0.5 * L);
    // sub.rotation.y = 2 * Math.PI * Math.random();
    // sub.rotation.x = 0.2 * Math.PI * Math.random();
}


  scene.add(g1);
  scene.add(g2);
  // console.log(g1);
  return {g1,g2};
}


function render() {renderer.render( scene, camera ); for (let fn of onRenders){fn();}}
function animate(time) {requestAnimationFrame(animate); TWEEN.update(time); render();}
