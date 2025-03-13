SPEC := libpdfium.spec

RPMBUILD := rpmbuild
RPMBUILD_ARGS := --define "_sourcedir $(CURDIR)" --define "_builddir $(CURDIR)" --define "_rpmdir $(CURDIR)" --define "_srcrpmdir $(CURDIR)"

.PHONY: all
all:

.PHONY: srpm rpm getsource clean
getsource: $(SPEC)
	spectool -g $<
	./fetch-source.sh

srpm: $(SPEC) getsource
	$(RPMBUILD) $(RPMBUILD_ARGS) -bs $<

rpm: $(SPEC) getsource
	$(RPMBUILD) $(RPMBUILD_ARGS) -bb $<

clean:
	rm *.gz
