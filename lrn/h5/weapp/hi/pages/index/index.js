// index.js
// 获取应用实例
const app = getApp();

Page({
  data: {
    openid : '',
    todos : [],
  },
  onLoad(){
    wx.login({
      success: (res)=>{
        console.log(`got code: ${res.code}`);
        let o = {
          url : 'https://myfunction-myservice-cgsyqncxvc.cn-hangzhou.fcapp.run/?code=' + res.code,
          success: (res) => {
            let data = res.data 
            console.log(`Got data ${JSON.stringify(data)}`);
            if (data.ok) {
              this.setData({openid: data.openid, todos: data.todos});
            } else {
              console.log('error: ' + data.msg)
            }
          },
          fail: () => {console.log(`failed`);}
        };
        wx.request(o);
      },
      fail: () => {
        console.warn(`failed.`);
      }});
},
addOne() {
  let newTodos = this.data.todos
  newTodos.push({
      name: `t${newTodos.length}`,
      done: false, 
      ddl: (newTodos.length % 2 === 0) ? '2000-01-01' : ''
})

  this.setData({todos: newTodos})
  console.log(`one item added, now todo is ${JSON.stringify(this.data.todos)}`)
},
submit() {
  console.log('submitting todos')
  if (this.data.openid === '') {
    console.log('openid not available, not submitting')
    return;
  } 

  let o = {
    url : 'https://myfunction-myservice-cgsyqncxvc.cn-hangzhou.fcapp.run/',
    data : {
      openid: this.data.openid,
      todos: this.data.todos
    },
    method: 'POST',
    success: (res) => {
      let data = res.data 
      console.log(`Got data ${JSON.stringify(data)}`);
      if (data.ok) {
        console.log('Data submited')
      } else {
        console.log('error: ' + data.msg)
      }
    },
    fail: () => {console.log(`failed`);}
  };
  wx.request(o);
}
});
