
import { mount } from '@vue/test-utils'
import SignUpView from '../src/views/SignUpView.vue'

import myStore from '../src/store/index.js';


test('mount SignUpView component', async () => {
    expect(SignUpView).toBeTruthy()
})


test('signup view empty password', () => {
    const wrapper = mount(SignUpView,{
        global: {
          plugins: [myStore],
        }
    })
    let vm = wrapper.vm

    vm.pswd = ''

    expect(vm.pswdWrong).toBe(true)
})

test('signup view nonempty password', () => {
    const wrapper = mount(SignUpView,{
        global: {
          plugins: [myStore],
        }
    })
    let vm = wrapper.vm

    vm.pswd = '123'

    expect(vm.pswdWrong).toBe(false)
})


test('signup view non-empty username', () => {
    const wrapper = mount(SignUpView,{
        global: {
          plugins: [myStore],
        }
    })    
    let vm = wrapper.vm

    vm.unam = 'abc'

    expect(vm.unamWrong).toBe(false)
})

test('signup view empty username', () => {
    const wrapper = mount(SignUpView,{
        global: {
          plugins: [myStore],
        }
    })    
    let vm = wrapper.vm

    vm.unam = ''

    expect(vm.unamWrong).toBe(true)
})

test('signup view not same password', () => {
    const wrapper = mount(SignUpView,{
        global: {
          plugins: [myStore],
        }
    })    
    let vm = wrapper.vm

    vm.pswd= '123'
    vm.pswd2 = '124'

    expect(vm.pswdSame).toBe(false)
})


test('signup view same password', () => {
    const wrapper = mount(SignUpView,{
        global: {
          plugins: [myStore],
        }
    })    
    let vm = wrapper.vm

    vm.pswd= '123'
    vm.pswd2 = '123'

    expect(vm.pswdSame).toBe(true)
})
