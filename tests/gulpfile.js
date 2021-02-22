/**
 * 
 * Se indica que se requiren los siguientes plugins previamente instalados.
 * Instalacion:
 *  gulp: npm install gulp --save-dev
 *  gulp-cucumber: npm install gulp-cucumber --save-dev
 *  gulp-rimraf: npm install --save-dev gulp-rimraf
 *  gulp-nodeunit-runner: npm install --save-dev gulp-nodeunit-runner
 *  gulp-apimocker: npm install gulp-apimocker --save-dev
 *  gulp-protractor-cucumber-html-report: npm install gulp-protractor-cucumber-html-report --save-dev
 * 
 */
var gulp = require('gulp');
var cucumber = require('gulp-cucumber');
var clean = require('gulp-rimraf');
var runner = require("gulp-nodeunit-runner");
var mocker = require('gulp-apimocker');
var reporter = require('gulp-protractor-cucumber-html-report');


/**
 * 
 * Borra el contenido de la carpeta report.
 * 
 */
gulp.task('clean', () =>{
    return gulp.src(['features/report/*'],{read: false })
               .pipe(clean({force: true}))
   });

/**
 * 
 * corre pruebas de features y genera reporte en formato json.
 *
 */
gulp.task('cucumber-test', () => {
    return gulp.src('*features/*')
                .pipe(cucumber({
                    'steps': '*features/step_definitions/*.js',
                    'support':'*features/support/*.js',
                    'format': 'json:features/report/cucumber_report.json'
                })
            );
});

/**
 *
 * Corre servidor con los mocks generados.
 *
 */
gulp.task('apimocker', () => {
    return mocker.start({
      config: '../node/config-generated.json',
      mockDirectory: '../node/mock'
    });
});


/**
 * 
 * Genera reporte html a partir de report 
 * json creado en la tarea cucumber-test.
 * 
 */
gulp.task('test-crear-html', () =>{
    return gulp.src('index.js')
               .pipe(runner())
});

/**
 * 
 * Genera reporte html a partir de report json creado en la tarea cucumber.
 * 
 */
gulp.task('crear-reporte-protractor-cucumber',() => {
    return gulp.src('features/report/cucumber_report.json')
               .pipe(reporter({
                    dest: 'features/report/'
                }));
});

/**
 * Ejecuta las tareas en la secuencia indicada.
 */
exports.correrPruebas = gulp.parallel('apimocker',gulp.series('clean','cucumber-test', 'test-crear-html'));

