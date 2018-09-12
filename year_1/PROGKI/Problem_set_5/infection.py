#
# infection.py
#
# Artificial Intelligence
# Tim Stolp
#
# simulate the change in size of a virus population over a certain time
#
#####################################

import random

# generate a virus made from the nucleotides A, C, T, and G of a given length
def generateVirus(length):
    return ''.join(random.choice(['A', 'C', 'T', 'G']) for x in range(length))

# change a random nucleotide into another nucleotide
def mutate(virus):
    random_int = random.randrange(len(virus))
    return virus[:random_int] + random.choice([x for x in 'ACTG' if x != list(virus)[random_int]]) + virus[(random_int + 1):]

# kill a number of viruses with a certain probabilty
def kill(viruses, mortalityProb):
    return [x for x in viruses if random.random() > mortalityProb]

# duplicate a number of viruses with a certain probabilty
def reproduce(viruses, mutationProb, reproductionProb):
    return viruses + [mutate(x) if random.random() < mutationProb else x for x in viruses if random.random() < reproductionProb]

# calculate the reproduction probabilty
def reproductionProbability(viruses, maxReproductionProb, maxPopulation):
    return (1 - (len(viruses) / maxPopulation)) * maxReproductionProb

# simulate the change in virus population size over a certain amount of timesteps
def simulate(viruses, mortalityProb, mutationProb, maxReproductionProb, maxPopulation, timesteps = 500):
    lengths = [len(viruses)]
    for i in range(timesteps):
        # kill a number of viruses with a certain probabilty
        viruses = kill(viruses, mortalityProb)
        # duplicate a number of viruses with a certain probabilty
        viruses = reproduce(viruses, mutationProb, reproductionProbability(viruses, maxReproductionProb, maxPopulation))
        lengths += [len(viruses)]
    return lengths
