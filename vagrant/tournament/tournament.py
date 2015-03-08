#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2

def connect():
    """Connect to the PostgreSQL database.  Returns a tuple of a database connection and cursor."""
    conn = psycopg2.connect("dbname=tournament")
    cur = conn.cursor()
    return (conn, cur)

def deleteMatches():
    """Remove all the match records from the database."""
    conn, cur = connect()
    cur.execute("DELETE FROM matches")
    conn.commit()
    conn.close()
    
def deletePlayers():
    """Remove all the player records from the database."""
    conn, cur = connect()
    cur.execute("DELETE FROM players")
    conn.commit()
    conn.close()

def countPlayers():
    """Returns the number of players currently registered."""
    conn, cur = connect()
    cur.execute("SELECT COUNT(*) as num from players")
    result = cur.fetchone()[0]
    conn.close()
    return result

def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
    conn, cur = connect()
    cur.execute("INSERT INTO players (name) VALUES (%s)", (name,))
    conn.commit()
    conn.close()

def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    conn, cur = connect()
    cur.execute("SELECT * FROM complete_standings ORDER BY wins DESC;")
    results = cur.fetchall()
    standings = [(q[0], q[1], int(q[3]), int(q[2])) for q in results]    
    conn.close()
    return standings

def playerCount():
    """Returns the number of registered players from the database

    Returns:
        An int of the number of registered players."""
    conn, cur = connect()
    cur.execute('SELECT COUNT(*) as number FROM players')
    result = int(cur.fetchone()[0])
    conn.close()
    return result

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    conn, cur = connect()
    cur.execute("INSERT INTO matches (winner, loser) VALUES (%s, %s)", (winner, loser))
    conn.commit()
    conn.close()

def getMatchesPlayed():
    """Returns a list of pairs of players for that have already played against each other.
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    conn, cur = connect()
    cur.execute("SELECT * FROM matches_played")
    results = cur.fetchall()
    matches_played = [(m[1], m[0], (m[3]), m[2]) for m in results]  
    conn.close()
    return matches_played

def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    standings = playerStandings()
    matches_played = getMatchesPlayed()
    pairings = []
    i = 1
    while i < len(standings):
        match = (standings[0][0], standings[0][1], standings[i][0], standings[i][1])
        if match not in matches_played: 
            pairings.append(match)
            standings.pop(i)
            standings.pop(0)
            i = 1
        elif i == len(standings)-1:
            pairings.append(match)
            break
        else:
            i += 1
    if len(pairings) == playerCount()/2:
        return pairings
    else: return []

    