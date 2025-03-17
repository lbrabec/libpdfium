# make srpm
spec := libpdfium.spec
specdir := $(abspath $(dir $(spec)))
outdir := $(specdir)/out

RPMBUILD := rpmbuild
RPMBUILD_ARGS := --define "_sourcedir $(specdir)" --define "_builddir $(specdir)" --define "_rpmdir $(outdir)" --define "_srcrpmdir $(outdir)"

.PHONY: all
all:

$(outdir):
	mkdir -p $@

.PHONY: srpm rpm getsource clean
getsource: $(spec) $(outdir)
	spectool -C $(specdir) -g $<
	cd $(specdir) && ./fetch-source.sh

srpm: $(spec) getsource
	$(RPMBUILD) $(RPMBUILD_ARGS) -bs $<

rpm: $(spec) getsource
	$(RPMBUILD) $(RPMBUILD_ARGS) -bb $<

clean:
	rm -f $(specdir)/*.gz
