COUNT=5
 
# localdir,host,rsync_module,user of rsync_module,
USERNAME=root
DESTIP=
SYNCPATH1=/Deploy/
SYNCPATH2=/etc/nginx/
SYNCPATH3=/database/
SYNCPATH4=/root/.ssh/
SYNCPATH5=/root/.acme.sh/

SYNC1=$SYNCPATH1,$DESTIP,$SYNCPATH1,$USERNAME
SYNC2=$SYNCPATH2,$DESTIP,$SYNCPATH2,$USERNAME
SYNC3=$SYNCPATH3,$DESTIP,$SYNCPATH3,$USERNAME
SYNC4=$SYNCPATH4,$DESTIP,$SYNCPATH4,$USERNAME
SYNC5=$SYNCPATH5,$DESTIP,$SYNCPATH5,$USERNAME

INOTIFY_RSYNC_FUN ()
	{
    DIR=`echo $1 | awk -F"," '{print $1}'`
    IP=`echo $1 | awk -F"," '{print $2}'`
    DES=`echo $1 | awk -F"," '{print $3}'`
    USER=`echo $1 | awk -F"," '{print $4}'`
	
	/usr/bin/inotifywait -mr -e modify,delete,create,attrib ${DIR} |while read D E F
        do
                FILECHAGE=${DIR}${FILE}
                ssh ${USER}@${IP} mkdir -p ${DES} 
				/usr/bin/rsync -ahqzt --progress --delete ${DIR} ${USER}@${IP}:${DES}
        done
	}
	
# COUNT=2

 
#############################################################
 
#main
i=0
while [ ${i} -lt ${COUNT} ]
do
    i=`expr ${i} + 1`
    tmp="SYNC"$i
    eval "SYNC=\$$tmp"
    INOTIFY_RSYNC_FUN "$SYNC" &
done
