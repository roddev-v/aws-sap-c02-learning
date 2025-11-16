const esbuild = require('esbuild');
const fs = require('fs');
const path = require('path');

const handlersDir = path.join(__dirname, 'lambdas'); // Correct: __dirname is /src
const outDir = path.join(__dirname, '..', 'dist'); // Output to /dist (project root)

// Read package.json to get dependencies
const packageJson = require('../package.json'); // Fixed path
const externalDeps = [
  'aws-sdk',
  '@aws-sdk/*',
  ...Object.keys(packageJson.dependencies || {}),
  ...Object.keys(packageJson.peerDependencies || {}),
];

// Get all handler files
const handlers = fs.readdirSync(handlersDir)
  .filter(file => file.endsWith('.ts'))
  .map(file => path.join(handlersDir, file));

// Bundle each handler
Promise.all(handlers.map(async (handler) => {
  const handlerName = path.basename(handler, '.ts');
  
  await esbuild.build({
    entryPoints: [handler],
    bundle: true,
    platform: 'node',
    target: 'node20',
    outfile: path.join(outDir, `${handlerName}.js`),
    external: externalDeps,
    minify: true,
    sourcemap: true,
  });
  
  console.log(`✓ Built ${handlerName}.js`);
})).catch(() => process.exit(1));