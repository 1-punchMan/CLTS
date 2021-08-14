#
# Usage: train-clts-xenc.sh lg1-lg2
#

lgs=$1
OUTPATH=data/processed/clts-$lgs/word-char_60k
export CUDA_VISIBLE_DEVICES=0

# reload the pretrained XLM
PRETRAINED="/home/zchen/CLTS/dumped/xlm_en_zh/bptt512_max_len256/best-valid_en_mlm_ppl.pth"
MODEL="/home/zchen/CLTS/dumped/clts-xenc-en-zh/8hr1uzeeqf/best-valid_en-zh_mt_rouge1.pth"

CHECKPOINT="/home/zchen/CLTS/dumped/clts-xenc-en-zh/penalty-1e-4/checkpoint.pth"

python train.py \
    --exp_name clts-xenc-$lgs \
    --dump_path ./dumped \
    --data_path $OUTPATH  \
    `# --reload_xencoder "$PRETRAINED" \
    # --reload_model "$MODEL,$MODEL"` \
    --lgs $lgs  \
    --mt_steps $lgs  \
    --encoder_only false \
    --emb_dim 512  \
    --n_layers 6  \
    --n_heads 8  \
    --dropout 0.1  \
    --attention_dropout 0.1  \
    --gelu_activation true  \
    --real false \
    --use_xencoder true \
    --ts_emb_dim 512  \
    --ts_n_layers 6  \
    --ts_n_heads 8  \
    --ts_dropout 0.1  \
    --ts_attention_dropout 0.1  \
    --ts_gelu_activation true  \
    --bptt 512  \
    --max_len 512  \
    --max_epoch 100000  \
    --epoch_size 200000 \
    --share_inout_emb true \
    --eval_bleu true \
    --eval_rouge true \
    --validation_metrics valid_${lgs}_mt_rouge1  \
    --stopping_criterion valid_${lgs}_mt_rouge1,10  \
    --sd_penalty true \
    --tokens_per_batch 3000 \
    --optimizer adam_inverse_sqrt,beta1=0.9,beta2=0.98,lr=0.0003,warmup_updates=12000 \
    --xencoder_optimizer adam,lr=0.00001 \
    --label_smoothing 0.0 \
    --eval_only false \
    --reload_checkpoint $CHECKPOINT


