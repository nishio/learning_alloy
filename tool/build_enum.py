# -*- encoding: utf-8 -*-
"""
script to generate enum-like signiture
given base signiture (Man) and names (Taro Jiro Saburo) print bellow

sig Taro extends Man {}
sig Jiro extends Man {}
sig Saburo extends Man {}

fact {
  lone Taro
  lone Jiro
  lone Saburo
}
"""

# preset
PRESET = {
    # from 1950's ranking: http://www.meijiyasuda.co.jp/profile/etc/ranking/
    "japanese_male_name_unicode": u"博 茂 隆 実 清 進 明 修 豊 誠",
    "japanese_male_name": u"Hiroshi Shigeru Takashi Minoru Kiyoshi Susumu Akira Osamu Yutaka Makoto",
    "japanese_female_name_unicode": u"幸子 和子 洋子 節子 恵子 悦子 京子 恵美子 啓子 久美子",
    "japanese_female_name": u"Sachiko Kazuko Youko Setsuko Keiko Etsuko Kyouko Emiko Kumiko Junko", # Keiko is duplicated
}

base = raw_input("base=? ")
names = raw_input("names(space-separated)=? ")
if names in PRESET: names = PRESET[names]
names = names.split()

print "\n".join(
    "sig %s extends %s {}" % (name, base)
    for name in names)

print
print "fact {"
print "\n".join(
    "  lone %s" % name
    for name in names)
print "}"




