const esbuild = require('esbuild');
const fs = require('fs');
const path = require('path');
const archiver = require('archiver');

const handlersDir = path.join(__dirname, 'lambdas');
const outDir = path.join(__dirname, '..', 'dist');

// Read package.json to get dependencies
const packageJson = require('../package.json');
const externalDeps = [
  'aws-sdk',
  '@aws-sdk/*',
  ...Object.keys(packageJson.dependencies || {}),
  ...Object.keys(packageJson.peerDependencies || {}),
];

// Create zip file
function createZip(filename, outfile) {
  return new Promise((resolve, reject) => {
    const output = fs.createWriteStream(outfile);
    const archive = archiver('zip', { zlib: { level: 9 } });

    output.on('close', () => resolve(void 0));
    archive.on('error', (err) => reject(err));

    archive.pipe(output);
    archive.file(filename, { name: 'index.js' });
    archive.finalize();
  });
}

// Get all handler files
const handlers = fs.readdirSync(handlersDir)
  .filter(file => file.endsWith('.ts'))
  .map(file => path.join(handlersDir, file));

// Bundle and zip each handler
Promise.all(handlers.map(async (handler) => {
  const handlerName = path.basename(handler, '.ts');
  const jsFile = path.join(outDir, `${handlerName}.js`);
  const zipFile = path.join(outDir, `${handlerName}.zip`);
  
  await esbuild.build({
    entryPoints: [handler],
    bundle: true,
    platform: 'node',
    target: 'node20',
    outfile: jsFile,
    external: externalDeps,
    minify: true,
    sourcemap: true,
  });
  
  console.log(`✓ Built ${handlerName}.js`);
  
  await createZip(jsFile, zipFile);
  console.log(`✓ Zipped ${handlerName}.zip`);
  
})).catch(() => process.exit(1));