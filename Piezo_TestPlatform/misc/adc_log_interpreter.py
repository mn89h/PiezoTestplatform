# Processes log data into usable ADC data
#
# Prerequisites:
# pip install bitstring

from bitstring import Bits, BitArray, BitStream, ConstBitStream
import os.path

# PARAMETERS
# Filename
filename = "adc_log_test.dat"
# Width of data
width = 5
# Strings preceding the streaming data
precedestring = "FORCE SINGLE\n" # unused
startstring = "0x807F"
endstring = "0x7F80"

# Check for file
if os.path.isfile(filename) == False:
    print("File not found!")
    quit()

# Create BitArray from file contents
logdata = BitArray(filename = filename)

# Get length and hex representation of precedestring
precedestring_len = len(precedestring) * 8
precedestring_hex = "0x" + "".join("{:02x}".format(ord(c), "x") for c in precedestring)
startstring_len = (len(startstring) - 2) * 4
endstring_len = (len(endstring) - 2) * 4

# Get the starting precedeindex from logdata
# precedeindices = logdata.find(precedestring_hex, bytealigned=True)
startindices = logdata.find(startstring, bytealigned=True)
i_start = startindices[0] + startstring_len
print('Starting at: {start:d}'.format(start=i_start))


endindices = logdata.find(endstring,bytealigned=True)
i_end = endindices[0]
print('Ending at: {end:d}'.format(end=i_end))


# Use only the part where streaming begins
logdata = logdata[i_start:i_end]
# print(logdata.bin)

# initial data
#  ---------BYTE 1---------     ---------BYTE 2---------         ---------BYTE X--------- 
# | B  B  B  A  A  A  A  A |   | D  C  C  C  C  C  B  B |       | Z  Z  Z  Z  Y  Y  Y  Y |
# | 2  1  0  4  3  2  1  0 |   | 0  4  3  2  1  0  4  3 |  ```  | 3  2  1  0  4  3  2  1 |
#  ------------------------     ------------------------         ------------------------ 

# reverse byte order
#  ---------BYTE X---------         ---------BYTE 2---------    ---------BYTE 1--------- 
# | Z  Z  Z  Z  Y  Y  Y  Y |       | D  C  C  C  C  C  B  B |  | B  B  B  A  A  A  A  A |
# | 3  2  1  0  4  3  2  1 |  ```  | 0  4  3  2  1  0  4  3 |  | 2  1  0  4  3  2  1  0 |
#  ------------------------         ------------------------    ------------------------ 
logdata.byteswap()
# print(logdata.bin)

# cut unfinished data
#  ---------BYTE X---------         ---------BYTE 2---------    ---------BYTE 1--------- 
# |             Y  Y  Y  Y |       | D  C  C  C  C  C  B  B |  | B  B  B  A  A  A  A  A |
# |             4  3  2  1 |  ```  | 0  4  3  2  1  0  4  3 |  | 2  1  0  4  3  2  1  0 |
#  ------------------------         ------------------------    ------------------------ 
logdata = logdata[((endindices[0] - i_start) % width):]
# print(logdata.bin)

# reverse bit order
#  ---------1 BYTE---------    ---------2 BYTE---------         ---------X BYTE--------- 
# | A  A  A  A  A  B  B  B |  | B  B  C  C  C  C  C  D |       | Y  Y  Y  Y             |
# | 0  1  2  3  4  0  1  2 |  | 3  4  0  1  2  3  4  0 |  ```  | 1  2  3  4             |
#  ------------------------    ------------------------         ------------------------ 
logdata.reverse()
# print(logdata.bin)

# cut into "width"-sized chunks, correct the bit order and store as ints in array 
#  -----VAL 1-----    -----VAL 2-----    -----VAL 3-----         -----VAL X----- 
# | A  A  A  A  A |  | B  B  B  B  B |  | C  C  C  C  C |       | Y  Y  Y  Y  Y |
# | 4  3  2  1  0 |  | 4  3  2  1  0 |  | 4  3  2  1  0 |  ```  | 4  3  2  1  0 |
#  ---------------    ---------------    ---------------         --------------- 
data_array = []
for chunk in logdata.cut(width):
    val = BitArray(chunk)
    val.reverse()
    data_array.append(val.int)

# write content of array to file
with open('data.csv', 'w') as file:
    for val in data_array:
        file.write("%i\n" % val)
