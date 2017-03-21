# user settings for the script:
text = "Bartek\n"
numPointsPerBit = 8
isTTL = True

# constants for the generator
valueHigh = (1 << 12) - 1
valueLow = 0


# global variable to count points. The full buffer is 2048
pointsPrinted = 0

# supporting table for defining 0s and 1s
valueTableTTL = [valueLow, valueHigh]
valueTableRS = [valueHigh, valueLow]


# prints a value corresponding to a single point.
# input: 0 or 1
def printSingleWavePoint(bit):
    global pointsPrinted
    if (isTTL == True):
        valueToPrint = valueTableTTL[bit]
    else:
        valueToPrint = valueTableRS[bit]
    print valueToPrint
    pointsPrinted = pointsPrinted + 1


# prints a numPointsPerBit repeats of a bit
def printWaveOfBit(bit):
    for wavePoint in range(0, numPointsPerBit):
        printSingleWavePoint(bit)    


# converts a character into a table of bits
def makeBitsFromByte(char):
    listOfBits = []
    listOfBits.append(0)  # start bit
    for bit in range(0,8):
        if ((char & 1) == 1):
            listOfBits.append(1)
        else:
            listOfBits.append(0)
        char = char >> 1
    listOfBits.append(1)  # stop bit
    return listOfBits

# triggers printing bits of a character
def printWaveOfByte(byte):
    bits = makeBitsFromByte(byte)
    for bit in bits:
         printWaveOfBit(bit)

# fill buffer with neutral value. Actually 1 not 0
def printZerosToFillBuffer():
    global pointsPrinted
    for bit in range(pointsPrinted,2048):
        printSingleWavePoint(1)

# main loop:
for char in list(text):
    currentByte = ord(char)
    printWaveOfByte(currentByte)

printZerosToFillBuffer()
