#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SHOW_MENU(){

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  GET_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$GET_SERVICES" | while read ID BAR NAME
  do
    echo -e "\n$ID) $NAME"
  done

  echo -e "\nChoose a service"
  read SERVICE_ID_SELECTED

  SERVICE_ID=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_ID ]]
  then
    SHOW_MENU "Choose a correct option"
  else
    echo -e "\nEnter a phone number"
    read CUSTOMER_PHONE
    GET_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $GET_NUMBER ]]
    then
      echo -e "\nEnter your name"
      read CUSTOMER_NAME
      ENTER_CUSTOMER_DATA=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
    echo -e "\nEnter a date"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' OR phone='$CUSTOMER_PHONE'")

    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

    ENTER_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    if [[ $ENTER_APPOINTMENT == "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME"
    else
      echo $ENTER_APPOINTMENT
    fi
  fi
}

SHOW_MENU
