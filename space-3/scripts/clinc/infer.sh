#!/bin/bash
set -ux

# CUDA environment settings.
export CUDA_VISIBLE_DEVICES=0

# Parameters.
LEARNING_METHOD=super
MODEL=IntentUnifiedTransformer
TRIGGER_DATA=clinc
TRIGGER_ROLE=user
PROJECT_NAME=SPACE
PROJECT_ROOT=/data/nt12_ssd_gluster/myself/SIAT-NLP/${PROJECT_NAME}
SAVE_ROOT=/data/nt12_hdd_gluster/myself/SIAT-NLP/${PROJECT_NAME}
VOCAB_PATH=${PROJECT_ROOT}/model/Bert/vocab.txt
DATA_DIR=${PROJECT_ROOT}/data/pre_train
LOAD_MODEL_NAME=state_epoch_45
LOAD_MODEL_DIR=97-89
INIT_CHECKPOINT=${SAVE_ROOT}/outputs/${TRIGGER_DATA}/${LOAD_MODEL_DIR}/${LOAD_MODEL_NAME}
EXAMPLE=false
WITH_QUERY_BOW=false
WITH_RESP_BOW=false
WITH_CONTRASTIVE=false
WITH_RDROP=true
WITH_POOL=false
WITH_MLM=true
DYNAMIC_SCORE=true
GENERATION=false
POLICY=false
TOKENIZER_TYPE=Bert
DROPOUT_RATIO=0.25
TEMPERATURE=0.07
MLM_RATIO=0.1
KL_RATIO=5.0
LR=1e-4
PROMPT_NUM_FOR_POLICY=5
PROMPT_NUM_FOR_UNDERSTAND=5
BATCH_SIZE_LABEL=128
BATCH_SIZE_NOLABEL=0
NUM_PROCESS=1
NUM_INTENT=150
NUM_EPOCH=60
NUM_GPU=1
SEED=42
SAVE_DIR=${SAVE_ROOT}/outputs/${TRIGGER_DATA}/${LOAD_MODEL_DIR}.infer

# Data preprocess.
python -u preprocess.py \
  --data_dir=${DATA_DIR} \
  --with_mlm=${WITH_MLM} \
  --vocab_path=${VOCAB_PATH} \
  --num_process=${NUM_PROCESS} \
  --trigger_data=${TRIGGER_DATA} \
  --trigger_role=${TRIGGER_ROLE} \
  --dynamic_score=${DYNAMIC_SCORE} \
  --tokenizer_type=${TOKENIZER_TYPE} \
  --prompt_num_for_policy=${PROMPT_NUM_FOR_POLICY} \
  --prompt_num_for_understand=${PROMPT_NUM_FOR_UNDERSTAND}

# Main run.
python -u run_intent.py \
  --do_infer=true \
  --model=${MODEL} \
  --example=${EXAMPLE} \
  --policy=${POLICY} \
  --generation=${GENERATION} \
  --data_dir=${DATA_DIR} \
  --vocab_path=${VOCAB_PATH} \
  --num_process=${NUM_PROCESS} \
  --trigger_data=${TRIGGER_DATA} \
  --trigger_role=${TRIGGER_ROLE} \
  --dynamic_score=${DYNAMIC_SCORE} \
  --tokenizer_type=${TOKENIZER_TYPE} \
  --prompt_num_for_policy=${PROMPT_NUM_FOR_POLICY} \
  --prompt_num_for_understand=${PROMPT_NUM_FOR_UNDERSTAND} \
  --with_query_bow=${WITH_QUERY_BOW} \
  --with_resp_bow=${WITH_RESP_BOW} \
  --batch_size_label=${BATCH_SIZE_LABEL} \
  --batch_size_nolabel=${BATCH_SIZE_NOLABEL} \
  --save_dir=${SAVE_DIR} \
  --init_checkpoint=${INIT_CHECKPOINT} \
  --learning_method=${LEARNING_METHOD} \
  --temperature=${TEMPERATURE} \
  --with_contrastive=${WITH_CONTRASTIVE} \
  --with_rdrop=${WITH_RDROP} \
  --with_pool=${WITH_POOL} \
  --with_mlm=${WITH_MLM} \
  --mlm_ratio=${MLM_RATIO} \
  --kl_ratio=${KL_RATIO} \
  --dropout=${DROPOUT_RATIO} \
  --embed_dropout=${DROPOUT_RATIO} \
  --attn_dropout=${DROPOUT_RATIO} \
  --ff_dropout=${DROPOUT_RATIO} \
  --num_intent=${NUM_INTENT} \
  --num_epoch=${NUM_EPOCH} \
  --gpu=${NUM_GPU} \
  --seed=${SEED} \
  --lr=${LR} \
  --log_steps=20 \
  --valid_steps=0 \
  --num_type_embeddings=2 \
  --save_checkpoint=true \
  --token_loss=true \
  --max_len=256