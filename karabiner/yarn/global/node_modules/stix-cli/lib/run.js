const { displayError, displayHelp } = require('./utils');

const run = () => {
  if (!process.argv[2] || process.argv[2] === 'help') {
    return displayHelp();
  }

  if (process.argv[2] && process.argv[2] !== 'init') {
    return displayError(`Unknown command "${process.argv[2]}" supplied.`, true);
  }

  if (process.argv[2] === 'init') {
    if (!process.argv[3]) {
      return displayError('Project name missing.', true);
    }

    return require('./init')(process.argv[3]);
  }
};

module.exports = (stix, app) => {
  if (!stix) {
    return run();
  }

  app.then(() => stix.start());
};
