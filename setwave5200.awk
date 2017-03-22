# use with awk:
#              cat wave.csv | awk -f "setwave5200.awk"
# send with command  "ascii-xfr -svn -l 500"
# 500ms between lines seem to secure correct data upload

BEGIN {
    ct = 0
    chunk = 0
    printf(":\n")   # to finish any ongoing command
}

function printCmdDefineChunk() {
    printf(":a%1x%1x",chan,chunk);
}

function raiseError() {
    print "Error: too much data"
    exit(1);
}

#
#  FOR EACH CSV LINE
#

# ignore anything which is not a number
($0 !~ /^[0-9]+$/) { next; }

# maximum number of chunks is 16 by the protocol design. (0xf)
(chunk >= 16) { raiseError(); }

# when first number is read in a chunk, command should be printed 
(ct == 0) {
    printCmdDefineChunk();
}

# when not first, continue with inserted ","
(ct != 0) { printf(","); }

{
    gsub("\"","");
    gsub("[ \t\r\n]","");

    printf("%d",$i);
    ct = ct + 1;
}

# in one chunk there is 128 values. End the line and start a new chunk
(ct == 128) {
    ct = 0;
    print ""
    chunk = chunk + 1
}

END { # print ending commands
    print ":s1f0000000100";      # set 1Hz
    print ":r1f";                # read back freq
    print ":s1w" (32+chan)       # select arbitrary waveform chan
}
