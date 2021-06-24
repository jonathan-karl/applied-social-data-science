from datetime import timedelta
import data_preparation

# Point of Execution
def main():
    pass


def get_cheating_observers(games_dict):
    '''Assumes a dictionary containing game-id's as keys
    and for each key a value of a list of lists (where each is a recorded
    kill in the game). Extracts all account-id's which have
    observed cheating and the corresponding time they observed
    cheating. Returns a list of these values called cheating_observers.'''

    # Assumption: We assume that if a game lasts from one day into another, that if in this game one player
    # is assumed to start cheating at 0:00 in the latter day on which the game takes place, he will be dealt
    # with as a cheater from the beginning of such game.

    #Initialise list of cheating_observers
    cheating_observers = []


    # Condition 1: Cheating player B kills at least 3 other players before A gets killed in the game
    # Get list of lists containing all players of each game
    players_step1 = data_preparation.get_players(games_dict)

    # Get list of account-id's or 0's (one for each game), indicating either the first cheater to have committed
    # three kills or, if 0, that no cheater committed three or more kills.
    first_three_kill_cheaters = data_preparation.get_first_three_kill_cheaters(games_dict)

    # Set counter to 0
    killed_after_cheater = 0
    for game_number, game in enumerate(games_dict.values()):
        # If a cheater in the game made three or more kills
        # then the indicator will be non-zero but contain the cheaters
        # account-id.
        if first_three_kill_cheaters[game_number] != 0:
            # Store the account-id of the cheater that committed three kills
            # first in a variable
            the_three_killer = first_three_kill_cheaters[game_number]

            # Set the counter of this cheater's kills in game to 0 initially.
            cheater_kill_counter = 0


            # Loop through all kills in each game, and count the number of kills
            # "the_three_killer" committed (and remove all players in the game
            # that were killed before this event occured). When the counter
            # is equal to 3 or more (and the kill currently iterated over does
            # not contain a cheater, append the killed account-id and the
            # time of the kill.
            for kill in game:
                if cheater_kill_counter < 3:
                    if 2 not in kill and 1 not in kill:
                        players_step1[game_number].remove(kill[1])
                    if 1 in kill and the_three_killer == kill[0]:
                        cheater_kill_counter += 1
                        if 2 not in kill:
                            players_step1[game_number].remove(kill[1])
                elif 1 not in kill and 2 not in kill:
                    cheating_observers.append(kill[1:])
                    players_step1[game_number].remove(kill[1])
                    killed_after_cheater += 1

            # Record the time of the last kill to use for the winner to observe cheating
            last_kill = kill[2]
            # Append the winner (or winners) to the cheating_observers list
            # (if there was enough cheating in the game, i.e. a cheater made at least
            # three kills.)
            for player in players_step1[game_number]:
                    cheating_observers.append([player, last_kill])
                    killed_after_cheater += 1

        # Clear up memory
        players_step1[game_number].clear()


    # Uncomment to see the amount of people that observed cheating under condition 1
    #print("killed_after_cheater:", killed_after_cheater)
    #print("cheating_observers", len(cheating_observers), " - after satisfying condition 1")

    # Condition 2: A is killed by cheating player B.

    # Check for each kill if it was commited by a cheater.
    # For those where both of these are true, append the killed
    # account-id and the time of kill to a new list.

    # Execute condition 2
    killed_by_cheater = 0
    for game in games_dict.values():
        for kill in game:
            if 1 in kill and 2 not in kill:
                killed_by_cheater += 1
                cheating_observers.append(kill[1:])


    # Uncomment to see the amount of people that observed cheating under condition 2
    #print("killed_by_cheater:", killed_by_cheater)
    #print("cheating_observers", len(cheating_observers), " - after satisfying condition 1 & 2")

    # Return cheating_observers list
    return cheating_observers

def get_observer_cheater_motifs(cheating_observers, cheaters):
    '''Assumes two list of lists as arguments. "cheating_observers"
    is assumed to contain an account-id and a time (whenever the
    player behind that account observed a cheater cheating). "cheaters"
    is assumed to contain an account-id and a time (whenever the player behind
    such account is assumed to have started cheating).
    Returns the length of the observer_cheater_motifs list, i.e.
    those who started cheating within 5 days after having observed
    cheating.'''

    # The Conclusion, who fell victim to the observation of cheating
    # and started cheating themselves.

    # Initialise with empty list of those failing for cheating
    observer_cheater_motifs = []
    account_ids_cheaters = data_preparation.get_cheater_account_ids(cheaters)

    # Loop through list of cheating observers and determine if they
    # started cheating within 5 days after observing cheating (also
    # account for multiple observations, checking each individually).
    for i in cheating_observers:
        if i[0] in account_ids_cheaters:
            index_cheater = account_ids_cheaters.index(i[0])
            if i[1] + timedelta(days=5) >= cheaters[index_cheater][1] and i[0] not in observer_cheater_motifs:
                observer_cheater_motifs.append(i[0])

    # Uncomment to check number of observer_cheater_motifs
    #print("Number of observer_cheater_motifs:", len(observer_cheater_motifs))

    return len(observer_cheater_motifs)


if __name__ == '__main__':
    main()
