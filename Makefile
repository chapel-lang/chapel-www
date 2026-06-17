ifndef CHPL_WWW
CHPL_WWW=.
endif

SRC_DIR = $(CHPL_WWW)/src
UTIL_DIR = $(SRC_DIR)/util
PUBLIC_DIR = $(SRC_DIR)/public
WEBSITE_DIR = $(CHPL_WWW)/chapel-lang.org

ACTIVATE=$(SRC_DIR)/venv/bin/activate
SETUP=. $(ACTIVATE)

default: preview

preview: clean $(ACTIVATE)
# have hugo populate 'public/' with the files it'll build
	cd $(SRC_DIR) && hugo build
# link to all other website content to avoid broken links to it (e.g., blog)
	$(MAKE) linkstuff
# have hugo serve result (will also re-build)
	cd $(SRC_DIR) && hugo serve

www web html: clean $(ACTIVATE)
	cd $(SRC_DIR) && hugo
	$(MAKE) linkstuff
#	cp -r $(PUBLIC_DIR)/* $(CHPL_WWW)/chapel-lang.org/
	rsync -avh --no-times --no-links --checksum $(PUBLIC_DIR)/* $(CHPL_WWW)/chapel-lang.org/ --delete

publish:
	$(UTIL_DIR)/updateWWW.bash

linkstuff:
	-ln -s $(WEBSITE_DIR)/* $(PUBLIC_DIR)/ >& /dev/null
	-ln -s $(WEBSITE_DIR)/presentations/* $(PUBLIC_DIR)/presentations/ >& /dev/null
	-ln -s $(WEBSITE_DIR)/papers/* $(PUBLIC_DIR)/papers/ >& /dev/null
	-ln -s $(WEBSITE_DIR)/tutorials/* $(PUBLIC_DIR)/tutorials/ >& /dev/null
	-ln -s $(WEBSITE_DIR)/chapelcon/* $(PUBLIC_DIR)/chapelcon/ >& /dev/null

news:
	@echo "'make news' is no longer meaningful; just go straight to 'make www'"

clean:
	rm -rf $(PUBLIC_DIR)

clobber: clean
	rm -rf $(PUBLIC_DIR)/venv

checks: lint-artifacts check-unused-artifacts

lint-artifacts:
	python3 $(UTIL_DIR)/lint_artifacts.py $(SRC_DIR)/data/artifacts.toml

check-unused-artifacts: $(ACTIVATE)
	git diff main > /tmp/artifacts-diff.tmp
	# run check_unused_artifacts.py, making sure to cleanup tmp file after
	# as well as preserve exit code
	STATUS=0; \
	python3 $(UTIL_DIR)/check_unused_artifacts.py $(SRC_DIR)/data/artifacts.toml /tmp/artifacts-diff.tmp || STATUS=$$?; \
	rm /tmp/artifacts-diff.tmp; \
	exit $$STATUS

$(ACTIVATE):
	cd $(SRC_DIR) && python3 -m venv ./venv
	cd $(SRC_DIR) && $(SETUP) && pip install -r requirements.txt

.PHONY: default preview www web html publish linkstuff news clean clobber checks lint-artifacts check-unused-artifacts
