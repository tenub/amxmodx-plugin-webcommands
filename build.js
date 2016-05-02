const build = require('amxmodx-build');
const pkg = require('./package.json');
const amxxpath = (pkg.amxmodx && pkg.amxmodx.path) ? pkg.amxmodx.path : '';

build(amxxpath);
