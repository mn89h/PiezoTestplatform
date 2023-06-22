# Processes log data into usable ADC data
#
# Prerequisites:
# pip install bitstring

from bitstring import Bits, BitArray, BitStream, ConstBitStream
import glob

# PARAMETERS
# Filename
filename = "adc_log_test.dat"
# Width of data
width = 5
# Strings preceding the streaming data
precedestring = "FORCE SINGLE\n" # unused
startstring = "0x807F"
endstring = "0x7F80"

# Check for input and output files
if glob.glob(filename) == []:
    print("File not found!")
    quit()
if glob.glob('*_data_0.txt'):
    try:
        input("Dump files may already exist. Press enter to overwrite or CTRL+C to abort...\n")
    except:
        print("Aborted.")
        quit()

# Create BitArray from file contents
logdata = BitStream(filename = filename)

i = 0
while True:
    try:
        # read from logdata until the startstring, bitpos is right after startstring
        logdata.readto(startstring, bytealigned=True)
        # read from logdata until the endstring and store the result for usage,
        # bitpos is right after endstring for next iteration
        current_logdata = logdata.readto(endstring, bytealigned=True)
        i = i + 1
    except:
        print("Done")
        break;
    

    source_abbr = current_logdata.read(8).hex
    freq_state = current_logdata.read(8).uint
    width = current_logdata.read(8).uint

    if source_abbr == format(ord('A'), "x"):
        source = 'ADC'
        dumpfile = 'adc_data_{number:d}.txt'.format(number=i)
        freq = freq_state * 250000 + 250000
    elif source_abbr == format(ord('C'), "x"):
        source = 'COMP'
        dumpfile = 'comp_data_{number:d}.txt'.format(number=i)
        # placeholder if different sampling frequencies are needed
        if freq_state == 5:
            freq = 25000000
        elif freq_state != 0:
            freq = 0
    else:
        print("Source not recognized, data may be corrupt")
        quit()

    # write configuration into dumpfile
    with open(dumpfile, 'w') as file:
        file.write("Frequency = %i\n" % freq)
        file.write("Sample Width = %i\n" % width)
        file.write("\n")

    # cut off ending bytes for following byteswap and bit reversal steps
    current_logdata = current_logdata.readlist('b, 16', b = len(current_logdata) - 24 - 16)[0]
    print('Dump {:d} ({:s}): Reading {:d} Bits'.format(i, source, len(current_logdata)))

    # print(current_logdata.bin)

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
    current_logdata.byteswap()
    # print(current_logdata.bin)

    # # cut unfinished data
    # #  ---------BYTE X---------         ---------BYTE 2---------    ---------BYTE 1--------- 
    # # |             Y  Y  Y  Y |       | D  C  C  C  C  C  B  B |  | B  B  B  A  A  A  A  A |
    # # |             4  3  2  1 |  ```  | 0  4  3  2  1  0  4  3 |  | 2  1  0  4  3  2  1  0 |
    # #  ------------------------         ------------------------    ------------------------ 
    # current_logdata = current_logdata[((endindices[0] - i_start) % width):]
    # # print(current_logdata.bin)

    # reverse bit order
    #  ---------1 BYTE---------    ---------2 BYTE---------         ---------X BYTE--------- 
    # | A  A  A  A  A  B  B  B |  | B  B  C  C  C  C  C  D |       | Y  Y  Y  Y             |
    # | 0  1  2  3  4  0  1  2 |  | 3  4  0  1  2  3  4  0 |  ```  | 1  2  3  4             |
    #  ------------------------    ------------------------         ------------------------ 
    current_logdata.reverse()
    # print(current_logdata.bin)

    # cut into "width"-sized chunks, correct the bit order and store as ints in array 
    #  -----VAL 1-----    -----VAL 2-----    -----VAL 3-----         -----VAL X----- 
    # | A  A  A  A  A |  | B  B  B  B  B |  | C  C  C  C  C |       | Y  Y  Y  Y  Y |
    # | 4  3  2  1  0 |  | 4  3  2  1  0 |  | 4  3  2  1  0 |  ```  | 4  3  2  1  0 |
    #  ---------------    ---------------    ---------------         --------------- 
    data_array = []
    while True:
        try:
            lol = current_logdata.read(width)
            lol.reverse()
            data_array.append(lol.int)
        except:
            break


    # for chunk in current_logdata.cut(width):
    #     val = BitArray(chunk)
    #     val.reverse()
    #     data_array.append(val.int)

    # write content of array to file
    with open(dumpfile, 'a') as file:
        for val in data_array:
            file.write("%i\n" % val)
