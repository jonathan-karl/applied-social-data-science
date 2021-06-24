from datetime import datetime

# Point of Execution
def main():
    pass


def get_data():
    '''Assumes that text-files "cheaters.txt" and "kill.txt" are in a
    "folder assignment-final-data" which is in the same directory as
    the folder containing this file and the code for the assignment.
    Returns two lists of lists a) containing cheaters who played
    between March 1 and March 10, 2019. Each list contains:
    1. player account id, 2. estimated date when the player
    started cheating, 3. date when the player's account was banned
    due to cheating, b) containing the killings done in 6,000
    randomly selected matches played between March 1 and March 10, 2019.
    Each list contains: 1. match id, 2. account id of the killer,
    3. account id of the player who got killed, 4. time when the attack
    (killing) happened. All recorded times are converted to datetime.'''

    # Read in cheaters
    cheaters = []
    for line in open('../assignment-final-data/cheaters.txt', 'r'):
        cheater_formatted = line.split()
        cheaters.append(cheater_formatted)

    print("Number of cheaters:", len(cheaters))
    #print("Before editing the dates, just after reading it in (cheaters):", cheaters[0][1], "is of type", type(cheaters[0][1]))
    #print("Before editing the dates, just after reading it in (cheaters):", cheaters[0][2], "is of type", type(cheaters[0][2]), "\n")


    # Read in kills
    kills = []
    for line in open('../assignment-final-data/kills.txt', 'r'):
        kills_formatted = line.split()
        kills_formatted[3:] = [' '.join(kills_formatted[3:])]
        kills.append(kills_formatted)

    print("Number of kills:", len(kills), "\n")
    #print("Before editing the dates, just after reading it in (kills):", kills[0][3], "is of type", type(kills[0][3]), "\n")


    #Fix the dates for kills
    for kill in kills:
        kill[3] = datetime.strptime(kill[3],"%Y-%m-%d %H:%M:%S.%f")

    #print("After editing the dates (kills):", kills[0][3], "is of type", type(kills[0][3]), "\n")

    # Fix the dates for cheater
    for cheater in cheaters:
        cheater[1] = datetime.strptime(cheater[1], "%Y-%m-%d") #%H:%M:%S
        cheater[2] = cheater[2].strip()
        cheater[2] = datetime.strptime(cheater[2], "%Y-%m-%d") #%H:%M:%S

    print("Example cheater:", cheaters[:1])
    print("Example kill:", kills[:1], "\n")

    #print("After editing the dates (cheaters):", cheaters[0][1], "is of type", type(cheaters[0][1]))
    #print("After editing the dates (cheaters):", cheaters[0][2], "is of type", type(cheaters[0][2]), "\n")

    return kills, cheaters

def get_cheater_account_ids(cheaters):
    '''Takes list of lists containing
    1. player account id,
    2. estimated date when the player started cheating,
    3. date when the player's account was banned as argument.
    Return list of cheater account-ids.
    '''

    # Extract the first element of every list in the cheaters list,
    # representing the cheater's account-id
    account_ids_cheaters = [cheater[0] for cheater in cheaters]
    return account_ids_cheaters

# Append a 1 to every kill a cheater made and a 2 to every kill where a cheater was killed
# to reduce complexity of the analysis and randomisation.
def label_cheater_kills(kills, cheaters):
    '''Takes a list of "kills" and a list of "cheaters"
    (each one containing lists) as arguments. Appending a 1 to every kill
    (element in kills) a cheater made and a 2 to every kill where a
    cheater was killed. Returns the labelled lists "kills" and "cheaters". '''

    account_ids_cheaters = get_cheater_account_ids(cheaters)

    for kill in kills:
        # For each kill, if committed by a cheating players,
        # append 1.
        if kill[1] in account_ids_cheaters:
            # Get the index of the cheater in the account_ids_cheaters list (to not Loop)
            # through the entire cheater list every time)
            index_cheater = account_ids_cheaters.index(kill[1])

            # if the killer is in the cheater list and the kill happend after the cheater
            # started cheating, append a 1
            if cheaters[index_cheater][0] == kill[1] and kill[3] >= cheaters[index_cheater][1]:
                kill.append(1)

        # For each kill, if a cheating player was killed,
        # append 2.
        if kill[2] in account_ids_cheaters:
            # Get the index of the cheater in the account_ids_cheaters list
            index_cheater = account_ids_cheaters.index(kill[2])

            # if the killed is in the cheater list and the kill happend after the cheater
            # started cheating, append a 2
            if cheaters[index_cheater][0] == kill[2] and kill[3] >= cheaters[index_cheater][1]:
                kill.append(2)

    print("Done: The kills have been labelled with a 1 to every kill committed by a cheater and a 2 to every kill where a cheater was killed.\n")

    # Return the formatted kills list
    return kills

# This function can be used to acquire the original form of data again after
# having labelled the data for kills involving cheaters.
def return_data_to_original(kills):
    '''Takes a list "kills" of lists (where each list is representing
    a single kill) as argument. Removes labels that have previously been
    attached for data analysis.'''

    # Remove labels appended in "label_cheater_kills"
    for kill in kills:
        if 1 in kill:
            kill.remove(1)
        if 2 in kill:
            kill.remove(2)

    return kills

