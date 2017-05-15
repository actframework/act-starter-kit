/*!
* gulp
* $ npm install gulp-autoprefixer gulp-cssnano gulp-jshint gulp-concat gulp-uglify gulp-imagemin gulp-notify gulp-rename gulp-livereload gulp-cache del gulp-clip-empty-files gulp-less --save-dev
*
* Simple GULP script to show you how to integrate a Node hot-reload front-end workflow with the Act hot-reload backend and fart unicorn rainbows 4 dayz.
* - by Joe Cincotta 8/3/2017
*
*/


/*
Put your regular CSS, LESS and Javascript files here. I have put a wildcard here to take everything from the js.src, less.src and css.src directories, 
so you can just add your own Javascript there without having to update this section - unless you're using a Node module. 

If you are trying to use a node package and also minify it, you should put the path to the Minified CSS as per the example form below:
'node_modules/bootstrap/js/collapse.js'

To get this working, you should update your libs in the 'package.json' file and let NPM install the node library into the node_modules path. 
By doing this you have the ability to use one command (setup_dev) to download and install all Javascript AND Java (Maven) deps! Nice...
*/
var normal_css_src=['css.src/*.css'];
var less_src=['less.src/*.less'];
var normal_js_src=['js.src/*.js','node_modules/bootstrap/js/collapse.js'];


/*
Put your already minified files here... Normally you would use this if you are trying to use a node package. 
You should put the path to the Minified CSS or JS as per the example form below:
'node_modules/bootstrap/dist/css/bootstrap.min.css'

To get this working, you should update your libs in the package.json and let NPM install the node library into the node_modules path. 
By doing this you have the ability to use one command (setup_dev) to download and install all Javascript AND Java (Maven) deps! Nice...
*/
var already_minified_css_src=['node_modules/bootstrap/dist/css/bootstrap.min.css'];
var already_minified_js_src=['node_modules/jquery/dist/jquery.min.js', 'node_modules/bootstrap/dist/js/bootstrap.min.js'];





var gulp = require('gulp'),
    autoprefixer = require('gulp-autoprefixer'),
    cssnano = require('gulp-cssnano'),
    uglify = require('gulp-uglify'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    notify = require('gulp-notify'),
    cache = require('gulp-cache'),
    livereload = require('gulp-livereload'),
    del = require('del'),
    clip = require('gulp-clip-empty-files'),
    less = require('gulp-less');

/*
* These are our ACT standard project path locations for processed CSS and Javascript files.
* */
var path = {
    css : 'src/main/resources/asset/css',
    js : 'src/main/resources/asset/js',
    img: 'src/main/resources/asset/img'
};


/*
* Gulp pipeline for taking standard CSS and minifying it
* then put it in the standard ACT location for static CSS resources
* */
gulp.task('css', function() {
    return gulp.src(normal_css_src)
        .pipe(rename({suffix: '.min'}))
        .pipe(cssnano())
        .pipe(gulp.dest(path.css))
        .pipe(notify({ message: 'css ok' }));
});

/*
 * Gulp pipeline for taking already minified CSS
 * then put it in the standard ACT location for static CSS resources
 * */
gulp.task('css-min', function() {
    return gulp.src(already_minified_css_src)
        .pipe(gulp.dest(path.css))
        .pipe(notify({ message: 'css-min ok' }));
});

/*
 * Gulp pipeline for taking LESS and processing then minifying it
 * then put it in the standard ACT location for static CSS resources
 *
 * Note that we have a heavily modified the LESS templates from the rsrc directory.
 * */
gulp.task('less', function() {
    return gulp.src(less_src)
        .pipe(less())
        .pipe(rename({suffix: '.min'}))
        .pipe(cssnano())
        .pipe(clip())
        .pipe(gulp.dest(path.css))
        .pipe(notify({ message: 'less ok' }));
});

/*
 * Gulp pipeline for taking already minified JS from node_modules and
 * then put it in the standard ACT location for static JS resources
 * */
gulp.task('js-min', function() {
    return gulp.src(already_minified_js_src)
        .pipe(gulp.dest(path.js))
        .pipe(notify({ message: 'js-min ok' }));
});

/*
 *  Gulp pipeline for taking Javascript and minifying it,
 *  then put it in the standard ACT location for static JS resources
 *
 *  Note: we are using prismjs, however since there are no compiled CSS distribution files in the PrismJS deployment
 *  we use pre-compiled versions in the js.src and css.src directories... don't hate me.
 *
 *  Same deal for highlight.js - it's a custom pack that has language specific extensions, and line-numbers - so
 *  just nod and smile... then maintain eye contact and step away slowly.
 * */
gulp.task('js', function() {
    return gulp.src(normal_js_src)
        .pipe(rename({suffix: '.min'}))
        .pipe(uglify())
        .pipe(gulp.dest(path.js))
        .pipe(notify({ message: 'js ok' }));
});

/*
 * Gulp cleanup task
 * */
gulp.task('clean', function() {
    return del([
        path.js + '/*.js',
        path.css + '/*.css'
    ]);
});

/*
 * Gulp default task
 * */
gulp.task('default', ['clean'], function() {
    gulp.start('js', 'js-min', 'css','css-min','less');
});

/*
 * Gulp file watcher only needs to monitor changes to actual CSS and JS files
 * since the ACT hot-reload takes care of all other changes
 * */
gulp.task('watch', function() {
    // Watch .css files
    gulp.watch('css.src/*.css', ['css']);

    // Watch .js files
    gulp.watch('js.src/*.js', ['js']);

    // Watch .js files
    gulp.watch('less.src/*.less', ['less']);

    // Create LiveReload server
    livereload.listen();
});
