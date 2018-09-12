#
# mario.py
#
# Artificial Intelligence
# Tim Stolp
#
# draw a pyramide of a certain height
#
#####################################

# ask for height untill a value between 0 and 23 is put in
while True:
    h = int(input("Height: "))
    if h > -1 and h < 24:
        break

# print h amount of layers starting 2x# adding 1 # each next layer
for i in range(2, h + 2):
    print("{:>{height}}".format("#" * i,  height = str(h + 1)))
