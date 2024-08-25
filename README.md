# Backstabbing Framework for BG3

[Downloads available here](https:)

### For Users

Just download the mod, and place it after _every_ mod that requires it.

### For Mod Authors

If you're interested in the backstabbing mechanic (the one I used in [shade](https://www.nexusmods.com/baldursgate3/mods/10781?tab=description), then this project is meant for you. It features an easily configurable, and very much refined, backstabbing mechanic that also works outside of combat, unlike my shade mod. All you need to do is to place a [BackstabbingBlueprint.json](https://github.com/Lunisole/BackstabbingFramework/blob/main/Mods/BackstabbingFramework/BackstabbingBlueprint-Example.json) next to your meta.lsx.

The backstabbing state is handled through a status, called ```BACKSTABBING_FRAMEWORK_MAIN_STATUS_200001```, so for you to be able to use backstabbing this status will have to show up as conditions to the passives, spell, scripts or whatever you want of your mod. I'll consider supporting custom status later.
