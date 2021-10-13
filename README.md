# sangeria
A Sanger 16S assembly and annotation pipeline

## Requirements

1. R
2. Python 3.7
3. numpy
4. BLAST
5. geargenomics/tracy (https://github.com/gear-genomics/tracy)



## Quick usage

### 1. Assemble sanger reads and blast assemblies vs. Silva 16S database 

```bash
scripts/16S_assembly_silva.sh assembly_group_name
```

### 2. Blast assemblies vs. NCBI 16S database 

```bash 
scripts/16S_assembly_ncbi.sh assembly_group_name
```
