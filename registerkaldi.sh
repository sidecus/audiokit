#!/usr/bin/env bash

echo "/app/kaldilibs" > /etc/ld.so.conf.d/libkaldi-feat.conf
echo "/app/kaldilibs" > /etc/ld.so.conf.d/libkaldi-util.conf
echo "/app/kaldilibs" > /etc/ld.so.conf.d/libkaldi-matrix.conf
echo "/app/kaldilibs" > /etc/ld.so.conf.d/libkaldi-base.conf
echo "/app/kaldilibs" > /etc/ld.so.conf.d/libkaldi-transform.conf
echo "/app/kaldilibs" > /etc/ld.so.conf.d/libkaldi-gmm.conf
echo "/app/kaldilibs" > /etc/ld.so.conf.d/libkaldi-tree.conf
ldconfig
