import axios from "axios";

import {ref, computed} from 'vue';
import { useStore } from 'vuex';
import {useRouter} from 'vue-router';
export default function f() {
  const http = axios.create({
    baseURL: process.env.VUE_APP_AUTH_HOST ?
      `https://${process.env.VUE_APP_AUTH_HOST}/auth/` :
      'http://localhost:9002'
  });

  // switched to composition API
  /* toHome() {
   *     this.$router.push({path: '/'})
   * }, */
  let r = useRouter();

  function toHome() {
    r.push({path: '/'});
  }

  let unam = ref('aaa');
  let pswd = ref('123');

  const s = useStore();
  const unamWrong = computed(() => unam.value === '');
  const pswdWrong = computed(() => pswd.value === '');
  const online = computed(() => s.state.online);
  const lang = computed(() => s.getters.lang);

  return {http, toHome, unam,pswd,
          unamWrong, pswdWrong, online, lang};
}
