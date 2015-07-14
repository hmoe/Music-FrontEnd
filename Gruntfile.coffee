'use strick'

module.exports = (grunt) ->
    conf =
        pkg: grunt.file.readJSON('package.json'),
        wiredep:
            task:
                src: [
                    'public/index.html'
                ]
        concat:
            dist:
                src: ['src/views/header.tpl'
                      'src/views/popbox/header.tpl'
                      'src/views/popbox/playlist.tpl'
                      'src/views/popbox/about.tpl'
                      'src/views/popbox/setting.tpl'
                      'src/views/popbox/footer.tpl'
                      'src/views/wrap/header.tpl'
                      'src/views/wrap/right_panel.tpl'
                      'src/views/wrap/info_box.tpl'
                      'src/views/wrap/lrc.tpl'
                      'src/views/wrap/ctl_panel.tpl'
                      'src/views/wrap/footer.tpl'
                      'src/views/footer.tpl']
                dest: 'public/index.html'
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

    grunt.loadNpmTasks 'grunt-wiredep'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-copy'

    grunt.initConfig conf

    grunt.registerTask 'default', ['copy', 'concat', 'wiredep', 'sass']

