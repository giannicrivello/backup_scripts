#!/bin/bash

#this is a backup config using tar archive / compression and GCP(google cloud platform)
#all files, configs, and project folders you want to be backed up need to be placed here

#place paths to directories you wish to backup
dev_projects=/home/gianni/dev_projects
qtile_config_dir=/home/gianni/.config/qtile

#local backup repo (repo where script will place the tar balls before shipping to GCP)
local_backup_repo=/home/gianni/backups

#google cloud bucket(s)
gcp_bucket=gs://ahi-1/




source_backup (){
	for i in $(find $dev_projects -printf "%P\n") ; do
		tar -czvf $i.tar.gz $dev_projects
		mv $(ls | grep .gz) $local_backup_repo
	done

}

qtile_config_backup (){
	for i in $(find $qtile_config_dir -printf "%P\n") ; do
	       tar -czvf $i.config.tar.gz $qtile_config_dir	
	       mv $(ls | grep config) $local_backup_repo 
       done      
}


#uncomment the funcitons you wish to run
qtile_config_backup
source_backup
#GCP function
gsutil -m cp -r $local_backup_repo $gcp_bucket
