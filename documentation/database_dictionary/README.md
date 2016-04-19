# Adjusted version of pypostgreports 

A collection of generic "reports" that can be run on a Postgres 
database including a data dictionary generator as well as a 
database size report. This is a slightly adjusted python script 
derived from pypostgreports (https://github.com/kylejmcintyre/pypostgreports.git) 
and includes guidelines for how to transform the html-report to a well 
formatted pdf using weasyprint (http://weasyprint.readthedocs.org/en/latest/install.html). 

Note that the data dictionary is intended for Postgres instances
that are thoroughly documented using Postgres comments. 

## Adjustments 

  * Different styling than pypostgreports, closer to the postgres reporting standard.
  * For our specific database: Experimental script for html cleaning (WORK IN PROGRESS) 
  * Conversion from html to pdf or png

## Dependencies
pypostgreports - Tested on Postgres 9.4 and Python 2.7.x and depends on the following Python modules:

  * psycopg2
  * jinja2
  * pandas

These are easily available in Anaconda Python.

WeasyPrint 0.27 - depends on:

  * CPython 2.6, 2.7 or ≥ 3.2
  * cairo [1]
  * Pango
  * CFFI ≥ 0.5
  * lxml ≥ 3.0
  * html5lib ≥ 0.99
  * cairocffi ≥ 0.3
  * tinycss = 0.3
  * cssselect ≥ 0.6
  * CairoSVG ≥ 1.0.20
  * Pyphen ≥ 0.8
  * Optional: GDK-PixBuf [2]

See http://weasyprint.readthedocs.org/en/latest/install.html for installation

## Usage pypostgreports

    usage: ./data_dictionary.py [-h] [--host HOST] [--port PORT] [--user USER]
                                [--pass PASS] [--db DBNAME] [--output OUTPUT]
                                [--title TITLE]
    
    optional arguments:
      -h, --help                 show this help message and exit
      --host HOST                Postgres host
      --port PORT                Postgres port
      --user USER,     -u USER   Postgres user
      --pass PASS,     -p PASS   Postgres password
      --db DBNAME,     -d DBNAME Postgres database
      --output OUTPUT, -o OUTPUT Output file location
      --title  TITLE,  -t TITLE  Title of the report 

Individual reports may have additional arguments beyond these base arguments
shared by all reports. By default, the output file is [name of the report].html
in the current working directory.
    

## Usage weasyprint

    usage: weasyprint [-h] [--version] [-e ENCODING] [-f {pdf,png}]
                      [-s STYLESHEET] [-m MEDIA_TYPE] [-r RESOLUTION]
                      [--base-url BASE_URL] [-a ATTACHMENT]
                      input output

	positional arguments:
	  input                 URL or filename of the HTML input, or - for stdin
      output                Filename where output is written, or - for stdout

	optional arguments:
      --help                        -h             Show this help message and exit
      --version                                    Print WeasyPrint's version number and exit.
      --encoding ENCODING           -e ENCODING    Character encoding of the input
      --format {pdf,png}            -f {pdf,png}   Output format. Can be ommited if `output` ends 
                                                   with a .pdf or .png extension.
      --stylesheet STYLESHEET       -s STYLESHEET  URL or filename for a user CSS stylesheet. May 
                                                   be given multiple times.
      --media-type MEDIA_TYPE       -m MEDIA_TYPE  Media type to use for @media, defaults to print
      --resolution RESOLUTION       -r RESOLUTION  PNG only: the resolution in pixel per CSS inch.
                                                   Defaults to 96, one PNG pixel per CSS pixel.           
      --base-url BASE_URL                          Base for relative URLs in the HTML input. Defaults to
                                                   the input's own filename or URL or the current
                                                   directory for stdin.
      --attachment ATTACHMENT       -a ATTACHMENT  URL or filename of a file to attach to the PDF document

## Example

Pull database_dictionary directory and open 'Data_Dictionary_Script.sh' for a bash-script with the whole procedure.
