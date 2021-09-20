# GB SMART multiboot rom manager for Game Boy
A GNU Octave/Matlab tool to build a multiboot rom for GB SMART 16M / GB SMART 32M flash cartridges.

The purpose of this project is to rejuvenate the multiboot support for GB SMART 16M / GB SMART 32M flash cartridges that was abandoned years ago.

## The story

In the early 2000, the GB SMART 16M / GB SMART 32M were common flashable cartridges for Game Boy. They was bundled with a parallel-port flasher like the odd GB-Transferer. The GB SMART cartridges were able to emulate many common Game Boy mappers from this era and are still intersting pieces of hardware with a very broad compatility (even by today's standards).

The parallel GB-transferer itself had a particular interesting feature : it was able to flash single rom and dump cartridges, but it was also able to create a multiboot rom cartridge. The principle was to inject a particular custom multiboot rom first, then the other games to the flash chip. The custom multiboot rom had probably special instructions to lock certain high address pins of the cartridge custom mapper which allow any game to be seen as working with normal addresses range from a Game Boy, whatever its actual position in the flash chip.

Unfortunately, the GB transferer software was not open access and became completely obsolete since Windows Vista. More recently the software support for parallel port was even abandon on Windows. So the GB-transferers now sleep in drawers for eternity.

In the other hand, GB SMART 16M / GB SMART 32M cartridges are still usable today with any compatible good flasher (https://www.gbxcart.com/) and the custom multiboot rom is easy to find on internet as it is a simple .gb file.

The global working principle of the multiboot rom is explained here in details: 
https://www.insidegadgets.com/2019/05/24/a-look-into-the-gb-smart-16m-flash-cart-inspecting-the-multi-game-menu-adding-flashing-support-and-a-basic-menu-maker/

The custom multiboot rom must be at the root of the GB SMART cartridge (first 32 kB) and the other roms are aligned at offsets multiple of there own size (for example 32 kB roms must be aligned at offsets 0x8000, 0x10000, 0x18000, etc., 512 kB roms must be aligned at offsets 0x80000, 0x10000, etc.). Consequence : GB SMART 16M (2MB) can at most handle one 1MB rom (plus other smaller roms) and GB SMART 32M (4MB) one 2MB rom + one 1MB rom (plus other smaller roms). Final rule, the multiboot can handle 15 roms only (in fact 16, 15 + the custom multiboot rom) to fit on a Game Boy screen. 

When booting the system, the custom multiboot rom searches for a Game Boy logo every 32 kB after itself, deduces starting adresses for rom (and mapper pinout locking), creates the multiboot menu and allows the player to boot the desired rom. So the trick now is to recreate a fully working multiboot rom system that fits a maximum number of roms into the GB SMART cards without the original software. 

## How to use the rom manager ?

Simply dump Game Boy roms in the /roms folder and run the code. The principle is simple : big roms first and first seen first placed. When no slots remain for writing, roms are simply rejected. If the cumulative size (2MB or 4MB) or number (15) of roms is bigger than the cartridge capacity, the code stops with an error message. The code generates a big OUTPUT.GB containing the whole « filesystem » that is ready to flash to your GB SMART card.

Two versions of code are proposed : one for GB SMART 16M and one for GB SMART 32M. I developped the software on GB SMART 32M but I assume the rules are the same for GB SMART 16M (Except for the total size).

The code could seem weird for Matlab veterans but it was made to be fully compatible with GNU Octave so some advance features of Matlab were not usable (like directly sorting structures for example).

## Why is it so unreliable ?

I own the Parallel GB-transferer and I remind the multiboot support as beeing a very glitchy feature. I do not even remind been able to make it work even one single time correctly on real hardware. I though it was due to some noise on the parallel line port. 

In fact the multiboot support was glitchy for real. 

The GNU Octave/Matlab code proposed here is much better than the original piece of crap of software, but certain games still refuses to work in multiboot. Particularly the GBC support is particularly poor (a GBC game boots by default in DMG mode… at most) and game like Links Awakening works but crashes when saving (saving make the game reboot in an undesired state). 

Pokémon games seem OK at first glance but do not forget that all games share one single sram, so any save erases the other.

This multiboot system does not support multiboot cartridges either (game compilations), as a soft reboot makes the system crash.

Last but not least of a flaw, the multiboot is supported by GB SMART cards ONLY due to their particular custom mapper, so any other flash carts will not work… Surprisingly BGB emulator supports this mapper.

Just a last precision, GB SMART 16M / GB SMART 32M cartridges flashed with a single rom like a regular flashable cartridge works like a charm.

## Well, knowing these limitations, have fun with it !

![GB SMART 32M](https://github.com/Raphael-Boichot/GB-SMART-multiboot-rom-manager/blob/main/1632161467401.png)
