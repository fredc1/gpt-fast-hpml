# Environment
Unfortuneately, to run this entire repo you need some very stringent requirements.

GPU:
1. Compute capability >= 8
2. Memory >= 80 GB

Linux Host:
1. Persistent Storage >= 800GB
2. RAM >= 512 GB
3. CUDA Toolkit >= 12.1
4. PyTorch most up to date (https://pytorch.org/get-started/locally/) (As of now only works with PyTorch Nightly)


## Setup
Install Dependencies:
```bash
pip install sentencepiece huggingface_hub
```
Getting access to models:
Go to https://huggingface.co/meta-llama/Llama-2-7b and follow the steps to get approval to access Llama first from Meta and then from this specific huggingface repo.

Login with `huggingface-cli login` This allows you to pull the repos in download.py without passing your access token.

## Downloading Models
Models repos used:
```text
meta-llama/Llama-2-7b-chat-hf
meta-llama/Llama-2-13b-chat-hf
meta-llama/Llama-2-70b-chat-hf
```

Download:
```bash
python scripts/download.py --repo_id meta-llama/Llama-2-7b-chat-hf && python scripts/convert_hf_checkpoint.py --checkpoint_dir checkpoints/meta-llama/Llama-2-7b-chat-hf
```
```bash
python scripts/download.py --repo_id meta-llama/Llama-2-13b-chat-hf && python scripts/convert_hf_checkpoint.py --checkpoint_dir checkpoints/meta-llama/Llama-2-13b-chat-hf 
```
```bash
python scripts/download.py --repo_id meta-llama/Llama-2-70b-chat-hf && python scripts/convert_hf_checkpoint.py --checkpoint_dir checkpoints/meta-llama/Llama-2-70b-chat-hf 
```

Quantize:
```bash
python quantize.py --checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth --mode int4 && python quantize.py --checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth --mode int8
```
```bash
python quantize.py --checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model.pth --mode int4 && python quantize.py --checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model.pth --mode int8
```
```bash
python quantize.py --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model.pth --mode int4 && python quantize.py --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model.pth --mode int8
```


## Acknowledgements
Thanks to:
* The [gpt-fast](https://github.com/pytorch-labs/gpt-fast) pytorch labs project for providing the boilerplate transformer and model code for this project

