# PopUpHauntedHouse-New

The Pop-up Haunted House project is an attempt to use Bluetooth low energy beacons to make any house a haunted house. The goal is to establish a JSON storytelling format, which matches beacon IDs to actions. Right now, the plan is to make those actions audio. So you place your beacons, put on your headphones, turn off the lights, and follow the story. Your own house becomes haunted!

What's more is that we plan on expanding the actions you can program. Say you want to call a server, which in turn projects something on the wall. Or you want to call a server, which in turn causes your phone to ring. Or a smart-lightbulb to flicker.

But it's not just abotu scaring the pants off you. The JSON format should allow for any kind of story you want to tell.

# Story Progression
One of the cool ideas we're baking into this framework is the idea that approaching a beacon once triggers one action. Then approaching the beacon a second time triggers another action. So there is a story progression there. In the future, we'll keep adding more complex rules, so that your approach to a beacon is based on where you are in a story, which other beacons you've approached, etc.

This is a Murmur Labs project and we invite anyone to contribute as we move forward.

It's our further hope to integrate this with our data_storyteller project, which we use to take in inputs, match those to metadata, and then make decisions on where to send you next.

Data_storyteller is a RESTful web service written on a LAMP stack and is available in our public repo.
