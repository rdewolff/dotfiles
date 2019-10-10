#! /usr/bin/env node
const path = require('path');
const { displayError } = require('./utils');

process.env.NODE_PATH = [
  ...(process.env.NODE_PATH || []),
  path.resolve(process.cwd(), 'node_modules'),
].join(':');

require('module').Module._initPaths();
require('dotenv').config();

let stix;
let app;

try {
  const { Application } = require('stix');
  const config = require(path.resolve(process.cwd(), 'dist', 'config', 'index'));

  stix = new Application(config);
  app = stix.launch('cli', true);
} catch (error) {
  if (!process.env.COMP_LINE && ['init', 'help', undefined].indexOf(process.argv[2]) === -1) {
    displayError('Launching CLI failed. Did you forget to run `yarn build`? Error details below.');

    console.log(error);
  }
}

if (process.env.COMP_LINE) {
  require('./autocomplete')(stix, app);
} else {
  require('./run')(stix, app);
}
