# Backstabbing Framework for BG3

[Downloads available here](https:)

### For Users

Just download the mod, and place it after _every_ mod that requires it.

### For Mod Authors

#### BackstabbingBlueprint.json

If you're interested in the backstabbing mechanic (the one I used in [shade](https://www.nexusmods.com/baldursgate3/mods/10781?tab=description), then this project is meant for you. It features an easily configurable, and very much refined, backstabbing mechanic that also works outside of combat, unlike my shade mod. All you need to do is to place a [BackstabbingBlueprint.json](https://github.com/Lunisole/BackstabbingFramework/blob/main/Mods/BackstabbingFramework/BackstabbingBlueprint-Example.json) next to your meta.lsx.

This file contains what spells/passives enable backstabbing in your mod.

The first 2 fields (EnablingSpells and EnablingPassives) are for easy configuration but aren't very customizable (Spells and Passives in those 2 fields will use the default backstabbing angle of 90°).
For instance in the example, there is "Projectile_FireBolt" in EnablingSpells, so any character will be able to backstab with that spell, and we also have "SneakAttack_Unlock" in EnablingPassives, so any character with this passive will be able to backstab (with any spell).

The next field is Custom, which lets you customize the backstabbing angle of specific spells and passives.
We need to put a list of 2 values in this field, the first one being the name of the spell/passive, and the second one being its associated backstabbing angle. If the angle is 90°, then it's basically the same as the first 2 fields mentionned above, although it'll still work. For instance in the example we have ```["Target_MainHandAttack",180]``` in Custom.Spells and ```["UnlockedSpellSlotLevel2",240]``` in Custom.Passives.

The Angle is this file are basically divided by 2, and applied on each side of the character. So an angle of 90° is equal to 45° on each side of a character, and 180° is equal to 90° on each side (so basically if you're in the demi-circle on the back of the character). An angle of 360° means you'll always backstab.

#### The Backstabbing Status

The backstabbing state is handled through a status, called ```BACKSTABBING_FRAMEWORK_MAIN_STATUS_200001```, so for you to be able to use backstabbing this status will have to show up as conditions to the passives, spell, scripts or whatever you want of your mod. I'll consider supporting custom status later.

