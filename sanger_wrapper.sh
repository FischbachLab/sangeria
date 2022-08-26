#!/bin/bash

group=${1:?"Enter group name as argv[1]"}

bash /mnt/efs/scratch/Xmeng/data/16S/Sanger/sanger_scripts/16S_assembly_silva.sh $group >/mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/$group/$group.log 2>&1  && bash /mnt/efs/scratch/Xmeng/data/16S/Sanger/sanger_scripts/16S_assembly_ncbi.sh $group

Current=$(pwd);

cd /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group/$group/789F_907R_28F_1492R_outputs/

Rscript /mnt/efs/scratch/Xmeng/data/16S/Sanger/sanger_scripts/sanger_assembly_summary.R

cd ${Current}
