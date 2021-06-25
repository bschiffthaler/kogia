#!/bin/bash

if [ ! "${PSEUDOPIPE_ENV:-x}" -eq "x" ]; then
	source $PSEUDOPIPE_ENV;
	return;
fi

# Pseudopipe configuration
export PSEUDOPIPE_HOME=/usr/local/bin/pseudopipe
export pseudopipe=$PSEUDOPIPE_HOME/core/runScripts.py
export genPgeneResult=$PSEUDOPIPE_HOME/ext/genPgeneResult.sh
export genFullAln=$PSEUDOPIPE_HOME/ext/genFullAln.sh
export fastaSplitter=$PSEUDOPIPE_HOME/ext/splitFasta.py
export sqDummy=$PSEUDOPIPE_HOME/ext/sqDummy.py
export blastHandler=$PSEUDOPIPE_HOME/core/processBlastOutput.py
export extractExLoc=$PSEUDOPIPE_HOME/core/extractKPExonLocations.py

# Python configuration
export pythonExec=`which python2`

# Alignment tools configuration
export formatDB=`which formatdb`
export blastExec=`which blastall`
export fastaExec=`which tfasty35`
