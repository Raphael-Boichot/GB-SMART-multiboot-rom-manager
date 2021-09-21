# GB SMART 16/32M multiboot rom manager for Game Boy
A GNU Octave/Matlab tool to build a multiboot rom for GB SMART 16M / GB SMART 32M flash cartridges.

The purpose of this project is to rejuvenate the multiboot support for GB SMART 16/32M flash cartridges that was abandoned years ago.

![GB SMART 32M](https://github.com/Raphael-Boichot/GB-SMART-multiboot-rom-manager/blob/main/1632161467401.png)

## The story

In the early 2000, the GB SMART 16/32M were quite common flashable cartridges for Game Boy. They was bundled with a parallel-port flasher like the odd GB-Transferer. The GB SMART cartridges were able to emulate many common Game Boy mappers from this era and are still intersting pieces of hardware with a very broad compatility (even by today's standards).

The parallel GB-transferer itself had a particular interesting feature : it was not only able to flash single rom and dump cartridges, but it was also able to create a multiboot rom cartridge. The principle was to inject a particular custom multiboot rom first, then the other games to the flash chip. The custom multiboot rom had probably special instructions to lock certain high address pins of the cartridge custom mapper which allow any game to be seen as working with normal addresses range from a Game Boy, whatever its actual position in the flash chip.

Unfortunately, the GB transferer software was not open access and became completely obsolete since Windows Vista. More recently the software support for parallel port was also abandon on Windows. So the GB-transferers now sleep in drawers for eternity.

In the other hand, GB SMART 16/32M cartridges are still usable today with any compatible good flasher (https://www.gbxcart.com/) and the custom multiboot rom is easy to find on internet as it is a simple .gb file.

The global working principle of the multiboot rom is explained here in details: 
https://www.insidegadgets.com/2019/05/24/a-look-into-the-gb-smart-16m-flash-cart-inspecting-the-multi-game-menu-adding-flashing-support-and-a-basic-menu-maker/

The custom multiboot rom must be at the root of the GB SMART cartridge (first 32 kB) and the other roms are aligned at offsets multiple of there own size (for example 32 kB roms must be aligned at offsets 0x8000, 0x10000, 0x18000, etc., 512 kB roms must be aligned at offsets 0x80000, 0x10000, etc.). Consequence : GB SMART 16M (2MB) can at most handle one 1MB rom (plus other smaller roms) and GB SMART 32M (4MB) one 2MB rom + one 1MB rom (plus other smaller roms). Final rule, the multiboot can handle 15 roms only (in fact 16, 15 + the custom multiboot rom) to fit on the 18 tile lines of a Game Boy screen. 

When booting the system, the custom multiboot rom searches for a Game Boy logo every 32 kB after itself, deduces starting adresses for rom (and mapper pinout locking), creates the multiboot menu and allows the player to boot the desired rom. So the trick now is to recreate a fully working multiboot rom system that fits a maximum number of roms into the GB SMART cards without the original software. 

## How to use the rom manager ?

Simply dump Game Boy roms in the /roms folder and run the code. The principle is simple : big roms first and first seen first placed. The multiboot "filesystem" is filled with big roms at higher addresses first to optimize the placement, then the size of rom and addresses are progressively reduced. When no slots remain for writing, roms are simply jumped. If the number of roms written is equal to the cartridge capacity, the code ends. The code generates a big OUTPUT.GB containing the whole « filesystem » that is ready to flash to your GB SMART card. You can check the rom with BGB emulator to be sure that everything is OK.

Two versions of code are proposed : one for GB SMART 16M and one for GB SMART 32M. I developped the software on GB SMART 32M but I assume the rules are the same for GB SMART 16M (Except for the total size).

The code could seem weird for Matlab veterans but it was made to be fully compatible with GNU Octave so some advance features of Matlab were not usable (like quick sorting of structures for example).

## Why it is not 100 % reliable...

I own the Parallel GB-transferer and I remind the multiboot support as beeing a very unreliable feature. I do not even remind been able to make it work even one single time correctly on real hardware. I though it was due to some noise on my parallel port. 

In fact the multiboot support was kind of glitchy for real. 

The GNU Octave/Matlab code proposed here is much better than the original piece of crap of Chinese software offered with the GB-transferer, but certain games still refuses to work in multiboot. Particularly the GBC support is average (a GBC game boots by default in DMG mode) and game like Links Awakening works but crashes when saving (saving make the game reboot in an undesired state). 

Pokémon games seem OK at first glance but do not forget that all games share one single sram, so any save erases the other.

This multiboot system does not support other multiboot cartridges either (game compilations), as a soft reboot makes the system crash (same problem than Link's Awakening). In fact any Game Boy game using an internal soft reboot will not be supported.

Last but not least, the multiboot feature is of course supported by GB SMART cards ONLY due to their particular custom mapper, so any other flash cart will not work… By using a regular flashable cartridge, you will just be stuck to the boot menu as address range locking is not available. Surprisingly the BGB emulator fully supports this weird mapper.

Just a last precision, a GB SMART 16/32M cartridge flashed with a single rom (both GB/GBC games) works like a charm. I found that the game compatibility is even broader than an EZ-flash for example.

## Well, knowing these limitations, have fun with it !

In conclusion, the good way of using the multiboot support is to have just one big GB game with save feature (like Pokémon) and many small GB games on the card. GBC games are midly advised in multiboot regarding the intrinsic system limitations.

