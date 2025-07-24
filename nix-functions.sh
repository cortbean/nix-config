#!/bin/bash

function nFull() {
    echo "Full update nix"

    nh os switch --update
    
    echo "\nDo you want to delete old generations (Keep 3)? [y/N] "
    read REPLY

    # Permet que de garder les 3 dernières générations
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo nh clean all --keep 3

    #     echo "How far back in the configuration history (in days) do they want to go? "
    #     read REPLY
    #
    #     days=$REPLY+"d"
    #     sudo nix-collect-garbage --delete-older-than $days
    fi

    sudo nix-store --gc # Nettoyer les dérivations inutilisées (garbage collection)
    nh os boot # Pour enlever se qui se trouve dans le boot

    echo "\nDo you want to list the generations? [y/N] "
    read REPLY

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system # Lister les builds
    fi
}

function nBuild() {
    echo "1. Test before applying permanently" # Loads the new configuration temporarily, without making it persistent.
    echo "2. Build the configuration without applying it" # Compiles the new configuration but does not activate it.
    echo "3. Rebuilding the system after modifying configuration files" # This recompiles the configuration and applies the changes immediately without requiring a reboot (unless it's a critical change).

    echo "\nWhat do you want to do?"
    read choice

    case $choice in
        1)
            TMPDIR=/tmp nh os test
            ;;
        2)
            TMPDIR=/tmp nh os build
            ;;
        3)
            nh os switch
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}
