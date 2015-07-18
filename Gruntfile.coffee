'use strick'

module.exports = (grunt) ->
  conf =
    pkg: grunt.file.readJSON('package.json'),
    wiredep:
      task:
        src: [
          'public/index.html'
        ]
    jade:
      compile:
        files:
          'public/index.html': 'src/views/index.jade'
    copy:
      main:
        files: [ {
          expand: true,
          src: ['assets/**']
          dest: 'public/'
        } ]
    sass:
      dist:
        files:
          'public/assets/css/hmoe-player.css': 'src/sass/hmoe-player.sass'
          'public/assets/css/hmoe-html5player-icon.css': 'src/sass/hmoe-html5player-icon.sass'
          'public/assets/css/reset.css': 'src/sass/reset.sass'
          'public/assets/css/animation.css': 'src/sass/animation.sass'
    coffee:
      compile:
        options:
          bare: true
        files:
          'public/assets/js/hmoe-player.js': 'src/coffee/hmoe-player.coffee'
          'public/assets/js/player.js': 'src/coffee/player.coffee'

  grunt.loadNpmTasks 'grunt-wiredep'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.initConfig conf

  grunt.registerTask 'default', ['copy', 'jade', 'wiredep', 'sass', 'coffee']

