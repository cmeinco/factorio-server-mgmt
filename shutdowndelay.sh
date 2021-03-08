

tail -1 /opt/factorio/factorio/factorio-current.log | awk '{print $1}' > /tmp/lasttimestamptmp

diff /tmp/lasttimestamp /tmp/lasttimestamptmp -q
retval=$?
if [ ${retval} -eq 0 ]; then  #no difference

    lastModificationSeconds=$(date +%s -r /opt/factorio/factorio/factorio-current.log)
    currentSeconds=$(date +%s)
    elapsedSeconds=$((currentSeconds - lastModificationSeconds))

    if [ ${elapsedSeconds} -gt 300 ]; then

        # no change in more than 1h, recommend shutdown.
        echo "Shutting myself down, hasta la vista baby."
        aws ec2 stop-instances --instance-ids `curl --silent http://169.254.169.254/latest/meta-data/instance-id` --region `curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep -oP '\"region\" : \"\K[^\"]+'`

    fi

fi

tail -1 /opt/factorio/factorio/factorio-current.log | awk '{print $1}' > /tmp/lasttimestamp
