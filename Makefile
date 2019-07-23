#
# 4cade Makefile
# assembles source code, optionally builds a disk image and mounts it
# note: Windows users should probably use winmake.bat instead
#
# original by Quinn Dunki on 2014-08-15
# One Girl, One Laptop Productions
# http://www.quinndunki.com/blondihacks
#
# adapted by 4am on 2018-08-19
#

DISK=4cade.2mg
VOLUME=A.4AM.PACK

# third-party tools required to build
# https://sourceforge.net/projects/acme-crossass/
ACME=acme
# https://www.brutaldeluxe.fr/products/crossdevtools/cadius/
# https://github.com/mach-kernel/cadius
CADIUS=cadius

asm: md
	$(ACME) -r build/4cade.lst src/4cade.a 2>build/relbase.log
	$(ACME) -r build/4cade.lst -DRELBASE=`cat build/relbase.log | grep "RELBASE =" | cut -d"=" -f2 | cut -d"(" -f2 | cut -d")" -f1` src/4cade.a
	$(ACME) src/fx/fx.cover.fade.a
	$(ACME) src/fx/fx.dhgr.fizzle.a
	$(ACME) src/fx/fx.dhgr.fizzle.white.a
	$(ACME) src/fx/fx.dhgr.ripple.a
	$(ACME) src/fx/fx.dhgr.ripple.white.a
	$(ACME) src/fx/fx.dhgr.iris.a
	$(ACME) src/fx/fx.dhgr.iris.white.a
	$(ACME) src/fx/fx.dhgr.radial.a
	$(ACME) src/fx/fx.dhgr.radial.white.a
	$(ACME) src/fx/fx.dhgr.radial2.a
	$(ACME) src/fx/fx.dhgr.radial2.white.a
	$(ACME) src/fx/fx.dhgr.radial3.a
	$(ACME) src/fx/fx.dhgr.radial3.white.a
	$(ACME) src/fx/fx.dhgr.radial4.a
	$(ACME) src/fx/fx.dhgr.radial4.white.a
	$(ACME) src/fx/fx.dhgr.radial5.a
	$(ACME) src/fx/fx.dhgr.radial5.white.a
	$(ACME) src/fx/fx.dhgr.star.a
	$(ACME) src/fx/fx.dhgr.star.white.a
	$(ACME) src/fx/fx.hgr.diagonal.a
	$(ACME) src/fx/fx.hgr.interlock.ud.a
	$(ACME) src/fx/fx.hgr.interlock.lr.a
	$(ACME) src/fx/fx.hgr.spiral.a
	$(ACME) src/fx/fx.hgr.fourspiral.a
	$(ACME) src/fx/fx.hgr.fizzle.a
	$(ACME) src/fx/fx.hgr.bar.dissolve.a
	$(ACME) src/fx/fx.hgr.block.fizzle.a
	$(ACME) src/fx/fx.hgr.block.fizzle.white.a
	$(ACME) src/fx/fx.hgr.2pass.lr.a
	$(ACME) src/fx/fx.hgr.crystal.a
	$(ACME) src/fx/fx.hgr.foursquare.white.a
	$(ACME) src/fx/fx.hgr.onesquare.white.a
	$(ACME) src/fx/fx.hgr.diamond.a
	$(ACME) src/fx/fx.hgr.checkerboard.white.a
	$(ACME) src/fx/fx.hgr.halfblock.fizzle.a
	$(ACME) src/fx/fx.hgr.halfblock.fizzle.white.a
	$(ACME) src/fx/fx.hgr.stagger.ud.a
	$(ACME) src/fx/fx.hgr.stagger.ud.white.a
	$(ACME) src/fx/fx.hgr.stagger.lr.a
	$(ACME) src/fx/fx.hgr.stagger.lr.white.a
	$(ACME) src/fx/fx.hgr.corner.circle.a
	$(ACME) src/fx/fx.hgr.sunrise.a
	$(ACME) src/fx/fx.hgr.sunset.a
	$(ACME) src/fx/fx.hgr.radial.a
	$(ACME) src/fx/fx.hgr.radial2.a
	$(ACME) src/fx/fx.hgr.radial3.a
	$(ACME) src/fx/fx.hgr.radial4.a
	$(ACME) src/fx/fx.hgr.radial5.a
	$(ACME) src/fx/fx.hgr.split.ud.intro.a
	$(ACME) src/fx/fx.hgr.iris.a
	$(ACME) src/fx/fx.hgr.ripple.a
	$(ACME) src/fx/fx.hgr.ripple2.a
	$(ACME) src/fx/fx.hgr.star.a
	$(ACME) src/fx/fx.hgr.star.white.a
	$(ACME) src/fx/fx.shr.fizzle.a
	$(ACME) src/fx/fx.gr.fizzle.a

