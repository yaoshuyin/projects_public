#!/bin/bash
sub_old=a.com
sub_new=z.com

for n in *
do
  mv $n ${n/$sub_old/$sub_new};
done