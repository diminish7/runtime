module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compile:
        files: [
          expand: true
          cwd: 'src'
          src: '**/*.coffee'
          dest: 'target'
          ext: '.js'
        ]
    coffeelint:
      app: 'src/**/*.coffee'
      options:
        configFile: 'coffeelint.json'
    watch:
      files: ['Gruntfile.coffee', 'src/**/*.coffee']
      tasks: ['coffeelint', 'coffee']

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['watch']

  grunt.registerTask 'configure', 'Hydrates JSON files from example files under config', ->
    grunt.file.expand('./config/*.json.example').forEach (src) ->
      dest = src.replace(/\.example$/, '')
      grunt.file.copy(src, dest) unless grunt.file.exists(dest)