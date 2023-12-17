# pip3 install virtualenv
# virtualenv pnight
# source pnight/bin/activate
# nvcc --version
# pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu121
# git clone https://github.com/pytorch-labs/gpt-fast.git
# pip3 install huggingface_hub
# huggingface-cli login
# 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
# pip3 install sentencepiece
# cd gpt-fast
# ./scripts/prepare.sh meta-llama/Llama-2-7b-chat-hf
# ./scripts/prepare.sh meta-llama/Llama-2-13b-chat-hf

# python quantize.py --checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth --mode int4 --groupsize 32
# python quantize.py --checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model.pth --mode int4 --groupsize 32


##############################################################################################################
# Benchmarks

python generate.py --checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model_int4.g32.pth --compile
# Time for inference 5: 1.01 sec total, 197.10 tokens/sec
# Bandwidth achieved: 865.67 GB/s
# ==========
# Average tokens/sec: 197.05
# Memory used: 4.62 GB
python generate.py --checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model_int8.pth --compile
# Time for inference 5: 1.20 sec total, 167.26 tokens/sec
# Bandwidth achieved: 1149.47 GB/s
# ==========
# Average tokens/sec: 167.19
# Memory used: 7.76 GB
python generate.py --checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth --compile
# Time for inference 5: 1.83 sec total, 109.55 tokens/sec
# Bandwidth achieved: 1476.42 GB/s
# ==========
# Average tokens/sec: 109.45
# Memory used: 13.90 GB

python generate.py --checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model_int4.g32.pth --compile
# Time for inference 5: 1.69 sec total, 118.34 tokens/sec
# Bandwidth achieved: 989.39 GB/s
# ==========
# Average tokens/sec: 118.25
# Memory used: 8.69 GB
python generate.py --checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model_int8.pth --compile
# Time for inference 5: 2.30 sec total, 87.12 tokens/sec
# Bandwidth achieved: 1148.63 GB/s
# ==========
# Average tokens/sec: 87.10
# Memory used: 14.33 GB
python generate.py --checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model.pth --compile
# Time for inference 5: 3.33 sec total, 59.97 tokens/sec
# Bandwidth achieved: 1561.24 GB/s
# ==========
# Average tokens/sec: 59.98
# Memory used: 26.67 GB

python generate.py --compile  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --profile generate.json --prompt "def quicksort(arr):"  --max_new_tokens 200 --num_samples 5
# Time for inference 5: 7.05 sec total, 28.38 tokens/sec
# Bandwidth achieved: 1233.87 GB/s
# ==========
# Average tokens/sec: 28.50
# Memory used: 44.00 GB

######################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
# Speculative decoding task: easy
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model_int4.g32.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Time for inference 5: 3.76 sec total, 53.26 tokens/sec
# Bandwidth achieved: 2315.19 GB/s
# ==========
# Acceptance probs: [0.14332247557003258, 0.06188925081433225, 0.0781758957654723, 0.1237785016286645, 0.5928338762214984]
# Mean Accepted: 2.960912052117264
# Average tokens/sec: 52.86
# Memory used: 48.24 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model_int8.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0 --profile generatesd
# Time for inference 5: 3.61 sec total, 55.34 tokens/sec
# Bandwidth achieved: 2405.83 GB/s
# ==========
# Acceptance probs: [0.11864406779661017, 0.09491525423728814, 0.061016949152542375, 0.05084745762711865, 0.6745762711864407]
# Mean Accepted: 3.0677966101694913
# Average tokens/sec: 54.16
# Memory used: 51.37 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Time for inference 5: 4.56 sec total, 43.85 tokens/sec
# Bandwidth achieved: 1906.15 GB/s
# ==========
# Acceptance probs: [0.13043478260869565, 0.08695652173913043, 0.07357859531772576, 0.06020066889632107, 0.6488294314381271]
# Mean Accepted: 3.0100334448160537
# Average tokens/sec: 45.03
# Memory used: 57.51 GB




time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model_int4.g32.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4  --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Time for inference 5: 4.28 sec total, 46.69 tokens/sec
# Bandwidth achieved: 2029.77 GB/s
# ==========
# Acceptance probs: [0.06761565836298933, 0.06405693950177936, 0.09252669039145907, 0.06405693950177936, 0.7117437722419929]
# Mean Accepted: 3.288256227758007
# Average tokens/sec: 47.78
# Memory used: 52.70 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model_int8.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Time for inference 5: 4.41 sec total, 45.40 tokens/sec
# Bandwidth achieved: 1973.78 GB/s
# ==========
# Acceptance probs: [0.051470588235294115, 0.03308823529411765, 0.09926470588235294, 0.07720588235294118, 0.7389705882352942]
# Mean Accepted: 3.4191176470588234
# Average tokens/sec: 45.58
# Memory used: 58.07 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Time for inference 5: 5.66 sec total, 35.32 tokens/sec
# Bandwidth achieved: 1535.48 GB/s
# ==========
# Acceptance probs: [0.051470588235294115, 0.03308823529411765, 0.09926470588235294, 0.07720588235294118, 0.7389705882352942]
# Mean Accepted: 3.4191176470588234
# Average tokens/sec: 35.57
# Memory used: 70.41 GB


