import matplotlib.pyplot as plt

mean_accepted = [
    ("Llama-2-7b-chat-hf (int4)", 0.8892405063291139),
    ("Llama-2-7b-chat-hf (int8)", 0.8985736925515055),
    ("Llama-2-7b-chat-hf (base)", 0.8971518987341772),
    ("Llama-2-13b-chat-hf (int4)", 0.9245585874799358),
    ("Llama-2-13b-chat-hf (int8)", 0.9385113268608414),
    ("Llama-2-13b-chat-hf (base)", 0.9385113268608414),
    ("Llama-2-70b-chat-hf (int4)", 1)
]

plot_data = {model: [] for model, _ in mean_accepted}

for model, p in mean_accepted:
    for k in range(1, 11):
        expected_num_accepted = 0.0
        for na in range(1, k + 1):
            if na == k:
                expected_num_accepted += na * (p ** na)
            else:
                expected_num_accepted += na * (p ** na) * ((1 - p))
        plot_data[model].append(expected_num_accepted)

# Plotting
plt.figure(figsize=(10, 6))
for model, data in plot_data.items():
    plt.plot(range(1, 11), data, label=model)

plt.xlabel('k')
plt.ylabel('Expected Number Accepted')
plt.title('Expected Number Accepted vs k for Each Model')
plt.legend()
plt.grid(True)
plt.show()
