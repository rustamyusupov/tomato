# Tomato :tomato:

Tomato is a command-line tool to set slack status (emoji and text) and availability.

- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Credits and license](#credits-and-license)

## Installation

1. Install Tomato `brew install tomato`
2. Generate Slack [legacy token](https://api.slack.com/custom-integrations/legacy-tokens)
3. Run `tomato` and set token from step 2

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

## Credits and license

By Rustam Yusupov 2018-12-26 under the MIT license.
