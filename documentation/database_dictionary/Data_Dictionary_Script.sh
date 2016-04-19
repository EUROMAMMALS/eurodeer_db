## CREATE HTML DICTIONARY
    
    cd GIT/eurodeer_db/documentation/database_dictionary # your folder where Eurodeer GIT is stored
    ./data_dictionary.py --host xxxxxx --port xxxxxx --user xxxxxx --pass xxxxxx --db xxxxxx --title eurodeer_db_report # see README

## PROCESS HTML DICTIONARY 
	
	mv data_dictionary.html  result/data_dictionary.html # move data_dictionary.html to results dir
	cp report.css  result/report.css  # copy report css to results dir
	cd result  
	
# Remove whitespace | perl script that removes duplicate lines that are identical for the 40 first characters | remove redundant table information for schema's (activity_data_raw, public, temp and ws_schema's)

    sed '/^\s*$/d' data_dictionary.html | # whitespace
    perl -C -ne '$c = substr($_,0,40); print unless $c eq $l; $l = $c;' | # duplicates
    sed '/[<]h4[>]This schema stores the raw activity data that have still to be (partially) processed to be analyzed and merged together.[<][/]h4[>]/,/[<]h2[>]/{//!d}' | # remove tables schema activity_data_raw
    sed '/[<]h4[>]standard public schema[<][/]h4[>]/,/[<]h2[>]/{//!d}'  | # remove tables schema public 
    sed '/Elements stored in this schema can be deleted at any time by the database administrator.[<][/]h4[>]/,/[<]h2[>]/{//!d}' | # remove tables schema temp 
    sed  '/No other users will have access to this schema.[<][/]h4[>]/,/[<]h2[>]/{//!d}' > 2_data_dictionary_processed.html # remove tables schema's ws

# Remove manually duplicated rows for "notes", "geom_mcp_individuals", "geom_traj_buffer" (I don't know how to automate) -> open "2_data_dictionary_processed.html" to find these duplicates -> Saved as 3_DATA_DICTIONARY.html

# 3. Optionally add table of content in html file (copy paste in html and remove #)
    
	#    <h5>This file is a report generated from the EuroDEER postgres database. It describes all tables and related columns of the main schema's</h5> 

	#	 <table class="min"><th>Table of Content</th>
	#    <tr><td>activity_data_raw schema</td></tr>
	#    <tr><td>analysis schema</td></tr>
	#    <tr><td>env_data schema</td></tr>
	#    <tr><td>env_data_ts schema</td></tr>
	#    <tr><td>lu_tables schema</td></tr>
	#    <tr><td>main schema</td></tr>
	#    <tr><td>main_reddeer schema</td></tr>
	#    <tr><td>public schema</td></tr>
	#    <tr><td>temp schema</td></tr>
	#    <tr><td>tools schema</td></tr>
	#    <tr><td>ws_xxx schema</td></tr>
	#    </table>
	#    <br />

## CONVERT HTML DICTIONARY TO PDF

weasyprint 3_DATA_DICTIONARY.html -e UTF8 -f pdf -s report.css 3_DATA_DICTIONARY.pdf

## REMOVE REDUNDANT FILES

rm 2_data_dictionary_processed.html
rm data_dictionary.html
