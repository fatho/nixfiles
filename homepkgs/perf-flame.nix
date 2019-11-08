#
{ linuxPackages, flamegraph, bash, writeTextFile, ... }:
writeTextFile {
    name = "perf-flame";
    destination = "/bin/perf-flame";
    executable = true;
    text = ''
        #!${bash}/bin/bash
        export PATH=${linuxPackages.perf}/bin:${flamegraph}/bin
        perf script | stackcollapse-perf.pl | flamegraph.pl
    '';
}