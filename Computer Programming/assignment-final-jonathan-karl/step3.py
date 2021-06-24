import matplotlib.pyplot as plt
import data_preparation
from step1 import get_cheating_observers
from step1 import get_observer_cheater_motifs
from step2 import randomise_game

# Point of Execution
def main():
    pass


def get_random_motifs(games_dict, cheaters):
    '''Takes a dictionary containing game-id's as keys
    and for each a list of lists (where each is a recorded
    kill in the game) as arguments. Conduct 10 randomizations
    for the data and compute number of observer_cheater_motifs
    for each. Return a list of observer_cheater_motifs-counts.'''

    # Initialise empty list that will record the number of motif counts
    # that was found in each randomisation.
    motif_count = []

    # Run the code below in range below
    for i in range(10):
        # Randomise the data
        games_dict = randomise_game(games_dict)

        # Identify observer_cheater_motifs
        cheating_observers = get_cheating_observers(games_dict)
        motifs = get_observer_cheater_motifs(cheating_observers, cheaters)

        # Print an update of the number of motifs for each randomisation
        print("Randomisation number", i+1, "-", motifs, "observer-cheater-motifs were found.")

        # Append the counted motifs to "motif_count"
        motif_count.append(motifs)

    return motif_count

def plot_motif_fluctuation(initial_motif_count, motif_count):
    '''Plots the number of observer–cheater motifs observed in
    the actual data (vertical line) compared to the distribution
    in the randomized data (histogram).'''

    # Construct plot containing a histogram representing the
    # motif counts of the randomised datasets
    plt.hist(motif_count, bins = 'auto', color = '#0e0d7b')
    # Add a vertical line indicating the motif count in the
    # original data.
    plt.axvline(x = initial_motif_count)
    plt.xlabel('Number of observer-cheater-motifs')
    plt.ylabel('Count')
    plt.title('Is cheating behaviour infectious?')

    # Save and show plot
    plt.savefig("Nr_observer_cheater_motifs.png", dpi = 300)
    plt.show()

if __name__ == '__main__':
    main()
