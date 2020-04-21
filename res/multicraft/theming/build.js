var util  = require('util'),
    cp    = require('child_process'),
    fs    = require('fs'),
    path  = require('path'),
    os    = require('os'),
    steps = [];

/**
 * Normaize the process encoding across systems.
 */
process.stdin.setEncoding('utf8');

/**
 * Helper function to executing console commands.
 *
 * @param command string
 * @param args    array
 * @param cb      function
 */
function exec (command, args, cb) {
    // Windows is always special... have to do some wrangling here
    if (os.platform() === 'win32') {
        args.unshift('/c', command);
        command = 'cmd';
    }

    var child = cp.spawn(command, args, {
        cwd: __dirname
    });

    // Show the user the process output so they don't get too bored.
    child.stdout.pipe(process.stdout);
    child.stderr.pipe(process.stderr);
    child.on('close', function (code) {
        cb(!! code);
    });
}

/**
 * Step 2: Load the node_modules if they don't exist.
 */
steps.push(function(cb) {
    if (!fs.existsSync('node_modules')) {
        console.log('Installing build prerequisites. This only needs to be done once, and will take several minutes. Go grab a coffee while you wait!');
        exec('npm', ['install'], function (err) {
            if (err) {
                console.log('Error! Please be sure npm is installed and available on your system!');
            }
            cb(err);
        });

    } else {
        cb();
    }
});

/**
 * Step 3: Tell Gulp to go ahead and build the assets.
 */
steps.push(function(cb) {
    console.log('Compiling all assets. This may take a minute depending on the speed of your system.');
    exec('node', [path.join(__dirname, 'node_modules/gulp/bin/gulp.js'), 'dist'], cb);
});

/**
 * And finally, say we're done!
 */
steps.push(function(cb) {
    console.log('Done!');
});

/**
 * Now, run all the steps!
 */
(function run (err) {
    var func = steps.shift();
    if (func && !err) {
        func(run);
    } else {
        process.exit();
    }
})();
