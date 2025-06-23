ACTIVATE=./venv/bin/activate
SETUP=source $(ACTIVATE)

ifndef CHPL_WWW
CHPL_WWW=..
endif

PUBLIC_DIR = ./public
WEBSITE_DIR = $(CHPL_WWW)/chapel-lang.org

default: preview

preview: clean $(ACTIVATE)
# have hugo populate 'public/' with the files it'll build
	hugo build
# link to all other website content to avoid broken links to it (e.g., blog)
	-ln -s $(WEBSITE_DIR)/* $(PUBLIC_DIR)/ >& /dev/null
# have hugo serve result (will also re-build)
	hugo serve

www web html: clean $(ACTIVATE)
	hugo
	cp -r $(PUBLIC_DIR)/* $(CHPL_WWW)/chapel-lang.org/

news: $(ACTIVATE)
	$(SETUP) && python3 ./util/process_rss.py

clean:
	rm -rf $(PUBLIC_DIR)

clobber: clean
	rm -rf ./venv

check-artifacts: $(ACTIVATE)
	git diff main ./data/artifacts.toml > /tmp/artifacts-diff.tmp
	# run check_unused_artifacts.py, making sure to cleanup tmp file after
	# as well as preserve exit code
	STATUS=1; \
	python3 ./check_unused_artifacts.py ./data/artifacts.toml /tmp/artifacts-diff.tmp || STATUS=$$?; \
	rm /tmp/artifacts-diff.tmp; \
	exit $$STATUS

$(ACTIVATE):
	python3 -m venv ./venv
	$(SETUP) && pip install -r requirements.txt

.PHONY: default preview www web html news clean clobber
