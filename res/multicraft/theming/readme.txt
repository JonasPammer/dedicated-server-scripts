Installation
===
The build process is fairly straightforward. First, you'll need [Node.js](http://nodejs.org/download/) installed on your system. Then, run `node build.js`. The script will complete the compilation process by itself. The compiled themes will be installed in '../panel/themes'.

Development
===
The installation script effectively does the following:

  1. Ensure that dependencies are met on NPM, which includes the Gulp and Bower tools.
  2. Ensure that dependencies are met in Bower.
  3. Runs "gulp dist" to build assets into the panel.

For development, you can edit any theme in the `theming/themes` directory. After modifying it, run `gulp` in your command line to compile the theme into the panel.

You can use Grunt to compile assets according to your purpose:

- `gulp` - Compiles LESS and copies scripts and images, without any minfication
- `gulp dist` - Builds and minifies scripts and images. This may take a minute or two, depending on the system.

Aside from these, you may also find it useful to manually clear the state of the panel, triggering a rerun of the installation procedure. You can do this by running `gulp clean:state`.

Customization
===
Styles may be customized very easily, simply by changing [LESS](lesscss.org) variables in `static/css/style.less` and recompiling. A number of theme-specific variables are there, and, as Bootstrap is built in LESS as well, you can override the default LESS settings. By inserting any variable that appears in [Bootstrap's variables.less file](https://github.com/twbs/bootstrap/blob/master/less/variables.less) into this panel's style.less, you can override and change Bootstrap's default appearance.

