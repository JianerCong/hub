import { mount } from '@vue/test-utils'
import TodoApp from '../src/components/HelloWorld.vue'

test('Use the component instance',()=>{
    const wrapper = mount(TodoApp)

    // wrapper.vm access the component instance
    expect(wrapper.vm.x).toBe(0)
    wrapper.vm.setX()
    expect(wrapper.vm.x).toBe(42)
})
