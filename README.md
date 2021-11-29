# upgrad_projects
This repository is for upgrad project ssignments
Project contains 2 files.
1. Automation.sh: this file is used for seting up apache2 on ec2 instance and copying log files tar on S3 bucket
2. upgrad_aws_automation.conf: please update variables in this project e.g. name of tar file and s3 bucket name

Keep these 2 files in /root/Automation_Project/ folder on ec2 instance
how to 


#Make the script executible
chmod  +x  /root/Automation_Project/automation.sh
#switch to root user with sudo su
sudo  su
./root/Automation_Project/automation.sh

# or run with sudo privileges
sudo ./root/Automation_Project/automation.sh
