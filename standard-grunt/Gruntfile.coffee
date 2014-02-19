module.exports = (grunt) ->
	config =
		pkg: grunt.file.readJSON("package.json")
		basePath: './src/DR.KV2013.Web'

		# LESS
		less:
			dev:
				options:
					paths: ["<%=basePath%>/content/less"]
					yuicompress: false
				files:
					"<%=basePath%>/content/build/base.css": "<%=basePath%>/content/less/base.less"
					"<%=basePath%>/content/build/base-live.css": "<%=basePath%>/content/less/base-live.less"
					"<%=basePath%>/content/build/external-banner-live.css": "<%=basePath%>/content/less/external/external-banner-live.less"

			prod:
				options:
					paths: ["<%=basePath%>/content/less"]
					yuicompress: true
				files:
					"<%=basePath%>/content/build/base.css": "<%=basePath%>/content/less/base.less"
					"<%=basePath%>/content/build/base-live.css": "<%=basePath%>/content/less/base-live.less"
					"<%=basePath%>/content/build/external-banner-live.css": "<%=basePath%>/content/less/external/external-banner-live.less"


		# Uglify
		uglify:
			dev:	
				options:
						compress: false
						mangle: false
						beautify: true
						sourceMap: "<%=basePath%>/content/build/kv13-temp.js.map"
						sourceMappingURL: (path) ->
							return path.slice(path.lastIndexOf('/') + 1) + ".map"
				files:
						"<%=basePath%>/content/build/kv13.js": "<%=basePath%>/content/scripts/*.js"

						"<%=basePath%>/content/build/kv13-live.js": [
							"<%=basePath%>/content/scripts/base.js"
							"<%=basePath%>/content/scripts/Map.js"
                            "<%=basePath%>/content/scripts/Profile.js"
							"<%=basePath%>/content/scripts/UserSetting.js"
							"<%=basePath%>/content/scripts/Graphs.js"
							"<%=basePath%>/content/scripts/dr-exploratory-search.js"
							"<%=basePath%>/content/scripts/newsletter-subscription.js"
							"<%=basePath%>/content/scripts/Live-important-top-links.js"
							"<%=basePath%>/content/scripts/Live-scribbles.js"
							"<%=basePath%>/content/scripts/LiveAreaList.js"
							"<%=basePath%>/content/scripts/LivePlayer.js"
							"<%=basePath%>/content/scripts/LiveTop.js"
						]

			prod:	
				options:
						compress: true
						mangle: false
						beautify: false
						sourceMap: "<%=basePath%>/content/build/kv13-temp.js.map"
						sourceMappingURL: (path) ->
							return path.slice(path.lastIndexOf('/') + 1) + ".map"
				files:
						"<%=basePath%>/content/build/kv13.js": "<%=basePath%>/content/scripts/*.js"

						

			external:
				options:
						compress: true
						mangle: false
						beautify: false
				files:
						"<%=basePath%>/content/build/external/package01.js": [
							"<%=basePath%>/content/scripts/Map.js"
                            "<%=basePath%>/content/scripts/Profile.js"
						]

		# Avoid EOF errors occured in ST
		clean: 
			all:
				src: ["<%=basePath%>/content/build/*"]
			temps:
				src: ["<%=basePath%>/content/build/*-temp*"]

		"string-replace":
			pathFix:
				files:
					"<%=basePath%>/content/build/kv13.js.map": "<%=basePath%>/content/build/kv13-temp.js.map"
				options:
					replacements: [
						pattern: /"\.\/src\/DR\.KV2013\.Web\/content\//ig
						replacement: "\"../"
					]	

		# Watch
		watch:
			styles:
				files: ["<%=basePath%>/content/less/*.less","<%=basePath%>/content/less/external/*.less"]
				tasks: ["less:dev"]
			scripts:
				files: ["<%=basePath%>/content/scripts/*.js"]
				tasks: ["uglify:dev", "uglify:external"]


	# Initialize config
	grunt.initConfig(config)

	# Load NPM Tasks
	grunt.loadNpmTasks("grunt-contrib-less")
	grunt.loadNpmTasks("grunt-contrib-uglify")
	grunt.loadNpmTasks('grunt-contrib-clean')
	grunt.loadNpmTasks('grunt-string-replace')
	grunt.loadNpmTasks("grunt-contrib-watch")

	# Register tasks
	grunt.registerTask "dev", "Development build (will be watching!)", ->
		grunt.config.set("build", "dev")
		grunt.task.run("clean:all", "less:dev", "uglify:dev", "string-replace", "clean:temps", "uglify:external", "watch")

	grunt.registerTask "prod", "Production build", ->
		grunt.config.set("build", "prod")
		grunt.task.run("clean:all", "less:prod", "uglify:prod", "uglify:external", "string-replace", "clean:temps")

	grunt.registerTask "external", "Only build external files", ->
		grunt.config.set("build", "ext")
		grunt.task.run("uglify:external")

	# Default, list avaliable tasks
	grunt.registerTask "default", "", ->
		grunt.log.writeln("")
		grunt.log.writeln("    Usage:")
		grunt.log.writeln("")
		grunt.log.writeln("        grunt dev        For development build. Will be watching folders for changes and compile accordingly.")
		grunt.log.writeln("        grunt prod       For production builds only. Will also uglify and compress.")