#!/usr/bin/env bash
echo "FLUSH TABLES WITH READ LOCK;" | mysql tolldb

#save file suffix and pos which we use later
suffix=$(echo "SHOW MASTER STATUS" | mysql -N tolldb | awk '{print $1}' | cut -c4-)
position=$(echo "SHOW MASTER STATUS" | mysql -N tolldb | awk '{print $2}')

#dump the db naming it according to the log position and numbering
mysqldump -F -u root tolldb > tolldb$position$suffix.dump

unset suffix
unset position

echo "UNLOCK TABLES;" | mysql tolldb
