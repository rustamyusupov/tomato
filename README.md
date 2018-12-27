# Tomato :tomato:
Tomato is a command-line tool to set slack status (emoji and text) and availability.

* [Installation](#installation)
* [Usage](#usage)
* [Examples](#examples)
* [Aliases](#aliases)
* [Credits and license](#credits-and-license)

## Installation
For Mac OS:
1. Install Tomato `brew install tomato`
2. Generate Slack [legacy token](https://api.slack.com/custom-integrations/legacy-tokens)
3. Run `tomato` and set token from step 2.

For Windows:
1. Download and install [Erlang](https://www.erlang-solutions.com/resources/download.html) Package  
Erlang -> Windows -> Standard -> Last version
2. Download and install [Elixir](https://repo.hex.pm/elixir-websetup.exe)
3. Download [tomato](https://github.com/rustamyusupov/tomato/raw/master/tomato) app
4. Move Tomato to Windows directory
5. Create file tomato.bat in Windows directory containig `ecript tomato %*`
6. Generate Slack [legacy token](https://api.slack.com/custom-integrations/legacy-tokens)
7. Run `tomato` and set token from step 6.

## Usage
Run `tomato` without parameters to show help.

`tomato [parameters]`  
&nbsp;&nbsp;&nbsp;&nbsp;-e - emoji: status emoji  
&nbsp;&nbsp;&nbsp;&nbsp;-t - text: status text  
&nbsp;&nbsp;&nbsp;&nbsp;-p - presence: auto | away  
&nbsp;&nbsp;&nbsp;&nbsp;-d - duration: how long set status in minutes  
&nbsp;&nbsp;&nbsp;&nbsp;-s - say: command say phrase at the end

## Examples
Set emoji :tomato:, message "working", presence "away", during 25 minutes, after time end say "finished", clear status and presence:
```
tomato -e :tomato: -t working -p away -s finished -d 25
```
Set emoji :slack_call: and text "meeting":
```
tomato -e :slack_call: -t meeting
```

## Aliases
Examples of possible aliases:
```
alias work='tomato -e :tomato: -t working -p away -s finished -d 25'
alias lunch='tomato -e :fork_and_knife: -t eating -p away -d 60'
alias meet='tomato -e :slack_call: -t meeting'
alias away='tomato -p away'
alias active='tomato -p auto'
alias afk='tomato -e :runner: -t AFK -p away -d 30'
alias rs='tomato -e -t -p auto' # remove status and presence
```
Run:  
```
work
rs
etc
```
 Aliases with params:
```
alias work='f() { tomato -e :tomato: -t $1 -p away -s "tomat finished" -d $2 };f'
alias lunch='f() { tomato -e :fork_and_knife: -t eating -p away -d $1 };f'
alias afk='f() { tomato -e :runner: -t AFK -p away -d $1 };f'
```
Run:  
```
work "Working on My Task Name" 10
lunch 30
afk 45
```
This aliases run:
```
tomato -e :tomato: -t Working on My Task Name -p away -s finished -d 10
tomato -e :fork_and_knife: -t eating -p away -d 30
tomato -e :runner: -t AFK -p away -d 45
```


## Credits and license
By Rustam Yusupov 2018-12-26 under the MIT license.
