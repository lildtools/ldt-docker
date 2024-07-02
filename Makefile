.SILENT: default
default: clean build

###########################################################################
.SILENT: clean
.SILENT: clean-dist
.SILENT: clean-docs
.SILENT: clean-out
.SILENT: install
.SILENT: install-dependencies
.SILENT: build
.SILENT: compile
.SILENT: compile-usage
.SILENT: compile-version
.SILENT: watch
.SILENT: test
.SILENT: e2e
.SILENT: docs-generate
.SILENT: git-changelog
.SILENT: git-release

###########################################################################
APP_NAME        := ldt-docker
APP_DESCRIPTION := "Lightweight docker wrapper for \"ldt\"projects"
APP_LINK        := "https://lildworks.hu/lildtools/ldt-docker/about.html"
APP_VERSION     := 1.0.0-SNAPSHOT
APP_CODENAME    := LDTDCKR
APP_CMD         := ldtdckr

DIST            := ./dist/
DIST_FILE       := ./dist/${APP_NAME}.sh

DOCS            := ./docs/

SRC             := ./src/
SRC_APP         := ./src/main/sh/app/
SRC_TASKS       := ./src/main/sh/tasks/
SRC_RESOURCES   := ./src/main/resources/
SRC_TEST_OUT    := ./out/

###########################################################################
clean:
	((echo "[${APP_CODENAME}] clean...") && \
	 (make clean-dist clean-docs clean-out --silent) && \
	 (echo "[${APP_CODENAME}] clean."))

clean-dist:
	((echo "[${APP_CODENAME}] clean:dist...") && \
	 (if [ -d ${DIST} ]; then rm -rf ${DIST}; fi) && \
	 (echo "[${APP_CODENAME}] clean:dist."))

clean-docs:
	((echo "[${APP_CODENAME}] clean:docs...") && \
	 (if [ -d ${DOCS} ]; then rm -rf ${DOCS}; fi) && \
	 (echo "[${APP_CODENAME}] clean:docs."))

clean-out:
	((echo "[${APP_CODENAME}] clean:out...") && \
	 (if [ -d ${SRC_TEST_OUT} ]; then rm -rf ${SRC_TEST_OUT}; fi) && \
	 (echo "[${APP_CODENAME}] clean:out."))

install:
	((echo "[${APP_CODENAME}] install...") && \
	 (make install-dependencies --silent) && \
	 (echo "[${APP_CODENAME}] install."))

install-dependencies:
	((echo "[${APP_CODENAME}] install:dependencies...") && \
	 (apt-get update) && \
	 (apt-get install -y inotify-tools) && \
	 (echo "[${APP_CODENAME}] install:dependencies."))

build:
	((echo "[${APP_CODENAME}] build...") && \
	 (if [ ! -d ${DIST} ]; then mkdir ${DIST}; fi) && \
	 (make --silent compile) && \
	 (echo "[${APP_CODENAME}] build."))

compile:
	((echo "[${APP_CODENAME}] compile...") && \
	 (if [ -f ${SRC_RESOURCES}USAGE.txt ]; then make compile-usage --silent; fi) && \
	 (if [ -f ${PWD}/VERSION ]; then make compile-version --silent; fi) && \
	 (cat ${SRC_APP}main.sh >${DIST_FILE}) && \
	 (cat ${SRC_APP}parser.sh >>${DIST_FILE}) && \
	 (cat ${SRC_APP}loader.sh >>${DIST_FILE}) && \
	 (cat ${SRC_APP}validator.sh >>${DIST_FILE}) && \
	 (cat ${SRC_APP}router.sh >>${DIST_FILE}) && \
	 (find ${SRC_TASKS} -name '*.sh' -exec cat "{}" \; >>${DIST_FILE}) && \
	 (cat ${SRC_APP}runner.sh >>${DIST_FILE}) && \
	 (chmod 700 ${DIST_FILE}) && \
	 (echo "[${APP_CODENAME}] compile."))

compile-usage:
	((echo "[${APP_CODENAME}] compile:usage...") && \
	 (echo "doPrintUsage() {">${SRC_TASKS}doPrintUsage.sh) && \
	 (echo "echo \"=============================================">>${SRC_TASKS}doPrintUsage.sh) && \
	 (cat ${SRC_RESOURCES}USAGE.txt >>${SRC_TASKS}doPrintUsage.sh) && \
	 (echo "\"">>${SRC_TASKS}doPrintUsage.sh) && \
	 (echo "}">>${SRC_TASKS}doPrintUsage.sh) && \
	 (echo "[${APP_CODENAME}] compile:usage."))

compile-version:
	((echo "[${APP_CODENAME}] compile:version...") && \
	 (echo "doPrintVersion() {">${SRC_TASKS}doPrintVersion.sh) && \
	 (echo "echo \"${APP_NAME} v${APP_VERSION}\"">>${SRC_TASKS}doPrintVersion.sh) && \
	 (echo "}">>${SRC_TASKS}doPrintVersion.sh) && \
	 (echo "[${APP_CODENAME}] compile:version."))

watch:
	((echo "[${APP_CODENAME}] watch:src...") && \
	 (make compile --silent) && \
	 (while inotifywait -q -r -e modify,move,create,delete ./src/main/ >/dev/null; do \
	    make compile --silent; \
	  done;) && \
	 (echo "[${APP_CODENAME}] watch:src."))

test:
	((echo "[${APP_CODENAME}] test:run...") && \
	 (/bin/bash src/test/sh/unit/run-all.sh ${testUnit}) && \
	 (echo "[${APP_CODENAME}] test:run."))

e2e:
	((echo "[${APP_CODENAME}] e2e:run...") && \
	 (/bin/bash src/test/sh/integration/run-all.sh ${testCase}) && \
	 (echo "[${APP_CODENAME}] e2e:run."))

docs-generate:
	((echo "[${APP_CODENAME}] docs:gen...") && \
	 (if [ ! -d ${DOCS} ]; then mkdir ${DOCS}; fi) && \
	 (echo "        ${APP_NAME}" > ${DOCS}/README.txt) && \
	 (echo "==========================" >> ${DOCS}/README.txt) && \
	 (echo "- ${APP_DESCRIPTION}" >> ${DOCS}/README.txt) && \
	 (echo "-- For more informations about this project, please visit the official site:" >> ${DOCS}/README.txt) && \
	 (echo "" >> ${DOCS}/README.txt) && \
	 (echo "|  ${APP_LINK}" >> ${DOCS}/README.txt) && \
	 (echo "" >> ${DOCS}/README.txt) && \
	 (echo "Have fun," >> ${DOCS}/README.txt) && \
	 (echo "< lild />" >> ${DOCS}/README.txt) && \
	 (echo "[${APP_CODENAME}] docs:gen."))

git-changelog:
	((echo "[${APP_CODENAME}] git:changelog...") && \
	 (if [ ! -d ${DOCS} ]; then mkdir ${DOCS}; fi) && \
	 (echo "# ${APP_NAME}" > ${DOCS}/CHANGELOG.md) && \
	 (echo "" >> ${DOCS}/CHANGELOG.md) && \
	 (echo "## Changelog" >> ${DOCS}/CHANGELOG.md) && \
	 (echo "" >> ${DOCS}/CHANGELOG.md) && \
	 (git log --pretty="- %s" >> ${DOCS}/CHANGELOG.md) && \
	 (echo "[${APP_CODENAME}] git:changelog."))

git-release:
	((echo "[${APP_CODENAME}] git:release...") && \
	 (git flow release finish ; git push --all ; git push --tags) && \
	 (echo "[${APP_CODENAME}] git:release."))
