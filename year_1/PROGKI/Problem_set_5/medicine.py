#
# medicine.py
#
# Artificial Intelligence
# Tim Stolp
#
# simulate the change in size of a virus population over a certain time while applying a medicine after a certain time
#
#####################################

import infection
import random

# check if virus is resistent
def isResistent(virus):
    return virus.find('AAA') > -1

# duplicate a number of viruses with a certain probabilty, mutate the duplication with a certain probabilty
def reproduce(viruses, mutationProb, reproductionProb):
    return viruses + [infection.mutate(x) if random.random() < mutationProb else x for x in viruses if random.random() < reproductionProb if isResistent(x)]

# simulate the change in virus population size over a certain amount of timesteps
def simulate(viruses, mortalityProb, mutationProb, maxReproductionProb, maxPopulation, timesteps = 500):
    lengths = [len(viruses)]
    for i in range(timesteps):
        # kill a number of viruses with a certain probabilty
        viruses = infection.kill(viruses, mortalityProb)
        # after 100 steps only reproduce the resistent viruses
        if i >= 100:
            viruses = reproduce(viruses, mutationProb, infection.reproductionProbability(viruses, maxReproductionProb, maxPopulation))
        # reproduce a number of viruses with a certain probabilty
        else:
            viruses = infection.reproduce(viruses, mutationProb, infection.reproductionProbability(viruses, maxReproductionProb, maxPopulation))
        lengths += [len(viruses)]
    return lengths

# calculate how many patients get cured with a certain population size, mortalityProb, mutationProb, maxReproductionProb, and maxPopulation of viruses
def experiment(NumberOfPatients):
    cured = 0
    for i in range(NumberOfPatients):
        viruses = []
        # create a list of 10 viruses made of 16 nucleotides
        for i in range(10):
            viruses += [infection.generateVirus(16)]
        # simulate for 1 patient
        list_amount_viruses = simulate(viruses, 0.05, 0.1, 0.07, 1000)
        # if patient is cured count up 1
        if list_amount_viruses[-1] == 0:
            cured +=1
    return cured
