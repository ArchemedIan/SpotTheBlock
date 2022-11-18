# SpotTheBlock

Companion daemon to [BlockTheSpot](https://github.com/mrpond/BlockTheSpot): a Spotify advert/banner disabler.
## What This Does

- Updates [BlockTheSpot](https://github.com/mrpond/BlockTheSpot) after Spotify overwrites it with an update (via advert detection) 
- Checks for a new version of [BlockTheSpot](https://github.com/mrpond/BlockTheSpot) every 6 hrs, and prompts to update it.


## Features

- Small Footprint (~5-6 mb RAM usage)
- Minimal user interaction needed (a few clicks to install, one to update when prompted)
- Advertisement Detection (for reinstalling after Spotify updates overwrite [BlockTheSpot](https://github.com/mrpond/BlockTheSpot))
- Checks for updates every 6 hours

### Pre-requisites

- [Spotify](https://www.spotify.com/us/download/windows/) (obviously)
- [*Current* AHK](https://www.autohotkey.com/download/ahk-install.exe) **Not version 2**

## Installation

- Download AHK from above and Install it.
- [Download the latest SpotTheBlock zip](https://github.com/ArchemedIan/SpotTheBlock/archive/refs/heads/main.zip) 
- Extract anywhere
- Compile SpotTheBlockInstaller.ahk (Right-click > Compile)
- Run it from anywhere to start the install process
- **Updates to SpotTheBlock are installed the same as above.**


# Usage

on first run, follow propmpts. then forget.

### Notes

- this is a daemon, it just runs in the background and has no gui unless an advert is detected (or first run)

- when spotify updates, it will (eventually) detect an advert being played and prompt to (re)install BlockTheSpot



## Roadmap

- ~~Check for and install BlockTheSpot Updates~~ (implemented)

- Maybe add a keycombo to bypass advert detection and (re)install BlockTheSpot manually.

