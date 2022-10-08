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
          url : 'https://service-400bq5xk-1314230580.gz.apigw.tencentcs.com/test/my-python-function?code=' +
          res.code,
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
