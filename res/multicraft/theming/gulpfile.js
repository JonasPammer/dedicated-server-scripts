var gulp         = require('gulp'),
    themes       = require('fs').readdirSync('themes'),
    isProduction = false,
    $            = require('gulp-load-plugins')(),
    rimraf       = require('rimraf');

var globs = {
    less: 'themes/**/css/*.less',
    css: 'themes/**/*.css',
    js: 'themes/**/*.js',
    images: 'themes/**/*.{png,gif,jpg,jpeg,svg}',
    misc: ['themes/**/*.{ico,eot,woff,ttf,php,txt}', 'themes/**/.htaccess']
};

var target = '../panel/themes';

gulp.task('css', function() {
    gulp.src(globs.less)
        .pipe($.filter(['**/*.less', '!**/_*.less']))
        .pipe($.less())
        .pipe($.autoprefixer('last 3 versions'))
        .pipe($.if(isProduction, $.minifyCss()))
        .pipe(gulp.dest(target));
    gulp.src(globs.css)
        .pipe($.if(isProduction, $.minifyCss()))
        .pipe(gulp.dest(target));
});
gulp.task('js', function () {
    gulp.src(globs.js)
        .pipe($.if(isProduction, $.uglify()))
        .pipe(gulp.dest(target));
});
gulp.task('images', function() {
    gulp.src(globs.images)
        .pipe(gulp.dest(target));
});
gulp.task('misc', function () {
    gulp.src(globs.misc).pipe(gulp.dest(target));
});

gulp.task('clean', function () {
    rimraf.sync('../panel/assets/*');
    for (var i = 0, l = themes.length; i < l; i++) {
        rimraf.sync(target + '/' + themes[i]);
    }
});

gulp.task('setProduction', function() {
    isProduction = true;
});

gulp.task('dist', ['setProduction', 'default']);
gulp.task('default', ['clean', 'js', 'css', 'images', 'misc']);
