---
title: Corescripts setup
description: How to set up corescripts, allowing them to be loaded and served by the Site.
---

This guide explains how corescripts can be set up to be modified, and configured to be served by the Site.

## Terminology

The term "corescripts" can sometimes be ambiguous or refer to multiple things. In Mercury Core, the following definitions apply:

- **Builtins**: These are scripts, models, or other assets that are distributed with the client (therefore not loaded from the Site), and provide core functionality such as animations, character scripts (health regeneration, humanoid state), fonts, and some basic meshes.
- **Hardcoded assets**: These are assets with IDs that are hardcoded into the client which cannot easily be changed, though they are still loaded from the Site. This includes things like the Health model (the bar at the bottom of the screen, showing health and managing the red damage flash effect in some clients).
- **Loadscripts**: These are some of the first scripts that run when a place is loaded, for example the Host script, loaded by Studio when running the command to host a place, or the Join script, loaded by the Client when a user joins a place.
- **Corescripts**: These are scripts that run on the Client. They provide functionality such as GUI elements, chat, and user interface. Corescripts are loaded from the Site, and each has a unique asset ID.  
The Join script loads the Starter script (default ID 37801172), and the Starter script loads the rest of the corescripts. These scripts can be modified to change the IDs, so the IDs can be easily changed, as long as they are compatible with the client (this means they usually have to be numeric and below 2147483647).
- **Dependencies**: These are assets (usually images) loaded by Corescripts, Builtins, or Hardcoded assets. They have their own unique IDs which, again, can be modified if needed, and are loaded from the Site.

Loadscripts are loaded from the Site, each from their own specific URL paths.  
Hardcoded assets, Corescripts, and Dependencies are all loaded as if they were normal assets from the Site. However, they are instead loaded from a separate directory from the other assets to improve ease of setup, updating, and management. It would theoretically be possible to set up Mercury Core normally, and upload all these assets to the Site like normal assets, but this would be an inconvenient and tedious process, especially in development where Database resets may be common.
