import { defineConfig } from 'umi';
import * as path from 'path';

export default defineConfig({
  hash: true,
  title: '网易 | 智慧云课堂',
  publicPath: '/',
  define: {
    'process.env.ENV': process.env.ENV,
  },
  history: {
    type: 'hash',
  },
  nodeModulesTransform: {
    type: 'none',
  },
  routes: [
    { path: '/', component: '@/pages/login/index' },
    { path: '/classroom', component: '@/pages/classroom/index' },
  ],
  devServer: {
    https: {
      key: path.join(__dirname, './cert/key.pem'),
      cert: path.join(__dirname, './cert/cert.pem'),
    },
  },
});
