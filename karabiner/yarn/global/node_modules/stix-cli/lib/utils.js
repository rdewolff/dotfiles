const chalk = require('chalk');
const commandLineUsage = require('command-line-usage');

module.exports.displayHelp = () => {
  console.log(commandLineUsage([
    {
      header: 'Stix CLI',
      content: `{italic Stix CLI tools for your stix CLI needs. \\n\\t...And by that we mean stix projects.}`,
    },
    {
      header: chalk.yellow('Available commands:'),
    },
    { content: [ { name: chalk.green('init <name>'), description: 'Initialize a new Stix project in this directory.' } ] },
    {
      header: chalk.yellow('Examples:'),
      content: [{ description: '$ stix init my-app' }],
    },
  ]));
};

module.exports.displayError = (error, includeHelp = false) => {
  includeHelp && module.exports.displayHelp();

  if (!includeHelp) {
    console.log('');
  }

  console.log(chalk.red.bold('Error: ') + chalk.red(error) + '\n');
};

module.exports.displaySuccess = (message) => {
  console.log('');
  console.log(chalk.green.bold('Success: ') + chalk.green(message) + '\n');
};
