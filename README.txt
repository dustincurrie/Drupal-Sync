Bash script that synchronizes a local install of Drupal with a remote install.


DESCRIPTION
-----------

USAGE
-----------

$ drusync [options]


OPTIONS
-----------

All options are required to function correctly

  -r <path>,     --local-docroot=<path>             local Drupal root directory,   e.g. /var/www
  -h <domain>,   --remote-www-server=<domain>       remote domain,                 e.g. www.leveltendesign.com
  -u <username>, --remote-ssh-user=<username>       remote ssh user
  -d <dbname>,   --remote-database-name=<dbname>    remote mysql database name
  -b <username>, --remote-database-user=<username>  remote mysql database user
  -p <pass>,     --remote-database-pass=<pass>      remote mysql database password
  -o <domain>,   --remote-database-host=<domain>    remote database host from ssh, e.g. localhost
  -l <dbname>,   --local-database-name=<dbname>     local mysql database name
  -s <username>, --local-database-user=<username>   local mysql database user
  -a <pass>,     --local-database-pass=<pass>       local mysql database password
  -f <path>,     --remote-files-dir=<path>          remote files directory,        e.g. ~/public_html/sites/default/files
  -i <path>,     --local-files-dir=<path>           local files directory,         e.g. /var/www/sites/default/
                                                    WARNING: do not include the trailing 'files' for the local files directory path

CREDITS
-----------

Developed by Dustin Currie <dustin@onlinedesert.com> with a bit of bash help from Google.
