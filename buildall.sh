#!/bin/bash
OUTDIR=
SOURCE=

function build_all() {
  OUTDIR=~/COMPLETED
  SOURCE=~/WORKING_DIRECTORY
  BEGIN=$(date +%s)
  ROMS="cm du rr aicp aosip pn screwd omni abc"
  cd ${SOURCE}
  for ROM in ${ROMS}
  do 
    repo init -u https://github.com/InterestingTwist/${ROM}_manifest.git 
    repo sync -j4 --force-sync
    source build/envsetup.sh
    mka clean
    # Build the below devices 
    DEVICES="angler bullhead shamu"
    for DEVICE in ${DEVICES}
    do
      brunch ${DEVICE}
      mv ${SOURCE}/out/target/product/${DEVICE}/*${DEVICE}*.zip ${OUTDIR}
      mka clean
    done
  done
  # End
  END=$(date +%s)
  cd ~/
  echo "${green}All builds complete!${reset}"
  echo "${green}Total time elapsed: $(echo $(($END-$BEGIN)) | awk '{print int($1/60)"mins "int($1%60)"secs "}')${reset}"
}
