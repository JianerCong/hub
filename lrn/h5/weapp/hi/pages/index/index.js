// index.js
// 获取应用实例
const app = getApp();

Page({
  data: {
  },
  onLoad(){
    wx.login({
      success: (res)=>{
        console.log(`got code: ${res.code}`);
        let o = {
          url : 'http://localhost:8080/',
          success: (res) => {
            console.log(`Got data ${res.data}`);
          },
          fail: () => {console.log(`failed`);}
        };
        wx.request(o);
      },
      fail: () => {
        console.warn(`failed.`);
      }});
}
});
