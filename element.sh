#!/bin/bash

# Define the PSQL command
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  INPUT=$1

  # Function to display the element details
  DISPLAY_DATA () {
    if [[ -z $1 ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$1" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
      do
        # Trim leading/trailing spaces using `sed` and format output properly
        ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed 's/^[ \t]*//;s/[ \t]*$//')
        SYMBOL=$(echo $SYMBOL | sed 's/^[ \t]*//;s/[ \t]*$//')
        NAME=$(echo $NAME | sed 's/^[ \t]*//;s/[ \t]*$//')
        ATOMIC_MASS=$(echo $ATOMIC_MASS | sed 's/^[ \t]*//;s/[ \t]*$//')
        MELTING_POINT=$(echo $MELTING_POINT | sed 's/^[ \t]*//;s/[ \t]*$//')
        BOILING_POINT=$(echo $BOILING_POINT | sed 's/^[ \t]*//;s/[ \t]*$//')
        TYPE=$(echo $TYPE | sed 's/^[ \t]*//;s/[ \t]*$//')

        # Display formatted output
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  }

  # Check if input is a number (atomic number)
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then
    # Query using atomic number
    DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$INPUT")
    DISPLAY_DATA "$DATA"
  else
    # Query using symbol or name
    DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$INPUT' OR name='$INPUT'")
    DISPLAY_DATA "$DATA"
  fi
fi
