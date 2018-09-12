#
# greedy.py
#
# Artificial Intelligence
# Tim Stolp
#
# Calculate the amount of coins necessary to give back change
#
#####################################

# ask for change untill value above zero is put in
while True:
    money = float(input("O hai! How much change is owed? "))
    if money > 0:
        break

# turn change into an integer
money = int(money * 100)

# calculate the amount of each coin
quarters = (money // 25)
dimes = (money % 25 // 10)
nickles = (money % 25 % 10 // 5)
pennies = (money % 25 % 10 % 5)

# add coins together and print
print(quarters + dimes + nickles + pennies)
