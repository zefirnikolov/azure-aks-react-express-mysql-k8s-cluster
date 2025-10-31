// /ssr/index.js

// Transpile JSX and ESM -> CommonJS for server runtime
// - We IGNORE .babelrc to avoid external preset confusion
// - We set modules: 'commonjs' so imports in client/src (e.g., './components/Navbar')
//   are compiled to require(), which supports extensionless resolution.
// - Our dynamic import in app.js is inside eval('import(...)'), so Babel won't transform it.
require('@babel/register')({
  extensions: ['.js', '.jsx'],
  ignore: [/node_modules/],
  cache: true,
  babelrc: false,
  configFile: false,
  presets: [
    [require.resolve('@babel/preset-env'), { targets: { node: '20' }, modules: 'commonjs' }],
    [require.resolve('@babel/preset-react'), { runtime: 'classic', development: false }]
  ]
});

// ---- Asset stubs so CRA-style imports don't crash on the server ----
require.extensions['.css'] = function () { return undefined; };
require.extensions['.scss'] = function () { return undefined; };
const transparentPng =
  'data:image/png;base64,' +
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMB/akQvVwAAAAASUVORK5CYII=';
const imgStub = function (module) { module.exports = transparentPng; };
['.svg', '.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico'].forEach(ext => {
  require.extensions[ext] = imgStub;
});

// Start the Express SSR server
require('./app');
