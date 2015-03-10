tournament results
=================

The pupose of this project is to develop a SQL database interface to run a virtual Swiss elimination
style tournament.  There are a few things this implementation assumes, even number of players and a single 
tournament round.

Use:
To see a demonstration of the project you will need a machine configured with PSQL and the latest version of Python 2.7.
Follow the following steps to run the program, assuming you've already downloaded the project contents.
Navigate to the project folder
Run PSQL from the command line
Run the command "\i tournament.sql" to create the database
Run the command "\q" to exit the database enviroment
Run the command "python tournament_test.py" to run the simulation

A program that meets specification will have the following read out at the console:
1. Old matches can be deleted.
2. Player records can be deleted.
3. After deleting, countPlayers() returns zero.
4. After registering a player, countPlayers() returns 1.
5. Players can be registered and deleted.
6. Newly registered players appear in the standings with no matches.
7. After a match, players have updated standings.
8. After one match, players with one win are paired.
Success!  All tests pass!


Steven Marr
stevenmarr@me.com
