module rg_buffer #(
  parameter D_WL = 24,
  parameter UNITS_NUM = 5
)(
   input [7:0] addr,
   output [UNITS_NUM*D_WL-1:0] w_o
);

wire [D_WL*UNITS_NUM-1:0] w_fix [0:179];
assign w_o = w_fix[addr];
assign w_fix[0]='h0004c6fffe35fff6f0fff4af0008e3;
assign w_fix[1]='h0007c1ffe43bffffd000223dffea55;
assign w_fix[2]='hfff97dffe8d40017720002edffe99f;
assign w_fix[3]='h000dc2fff309fff6c7fffd47ffea8d;
assign w_fix[4]='hfff948ffe61fffffa4ffff58fffaf8;
assign w_fix[5]='hfff559fff09afffc8cffffa9ffefda;
assign w_fix[6]='hfffdd4ffebf0fff7b2fffcdefffcd5;
assign w_fix[7]='h00027f0005a8fff202ffff7cfff83a;
assign w_fix[8]='h0002ab00096b00050fffebbfffdb8e;
assign w_fix[9]='h000235ffef3000061a0009cf000521;
assign w_fix[10]='hfffdd9fff1ab000a3c000b2700068b;
assign w_fix[11]='hfff943fff3b8ffe903ffeb95fff196;
assign w_fix[12]='h00003bffef81000f7b000872000629;
assign w_fix[13]='hfff7480006a0fff7bbffed3dfff2e7;
assign w_fix[14]='hfffcfd00053e00088b000347000a87;
assign w_fix[15]='h0003e50007470016700009f5000c17;
assign w_fix[16]='h00054f0000bc0004540009ae000c55;
assign w_fix[17]='h000926000731000ffe000f48fff67e;
assign w_fix[18]='h0000340003b500032f00011d0000f9;
assign w_fix[19]='hfffafe00110a00066100017f000a2a;
assign w_fix[20]='h0005cbfff3e7fffa3000166f00132c;
assign w_fix[21]='hfff455ffeb75ffff5c000bae0000c5;
assign w_fix[22]='hfff4bdfff590fff0ecfff3ca000d51;
assign w_fix[23]='h000ddcffedb900024b0020a3000459;
assign w_fix[24]='hfffe10ffef2ffffc42fff6b5fffbbf;
assign w_fix[25]='hfffa87001dd40000bcffefa9001c92;
assign w_fix[26]='h00047f001117000c5b000805002ac2;
assign w_fix[27]='hfffcb20008ccfffc3ffffe91fffc33;
assign w_fix[28]='h0006c1ffed850004f5001b7b0003e6;
assign w_fix[29]='h0002f800081efffa5effffd100039a;
assign w_fix[30]='hfff67f00017e000b1b0005a6000d24;
assign w_fix[31]='h000168fffdacffff960006d9000d79;
assign w_fix[32]='h0004b5fffc44ffff76ffebf9fff7d6;
assign w_fix[33]='h001961002a3ffffbf7001794fff49f;
assign w_fix[34]='h0003bbfff793fffc03000324000aa1;
assign w_fix[35]='hfff8320011af0004dbfffa5e000ce5;
assign w_fix[36]='hfffad4000212000872000a010010a5;
assign w_fix[37]='h0001b2fff87afff96afffef3fffb5a;
assign w_fix[38]='hfff72b001c8afffce1000f5dffff54;
assign w_fix[39]='h000542fff742fffe3c000ab8000222;
assign w_fix[40]='hffff1afff61e00020efffd3a00069e;
assign w_fix[41]='hffdd710021c40011c2fff600ffe894;
assign w_fix[42]='h00068efff7c600021ffffb640005bb;
assign w_fix[43]='hfffa6dfffff70001fbfff8920005e7;
assign w_fix[44]='hfff94e000f9c0005c60002420002be;
assign w_fix[45]='h000fabffe1c9ffecbffffd4afff12d;
assign w_fix[46]='h00074dffe85e000992fffe1c000907;
assign w_fix[47]='hffff3cfffd50fffefd0001e800109c;
assign w_fix[48]='h0009ecfffde2fffe8dfff57ffffb8d;
assign w_fix[49]='hfff8a3fff8640001ad00061f000737;
assign w_fix[50]='h0000d8ffff44000131fffe8c0004ab;
assign w_fix[51]='h00041e0006d700020bfff31d00030f;
assign w_fix[52]='hffed13001d94000e7d0015e6fffd73;
assign w_fix[53]='h000dafffe4d30008960007950008be;
assign w_fix[54]='hfffb4ffffb160001a3fffc93fff95e;
assign w_fix[55]='hffff78fff90a0003fbfff932fff566;
assign w_fix[56]='h00028cfffa490004c1fff946000055;
assign w_fix[57]='h0008ff00007900017ffffd00fffbd8;
assign w_fix[58]='h000a2dfff6a60005a1000b30000357;
assign w_fix[59]='h000266ffff36fffb30000413fff8ab;
assign w_fix[60]='hfffbf4000171fffda000195f0004ad;
assign w_fix[61]='h00020a000abffff7a90004ba000033;
assign w_fix[62]='h00093d000122fffd11ffed9d000309;
assign w_fix[63]='hfffd530001ed000b2effef2d000448;
assign w_fix[64]='h0003dc0012df0000fb0009cf0002c8;
assign w_fix[65]='h00012b000545fff73efff5a8fff916;
assign w_fix[66]='hfffd66fffb00fff9fffff938ffffb4;
assign w_fix[67]='h00046a000495fffc960000de000181;
assign w_fix[68]='h0000bc000724fffd40ffe40800013c;
assign w_fix[69]='hffff16fffbe200007e000ba8000463;
assign w_fix[70]='hfffe5f0005c0fffdd5000d84ffff26;
assign w_fix[71]='hfff3c30011cfffe110ffedd3ffee02;
assign w_fix[72]='hffffbd00006bfff93d00066800001a;
assign w_fix[73]='hfffd8bfff8fafff47a000b17fff3a5;
assign w_fix[74]='hfff4aafff8eefffe6600015cfffb99;
assign w_fix[75]='h0012bffffd28000ffe0003fd000947;
assign w_fix[76]='hfffbb90002f10004ce0019c5ffff24;
assign w_fix[77]='hfffbe2fffc96ffff27fffa87000360;
assign w_fix[78]='hfff97b0002ea0000cb00022c000333;
assign w_fix[79]='hffface00033bfffcf10015a1fffe1e;
assign w_fix[80]='hfff92efff93c000ff5fffb0f001005;
assign w_fix[81]='hffffc7fffcc8fff362fff7b9fff9ae;
assign w_fix[82]='h000050fff940ffe3b9000571ffed1a;
assign w_fix[83]='hfffaa2fffe18000225000e7d000c60;
assign w_fix[84]='h0002300001dcffff3cffe788fffe47;
assign w_fix[85]='hfffb67ffdea300056efff9cb000075;
assign w_fix[86]='hfffdc0fffa4a00010800187cfffd3b;
assign w_fix[87]='h0000af000122fffc5dfffc25fffacf;
assign w_fix[88]='hfffcddfffaf00008aa0000f7000683;
assign w_fix[89]='h00044e00014e0001cbffff420003d0;
assign w_fix[90]='hfff5affff2c900068a000980fff22d;
assign w_fix[91]='h000152fffb6dffff09ffff6affecd1;
assign w_fix[92]='h0002fa000fb8002821ffee6800096d;
assign w_fix[93]='h000f2d000a4cfffb6efff5a5fffd0f;
assign w_fix[94]='h000455000564fff95d000dd1fff699;
assign w_fix[95]='hfff672ffff94fffc47fff612fff7e5;
assign w_fix[96]='hfff8e7fff916fffaacfff98b00019d;
assign w_fix[97]='hfffc5efffb12fffcd5fff979000153;
assign w_fix[98]='h000d7bfff15b001034fff918000cda;
assign w_fix[99]='h00026e00078b0004ef0004dafffab3;
assign w_fix[100]='h0000e700058e00011400058dfffac1;
assign w_fix[101]='h0004c0fffc85ffe9f3ffd7ecffffd3;
assign w_fix[102]='h000530000780000787000621fffa5c;
assign w_fix[103]='hfff9a700093cffeb67fff735ffff47;
assign w_fix[104]='hfffbaa0000a3000396fffe79fffe7a;
assign w_fix[105]='h00053e00083f000861000e75000504;
assign w_fix[106]='h00057c000baaffecb0fffdf1fff3f2;
assign w_fix[107]='h000442fffe2c0014d5000862ffff87;
assign w_fix[108]='h0002e9000c9300027c00001f000a24;
assign w_fix[109]='hfff09f00014d0001ba000358000049;
assign w_fix[110]='hfff7bbfff8090000a00003f8ffea53;
assign w_fix[111]='hfff754000a570001caffe649fffe54;
assign w_fix[112]='hffeb5ffff571fff3fdffd4b8fffb2a;
assign w_fix[113]='h0005ae0004d6fffb8900192ffff753;
assign w_fix[114]='hfffb39ffff46fffa22fff34effff38;
assign w_fix[115]='hfffebd0002660004c8000236001314;
assign w_fix[116]='hfffc4c000c66fff3cafffbc9fffc13;
assign w_fix[117]='h0006d5001076000471ffef9e000bd5;
assign w_fix[118]='h00004b00051afffd110008edfffa3f;
assign w_fix[119]='hffffeefff8f500042c0006800001c0;
assign w_fix[120]='h000eb7ffe87bfff5d800054cfffac0;
assign w_fix[121]='hfff5f80008fafff33ffff804ffff51;
assign w_fix[122]='hfffb65fff985ffef0b0014ffffeb64;
assign w_fix[123]='h000188000a64fff508fff7cbffdb1a;
assign w_fix[124]='h00010dfff514000ed8000789fff4be;
assign w_fix[125]='h000745fff3370005f0fffd1efffa28;
assign w_fix[126]='hfffeeb0000bf000ac50000530010be;
assign w_fix[127]='h00064ffffcd4fffee50000abfffa82;
assign w_fix[128]='h0001b1000f15000ce8fff103fffdd6;
assign w_fix[129]='hfffa40000a440007a4000b0efff7d6;
assign w_fix[130]='h000231fffec700035300084efff595;
assign w_fix[131]='h001426ffcd110002b0fff5adffee74;
assign w_fix[132]='hfffe54fff70600107e000483ffff24;
assign w_fix[133]='h00077affeb58001092fffd92fff0f1;
assign w_fix[134]='h00082f0008adfff21ffffe110000df;
assign w_fix[135]='hfff648000a0dffeff4001723000246;
assign w_fix[136]='h000107fff0c200087d0001c8fffb01;
assign w_fix[137]='hfff43500058dfff042000d9a00020a;
assign w_fix[138]='hfffb3ffff31dfff85a000cdafff5b3;
assign w_fix[139]='h0002b0fff7a5fffe63000397fffc8f;
assign w_fix[140]='hfff915000f85ffec2fffffbe0002a7;
assign w_fix[141]='h0008b8fff385fff7350002810002b8;
assign w_fix[142]='h001998fff0160006bcfffa04001801;
assign w_fix[143]='hfff3a30006e400076b00048a000481;
assign w_fix[144]='hfff83efffdcb0007e0fffe2d000593;
assign w_fix[145]='h00019b0000210002f100045900084c;
assign w_fix[146]='hfff653fffddd00085500016c000523;
assign w_fix[147]='hfff9d000090dfffa8ffffd40fffedc;
assign w_fix[148]='hfffedf000e0e000b47000671000251;
assign w_fix[149]='hffff420005d1ffff55000a1f000041;
assign w_fix[150]='hfffb63ffea64ffec32ffe5c3fffec7;
assign w_fix[151]='h0002d600033bffff3ffff60ffff156;
assign w_fix[152]='h0003dcffffb8000b30ffeb7c0003c9;
assign w_fix[153]='hffff9e000d13fff87cffdc82ffeddf;
assign w_fix[154]='hfffe520001040005b6fffa57fff6e2;
assign w_fix[155]='h000618fff9910004d6ffe9e200039a;
assign w_fix[156]='h0003db00054efff8f4fffd4e0005e0;
assign w_fix[157]='hfffc7f0007f80005030006cb0000c3;
assign w_fix[158]='h000113000017fffb58fffc57000d8d;
assign w_fix[159]='hffffd1000430fff8d5fffc1bfff8ea;
assign w_fix[160]='hfffe4cfffe830002f0fff6b3fff936;
assign w_fix[161]='h0001efffc84ffff9abffe5c5fffe5f;
assign w_fix[162]='hfffdbbfffac2ffffacfff8fffff79b;
assign w_fix[163]='hfffd3cffeed60018ad000a8f000e9c;
assign w_fix[164]='h0003b6ffff9afffd87fffa39000271;
assign w_fix[165]='hfff9870009dffffe6e001c4ffff876;
assign w_fix[166]='hfff9f1ffff1e000ae70005cdffeec6;
assign w_fix[167]='hfff370fffde5fffce3ffec49fff71b;
assign w_fix[168]='hfffd9c0006aa000729fffee900007b;
assign w_fix[169]='h0003fffffbdc00062f0005590000e6;
assign w_fix[170]='hfff76b000d0600039600038efff340;
assign w_fix[171]='h000383fffbce000412fff5f6fff32e;
assign w_fix[172]='h000506ffed21ffefc2fff51c000a54;
assign w_fix[173]='hfffb35000312fff906fffc85fff2f1;
assign w_fix[174]='hfffe7cfff7da000de30006070004fe;
assign w_fix[175]='hfffd0200050cffff0a0008970009a5;
assign w_fix[176]='h00076dfffb630000d7fffab0fff0be;
assign w_fix[177]='h000324000f650000d90008ec0005d9;
assign w_fix[178]='hfffce300040efffac4fff919fff224;
assign w_fix[179]='hfff5a8000304fff6a000037e00028d;

endmodule