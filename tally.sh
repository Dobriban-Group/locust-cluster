#!/bin/bash
(echo "JOB  PARTITION  USER  NAME  CPU  RAM  GPU  STATUS  TMAX  TUSED  NODES" && \
  squeue --noheader --Format='JobArrayID:.12 ,Partition:12 ,UserName:10 ,Name: ,NumCPUs:10 ,MinMemory: ,TRES:60 ,State:10 ,TimeLimit:.15 ,TimeUsed:.15 ,NodeList' "$@") |\
  sed -E 's/(cpu=[^,]*,|mem=[^,]*,|node=[^,]*,|billing=[^,]*,?)+//g' | column -t
