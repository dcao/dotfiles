{ colors ? import ./colors, world-wall, ... }:

''
  ignore-empty-password
  image=${world-wall}/share/artwork/gnome/world.png
  font=Iosevka
  indicator-radius=128
  indicator-thickness=6

  bs-hl-color=${colors.base08}
  key-hl-color=${colors.base0B}

  indicator-caps-lock

  inside-color=00000000
  inside-clear-color=${colors.base00}
  inside-caps-lock-color=00000000
  inside-ver-color=${colors.base0D}88
  inside-wrong-color=${colors.base08}88

  line-uses-ring

  ring-color=00000000
  ring-clear-color=${colors.base02}
  ring-caps-lock-color=${colors.base0E}55
  ring-ver-color=${colors.base0D}
  ring-wrong-color=${colors.base08}

  separator-color=00000000

  text-color=${colors.base00}
  text-clear-color=${colors.base03}
  text-ver-color=${colors.base00}
  text-wrong-color=${colors.base00}
  text-caps-lock-color=00000000
''
