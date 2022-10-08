import { mount } from '@vue/test-utils'
import TodoApp from '../src/components/HelloWorld.vue'

test('mount component', async () => {
    expect(TodoApp).toBeTruthy()
})

test('renders a todo', () => {
    const wrapper = mount(TodoApp)

    const todo = wrapper.get('[data-test="todo"]')

    expect(todo.text()).toBe('Learn Vue.js 3')
})

test('completes a todo', async () => {
    const wrapper = mount(TodoApp)

    await wrapper.get('[data-test="todo-checkbox"]').setValue(true)

    expect(wrapper.get('[data-test="todo"]').classes()).toContain('completed')
})

test('creates a todo', async () => {
    const wrapper = mount(TodoApp)

    await wrapper.get('[data-test="new-todo"]').setValue('New todo')
    await wrapper.get('[data-test="form"]').trigger('submit')

    expect(wrapper.findAll('[data-test="todo"]')).toHaveLength(2)
})
