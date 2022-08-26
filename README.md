# sangeria
A Sanger 16S assembly and annotation pipeline

## Requirements

1. R
2. Python 3.7
3. numpy
4. BLAST
5. geargenomics/tracy (https://github.com/gear-genomics/tracy)


## Quick usage

Default program path: /mnt/efs/scratch/Xmeng/data/16S/Sanger
Default assembly path: /mnt/efs/scratch/Xmeng/data/16S/Sanger/QB_RAW_DATA_by_group

## 3 Steps to run the Sanger assembly and annotation:

### 1. First run prepare_sanger_data.sh with the assigned group name, QuintaraBio name and order id from the excel sheet

```bash
bash prepare_sanger_data.sh 220727_MITI_mixed 220727_MITI_mixed 787985
```

### 2. Run sanger_wrapper.sh with the above group_name

```bash
bash sanger_wrapper.sh  220727_MITI_mixed 
```

### 3. Copy the summary and assembly files to the MITI Google Drive

```bash
copy QB_RAW_DATA_by_group/20727_MITI_mixed/789F_907R_27F_1492R_outputs/ to https://drive.google.com/drive/folders/1qc33xjhU_BtkkD0eWPEPYXkyXl_R8uV_?usp=sharing
```

## Note: 
Default primers are listed in scripts/4primers 
789F 907R 28F 1492R


 