def aggregating_by_game(kills):
    '''Takes a list of lists (of kills) as argument. Assumes the first element
    of each list in "kills" is the game_id. Returns a dictionary in which each key
    is a game_id and the corresponding value is a list of lists (kills in that game),
    also sorts the kills in each game by time (ascending).'''
    # Initialise with empty dictionary
    games_dict = {}

    # Assign each match id as a key and append all kills as lists to that key
    for i in kills:
        if i[0] in games_dict:
            # Append value to key
            games_dict[i[0]].append(i[1:])
        else:
            #If key does not exist, create key-value pair
            games_dict[i[0]] = [i[1:]]

    # Check the length of the dictionary, i.e. number of games
    print("This dictionary of games contains", len(games_dict), "elements/games.")

    # Source for this: https://www.geeksforgeeks.org/python-sort-list-according-second-element-sublist/
    # Sorting each game by the time of the kill in ascending order
    for game in games_dict.values():
        game.sort(key = lambda x: x[2])

    # Return games_dict
    return games_dict

## ONLY RUN AFTER RUNNING 'label_cheater_kills' ##
def fix_two_day_game(games_dict):
    '''Takes dictionary of games:list of kills as argument.
    Returns the dictionary with adjusted kill labels for games
    in which a cheater was assumed to have started cheating mid-game.'''

    # Fix the games which span over the course of two days
    # We assume that cheaters assumed to have started cheating mid-game
    # have in fact already cheated in that game.

    # Get list of lists of cheaters for each game
    all_cheaters = get_cheaters(games_dict)

    # Loop through each game, check if it spans over two dates,
    # if so, loop through the cheaters in the game and adequately
    # label them irrespective of the the exact time they started
    # cheating
    for game_number, game in enumerate(games_dict.values()):
        two_day_game = check_if_game_two_day(games_dict, game_number)
        if two_day_game:
            for cheater in all_cheaters[game_number]:
                for kill in game:
                    if cheater in kill:

                        # For each kill in which a cheater is involved before
                        # their initially assumed starting point of cheating
                        # append a 1 if the cheater is the killer and a 2
                        # if the cheater is the victim. Only applies to kills
                        # before 12am in that game.
                        if cheater == kill[0] and 1 not in kill:
                            kill.append(1)
                        # For each kill, if a cheating player was killed,
                        # append 2.
                        if cheater == kill[1] and 2 not in kill:
                                kill.append(2)

    # Return the newly adjusted dict
    return games_dict


def get_players(games_dict):
    '''Takes dictionary of games:list of kills as argument.
    Returns a list of lists (one for each game) containing
    all non-cheating players per game.'''
    # Initialise empty list
    players = []

    for game in games_dict.values():
        # Initialise empty list of players for each game
        game_players = []

        # Loop through each kill and add only those account
        # id's which a) are not yet in the game_players lists,
        # b) are no cheaters.
        for kill in game:
            if kill[0] not in game_players:
                if 1 not in kill:
                    game_players.append(kill[0])
            if kill[1] not in game_players:
                if 2 not in kill:
                    game_players.append(kill[1])

        # After iterating through all kills in a game,
        # append the game_players list to the players list
        players.append(game_players)

    # Return players list
    return players

def get_cheaters(games_dict):
    '''Takes dictionary of games:list of kills as argument.
    Returns a list of lists (one for each game) containing
    all cheating players per game.'''
    # Initialise empty list
    cheaters_unique = []

    for game in games_dict.values():
        # Initialise empty list of cheaters for each game
        game_cheaters = []

        # For each game, loop through each kill and add only those
        # account id's which a) are not yet in the cheaters_unique
        # lists, b) are cheaters.
        for kill in game:
            if kill[0] not in game_cheaters:
                if 1 in kill:
                    game_cheaters.append(kill[0])
            if kill[1] not in game_cheaters:
                if 2 in kill:
                    game_cheaters.append(kill[1])

        # After iterating through all kills in a game,
        # append the game_cheaters list to the cheaters_unique list
        cheaters_unique.append(game_cheaters)

    # Return cheaters_unique list
    return cheaters_unique


def check_if_game_two_day(games_dict, game_number):
    '''Takes dictionary of games:list of kills and a number
    indexing the game (from one of many in the dictionary as argument.
    Returns a boolean indicator "two_day_game" to check if the game of
    interest reaches over two days.'''

    # Set up the boolean as false by default
    two_day_game = False

    # Extract the game[game_number] as a list from dict
    game = list(games_dict.values())[game_number]

    # Extract first and last kill time
    first_kill = game[0][2]
    last_kill = game[-1][2]

    # Change the boolean to true if the first and last kill
    # happened at two different dates.
    if first_kill.date() != last_kill.date():
        two_day_game == True

    # Return the boolean
    return two_day_game


def get_first_three_kill_cheaters(games_dict):
    '''Takes dictionary of games:list of kills as argument.
    Returns a list of account-ids representing the first cheater
    that committed three kills for every game (or a 0 if no cheater
    committed a kill), i.e. the length of the list will be equal to
    the number of keys in the dict.'''

    # Initialise empty list
    three_kill_cheaters = []

    for game in games_dict.values():

        # Add all killers in kills that were committed by cheaters
        game_all_cheaters = [kill[0] for kill in game if 1 in kill]

        # Set the value to be added to the list "three_kill_cheaters"
        # to be 0 by default
        the_cheater = 0

        # Initialise a dictionary that records kills of all cheaters
        # in timely order, set "the_cheater" to the account-id that
        # is first found to kill thrice, then break loop
        cheater_occurence_dict={}
        for i in game_all_cheaters:
            if game_all_cheaters.count(i) > 2:
                if i in cheater_occurence_dict:
                    cheater_occurence_dict[i] += 1
                else:
                    cheater_occurence_dict[i] = 1
                if cheater_occurence_dict[i] == 3:
                    the_cheater = i
                    break

        # Append the account-id (or 0 if no cheater killed more
        # than 2 times to the "three_kill_cheaters"-list.
        three_kill_cheaters.append(the_cheater)

    return three_kill_cheaters



if __name__ == '__main__':
    main()
