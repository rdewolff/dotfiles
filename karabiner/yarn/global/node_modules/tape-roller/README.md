# tape-roller

Create, modify and generate code. Common boilerplate operations on the CLI made easy.

[![Slack Status](https://spoonx-slack.herokuapp.com/badge.svg)](https://spoonx-slack.herokuapp.com)

https://gist.github.com/Rawphs/4f0ef360ddab7794549fa7b9b7e8b821

## Usage 

```ts
const moduleName      = params.name;
const sourceDirectory = path.resolve(__dirname, '..', 'templates');
const targetDirectory = path.resolve(projectRoot, 'app');
const tapeRoller      = new TapeRoller({ sourceDirectory, targetDirectory });

tapeRoller
  .read('module/**/*', { from: 'module' })
  .replace({ moduleName, year: new Date().getFullYear() })
  .write(path.resolve('module', moduleName));
```
