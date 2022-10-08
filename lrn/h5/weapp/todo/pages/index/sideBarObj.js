const sideBarObj = {
  data: {
    // sharedText: 'This is a piece of data shared between pages.'
    light: true,
    visible: false,
    checker_color: '#aaa',
  },

  attached: function() {
    // get the system theme
    wx.getSystemInfo({
      // ! it's important to use arrow function here so you can refers to `this`'
      success: (res) => {
        let t = res.theme;
        console.log(` Mode: ${t}`);

        if (t === "dark") {
          console.log(`switching theme during attachment`);

          this.setData({light: false, checker_color: '#666'});
          wx.setNavigationBarColor({
            frontColor: '#ffffff',  // 状态栏 按钮
            backgroundColor: '#222',
            animation: {
              duration: 400,
              timingFunc: 'easeIn'
            },
          });

          console.log(`now the light is `);
        } else if (res.theme === 'light'){
          console.log(`not switching theme`);
        } else {
          console.warn(`failed to get system theme`);
        }

        // listen to the switch theme event
        wx.onThemeChange(() => {
          console.log(`theme changed in the system`);
          this.switchTheme();
        });

      },
      fail: function(res) {
        console.warn(`failed to get system info`);
      },
    });

  },
  methods: {
    // sharedMethod: function() {
    //   this.data.sharedText === 'This is a piece of data shared between pages.'
    // }

    // side bar -----------------------------------------
    onVisibleChange({ detail }) {
        const { visible } = detail;
        this.setData({
           visible: visible
        });
    },

    // bar
    switchTheme() {
      console.log(`switching theme`);
      let l =  !this.data.light;
      this.setData({
        light: l
      });
      if (l) {
        console.log(`switched to light mode`);
        this.setData({checker_color: '#aaa'});
        wx.setNavigationBarColor({
          frontColor: '#000000',
          backgroundColor: '#ccc',
          animation: {
            duration: 400,
            timingFunc: 'easeIn'
          }
        });
      } else {
        console.log(`switched to dark-mode`);
        this.setData({checker_color: '#666'});
        wx.setNavigationBarColor({
          frontColor: '#ffffff',  // 状态栏 按钮
          backgroundColor: '#222',
          animation: {
            duration: 400,
            timingFunc: 'easeIn'
          }
        });
      }  
    },

    openPopUp() {
      console.log('opening popup');
      this.setData({
        visible: true,
      });
    },
  }
};

export {sideBarObj}
