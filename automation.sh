#!/bin/bash
update_required_packages () {
	echo "updating required pckages";
	sudo apt update -y
	echo "updating required pckages complted";
}

install_apache2 () {
	if echo dpkg --get-selections | grep -q "apache2"
	then 
		echo "Apache2 is already installed";
	else 
		echo "Apache2 is not installed, so Instlling Apache2";
		sudo apt install apache2
		echo "Apache2 Installation completed";
	fi
}

start_apache2_server () {
	if systemctl is-active apache2
	then
				echo "Apache2 server is already running";
	else
		echo "Apache2 server is not running, Starting Apache2 server";
		sudo systemctl start apache2
		echo "Apache2 server is now started";

	fi
}

enable_apache2_service () {
	if systemctl is-enabled apache2
	then
		echo "Apache2 service is already enable";
	else
		echo "Apache2 service is disable, Enabling Apache2 service";
		sudo systemctl enable apache2
		echo "Apache2 service is now ebnable";
	fi
}

create_archive_tar () {
	echo "Creating archieve file of log files";
	tar -cvf ${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
	mv ${myname}-httpd-logs-${timestamp}.tar /tmp/
	echo "Archive file ${myname}-httpd-logs-${timestamp}.tar created on folder /tmp/";
}

copy_tar () {
	echo "Copying archive file";
	aws s3 \
	cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
	s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
	echo "Archive file successfully copied on S3 bucket";
}

update_inventory () {
	inventoryFile=/var/www/html/inventory.html
	logType="httpd-logs"
	filename=${myname}-httpd-logs-${timestamp}.tar
	type=${filename##*.}
	size=$(ls -lh /tmp/${filename}| cut -d " " -f5)

	if ! test -f "$inventoryFile"; then
		echo "Inventory File is not available, creating a Inventory file";
		touch ${inventoryFile}
		echo "<b>Log Type&nbsp;&nbsp;&nbsp;&nbsp;Time Created&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type&nbsp;&nbsp;Size</b>">${inventoryFile}
	fi
		echo "<br>${logType}&nbsp;&nbsp;&nbsp;&nbsp;${timestamp}&nbsp;&nbsp;&nbsp;&nbsp;${type}&nbsp;&nbsp;&nbsp;&nbsp;${size}">>${inventoryFile}
		echo "Inventory file has been updated";

}

create_cronJob () {
	cronFile=/etc/cron.d/automation
	if test -f "$cronFile"; then
		echo "Cron Job file is already available";
	else
		echo "Cron Job is not available, creating a Cron job file";
		touch ${cronFile}
		echo '0 0 * * * root /root/Automation_Project/automation.sh'>${cronFile}
		echo "Cron Job file has been created";
	fi
}

program_flow () {
echo "###########Apache instlltion on EC2 & archieving logs script starting###########";
update_required_packages;
install_apache2;
start_apache2_server;
enable_apache2_service;
create_archive_tar;
copy_tar;
update_inventory;
create_cronJob;

echo "###########Apache instlltion on EC2 & archieving logs script completed###########";
}

. ./upgrad_aws_automation.conf
program_flow;