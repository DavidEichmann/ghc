TOP=../../..
include $(TOP)/mk/boilerplate.mk
include $(TOP)/mk/test.mk

clean.%:
	rm -rf pkg.$*

HERE := $(abspath .)
$(eval $(call canonicalise,HERE))

package.%:
	$(MAKE) --no-print-directory clean.$*
	mkdir pkg.$*
	"$(TEST_HC)" -outputdir pkg.$* --make -v -o pkg.$*/setup Setup.hs
	
	"$(GHC_PKG)" init pkg.$*/local.package.conf
	
	echo "*** GhcDynamic = $(GhcDynamic)"
	echo "*** DYNAMIC_GHC_PROGRAMS = $(DYNAMIC_GHC_PROGRAMS)"
	echo "*** CABAL_PLUGIN_BUILD = $(CABAL_PLUGIN_BUILD)"
	pkg.$*/setup configure --distdir pkg.$*/dist -v0 $(CABAL_PLUGIN_BUILD) --prefix="$(HERE)/pkg.$*/install" --with-compiler="$(TEST_HC)" --with-hc-pkg="$(GHC_PKG)" --package-db=pkg.$*/local.package.conf $(if $(findstring YES,$(HAVE_PROFILING)), --enable-library-profiling)
	pkg.$*/setup build     --distdir pkg.$*/dist -v0
	pkg.$*/setup install   --distdir pkg.$*/dist -v0
