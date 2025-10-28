import sys
from collections import defaultdict

# -------------------------------------------------------------
# Function: Simulate Mapper Phase
# -------------------------------------------------------------
def mapper(input_text):
    mapped_data = []
    for line in input_text.strip().split("\n"):
        words = line.strip().split()
        for word in words:
            mapped_data.append((word.lower(), 1))
    return mapped_data

# -------------------------------------------------------------
# Function: Simulate Reducer Phase
# -------------------------------------------------------------
def reducer(mapped_data):
    word_count = defaultdict(int)
    for word, count in mapped_data:
        word_count[word] += count
    return word_count

# -------------------------------------------------------------
# Main Function
# -------------------------------------------------------------
if __name__ == "__main__":
    print("===== Hadoop MapReduce Word Count Simulation =====")
    
    # Sample input text (you can change it)
    input_text = """
    Hadoop is fast Hadoop is reliable
    MapReduce is powerful and scalable
    """

    print("\n--- Input Text ---")
    print(input_text.strip())

    # Step 1: Mapper Phase
    mapped_data = mapper(input_text)
    print("\n--- Mapper Output (word, 1) ---")
    for item in mapped_data:
        print(item)

    # Step 2: Reducer Phase
    reduced_output = reducer(mapped_data)
    print("\n--- Reducer Output (word: count) ---")
    for word, count in reduced_output.items():
        print(f"{word}: {count}")

    print("\n===== MapReduce Word Count Completed Successfully =====")
