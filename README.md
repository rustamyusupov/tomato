# Tomato :tomato:
Tomato is a command-line tool to set slack status (emoji and text) and availability.

* [Installation](#installation)
* [Usage](#usage)
* [Examples](#examples)
* [Aliases](#aliases)
* [Credits and license](#credits-and-license)

## Installation
1. Download and install [Erlang](https://www.erlang-solutions.com/resources/download.html) Package (Erlang -> Your OS -> Standard -> Last version)
2. Generate Slack [legacy token](https://api.slack.com/custom-integrations/legacy-tokens)
3. [Set environmet variable](https://gist.github.com/rustamyusupov/fbbec3785b7876bfe9712a2e2b9ef5ef) TOMATO_TOKEN="your token from step 2"
4. Download [tomato](https://github.com/rustamyusupov/tomato/raw/master/tomato) app
5. Make the Tomato executable by typing in console: `chmod a+x tomato`

## Usage
Run `./tomato` without parameters to show help.

`./tomato [parameters]`  
  -e - Emoji: status emoji  
  -t - Text: status text  
  -p - Presence: auto | away  
  -d - Duration: how long set status in minutes  
  -s - Say: command say phrase at the end

## Examples
Set emoji :tomato:, message "working", presence "away", during 25 minutes, after time end say "finished" and clear status and presence:
```
./tomato -e :tomato: -t working -p away -s finished -d 25
```
Set emoji :slack_call:, text "meeting":
```
./tomato -e :slack_call: -t meeting
```

## Aliases
Examples of possible aliases:
- work: `./tomato -e :tomato: -t working -p away -s finished -d 25`
- lunch: `./tomato -e :fork_and_knife: -t eating -p away -d 60`
- meet: `./tomato -e :slack_call: -t meeting`
- away: `./tomato -p away`
- active: `./tomato -p auto`
- afk: `./tomato -e :runner: -t AFK -p away -d 30`
- rs (remove status): `./tomato -e -t -p auto`

## Credits and license
By Rustam Yusupov 2018-12-24 under the MIT license.
