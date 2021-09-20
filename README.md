# GB-SMART-multiboot-rom-manager
A GNU Octave/Matlab tool to build a multiboot rom for GB SMART 16M / GB SMART 32M

The purpose of this project is to rejuvenate the multiboot support for GB SMART 16M / GB SMART 32M flash cartridges that was abadon years ago.

##The story##

One common flashcard for Game Boy In the early 2000 was the GB SMART 16M / GB SMART 32M rewritable cartridge. It was bundled with a parallel flasher like the odd GB-Transferer. The GB SMART cartridge itself was able to emulate many common Game Boy mappers from this era and still today it is an intersting piece of hardware to use.
The parallel GB-transferer itself had a particular interesting feature : it was certainly able to flash single rom and dump cartridges, but it was also able to create a multiboot rom.  The principle was to inject a particular custom multiboot rom first, then the other games. The custom multiboot rom probably had special instructions to lock certain high addresses pin of the cartridge custom mapper and allow any game to be seen as working with normal addresses range from a Game Boy whatever its actual position in the flash chip.
Unfortunately, the GB transferer software was not open access and has becomed completely obsolete until Windows Vista. More recently the software support for parallel port was even abandon on Windows. So the GB-transferers now sleep in drawers for eternity.
In the other hand, GB SMART 16M / GB SMART 32M cartridges are still usable with any compatible good flasher (see Insidegadget) and the custom multiboot rom is easy to find on internet as it is a simple .gb file.
The global working principle of the multiboot rom is explained here in details: see Insidegadget.
The custom multiboot rom must be at the root of the GB SMART cartridge (first 32 kB) and the other roms are aligned at offsets multiple of there own size (for example 32 kB roms must be aligned at offsets 0x008000, 0x010000, 0x018000, etc., 512 kB roms must be aligned at offsets 0x80000, 0x10000, etc.).  Consequence : GB SMART 16M (2MB) can at most handle one 1MB rom (plus other smaller roms)  and GB SMART 32M (4MB) one 2MB rom (plus other smaller roms). Final rule, the multiboot can handle 15 roms only (in fact 16, 15 + the custom multiboot rom). 
When booting the system, the custom multiboot rom searches for a Game Boy logo every 32 kB after itself, deduces starting adresses for rom (and mapper pinout locking), creates the multiboot menu and allows the player to boot the desired rom.
So the trick now is to recreate a fully working multiboot rom system that fits a maximum number of roms into the GB SMART cards with these rules. The big rom obtained can then be written with any modern flasher.
How to use it ?
Simply dump roms in the /roms folder and run the code. The principle is simple : big roms first and first seen first placed. When no slots remain for writing, roms are simply rejected. If the cumulative size (2MB or 4MB) or number (15) of roms is bigger than the cartridge capacity, the code stops with an error message. The code generates a big OUTPUT.GB containing the « filesystem » and ready to write.
Two versions of code are proposed : one for GB SMART 16M and one for GB SMART 32M. I developped the software on GB SMART 32M but I assume the rules are the same for GB SMART 16M (Except for tye total size).
The code could seem weird for Matlab veterans but it was made to be fully compatible with GNU Octave so some advance features of Matlab were not usable (like directly sorting structures for example).
Knows flaws
I own the Parallel GB-transferer and I remind the multiboot support as beeing a very glitchy feature. I do not even remind been able to make it work even one single time. I though it was due to some noise on the parallel line port. In fact the multiboot support IS glitchy for real. The GNU Octave/Matlab code proposed here is much better than the original piece of crap of software, but certain games still refuses to work in multiboot. Particularly the GBC support is particularly poor (a GBC game boots by default in DMG mode… at most) and game like Links Awakening works but crashes when saving (saving make the game reboot in an undesired state). Pokémon games seem OK at first glance but do not forget that every game shares one single sram, so any save erases the other.
Last but not least of a flaw, the multiboot is supported by GB SMART cards ONLY due to their particular custom mappers, so any other flash carts will not work… Surprisingly BGB emulator supports this mapper.
Well, knowing these limitations, have fun with it !
