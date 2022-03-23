ALPINE=3.14
EXEC=diamond
VERSION=2.0.14
SOURCES=Dockerfile Makefile test.py

all: release

prog/.setup.done:
	mkdir -p test.py.data
	mkdir -p prog
	touch prog/.setup.done

prog/alpine: prog/.setup.done
	docker pull alpine:${ALPINE}
	touch prog/alpine

prog/docker: prog/alpine
	docker build --no-cache -t ${EXEC} --build-arg BUILD_NCPU=8 .
	touch prog/docker

prog/singularity: prog/docker
	singularity build ./test.py.data/${EXEC}.sif docker-daemon://${EXEC}:latest
	touch prog/singularity

prog/.tests.setup: prog/singularity
	touch prog/.tests.setup

prog/.tests.success: prog/.tests.setup
	avocado run test.py
	touch prog/.tests.success

prog/.docker.tags: prog/.tests.success
	docker tag ${EXEC} bschiffthaler/${EXEC}:${VERSION}
	docker tag ${EXEC} bschiffthaler/${EXEC}:latest
	docker push bschiffthaler/${EXEC}:${VERSION}
	docker push bschiffthaler/${EXEC}:latest
	touch prog/.docker.tags

prog/.git.commits: prog/.docker.tags
	git add ${SOURCES}
	git commit -m "Bump ${EXEC}->${VERSION}"
	git tag ${EXEC}/${VERSION}
	git checkout main
	git merge -m "Merge branch ${EXEC} into main" ${EXEC}
	touch prog/.git.commits

release: prog/.git.commits
	rm -rf prog
	rm -rf test.py.data
	rm -rf __pycache__

clean:
	rm -rf test.py.data prog  __pycache__
