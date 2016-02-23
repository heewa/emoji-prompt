This is small bash script that you can use to get emoji in your prompt.

- A terminal's emoji stays static for an hour.
- Every terminal gets a different, random emoji every hour.
- Random emoji are chosen from sets based on time of day.

For example:

```bash
# Morning
🍳 08:00:00~ $

# Daytime
🍄 14:00:00~ $

# Lunch
🍣 13:15:00~ $

# Back to daytime
📚 16:00:00~ $

# Afternoon snack
🍫 20:30:00~ $

# Evening drinks
🍺 22:00:00~ $

# Late night
🌃 03:00:00~ $
```

Using
-----

Drop this file somewhere, like your home dir:

```bash
curl 'https://raw.githubusercontent.com/heewa/emoji-prompt/master/emoji-prompt.sh' > ~/.emoji-prompt.sh
```

If you import that into your `~/.bashrc`, it'll give you a bash function
`CURRENT_EMOJI` that you can incorporate into your prompt. Because the emoji
change over time, you can't just set `$PS1` env var. You need to define a bash
function to set it. For example, in your `~/.bashrc`:

```bash
. ~/.emoji-prompt.sh
__UPDATE_PROMPT() {
    PS1="$(CURRENT_EMOJI) \u@\h $ "
}
export PROMPT_COMMAND="__UPDATE_PROMPT"
```

Which will give you prompts like:

```bash
🍹 heewa@airwa3 $
```

If you don't want the dark comma-ish suffix, or want to add it yourself, you
can get just the emoji with `$(CURRENT_EMOJI_RAW)` and the suffix with
`$EMOJI_SUFFIX`, used like:

If you're already using a function, you can similarly add it to that. For example,
I customized [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt) to
add emoji (and a few other small changes), by following
[the instructions](https://github.com/magicmonty/bash-git-prompt#further-customizations),
and placing the `CURRENT_EMOJI` fn call inside one of their prompt-portions:

```bash
GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_\$(CURRENT_EMOJI_RAW)$EMOJI_SUFF
IX${White}${Time12a}${Yellow}${PathShort}${ResetColor}"
```

And now my prompt looks like:

![emoji-git-prompt](https://cloud.githubusercontent.com/assets/232685/13192614/eb77c564-d73b-11e5-86d2-27552f55ffce.png)