dsk: md asm
	$(CADIUS) CREATEVOLUME build/"$(DISK)" "$(VOLUME)" 32766KB >>build/log
	cp res/_FileInformation.txt build/ >>build/log
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "build/LAUNCHER.SYSTEM" >>build/log
	cp res/prefs.conf build/PREFS.CONF >>build/log
	cp res/credits.txt build/CREDITS >>build/log
	bin/padto 512 build/PREFS.CONF
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "res/TITLE" >>build/log
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "res/COVER" >>build/log
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "build/PREFS.CONF" >>build/log
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "res/GAMES.CONF" >>build/log
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "res/ATTRACT.CONF" >>build/log
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "res/FX.CONF" >>build/log
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "res/DFX.CONF" >>build/log
	$(CADIUS) ADDFILE build/"$(DISK)" "/$(VOLUME)/" "build/CREDITS" >>build/log
	rsync -aP res/title.hgr/* build/TITLE.HGR >>build/log
	bin/buildfileinfo.py build/TITLE.HGR "06" "4000" >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/TITLE.HGR" "build/TITLE.HGR" >>build/log
	rsync -aP res/title.dhgr/* build/TITLE.DHGR >>build/log
	bin/buildfileinfo.py build/TITLE.DHGR "06" "4000" >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/TITLE.DHGR" "build/TITLE.DHGR" >>build/log
	rsync -aP res/action.hgr/* build/ACTION.HGR >>build/log
	bin/buildfileinfo.py build/ACTION.HGR "06" "4000" >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/ACTION.HGR" "build/ACTION.HGR" >>build/log
	rsync -aP res/action.dhgr/* build/ACTION.DHGR >>build/log
	bin/buildfileinfo.py build/ACTION.DHGR "06" "4000" >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/ACTION.DHGR" "build/ACTION.DHGR" >>build/log
	rsync -aP res/action.gr/* build/ACTION.GR >>build/log
	bin/buildfileinfo.py build/ACTION.GR "06" "6000" >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/ACTION.GR" "build/ACTION.GR" >>build/log
	rsync -aP res/artwork.shr/* build/ARTWORK.SHR >>build/log
	bin/buildfileinfo.py build/ARTWORK.SHR "C1" "2000" >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/ARTWORK.SHR" "build/ARTWORK.SHR" >>build/log
	rsync -aP res/attract/* build/ATTRACT >>build/log
	bin/buildfileinfo.py build/ATTRACT "04" "8000" >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/ATTRACT" "build/ATTRACT" >>build/log
	rsync -aP res/ss/* build/SS >>build/log
	bin/buildfileinfo.py build/SS "04" "4000" >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/SS" "build/SS" >>build/log
	rsync -aP res/demo/* build/DEMO >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/DEMO" "build/DEMO" >>build/log
	$(CADIUS) RENAMEFILE build/"$(DISK)" "/$(VOLUME)/DEMO/SPCARTOON.11" "SPCARTOON.1." >>build/log
	$(CADIUS) RENAMEFILE build/"$(DISK)" "/$(VOLUME)/DEMO/SPCARTOON.22" "SPCARTOON.2." >>build/log
	$(CADIUS) RENAMEFILE build/"$(DISK)" "/$(VOLUME)/DEMO/SPCARTOON.33" "SPCARTOON.3." >>build/log
	$(CADIUS) RENAMEFILE build/"$(DISK)" "/$(VOLUME)/DEMO/SPCARTOON.44" "SPCARTOON.4." >>build/log
	$(CADIUS) RENAMEFILE build/"$(DISK)" "/$(VOLUME)/DEMO/SPCARTOON.55" "SPCARTOON.5." >>build/log
	$(CADIUS) RENAMEFILE build/"$(DISK)" "/$(VOLUME)/DEMO/SPCARTOON.66" "SPCARTOON.6." >>build/log
	rsync -aP res/fx/* build/FX >>build/log
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/FX" "build/FX" >>build/log
	$(CADIUS) CREATEFOLDER build/"$(DISK)" "/$(VOLUME)/X/" >>build/log
	bin/do2po.py res/dsk/ build/po/
	rsync -a res/dsk/*.po build/po/
	bin/extract.py build/po/ | sh >>build/log
	rm -f build/X/**/.DS_Store
	rm -f build/X/**/PRODOS
	rm -f build/X/**/LOADER.SYSTEM
	$(CADIUS) ADDFOLDER build/"$(DISK)" "/$(VOLUME)/X" "build/X" >>build/log
	bin/changebootloader.py build/"$(DISK)" res/proboothd

mount: dsk
	osascript bin/V2Make.scpt "`pwd`" bin/4cade.vii build/"$(DISK)"

md:
	mkdir -p build/po
	mkdir -p build/X
	mkdir -p build/TITLE.HGR
	mkdir -p build/TITLE.DHGR
	mkdir -p build/ACTION.HGR
	mkdir -p build/ACTION.DHGR
	mkdir -p build/ACTION.GR
	mkdir -p build/ARTWORK.SHR
	mkdir -p build/ATTRACT
	mkdir -p build/SS
	mkdir -p build/DEMO
	mkdir -p build/FX

clean:
	rm -rf build/ || rm -rf build

all: clean asm dsk mount
