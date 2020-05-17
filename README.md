# SSync

**S**erver **Sync**hronization, or SSync for short, is a ULib module that automatically synchronizes data from your Garry's Mod server to a MySQL database.

## Dependencies

- [ULib](https://github.com/TeamUlysses/ulib) v2.63 or higher (may work with older versions)
- [MySQLOO](https://github.com/FredyH/MySQLOO)

## Installation
Download the latest version from the [Releases](https://github.com/iViscosity/SSync/releases) page, and extract it to your server's `addons` folder!

Once done, you should have a file structure like:

`/garrysmod/addons/ssync/lua/autorun/server/ssync_init.lua`

`/garrysmod/addons/ssync/lua/ssync/config.lua`

A server restart is **required**, not just a map change. Make sure you edit all configuration information in `/garrysmod/addons/ssync/lua/ssync/config.lua`  **before** turning the server back online!

## Usage

SSync is completely automated, so you don't have to do anything except provide it the information to connect to your Database!

## 