######################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
# Speculative decoding task: easy batch = 1
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model_int4.g32.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 1 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Acceptance probs: [0.11075949367088607, 0.8892405063291139]
# Mean Accepted: 0.8892405063291139
# Average tokens/sec: 39.47
# Memory used: 48.74 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model_int8.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 1 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Mean Accepted: 0.8985736925515055
# Average tokens/sec: 38.78
# Memory used: 51.37 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 1 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Acceptance probs: [0.10284810126582279, 0.8971518987341772]
# Mean Accepted: 0.8971518987341772
# Average tokens/sec: 34.77
# Memory used: 57.53 GB



time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model_int4.g32.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 1 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Acceptance probs: [0.0754414125200642, 0.9245585874799358]
# Mean Accepted: 0.9245585874799358
# Average tokens/sec: 35.28
# Memory used: 52.70 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model_int8.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 1 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Acceptance probs: [0.061488673139158574, 0.9385113268608414]
# Mean Accepted: 0.9385113268608414
# Average tokens/sec: 32.96
# Memory used: 58.07 GB

time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 1 --prompt "def quicksort(arr):" --max_new_tokens 200 --num_samples 5 --temperature 0
# Acceptance probs: [0.061488673139158574, 0.9385113268608414]
# Mean Accepted: 0.9385113268608414
# Average tokens/sec: 27.79
# Memory used: 70.41 GB


######################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
# Speculative decoding task: hard

time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model_int4.g32.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "Write a CUDA kernel for Convolution. Implement the convolution algorithm in CUDA with tiling and shared memory." --max_new_tokens 400 --num_samples 5 --temperature 0
# Acceptance probs: [0.18167938931297709, 0.11297709923664122, 0.0916030534351145, 0.08091603053435115, 0.5328244274809161]
# Mean Accepted: 2.670229007633588
# Average tokens/sec: 49.08
# Memory used: 48.84 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model_int8.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "Write a CUDA kernel for Convolution. Implement the convolution algorithm in CUDA with tiling and shared memory." --max_new_tokens 400 --num_samples 5 --temperature 0
# Acceptance probs: [0.1383147853736089, 0.11128775834658187, 0.09062003179650238, 0.10810810810810811, 0.5516693163751988]
# Mean Accepted: 2.823529411764706
# Average tokens/sec: 50.08
# Memory used: 51.73 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "Write a CUDA kernel for Convolution. Implement the convolution algorithm in CUDA with tiling and shared memory." --max_new_tokens 400 --num_samples 5 --temperature 0
# Acceptance probs: [0.16897081413210446, 0.12749615975422426, 0.08294930875576037, 0.07834101382488479, 0.5422427035330261]
# Mean Accepted: 2.697388632872504
# Average tokens/sec: 41.46
# Memory used: 57.89 GB





time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model_int4.g32.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "Write a CUDA kernel for Convolution. Implement the convolution algorithm in CUDA with tiling and shared memory." --max_new_tokens 400 --num_samples 5 --temperature 0
# Acceptance probs: [0.15241057542768274, 0.1321928460342146, 0.08553654743390357, 0.07620528771384137, 0.5536547433903577]
# Mean Accepted: 2.7465007776049766
# Average tokens/sec: 41.77
# Memory used: 53.13 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model_int8.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "Write a CUDA kernel for Convolution. Implement the convolution algorithm in CUDA with tiling and shared memory." --max_new_tokens 400 --num_samples 5 --temperature 0
# Acceptance probs: [0.14375, 0.125, 0.1046875, 0.090625, 0.5359375]
# Mean Accepted: 2.75
# Average tokens/sec: 38.50
# Memory used: 58.41 GB
time python generate.py --compile  --draft_checkpoint_path checkpoints/meta-llama/Llama-2-13b-chat-hf/model.pth  --checkpoint_path checkpoints/meta-llama/Llama-2-70b-chat-hf/model_int4.g32.pth --speculate_k 4 --prompt "Write a CUDA kernel for Convolution. Implement the convolution algorithm in CUDA with tiling and shared memory." --max_new_tokens 400 --num_samples 5 --temperature 0
# Acceptance probs: [0.14890282131661442, 0.12695924764890282, 0.10031347962382445, 0.06269592476489028, 0.5611285266457681]
# Mean Accepted: 2.760188087774295
# Average tokens/sec: 30.03
# Memory used: 70.75 GB
