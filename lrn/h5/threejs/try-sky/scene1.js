console.log('scene1 loaded');
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
        recieve_signals,
       } from './my_utils.js';

let camera, scene, renderer;
let onRenders = [];
const L = 50;

register_to_button(1,init);

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
  // console.log(g1);

  // subtitle
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

  await play_section(para,'1.中继器通过卫星受到组队命令',async () => await recieve_signals(3*L,scene));
  await play_section(para,'2.p2p身份认证，通过后入网并共识',async () => await make_signals(small_submarines,scene));
  await play_section(para,'3.执行组队命令',async () => await move_small_submarines(small_submarines));

  para.textContent = '4.完成组队';
  await subtitle_on(para);
  await Promise.all([
    establish_team(scene,g1.children[0],g1.children.slice(1),render),
    establish_team(scene,g2.children[0],g2.children.slice(1),render),
  ]);
  // await subtitle_off(para);

  console.log('done');
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
}

async function get_submarines(){
  let g1 = await get_submarine_group();
  g1.translateX(-3*L);
  g1.name = '潜艇1群';
  let g2 = g1.clone();
  g2.translateX(6*L);
  g1.name = '潜艇2群';

  scene.add(g1);
  scene.add(g2);
  // console.log(g1);
  return {g1,g2};
}


function render() {renderer.render( scene, camera ); for (let fn of onRenders){fn();}}
function animate(time) {requestAnimationFrame(animate); TWEEN.update(time); render();}
