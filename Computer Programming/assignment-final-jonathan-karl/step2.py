import random
import data_preparation

# Point of Execution
def main():
    pass


# Randomise the each game compilation
def randomise_game(games_dict):
    '''Assumes a dictionary containing game-id's as keys
    and for each a list of lists (where each is a recorded
    kill in the game). Returns a new games_dict where the
    compilation of each game has been randomised, i.e.
    players that are not cheaters randomly change places.
    This preserves the times and numbers of kills of each player,
    only that they get assigned a new account-id from another player
    in the game, who also gets a new account-id and so on. Thereby,
    the players in each game don't change, only their (if non-cheating)
    position in the game.'''
    # This list will be used to iterate over for each game
    players = data_preparation.get_players(games_dict)

    # This list will be used to draw random players from,
    # with which the player in the current iteration
    # might be exchanged
    players_step2 = data_preparation.get_players(games_dict)

    # The following loops through every game,
    # randomly choosing a player for each player and then looping
    # through every kill in the game. Only positions in the game
    # that do not involve cheaters will be subject to randomisation
    # and temporary labels (3 for "a killer was randomised in this kill"
    # and 4 for "a kill-victim was randomised in this kill") will be assigned
    # to ensure complete randomisation.

    for game_number, game in enumerate(games_dict.values()):
        ls_to_choose_random = players_step2[game_number]
        for player in players[game_number]:
            random_player = random.choice(ls_to_choose_random)
            ls_to_choose_random.remove(random_player)
            for kill in game:
                # for the kills where a cheater was involved
                if 1 in kill or 2 in kill:
                    # Switch those killed by cheaters
                    if kill[3] == 1 and player == kill[1] and 4 not in kill:
                        kill[1] = random_player
                        kill.append(4)
                    # Switch those who killed cheaters
                    if kill[3] == 2 and player == kill[0] and 3 not in kill:
                        kill[0] = random_player
                        kill.append(3)

                # for the kills where no cheater was involved
                # Switch those that killed
                if player == kill[0] and 1 not in kill and 3 not in kill:
                    kill[0] = random_player
                    kill.append(3)
                # Switch those that were killed
                if player == kill[1] and 2 not in kill and 4 not in kill:
                    kill[1] = random_player
                    kill.append(4)

        # now remove all appended temporary lables (3's and 4's)
        for kill in game:
            if 3 in kill:
                kill.remove(3)
            if 4 in kill:
                kill.remove(4)

    # Return newly randomised games_dict containing
    # all games in new constellations
    return games_dict


if __name__ == '__main__':
    main()
