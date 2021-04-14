# Wireguard Deployment Script for Ubuntu 20.04

This script will deploy a wireguard server to a Ubuntu 20.04 vm and automaticially generate keys and conf files to connect clients to it.

To run variables need to be passed to the script.

- 1 - $HowMany - How many keys would you like to generate"
- 2 - $StartingIPAddr - What is the starting ip the keys shoudl increment from. e.g: 10 would result in the first ip of the first key being x.x.x.10, the next would be x.x.x.11