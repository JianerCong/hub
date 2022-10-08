import { mount } from '@vue/test-utils';
import LogInView from '../src/views/LogInView.vue';

import myStore from '../src/store/index.js';

// test logInView------------------------------------
test('mount LogInView component', async () => {
  expect(LogInView).toBeTruthy();
});

test('login view empty username', () => {
  const wrapper = mount(LogInView,{
    global: {
      plugins: [myStore],
    }
  });
  let vm = wrapper.vm;

  vm.unam = '';

  expect(vm.unamWrong).toBe(true);
});


test('login view empty password', () => {
  const wrapper = mount(LogInView,{
    global: {
      plugins: [myStore],
    }
  });
  let vm = wrapper.vm;

  vm.pswd = '';

  expect(vm.pswdWrong).toBe(true);
});
