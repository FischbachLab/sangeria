#!/bin/bash -x

set -eu

# assigned group name
mygroup=${1:?"Assign a group name, e.g. Re-Sanger_Plate1"}
# QuintaraBio name 
Name=${2:?"QuintaraBio sequencing name, e.g., Re-Sanger_Plate1"}
# Order IDs
id=${3:?"QuintaraBio id, e.g, 772993"}
ORDER=($id) # (714723 714724)   

#aws --profile biohub s3 sync s3://czbiohub-microbiome/Fischbach_Lab/MITI/Sanger/QB_RAW_DATA/Compressed/ /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_Compressed/
aws s3 sync s3://maf-users/MITI/Sanger/QB_RAW_DATA/Compressed/${Name} /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_Compressed/${Name}

#if [ -d  /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_Compressed/${ORDER} ]; then
#   rm -r  /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_Compressed/${ORDER}
#fi

if [ -d  /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/${mygroup} ]; then
   rm -r  /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/${mygroup}
fi

#aws --profile biohub s3 sync s3://czbiohub-microbiome/Fischbach_Lab/MITI/Sanger/QB_RAW_DATA/Compressed/${ORDER} /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_Compressed/${ORDER}

mkdir -p /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/${mygroup}/all_ab1_files
mkdir -p /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/${mygroup}/qc_files

# for i in ${ORDER[@]}
for ((idx=0; idx<${#ORDER[@]}; ++idx));
do
        echo ${ORDER[idx]}
#:<<'COMM'
	cd /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_Compressed/${Name}/${ORDER[idx]}/
#	cp *_autoqc.xls /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/${mygroup}/qc_files
	
        if [ ls "*.crdownload" 1>/dev/null 2>&1 ]; then
           rm  "*.crdownload"
        fi

        # each order id
	ids=`ls *.zip`
	echo ${ids[@]}
        for i in ${ids[@]};
        do 		 
	  echo $i 
 	  PARENT=$(pwd);
                
	 # ls *.zip | cut -f 3 -d _ | parallel "mkdir -p {}; mv *{}*.zip {}/"
          dirname=`echo "$i" | cut -f 3 -d _`
	  echo $dirname  
          [ ! -d $dirname ] &&  mkdir -p $dirname && mv $i $dirname

	  for f in $dirname/*.zip; do
            echo $f
            
    	    NEW_DIR=$PARENT/$(echo "${f}" | cut -f 1 -d /);
    	    cd "${NEW_DIR}"
	    echo ${NEW_DIR}
    	    if compgen -G "*.zip" > /dev/null; then
    		ls *.zip | parallel "unzip {}" | echo "y";
		cp *.ab1 /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/${mygroup}/all_ab1_files
	    fi
 
	    #ls *.zip | parallel "unzip {}";
           # unzip *.zip 
	  # cp *.ab1 /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/${mygroup}/all_ab1_files
    	   cd -;
	  done
       done
#COMM
done

# /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_Compressed/MIMB1/747567/*/SH0002453*.ab1 /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/MIMB1_1/all_ab1_files/

