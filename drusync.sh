#!/bin/bash

for arg
do
    delim=""
    case "$arg" in
    #translate --gnu-long-options to -g (short options)
       --local-docroot) args="${args}-r ";;
       --remote-www-server) args="${args}-h ";;
       --remote-ssh-user) args="${args}-u ";;
       --remote-database-name) args="${args}-d ";;
       --remote-database-user) args="${args}-b ";;
       --remote-database-pass) args="${args}-p ";;
       --remote-database-host) args="${args}-o ";;
       --local-database-name) args="${args}-l ";;
       --local-database-user) args="${args}-s ";;
       --local-database-pass) args="${args}-a ";;
       --remote-files-dir) args="${args}-f ";;
       --local-files-dir) args="${args}-i ";;
       #pass through anything else
       *) [[ "${arg:0:1}" == "-" ]] || delim="\""
           args="${args}${delim}${arg}${delim} ";;
    esac
done
 
#Reset the positional parameters to the short options
eval set -- $args
 
while getopts "r:h:u:d:b:p:o:l:s:a:f:i:" opt;
do
    case $opt in
        r) PROJECTROOT="$OPTARG";;
        h) PROJECTHOST="$OPTARG";;
        u) REMOTESSHUSER="$OPTARG";;
        d) REMOTEDB="$OPTARG";;
        b) REMOTEDBUSER="$OPTARG";;
        p) REMOTEDBPASS="$OPTARG";;
        o) REMOTEDBHOST="$OPTARG";;
        l) LOCALDB="$OPTARG";;
        s) LOCALDBUSER="$OPTARG";;
        a) LOCALDBPASS="$OPTARG";;
        f) REMOTEFILESDIR="$OPTARG";;
        i) LOCALFILESDIR="$OPTARG";;
    esac
done


REMOTEFILE="/home/$REMOTESSHUSER/mysqldump.sql"
# path this script will use to save it local working file - should be ok on any linux computer
LOCALFILE="/tmp/mysqldump.sql"

echo "Updating SVN at $PROJECTROOT ..."
svn update $PROJECTROOT

REMOTEFILE_GZ="$REMOTEFILE.gz"
LOCALFILE_GZ="$LOCALFILE.gz"
echo "Dumping DB.."

ssh $REMOTESSHUSER@$PROJECTHOST "\
	mysqldump \
		--add-drop-table \
		--add-locks \
		--complete-insert \
		--extended-insert \
		--host=$REMOTEDBHOST \
		--user=$REMOTEDBUSER \
		--password=$REMOTEDBPASS \
		$REMOTEDB > $REMOTEFILE && \
		gzip -9 $REMOTEFILE"
echo "Copying dump..."
scp $REMOTESSHUSER@$PROJECTHOST:$REMOTEFILE_GZ $LOCALFILE_GZ
echo "Removing remote dump..."
ssh $REMOTESSHUSER@$PROJECTHOST "rm $REMOTEFILE_GZ"
echo "Importing dump..."
gunzip < $LOCALFILE_GZ | mysql \
	--user=$LOCALDBUSER \
	--password=$LOCALDBPASS \
    	--show-warnings \
	$LOCALDB
echo "Removing local dump..."
rm $LOCALFILE_GZ
echo "Syncing files directory..."
rsync -r $REMOTESSHUSER@$PROJECTHOST:$REMOTEFILESDIR $LOCALFILESDIR
echo "Drupal Sync complete!"

