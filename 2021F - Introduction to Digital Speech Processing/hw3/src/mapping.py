import sys
# usage: mapping.py <input: big5-ZhuYin.map> <output: ZhuYin-big5.map>

ZhuYin_big5 = {}
input_file = open(sys.argv[1], "r", encoding="cp950", errors="ignore")

for line in input_file:
    big5 = line.split(' ')[0]
    ZhuYin = line.split(' ')[1].split('/')
    ZhuYin_big5[big5] = [big5]
    all_ZhuYin_head = list(set([z[0] for z in ZhuYin]))
    all_ZhuYin_head = sorted(all_ZhuYin_head)

    for z in all_ZhuYin_head:
        if z not in ZhuYin_big5:
            ZhuYin_big5[z] = [big5]
        else:
            ZhuYin_big5[z].append(big5)

output_file = open(sys.argv[2], "w", encoding="cp950")

for ZhuYin_head, big5_list in sorted(ZhuYin_big5.items()):
    output_file.write(ZhuYin_head)
    output_file.write("\t")
    # for big5 in big5_list:
    #     output_file.write(big5 + " ")
    output_file.write(' '.join(big5_list))
    output_file.write("\n")

