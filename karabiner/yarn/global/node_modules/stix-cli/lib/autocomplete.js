const tabtab = require('tabtab')({
  cache: false
});

const tabtabInit = () => {
  tabtab.on('stix', (data, done) => {
    done(null, [ { name: 'init', description: 'Initialize a new stix application.' } ]);
  });
};

module.exports = (stix, app) => {
  if (!stix) {
    return tabtabInit();
  }

  const { CliService } = require('stix');

  let resultsReady;

  const tabtabResults = new Promise(resolve => {
    resultsReady = resolve;
  });

  app.then(() => {
    const commands = stix.getServiceManager().get(CliService).getCommands();

    const completions = Object.keys(commands).map(command => ({
      name: command,
      description: commands[command].config ? commands[command].config.description : 'No description found.',
    }));

    resultsReady({ commands, completions });
  });

  tabtabResults.then(({ completions, commands }) => {
    tabtab.on('stix', (data, done) => {
      done(null, data.prev === 'stix' ? completions : null);
    });

    completions.forEach(({ name }) => {
      const config = commands[name].config;

      if (!config || !config.options) {
        return;
      }

      tabtab.on(name, (data, done) => {
        const options = [];
        const aliases = [];

        Object.keys(config.options).forEach(option => {
          options.push({
            name: `--${option}`,
            description: config.options[option] ? config.options[option].description : 'No description found.',
          });

          if (config.options[option].alias) {
            aliases.push({ name: `-${config.options[option].alias}`, description: `Alias for --${option}` });
          }
        });

        done(null, options.concat(aliases));
      });
    });

    tabtab.on('help', (data, done) => {
      done(null, completions.map(completion => ({
        name: completion.name,
        description: `Display help for command "${completion.name}".`,
      })));
    });

    tabtab.start();
  });
};
