# make srpm
spec := libpdfium.spec
outdir := $(CURDIR)

RPMBUILD := rpmbuild
RPMBUILD_ARGS := --define "_sourcedir $(CURDIR)" --define "_builddir $(CURDIR)" --define "_rpmdir $(outdir)" --define "_srcrpmdir $(outdir)"

.PHONY: all
all:

.PHONY: srpm rpm getsource clean
getsource: $(spec)
	spectool -g $<
	./fetch-source.sh

srpm: $(spec) getsource
	$(RPMBUILD) $(RPMBUILD_ARGS) -bs $<

rpm: $(spec) getsource
	$(RPMBUILD) $(RPMBUILD_ARGS) -bb $<

clean:
	rm *.gz
