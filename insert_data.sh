#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE teams,games")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERG OPPONENTG
do
  # INSERT WINNER TEAM
  if [[ $WINNER != winner ]]
  then
    # get team
    GET_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")"
    # if not found
    if [[ -z $GET_TEAM ]]
    then
      # insert team
      INSERT_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
      echo "Team $WINNER was inserted successfully"
      fi
      # get new team
      GET_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")"
    fi
  fi
  # INSERT OPPONENT TEAM
  if [[ $OPPONENT != opponent ]]
  then
    # get team
    GET_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")"
    # if not found
    if [[ -z $GET_TEAM ]]
    then
      # insert team
      INSERT_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
      echo "Team $OPPONENT was inserted successfully"
      fi
      # get new team
      GET_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")"
    fi
  fi
done

# Insert games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERG OPPONENTG
do
  if [[ $YEAR != year ]]
  then
    GET_WINNER="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")"
    GET_OPPONENT="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")"
    if [[ $GET_WINNER == $WINNER ]]
    then
      GET_WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
      GET_OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
      INSERT_GAMES="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND', $GET_WINNER_ID,$GET_OPPONENT_ID,$WINNERG,$OPPONENTG)")"
      if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
        echo "Game inserted, $WINNER $OPPONENT"
      fi
    fi
  fi
  
done