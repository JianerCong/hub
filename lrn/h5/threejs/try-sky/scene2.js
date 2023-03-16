console.log('scene2.js loaded');
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
       } from './my_utils.js';

let camera, scene, renderer;
let onRenders = [];
const L = 25;

init();

async function init() {
  setup_stats(onRenders);

  let o = setup_defaults();
  camera = o.camera; scene = o.scene; renderer = o.renderer;
	camera.position.set( 0, 400, 0 );/* x,y,z  (left, up, front)*/

  init_light(scene);
	let {sky,sun} = initSky(scene, renderer);
  initSea(scene);
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

  // await play_section(para,'1.组队已经完成，准备接受指令', async () => establish_team(scene,g1,render));
  // await play_section(para, '2.中继点收到任务指令及地点',
  //                    async () =>
  //                     get_destination(g1)
  //                   );

  await play_section(para,
                     '3.中继点被分配为导航角色并执行导航',
                     async () =>
                     navigate_there(g1)
                    );

  para.textContent = '4.到达任务执行地，中继点分配任务角色';
  await subtitle_on(para);

  await establish_team(scene,g1,render);
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
    console.log(sub.rotation);

    let t = new TWEEN.Tween(sub.rotation).to({y: a},500);
    await play_this(t);
    // console.log(sub.rotation);
}



  await subtitle_off(para);

  console.log('done');

}

async function navigate_there(g1){
  let ms = 1000;

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

  let t = new TWEEN.Tween(g1.position)
      .to({x: -4*L},1000)
      .easing(TWEEN.Easing.Quadratic.InOut);
  await play_this(t);
}

async function get_destination(g1){
  let dest = -4*L;

  // add a small ball m
  const geom = new THREE.SphereGeometry(2,8,8);
  const mat = new THREE.MeshPhongMaterial({color: 0xff2211});
  let m = new THREE.Mesh(geom,mat); // small ball
  scene.add(m);

  let v0 = new THREE.Vector3();
  g1.children[0].getWorldPosition(v0);    // position of main submarine
  // console.log(g1.children[0]);
  let v = new THREE.Vector3(dest, 0,0);
  let o = {t:0};
  let ms = 500;
  let t = new TWEEN.Tween(o).to({t:1},ms)
      .repeat(3)
      .onUpdate(()=>{
        m.position.lerpVectors(v0,v,o.t);
        render();
      });
  await play_this(t);
  m.removeFromParent();
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

      m1.name = `小潜艇`;
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
