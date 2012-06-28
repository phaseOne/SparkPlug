BOOTSTRAP = ./prod/assets/css/bootstrap.css
BOOTSTRAP_LESS = ./dev/less/bootstrap/bootstrap.less
BOOTSTRAP_RESPONSIVE = ./prod/assets/css/bootstrap-responsive.css
BOOTSTRAP_RESPONSIVE_LESS = ./dev/less/bootstrap/responsive.less
DATE=$(shell date +%I:%M%p)
CHECK=\033[32m✔\033[39m
HR=\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#


#
# BUILD SparkPlug
#

build:
	@echo "\n${HR}"
	@echo "Building SparkPlug..."
	@echo "This is a modified Bootstrap script"
	@echo "${HR}\n"
	@rm -rf prod
	@mkdir -p prod/assets/{img,js,css}
	@echo "Creating directories...                     ${CHECK} Done"
	@./node_modules/jshint/bin/hint dev/js/* --config dev/js/.jshintrc
	@echo "Running JSHint on javascript...             ${CHECK} Done"
	@./node_modules/recess/bin/recess --compress ${BOOTSTRAP_LESS} > ${BOOTSTRAP}
	@./node_modules/recess/bin/recess --compress ${BOOTSTRAP_RESPONSIVE_LESS} > ${BOOTSTRAP_RESPONSIVE}
	@./node_modules/recess/bin/recess --compress ./dev/less/main.less > ./prod/assets/css/main.css
	@echo "Compiling LESS with Recess...               ${CHECK} Done"
	@node dev/build
	@echo "Compiling mustache templates...             ${CHECK} Done"
	@cp dev/img/* prod/assets/img/
	@echo "Moving images...                            ${CHECK} Done"
	@cat dev/js/*.js > prod/assets/js/main.js
	@./node_modules/uglify-js/bin/uglifyjs prod/assets/js/main.js > prod/assets/js/main.min.js
	@cat dev/js/bootstrap/*.js > prod/assets/js/bootstrap.js
	@./node_modules/uglify-js/bin/uglifyjs -nc prod/assets/js/bootstrap.js > prod/assets/js/bootstrap.min.tmp.js
	@echo "/**\n* Bootstrap.js by @fat & @mdo\n* Copyright 2012 Twitter, Inc.\n* http://www.apache.org/licenses/LICENSE-2.0.txt\n*/" > prod/assets/js/copyright.js
	@cat prod/assets/js/copyright.js prod/assets/js/bootstrap.min.tmp.js > prod/assets/js/bootstrap.min.js
	@rm prod/assets/js/main.js prod/assets/js/bootstrap.js prod/assets/js/copyright.js prod/assets/js/bootstrap.min.tmp.js
	@echo "Compiling and minifying javascript...       ${CHECK} Done"
	@echo "\n${HR}"
	@echo "Bootstrap successfully built at ${DATE}."
	@echo "${HR}\n"
	@echo "Thanks for using Bootstrap,"
	@echo "<3 @mdo and @fat"
	@echo "and Evan Bovie\n"

#
# WATCH SparkPlug FILES
#

watch:
	echo "Watching files..."; \
	watchr -e "watch('dev/.*/.*\.*') { system 'make' }"
