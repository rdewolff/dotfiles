const { displayError, displaySuccess } = require('./utils');
const { Git, File, Package } = require('tape-roller');
const fs = require('fs');
const { Spinner } = require('cli-spinner');
const path = require('path');

module.exports = async (name) => {
  const spinner = new Spinner('Creating project...');

  spinner.setSpinnerString(26);
  spinner.start();

  const project = path.resolve(process.cwd(), name);

  try {
    fs.statSync(project);
    spinner.stop(true);

    return displayError('There is already a file/directory with this name.');
  } catch (error) {
  }

  spinner.setSpinnerTitle('(1/4) Cloning skeleton...');
  await Git.clone('https://github.com/SpoonX/stix-skeleton.git', name, process.cwd());

  spinner.setSpinnerTitle('(2/4) Clearing out useless artifacts...');
  await File.remove(path.resolve(project, `.git`), true);

  spinner.setSpinnerTitle('(3/4) Installing dependencies...');
  await Package.install(project);

  spinner.setSpinnerTitle('(4/4) Running build...');
  await Package.run('--cwd', 'install --prefix', project, 'build');

  spinner.stop(true);

  displaySuccess('Initialized new stix project!');
};
