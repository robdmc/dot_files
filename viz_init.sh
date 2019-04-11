 # Function to initialize the conda viz env
 function viz.init () { 
     set +o history
     . ~/rcconda.sh
     . activate viz2
     set -o history
 }

