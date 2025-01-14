#!/user/bin/python3

import sys

input_file = sys.argv[1]
output_file = sys.argv[2]


with open(
    input_file,
    "r",
) as file:
    data = file.read().strip()

bytes_data = bytes([int(byte) for byte in data.split()])

with open(
    output_file,
    "wb",
) as file:
    file.write(bytes_data)
