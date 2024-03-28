#!/usr/bin/env bash

# get passed argument for the type of rebuild (either system or home)
rebuild_type=$1

if [ -z $rebuild_type ]; then
  echo "This is a simple command line tool for rebuilding your NixOS. Please provide either system or home as an argument."
  exit 1
elif [ $rebuild_type == "system" ]; then
	sudo nixos-rebuild switch --flake
elif [ $rebuild_type == "home" ]; then
	home-manager switch --flake 
else
	echo "Invalid rebuild type. Please provide either system or home"
	exit 1
fi



