outdir:=out
compile:=sim.veriwell
ifneq ($(OutRootDir),)
outdir:=$(OutRootDir)/$(shell basename $(shell pwd))/$(outdir)
endif
outdir_prefix=$(outdir)
ifneq ($(out),)
outdir:=$(outdir)-$(out)
endif

run waveform debug:
ifneq ($(wildcard ./.isout),)
	@$(MAKE) -f Makefile.$(compile) $@
else
ifneq ($(outdir),)
	@echo run output: $(outdir)
	@if [ ! -d $(outdir) ]; then \
		mkdir -p $(outdir); \
		/bin/ln -srf * $(outdir); \
		touch $(outdir)/.isout; \
		if [ -n "$(OutRootDir)" ]; then \
			ln -s $(outdir) .; \
		fi; \
	fi
	@$(MAKE) -C $(outdir) outdir= -f Makefile.$(compile) $@
endif
endif

realclean:
	rm -rf $(outdir_prefix)* $(shell basename $(outdir_prefix))*

clean:
	rm -rf $(outdir) $(shell basename $(outdir))
