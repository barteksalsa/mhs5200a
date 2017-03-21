# send with command  "ascii-xfr -svn -l 500"
# 500ms between lines seem to secure correct data upload

BEGIN {
    ct = 0
    chunk = 0
    printf(":\n")
}

function printCmdDefineChunk() {
    printf(":a%1x%1x",chan,chunk);
}

function raiseError() {
    print "Error: too much data"
    exit(1);
}


# ignore anything which is not a number
($0 !~ /^[0-9]+$/) { next; }

(chunk >= 16) { raiseError(); }

(ct == 0) {
    printCmdDefineChunk();
}

(ct != 0) { printf(","); }

{
    gsub("\"","");
    gsub("[ \t\r\n]","");

    printf("%d",$i);  # times 2 because buffer seems to be 2048
    ct = ct + 1;
}

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
