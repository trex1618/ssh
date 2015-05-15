#!/bin/bash

#defaults
PUBKEY=ssh/authorized_keys
PROMPT=false
HELP=false

#source config file.
. conf/config

while [[ $# > 0 ]]
do
  key="$1"
  shift

  case $key in
    --conf)
      CONFILE=$1
      shift
      # Override the default conf file
      . conf/config.$CONFILE
    ;;
    -id|--idkey)
      IDKEY=$1
      shift
    ;;
    -pp|--passphase)
      PASSPHASE=$1
      shift
    ;;
    -h|--host)
      HOST="$1"
      shift
    ;;
    -u|--username)
      USER="$1"
      shift
    ;;
    -p|--prompt)
      PROMPT=true
    ;;
    -h|--help|-?|--?)
      HELP=true
    ;;
    *)
      # unknown option
    ;;
  esac
done

if $HELP; then
  echo "create_sshkeys"
  echo " "
  echo "Create the ssh keys"
  echo "-p|--prompt           Prompt for the password"
  exit
  exit
fi

if $PROMPT; then
  read -p "Enter SSH passphase: " PASSPHASE
else
  PASSPHASE=
fi

if [ ! -d "ssh"]; then
  mkdir ssh
fi

#Create SSH pair
IDKEY=ssh/$USER\_rsa

if [ -e "$IDKEY" ]; then 
  rm -f $IDKEY
fi

ssh-keygen -t rsa -f $IDKEY -N "$PASSPHASE" -C $USER@$HOST

if [ -e "$IDKEY.pub" ]; then 
  echo "" >> $PUBKEY
  cat $IDKEY.pub >> $PUBKEY
fi


