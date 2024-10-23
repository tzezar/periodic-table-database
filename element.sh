#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # If input is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type 
                     FROM elements 
                     INNER JOIN properties USING(atomic_number) 
                     INNER JOIN types USING(type_id) 
                     WHERE atomic_number=$1")
  else
    # If input is a symbol or name
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type 
                     FROM elements 
                     INNER JOIN properties USING(atomic_number) 
                     INNER JOIN types USING(type_id) 
                     WHERE symbol='$1' OR name='$1'")
  fi

  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME MASS MELTING BOILING TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
