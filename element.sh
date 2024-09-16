#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]];
then
  echo Please provide an element as an argument.
elif [[ $1 =~ ^[0-9]+$ ]];
then
  ATOMIC_NUMBER_QUERY_RESULT=$($PSQL "SELECT t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, e.symbol, e.name
                                      FROM properties p LEFT JOIN elements e
                                      USING(atomic_number)
                                      LEFT JOIN types t
                                      USING(type_id)
                                      WHERE atomic_number=$1"
                              )
  if [[ -n $ATOMIC_NUMBER_QUERY_RESULT ]];
  then
    echo $ATOMIC_NUMBER_QUERY_RESULT | while read TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT BAR SYMBOL BAR NAME
    do
      echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    echo I could not find that element in the database.
  fi
else
  ATOMIC_SYMBOL_QUERY_RESULT=$($PSQL "SELECT t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, e.atomic_number, e.name
                                      FROM properties p LEFT JOIN elements e
                                      USING(atomic_number)
                                      LEFT JOIN types t
                                      USING(type_id)
                                      WHERE symbol='$1'"
                              )
  if [[ -n $ATOMIC_SYMBOL_QUERY_RESULT ]];
  then
    echo $ATOMIC_SYMBOL_QUERY_RESULT | while read TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT BAR ATOMIC_NUM BAR NAME
    do
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    NAME_QUERY_RESULT=$($PSQL "SELECT t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, e.atomic_number, e.symbol
                                      FROM properties p LEFT JOIN elements e
                                      USING(atomic_number)
                                      LEFT JOIN types t
                                      USING(type_id)
                                      WHERE name='$1'"
                        )
    if [[ -n $NAME_QUERY_RESULT ]];
    then
      echo $NAME_QUERY_RESULT | while read TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT BAR ATOMIC_NUM BAR SYMBOL
      do
        echo "The element with atomic number $ATOMIC_NUM is $1 ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius." 
      done
    else
      echo I could not find that element in the database.
    fi
  fi
fi
