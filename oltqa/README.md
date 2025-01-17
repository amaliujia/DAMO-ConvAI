# OLTQA
The PyTorch implementation of paper [Long-Tailed Question Answering in an Open World](https://arxiv.org/abs/2305.06557)

# Requirements and data preparation
```bash
cd LongTailQA
pip install -r r.txt
```
The raw dataset is available [here](https://drive.google.com/file/d/12-w1bMAevcXmjsl8DKcCrJe1kI-pyZTd/view?usp=share_link) to be placed in data_process/data

# Construct Pareto Long-Tail subset of raw data
```bash
python gen_lt.py
```

# large PLM inference
## BM25 candidates
use [This Repo](https://github.com/OhadRubin/EPR) to select BM25 examples for PLM inference
```bash
python find_bm25.py output_path=$PWD/data/{compute_bm25_outfile} \
    dataset_split=train setup_type={bm25_setup_type} task_name={dataset} +ds_size={ds_size} L={finder_L}
```

## PLM inference
Install [GLM-10B](https://github.com/THUDM/GLM) or [GLM-130B](https://github.com/THUDM/GLM-130B) in ./plm and infer hint candidates with each example for an input.
```bash
cd plm
bash ./install_glm.sh
bash ./run.sh ${input_file}
```


# Two-stage Training

## generate dataset for example selection

```bash
python gen_sel.py
python gen_seldev.py
python gen_seltest.py
```

## pre-train bi-encoder and cross-encoder with plm scores
```bash
bash ./train_stage1.sh ${train batch size}
```
For a quickstart, pre-trained [bi-encoder](https://drive.google.com/file/d/1RRau7Y7PX2rv3CxVHK5FGM4aJPhsLbiv/view?usp=share_link) and [cross-encoder](https://drive.google.com/file/d/1YNi5TSBvo4eevdw7DPcLApX96LSJlu4p/view?usp=share_link) checkpoints are available.

## train and evaluate the framework
```bash
bash ./cyclekd.sh ./ll ${train batch size} ${eval batch size} ${epoch}
bash ./testseen.sh  ${eval batch size}
bash ./testunseen.sh  ${eval batch size}
```

## Ablation variants: removing knowledge sharing and knowledge mining:
```bash
#w/o knowledge sharing
bash ./cycleablationmeta.sh  ${train batch size} ${eval batch size} ${epoch}
bash ./testseen-nometa.sh ${eval batch size}
bash ./testunseen-nometa.sh ${eval batch size}
```

and

```bash
#w/o knowledge mining
bash ./ablationknowledge.sh ${train batch size} ${eval batch size} ${epoch}
```