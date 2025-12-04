# My productivity dotfiles built via ansible
#### These dotfiles assume an Archlinux installed via archinstall in the minimal configuration with pipewire pre-installed via the audio option.

## Install dependencies
```bash
ansible-galaxy install -r requirements.yml
```

## Install the dotfiles
```bash
ansible-playbook -K playbooks/install_all.yml
```

# Motivation
I used to use [@prasanthrangan's hyprdots](https://github.com/prasanthrangan/hyprdots) for a long while, and even though there way breaking changes here and there after updating, it was fine for the most part and I enjoyed the aesthetics. It also was my first ever serious view of Hyprland (on Arch btw) and what it could offer. I mainly use my machine to code with a gaming session here and there and for the former switching to Hyprland from KDE Plasma was a big boost in productivity.

Over time I added more and more customizations that would make my workflow better, but at the same time these dotfiles evolved into a bigger project driven by a larger community: the [HyDE-Project](https://github.com/HyDE-Project/HyDE). And as the project grew, the bloat grew with it. And so did the incompatibilities between my preferences and new bloat that came in over time. At one point I stopped updating alltogether, which obviously wasn't a feasable long-term solution.

One day I wiped my system and tried giving HyDE another chance, throwing out my customizations for now and trying out the out-of-the-box experience it could offer. When I couldn't get rid of the opacity all windows had I rage quit. Even after removing every single windowrule statement containing opacity settings my windows were still all at 95% opacity or something around that.

This is when i decided to throw it all out and just start from mostly scratch, taking inspiration from the project and other bits an pieces I found on the way.

First of all, I don't get why people use bash scripts to install/update/backup their dotfiles, when there are better tools for the job. That's why I use ansible. It's way easier to reason about and expanding the project is quite trivial with it.

Secondly, I like aesthetics, but when they get in my way I don't want them at all. After updating my system both hyprdots and HyDE would occasionally have their themes broken, which would require a separate update of the dotfiles which wouldn't solve it every time either. That's why I opted for Breeze-Dark and thats it. A stable dark theme, I don't need much more than that.

And now after a week or so I have what I would consider a quite simple hyprland setup where productivity is the number one priority. The project is not too modular, there is quite a bit of config duplication, there is not rollback/backup system and it has some issues I haven't fixed yet (such as long startup times for firefox-related flatpaks), but It's good enough for me for now and it shouldn't be too dificult for a third party to reasona about my structure and adjust it to their own needs.

# Credits
- The many lessons I learned by taking a look at both [@prasanthrangan's dotfiles](https://github.com/prasanthrangan/hyprdots)'s and the [HyDE-Project](https://github.com/HyDE-Project/HyDE)'s config and scripts.
- The waybar config is a modified version of [@anmol-fzr](https://github.com/anmol-fzr)'s [config](https://github.com/anmol-fzr/waybar).
- The rofi config is taken from [@adi1090x](https://github.com/adi1090x)'s [rofi config collection](https://github.com/adi1090x/rofi) and modified.
- The hyprlock config is taken from [@justinmdickey](https://github.com/justinmdickey)'s [dotfiles](https://github.com/justinmdickey/publicdots) and modified.
- The KDE cache updater hook in the dolphin role is taken from [@egnrse](https://github.com/egnrse)'s [repo](https://github.com/egnrse/updateKDEcache.hook).

