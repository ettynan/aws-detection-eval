#!/bin/bash
for i in $(seq 1 100); 
do 
  AWS_ACCESS_KEY_ID=AKIAV6DQ5IUWRLQUPQ6E AWS_SECRET_ACCESS_KEY='z1Xf2mbuV5S0hHfuBUpTRVTdAwtW/7qzl7ZaVD' aws sts get-caller-identity --region us-west-2; 
done >error.log 2>&1

scp -i ~/.ssh/id-do root@165.22.71.7:~/error.log .
