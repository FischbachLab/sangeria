#!/bin/bash -x
# shellcheck disable=SC2086
set -e
set -u
set -o pipefail

TASK=${TASK:-"blastn"}
QUERY_EXT=${QUERY_EXT:-".fa"}
THREADS=${THREADS:-12}

QUERY_PATH=${1}
#LOCAL_DB=${2:-"/mnt/efs/databases/Blast/Silva/v138.1/silva138"}
LOCAL_DB=${2:-"/mnt/efs/scratch/Xmeng/data/16S/Sanger/silva_db/SILVA_138.1_SSURef_NR99_tax_silva.fasta"}
RESULTS_PATH=$(echo "${QUERY_PATH}" | sed -e "s/queries/results/" -e "s/${QUERY_EXT}/.${TASK}.archive/")

# BASE_PATH="/home/ec2-user/efs/docker/PacBio/Assemblies/BLAST/UHGGdb"
# LOCAL_DB="${BASE_PATH}/db/UHGG_isolates"
# LOCAL_DB="${BASE_PATH}/extended_db/UHGG_isolates_ext"
BASE_PATH=$(pwd)
LOCAL_QUERY_FASTA="${BASE_PATH}/${QUERY_PATH}"
LOCAL_RESULT_FILE="${BASE_PATH}/${RESULTS_PATH}"

LOCAL_DB_DIR="$(dirname ${LOCAL_DB})"
DBNAME="$(basename ${LOCAL_DB})"

LOCAL_QUERY_DIR="$(dirname ${LOCAL_QUERY_FASTA})"
QUERY_FILE_NAME="$(basename ${LOCAL_QUERY_FASTA})"

LOCAL_RESULTS_DIR="$(dirname ${LOCAL_RESULT_FILE})"
RESULTS_FILE_NAME="$(basename ${LOCAL_RESULT_FILE})"

mkdir -p ${LOCAL_RESULTS_DIR}

DOCKER_DB_DIR="/blast/blastdb_custom"
DOCKER_QUERIES_DIR="/blast/queries"
DOCKER_RESULTS_DIR="/blast/results"

docker container run --rm \
    -v ${LOCAL_DB_DIR}:${DOCKER_DB_DIR}:ro \
    -v ${LOCAL_QUERY_DIR}:${DOCKER_QUERIES_DIR}:ro \
    -v ${LOCAL_RESULTS_DIR}:${DOCKER_RESULTS_DIR}:rw \
    ncbi/blast:latest \
        ${TASK} \
            -num_threads ${THREADS} \
            -query ${DOCKER_QUERIES_DIR}/${QUERY_FILE_NAME} \
            -out ${DOCKER_RESULTS_DIR}/${RESULTS_FILE_NAME} \
            -db ${DBNAME} \
            -outfmt 11 \
            -dbsize 1000000 \
            -num_alignments 200
            # -gapopen 0 \
            # -gapextend 0 \

docker container run --rm \
    -v ${LOCAL_DB_DIR}:${DOCKER_DB_DIR}:ro \
    -v ${LOCAL_QUERY_DIR}:${DOCKER_QUERIES_DIR}:ro \
    -v ${LOCAL_RESULTS_DIR}:${DOCKER_RESULTS_DIR}:rw \
    ncbi/blast:latest \
        blast_formatter \
            -archive ${DOCKER_RESULTS_DIR}/${RESULTS_FILE_NAME} \
            -outfmt '6 std qlen slen qcovs' \
            -out ${DOCKER_RESULTS_DIR}/${RESULTS_FILE_NAME}.outFmt_6.tsv



