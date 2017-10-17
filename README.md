# gb2fasta.pl
Perl script to convert GenBank records to FASTA format

The program reads a file with one or multiple genbank records and extract the senquences in FASTA format. The script can also retrieve some meta-data, such as voucher name and geographic location.

## Just download the code

    wget https://raw.githubusercontent.com/santiagosnchez/gb2fasta/master/gb2fasta.pl

## Or install (UNIX systems)

    git clone https://github.com/santiagosnchez/gb2fasta
    cd GetPhased
    chmod +x getPhased.pl
    sudo cp getPhased.pl /usr/local/bin

## Running the code

Use the `-h` flag for more details:

    perl gb2fasta.pl -h
    
    Try:
    perl gb2fasta.pl -gb <gb.file> -out <outfile.fasta> [options]
    Options:
    -geo    will include only records with a geographic location
    -oc     will only include the country if the record has a geographic location
    -nv     will exclude the voucher label
