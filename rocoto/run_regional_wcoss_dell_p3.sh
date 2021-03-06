#!/bin/sh -l

set -x

# Home directory of the regional_workflow package
HOMEfv3=/gpfs/dell2/emc/modeling/noscrub/${USER}/regional_workflow

# if want a non-CONUS domain, export DOMAIN here
doms="hi"

# for DOMAIN in $doms
# do
# export DOMAIN


cd ${HOMEfv3}/rocoto

source ./config.workflow.defaults

machine=wcoss_dell_p3 
SITE_FILE="sites/${machine}.ent"
CPU_ACCOUNT=HREF-T2O

# Experiment name
EXPT=fv3sartest
# First, last, and interval of the workflow cycles
CYCLE_YMDH_BEG="2019083012"
CYCLE_YMDH_END="2019103112"
CYCLE_INT_HH="12"

GET_INPUT=NO
COMINgfs=/gpfs/dell1/nco/ops/com/gfs/prod
STMP=/gpfs/dell1/stmp/${USER}/${EXPT}
PTMP=/gpfs/dell1/ptmp/${USER}/${EXPT}

if [ ! -e ${PTMP} ] ; then
  mkdir -p $PTMP
fi

if [ ! -e ${STMP} ] ; then
  mkdir -p $STMP
fi

# The workflow files of the experiment
expxml=${EXPT}_${CYCLE_YMDH_BEG}.xml
expdb=${EXPT}_${CYCLE_YMDH_BEG}.db

# Generate the workflow definition file by parsing regional_workflow.xml.in
sed -e "s|@\[EXPT.*\]|${EXPT}|g" \
    -e "s|@\[GTYPE.*\]|${GTYPE}|g" \
    -e "s|@\[DOMAIN.*\]|${DOMAIN}|g" \
    -e "s|@\[CYCLE_YMDH_BEG.*\]|${CYCLE_YMDH_BEG}|g" \
    -e "s|@\[CYCLE_YMDH_END.*\]|${CYCLE_YMDH_END}|g" \
    -e "s|@\[CYCLE_INT_HH.*\]|${CYCLE_INT_HH}|g" \
    -e "s|@\[USER.*\]|${USER}|g" \
    -e "s|@\[CPU_ACCOUNT.*\]|${CPU_ACCOUNT}|g" \
    -e "s|@\[SITE_FILE.*\]|${SITE_FILE}|g" \
    -e "s|@\[HOMEfv3.*\]|${HOMEfv3}|g" \
    -e "s|@\[PTMP.*\]|${PTMP}|g" \
    -e "s|@\[STMP.*\]|${STMP}|g" \
    -e "s|@\[MAKE_GRID_OROG.*\]|${MAKE_GRID_OROG}|g" \
    -e "s|@\[MAKE_SFC_CLIMO.*\]|${MAKE_SFC_CLIMO}|g" \
    -e "s|@\[GET_INPUT.*\]|${GET_INPUT}|g" \
    -e "s|@\[COMINgfs.*\]|${COMINgfs}|g" \
    regional_workflow.xml.in \
    > ${expxml}

# Run the workflow for the experiment
rocotorun -v 10 -w ${expxml} -d ${expdb}

echo 'job done'

# done
