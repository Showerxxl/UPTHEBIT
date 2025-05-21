# Up The Bit

Up The Bit is an **iOS mobile game** that blends idle clicker mechanics with action-RPG progression and dynamic music integration. Players tap the main screen to generate in-game currency, which can be spent to level up their hero, upgrade skills, and equip better gear. The core gameplay centers on battling goblin enemies across multiple levels: each level is a 2D side-view stage filled with moving platforms and waves of goblins to defeat. As players defeat goblins and clear levels, they unlock new abilities and upgrades, driving continuous character progression. A standout feature of Up The Bit is its **Apple Music integration**: players can select a custom track for each level, and the game analyzes the song’s BPM so that platform movements and enemy spawn timings sync to the beat. This creates a unique, rhythm-driven experience where the player’s own music influences the challenge and pacing of the game.

## Key Features

- **Clicker-style Currency Generation:** The main screen functions like an idle clicker. Players tap to earn in-game currency and accumulate wealth even when not actively fighting. This currency is used to purchase upgrades and boost progression.  
- **RPG-style Character Progression:** Earn experience and currency by defeating goblins and completing levels. Level up the hero, unlock new skills, and equip improved weapons or armor to increase combat effectiveness. Character stats and abilities grow stronger over time, giving a satisfying sense of progression.  
- **Multiple Game Levels:** Progress through a series of distinct levels (dungeons, caves, forests, etc.), each increasing in difficulty and featuring new layouts. Every level introduces fresh platform configurations and enemy patterns, providing varied challenges as the player advances.  
- **Real-time Music Interaction:** Seamless **Apple Music** integration lets players choose a track for each level. The game uses the MediaPlayer and AVFoundation frameworks to analyze the selected song’s tempo (BPM) in real time. Platform movement speeds, obstacle timing, and goblin spawn intervals are dynamically adjusted to match the music beat, creating an adaptive gameplay experience that changes with each track.  
- **Animated 2D Gameplay (SpriteKit):** The game features vibrant 2D graphics and smooth animations powered by Apple’s SpriteKit engine. Characters, enemies, and environments are all rendered in a cartoon style. SpriteKit’s physics and animation systems enable responsive platform movements and collision detection for jumping and attacking.  
- **Modular VIPER Architecture:** The codebase is organized using the VIPER design pattern (View, Interactor, Presenter, Entity, Router). This modular architecture ensures a clean separation of concerns, making the project easier to maintain and extend. Each screen and game module follows VIPER conventions, facilitating scalable development.  
- **Rhythm-Synced Platform & Enemy Behavior:** In addition to dynamic music-driven spawns, platforms and traps in each level move in time with the chosen music track. For example, platforms may oscillate or jump on the beat, and enemies may appear in rhythmic pulses. This synchronization enhances the game’s immersion and ties the audio and visual elements together in real time.
 

## Technology Stack

- **iOS & Swift:** Core development for iPhone/iPad platform using Swift (latest version).  
- **SpriteKit & UIKit:** SpriteKit for 2D game rendering and animations; UIKit for menus, HUD, and system interfaces (e.g. level select, settings screens).  
- **AVFoundation & MediaPlayer:** Apple’s AVFoundation and MediaPlayer frameworks are used to play audio and access Apple Music. The app queries the BPM of user-selected tracks to sync game events.  
- **VIPER Architecture:** The app is structured using VIPER, promoting modular, testable code. Each game module (e.g. Battle Level, Shop, Main Menu) follows the VIPER components (View, Interactor, Presenter, etc.) for clear organization.  
- **UserDefaults:** Simple persistent storage via UserDefaults is used to save player progress, unlocked levels, and settings (such as high scores or user preferences) between sessions.  

## Future Plans

- **New Levels and Environments:** Add additional game levels with unique themes (e.g. icy caverns, lava dungeons) and more challenging goblin variants. Each new level will introduce novel obstacles and layout designs.  
- **Customization & Upgrades:** Implement more character customization options such as new outfits, weapon skins, and cosmetic effects. Expand the upgrade system with additional skill trees or power-ups for deeper RPG mechanics.   
- **Monetization Strategies:** Introduce optional in-app purchases such as premium currency packs, cosmetic items, or “remove ads” features. Consider ad support (e.g. rewarded video ads for currency bonuses) to monetize the game while keeping it free-to-play.  
- **Polish and Platform Expansion:** Continue refining UI/UX, animations, and sound design based on player feedback.
## Author Info

- **Developer:** Igor Markin  
- **Context:** Course project at HSE University, Faculty of Computer Science (Class of 2025)
