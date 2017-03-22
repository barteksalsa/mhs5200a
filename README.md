About setwave5200
=================

**This is an early, but working, work in progress.**

The repository itself is forked from [link](https://github.com/wd5gnr/mhs5200a). That repository provides a lot of useful information. Please visit it first.

# Motivation

Scripts in the original repository have constraints:

* work only in Linux environment
* apply to a MHS5200a version which has 8-bit converter and has buffer size of 1024

They simply do not work with my hardware which seems to have:

* 12-bit samples mean available value range from 0 (-1/2 of amplitude) to 4095 (+1/2 of amplitude)
* 128 bytes per chunk
* signal buffer consisting of 2048 samples
* no RTS/CTS flow control

These are conclusions from my reverse-engineering efforts.

# Constraints

The scripts should work under any OS that has:

* gawk (GNU awk) 
* python 2.7
* minicom or any equivalent software for uploading files over UART

# Workflow

The typical workflow is the following:

* generate waveform data using an excel sheet or python script and put them in a file one value in a line (like in csv)
* make a serie of commands out of these values
* upload this file to the device
