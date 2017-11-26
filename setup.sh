#!/bin/bash
result=${PWD##*/} 
if [ $result != VSCodeProcessingBoilerPlate ]
then
  alias git=hub
  git remote remove origin
  hub create
  mv VSCodeProcessingBoilerPlate.pde $result.pde
  echo 'Done!'
fi