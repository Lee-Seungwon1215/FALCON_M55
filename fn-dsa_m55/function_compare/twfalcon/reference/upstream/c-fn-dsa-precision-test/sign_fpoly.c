/*
 * Floating-point polynomials.
 */

#include "sign_inner.h"
#include <stdlib.h>

#if TEST_PRECISION

static fpr GM[2048];
static int gm_set = 0;

static inline void initialize_GM(){
    if(gm_set == 0){
        gm_set = 1;
        printf("initialize gm\n");
        GM[0] = FPR_ZERO;
        GM[1] = FPR_ZERO;
        GM[2] = FPR_NZERO;
        GM[3] = FPR_ONE;
        GM[4] = FPR_GM(4);
        GM[5] = FPR_GM(5);
        GM[6] = FPR_GM(6);
        GM[7] = FPR_GM(7);
        GM[8] = FPR_GM(8);
        GM[9] = FPR_GM(9);
        GM[10] = FPR_GM(10);
        GM[11] = FPR_GM(11);
        GM[12] = FPR_GM(12);
        GM[13] = FPR_GM(13);
        GM[14] = FPR_GM(14);
        GM[15] = FPR_GM(15);
        GM[16] = FPR_GM(16);
        GM[17] = FPR_GM(17);
        GM[18] = FPR_GM(18);
        GM[19] = FPR_GM(19);
        GM[20] = FPR_GM(20);
        GM[21] = FPR_GM(21);
        GM[22] = FPR_GM(22);
        GM[23] = FPR_GM(23);
        GM[24] = FPR_GM(24);
        GM[25] = FPR_GM(25);
        GM[26] = FPR_GM(26);
        GM[27] = FPR_GM(27);
        GM[28] = FPR_GM(28);
        GM[29] = FPR_GM(29);
        GM[30] = FPR_GM(30);
        GM[31] = FPR_GM(31);
        GM[32] = FPR_GM(32);
        GM[33] = FPR_GM(33);
        GM[34] = FPR_GM(34);
        GM[35] = FPR_GM(35);
        GM[36] = FPR_GM(36);
        GM[37] = FPR_GM(37);
        GM[38] = FPR_GM(38);
        GM[39] = FPR_GM(39);
        GM[40] = FPR_GM(40);
        GM[41] = FPR_GM(41);
        GM[42] = FPR_GM(42);
        GM[43] = FPR_GM(43);
        GM[44] = FPR_GM(44);
        GM[45] = FPR_GM(45);
        GM[46] = FPR_GM(46);
        GM[47] = FPR_GM(47);
        GM[48] = FPR_GM(48);
        GM[49] = FPR_GM(49);
        GM[50] = FPR_GM(50);
        GM[51] = FPR_GM(51);
        GM[52] = FPR_GM(52);
        GM[53] = FPR_GM(53);
        GM[54] = FPR_GM(54);
        GM[55] = FPR_GM(55);
        GM[56] = FPR_GM(56);
        GM[57] = FPR_GM(57);
        GM[58] = FPR_GM(58);
        GM[59] = FPR_GM(59);
        GM[60] = FPR_GM(60);
        GM[61] = FPR_GM(61);
        GM[62] = FPR_GM(62);
        GM[63] = FPR_GM(63);
        GM[64] = FPR_GM(64);
        GM[65] = FPR_GM(65);
        GM[66] = FPR_GM(66);
        GM[67] = FPR_GM(67);
        GM[68] = FPR_GM(68);
        GM[69] = FPR_GM(69);
        GM[70] = FPR_GM(70);
        GM[71] = FPR_GM(71);
        GM[72] = FPR_GM(72);
        GM[73] = FPR_GM(73);
        GM[74] = FPR_GM(74);
        GM[75] = FPR_GM(75);
        GM[76] = FPR_GM(76);
        GM[77] = FPR_GM(77);
        GM[78] = FPR_GM(78);
        GM[79] = FPR_GM(79);
        GM[80] = FPR_GM(80);
        GM[81] = FPR_GM(81);
        GM[82] = FPR_GM(82);
        GM[83] = FPR_GM(83);
        GM[84] = FPR_GM(84);
        GM[85] = FPR_GM(85);
        GM[86] = FPR_GM(86);
        GM[87] = FPR_GM(87);
        GM[88] = FPR_GM(88);
        GM[89] = FPR_GM(89);
        GM[90] = FPR_GM(90);
        GM[91] = FPR_GM(91);
        GM[92] = FPR_GM(92);
        GM[93] = FPR_GM(93);
        GM[94] = FPR_GM(94);
        GM[95] = FPR_GM(95);
        GM[96] = FPR_GM(96);
        GM[97] = FPR_GM(97);
        GM[98] = FPR_GM(98);
        GM[99] = FPR_GM(99);
        GM[100] = FPR_GM(100);
        GM[101] = FPR_GM(101);
        GM[102] = FPR_GM(102);
        GM[103] = FPR_GM(103);
        GM[104] = FPR_GM(104);
        GM[105] = FPR_GM(105);
        GM[106] = FPR_GM(106);
        GM[107] = FPR_GM(107);
        GM[108] = FPR_GM(108);
        GM[109] = FPR_GM(109);
        GM[110] = FPR_GM(110);
        GM[111] = FPR_GM(111);
        GM[112] = FPR_GM(112);
        GM[113] = FPR_GM(113);
        GM[114] = FPR_GM(114);
        GM[115] = FPR_GM(115);
        GM[116] = FPR_GM(116);
        GM[117] = FPR_GM(117);
        GM[118] = FPR_GM(118);
        GM[119] = FPR_GM(119);
        GM[120] = FPR_GM(120);
        GM[121] = FPR_GM(121);
        GM[122] = FPR_GM(122);
        GM[123] = FPR_GM(123);
        GM[124] = FPR_GM(124);
        GM[125] = FPR_GM(125);
        GM[126] = FPR_GM(126);
        GM[127] = FPR_GM(127);
        GM[128] = FPR_GM(128);
        GM[129] = FPR_GM(129);
        GM[130] = FPR_GM(130);
        GM[131] = FPR_GM(131);
        GM[132] = FPR_GM(132);
        GM[133] = FPR_GM(133);
        GM[134] = FPR_GM(134);
        GM[135] = FPR_GM(135);
        GM[136] = FPR_GM(136);
        GM[137] = FPR_GM(137);
        GM[138] = FPR_GM(138);
        GM[139] = FPR_GM(139);
        GM[140] = FPR_GM(140);
        GM[141] = FPR_GM(141);
        GM[142] = FPR_GM(142);
        GM[143] = FPR_GM(143);
        GM[144] = FPR_GM(144);
        GM[145] = FPR_GM(145);
        GM[146] = FPR_GM(146);
        GM[147] = FPR_GM(147);
        GM[148] = FPR_GM(148);
        GM[149] = FPR_GM(149);
        GM[150] = FPR_GM(150);
        GM[151] = FPR_GM(151);
        GM[152] = FPR_GM(152);
        GM[153] = FPR_GM(153);
        GM[154] = FPR_GM(154);
        GM[155] = FPR_GM(155);
        GM[156] = FPR_GM(156);
        GM[157] = FPR_GM(157);
        GM[158] = FPR_GM(158);
        GM[159] = FPR_GM(159);
        GM[160] = FPR_GM(160);
        GM[161] = FPR_GM(161);
        GM[162] = FPR_GM(162);
        GM[163] = FPR_GM(163);
        GM[164] = FPR_GM(164);
        GM[165] = FPR_GM(165);
        GM[166] = FPR_GM(166);
        GM[167] = FPR_GM(167);
        GM[168] = FPR_GM(168);
        GM[169] = FPR_GM(169);
        GM[170] = FPR_GM(170);
        GM[171] = FPR_GM(171);
        GM[172] = FPR_GM(172);
        GM[173] = FPR_GM(173);
        GM[174] = FPR_GM(174);
        GM[175] = FPR_GM(175);
        GM[176] = FPR_GM(176);
        GM[177] = FPR_GM(177);
        GM[178] = FPR_GM(178);
        GM[179] = FPR_GM(179);
        GM[180] = FPR_GM(180);
        GM[181] = FPR_GM(181);
        GM[182] = FPR_GM(182);
        GM[183] = FPR_GM(183);
        GM[184] = FPR_GM(184);
        GM[185] = FPR_GM(185);
        GM[186] = FPR_GM(186);
        GM[187] = FPR_GM(187);
        GM[188] = FPR_GM(188);
        GM[189] = FPR_GM(189);
        GM[190] = FPR_GM(190);
        GM[191] = FPR_GM(191);
        GM[192] = FPR_GM(192);
        GM[193] = FPR_GM(193);
        GM[194] = FPR_GM(194);
        GM[195] = FPR_GM(195);
        GM[196] = FPR_GM(196);
        GM[197] = FPR_GM(197);
        GM[198] = FPR_GM(198);
        GM[199] = FPR_GM(199);
        GM[200] = FPR_GM(200);
        GM[201] = FPR_GM(201);
        GM[202] = FPR_GM(202);
        GM[203] = FPR_GM(203);
        GM[204] = FPR_GM(204);
        GM[205] = FPR_GM(205);
        GM[206] = FPR_GM(206);
        GM[207] = FPR_GM(207);
        GM[208] = FPR_GM(208);
        GM[209] = FPR_GM(209);
        GM[210] = FPR_GM(210);
        GM[211] = FPR_GM(211);
        GM[212] = FPR_GM(212);
        GM[213] = FPR_GM(213);
        GM[214] = FPR_GM(214);
        GM[215] = FPR_GM(215);
        GM[216] = FPR_GM(216);
        GM[217] = FPR_GM(217);
        GM[218] = FPR_GM(218);
        GM[219] = FPR_GM(219);
        GM[220] = FPR_GM(220);
        GM[221] = FPR_GM(221);
        GM[222] = FPR_GM(222);
        GM[223] = FPR_GM(223);
        GM[224] = FPR_GM(224);
        GM[225] = FPR_GM(225);
        GM[226] = FPR_GM(226);
        GM[227] = FPR_GM(227);
        GM[228] = FPR_GM(228);
        GM[229] = FPR_GM(229);
        GM[230] = FPR_GM(230);
        GM[231] = FPR_GM(231);
        GM[232] = FPR_GM(232);
        GM[233] = FPR_GM(233);
        GM[234] = FPR_GM(234);
        GM[235] = FPR_GM(235);
        GM[236] = FPR_GM(236);
        GM[237] = FPR_GM(237);
        GM[238] = FPR_GM(238);
        GM[239] = FPR_GM(239);
        GM[240] = FPR_GM(240);
        GM[241] = FPR_GM(241);
        GM[242] = FPR_GM(242);
        GM[243] = FPR_GM(243);
        GM[244] = FPR_GM(244);
        GM[245] = FPR_GM(245);
        GM[246] = FPR_GM(246);
        GM[247] = FPR_GM(247);
        GM[248] = FPR_GM(248);
        GM[249] = FPR_GM(249);
        GM[250] = FPR_GM(250);
        GM[251] = FPR_GM(251);
        GM[252] = FPR_GM(252);
        GM[253] = FPR_GM(253);
        GM[254] = FPR_GM(254);
        GM[255] = FPR_GM(255);
        GM[256] = FPR_GM(256);
        GM[257] = FPR_GM(257);
        GM[258] = FPR_GM(258);
        GM[259] = FPR_GM(259);
        GM[260] = FPR_GM(260);
        GM[261] = FPR_GM(261);
        GM[262] = FPR_GM(262);
        GM[263] = FPR_GM(263);
        GM[264] = FPR_GM(264);
        GM[265] = FPR_GM(265);
        GM[266] = FPR_GM(266);
        GM[267] = FPR_GM(267);
        GM[268] = FPR_GM(268);
        GM[269] = FPR_GM(269);
        GM[270] = FPR_GM(270);
        GM[271] = FPR_GM(271);
        GM[272] = FPR_GM(272);
        GM[273] = FPR_GM(273);
        GM[274] = FPR_GM(274);
        GM[275] = FPR_GM(275);
        GM[276] = FPR_GM(276);
        GM[277] = FPR_GM(277);
        GM[278] = FPR_GM(278);
        GM[279] = FPR_GM(279);
        GM[280] = FPR_GM(280);
        GM[281] = FPR_GM(281);
        GM[282] = FPR_GM(282);
        GM[283] = FPR_GM(283);
        GM[284] = FPR_GM(284);
        GM[285] = FPR_GM(285);
        GM[286] = FPR_GM(286);
        GM[287] = FPR_GM(287);
        GM[288] = FPR_GM(288);
        GM[289] = FPR_GM(289);
        GM[290] = FPR_GM(290);
        GM[291] = FPR_GM(291);
        GM[292] = FPR_GM(292);
        GM[293] = FPR_GM(293);
        GM[294] = FPR_GM(294);
        GM[295] = FPR_GM(295);
        GM[296] = FPR_GM(296);
        GM[297] = FPR_GM(297);
        GM[298] = FPR_GM(298);
        GM[299] = FPR_GM(299);
        GM[300] = FPR_GM(300);
        GM[301] = FPR_GM(301);
        GM[302] = FPR_GM(302);
        GM[303] = FPR_GM(303);
        GM[304] = FPR_GM(304);
        GM[305] = FPR_GM(305);
        GM[306] = FPR_GM(306);
        GM[307] = FPR_GM(307);
        GM[308] = FPR_GM(308);
        GM[309] = FPR_GM(309);
        GM[310] = FPR_GM(310);
        GM[311] = FPR_GM(311);
        GM[312] = FPR_GM(312);
        GM[313] = FPR_GM(313);
        GM[314] = FPR_GM(314);
        GM[315] = FPR_GM(315);
        GM[316] = FPR_GM(316);
        GM[317] = FPR_GM(317);
        GM[318] = FPR_GM(318);
        GM[319] = FPR_GM(319);
        GM[320] = FPR_GM(320);
        GM[321] = FPR_GM(321);
        GM[322] = FPR_GM(322);
        GM[323] = FPR_GM(323);
        GM[324] = FPR_GM(324);
        GM[325] = FPR_GM(325);
        GM[326] = FPR_GM(326);
        GM[327] = FPR_GM(327);
        GM[328] = FPR_GM(328);
        GM[329] = FPR_GM(329);
        GM[330] = FPR_GM(330);
        GM[331] = FPR_GM(331);
        GM[332] = FPR_GM(332);
        GM[333] = FPR_GM(333);
        GM[334] = FPR_GM(334);
        GM[335] = FPR_GM(335);
        GM[336] = FPR_GM(336);
        GM[337] = FPR_GM(337);
        GM[338] = FPR_GM(338);
        GM[339] = FPR_GM(339);
        GM[340] = FPR_GM(340);
        GM[341] = FPR_GM(341);
        GM[342] = FPR_GM(342);
        GM[343] = FPR_GM(343);
        GM[344] = FPR_GM(344);
        GM[345] = FPR_GM(345);
        GM[346] = FPR_GM(346);
        GM[347] = FPR_GM(347);
        GM[348] = FPR_GM(348);
        GM[349] = FPR_GM(349);
        GM[350] = FPR_GM(350);
        GM[351] = FPR_GM(351);
        GM[352] = FPR_GM(352);
        GM[353] = FPR_GM(353);
        GM[354] = FPR_GM(354);
        GM[355] = FPR_GM(355);
        GM[356] = FPR_GM(356);
        GM[357] = FPR_GM(357);
        GM[358] = FPR_GM(358);
        GM[359] = FPR_GM(359);
        GM[360] = FPR_GM(360);
        GM[361] = FPR_GM(361);
        GM[362] = FPR_GM(362);
        GM[363] = FPR_GM(363);
        GM[364] = FPR_GM(364);
        GM[365] = FPR_GM(365);
        GM[366] = FPR_GM(366);
        GM[367] = FPR_GM(367);
        GM[368] = FPR_GM(368);
        GM[369] = FPR_GM(369);
        GM[370] = FPR_GM(370);
        GM[371] = FPR_GM(371);
        GM[372] = FPR_GM(372);
        GM[373] = FPR_GM(373);
        GM[374] = FPR_GM(374);
        GM[375] = FPR_GM(375);
        GM[376] = FPR_GM(376);
        GM[377] = FPR_GM(377);
        GM[378] = FPR_GM(378);
        GM[379] = FPR_GM(379);
        GM[380] = FPR_GM(380);
        GM[381] = FPR_GM(381);
        GM[382] = FPR_GM(382);
        GM[383] = FPR_GM(383);
        GM[384] = FPR_GM(384);
        GM[385] = FPR_GM(385);
        GM[386] = FPR_GM(386);
        GM[387] = FPR_GM(387);
        GM[388] = FPR_GM(388);
        GM[389] = FPR_GM(389);
        GM[390] = FPR_GM(390);
        GM[391] = FPR_GM(391);
        GM[392] = FPR_GM(392);
        GM[393] = FPR_GM(393);
        GM[394] = FPR_GM(394);
        GM[395] = FPR_GM(395);
        GM[396] = FPR_GM(396);
        GM[397] = FPR_GM(397);
        GM[398] = FPR_GM(398);
        GM[399] = FPR_GM(399);
        GM[400] = FPR_GM(400);
        GM[401] = FPR_GM(401);
        GM[402] = FPR_GM(402);
        GM[403] = FPR_GM(403);
        GM[404] = FPR_GM(404);
        GM[405] = FPR_GM(405);
        GM[406] = FPR_GM(406);
        GM[407] = FPR_GM(407);
        GM[408] = FPR_GM(408);
        GM[409] = FPR_GM(409);
        GM[410] = FPR_GM(410);
        GM[411] = FPR_GM(411);
        GM[412] = FPR_GM(412);
        GM[413] = FPR_GM(413);
        GM[414] = FPR_GM(414);
        GM[415] = FPR_GM(415);
        GM[416] = FPR_GM(416);
        GM[417] = FPR_GM(417);
        GM[418] = FPR_GM(418);
        GM[419] = FPR_GM(419);
        GM[420] = FPR_GM(420);
        GM[421] = FPR_GM(421);
        GM[422] = FPR_GM(422);
        GM[423] = FPR_GM(423);
        GM[424] = FPR_GM(424);
        GM[425] = FPR_GM(425);
        GM[426] = FPR_GM(426);
        GM[427] = FPR_GM(427);
        GM[428] = FPR_GM(428);
        GM[429] = FPR_GM(429);
        GM[430] = FPR_GM(430);
        GM[431] = FPR_GM(431);
        GM[432] = FPR_GM(432);
        GM[433] = FPR_GM(433);
        GM[434] = FPR_GM(434);
        GM[435] = FPR_GM(435);
        GM[436] = FPR_GM(436);
        GM[437] = FPR_GM(437);
        GM[438] = FPR_GM(438);
        GM[439] = FPR_GM(439);
        GM[440] = FPR_GM(440);
        GM[441] = FPR_GM(441);
        GM[442] = FPR_GM(442);
        GM[443] = FPR_GM(443);
        GM[444] = FPR_GM(444);
        GM[445] = FPR_GM(445);
        GM[446] = FPR_GM(446);
        GM[447] = FPR_GM(447);
        GM[448] = FPR_GM(448);
        GM[449] = FPR_GM(449);
        GM[450] = FPR_GM(450);
        GM[451] = FPR_GM(451);
        GM[452] = FPR_GM(452);
        GM[453] = FPR_GM(453);
        GM[454] = FPR_GM(454);
        GM[455] = FPR_GM(455);
        GM[456] = FPR_GM(456);
        GM[457] = FPR_GM(457);
        GM[458] = FPR_GM(458);
        GM[459] = FPR_GM(459);
        GM[460] = FPR_GM(460);
        GM[461] = FPR_GM(461);
        GM[462] = FPR_GM(462);
        GM[463] = FPR_GM(463);
        GM[464] = FPR_GM(464);
        GM[465] = FPR_GM(465);
        GM[466] = FPR_GM(466);
        GM[467] = FPR_GM(467);
        GM[468] = FPR_GM(468);
        GM[469] = FPR_GM(469);
        GM[470] = FPR_GM(470);
        GM[471] = FPR_GM(471);
        GM[472] = FPR_GM(472);
        GM[473] = FPR_GM(473);
        GM[474] = FPR_GM(474);
        GM[475] = FPR_GM(475);
        GM[476] = FPR_GM(476);
        GM[477] = FPR_GM(477);
        GM[478] = FPR_GM(478);
        GM[479] = FPR_GM(479);
        GM[480] = FPR_GM(480);
        GM[481] = FPR_GM(481);
        GM[482] = FPR_GM(482);
        GM[483] = FPR_GM(483);
        GM[484] = FPR_GM(484);
        GM[485] = FPR_GM(485);
        GM[486] = FPR_GM(486);
        GM[487] = FPR_GM(487);
        GM[488] = FPR_GM(488);
        GM[489] = FPR_GM(489);
        GM[490] = FPR_GM(490);
        GM[491] = FPR_GM(491);
        GM[492] = FPR_GM(492);
        GM[493] = FPR_GM(493);
        GM[494] = FPR_GM(494);
        GM[495] = FPR_GM(495);
        GM[496] = FPR_GM(496);
        GM[497] = FPR_GM(497);
        GM[498] = FPR_GM(498);
        GM[499] = FPR_GM(499);
        GM[500] = FPR_GM(500);
        GM[501] = FPR_GM(501);
        GM[502] = FPR_GM(502);
        GM[503] = FPR_GM(503);
        GM[504] = FPR_GM(504);
        GM[505] = FPR_GM(505);
        GM[506] = FPR_GM(506);
        GM[507] = FPR_GM(507);
        GM[508] = FPR_GM(508);
        GM[509] = FPR_GM(509);
        GM[510] = FPR_GM(510);
        GM[511] = FPR_GM(511);
        GM[512] = FPR_GM(512);
        GM[513] = FPR_GM(513);
        GM[514] = FPR_GM(514);
        GM[515] = FPR_GM(515);
        GM[516] = FPR_GM(516);
        GM[517] = FPR_GM(517);
        GM[518] = FPR_GM(518);
        GM[519] = FPR_GM(519);
        GM[520] = FPR_GM(520);
        GM[521] = FPR_GM(521);
        GM[522] = FPR_GM(522);
        GM[523] = FPR_GM(523);
        GM[524] = FPR_GM(524);
        GM[525] = FPR_GM(525);
        GM[526] = FPR_GM(526);
        GM[527] = FPR_GM(527);
        GM[528] = FPR_GM(528);
        GM[529] = FPR_GM(529);
        GM[530] = FPR_GM(530);
        GM[531] = FPR_GM(531);
        GM[532] = FPR_GM(532);
        GM[533] = FPR_GM(533);
        GM[534] = FPR_GM(534);
        GM[535] = FPR_GM(535);
        GM[536] = FPR_GM(536);
        GM[537] = FPR_GM(537);
        GM[538] = FPR_GM(538);
        GM[539] = FPR_GM(539);
        GM[540] = FPR_GM(540);
        GM[541] = FPR_GM(541);
        GM[542] = FPR_GM(542);
        GM[543] = FPR_GM(543);
        GM[544] = FPR_GM(544);
        GM[545] = FPR_GM(545);
        GM[546] = FPR_GM(546);
        GM[547] = FPR_GM(547);
        GM[548] = FPR_GM(548);
        GM[549] = FPR_GM(549);
        GM[550] = FPR_GM(550);
        GM[551] = FPR_GM(551);
        GM[552] = FPR_GM(552);
        GM[553] = FPR_GM(553);
        GM[554] = FPR_GM(554);
        GM[555] = FPR_GM(555);
        GM[556] = FPR_GM(556);
        GM[557] = FPR_GM(557);
        GM[558] = FPR_GM(558);
        GM[559] = FPR_GM(559);
        GM[560] = FPR_GM(560);
        GM[561] = FPR_GM(561);
        GM[562] = FPR_GM(562);
        GM[563] = FPR_GM(563);
        GM[564] = FPR_GM(564);
        GM[565] = FPR_GM(565);
        GM[566] = FPR_GM(566);
        GM[567] = FPR_GM(567);
        GM[568] = FPR_GM(568);
        GM[569] = FPR_GM(569);
        GM[570] = FPR_GM(570);
        GM[571] = FPR_GM(571);
        GM[572] = FPR_GM(572);
        GM[573] = FPR_GM(573);
        GM[574] = FPR_GM(574);
        GM[575] = FPR_GM(575);
        GM[576] = FPR_GM(576);
        GM[577] = FPR_GM(577);
        GM[578] = FPR_GM(578);
        GM[579] = FPR_GM(579);
        GM[580] = FPR_GM(580);
        GM[581] = FPR_GM(581);
        GM[582] = FPR_GM(582);
        GM[583] = FPR_GM(583);
        GM[584] = FPR_GM(584);
        GM[585] = FPR_GM(585);
        GM[586] = FPR_GM(586);
        GM[587] = FPR_GM(587);
        GM[588] = FPR_GM(588);
        GM[589] = FPR_GM(589);
        GM[590] = FPR_GM(590);
        GM[591] = FPR_GM(591);
        GM[592] = FPR_GM(592);
        GM[593] = FPR_GM(593);
        GM[594] = FPR_GM(594);
        GM[595] = FPR_GM(595);
        GM[596] = FPR_GM(596);
        GM[597] = FPR_GM(597);
        GM[598] = FPR_GM(598);
        GM[599] = FPR_GM(599);
        GM[600] = FPR_GM(600);
        GM[601] = FPR_GM(601);
        GM[602] = FPR_GM(602);
        GM[603] = FPR_GM(603);
        GM[604] = FPR_GM(604);
        GM[605] = FPR_GM(605);
        GM[606] = FPR_GM(606);
        GM[607] = FPR_GM(607);
        GM[608] = FPR_GM(608);
        GM[609] = FPR_GM(609);
        GM[610] = FPR_GM(610);
        GM[611] = FPR_GM(611);
        GM[612] = FPR_GM(612);
        GM[613] = FPR_GM(613);
        GM[614] = FPR_GM(614);
        GM[615] = FPR_GM(615);
        GM[616] = FPR_GM(616);
        GM[617] = FPR_GM(617);
        GM[618] = FPR_GM(618);
        GM[619] = FPR_GM(619);
        GM[620] = FPR_GM(620);
        GM[621] = FPR_GM(621);
        GM[622] = FPR_GM(622);
        GM[623] = FPR_GM(623);
        GM[624] = FPR_GM(624);
        GM[625] = FPR_GM(625);
        GM[626] = FPR_GM(626);
        GM[627] = FPR_GM(627);
        GM[628] = FPR_GM(628);
        GM[629] = FPR_GM(629);
        GM[630] = FPR_GM(630);
        GM[631] = FPR_GM(631);
        GM[632] = FPR_GM(632);
        GM[633] = FPR_GM(633);
        GM[634] = FPR_GM(634);
        GM[635] = FPR_GM(635);
        GM[636] = FPR_GM(636);
        GM[637] = FPR_GM(637);
        GM[638] = FPR_GM(638);
        GM[639] = FPR_GM(639);
        GM[640] = FPR_GM(640);
        GM[641] = FPR_GM(641);
        GM[642] = FPR_GM(642);
        GM[643] = FPR_GM(643);
        GM[644] = FPR_GM(644);
        GM[645] = FPR_GM(645);
        GM[646] = FPR_GM(646);
        GM[647] = FPR_GM(647);
        GM[648] = FPR_GM(648);
        GM[649] = FPR_GM(649);
        GM[650] = FPR_GM(650);
        GM[651] = FPR_GM(651);
        GM[652] = FPR_GM(652);
        GM[653] = FPR_GM(653);
        GM[654] = FPR_GM(654);
        GM[655] = FPR_GM(655);
        GM[656] = FPR_GM(656);
        GM[657] = FPR_GM(657);
        GM[658] = FPR_GM(658);
        GM[659] = FPR_GM(659);
        GM[660] = FPR_GM(660);
        GM[661] = FPR_GM(661);
        GM[662] = FPR_GM(662);
        GM[663] = FPR_GM(663);
        GM[664] = FPR_GM(664);
        GM[665] = FPR_GM(665);
        GM[666] = FPR_GM(666);
        GM[667] = FPR_GM(667);
        GM[668] = FPR_GM(668);
        GM[669] = FPR_GM(669);
        GM[670] = FPR_GM(670);
        GM[671] = FPR_GM(671);
        GM[672] = FPR_GM(672);
        GM[673] = FPR_GM(673);
        GM[674] = FPR_GM(674);
        GM[675] = FPR_GM(675);
        GM[676] = FPR_GM(676);
        GM[677] = FPR_GM(677);
        GM[678] = FPR_GM(678);
        GM[679] = FPR_GM(679);
        GM[680] = FPR_GM(680);
        GM[681] = FPR_GM(681);
        GM[682] = FPR_GM(682);
        GM[683] = FPR_GM(683);
        GM[684] = FPR_GM(684);
        GM[685] = FPR_GM(685);
        GM[686] = FPR_GM(686);
        GM[687] = FPR_GM(687);
        GM[688] = FPR_GM(688);
        GM[689] = FPR_GM(689);
        GM[690] = FPR_GM(690);
        GM[691] = FPR_GM(691);
        GM[692] = FPR_GM(692);
        GM[693] = FPR_GM(693);
        GM[694] = FPR_GM(694);
        GM[695] = FPR_GM(695);
        GM[696] = FPR_GM(696);
        GM[697] = FPR_GM(697);
        GM[698] = FPR_GM(698);
        GM[699] = FPR_GM(699);
        GM[700] = FPR_GM(700);
        GM[701] = FPR_GM(701);
        GM[702] = FPR_GM(702);
        GM[703] = FPR_GM(703);
        GM[704] = FPR_GM(704);
        GM[705] = FPR_GM(705);
        GM[706] = FPR_GM(706);
        GM[707] = FPR_GM(707);
        GM[708] = FPR_GM(708);
        GM[709] = FPR_GM(709);
        GM[710] = FPR_GM(710);
        GM[711] = FPR_GM(711);
        GM[712] = FPR_GM(712);
        GM[713] = FPR_GM(713);
        GM[714] = FPR_GM(714);
        GM[715] = FPR_GM(715);
        GM[716] = FPR_GM(716);
        GM[717] = FPR_GM(717);
        GM[718] = FPR_GM(718);
        GM[719] = FPR_GM(719);
        GM[720] = FPR_GM(720);
        GM[721] = FPR_GM(721);
        GM[722] = FPR_GM(722);
        GM[723] = FPR_GM(723);
        GM[724] = FPR_GM(724);
        GM[725] = FPR_GM(725);
        GM[726] = FPR_GM(726);
        GM[727] = FPR_GM(727);
        GM[728] = FPR_GM(728);
        GM[729] = FPR_GM(729);
        GM[730] = FPR_GM(730);
        GM[731] = FPR_GM(731);
        GM[732] = FPR_GM(732);
        GM[733] = FPR_GM(733);
        GM[734] = FPR_GM(734);
        GM[735] = FPR_GM(735);
        GM[736] = FPR_GM(736);
        GM[737] = FPR_GM(737);
        GM[738] = FPR_GM(738);
        GM[739] = FPR_GM(739);
        GM[740] = FPR_GM(740);
        GM[741] = FPR_GM(741);
        GM[742] = FPR_GM(742);
        GM[743] = FPR_GM(743);
        GM[744] = FPR_GM(744);
        GM[745] = FPR_GM(745);
        GM[746] = FPR_GM(746);
        GM[747] = FPR_GM(747);
        GM[748] = FPR_GM(748);
        GM[749] = FPR_GM(749);
        GM[750] = FPR_GM(750);
        GM[751] = FPR_GM(751);
        GM[752] = FPR_GM(752);
        GM[753] = FPR_GM(753);
        GM[754] = FPR_GM(754);
        GM[755] = FPR_GM(755);
        GM[756] = FPR_GM(756);
        GM[757] = FPR_GM(757);
        GM[758] = FPR_GM(758);
        GM[759] = FPR_GM(759);
        GM[760] = FPR_GM(760);
        GM[761] = FPR_GM(761);
        GM[762] = FPR_GM(762);
        GM[763] = FPR_GM(763);
        GM[764] = FPR_GM(764);
        GM[765] = FPR_GM(765);
        GM[766] = FPR_GM(766);
        GM[767] = FPR_GM(767);
        GM[768] = FPR_GM(768);
        GM[769] = FPR_GM(769);
        GM[770] = FPR_GM(770);
        GM[771] = FPR_GM(771);
        GM[772] = FPR_GM(772);
        GM[773] = FPR_GM(773);
        GM[774] = FPR_GM(774);
        GM[775] = FPR_GM(775);
        GM[776] = FPR_GM(776);
        GM[777] = FPR_GM(777);
        GM[778] = FPR_GM(778);
        GM[779] = FPR_GM(779);
        GM[780] = FPR_GM(780);
        GM[781] = FPR_GM(781);
        GM[782] = FPR_GM(782);
        GM[783] = FPR_GM(783);
        GM[784] = FPR_GM(784);
        GM[785] = FPR_GM(785);
        GM[786] = FPR_GM(786);
        GM[787] = FPR_GM(787);
        GM[788] = FPR_GM(788);
        GM[789] = FPR_GM(789);
        GM[790] = FPR_GM(790);
        GM[791] = FPR_GM(791);
        GM[792] = FPR_GM(792);
        GM[793] = FPR_GM(793);
        GM[794] = FPR_GM(794);
        GM[795] = FPR_GM(795);
        GM[796] = FPR_GM(796);
        GM[797] = FPR_GM(797);
        GM[798] = FPR_GM(798);
        GM[799] = FPR_GM(799);
        GM[800] = FPR_GM(800);
        GM[801] = FPR_GM(801);
        GM[802] = FPR_GM(802);
        GM[803] = FPR_GM(803);
        GM[804] = FPR_GM(804);
        GM[805] = FPR_GM(805);
        GM[806] = FPR_GM(806);
        GM[807] = FPR_GM(807);
        GM[808] = FPR_GM(808);
        GM[809] = FPR_GM(809);
        GM[810] = FPR_GM(810);
        GM[811] = FPR_GM(811);
        GM[812] = FPR_GM(812);
        GM[813] = FPR_GM(813);
        GM[814] = FPR_GM(814);
        GM[815] = FPR_GM(815);
        GM[816] = FPR_GM(816);
        GM[817] = FPR_GM(817);
        GM[818] = FPR_GM(818);
        GM[819] = FPR_GM(819);
        GM[820] = FPR_GM(820);
        GM[821] = FPR_GM(821);
        GM[822] = FPR_GM(822);
        GM[823] = FPR_GM(823);
        GM[824] = FPR_GM(824);
        GM[825] = FPR_GM(825);
        GM[826] = FPR_GM(826);
        GM[827] = FPR_GM(827);
        GM[828] = FPR_GM(828);
        GM[829] = FPR_GM(829);
        GM[830] = FPR_GM(830);
        GM[831] = FPR_GM(831);
        GM[832] = FPR_GM(832);
        GM[833] = FPR_GM(833);
        GM[834] = FPR_GM(834);
        GM[835] = FPR_GM(835);
        GM[836] = FPR_GM(836);
        GM[837] = FPR_GM(837);
        GM[838] = FPR_GM(838);
        GM[839] = FPR_GM(839);
        GM[840] = FPR_GM(840);
        GM[841] = FPR_GM(841);
        GM[842] = FPR_GM(842);
        GM[843] = FPR_GM(843);
        GM[844] = FPR_GM(844);
        GM[845] = FPR_GM(845);
        GM[846] = FPR_GM(846);
        GM[847] = FPR_GM(847);
        GM[848] = FPR_GM(848);
        GM[849] = FPR_GM(849);
        GM[850] = FPR_GM(850);
        GM[851] = FPR_GM(851);
        GM[852] = FPR_GM(852);
        GM[853] = FPR_GM(853);
        GM[854] = FPR_GM(854);
        GM[855] = FPR_GM(855);
        GM[856] = FPR_GM(856);
        GM[857] = FPR_GM(857);
        GM[858] = FPR_GM(858);
        GM[859] = FPR_GM(859);
        GM[860] = FPR_GM(860);
        GM[861] = FPR_GM(861);
        GM[862] = FPR_GM(862);
        GM[863] = FPR_GM(863);
        GM[864] = FPR_GM(864);
        GM[865] = FPR_GM(865);
        GM[866] = FPR_GM(866);
        GM[867] = FPR_GM(867);
        GM[868] = FPR_GM(868);
        GM[869] = FPR_GM(869);
        GM[870] = FPR_GM(870);
        GM[871] = FPR_GM(871);
        GM[872] = FPR_GM(872);
        GM[873] = FPR_GM(873);
        GM[874] = FPR_GM(874);
        GM[875] = FPR_GM(875);
        GM[876] = FPR_GM(876);
        GM[877] = FPR_GM(877);
        GM[878] = FPR_GM(878);
        GM[879] = FPR_GM(879);
        GM[880] = FPR_GM(880);
        GM[881] = FPR_GM(881);
        GM[882] = FPR_GM(882);
        GM[883] = FPR_GM(883);
        GM[884] = FPR_GM(884);
        GM[885] = FPR_GM(885);
        GM[886] = FPR_GM(886);
        GM[887] = FPR_GM(887);
        GM[888] = FPR_GM(888);
        GM[889] = FPR_GM(889);
        GM[890] = FPR_GM(890);
        GM[891] = FPR_GM(891);
        GM[892] = FPR_GM(892);
        GM[893] = FPR_GM(893);
        GM[894] = FPR_GM(894);
        GM[895] = FPR_GM(895);
        GM[896] = FPR_GM(896);
        GM[897] = FPR_GM(897);
        GM[898] = FPR_GM(898);
        GM[899] = FPR_GM(899);
        GM[900] = FPR_GM(900);
        GM[901] = FPR_GM(901);
        GM[902] = FPR_GM(902);
        GM[903] = FPR_GM(903);
        GM[904] = FPR_GM(904);
        GM[905] = FPR_GM(905);
        GM[906] = FPR_GM(906);
        GM[907] = FPR_GM(907);
        GM[908] = FPR_GM(908);
        GM[909] = FPR_GM(909);
        GM[910] = FPR_GM(910);
        GM[911] = FPR_GM(911);
        GM[912] = FPR_GM(912);
        GM[913] = FPR_GM(913);
        GM[914] = FPR_GM(914);
        GM[915] = FPR_GM(915);
        GM[916] = FPR_GM(916);
        GM[917] = FPR_GM(917);
        GM[918] = FPR_GM(918);
        GM[919] = FPR_GM(919);
        GM[920] = FPR_GM(920);
        GM[921] = FPR_GM(921);
        GM[922] = FPR_GM(922);
        GM[923] = FPR_GM(923);
        GM[924] = FPR_GM(924);
        GM[925] = FPR_GM(925);
        GM[926] = FPR_GM(926);
        GM[927] = FPR_GM(927);
        GM[928] = FPR_GM(928);
        GM[929] = FPR_GM(929);
        GM[930] = FPR_GM(930);
        GM[931] = FPR_GM(931);
        GM[932] = FPR_GM(932);
        GM[933] = FPR_GM(933);
        GM[934] = FPR_GM(934);
        GM[935] = FPR_GM(935);
        GM[936] = FPR_GM(936);
        GM[937] = FPR_GM(937);
        GM[938] = FPR_GM(938);
        GM[939] = FPR_GM(939);
        GM[940] = FPR_GM(940);
        GM[941] = FPR_GM(941);
        GM[942] = FPR_GM(942);
        GM[943] = FPR_GM(943);
        GM[944] = FPR_GM(944);
        GM[945] = FPR_GM(945);
        GM[946] = FPR_GM(946);
        GM[947] = FPR_GM(947);
        GM[948] = FPR_GM(948);
        GM[949] = FPR_GM(949);
        GM[950] = FPR_GM(950);
        GM[951] = FPR_GM(951);
        GM[952] = FPR_GM(952);
        GM[953] = FPR_GM(953);
        GM[954] = FPR_GM(954);
        GM[955] = FPR_GM(955);
        GM[956] = FPR_GM(956);
        GM[957] = FPR_GM(957);
        GM[958] = FPR_GM(958);
        GM[959] = FPR_GM(959);
        GM[960] = FPR_GM(960);
        GM[961] = FPR_GM(961);
        GM[962] = FPR_GM(962);
        GM[963] = FPR_GM(963);
        GM[964] = FPR_GM(964);
        GM[965] = FPR_GM(965);
        GM[966] = FPR_GM(966);
        GM[967] = FPR_GM(967);
        GM[968] = FPR_GM(968);
        GM[969] = FPR_GM(969);
        GM[970] = FPR_GM(970);
        GM[971] = FPR_GM(971);
        GM[972] = FPR_GM(972);
        GM[973] = FPR_GM(973);
        GM[974] = FPR_GM(974);
        GM[975] = FPR_GM(975);
        GM[976] = FPR_GM(976);
        GM[977] = FPR_GM(977);
        GM[978] = FPR_GM(978);
        GM[979] = FPR_GM(979);
        GM[980] = FPR_GM(980);
        GM[981] = FPR_GM(981);
        GM[982] = FPR_GM(982);
        GM[983] = FPR_GM(983);
        GM[984] = FPR_GM(984);
        GM[985] = FPR_GM(985);
        GM[986] = FPR_GM(986);
        GM[987] = FPR_GM(987);
        GM[988] = FPR_GM(988);
        GM[989] = FPR_GM(989);
        GM[990] = FPR_GM(990);
        GM[991] = FPR_GM(991);
        GM[992] = FPR_GM(992);
        GM[993] = FPR_GM(993);
        GM[994] = FPR_GM(994);
        GM[995] = FPR_GM(995);
        GM[996] = FPR_GM(996);
        GM[997] = FPR_GM(997);
        GM[998] = FPR_GM(998);
        GM[999] = FPR_GM(999);
        GM[1000] = FPR_GM(1000);
        GM[1001] = FPR_GM(1001);
        GM[1002] = FPR_GM(1002);
        GM[1003] = FPR_GM(1003);
        GM[1004] = FPR_GM(1004);
        GM[1005] = FPR_GM(1005);
        GM[1006] = FPR_GM(1006);
        GM[1007] = FPR_GM(1007);
        GM[1008] = FPR_GM(1008);
        GM[1009] = FPR_GM(1009);
        GM[1010] = FPR_GM(1010);
        GM[1011] = FPR_GM(1011);
        GM[1012] = FPR_GM(1012);
        GM[1013] = FPR_GM(1013);
        GM[1014] = FPR_GM(1014);
        GM[1015] = FPR_GM(1015);
        GM[1016] = FPR_GM(1016);
        GM[1017] = FPR_GM(1017);
        GM[1018] = FPR_GM(1018);
        GM[1019] = FPR_GM(1019);
        GM[1020] = FPR_GM(1020);
        GM[1021] = FPR_GM(1021);
        GM[1022] = FPR_GM(1022);
        GM[1023] = FPR_GM(1023);
        GM[1024] = FPR_GM(1024);
        GM[1025] = FPR_GM(1025);
        GM[1026] = FPR_GM(1026);
        GM[1027] = FPR_GM(1027);
        GM[1028] = FPR_GM(1028);
        GM[1029] = FPR_GM(1029);
        GM[1030] = FPR_GM(1030);
        GM[1031] = FPR_GM(1031);
        GM[1032] = FPR_GM(1032);
        GM[1033] = FPR_GM(1033);
        GM[1034] = FPR_GM(1034);
        GM[1035] = FPR_GM(1035);
        GM[1036] = FPR_GM(1036);
        GM[1037] = FPR_GM(1037);
        GM[1038] = FPR_GM(1038);
        GM[1039] = FPR_GM(1039);
        GM[1040] = FPR_GM(1040);
        GM[1041] = FPR_GM(1041);
        GM[1042] = FPR_GM(1042);
        GM[1043] = FPR_GM(1043);
        GM[1044] = FPR_GM(1044);
        GM[1045] = FPR_GM(1045);
        GM[1046] = FPR_GM(1046);
        GM[1047] = FPR_GM(1047);
        GM[1048] = FPR_GM(1048);
        GM[1049] = FPR_GM(1049);
        GM[1050] = FPR_GM(1050);
        GM[1051] = FPR_GM(1051);
        GM[1052] = FPR_GM(1052);
        GM[1053] = FPR_GM(1053);
        GM[1054] = FPR_GM(1054);
        GM[1055] = FPR_GM(1055);
        GM[1056] = FPR_GM(1056);
        GM[1057] = FPR_GM(1057);
        GM[1058] = FPR_GM(1058);
        GM[1059] = FPR_GM(1059);
        GM[1060] = FPR_GM(1060);
        GM[1061] = FPR_GM(1061);
        GM[1062] = FPR_GM(1062);
        GM[1063] = FPR_GM(1063);
        GM[1064] = FPR_GM(1064);
        GM[1065] = FPR_GM(1065);
        GM[1066] = FPR_GM(1066);
        GM[1067] = FPR_GM(1067);
        GM[1068] = FPR_GM(1068);
        GM[1069] = FPR_GM(1069);
        GM[1070] = FPR_GM(1070);
        GM[1071] = FPR_GM(1071);
        GM[1072] = FPR_GM(1072);
        GM[1073] = FPR_GM(1073);
        GM[1074] = FPR_GM(1074);
        GM[1075] = FPR_GM(1075);
        GM[1076] = FPR_GM(1076);
        GM[1077] = FPR_GM(1077);
        GM[1078] = FPR_GM(1078);
        GM[1079] = FPR_GM(1079);
        GM[1080] = FPR_GM(1080);
        GM[1081] = FPR_GM(1081);
        GM[1082] = FPR_GM(1082);
        GM[1083] = FPR_GM(1083);
        GM[1084] = FPR_GM(1084);
        GM[1085] = FPR_GM(1085);
        GM[1086] = FPR_GM(1086);
        GM[1087] = FPR_GM(1087);
        GM[1088] = FPR_GM(1088);
        GM[1089] = FPR_GM(1089);
        GM[1090] = FPR_GM(1090);
        GM[1091] = FPR_GM(1091);
        GM[1092] = FPR_GM(1092);
        GM[1093] = FPR_GM(1093);
        GM[1094] = FPR_GM(1094);
        GM[1095] = FPR_GM(1095);
        GM[1096] = FPR_GM(1096);
        GM[1097] = FPR_GM(1097);
        GM[1098] = FPR_GM(1098);
        GM[1099] = FPR_GM(1099);
        GM[1100] = FPR_GM(1100);
        GM[1101] = FPR_GM(1101);
        GM[1102] = FPR_GM(1102);
        GM[1103] = FPR_GM(1103);
        GM[1104] = FPR_GM(1104);
        GM[1105] = FPR_GM(1105);
        GM[1106] = FPR_GM(1106);
        GM[1107] = FPR_GM(1107);
        GM[1108] = FPR_GM(1108);
        GM[1109] = FPR_GM(1109);
        GM[1110] = FPR_GM(1110);
        GM[1111] = FPR_GM(1111);
        GM[1112] = FPR_GM(1112);
        GM[1113] = FPR_GM(1113);
        GM[1114] = FPR_GM(1114);
        GM[1115] = FPR_GM(1115);
        GM[1116] = FPR_GM(1116);
        GM[1117] = FPR_GM(1117);
        GM[1118] = FPR_GM(1118);
        GM[1119] = FPR_GM(1119);
        GM[1120] = FPR_GM(1120);
        GM[1121] = FPR_GM(1121);
        GM[1122] = FPR_GM(1122);
        GM[1123] = FPR_GM(1123);
        GM[1124] = FPR_GM(1124);
        GM[1125] = FPR_GM(1125);
        GM[1126] = FPR_GM(1126);
        GM[1127] = FPR_GM(1127);
        GM[1128] = FPR_GM(1128);
        GM[1129] = FPR_GM(1129);
        GM[1130] = FPR_GM(1130);
        GM[1131] = FPR_GM(1131);
        GM[1132] = FPR_GM(1132);
        GM[1133] = FPR_GM(1133);
        GM[1134] = FPR_GM(1134);
        GM[1135] = FPR_GM(1135);
        GM[1136] = FPR_GM(1136);
        GM[1137] = FPR_GM(1137);
        GM[1138] = FPR_GM(1138);
        GM[1139] = FPR_GM(1139);
        GM[1140] = FPR_GM(1140);
        GM[1141] = FPR_GM(1141);
        GM[1142] = FPR_GM(1142);
        GM[1143] = FPR_GM(1143);
        GM[1144] = FPR_GM(1144);
        GM[1145] = FPR_GM(1145);
        GM[1146] = FPR_GM(1146);
        GM[1147] = FPR_GM(1147);
        GM[1148] = FPR_GM(1148);
        GM[1149] = FPR_GM(1149);
        GM[1150] = FPR_GM(1150);
        GM[1151] = FPR_GM(1151);
        GM[1152] = FPR_GM(1152);
        GM[1153] = FPR_GM(1153);
        GM[1154] = FPR_GM(1154);
        GM[1155] = FPR_GM(1155);
        GM[1156] = FPR_GM(1156);
        GM[1157] = FPR_GM(1157);
        GM[1158] = FPR_GM(1158);
        GM[1159] = FPR_GM(1159);
        GM[1160] = FPR_GM(1160);
        GM[1161] = FPR_GM(1161);
        GM[1162] = FPR_GM(1162);
        GM[1163] = FPR_GM(1163);
        GM[1164] = FPR_GM(1164);
        GM[1165] = FPR_GM(1165);
        GM[1166] = FPR_GM(1166);
        GM[1167] = FPR_GM(1167);
        GM[1168] = FPR_GM(1168);
        GM[1169] = FPR_GM(1169);
        GM[1170] = FPR_GM(1170);
        GM[1171] = FPR_GM(1171);
        GM[1172] = FPR_GM(1172);
        GM[1173] = FPR_GM(1173);
        GM[1174] = FPR_GM(1174);
        GM[1175] = FPR_GM(1175);
        GM[1176] = FPR_GM(1176);
        GM[1177] = FPR_GM(1177);
        GM[1178] = FPR_GM(1178);
        GM[1179] = FPR_GM(1179);
        GM[1180] = FPR_GM(1180);
        GM[1181] = FPR_GM(1181);
        GM[1182] = FPR_GM(1182);
        GM[1183] = FPR_GM(1183);
        GM[1184] = FPR_GM(1184);
        GM[1185] = FPR_GM(1185);
        GM[1186] = FPR_GM(1186);
        GM[1187] = FPR_GM(1187);
        GM[1188] = FPR_GM(1188);
        GM[1189] = FPR_GM(1189);
        GM[1190] = FPR_GM(1190);
        GM[1191] = FPR_GM(1191);
        GM[1192] = FPR_GM(1192);
        GM[1193] = FPR_GM(1193);
        GM[1194] = FPR_GM(1194);
        GM[1195] = FPR_GM(1195);
        GM[1196] = FPR_GM(1196);
        GM[1197] = FPR_GM(1197);
        GM[1198] = FPR_GM(1198);
        GM[1199] = FPR_GM(1199);
        GM[1200] = FPR_GM(1200);
        GM[1201] = FPR_GM(1201);
        GM[1202] = FPR_GM(1202);
        GM[1203] = FPR_GM(1203);
        GM[1204] = FPR_GM(1204);
        GM[1205] = FPR_GM(1205);
        GM[1206] = FPR_GM(1206);
        GM[1207] = FPR_GM(1207);
        GM[1208] = FPR_GM(1208);
        GM[1209] = FPR_GM(1209);
        GM[1210] = FPR_GM(1210);
        GM[1211] = FPR_GM(1211);
        GM[1212] = FPR_GM(1212);
        GM[1213] = FPR_GM(1213);
        GM[1214] = FPR_GM(1214);
        GM[1215] = FPR_GM(1215);
        GM[1216] = FPR_GM(1216);
        GM[1217] = FPR_GM(1217);
        GM[1218] = FPR_GM(1218);
        GM[1219] = FPR_GM(1219);
        GM[1220] = FPR_GM(1220);
        GM[1221] = FPR_GM(1221);
        GM[1222] = FPR_GM(1222);
        GM[1223] = FPR_GM(1223);
        GM[1224] = FPR_GM(1224);
        GM[1225] = FPR_GM(1225);
        GM[1226] = FPR_GM(1226);
        GM[1227] = FPR_GM(1227);
        GM[1228] = FPR_GM(1228);
        GM[1229] = FPR_GM(1229);
        GM[1230] = FPR_GM(1230);
        GM[1231] = FPR_GM(1231);
        GM[1232] = FPR_GM(1232);
        GM[1233] = FPR_GM(1233);
        GM[1234] = FPR_GM(1234);
        GM[1235] = FPR_GM(1235);
        GM[1236] = FPR_GM(1236);
        GM[1237] = FPR_GM(1237);
        GM[1238] = FPR_GM(1238);
        GM[1239] = FPR_GM(1239);
        GM[1240] = FPR_GM(1240);
        GM[1241] = FPR_GM(1241);
        GM[1242] = FPR_GM(1242);
        GM[1243] = FPR_GM(1243);
        GM[1244] = FPR_GM(1244);
        GM[1245] = FPR_GM(1245);
        GM[1246] = FPR_GM(1246);
        GM[1247] = FPR_GM(1247);
        GM[1248] = FPR_GM(1248);
        GM[1249] = FPR_GM(1249);
        GM[1250] = FPR_GM(1250);
        GM[1251] = FPR_GM(1251);
        GM[1252] = FPR_GM(1252);
        GM[1253] = FPR_GM(1253);
        GM[1254] = FPR_GM(1254);
        GM[1255] = FPR_GM(1255);
        GM[1256] = FPR_GM(1256);
        GM[1257] = FPR_GM(1257);
        GM[1258] = FPR_GM(1258);
        GM[1259] = FPR_GM(1259);
        GM[1260] = FPR_GM(1260);
        GM[1261] = FPR_GM(1261);
        GM[1262] = FPR_GM(1262);
        GM[1263] = FPR_GM(1263);
        GM[1264] = FPR_GM(1264);
        GM[1265] = FPR_GM(1265);
        GM[1266] = FPR_GM(1266);
        GM[1267] = FPR_GM(1267);
        GM[1268] = FPR_GM(1268);
        GM[1269] = FPR_GM(1269);
        GM[1270] = FPR_GM(1270);
        GM[1271] = FPR_GM(1271);
        GM[1272] = FPR_GM(1272);
        GM[1273] = FPR_GM(1273);
        GM[1274] = FPR_GM(1274);
        GM[1275] = FPR_GM(1275);
        GM[1276] = FPR_GM(1276);
        GM[1277] = FPR_GM(1277);
        GM[1278] = FPR_GM(1278);
        GM[1279] = FPR_GM(1279);
        GM[1280] = FPR_GM(1280);
        GM[1281] = FPR_GM(1281);
        GM[1282] = FPR_GM(1282);
        GM[1283] = FPR_GM(1283);
        GM[1284] = FPR_GM(1284);
        GM[1285] = FPR_GM(1285);
        GM[1286] = FPR_GM(1286);
        GM[1287] = FPR_GM(1287);
        GM[1288] = FPR_GM(1288);
        GM[1289] = FPR_GM(1289);
        GM[1290] = FPR_GM(1290);
        GM[1291] = FPR_GM(1291);
        GM[1292] = FPR_GM(1292);
        GM[1293] = FPR_GM(1293);
        GM[1294] = FPR_GM(1294);
        GM[1295] = FPR_GM(1295);
        GM[1296] = FPR_GM(1296);
        GM[1297] = FPR_GM(1297);
        GM[1298] = FPR_GM(1298);
        GM[1299] = FPR_GM(1299);
        GM[1300] = FPR_GM(1300);
        GM[1301] = FPR_GM(1301);
        GM[1302] = FPR_GM(1302);
        GM[1303] = FPR_GM(1303);
        GM[1304] = FPR_GM(1304);
        GM[1305] = FPR_GM(1305);
        GM[1306] = FPR_GM(1306);
        GM[1307] = FPR_GM(1307);
        GM[1308] = FPR_GM(1308);
        GM[1309] = FPR_GM(1309);
        GM[1310] = FPR_GM(1310);
        GM[1311] = FPR_GM(1311);
        GM[1312] = FPR_GM(1312);
        GM[1313] = FPR_GM(1313);
        GM[1314] = FPR_GM(1314);
        GM[1315] = FPR_GM(1315);
        GM[1316] = FPR_GM(1316);
        GM[1317] = FPR_GM(1317);
        GM[1318] = FPR_GM(1318);
        GM[1319] = FPR_GM(1319);
        GM[1320] = FPR_GM(1320);
        GM[1321] = FPR_GM(1321);
        GM[1322] = FPR_GM(1322);
        GM[1323] = FPR_GM(1323);
        GM[1324] = FPR_GM(1324);
        GM[1325] = FPR_GM(1325);
        GM[1326] = FPR_GM(1326);
        GM[1327] = FPR_GM(1327);
        GM[1328] = FPR_GM(1328);
        GM[1329] = FPR_GM(1329);
        GM[1330] = FPR_GM(1330);
        GM[1331] = FPR_GM(1331);
        GM[1332] = FPR_GM(1332);
        GM[1333] = FPR_GM(1333);
        GM[1334] = FPR_GM(1334);
        GM[1335] = FPR_GM(1335);
        GM[1336] = FPR_GM(1336);
        GM[1337] = FPR_GM(1337);
        GM[1338] = FPR_GM(1338);
        GM[1339] = FPR_GM(1339);
        GM[1340] = FPR_GM(1340);
        GM[1341] = FPR_GM(1341);
        GM[1342] = FPR_GM(1342);
        GM[1343] = FPR_GM(1343);
        GM[1344] = FPR_GM(1344);
        GM[1345] = FPR_GM(1345);
        GM[1346] = FPR_GM(1346);
        GM[1347] = FPR_GM(1347);
        GM[1348] = FPR_GM(1348);
        GM[1349] = FPR_GM(1349);
        GM[1350] = FPR_GM(1350);
        GM[1351] = FPR_GM(1351);
        GM[1352] = FPR_GM(1352);
        GM[1353] = FPR_GM(1353);
        GM[1354] = FPR_GM(1354);
        GM[1355] = FPR_GM(1355);
        GM[1356] = FPR_GM(1356);
        GM[1357] = FPR_GM(1357);
        GM[1358] = FPR_GM(1358);
        GM[1359] = FPR_GM(1359);
        GM[1360] = FPR_GM(1360);
        GM[1361] = FPR_GM(1361);
        GM[1362] = FPR_GM(1362);
        GM[1363] = FPR_GM(1363);
        GM[1364] = FPR_GM(1364);
        GM[1365] = FPR_GM(1365);
        GM[1366] = FPR_GM(1366);
        GM[1367] = FPR_GM(1367);
        GM[1368] = FPR_GM(1368);
        GM[1369] = FPR_GM(1369);
        GM[1370] = FPR_GM(1370);
        GM[1371] = FPR_GM(1371);
        GM[1372] = FPR_GM(1372);
        GM[1373] = FPR_GM(1373);
        GM[1374] = FPR_GM(1374);
        GM[1375] = FPR_GM(1375);
        GM[1376] = FPR_GM(1376);
        GM[1377] = FPR_GM(1377);
        GM[1378] = FPR_GM(1378);
        GM[1379] = FPR_GM(1379);
        GM[1380] = FPR_GM(1380);
        GM[1381] = FPR_GM(1381);
        GM[1382] = FPR_GM(1382);
        GM[1383] = FPR_GM(1383);
        GM[1384] = FPR_GM(1384);
        GM[1385] = FPR_GM(1385);
        GM[1386] = FPR_GM(1386);
        GM[1387] = FPR_GM(1387);
        GM[1388] = FPR_GM(1388);
        GM[1389] = FPR_GM(1389);
        GM[1390] = FPR_GM(1390);
        GM[1391] = FPR_GM(1391);
        GM[1392] = FPR_GM(1392);
        GM[1393] = FPR_GM(1393);
        GM[1394] = FPR_GM(1394);
        GM[1395] = FPR_GM(1395);
        GM[1396] = FPR_GM(1396);
        GM[1397] = FPR_GM(1397);
        GM[1398] = FPR_GM(1398);
        GM[1399] = FPR_GM(1399);
        GM[1400] = FPR_GM(1400);
        GM[1401] = FPR_GM(1401);
        GM[1402] = FPR_GM(1402);
        GM[1403] = FPR_GM(1403);
        GM[1404] = FPR_GM(1404);
        GM[1405] = FPR_GM(1405);
        GM[1406] = FPR_GM(1406);
        GM[1407] = FPR_GM(1407);
        GM[1408] = FPR_GM(1408);
        GM[1409] = FPR_GM(1409);
        GM[1410] = FPR_GM(1410);
        GM[1411] = FPR_GM(1411);
        GM[1412] = FPR_GM(1412);
        GM[1413] = FPR_GM(1413);
        GM[1414] = FPR_GM(1414);
        GM[1415] = FPR_GM(1415);
        GM[1416] = FPR_GM(1416);
        GM[1417] = FPR_GM(1417);
        GM[1418] = FPR_GM(1418);
        GM[1419] = FPR_GM(1419);
        GM[1420] = FPR_GM(1420);
        GM[1421] = FPR_GM(1421);
        GM[1422] = FPR_GM(1422);
        GM[1423] = FPR_GM(1423);
        GM[1424] = FPR_GM(1424);
        GM[1425] = FPR_GM(1425);
        GM[1426] = FPR_GM(1426);
        GM[1427] = FPR_GM(1427);
        GM[1428] = FPR_GM(1428);
        GM[1429] = FPR_GM(1429);
        GM[1430] = FPR_GM(1430);
        GM[1431] = FPR_GM(1431);
        GM[1432] = FPR_GM(1432);
        GM[1433] = FPR_GM(1433);
        GM[1434] = FPR_GM(1434);
        GM[1435] = FPR_GM(1435);
        GM[1436] = FPR_GM(1436);
        GM[1437] = FPR_GM(1437);
        GM[1438] = FPR_GM(1438);
        GM[1439] = FPR_GM(1439);
        GM[1440] = FPR_GM(1440);
        GM[1441] = FPR_GM(1441);
        GM[1442] = FPR_GM(1442);
        GM[1443] = FPR_GM(1443);
        GM[1444] = FPR_GM(1444);
        GM[1445] = FPR_GM(1445);
        GM[1446] = FPR_GM(1446);
        GM[1447] = FPR_GM(1447);
        GM[1448] = FPR_GM(1448);
        GM[1449] = FPR_GM(1449);
        GM[1450] = FPR_GM(1450);
        GM[1451] = FPR_GM(1451);
        GM[1452] = FPR_GM(1452);
        GM[1453] = FPR_GM(1453);
        GM[1454] = FPR_GM(1454);
        GM[1455] = FPR_GM(1455);
        GM[1456] = FPR_GM(1456);
        GM[1457] = FPR_GM(1457);
        GM[1458] = FPR_GM(1458);
        GM[1459] = FPR_GM(1459);
        GM[1460] = FPR_GM(1460);
        GM[1461] = FPR_GM(1461);
        GM[1462] = FPR_GM(1462);
        GM[1463] = FPR_GM(1463);
        GM[1464] = FPR_GM(1464);
        GM[1465] = FPR_GM(1465);
        GM[1466] = FPR_GM(1466);
        GM[1467] = FPR_GM(1467);
        GM[1468] = FPR_GM(1468);
        GM[1469] = FPR_GM(1469);
        GM[1470] = FPR_GM(1470);
        GM[1471] = FPR_GM(1471);
        GM[1472] = FPR_GM(1472);
        GM[1473] = FPR_GM(1473);
        GM[1474] = FPR_GM(1474);
        GM[1475] = FPR_GM(1475);
        GM[1476] = FPR_GM(1476);
        GM[1477] = FPR_GM(1477);
        GM[1478] = FPR_GM(1478);
        GM[1479] = FPR_GM(1479);
        GM[1480] = FPR_GM(1480);
        GM[1481] = FPR_GM(1481);
        GM[1482] = FPR_GM(1482);
        GM[1483] = FPR_GM(1483);
        GM[1484] = FPR_GM(1484);
        GM[1485] = FPR_GM(1485);
        GM[1486] = FPR_GM(1486);
        GM[1487] = FPR_GM(1487);
        GM[1488] = FPR_GM(1488);
        GM[1489] = FPR_GM(1489);
        GM[1490] = FPR_GM(1490);
        GM[1491] = FPR_GM(1491);
        GM[1492] = FPR_GM(1492);
        GM[1493] = FPR_GM(1493);
        GM[1494] = FPR_GM(1494);
        GM[1495] = FPR_GM(1495);
        GM[1496] = FPR_GM(1496);
        GM[1497] = FPR_GM(1497);
        GM[1498] = FPR_GM(1498);
        GM[1499] = FPR_GM(1499);
        GM[1500] = FPR_GM(1500);
        GM[1501] = FPR_GM(1501);
        GM[1502] = FPR_GM(1502);
        GM[1503] = FPR_GM(1503);
        GM[1504] = FPR_GM(1504);
        GM[1505] = FPR_GM(1505);
        GM[1506] = FPR_GM(1506);
        GM[1507] = FPR_GM(1507);
        GM[1508] = FPR_GM(1508);
        GM[1509] = FPR_GM(1509);
        GM[1510] = FPR_GM(1510);
        GM[1511] = FPR_GM(1511);
        GM[1512] = FPR_GM(1512);
        GM[1513] = FPR_GM(1513);
        GM[1514] = FPR_GM(1514);
        GM[1515] = FPR_GM(1515);
        GM[1516] = FPR_GM(1516);
        GM[1517] = FPR_GM(1517);
        GM[1518] = FPR_GM(1518);
        GM[1519] = FPR_GM(1519);
        GM[1520] = FPR_GM(1520);
        GM[1521] = FPR_GM(1521);
        GM[1522] = FPR_GM(1522);
        GM[1523] = FPR_GM(1523);
        GM[1524] = FPR_GM(1524);
        GM[1525] = FPR_GM(1525);
        GM[1526] = FPR_GM(1526);
        GM[1527] = FPR_GM(1527);
        GM[1528] = FPR_GM(1528);
        GM[1529] = FPR_GM(1529);
        GM[1530] = FPR_GM(1530);
        GM[1531] = FPR_GM(1531);
        GM[1532] = FPR_GM(1532);
        GM[1533] = FPR_GM(1533);
        GM[1534] = FPR_GM(1534);
        GM[1535] = FPR_GM(1535);
        GM[1536] = FPR_GM(1536);
        GM[1537] = FPR_GM(1537);
        GM[1538] = FPR_GM(1538);
        GM[1539] = FPR_GM(1539);
        GM[1540] = FPR_GM(1540);
        GM[1541] = FPR_GM(1541);
        GM[1542] = FPR_GM(1542);
        GM[1543] = FPR_GM(1543);
        GM[1544] = FPR_GM(1544);
        GM[1545] = FPR_GM(1545);
        GM[1546] = FPR_GM(1546);
        GM[1547] = FPR_GM(1547);
        GM[1548] = FPR_GM(1548);
        GM[1549] = FPR_GM(1549);
        GM[1550] = FPR_GM(1550);
        GM[1551] = FPR_GM(1551);
        GM[1552] = FPR_GM(1552);
        GM[1553] = FPR_GM(1553);
        GM[1554] = FPR_GM(1554);
        GM[1555] = FPR_GM(1555);
        GM[1556] = FPR_GM(1556);
        GM[1557] = FPR_GM(1557);
        GM[1558] = FPR_GM(1558);
        GM[1559] = FPR_GM(1559);
        GM[1560] = FPR_GM(1560);
        GM[1561] = FPR_GM(1561);
        GM[1562] = FPR_GM(1562);
        GM[1563] = FPR_GM(1563);
        GM[1564] = FPR_GM(1564);
        GM[1565] = FPR_GM(1565);
        GM[1566] = FPR_GM(1566);
        GM[1567] = FPR_GM(1567);
        GM[1568] = FPR_GM(1568);
        GM[1569] = FPR_GM(1569);
        GM[1570] = FPR_GM(1570);
        GM[1571] = FPR_GM(1571);
        GM[1572] = FPR_GM(1572);
        GM[1573] = FPR_GM(1573);
        GM[1574] = FPR_GM(1574);
        GM[1575] = FPR_GM(1575);
        GM[1576] = FPR_GM(1576);
        GM[1577] = FPR_GM(1577);
        GM[1578] = FPR_GM(1578);
        GM[1579] = FPR_GM(1579);
        GM[1580] = FPR_GM(1580);
        GM[1581] = FPR_GM(1581);
        GM[1582] = FPR_GM(1582);
        GM[1583] = FPR_GM(1583);
        GM[1584] = FPR_GM(1584);
        GM[1585] = FPR_GM(1585);
        GM[1586] = FPR_GM(1586);
        GM[1587] = FPR_GM(1587);
        GM[1588] = FPR_GM(1588);
        GM[1589] = FPR_GM(1589);
        GM[1590] = FPR_GM(1590);
        GM[1591] = FPR_GM(1591);
        GM[1592] = FPR_GM(1592);
        GM[1593] = FPR_GM(1593);
        GM[1594] = FPR_GM(1594);
        GM[1595] = FPR_GM(1595);
        GM[1596] = FPR_GM(1596);
        GM[1597] = FPR_GM(1597);
        GM[1598] = FPR_GM(1598);
        GM[1599] = FPR_GM(1599);
        GM[1600] = FPR_GM(1600);
        GM[1601] = FPR_GM(1601);
        GM[1602] = FPR_GM(1602);
        GM[1603] = FPR_GM(1603);
        GM[1604] = FPR_GM(1604);
        GM[1605] = FPR_GM(1605);
        GM[1606] = FPR_GM(1606);
        GM[1607] = FPR_GM(1607);
        GM[1608] = FPR_GM(1608);
        GM[1609] = FPR_GM(1609);
        GM[1610] = FPR_GM(1610);
        GM[1611] = FPR_GM(1611);
        GM[1612] = FPR_GM(1612);
        GM[1613] = FPR_GM(1613);
        GM[1614] = FPR_GM(1614);
        GM[1615] = FPR_GM(1615);
        GM[1616] = FPR_GM(1616);
        GM[1617] = FPR_GM(1617);
        GM[1618] = FPR_GM(1618);
        GM[1619] = FPR_GM(1619);
        GM[1620] = FPR_GM(1620);
        GM[1621] = FPR_GM(1621);
        GM[1622] = FPR_GM(1622);
        GM[1623] = FPR_GM(1623);
        GM[1624] = FPR_GM(1624);
        GM[1625] = FPR_GM(1625);
        GM[1626] = FPR_GM(1626);
        GM[1627] = FPR_GM(1627);
        GM[1628] = FPR_GM(1628);
        GM[1629] = FPR_GM(1629);
        GM[1630] = FPR_GM(1630);
        GM[1631] = FPR_GM(1631);
        GM[1632] = FPR_GM(1632);
        GM[1633] = FPR_GM(1633);
        GM[1634] = FPR_GM(1634);
        GM[1635] = FPR_GM(1635);
        GM[1636] = FPR_GM(1636);
        GM[1637] = FPR_GM(1637);
        GM[1638] = FPR_GM(1638);
        GM[1639] = FPR_GM(1639);
        GM[1640] = FPR_GM(1640);
        GM[1641] = FPR_GM(1641);
        GM[1642] = FPR_GM(1642);
        GM[1643] = FPR_GM(1643);
        GM[1644] = FPR_GM(1644);
        GM[1645] = FPR_GM(1645);
        GM[1646] = FPR_GM(1646);
        GM[1647] = FPR_GM(1647);
        GM[1648] = FPR_GM(1648);
        GM[1649] = FPR_GM(1649);
        GM[1650] = FPR_GM(1650);
        GM[1651] = FPR_GM(1651);
        GM[1652] = FPR_GM(1652);
        GM[1653] = FPR_GM(1653);
        GM[1654] = FPR_GM(1654);
        GM[1655] = FPR_GM(1655);
        GM[1656] = FPR_GM(1656);
        GM[1657] = FPR_GM(1657);
        GM[1658] = FPR_GM(1658);
        GM[1659] = FPR_GM(1659);
        GM[1660] = FPR_GM(1660);
        GM[1661] = FPR_GM(1661);
        GM[1662] = FPR_GM(1662);
        GM[1663] = FPR_GM(1663);
        GM[1664] = FPR_GM(1664);
        GM[1665] = FPR_GM(1665);
        GM[1666] = FPR_GM(1666);
        GM[1667] = FPR_GM(1667);
        GM[1668] = FPR_GM(1668);
        GM[1669] = FPR_GM(1669);
        GM[1670] = FPR_GM(1670);
        GM[1671] = FPR_GM(1671);
        GM[1672] = FPR_GM(1672);
        GM[1673] = FPR_GM(1673);
        GM[1674] = FPR_GM(1674);
        GM[1675] = FPR_GM(1675);
        GM[1676] = FPR_GM(1676);
        GM[1677] = FPR_GM(1677);
        GM[1678] = FPR_GM(1678);
        GM[1679] = FPR_GM(1679);
        GM[1680] = FPR_GM(1680);
        GM[1681] = FPR_GM(1681);
        GM[1682] = FPR_GM(1682);
        GM[1683] = FPR_GM(1683);
        GM[1684] = FPR_GM(1684);
        GM[1685] = FPR_GM(1685);
        GM[1686] = FPR_GM(1686);
        GM[1687] = FPR_GM(1687);
        GM[1688] = FPR_GM(1688);
        GM[1689] = FPR_GM(1689);
        GM[1690] = FPR_GM(1690);
        GM[1691] = FPR_GM(1691);
        GM[1692] = FPR_GM(1692);
        GM[1693] = FPR_GM(1693);
        GM[1694] = FPR_GM(1694);
        GM[1695] = FPR_GM(1695);
        GM[1696] = FPR_GM(1696);
        GM[1697] = FPR_GM(1697);
        GM[1698] = FPR_GM(1698);
        GM[1699] = FPR_GM(1699);
        GM[1700] = FPR_GM(1700);
        GM[1701] = FPR_GM(1701);
        GM[1702] = FPR_GM(1702);
        GM[1703] = FPR_GM(1703);
        GM[1704] = FPR_GM(1704);
        GM[1705] = FPR_GM(1705);
        GM[1706] = FPR_GM(1706);
        GM[1707] = FPR_GM(1707);
        GM[1708] = FPR_GM(1708);
        GM[1709] = FPR_GM(1709);
        GM[1710] = FPR_GM(1710);
        GM[1711] = FPR_GM(1711);
        GM[1712] = FPR_GM(1712);
        GM[1713] = FPR_GM(1713);
        GM[1714] = FPR_GM(1714);
        GM[1715] = FPR_GM(1715);
        GM[1716] = FPR_GM(1716);
        GM[1717] = FPR_GM(1717);
        GM[1718] = FPR_GM(1718);
        GM[1719] = FPR_GM(1719);
        GM[1720] = FPR_GM(1720);
        GM[1721] = FPR_GM(1721);
        GM[1722] = FPR_GM(1722);
        GM[1723] = FPR_GM(1723);
        GM[1724] = FPR_GM(1724);
        GM[1725] = FPR_GM(1725);
        GM[1726] = FPR_GM(1726);
        GM[1727] = FPR_GM(1727);
        GM[1728] = FPR_GM(1728);
        GM[1729] = FPR_GM(1729);
        GM[1730] = FPR_GM(1730);
        GM[1731] = FPR_GM(1731);
        GM[1732] = FPR_GM(1732);
        GM[1733] = FPR_GM(1733);
        GM[1734] = FPR_GM(1734);
        GM[1735] = FPR_GM(1735);
        GM[1736] = FPR_GM(1736);
        GM[1737] = FPR_GM(1737);
        GM[1738] = FPR_GM(1738);
        GM[1739] = FPR_GM(1739);
        GM[1740] = FPR_GM(1740);
        GM[1741] = FPR_GM(1741);
        GM[1742] = FPR_GM(1742);
        GM[1743] = FPR_GM(1743);
        GM[1744] = FPR_GM(1744);
        GM[1745] = FPR_GM(1745);
        GM[1746] = FPR_GM(1746);
        GM[1747] = FPR_GM(1747);
        GM[1748] = FPR_GM(1748);
        GM[1749] = FPR_GM(1749);
        GM[1750] = FPR_GM(1750);
        GM[1751] = FPR_GM(1751);
        GM[1752] = FPR_GM(1752);
        GM[1753] = FPR_GM(1753);
        GM[1754] = FPR_GM(1754);
        GM[1755] = FPR_GM(1755);
        GM[1756] = FPR_GM(1756);
        GM[1757] = FPR_GM(1757);
        GM[1758] = FPR_GM(1758);
        GM[1759] = FPR_GM(1759);
        GM[1760] = FPR_GM(1760);
        GM[1761] = FPR_GM(1761);
        GM[1762] = FPR_GM(1762);
        GM[1763] = FPR_GM(1763);
        GM[1764] = FPR_GM(1764);
        GM[1765] = FPR_GM(1765);
        GM[1766] = FPR_GM(1766);
        GM[1767] = FPR_GM(1767);
        GM[1768] = FPR_GM(1768);
        GM[1769] = FPR_GM(1769);
        GM[1770] = FPR_GM(1770);
        GM[1771] = FPR_GM(1771);
        GM[1772] = FPR_GM(1772);
        GM[1773] = FPR_GM(1773);
        GM[1774] = FPR_GM(1774);
        GM[1775] = FPR_GM(1775);
        GM[1776] = FPR_GM(1776);
        GM[1777] = FPR_GM(1777);
        GM[1778] = FPR_GM(1778);
        GM[1779] = FPR_GM(1779);
        GM[1780] = FPR_GM(1780);
        GM[1781] = FPR_GM(1781);
        GM[1782] = FPR_GM(1782);
        GM[1783] = FPR_GM(1783);
        GM[1784] = FPR_GM(1784);
        GM[1785] = FPR_GM(1785);
        GM[1786] = FPR_GM(1786);
        GM[1787] = FPR_GM(1787);
        GM[1788] = FPR_GM(1788);
        GM[1789] = FPR_GM(1789);
        GM[1790] = FPR_GM(1790);
        GM[1791] = FPR_GM(1791);
        GM[1792] = FPR_GM(1792);
        GM[1793] = FPR_GM(1793);
        GM[1794] = FPR_GM(1794);
        GM[1795] = FPR_GM(1795);
        GM[1796] = FPR_GM(1796);
        GM[1797] = FPR_GM(1797);
        GM[1798] = FPR_GM(1798);
        GM[1799] = FPR_GM(1799);
        GM[1800] = FPR_GM(1800);
        GM[1801] = FPR_GM(1801);
        GM[1802] = FPR_GM(1802);
        GM[1803] = FPR_GM(1803);
        GM[1804] = FPR_GM(1804);
        GM[1805] = FPR_GM(1805);
        GM[1806] = FPR_GM(1806);
        GM[1807] = FPR_GM(1807);
        GM[1808] = FPR_GM(1808);
        GM[1809] = FPR_GM(1809);
        GM[1810] = FPR_GM(1810);
        GM[1811] = FPR_GM(1811);
        GM[1812] = FPR_GM(1812);
        GM[1813] = FPR_GM(1813);
        GM[1814] = FPR_GM(1814);
        GM[1815] = FPR_GM(1815);
        GM[1816] = FPR_GM(1816);
        GM[1817] = FPR_GM(1817);
        GM[1818] = FPR_GM(1818);
        GM[1819] = FPR_GM(1819);
        GM[1820] = FPR_GM(1820);
        GM[1821] = FPR_GM(1821);
        GM[1822] = FPR_GM(1822);
        GM[1823] = FPR_GM(1823);
        GM[1824] = FPR_GM(1824);
        GM[1825] = FPR_GM(1825);
        GM[1826] = FPR_GM(1826);
        GM[1827] = FPR_GM(1827);
        GM[1828] = FPR_GM(1828);
        GM[1829] = FPR_GM(1829);
        GM[1830] = FPR_GM(1830);
        GM[1831] = FPR_GM(1831);
        GM[1832] = FPR_GM(1832);
        GM[1833] = FPR_GM(1833);
        GM[1834] = FPR_GM(1834);
        GM[1835] = FPR_GM(1835);
        GM[1836] = FPR_GM(1836);
        GM[1837] = FPR_GM(1837);
        GM[1838] = FPR_GM(1838);
        GM[1839] = FPR_GM(1839);
        GM[1840] = FPR_GM(1840);
        GM[1841] = FPR_GM(1841);
        GM[1842] = FPR_GM(1842);
        GM[1843] = FPR_GM(1843);
        GM[1844] = FPR_GM(1844);
        GM[1845] = FPR_GM(1845);
        GM[1846] = FPR_GM(1846);
        GM[1847] = FPR_GM(1847);
        GM[1848] = FPR_GM(1848);
        GM[1849] = FPR_GM(1849);
        GM[1850] = FPR_GM(1850);
        GM[1851] = FPR_GM(1851);
        GM[1852] = FPR_GM(1852);
        GM[1853] = FPR_GM(1853);
        GM[1854] = FPR_GM(1854);
        GM[1855] = FPR_GM(1855);
        GM[1856] = FPR_GM(1856);
        GM[1857] = FPR_GM(1857);
        GM[1858] = FPR_GM(1858);
        GM[1859] = FPR_GM(1859);
        GM[1860] = FPR_GM(1860);
        GM[1861] = FPR_GM(1861);
        GM[1862] = FPR_GM(1862);
        GM[1863] = FPR_GM(1863);
        GM[1864] = FPR_GM(1864);
        GM[1865] = FPR_GM(1865);
        GM[1866] = FPR_GM(1866);
        GM[1867] = FPR_GM(1867);
        GM[1868] = FPR_GM(1868);
        GM[1869] = FPR_GM(1869);
        GM[1870] = FPR_GM(1870);
        GM[1871] = FPR_GM(1871);
        GM[1872] = FPR_GM(1872);
        GM[1873] = FPR_GM(1873);
        GM[1874] = FPR_GM(1874);
        GM[1875] = FPR_GM(1875);
        GM[1876] = FPR_GM(1876);
        GM[1877] = FPR_GM(1877);
        GM[1878] = FPR_GM(1878);
        GM[1879] = FPR_GM(1879);
        GM[1880] = FPR_GM(1880);
        GM[1881] = FPR_GM(1881);
        GM[1882] = FPR_GM(1882);
        GM[1883] = FPR_GM(1883);
        GM[1884] = FPR_GM(1884);
        GM[1885] = FPR_GM(1885);
        GM[1886] = FPR_GM(1886);
        GM[1887] = FPR_GM(1887);
        GM[1888] = FPR_GM(1888);
        GM[1889] = FPR_GM(1889);
        GM[1890] = FPR_GM(1890);
        GM[1891] = FPR_GM(1891);
        GM[1892] = FPR_GM(1892);
        GM[1893] = FPR_GM(1893);
        GM[1894] = FPR_GM(1894);
        GM[1895] = FPR_GM(1895);
        GM[1896] = FPR_GM(1896);
        GM[1897] = FPR_GM(1897);
        GM[1898] = FPR_GM(1898);
        GM[1899] = FPR_GM(1899);
        GM[1900] = FPR_GM(1900);
        GM[1901] = FPR_GM(1901);
        GM[1902] = FPR_GM(1902);
        GM[1903] = FPR_GM(1903);
        GM[1904] = FPR_GM(1904);
        GM[1905] = FPR_GM(1905);
        GM[1906] = FPR_GM(1906);
        GM[1907] = FPR_GM(1907);
        GM[1908] = FPR_GM(1908);
        GM[1909] = FPR_GM(1909);
        GM[1910] = FPR_GM(1910);
        GM[1911] = FPR_GM(1911);
        GM[1912] = FPR_GM(1912);
        GM[1913] = FPR_GM(1913);
        GM[1914] = FPR_GM(1914);
        GM[1915] = FPR_GM(1915);
        GM[1916] = FPR_GM(1916);
        GM[1917] = FPR_GM(1917);
        GM[1918] = FPR_GM(1918);
        GM[1919] = FPR_GM(1919);
        GM[1920] = FPR_GM(1920);
        GM[1921] = FPR_GM(1921);
        GM[1922] = FPR_GM(1922);
        GM[1923] = FPR_GM(1923);
        GM[1924] = FPR_GM(1924);
        GM[1925] = FPR_GM(1925);
        GM[1926] = FPR_GM(1926);
        GM[1927] = FPR_GM(1927);
        GM[1928] = FPR_GM(1928);
        GM[1929] = FPR_GM(1929);
        GM[1930] = FPR_GM(1930);
        GM[1931] = FPR_GM(1931);
        GM[1932] = FPR_GM(1932);
        GM[1933] = FPR_GM(1933);
        GM[1934] = FPR_GM(1934);
        GM[1935] = FPR_GM(1935);
        GM[1936] = FPR_GM(1936);
        GM[1937] = FPR_GM(1937);
        GM[1938] = FPR_GM(1938);
        GM[1939] = FPR_GM(1939);
        GM[1940] = FPR_GM(1940);
        GM[1941] = FPR_GM(1941);
        GM[1942] = FPR_GM(1942);
        GM[1943] = FPR_GM(1943);
        GM[1944] = FPR_GM(1944);
        GM[1945] = FPR_GM(1945);
        GM[1946] = FPR_GM(1946);
        GM[1947] = FPR_GM(1947);
        GM[1948] = FPR_GM(1948);
        GM[1949] = FPR_GM(1949);
        GM[1950] = FPR_GM(1950);
        GM[1951] = FPR_GM(1951);
        GM[1952] = FPR_GM(1952);
        GM[1953] = FPR_GM(1953);
        GM[1954] = FPR_GM(1954);
        GM[1955] = FPR_GM(1955);
        GM[1956] = FPR_GM(1956);
        GM[1957] = FPR_GM(1957);
        GM[1958] = FPR_GM(1958);
        GM[1959] = FPR_GM(1959);
        GM[1960] = FPR_GM(1960);
        GM[1961] = FPR_GM(1961);
        GM[1962] = FPR_GM(1962);
        GM[1963] = FPR_GM(1963);
        GM[1964] = FPR_GM(1964);
        GM[1965] = FPR_GM(1965);
        GM[1966] = FPR_GM(1966);
        GM[1967] = FPR_GM(1967);
        GM[1968] = FPR_GM(1968);
        GM[1969] = FPR_GM(1969);
        GM[1970] = FPR_GM(1970);
        GM[1971] = FPR_GM(1971);
        GM[1972] = FPR_GM(1972);
        GM[1973] = FPR_GM(1973);
        GM[1974] = FPR_GM(1974);
        GM[1975] = FPR_GM(1975);
        GM[1976] = FPR_GM(1976);
        GM[1977] = FPR_GM(1977);
        GM[1978] = FPR_GM(1978);
        GM[1979] = FPR_GM(1979);
        GM[1980] = FPR_GM(1980);
        GM[1981] = FPR_GM(1981);
        GM[1982] = FPR_GM(1982);
        GM[1983] = FPR_GM(1983);
        GM[1984] = FPR_GM(1984);
        GM[1985] = FPR_GM(1985);
        GM[1986] = FPR_GM(1986);
        GM[1987] = FPR_GM(1987);
        GM[1988] = FPR_GM(1988);
        GM[1989] = FPR_GM(1989);
        GM[1990] = FPR_GM(1990);
        GM[1991] = FPR_GM(1991);
        GM[1992] = FPR_GM(1992);
        GM[1993] = FPR_GM(1993);
        GM[1994] = FPR_GM(1994);
        GM[1995] = FPR_GM(1995);
        GM[1996] = FPR_GM(1996);
        GM[1997] = FPR_GM(1997);
        GM[1998] = FPR_GM(1998);
        GM[1999] = FPR_GM(1999);
        GM[2000] = FPR_GM(2000);
        GM[2001] = FPR_GM(2001);
        GM[2002] = FPR_GM(2002);
        GM[2003] = FPR_GM(2003);
        GM[2004] = FPR_GM(2004);
        GM[2005] = FPR_GM(2005);
        GM[2006] = FPR_GM(2006);
        GM[2007] = FPR_GM(2007);
        GM[2008] = FPR_GM(2008);
        GM[2009] = FPR_GM(2009);
        GM[2010] = FPR_GM(2010);
        GM[2011] = FPR_GM(2011);
        GM[2012] = FPR_GM(2012);
        GM[2013] = FPR_GM(2013);
        GM[2014] = FPR_GM(2014);
        GM[2015] = FPR_GM(2015);
        GM[2016] = FPR_GM(2016);
        GM[2017] = FPR_GM(2017);
        GM[2018] = FPR_GM(2018);
        GM[2019] = FPR_GM(2019);
        GM[2020] = FPR_GM(2020);
        GM[2021] = FPR_GM(2021);
        GM[2022] = FPR_GM(2022);
        GM[2023] = FPR_GM(2023);
        GM[2024] = FPR_GM(2024);
        GM[2025] = FPR_GM(2025);
        GM[2026] = FPR_GM(2026);
        GM[2027] = FPR_GM(2027);
        GM[2028] = FPR_GM(2028);
        GM[2029] = FPR_GM(2029);
        GM[2030] = FPR_GM(2030);
        GM[2031] = FPR_GM(2031);
        GM[2032] = FPR_GM(2032);
        GM[2033] = FPR_GM(2033);
        GM[2034] = FPR_GM(2034);
        GM[2035] = FPR_GM(2035);
        GM[2036] = FPR_GM(2036);
        GM[2037] = FPR_GM(2037);
        GM[2038] = FPR_GM(2038);
        GM[2039] = FPR_GM(2039);
        GM[2040] = FPR_GM(2040);
        GM[2041] = FPR_GM(2041);
        GM[2042] = FPR_GM(2042);
        GM[2043] = FPR_GM(2043);
        GM[2044] = FPR_GM(2044);
        GM[2045] = FPR_GM(2045);
        GM[2046] = FPR_GM(2046);
        GM[2047] = FPR_GM(2047);
    }
}
const uint64_t GM2[] = {
	FPR2_ZERO, FPR2_ZERO,
	FPR2_NZERO, FPR2_ONE,
	FPR2(   6369051672525773, -53), FPR2(   6369051672525773, -53),
	FPR2(  -6369051672525773, -53), FPR2(   6369051672525773, -53),
	FPR2(   8321567036706118, -53), FPR2(   6893811853601123, -54),
	FPR2(  -6893811853601123, -54), FPR2(   8321567036706118, -53),
	FPR2(   6893811853601123, -54), FPR2(   8321567036706118, -53),
	FPR2(  -8321567036706118, -53), FPR2(   6893811853601123, -54),
	FPR2(   8834128446708912, -53), FPR2(   7028869612283403, -55),
	FPR2(  -7028869612283403, -55), FPR2(   8834128446708912, -53),
	FPR2(   5004131788810440, -53), FPR2(   7489212472271267, -53),
	FPR2(  -7489212472271267, -53), FPR2(   5004131788810440, -53),
	FPR2(   7489212472271267, -53), FPR2(   5004131788810440, -53),
	FPR2(  -5004131788810440, -53), FPR2(   7489212472271267, -53),
	FPR2(   7028869612283403, -55), FPR2(   8834128446708912, -53),
	FPR2(  -8834128446708912, -53), FPR2(   7028869612283403, -55),
	FPR2(   8963827128411430, -53), FPR2(   7062879306626092, -56),
	FPR2(  -7062879306626092, -56), FPR2(   8963827128411430, -53),
	FPR2(   5714106716331478, -53), FPR2(   6962659179435841, -53),
	FPR2(  -6962659179435841, -53), FPR2(   5714106716331478, -53),
	FPR2(   7943640554978737, -53), FPR2(   8491928673252923, -54),
	FPR2(  -8491928673252923, -54), FPR2(   7943640554978737, -53),
	FPR2(   5229303857258246, -54), FPR2(   8619352278838746, -53),
	FPR2(  -8619352278838746, -53), FPR2(   5229303857258246, -54),
	FPR2(   8619352278838746, -53), FPR2(   5229303857258246, -54),
	FPR2(  -5229303857258246, -54), FPR2(   8619352278838746, -53),
	FPR2(   8491928673252923, -54), FPR2(   7943640554978737, -53),
	FPR2(  -7943640554978737, -53), FPR2(   8491928673252923, -54),
	FPR2(   6962659179435841, -53), FPR2(   5714106716331478, -53),
	FPR2(  -5714106716331478, -53), FPR2(   6962659179435841, -53),
	FPR2(   7062879306626092, -56), FPR2(   8963827128411430, -53),
	FPR2(  -8963827128411430, -53), FPR2(   7062879306626092, -56),
	FPR2(   8996349688769918, -53), FPR2(   7071397114140692, -57),
	FPR2(  -7071397114140692, -57), FPR2(   8996349688769918, -53),
	FPR2(   6048865317612704, -53), FPR2(   6673894424096687, -53),
	FPR2(  -6673894424096687, -53), FPR2(   6048865317612704, -53),
	FPR2(   8142411687315315, -53), FPR2(   7702147837811904, -54),
	FPR2(  -7702147837811904, -54), FPR2(   8142411687315315, -53),
	FPR2(   6068868072808413, -54), FPR2(   8480675002222309, -53),
	FPR2(  -8480675002222309, -53), FPR2(   6068868072808413, -54),
	FPR2(   8737264780849367, -53), FPR2(   8754283581366043, -55),
	FPR2(  -8754283581366043, -55), FPR2(   8737264780849367, -53),
	FPR2(   4630625854357486, -53), FPR2(   7725732496764478, -53),
	FPR2(  -7725732496764478, -53), FPR2(   4630625854357486, -53),
	FPR2(   7234650278954817, -53), FPR2(   5365582331473973, -53),
	FPR2(  -5365582331473973, -53), FPR2(   7234650278954817, -53),
	FPR2(   5286522480648506, -55), FPR2(   8909709923362071, -53),
	FPR2(  -8909709923362071, -53), FPR2(   5286522480648506, -55),
	FPR2(   8909709923362071, -53), FPR2(   5286522480648506, -55),
	FPR2(  -5286522480648506, -55), FPR2(   8909709923362071, -53),
	FPR2(   5365582331473973, -53), FPR2(   7234650278954817, -53),
	FPR2(  -7234650278954817, -53), FPR2(   5365582331473973, -53),
	FPR2(   7725732496764478, -53), FPR2(   4630625854357486, -53),
	FPR2(  -4630625854357486, -53), FPR2(   7725732496764478, -53),
	FPR2(   8754283581366043, -55), FPR2(   8737264780849367, -53),
	FPR2(  -8737264780849367, -53), FPR2(   8754283581366043, -55),
	FPR2(   8480675002222309, -53), FPR2(   6068868072808413, -54),
	FPR2(  -6068868072808413, -54), FPR2(   8480675002222309, -53),
	FPR2(   7702147837811904, -54), FPR2(   8142411687315315, -53),
	FPR2(  -8142411687315315, -53), FPR2(   7702147837811904, -54),
	FPR2(   6673894424096687, -53), FPR2(   6048865317612704, -53),
	FPR2(  -6048865317612704, -53), FPR2(   6673894424096687, -53),
	FPR2(   7071397114140692, -57), FPR2(   8996349688769918, -53),
	FPR2(  -8996349688769918, -53), FPR2(   7071397114140692, -57),
	FPR2(   9004486454725901, -53), FPR2(   7073527528384126, -58),
	FPR2(  -7073527528384126, -58), FPR2(   9004486454725901, -53),
	FPR2(   6210829080669407, -53), FPR2(   6523437785808790, -53),
	FPR2(  -6523437785808790, -53), FPR2(   6210829080669407, -53),
	FPR2(   8234469430249786, -53), FPR2(   7300178522992010, -54),
	FPR2(  -7300178522992010, -54), FPR2(   8234469430249786, -53),
	FPR2(   6483292609725855, -54), FPR2(   8403652042342972, -53),
	FPR2(  -8403652042342972, -53), FPR2(   6483292609725855, -54),
	FPR2(   8788343498532233, -53), FPR2(   7893954108215139, -55),
	FPR2(  -7893954108215139, -55), FPR2(   8788343498532233, -53),
	FPR2(   4818830163135267, -53), FPR2(   7609764403282432, -53),
	FPR2(  -7609764403282432, -53), FPR2(   4818830163135267, -53),
	FPR2(   7364149319706498, -53), FPR2(   5186419112612575, -53),
	FPR2(  -5186419112612575, -53), FPR2(   7364149319706498, -53),
	FPR2(   6159551188123590, -55), FPR2(   8874592046238633, -53),
	FPR2(  -8874592046238633, -53), FPR2(   6159551188123590, -55),
	FPR2(   8939460924383187, -53), FPR2(   8820618739413774, -56),
	FPR2(  -8820618739413774, -56), FPR2(   8939460924383187, -53),
	FPR2(   5541513524170937, -53), FPR2(   7100793355396091, -53),
	FPR2(  -7100793355396091, -53), FPR2(   5541513524170937, -53),
	FPR2(   7837046897874218, -53), FPR2(   8879264459430586, -54),
	FPR2(  -8879264459430586, -54), FPR2(   7837046897874218, -53),
	FPR2(   4804669900715639, -54), FPR2(   8680923061569891, -53),
	FPR2(  -8680923061569891, -53), FPR2(   4804669900715639, -54),
	FPR2(   8552589520593170, -53), FPR2(   5650787876693505, -54),
	FPR2(  -5650787876693505, -54), FPR2(   8552589520593170, -53),
	FPR2(   8099477666776158, -54), FPR2(   8045449260044789, -53),
	FPR2(  -8045449260044789, -53), FPR2(   8099477666776158, -54),
	FPR2(   6820330957936494, -53), FPR2(   5883257944270313, -53),
	FPR2(  -5883257944270313, -53), FPR2(   6820330957936494, -53),
	FPR2(   5300885459442166, -56), FPR2(   8982793858156602, -53),
	FPR2(  -8982793858156602, -53), FPR2(   5300885459442166, -56),
	FPR2(   8982793858156602, -53), FPR2(   5300885459442166, -56),
	FPR2(  -5300885459442166, -56), FPR2(   8982793858156602, -53),
	FPR2(   5883257944270313, -53), FPR2(   6820330957936494, -53),
	FPR2(  -6820330957936494, -53), FPR2(   5883257944270313, -53),
	FPR2(   8045449260044789, -53), FPR2(   8099477666776158, -54),
	FPR2(  -8099477666776158, -54), FPR2(   8045449260044789, -53),
	FPR2(   5650787876693505, -54), FPR2(   8552589520593170, -53),
	FPR2(  -8552589520593170, -53), FPR2(   5650787876693505, -54),
	FPR2(   8680923061569891, -53), FPR2(   4804669900715639, -54),
	FPR2(  -4804669900715639, -54), FPR2(   8680923061569891, -53),
	FPR2(   8879264459430586, -54), FPR2(   7837046897874218, -53),
	FPR2(  -7837046897874218, -53), FPR2(   8879264459430586, -54),
	FPR2(   7100793355396091, -53), FPR2(   5541513524170937, -53),
	FPR2(  -5541513524170937, -53), FPR2(   7100793355396091, -53),
	FPR2(   8820618739413774, -56), FPR2(   8939460924383187, -53),
	FPR2(  -8939460924383187, -53), FPR2(   8820618739413774, -56),
	FPR2(   8874592046238633, -53), FPR2(   6159551188123590, -55),
	FPR2(  -6159551188123590, -55), FPR2(   8874592046238633, -53),
	FPR2(   5186419112612575, -53), FPR2(   7364149319706498, -53),
	FPR2(  -7364149319706498, -53), FPR2(   5186419112612575, -53),
	FPR2(   7609764403282432, -53), FPR2(   4818830163135267, -53),
	FPR2(  -4818830163135267, -53), FPR2(   7609764403282432, -53),
	FPR2(   7893954108215139, -55), FPR2(   8788343498532233, -53),
	FPR2(  -8788343498532233, -53), FPR2(   7893954108215139, -55),
	FPR2(   8403652042342972, -53), FPR2(   6483292609725855, -54),
	FPR2(  -6483292609725855, -54), FPR2(   8403652042342972, -53),
	FPR2(   7300178522992010, -54), FPR2(   8234469430249786, -53),
	FPR2(  -8234469430249786, -53), FPR2(   7300178522992010, -54),
	FPR2(   6523437785808790, -53), FPR2(   6210829080669407, -53),
	FPR2(  -6210829080669407, -53), FPR2(   6523437785808790, -53),
	FPR2(   7073527528384126, -58), FPR2(   9004486454725901, -53),
	FPR2(  -9004486454725901, -53), FPR2(   7073527528384126, -58),
	FPR2(   9006521029202651, -53), FPR2(   7074060192106372, -59),
	FPR2(  -7074060192106372, -59), FPR2(   9006521029202651, -53),
	FPR2(   6290414033205309, -53), FPR2(   6446730156091567, -53),
	FPR2(  -6446730156091567, -53), FPR2(   6290414033205309, -53),
	FPR2(   8278641599964811, -53), FPR2(   7097529619223511, -54),
	FPR2(  -7097529619223511, -54), FPR2(   8278641599964811, -53),
	FPR2(   6689055905271015, -54), FPR2(   8363239276060827, -53),
	FPR2(  -8363239276060827, -53), FPR2(   6689055905271015, -54),
	FPR2(   8811899492445997, -53), FPR2(   7461973733147729, -55),
	FPR2(  -7461973733147729, -55), FPR2(   8811899492445997, -53),
	FPR2(   4911850829306697, -53), FPR2(   7550056943179025, -53),
	FPR2(  -7550056943179025, -53), FPR2(   4911850829306697, -53),
	FPR2(   7427240153512674, -53), FPR2(   5095659144473433, -53),
	FPR2(  -5095659144473433, -53), FPR2(   7427240153512674, -53),
	FPR2(   6594706969509681, -55), FPR2(   8855027013722231, -53),
	FPR2(  -8855027013722231, -53), FPR2(   6594706969509681, -55),
	FPR2(   8952318119487099, -53), FPR2(   7942347067146965, -56),
	FPR2(  -7942347067146965, -56), FPR2(   8952318119487099, -53),
	FPR2(   5628233915913940, -53), FPR2(   7032255783343117, -53),
	FPR2(  -7032255783343117, -53), FPR2(   5628233915913940, -53),
	FPR2(   7890937899537737, -53), FPR2(   8686250625038550, -54),
	FPR2(  -8686250625038550, -54), FPR2(   7890937899537737, -53),
	FPR2(   5017364677319486, -54), FPR2(   8650789058710388, -53),
	FPR2(  -8650789058710388, -53), FPR2(   5017364677319486, -54),
	FPR2(   8586617456218381, -53), FPR2(   5440455523270994, -54),
	FPR2(  -5440455523270994, -54), FPR2(   8586617456218381, -53),
	FPR2(   8296327868244873, -54), FPR2(   7995146927371163, -53),
	FPR2(  -7995146927371163, -53), FPR2(   8296327868244873, -54),
	FPR2(   6892014024666815, -53), FPR2(   5799118993295673, -53),
	FPR2(  -5799118993295673, -53), FPR2(   6892014024666815, -53),
	FPR2(   6182347902460953, -56), FPR2(   8973986217941769, -53),
	FPR2(  -8973986217941769, -53), FPR2(   6182347902460953, -56),
	FPR2(   8990248722657709, -53), FPR2(   8837249445142752, -57),
	FPR2(  -8837249445142752, -57), FPR2(   8990248722657709, -53),
	FPR2(   5966510898238870, -53), FPR2(   6747620774451057, -53),
	FPR2(  -6747620774451057, -53), FPR2(   5966510898238870, -53),
	FPR2(   8094539977653340, -53), FPR2(   7901407713763047, -54),
	FPR2(  -7901407713763047, -54), FPR2(   8094539977653340, -53),
	FPR2(   5860269242247018, -54), FPR2(   8517273596445054, -53),
	FPR2(  -8517273596445054, -53), FPR2(   5860269242247018, -54),
	FPR2(   8709749749347266, -53), FPR2(   4591251558497710, -54),
	FPR2(  -4591251558497710, -54), FPR2(   8709749749347266, -53),
	FPR2(   4535470554627767, -53), FPR2(   7781975665774802, -53),
	FPR2(  -7781975665774802, -53), FPR2(   4535470554627767, -53),
	FPR2(   7168261574088514, -53), FPR2(   5453958600874483, -53),
	FPR2(  -5453958600874483, -53), FPR2(   7168261574088514, -53),
	FPR2(   4848781029471607, -55), FPR2(   8925257479345985, -53),
	FPR2(  -8925257479345985, -53), FPR2(   4848781029471607, -55),
	FPR2(   8892820597836187, -53), FPR2(   5723467800985178, -55),
	FPR2(  -5723467800985178, -55), FPR2(   8892820597836187, -53),
	FPR2(   5276398025110506, -53), FPR2(   7299949472100244, -53),
	FPR2(  -7299949472100244, -53), FPR2(   5276398025110506, -53),
	FPR2(   7668325860857618, -53), FPR2(   4725083798866319, -53),
	FPR2(  -4725083798866319, -53), FPR2(   7668325860857618, -53),
	FPR2(   8324745682830097, -55), FPR2(   8763464012413658, -53),
	FPR2(  -8763464012413658, -53), FPR2(   8324745682830097, -55),
	FPR2(   8442799249538603, -53), FPR2(   6276552954161094, -54),
	FPR2(  -6276552954161094, -54), FPR2(   8442799249538603, -53),
	FPR2(   7501728046727114, -54), FPR2(   8189057179727324, -53),
	FPR2(  -8189057179727324, -53), FPR2(   7501728046727114, -54),
	FPR2(   6599163009790561, -53), FPR2(   6130308800119180, -53),
	FPR2(  -6130308800119180, -53), FPR2(   6599163009790561, -53),
	FPR2(   5304479856743885, -57), FPR2(   9001095837710173, -53),
	FPR2(  -9001095837710173, -53), FPR2(   5304479856743885, -57),
	FPR2(   9001095837710173, -53), FPR2(   5304479856743885, -57),
	FPR2(  -5304479856743885, -57), FPR2(   9001095837710173, -53),
	FPR2(   6130308800119180, -53), FPR2(   6599163009790561, -53),
	FPR2(  -6599163009790561, -53), FPR2(   6130308800119180, -53),
	FPR2(   8189057179727324, -53), FPR2(   7501728046727114, -54),
	FPR2(  -7501728046727114, -54), FPR2(   8189057179727324, -53),
	FPR2(   6276552954161094, -54), FPR2(   8442799249538603, -53),
	FPR2(  -8442799249538603, -53), FPR2(   6276552954161094, -54),
	FPR2(   8763464012413658, -53), FPR2(   8324745682830097, -55),
	FPR2(  -8324745682830097, -55), FPR2(   8763464012413658, -53),
	FPR2(   4725083798866319, -53), FPR2(   7668325860857618, -53),
	FPR2(  -7668325860857618, -53), FPR2(   4725083798866319, -53),
	FPR2(   7299949472100244, -53), FPR2(   5276398025110506, -53),
	FPR2(  -5276398025110506, -53), FPR2(   7299949472100244, -53),
	FPR2(   5723467800985178, -55), FPR2(   8892820597836187, -53),
	FPR2(  -8892820597836187, -53), FPR2(   5723467800985178, -55),
	FPR2(   8925257479345985, -53), FPR2(   4848781029471607, -55),
	FPR2(  -4848781029471607, -55), FPR2(   8925257479345985, -53),
	FPR2(   5453958600874483, -53), FPR2(   7168261574088514, -53),
	FPR2(  -7168261574088514, -53), FPR2(   5453958600874483, -53),
	FPR2(   7781975665774802, -53), FPR2(   4535470554627767, -53),
	FPR2(  -4535470554627767, -53), FPR2(   7781975665774802, -53),
	FPR2(   4591251558497710, -54), FPR2(   8709749749347266, -53),
	FPR2(  -8709749749347266, -53), FPR2(   4591251558497710, -54),
	FPR2(   8517273596445054, -53), FPR2(   5860269242247018, -54),
	FPR2(  -5860269242247018, -54), FPR2(   8517273596445054, -53),
	FPR2(   7901407713763047, -54), FPR2(   8094539977653340, -53),
	FPR2(  -8094539977653340, -53), FPR2(   7901407713763047, -54),
	FPR2(   6747620774451057, -53), FPR2(   5966510898238870, -53),
	FPR2(  -5966510898238870, -53), FPR2(   6747620774451057, -53),
	FPR2(   8837249445142752, -57), FPR2(   8990248722657709, -53),
	FPR2(  -8990248722657709, -53), FPR2(   8837249445142752, -57),
	FPR2(   8973986217941769, -53), FPR2(   6182347902460953, -56),
	FPR2(  -6182347902460953, -56), FPR2(   8973986217941769, -53),
	FPR2(   5799118993295673, -53), FPR2(   6892014024666815, -53),
	FPR2(  -6892014024666815, -53), FPR2(   5799118993295673, -53),
	FPR2(   7995146927371163, -53), FPR2(   8296327868244873, -54),
	FPR2(  -8296327868244873, -54), FPR2(   7995146927371163, -53),
	FPR2(   5440455523270994, -54), FPR2(   8586617456218381, -53),
	FPR2(  -8586617456218381, -53), FPR2(   5440455523270994, -54),
	FPR2(   8650789058710388, -53), FPR2(   5017364677319486, -54),
	FPR2(  -5017364677319486, -54), FPR2(   8650789058710388, -53),
	FPR2(   8686250625038550, -54), FPR2(   7890937899537737, -53),
	FPR2(  -7890937899537737, -53), FPR2(   8686250625038550, -54),
	FPR2(   7032255783343117, -53), FPR2(   5628233915913940, -53),
	FPR2(  -5628233915913940, -53), FPR2(   7032255783343117, -53),
	FPR2(   7942347067146965, -56), FPR2(   8952318119487099, -53),
	FPR2(  -8952318119487099, -53), FPR2(   7942347067146965, -56),
	FPR2(   8855027013722231, -53), FPR2(   6594706969509681, -55),
	FPR2(  -6594706969509681, -55), FPR2(   8855027013722231, -53),
	FPR2(   5095659144473433, -53), FPR2(   7427240153512674, -53),
	FPR2(  -7427240153512674, -53), FPR2(   5095659144473433, -53),
	FPR2(   7550056943179025, -53), FPR2(   4911850829306697, -53),
	FPR2(  -4911850829306697, -53), FPR2(   7550056943179025, -53),
	FPR2(   7461973733147729, -55), FPR2(   8811899492445997, -53),
	FPR2(  -8811899492445997, -53), FPR2(   7461973733147729, -55),
	FPR2(   8363239276060827, -53), FPR2(   6689055905271015, -54),
	FPR2(  -6689055905271015, -54), FPR2(   8363239276060827, -53),
	FPR2(   7097529619223511, -54), FPR2(   8278641599964811, -53),
	FPR2(  -8278641599964811, -53), FPR2(   7097529619223511, -54),
	FPR2(   6446730156091567, -53), FPR2(   6290414033205309, -53),
	FPR2(  -6290414033205309, -53), FPR2(   6446730156091567, -53),
	FPR2(   7074060192106372, -59), FPR2(   9006521029202651, -53),
	FPR2(  -9006521029202651, -53), FPR2(   7074060192106372, -59),
	FPR2(   9007029696760466, -53), FPR2(   7074193361797233, -60),
	FPR2(  -7074193361797233, -60), FPR2(   9007029696760466, -53),
	FPR2(   6329852010540816, -53), FPR2(   6408011543315061, -53),
	FPR2(  -6408011543315061, -53), FPR2(   6329852010540816, -53),
	FPR2(   8300260568395001, -53), FPR2(   6995802430416048, -54),
	FPR2(  -6995802430416048, -54), FPR2(   8300260568395001, -53),
	FPR2(   6791561728666308, -54), FPR2(   8342560202721672, -53),
	FPR2(  -8342560202721672, -53), FPR2(   6791561728666308, -54),
	FPR2(   8823180063448708, -53), FPR2(   7245558068298598, -55),
	FPR2(  -7245558068298598, -55), FPR2(   8823180063448708, -53),
	FPR2(   4958084643600824, -53), FPR2(   7519776265388244, -53),
	FPR2(  -7519776265388244, -53), FPR2(   4958084643600824, -53),
	FPR2(   7458366714537629, -53), FPR2(   5049990531286555, -53),
	FPR2(  -5049990531286555, -53), FPR2(   7458366714537629, -53),
	FPR2(   6811916523300038, -55), FPR2(   8844744230026167, -53),
	FPR2(  -8844744230026167, -53), FPR2(   6811916523300038, -55),
	FPR2(   8958241260309380, -53), FPR2(   7502754424118275, -56),
	FPR2(  -7502754424118275, -56), FPR2(   8958241260309380, -53),
	FPR2(   5671277076310961, -53), FPR2(   6997589209028812, -53),
	FPR2(  -6997589209028812, -53), FPR2(   5671277076310961, -53),
	FPR2(   7917438270796208, -53), FPR2(   8589251339374868, -54),
	FPR2(  -8589251339374868, -54), FPR2(   7917438270796208, -53),
	FPR2(   5123430714424177, -54), FPR2(   8635233224599694, -53),
	FPR2(  -8635233224599694, -53), FPR2(   5123430714424177, -54),
	FPR2(   8603146819336178, -53), FPR2(   5334980119757703, -54),
	FPR2(  -5334980119757703, -54), FPR2(   8603146819336178, -53),
	FPR2(   8394286290816088, -54), FPR2(   7969543765584135, -53),
	FPR2(  -7969543765584135, -53), FPR2(   8394286290816088, -54),
	FPR2(   6927467009660074, -53), FPR2(   5756721223463751, -53),
	FPR2(  -5756721223463751, -53), FPR2(   6927467009660074, -53),
	FPR2(   6622738275719969, -56), FPR2(   8969075513488470, -53),
	FPR2(  -8969075513488470, -53), FPR2(   6622738275719969, -56),
	FPR2(   8993468505216860, -53), FPR2(   7954473020348387, -57),
	FPR2(  -7954473020348387, -57), FPR2(   8993468505216860, -53),
	FPR2(   6007801203085623, -53), FPR2(   6710883929767346, -53),
	FPR2(  -6710883929767346, -53), FPR2(   6007801203085623, -53),
	FPR2(   8118628663374582, -53), FPR2(   7801924644814081, -54),
	FPR2(  -7801924644814081, -54), FPR2(   8118628663374582, -53),
	FPR2(   5964680940960804, -54), FPR2(   8499134293134885, -53),
	FPR2(  -8499134293134885, -53), FPR2(   5964680940960804, -54),
	FPR2(   8723671485748716, -53), FPR2(   8968562179829241, -55),
	FPR2(  -8968562179829241, -55), FPR2(   8723671485748716, -53),
	FPR2(   4583134480704026, -53), FPR2(   7754000048129257, -53),
	FPR2(  -7754000048129257, -53), FPR2(   4583134480704026, -53),
	FPR2(   7201591494446370, -53), FPR2(   5409872305491543, -53),
	FPR2(  -5409872305491543, -53), FPR2(   7201591494446370, -53),
	FPR2(   5067747153968079, -55), FPR2(   8917651573624763, -53),
	FPR2(  -8917651573624763, -53), FPR2(   5067747153968079, -55),
	FPR2(   8901432827556552, -53), FPR2(   5505098772745492, -55),
	FPR2(  -5505098772745492, -55), FPR2(   8901432827556552, -53),
	FPR2(   5321090346314263, -53), FPR2(   7267436682969301, -53),
	FPR2(  -7267436682969301, -53), FPR2(   5321090346314263, -53),
	FPR2(   7697174075937797, -53), FPR2(   4677942887564769, -53),
	FPR2(  -4677942887564769, -53), FPR2(   7697174075937797, -53),
	FPR2(   8539675389073947, -55), FPR2(   8750529122869341, -53),
	FPR2(  -8750529122869341, -53), FPR2(   8539675389073947, -55),
	FPR2(   8461896418689196, -53), FPR2(   6172826715203219, -54),
	FPR2(  -6172826715203219, -54), FPR2(   8461896418689196, -53),
	FPR2(   7602081049296905, -54), FPR2(   8165888154058130, -53),
	FPR2(  -8165888154058130, -53), FPR2(   7602081049296905, -54),
	FPR2(   6636653650073061, -53), FPR2(   6089701695779408, -53),
	FPR2(  -6089701695779408, -53), FPR2(   6636653650073061, -53),
	FPR2(   6188054973828419, -57), FPR2(   8998892164841951, -53),
	FPR2(  -8998892164841951, -53), FPR2(   6188054973828419, -57),
	FPR2(   9002960624407544, -53), FPR2(   8841410057981697, -58),
	FPR2(  -8841410057981697, -58), FPR2(   9002960624407544, -53),
	FPR2(   6170685101797492, -53), FPR2(   6561423914750605, -53),
	FPR2(  -6561423914750605, -53), FPR2(   6170685101797492, -53),
	FPR2(   8211917892022175, -53), FPR2(   7401092608336357, -54),
	FPR2(  -7401092608336357, -54), FPR2(   8211917892022175, -53),
	FPR2(   6380042884447767, -54), FPR2(   8423384213768154, -53),
	FPR2(  -8423384213768154, -53), FPR2(   6380042884447767, -54),
	FPR2(   8776068962491037, -53), FPR2(   8109502554616454, -55),
	FPR2(  -8109502554616454, -55), FPR2(   8776068962491037, -53),
	FPR2(   4772046813433470, -53), FPR2(   7639188937642932, -53),
	FPR2(  -7639188937642932, -53), FPR2(   4772046813433470, -53),
	FPR2(   7332187422259511, -53), FPR2(   5231507050503336, -53),
	FPR2(  -5231507050503336, -53), FPR2(   7332187422259511, -53),
	FPR2(   5941621343897074, -55), FPR2(   8883873558446555, -53),
	FPR2(  -8883873558446555, -53), FPR2(   5941621343897074, -55),
	FPR2(   8932527354167686, -53), FPR2(   4629632351109917, -55),
	FPR2(  -4629632351109917, -55), FPR2(   8932527354167686, -53),
	FPR2(   5497839557798690, -53), FPR2(   7134661772733911, -53),
	FPR2(  -7134661772733911, -53), FPR2(   5497839557798690, -53),
	FPR2(   7809658296434922, -53), FPR2(   8975271741297168, -54),
	FPR2(  -8975271741297168, -54), FPR2(   7809658296434922, -53),
	FPR2(   4698049169054608, -54), FPR2(   8695500095790524, -53),
	FPR2(  -8695500095790524, -53), FPR2(   4698049169054608, -54),
	FPR2(   8535092229218300, -53), FPR2(   5755636907708500, -54),
	FPR2(  -5755636907708500, -54), FPR2(   8535092229218300, -53),
	FPR2(   8000593299177483, -54), FPR2(   8070146537076992, -53),
	FPR2(  -8070146537076992, -53), FPR2(   8000593299177483, -54),
	FPR2(   6784103575026380, -53), FPR2(   5924995957629083, -53),
	FPR2(  -5924995957629083, -53), FPR2(   6784103575026380, -53),
	FPR2(   4859846576245171, -56), FPR2(   8986690462315460, -53),
	FPR2(  -8986690462315460, -53), FPR2(   4859846576245171, -56),
	FPR2(   8978559056886080, -53), FPR2(   5741724767297686, -56),
	FPR2(  -5741724767297686, -56), FPR2(   8978559056886080, -53),
	FPR2(   5841298429575172, -53), FPR2(   6856301559240908, -53),
	FPR2(  -6856301559240908, -53), FPR2(   5841298429575172, -53),
	FPR2(   8020449076395251, -53), FPR2(   8198057093618523, -54),
	FPR2(  -8198057093618523, -54), FPR2(   8020449076395251, -53),
	FPR2(   5545726096708791, -54), FPR2(   8569764811806532, -53),
	FPR2(  -8569764811806532, -53), FPR2(   5545726096708791, -54),
	FPR2(   8666019195502468, -53), FPR2(   4911109739270519, -54),
	FPR2(  -4911109739270519, -54), FPR2(   8666019195502468, -53),
	FPR2(   8782922878275687, -54), FPR2(   7864140438927325, -53),
	FPR2(  -7864140438927325, -53), FPR2(   8782922878275687, -54),
	FPR2(   7066657597201826, -53), FPR2(   5584978855691076, -53),
	FPR2(  -5584978855691076, -53), FPR2(   7066657597201826, -53),
	FPR2(   8381640685297609, -56), FPR2(   8946057928947489, -53),
	FPR2(  -8946057928947489, -53), FPR2(   8381640685297609, -56),
	FPR2(   8864976410656110, -53), FPR2(   6377249128729266, -55),
	FPR2(  -6377249128729266, -55), FPR2(   8864976410656110, -53),
	FPR2(   5141135908973599, -53), FPR2(   7395833961093832, -53),
	FPR2(  -7395833961093832, -53), FPR2(   5141135908973599, -53),
	FPR2(   7580053365593204, -53), FPR2(   4865432086605035, -53),
	FPR2(  -4865432086605035, -53), FPR2(   7580053365593204, -53),
	FPR2(   7678108458903330, -55), FPR2(   8800287158407901, -53),
	FPR2(  -8800287158407901, -53), FPR2(   7678108458903330, -55),
	FPR2(   8383603478168160, -53), FPR2(   6586298242701558, -54),
	FPR2(  -6586298242701558, -54), FPR2(   8383603478168160, -53),
	FPR2(   7198989590052351, -54), FPR2(   8256710945357489, -53),
	FPR2(  -8256710945357489, -53), FPR2(   7198989590052351, -54),
	FPR2(   6485206053121402, -53), FPR2(   6250739225336809, -53),
	FPR2(  -6250739225336809, -53), FPR2(   6485206053121402, -53),
	FPR2(   5305378684473085, -58), FPR2(   9005673271218593, -53),
	FPR2(  -9005673271218593, -53), FPR2(   5305378684473085, -58),
	FPR2(   9005673271218593, -53), FPR2(   5305378684473085, -58),
	FPR2(  -5305378684473085, -58), FPR2(   9005673271218593, -53),
	FPR2(   6250739225336809, -53), FPR2(   6485206053121402, -53),
	FPR2(  -6485206053121402, -53), FPR2(   6250739225336809, -53),
	FPR2(   8256710945357489, -53), FPR2(   7198989590052351, -54),
	FPR2(  -7198989590052351, -54), FPR2(   8256710945357489, -53),
	FPR2(   6586298242701558, -54), FPR2(   8383603478168160, -53),
	FPR2(  -8383603478168160, -53), FPR2(   6586298242701558, -54),
	FPR2(   8800287158407901, -53), FPR2(   7678108458903330, -55),
	FPR2(  -7678108458903330, -55), FPR2(   8800287158407901, -53),
	FPR2(   4865432086605035, -53), FPR2(   7580053365593204, -53),
	FPR2(  -7580053365593204, -53), FPR2(   4865432086605035, -53),
	FPR2(   7395833961093832, -53), FPR2(   5141135908973599, -53),
	FPR2(  -5141135908973599, -53), FPR2(   7395833961093832, -53),
	FPR2(   6377249128729266, -55), FPR2(   8864976410656110, -53),
	FPR2(  -8864976410656110, -53), FPR2(   6377249128729266, -55),
	FPR2(   8946057928947489, -53), FPR2(   8381640685297609, -56),
	FPR2(  -8381640685297609, -56), FPR2(   8946057928947489, -53),
	FPR2(   5584978855691076, -53), FPR2(   7066657597201826, -53),
	FPR2(  -7066657597201826, -53), FPR2(   5584978855691076, -53),
	FPR2(   7864140438927325, -53), FPR2(   8782922878275687, -54),
	FPR2(  -8782922878275687, -54), FPR2(   7864140438927325, -53),
	FPR2(   4911109739270519, -54), FPR2(   8666019195502468, -53),
	FPR2(  -8666019195502468, -53), FPR2(   4911109739270519, -54),
	FPR2(   8569764811806532, -53), FPR2(   5545726096708791, -54),
	FPR2(  -5545726096708791, -54), FPR2(   8569764811806532, -53),
	FPR2(   8198057093618523, -54), FPR2(   8020449076395251, -53),
	FPR2(  -8020449076395251, -53), FPR2(   8198057093618523, -54),
	FPR2(   6856301559240908, -53), FPR2(   5841298429575172, -53),
	FPR2(  -5841298429575172, -53), FPR2(   6856301559240908, -53),
	FPR2(   5741724767297686, -56), FPR2(   8978559056886080, -53),
	FPR2(  -8978559056886080, -53), FPR2(   5741724767297686, -56),
	FPR2(   8986690462315460, -53), FPR2(   4859846576245171, -56),
	FPR2(  -4859846576245171, -56), FPR2(   8986690462315460, -53),
	FPR2(   5924995957629083, -53), FPR2(   6784103575026380, -53),
	FPR2(  -6784103575026380, -53), FPR2(   5924995957629083, -53),
	FPR2(   8070146537076992, -53), FPR2(   8000593299177483, -54),
	FPR2(  -8000593299177483, -54), FPR2(   8070146537076992, -53),
	FPR2(   5755636907708500, -54), FPR2(   8535092229218300, -53),
	FPR2(  -8535092229218300, -53), FPR2(   5755636907708500, -54),
	FPR2(   8695500095790524, -53), FPR2(   4698049169054608, -54),
	FPR2(  -4698049169054608, -54), FPR2(   8695500095790524, -53),
	FPR2(   8975271741297168, -54), FPR2(   7809658296434922, -53),
	FPR2(  -7809658296434922, -53), FPR2(   8975271741297168, -54),
	FPR2(   7134661772733911, -53), FPR2(   5497839557798690, -53),
	FPR2(  -5497839557798690, -53), FPR2(   7134661772733911, -53),
	FPR2(   4629632351109917, -55), FPR2(   8932527354167686, -53),
	FPR2(  -8932527354167686, -53), FPR2(   4629632351109917, -55),
	FPR2(   8883873558446555, -53), FPR2(   5941621343897074, -55),
	FPR2(  -5941621343897074, -55), FPR2(   8883873558446555, -53),
	FPR2(   5231507050503336, -53), FPR2(   7332187422259511, -53),
	FPR2(  -7332187422259511, -53), FPR2(   5231507050503336, -53),
	FPR2(   7639188937642932, -53), FPR2(   4772046813433470, -53),
	FPR2(  -4772046813433470, -53), FPR2(   7639188937642932, -53),
	FPR2(   8109502554616454, -55), FPR2(   8776068962491037, -53),
	FPR2(  -8776068962491037, -53), FPR2(   8109502554616454, -55),
	FPR2(   8423384213768154, -53), FPR2(   6380042884447767, -54),
	FPR2(  -6380042884447767, -54), FPR2(   8423384213768154, -53),
	FPR2(   7401092608336357, -54), FPR2(   8211917892022175, -53),
	FPR2(  -8211917892022175, -53), FPR2(   7401092608336357, -54),
	FPR2(   6561423914750605, -53), FPR2(   6170685101797492, -53),
	FPR2(  -6170685101797492, -53), FPR2(   6561423914750605, -53),
	FPR2(   8841410057981697, -58), FPR2(   9002960624407544, -53),
	FPR2(  -9002960624407544, -53), FPR2(   8841410057981697, -58),
	FPR2(   8998892164841951, -53), FPR2(   6188054973828419, -57),
	FPR2(  -6188054973828419, -57), FPR2(   8998892164841951, -53),
	FPR2(   6089701695779408, -53), FPR2(   6636653650073061, -53),
	FPR2(  -6636653650073061, -53), FPR2(   6089701695779408, -53),
	FPR2(   8165888154058130, -53), FPR2(   7602081049296905, -54),
	FPR2(  -7602081049296905, -54), FPR2(   8165888154058130, -53),
	FPR2(   6172826715203219, -54), FPR2(   8461896418689196, -53),
	FPR2(  -8461896418689196, -53), FPR2(   6172826715203219, -54),
	FPR2(   8750529122869341, -53), FPR2(   8539675389073947, -55),
	FPR2(  -8539675389073947, -55), FPR2(   8750529122869341, -53),
	FPR2(   4677942887564769, -53), FPR2(   7697174075937797, -53),
	FPR2(  -7697174075937797, -53), FPR2(   4677942887564769, -53),
	FPR2(   7267436682969301, -53), FPR2(   5321090346314263, -53),
	FPR2(  -5321090346314263, -53), FPR2(   7267436682969301, -53),
	FPR2(   5505098772745492, -55), FPR2(   8901432827556552, -53),
	FPR2(  -8901432827556552, -53), FPR2(   5505098772745492, -55),
	FPR2(   8917651573624763, -53), FPR2(   5067747153968079, -55),
	FPR2(  -5067747153968079, -55), FPR2(   8917651573624763, -53),
	FPR2(   5409872305491543, -53), FPR2(   7201591494446370, -53),
	FPR2(  -7201591494446370, -53), FPR2(   5409872305491543, -53),
	FPR2(   7754000048129257, -53), FPR2(   4583134480704026, -53),
	FPR2(  -4583134480704026, -53), FPR2(   7754000048129257, -53),
	FPR2(   8968562179829241, -55), FPR2(   8723671485748716, -53),
	FPR2(  -8723671485748716, -53), FPR2(   8968562179829241, -55),
	FPR2(   8499134293134885, -53), FPR2(   5964680940960804, -54),
	FPR2(  -5964680940960804, -54), FPR2(   8499134293134885, -53),
	FPR2(   7801924644814081, -54), FPR2(   8118628663374582, -53),
	FPR2(  -8118628663374582, -53), FPR2(   7801924644814081, -54),
	FPR2(   6710883929767346, -53), FPR2(   6007801203085623, -53),
	FPR2(  -6007801203085623, -53), FPR2(   6710883929767346, -53),
	FPR2(   7954473020348387, -57), FPR2(   8993468505216860, -53),
	FPR2(  -8993468505216860, -53), FPR2(   7954473020348387, -57),
	FPR2(   8969075513488470, -53), FPR2(   6622738275719969, -56),
	FPR2(  -6622738275719969, -56), FPR2(   8969075513488470, -53),
	FPR2(   5756721223463751, -53), FPR2(   6927467009660074, -53),
	FPR2(  -6927467009660074, -53), FPR2(   5756721223463751, -53),
	FPR2(   7969543765584135, -53), FPR2(   8394286290816088, -54),
	FPR2(  -8394286290816088, -54), FPR2(   7969543765584135, -53),
	FPR2(   5334980119757703, -54), FPR2(   8603146819336178, -53),
	FPR2(  -8603146819336178, -53), FPR2(   5334980119757703, -54),
	FPR2(   8635233224599694, -53), FPR2(   5123430714424177, -54),
	FPR2(  -5123430714424177, -54), FPR2(   8635233224599694, -53),
	FPR2(   8589251339374868, -54), FPR2(   7917438270796208, -53),
	FPR2(  -7917438270796208, -53), FPR2(   8589251339374868, -54),
	FPR2(   6997589209028812, -53), FPR2(   5671277076310961, -53),
	FPR2(  -5671277076310961, -53), FPR2(   6997589209028812, -53),
	FPR2(   7502754424118275, -56), FPR2(   8958241260309380, -53),
	FPR2(  -8958241260309380, -53), FPR2(   7502754424118275, -56),
	FPR2(   8844744230026167, -53), FPR2(   6811916523300038, -55),
	FPR2(  -6811916523300038, -55), FPR2(   8844744230026167, -53),
	FPR2(   5049990531286555, -53), FPR2(   7458366714537629, -53),
	FPR2(  -7458366714537629, -53), FPR2(   5049990531286555, -53),
	FPR2(   7519776265388244, -53), FPR2(   4958084643600824, -53),
	FPR2(  -4958084643600824, -53), FPR2(   7519776265388244, -53),
	FPR2(   7245558068298598, -55), FPR2(   8823180063448708, -53),
	FPR2(  -8823180063448708, -53), FPR2(   7245558068298598, -55),
	FPR2(   8342560202721672, -53), FPR2(   6791561728666308, -54),
	FPR2(  -6791561728666308, -54), FPR2(   8342560202721672, -53),
	FPR2(   6995802430416048, -54), FPR2(   8300260568395001, -53),
	FPR2(  -8300260568395001, -53), FPR2(   6995802430416048, -54),
	FPR2(   6408011543315061, -53), FPR2(   6329852010540816, -53),
	FPR2(  -6329852010540816, -53), FPR2(   6408011543315061, -53),
	FPR2(   7074193361797233, -60), FPR2(   9007029696760466, -53),
	FPR2(  -9007029696760466, -53), FPR2(   7074193361797233, -60),
	FPR2(   9007156865146114, -53), FPR2(   7074226654454970, -61),
	FPR2(  -7074226654454970, -61), FPR2(   9007156865146114, -53),
	FPR2(   6349481723403377, -53), FPR2(   6388561673708188, -53),
	FPR2(  -6388561673708188, -53), FPR2(   6349481723403377, -53),
	FPR2(   8310952915477583, -53), FPR2(   6944839825747268, -54),
	FPR2(  -6944839825747268, -54), FPR2(   8310952915477583, -53),
	FPR2(   6842718994272319, -54), FPR2(   8332102832176454, -53),
	FPR2(  -8332102832176454, -53), FPR2(   6842718994272319, -54),
	FPR2(   8828695804602461, -53), FPR2(   7137247429536506, -55),
	FPR2(  -7137247429536506, -55), FPR2(   8828695804602461, -53),
	FPR2(   4981131658359743, -53), FPR2(   7504529686575502, -53),
	FPR2(  -7504529686575502, -53), FPR2(   4981131658359743, -53),
	FPR2(   7473824766646994, -53), FPR2(   5027084818466930, -53),
	FPR2(  -5027084818466930, -53), FPR2(   7473824766646994, -53),
	FPR2(   6920425636632580, -55), FPR2(   8839477938633966, -53),
	FPR2(  -8839477938633966, -53), FPR2(   6920425636632580, -55),
	FPR2(   8961076366892190, -53), FPR2(   7282851139856476, -56),
	FPR2(  -7282851139856476, -56), FPR2(   8961076366892190, -53),
	FPR2(   5692718687339392, -53), FPR2(   6980157044180565, -53),
	FPR2(  -6980157044180565, -53), FPR2(   5692718687339392, -53),
	FPR2(   7930576735691761, -53), FPR2(   8540630200145957, -54),
	FPR2(  -8540630200145957, -54), FPR2(   7930576735691761, -53),
	FPR2(   5176391646926010, -54), FPR2(   8627333353592832, -53),
	FPR2(  -8627333353592832, -53), FPR2(   5176391646926010, -54),
	FPR2(   8611290075458352, -53), FPR2(   5282166847391008, -54),
	FPR2(  -5282166847391008, -54), FPR2(   8611290075458352, -53),
	FPR2(   8443147217093086, -54), FPR2(   7956629605695492, -53),
	FPR2(  -7956629605695492, -53), FPR2(   8443147217093086, -54),
	FPR2(   6945095779491208, -53), FPR2(   5735440961974946, -53),
	FPR2(  -5735440961974946, -53), FPR2(   6945095779491208, -53),
	FPR2(   6842840994885793, -56), FPR2(   8966493518975884, -53),
	FPR2(  -8966493518975884, -53), FPR2(   6842840994885793, -56),
	FPR2(   8994951428947667, -53), FPR2(   7512970424714007, -57),
	FPR2(  -7512970424714007, -57), FPR2(   8994951428947667, -53),
	FPR2(   6028361630966943, -53), FPR2(   6692420672738099, -53),
	FPR2(  -6692420672738099, -53), FPR2(   6028361630966943, -53),
	FPR2(   8130558439301216, -53), FPR2(   7752072724043411, -54),
	FPR2(  -7752072724043411, -54), FPR2(   8130558439301216, -53),
	FPR2(   6016802823104436, -54), FPR2(   8489944602974586, -53),
	FPR2(  -8489944602974586, -53), FPR2(   6016802823104436, -54),
	FPR2(   8730509220737932, -53), FPR2(   8861464584337410, -55),
	FPR2(  -8861464584337410, -55), FPR2(   8730509220737932, -53),
	FPR2(   4606901848488119, -53), FPR2(   7739902697902825, -53),
	FPR2(  -7739902697902825, -53), FPR2(   4606901848488119, -53),
	FPR2(   7218154856711858, -53), FPR2(   5387752674272799, -53),
	FPR2(  -5387752674272799, -53), FPR2(   7218154856711858, -53),
	FPR2(   5177159182005257, -55), FPR2(   8913722698169820, -53),
	FPR2(  -8913722698169820, -53), FPR2(   5177159182005257, -55),
	FPR2(   8905613286971281, -53), FPR2(   5395836020528807, -55),
	FPR2(  -5395836020528807, -55), FPR2(   8905613286971281, -53),
	FPR2(   5343361485770773, -53), FPR2(   7251077605914050, -53),
	FPR2(  -7251077605914050, -53), FPR2(   5343361485770773, -53),
	FPR2(   7711489578089543, -53), FPR2(   4654306275012748, -53),
	FPR2(  -4654306275012748, -53), FPR2(   7711489578089543, -53),
	FPR2(   8647020179743560, -55), FPR2(   8743938102497119, -53),
	FPR2(  -8743938102497119, -53), FPR2(   8647020179743560, -55),
	FPR2(   8471325578127065, -53), FPR2(   6120876200014774, -54),
	FPR2(  -6120876200014774, -54), FPR2(   8471325578127065, -53),
	FPR2(   7652150456031602, -54), FPR2(   8154188295849595, -53),
	FPR2(  -8154188295849595, -53), FPR2(   7652150456031602, -54),
	FPR2(   6655305358219218, -53), FPR2(   6069312070034399, -53),
	FPR2(  -6069312070034399, -53), FPR2(   6655305358219218, -53),
	FPR2(   6629757244884614, -57), FPR2(   8997663271522660, -53),
	FPR2(  -8997663271522660, -53), FPR2(   6629757244884614, -57),
	FPR2(   9003765913003641, -53), FPR2(   7957506242722589, -58),
	FPR2(  -7957506242722589, -58), FPR2(   9003765913003641, -53),
	FPR2(   6190786226252304, -53), FPR2(   6542461640350018, -53),
	FPR2(  -6542461640350018, -53), FPR2(   6190786226252304, -53),
	FPR2(   8223232361233372, -53), FPR2(   7350670159317696, -54),
	FPR2(  -7350670159317696, -54), FPR2(   8223232361233372, -53),
	FPR2(   6431698015882422, -54), FPR2(   8413557723860353, -53),
	FPR2(  -8413557723860353, -53), FPR2(   6431698015882422, -54),
	FPR2(   8782247561441008, -53), FPR2(   8001765989250269, -55),
	FPR2(  -8001765989250269, -55), FPR2(   8782247561441008, -53),
	FPR2(   4795461056637271, -53), FPR2(   7624512552870645, -53),
	FPR2(  -7624512552870645, -53), FPR2(   4795461056637271, -53),
	FPR2(   7348202953025374, -53), FPR2(   5208987596045498, -53),
	FPR2(  -5208987596045498, -53), FPR2(   7348202953025374, -53),
	FPR2(   6050614741355486, -55), FPR2(   8879274589899640, -53),
	FPR2(  -8879274589899640, -53), FPR2(   6050614741355486, -55),
	FPR2(   8936036193963400, -53), FPR2(   4519992132352091, -55),
	FPR2(  -4519992132352091, -55), FPR2(   8936036193963400, -53),
	FPR2(   5519702517755945, -53), FPR2(   7117761061603948, -53),
	FPR2(  -7117761061603948, -53), FPR2(   5519702517755945, -53),
	FPR2(   7823389415514919, -53), FPR2(   8927310113985246, -54),
	FPR2(  -8927310113985246, -54), FPR2(   7823389415514919, -53),
	FPR2(   4751381895793102, -54), FPR2(   8688252467250769, -53),
	FPR2(  -8688252467250769, -53), FPR2(   4751381895793102, -54),
	FPR2(   8543881084037075, -53), FPR2(   5703239232730864, -54),
	FPR2(  -5703239232730864, -54), FPR2(   8543881084037075, -53),
	FPR2(   8050073368155017, -54), FPR2(   8057835820270665, -53),
	FPR2(  -8057835820270665, -53), FPR2(   8050073368155017, -54),
	FPR2(   6802249279161855, -53), FPR2(   5904154737026182, -53),
	FPR2(  -5904154737026182, -53), FPR2(   6802249279161855, -53),
	FPR2(   5080389927126093, -56), FPR2(   8984784444342543, -53),
	FPR2(  -8984784444342543, -53), FPR2(   5080389927126093, -56),
	FPR2(   8980718722493792, -53), FPR2(   5521331097805465, -56),
	FPR2(  -5521331097805465, -56), FPR2(   8980718722493792, -53),
	FPR2(   5862305776050047, -53), FPR2(   6838348441158650, -53),
	FPR2(  -6838348441158650, -53), FPR2(   5862305776050047, -53),
	FPR2(   8032986972986387, -53), FPR2(   8148805730028833, -54),
	FPR2(  -8148805730028833, -54), FPR2(   8032986972986387, -53),
	FPR2(   5598283333288561, -54), FPR2(   8561217456919463, -53),
	FPR2(  -8561217456919463, -53), FPR2(   5598283333288561, -54),
	FPR2(   8673511947735049, -53), FPR2(   4857912682255224, -54),
	FPR2(  -4857912682255224, -54), FPR2(   8673511947735049, -53),
	FPR2(   8831135229857187, -54), FPR2(   7850630614963393, -53),
	FPR2(  -7850630614963393, -53), FPR2(   8831135229857187, -54),
	FPR2(   7083758813816853, -53), FPR2(   5563272371750168, -53),
	FPR2(  -5563272371750168, -53), FPR2(   7083758813816853, -53),
	FPR2(   8601170191100479, -56), FPR2(   8942801513192182, -53),
	FPR2(  -8942801513192182, -53), FPR2(   8601170191100479, -56),
	FPR2(   8869825971537420, -53), FPR2(   6268429658850061, -55),
	FPR2(  -6268429658850061, -55), FPR2(   8869825971537420, -53),
	FPR2(   5163801812627728, -53), FPR2(   7380026372209606, -53),
	FPR2(  -7380026372209606, -53), FPR2(   5163801812627728, -53),
	FPR2(   7594944627693494, -53), FPR2(   4842153912968527, -53),
	FPR2(  -4842153912968527, -53), FPR2(   7594944627693494, -53),
	FPR2(   7786067926277549, -55), FPR2(   8794356716387429, -53),
	FPR2(  -8794356716387429, -53), FPR2(   7786067926277549, -55),
	FPR2(   8393667262452058, -53), FPR2(   6534826180350098, -54),
	FPR2(  -6534826180350098, -54), FPR2(   8393667262452058, -53),
	FPR2(   7249618174605810, -54), FPR2(   8245628993303844, -53),
	FPR2(  -8245628993303844, -53), FPR2(   7249618174605810, -54),
	FPR2(   6504352530186687, -53), FPR2(   6230813476397823, -53),
	FPR2(  -6230813476397823, -53), FPR2(   6504352530186687, -53),
	FPR2(   6189482235310630, -58), FPR2(   9005122242792311, -53),
	FPR2(  -9005122242792311, -53), FPR2(   6189482235310630, -58),
	FPR2(   9006139534818257, -53), FPR2(   8842450394781643, -59),
	FPR2(  -8842450394781643, -59), FPR2(   9006139534818257, -53),
	FPR2(   6270606139937627, -53), FPR2(   6465998534826869, -53),
	FPR2(  -6465998534826869, -53), FPR2(   6270606139937627, -53),
	FPR2(   8267715182103167, -53), FPR2(   7148293245867151, -54),
	FPR2(  -7148293245867151, -54), FPR2(   8267715182103167, -53),
	FPR2(   6637708312305582, -54), FPR2(   8373460784215450, -53),
	FPR2(  -8373460784215450, -53), FPR2(   6637708312305582, -54),
	FPR2(   8806134768774068, -53), FPR2(   7570076722248107, -55),
	FPR2(  -7570076722248107, -55), FPR2(   8806134768774068, -53),
	FPR2(   4888664464941756, -53), FPR2(   7565090757143791, -53),
	FPR2(  -7565090757143791, -53), FPR2(   4888664464941756, -53),
	FPR2(   7411571937572131, -53), FPR2(   5118421614990306, -53),
	FPR2(  -5118421614990306, -53), FPR2(   7411571937572131, -53),
	FPR2(   6486008573510911, -55), FPR2(   8860043409240618, -53),
	FPR2(  -8860043409240618, -53), FPR2(   6486008573510911, -55),
	FPR2(   8949230140998484, -53), FPR2(   8162032288300481, -56),
	FPR2(  -8162032288300481, -56), FPR2(   8949230140998484, -53),
	FPR2(   5606632771683968, -53), FPR2(   7049489866514174, -53),
	FPR2(  -7049489866514174, -53), FPR2(   5606632771683968, -53),
	FPR2(   7877576242606407, -53), FPR2(   8734627858479102, -54),
	FPR2(  -8734627858479102, -54), FPR2(   7877576242606407, -53),
	FPR2(   4964260571050563, -54), FPR2(   8658444875396786, -53),
	FPR2(  -8658444875396786, -53), FPR2(   4964260571050563, -54),
	FPR2(   8578231504803418, -53), FPR2(   5493116661642923, -54),
	FPR2(  -5493116661642923, -54), FPR2(   8578231504803418, -53),
	FPR2(   8247231293972637, -54), FPR2(   8007835688282839, -53),
	FPR2(  -8007835688282839, -53), FPR2(   8247231293972637, -54),
	FPR2(   6874190143201685, -53), FPR2(   5820236102574833, -53),
	FPR2(  -5820236102574833, -53), FPR2(   6874190143201685, -53),
	FPR2(   5962064393489674, -56), FPR2(   8976314881661062, -53),
	FPR2(  -8976314881661062, -53), FPR2(   5962064393489674, -56),
	FPR2(   8988511894135185, -53), FPR2(   4639257482637412, -56),
	FPR2(  -4639257482637412, -56), FPR2(   8988511894135185, -53),
	FPR2(   5945781409913510, -53), FPR2(   6765894016324346, -53),
	FPR2(  -6765894016324346, -53), FPR2(   5945781409913510, -53),
	FPR2(   8082381294590617, -53), FPR2(   7951037925568809, -54),
	FPR2(  -7951037925568809, -54), FPR2(   8082381294590617, -53),
	FPR2(   5807980408439539, -54), FPR2(   8526223038860894, -53),
	FPR2(  -8526223038860894, -53), FPR2(   5807980408439539, -54),
	FPR2(   8702665878971716, -53), FPR2(   4644672222488094, -54),
	FPR2(  -4644672222488094, -54), FPR2(   8702665878971716, -53),
	FPR2(   4511574444966625, -53), FPR2(   7795853669876749, -53),
	FPR2(  -7795853669876749, -53), FPR2(   4511574444966625, -53),
	FPR2(   7151495329710049, -53), FPR2(   5475924850081677, -53),
	FPR2(  -5475924850081677, -53), FPR2(   7151495329710049, -53),
	FPR2(   4739228994004870, -55), FPR2(   8928934438022583, -53),
	FPR2(  -8928934438022583, -53), FPR2(   4739228994004870, -55),
	FPR2(   8888388908592136, -53), FPR2(   5832572021635720, -55),
	FPR2(  -5832572021635720, -55), FPR2(   8888388908592136, -53),
	FPR2(   5253977264024408, -53), FPR2(   7316102878153182, -53),
	FPR2(  -7316102878153182, -53), FPR2(   5253977264024408, -53),
	FPR2(   7653793419459571, -53), FPR2(   4748587653907638, -53),
	FPR2(  -4748587653907638, -53), FPR2(   7653793419459571, -53),
	FPR2(   8217162790256110, -55), FPR2(   8769807759837646, -53),
	FPR2(  -8769807759837646, -53), FPR2(   8217162790256110, -55),
	FPR2(   8433131419575708, -53), FPR2(   6328327701619659, -54),
	FPR2(  -6328327701619659, -54), FPR2(   8433131419575708, -53),
	FPR2(   7451445395452699, -54), FPR2(   8200526129112289, -53),
	FPR2(  -8200526129112289, -53), FPR2(   7451445395452699, -54),
	FPR2(   6580324430530404, -53), FPR2(   6150525896504412, -53),
	FPR2(  -6150525896504412, -53), FPR2(   6580324430530404, -53),
	FPR2(   4862615327261055, -57), FPR2(   9002070596517294, -53),
	FPR2(  -9002070596517294, -53), FPR2(   4862615327261055, -57),
	FPR2(   9000036357160980, -53), FPR2(   5746294458442105, -57),
	FPR2(  -5746294458442105, -57), FPR2(   9000036357160980, -53),
	FPR2(   6110034002932808, -53), FPR2(   6617939475215195, -53),
	FPR2(  -6617939475215195, -53), FPR2(   6110034002932808, -53),
	FPR2(   8177511151817401, -53), FPR2(   7551940088880137, -54),
	FPR2(  -7551940088880137, -54), FPR2(   8177511151817401, -53),
	FPR2(   6224719129395714, -54), FPR2(   8452387612659540, -53),
	FPR2(  -8452387612659540, -53), FPR2(   6224719129395714, -54),
	FPR2(   8757037779928840, -53), FPR2(   8432250219727258, -55),
	FPR2(  -8432250219727258, -55), FPR2(   8757037779928840, -53),
	FPR2(   4701535469536748, -53), FPR2(   7682786125052197, -53),
	FPR2(  -7682786125052197, -53), FPR2(   4701535469536748, -53),
	FPR2(   7283727356142706, -53), FPR2(   5298769122728888, -53),
	FPR2(  -5298769122728888, -53), FPR2(   7283727356142706, -53),
	FPR2(   5614309708875923, -55), FPR2(   8897168584465961, -53),
	FPR2(  -8897168584465961, -53), FPR2(   5614309708875923, -55),
	FPR2(   8921496512746829, -53), FPR2(   4958287426364647, -55),
	FPR2(  -4958287426364647, -55), FPR2(   8921496512746829, -53),
	FPR2(   5431941016931809, -53), FPR2(   7184960348059028, -53),
	FPR2(  -7184960348059028, -53), FPR2(   5431941016931809, -53),
	FPR2(   7768024414754142, -53), FPR2(   4559323974712726, -53),
	FPR2(  -4559323974712726, -53), FPR2(   7768024414754142, -53),
	FPR2(   4537787679899090, -54), FPR2(   8716751640241088, -53),
	FPR2(  -8716751640241088, -53), FPR2(   4537787679899090, -54),
	FPR2(   8508243986206341, -53), FPR2(   5912502916968520, -54),
	FPR2(  -5912502916968520, -54), FPR2(   8508243986206341, -53),
	FPR2(   7851703130898649, -54), FPR2(   8106622471823008, -53),
	FPR2(  -8106622471823008, -53), FPR2(   7851703130898649, -54),
	FPR2(   6729284021401222, -53), FPR2(   5987184227491324, -53),
	FPR2(  -5987184227491324, -53), FPR2(   6729284021401222, -53),
	FPR2(   8395900745453257, -57), FPR2(   8991900931535341, -53),
	FPR2(  -8991900931535341, -53), FPR2(   8395900745453257, -57),
	FPR2(   8971573087646471, -53), FPR2(   6402573220819241, -56),
	FPR2(  -6402573220819241, -56), FPR2(   8971573087646471, -53),
	FPR2(   5777947300499967, -53), FPR2(   6909773035871137, -53),
	FPR2(  -6909773035871137, -53), FPR2(   5777947300499967, -53),
	FPR2(   7982382913091674, -53), FPR2(   8345346354319577, -54),
	FPR2(  -8345346354319577, -54), FPR2(   7982382913091674, -53),
	FPR2(   5387743177259695, -54), FPR2(   8594922587119653, -53),
	FPR2(  -8594922587119653, -53), FPR2(   5387743177259695, -54),
	FPR2(   8643051817502737, -53), FPR2(   5070421558241214, -54),
	FPR2(  -5070421558241214, -54), FPR2(   8643051817502737, -53),
	FPR2(   8637791633298976, -54), FPR2(   7904225283956311, -53),
	FPR2(  -7904225283956311, -53), FPR2(   8637791633298976, -54),
	FPR2(   7014955509902409, -53), FPR2(   5649782085062796, -53),
	FPR2(  -5649782085062796, -53), FPR2(   7014955509902409, -53),
	FPR2(   7722587089598028, -56), FPR2(   8955321835348103, -53),
	FPR2(  -8955321835348103, -53), FPR2(   7722587089598028, -56),
	FPR2(   8849927271317175, -53), FPR2(   6703343293614876, -55),
	FPR2(  -6703343293614876, -55), FPR2(   8849927271317175, -53),
	FPR2(   5072848711672022, -53), FPR2(   7442838461440245, -53),
	FPR2(  -7442838461440245, -53), FPR2(   5072848711672022, -53),
	FPR2(   7534952065202888, -53), FPR2(   4934990961460965, -53),
	FPR2(  -4934990961460965, -53), FPR2(   7534952065202888, -53),
	FPR2(   7353800509108698, -55), FPR2(   8817581275163911, -53),
	FPR2(  -8817581275163911, -53), FPR2(   7353800509108698, -55),
	FPR2(   8352939049913017, -53), FPR2(   6740340538294756, -54),
	FPR2(  -6740340538294756, -54), FPR2(   8352939049913017, -53),
	FPR2(   7046699187928017, -54), FPR2(   8289490096098815, -53),
	FPR2(  -8289490096098815, -53), FPR2(   7046699187928017, -54),
	FPR2(   6427401098276813, -53), FPR2(   6310162718700422, -53),
	FPR2(  -6310162718700422, -53), FPR2(   6427401098276813, -53),
	FPR2(   5305603405682435, -59), FPR2(   9006817750781007, -53),
	FPR2(  -9006817750781007, -53), FPR2(   5305603405682435, -59),
	FPR2(   9006817750781007, -53), FPR2(   5305603405682435, -59),
	FPR2(  -5305603405682435, -59), FPR2(   9006817750781007, -53),
	FPR2(   6310162718700422, -53), FPR2(   6427401098276813, -53),
	FPR2(  -6427401098276813, -53), FPR2(   6310162718700422, -53),
	FPR2(   8289490096098815, -53), FPR2(   7046699187928017, -54),
	FPR2(  -7046699187928017, -54), FPR2(   8289490096098815, -53),
	FPR2(   6740340538294756, -54), FPR2(   8352939049913017, -53),
	FPR2(  -8352939049913017, -53), FPR2(   6740340538294756, -54),
	FPR2(   8817581275163911, -53), FPR2(   7353800509108698, -55),
	FPR2(  -7353800509108698, -55), FPR2(   8817581275163911, -53),
	FPR2(   4934990961460965, -53), FPR2(   7534952065202888, -53),
	FPR2(  -7534952065202888, -53), FPR2(   4934990961460965, -53),
	FPR2(   7442838461440245, -53), FPR2(   5072848711672022, -53),
	FPR2(  -5072848711672022, -53), FPR2(   7442838461440245, -53),
	FPR2(   6703343293614876, -55), FPR2(   8849927271317175, -53),
	FPR2(  -8849927271317175, -53), FPR2(   6703343293614876, -55),
	FPR2(   8955321835348103, -53), FPR2(   7722587089598028, -56),
	FPR2(  -7722587089598028, -56), FPR2(   8955321835348103, -53),
	FPR2(   5649782085062796, -53), FPR2(   7014955509902409, -53),
	FPR2(  -7014955509902409, -53), FPR2(   5649782085062796, -53),
	FPR2(   7904225283956311, -53), FPR2(   8637791633298976, -54),
	FPR2(  -8637791633298976, -54), FPR2(   7904225283956311, -53),
	FPR2(   5070421558241214, -54), FPR2(   8643051817502737, -53),
	FPR2(  -8643051817502737, -53), FPR2(   5070421558241214, -54),
	FPR2(   8594922587119653, -53), FPR2(   5387743177259695, -54),
	FPR2(  -5387743177259695, -54), FPR2(   8594922587119653, -53),
	FPR2(   8345346354319577, -54), FPR2(   7982382913091674, -53),
	FPR2(  -7982382913091674, -53), FPR2(   8345346354319577, -54),
	FPR2(   6909773035871137, -53), FPR2(   5777947300499967, -53),
	FPR2(  -5777947300499967, -53), FPR2(   6909773035871137, -53),
	FPR2(   6402573220819241, -56), FPR2(   8971573087646471, -53),
	FPR2(  -8971573087646471, -53), FPR2(   6402573220819241, -56),
	FPR2(   8991900931535341, -53), FPR2(   8395900745453257, -57),
	FPR2(  -8395900745453257, -57), FPR2(   8991900931535341, -53),
	FPR2(   5987184227491324, -53), FPR2(   6729284021401222, -53),
	FPR2(  -6729284021401222, -53), FPR2(   5987184227491324, -53),
	FPR2(   8106622471823008, -53), FPR2(   7851703130898649, -54),
	FPR2(  -7851703130898649, -54), FPR2(   8106622471823008, -53),
	FPR2(   5912502916968520, -54), FPR2(   8508243986206341, -53),
	FPR2(  -8508243986206341, -53), FPR2(   5912502916968520, -54),
	FPR2(   8716751640241088, -53), FPR2(   4537787679899090, -54),
	FPR2(  -4537787679899090, -54), FPR2(   8716751640241088, -53),
	FPR2(   4559323974712726, -53), FPR2(   7768024414754142, -53),
	FPR2(  -7768024414754142, -53), FPR2(   4559323974712726, -53),
	FPR2(   7184960348059028, -53), FPR2(   5431941016931809, -53),
	FPR2(  -5431941016931809, -53), FPR2(   7184960348059028, -53),
	FPR2(   4958287426364647, -55), FPR2(   8921496512746829, -53),
	FPR2(  -8921496512746829, -53), FPR2(   4958287426364647, -55),
	FPR2(   8897168584465961, -53), FPR2(   5614309708875923, -55),
	FPR2(  -5614309708875923, -55), FPR2(   8897168584465961, -53),
	FPR2(   5298769122728888, -53), FPR2(   7283727356142706, -53),
	FPR2(  -7283727356142706, -53), FPR2(   5298769122728888, -53),
	FPR2(   7682786125052197, -53), FPR2(   4701535469536748, -53),
	FPR2(  -4701535469536748, -53), FPR2(   7682786125052197, -53),
	FPR2(   8432250219727258, -55), FPR2(   8757037779928840, -53),
	FPR2(  -8757037779928840, -53), FPR2(   8432250219727258, -55),
	FPR2(   8452387612659540, -53), FPR2(   6224719129395714, -54),
	FPR2(  -6224719129395714, -54), FPR2(   8452387612659540, -53),
	FPR2(   7551940088880137, -54), FPR2(   8177511151817401, -53),
	FPR2(  -8177511151817401, -53), FPR2(   7551940088880137, -54),
	FPR2(   6617939475215195, -53), FPR2(   6110034002932808, -53),
	FPR2(  -6110034002932808, -53), FPR2(   6617939475215195, -53),
	FPR2(   5746294458442105, -57), FPR2(   9000036357160980, -53),
	FPR2(  -9000036357160980, -53), FPR2(   5746294458442105, -57),
	FPR2(   9002070596517294, -53), FPR2(   4862615327261055, -57),
	FPR2(  -4862615327261055, -57), FPR2(   9002070596517294, -53),
	FPR2(   6150525896504412, -53), FPR2(   6580324430530404, -53),
	FPR2(  -6580324430530404, -53), FPR2(   6150525896504412, -53),
	FPR2(   8200526129112289, -53), FPR2(   7451445395452699, -54),
	FPR2(  -7451445395452699, -54), FPR2(   8200526129112289, -53),
	FPR2(   6328327701619659, -54), FPR2(   8433131419575708, -53),
	FPR2(  -8433131419575708, -53), FPR2(   6328327701619659, -54),
	FPR2(   8769807759837646, -53), FPR2(   8217162790256110, -55),
	FPR2(  -8217162790256110, -55), FPR2(   8769807759837646, -53),
	FPR2(   4748587653907638, -53), FPR2(   7653793419459571, -53),
	FPR2(  -7653793419459571, -53), FPR2(   4748587653907638, -53),
	FPR2(   7316102878153182, -53), FPR2(   5253977264024408, -53),
	FPR2(  -5253977264024408, -53), FPR2(   7316102878153182, -53),
	FPR2(   5832572021635720, -55), FPR2(   8888388908592136, -53),
	FPR2(  -8888388908592136, -53), FPR2(   5832572021635720, -55),
	FPR2(   8928934438022583, -53), FPR2(   4739228994004870, -55),
	FPR2(  -4739228994004870, -55), FPR2(   8928934438022583, -53),
	FPR2(   5475924850081677, -53), FPR2(   7151495329710049, -53),
	FPR2(  -7151495329710049, -53), FPR2(   5475924850081677, -53),
	FPR2(   7795853669876749, -53), FPR2(   4511574444966625, -53),
	FPR2(  -4511574444966625, -53), FPR2(   7795853669876749, -53),
	FPR2(   4644672222488094, -54), FPR2(   8702665878971716, -53),
	FPR2(  -8702665878971716, -53), FPR2(   4644672222488094, -54),
	FPR2(   8526223038860894, -53), FPR2(   5807980408439539, -54),
	FPR2(  -5807980408439539, -54), FPR2(   8526223038860894, -53),
	FPR2(   7951037925568809, -54), FPR2(   8082381294590617, -53),
	FPR2(  -8082381294590617, -53), FPR2(   7951037925568809, -54),
	FPR2(   6765894016324346, -53), FPR2(   5945781409913510, -53),
	FPR2(  -5945781409913510, -53), FPR2(   6765894016324346, -53),
	FPR2(   4639257482637412, -56), FPR2(   8988511894135185, -53),
	FPR2(  -8988511894135185, -53), FPR2(   4639257482637412, -56),
	FPR2(   8976314881661062, -53), FPR2(   5962064393489674, -56),
	FPR2(  -5962064393489674, -56), FPR2(   8976314881661062, -53),
	FPR2(   5820236102574833, -53), FPR2(   6874190143201685, -53),
	FPR2(  -6874190143201685, -53), FPR2(   5820236102574833, -53),
	FPR2(   8007835688282839, -53), FPR2(   8247231293972637, -54),
	FPR2(  -8247231293972637, -54), FPR2(   8007835688282839, -53),
	FPR2(   5493116661642923, -54), FPR2(   8578231504803418, -53),
	FPR2(  -8578231504803418, -53), FPR2(   5493116661642923, -54),
	FPR2(   8658444875396786, -53), FPR2(   4964260571050563, -54),
	FPR2(  -4964260571050563, -54), FPR2(   8658444875396786, -53),
	FPR2(   8734627858479102, -54), FPR2(   7877576242606407, -53),
	FPR2(  -7877576242606407, -53), FPR2(   8734627858479102, -54),
	FPR2(   7049489866514174, -53), FPR2(   5606632771683968, -53),
	FPR2(  -5606632771683968, -53), FPR2(   7049489866514174, -53),
	FPR2(   8162032288300481, -56), FPR2(   8949230140998484, -53),
	FPR2(  -8949230140998484, -53), FPR2(   8162032288300481, -56),
	FPR2(   8860043409240618, -53), FPR2(   6486008573510911, -55),
	FPR2(  -6486008573510911, -55), FPR2(   8860043409240618, -53),
	FPR2(   5118421614990306, -53), FPR2(   7411571937572131, -53),
	FPR2(  -7411571937572131, -53), FPR2(   5118421614990306, -53),
	FPR2(   7565090757143791, -53), FPR2(   4888664464941756, -53),
	FPR2(  -4888664464941756, -53), FPR2(   7565090757143791, -53),
	FPR2(   7570076722248107, -55), FPR2(   8806134768774068, -53),
	FPR2(  -8806134768774068, -53), FPR2(   7570076722248107, -55),
	FPR2(   8373460784215450, -53), FPR2(   6637708312305582, -54),
	FPR2(  -6637708312305582, -54), FPR2(   8373460784215450, -53),
	FPR2(   7148293245867151, -54), FPR2(   8267715182103167, -53),
	FPR2(  -8267715182103167, -53), FPR2(   7148293245867151, -54),
	FPR2(   6465998534826869, -53), FPR2(   6270606139937627, -53),
	FPR2(  -6270606139937627, -53), FPR2(   6465998534826869, -53),
	FPR2(   8842450394781643, -59), FPR2(   9006139534818257, -53),
	FPR2(  -9006139534818257, -53), FPR2(   8842450394781643, -59),
	FPR2(   9005122242792311, -53), FPR2(   6189482235310630, -58),
	FPR2(  -6189482235310630, -58), FPR2(   9005122242792311, -53),
	FPR2(   6230813476397823, -53), FPR2(   6504352530186687, -53),
	FPR2(  -6504352530186687, -53), FPR2(   6230813476397823, -53),
	FPR2(   8245628993303844, -53), FPR2(   7249618174605810, -54),
	FPR2(  -7249618174605810, -54), FPR2(   8245628993303844, -53),
	FPR2(   6534826180350098, -54), FPR2(   8393667262452058, -53),
	FPR2(  -8393667262452058, -53), FPR2(   6534826180350098, -54),
	FPR2(   8794356716387429, -53), FPR2(   7786067926277549, -55),
	FPR2(  -7786067926277549, -55), FPR2(   8794356716387429, -53),
	FPR2(   4842153912968527, -53), FPR2(   7594944627693494, -53),
	FPR2(  -7594944627693494, -53), FPR2(   4842153912968527, -53),
	FPR2(   7380026372209606, -53), FPR2(   5163801812627728, -53),
	FPR2(  -5163801812627728, -53), FPR2(   7380026372209606, -53),
	FPR2(   6268429658850061, -55), FPR2(   8869825971537420, -53),
	FPR2(  -8869825971537420, -53), FPR2(   6268429658850061, -55),
	FPR2(   8942801513192182, -53), FPR2(   8601170191100479, -56),
	FPR2(  -8601170191100479, -56), FPR2(   8942801513192182, -53),
	FPR2(   5563272371750168, -53), FPR2(   7083758813816853, -53),
	FPR2(  -7083758813816853, -53), FPR2(   5563272371750168, -53),
	FPR2(   7850630614963393, -53), FPR2(   8831135229857187, -54),
	FPR2(  -8831135229857187, -54), FPR2(   7850630614963393, -53),
	FPR2(   4857912682255224, -54), FPR2(   8673511947735049, -53),
	FPR2(  -8673511947735049, -53), FPR2(   4857912682255224, -54),
	FPR2(   8561217456919463, -53), FPR2(   5598283333288561, -54),
	FPR2(  -5598283333288561, -54), FPR2(   8561217456919463, -53),
	FPR2(   8148805730028833, -54), FPR2(   8032986972986387, -53),
	FPR2(  -8032986972986387, -53), FPR2(   8148805730028833, -54),
	FPR2(   6838348441158650, -53), FPR2(   5862305776050047, -53),
	FPR2(  -5862305776050047, -53), FPR2(   6838348441158650, -53),
	FPR2(   5521331097805465, -56), FPR2(   8980718722493792, -53),
	FPR2(  -8980718722493792, -53), FPR2(   5521331097805465, -56),
	FPR2(   8984784444342543, -53), FPR2(   5080389927126093, -56),
	FPR2(  -5080389927126093, -56), FPR2(   8984784444342543, -53),
	FPR2(   5904154737026182, -53), FPR2(   6802249279161855, -53),
	FPR2(  -6802249279161855, -53), FPR2(   5904154737026182, -53),
	FPR2(   8057835820270665, -53), FPR2(   8050073368155017, -54),
	FPR2(  -8050073368155017, -54), FPR2(   8057835820270665, -53),
	FPR2(   5703239232730864, -54), FPR2(   8543881084037075, -53),
	FPR2(  -8543881084037075, -53), FPR2(   5703239232730864, -54),
	FPR2(   8688252467250769, -53), FPR2(   4751381895793102, -54),
	FPR2(  -4751381895793102, -54), FPR2(   8688252467250769, -53),
	FPR2(   8927310113985246, -54), FPR2(   7823389415514919, -53),
	FPR2(  -7823389415514919, -53), FPR2(   8927310113985246, -54),
	FPR2(   7117761061603948, -53), FPR2(   5519702517755945, -53),
	FPR2(  -5519702517755945, -53), FPR2(   7117761061603948, -53),
	FPR2(   4519992132352091, -55), FPR2(   8936036193963400, -53),
	FPR2(  -8936036193963400, -53), FPR2(   4519992132352091, -55),
	FPR2(   8879274589899640, -53), FPR2(   6050614741355486, -55),
	FPR2(  -6050614741355486, -55), FPR2(   8879274589899640, -53),
	FPR2(   5208987596045498, -53), FPR2(   7348202953025374, -53),
	FPR2(  -7348202953025374, -53), FPR2(   5208987596045498, -53),
	FPR2(   7624512552870645, -53), FPR2(   4795461056637271, -53),
	FPR2(  -4795461056637271, -53), FPR2(   7624512552870645, -53),
	FPR2(   8001765989250269, -55), FPR2(   8782247561441008, -53),
	FPR2(  -8782247561441008, -53), FPR2(   8001765989250269, -55),
	FPR2(   8413557723860353, -53), FPR2(   6431698015882422, -54),
	FPR2(  -6431698015882422, -54), FPR2(   8413557723860353, -53),
	FPR2(   7350670159317696, -54), FPR2(   8223232361233372, -53),
	FPR2(  -8223232361233372, -53), FPR2(   7350670159317696, -54),
	FPR2(   6542461640350018, -53), FPR2(   6190786226252304, -53),
	FPR2(  -6190786226252304, -53), FPR2(   6542461640350018, -53),
	FPR2(   7957506242722589, -58), FPR2(   9003765913003641, -53),
	FPR2(  -9003765913003641, -53), FPR2(   7957506242722589, -58),
	FPR2(   8997663271522660, -53), FPR2(   6629757244884614, -57),
	FPR2(  -6629757244884614, -57), FPR2(   8997663271522660, -53),
	FPR2(   6069312070034399, -53), FPR2(   6655305358219218, -53),
	FPR2(  -6655305358219218, -53), FPR2(   6069312070034399, -53),
	FPR2(   8154188295849595, -53), FPR2(   7652150456031602, -54),
	FPR2(  -7652150456031602, -54), FPR2(   8154188295849595, -53),
	FPR2(   6120876200014774, -54), FPR2(   8471325578127065, -53),
	FPR2(  -8471325578127065, -53), FPR2(   6120876200014774, -54),
	FPR2(   8743938102497119, -53), FPR2(   8647020179743560, -55),
	FPR2(  -8647020179743560, -55), FPR2(   8743938102497119, -53),
	FPR2(   4654306275012748, -53), FPR2(   7711489578089543, -53),
	FPR2(  -7711489578089543, -53), FPR2(   4654306275012748, -53),
	FPR2(   7251077605914050, -53), FPR2(   5343361485770773, -53),
	FPR2(  -5343361485770773, -53), FPR2(   7251077605914050, -53),
	FPR2(   5395836020528807, -55), FPR2(   8905613286971281, -53),
	FPR2(  -8905613286971281, -53), FPR2(   5395836020528807, -55),
	FPR2(   8913722698169820, -53), FPR2(   5177159182005257, -55),
	FPR2(  -5177159182005257, -55), FPR2(   8913722698169820, -53),
	FPR2(   5387752674272799, -53), FPR2(   7218154856711858, -53),
	FPR2(  -7218154856711858, -53), FPR2(   5387752674272799, -53),
	FPR2(   7739902697902825, -53), FPR2(   4606901848488119, -53),
	FPR2(  -4606901848488119, -53), FPR2(   7739902697902825, -53),
	FPR2(   8861464584337410, -55), FPR2(   8730509220737932, -53),
	FPR2(  -8730509220737932, -53), FPR2(   8861464584337410, -55),
	FPR2(   8489944602974586, -53), FPR2(   6016802823104436, -54),
	FPR2(  -6016802823104436, -54), FPR2(   8489944602974586, -53),
	FPR2(   7752072724043411, -54), FPR2(   8130558439301216, -53),
	FPR2(  -8130558439301216, -53), FPR2(   7752072724043411, -54),
	FPR2(   6692420672738099, -53), FPR2(   6028361630966943, -53),
	FPR2(  -6028361630966943, -53), FPR2(   6692420672738099, -53),
	FPR2(   7512970424714007, -57), FPR2(   8994951428947667, -53),
	FPR2(  -8994951428947667, -53), FPR2(   7512970424714007, -57),
	FPR2(   8966493518975884, -53), FPR2(   6842840994885793, -56),
	FPR2(  -6842840994885793, -56), FPR2(   8966493518975884, -53),
	FPR2(   5735440961974946, -53), FPR2(   6945095779491208, -53),
	FPR2(  -6945095779491208, -53), FPR2(   5735440961974946, -53),
	FPR2(   7956629605695492, -53), FPR2(   8443147217093086, -54),
	FPR2(  -8443147217093086, -54), FPR2(   7956629605695492, -53),
	FPR2(   5282166847391008, -54), FPR2(   8611290075458352, -53),
	FPR2(  -8611290075458352, -53), FPR2(   5282166847391008, -54),
	FPR2(   8627333353592832, -53), FPR2(   5176391646926010, -54),
	FPR2(  -5176391646926010, -54), FPR2(   8627333353592832, -53),
	FPR2(   8540630200145957, -54), FPR2(   7930576735691761, -53),
	FPR2(  -7930576735691761, -53), FPR2(   8540630200145957, -54),
	FPR2(   6980157044180565, -53), FPR2(   5692718687339392, -53),
	FPR2(  -5692718687339392, -53), FPR2(   6980157044180565, -53),
	FPR2(   7282851139856476, -56), FPR2(   8961076366892190, -53),
	FPR2(  -8961076366892190, -53), FPR2(   7282851139856476, -56),
	FPR2(   8839477938633966, -53), FPR2(   6920425636632580, -55),
	FPR2(  -6920425636632580, -55), FPR2(   8839477938633966, -53),
	FPR2(   5027084818466930, -53), FPR2(   7473824766646994, -53),
	FPR2(  -7473824766646994, -53), FPR2(   5027084818466930, -53),
	FPR2(   7504529686575502, -53), FPR2(   4981131658359743, -53),
	FPR2(  -4981131658359743, -53), FPR2(   7504529686575502, -53),
	FPR2(   7137247429536506, -55), FPR2(   8828695804602461, -53),
	FPR2(  -8828695804602461, -53), FPR2(   7137247429536506, -55),
	FPR2(   8332102832176454, -53), FPR2(   6842718994272319, -54),
	FPR2(  -6842718994272319, -54), FPR2(   8332102832176454, -53),
	FPR2(   6944839825747268, -54), FPR2(   8310952915477583, -53),
	FPR2(  -8310952915477583, -53), FPR2(   6944839825747268, -54),
	FPR2(   6388561673708188, -53), FPR2(   6349481723403377, -53),
	FPR2(  -6349481723403377, -53), FPR2(   6388561673708188, -53),
	FPR2(   7074226654454970, -61), FPR2(   9007156865146114, -53),
	FPR2(  -9007156865146114, -53), FPR2(   7074226654454970, -61)
};
const tw_fpr GM_TW[] = {
    (tw_fpr){{0, 0, 0}}, (tw_fpr){{0, 0, 0}},
    (tw_fpr){{-0, -0, -0}}, (tw_fpr){{1, 0, 0}},
    FPR_TW(0x1.6a09e6p-1, 0x1.9fcef4p-27, -0x1.b7ba68p-52),
    FPR_TW(0x1.6a09e6p-1, 0x1.9fcef4p-27, -0x1.b7ba68p-52),
    FPR_TW(-0x1.6a09e6p-1, -0x1.9fcef4p-27, 0x1.b7ba68p-52),
    FPR_TW(0x1.6a09e6p-1, 0x1.9fcef4p-27, -0x1.b7ba68p-52),
    FPR_TW(0x1.d906bcp-1, 0x1.e651a8p-26, 0x1.8a2bf4p-51),
    FPR_TW(0x1.87de2ap-2, 0x1.abaa58p-28, 0x1.68d312p-53),
    FPR_TW(-0x1.87de2ap-2, -0x1.abaa58p-28, -0x1.68d312p-53),
    FPR_TW(0x1.d906bcp-1, 0x1.e651a8p-26, 0x1.8a2bf4p-51),
    FPR_TW(0x1.87de2ap-2, 0x1.abaa58p-28, 0x1.68d312p-53),
    FPR_TW(0x1.d906bcp-1, 0x1.e651a8p-26, 0x1.8a2bf4p-51),
    FPR_TW(-0x1.d906bcp-1, -0x1.e651a8p-26, -0x1.8a2bf4p-51),
    FPR_TW(0x1.87de2ap-2, 0x1.abaa58p-28, 0x1.68d312p-53),
    FPR_TW(0x1.f6297cp-1, 0x1.feeb96p-26, 0x1.562172p-56),
    FPR_TW(0x1.8f8b84p-3, -0x1.cb2cfap-30, -0x1.49b466p-55),
    FPR_TW(-0x1.8f8b84p-3, 0x1.cb2cfap-30, 0x1.49b466p-55),
    FPR_TW(0x1.f6297cp-1, 0x1.feeb96p-26, 0x1.562172p-56),
    FPR_TW(0x1.1c73b4p-1, -0x1.9465cep-27, 0x1.b25dd2p-55),
    FPR_TW(0x1.a9b662p-1, 0x1.21d434p-26, 0x1.819f64p-52),
    FPR_TW(-0x1.a9b662p-1, -0x1.21d434p-26, -0x1.819f64p-52),
    FPR_TW(0x1.1c73b4p-1, -0x1.9465cep-27, 0x1.b25dd2p-55),
    FPR_TW(0x1.a9b662p-1, 0x1.21d434p-26, 0x1.819f64p-52),
    FPR_TW(0x1.1c73b4p-1, -0x1.9465cep-27, 0x1.b25dd2p-55),
    FPR_TW(-0x1.1c73b4p-1, 0x1.9465cep-27, -0x1.b25dd2p-55),
    FPR_TW(0x1.a9b662p-1, 0x1.21d434p-26, 0x1.819f64p-52),
    FPR_TW(0x1.8f8b84p-3, -0x1.cb2cfap-30, -0x1.49b466p-55),
    FPR_TW(0x1.f6297cp-1, 0x1.feeb96p-26, 0x1.562172p-56),
    FPR_TW(-0x1.f6297cp-1, -0x1.feeb96p-26, -0x1.562172p-56),
    FPR_TW(0x1.8f8b84p-3, -0x1.cb2cfap-30, -0x1.49b466p-55),
    FPR_TW(0x1.fd88dap-1, 0x1.e89292p-28, 0x1.9e0828p-53),
    FPR_TW(0x1.917a6cp-4, -0x1.eb25eap-31, -0x1.e2718ep-60),
    FPR_TW(-0x1.917a6cp-4, 0x1.eb25eap-31, 0x1.e2718ep-60),
    FPR_TW(0x1.fd88dap-1, 0x1.e89292p-28, 0x1.9e0828p-53),
    FPR_TW(0x1.44cf32p-1, 0x1.424776p-27, -0x1.e7f896p-53),
    FPR_TW(0x1.8bc806p-1, 0x1.62a2e8p-26, 0x1.69d0f6p-54),
    FPR_TW(-0x1.8bc806p-1, -0x1.62a2e8p-26, -0x1.69d0f6p-54),
    FPR_TW(0x1.44cf32p-1, 0x1.424776p-27, -0x1.e7f896p-53),
    FPR_TW(0x1.c38b3p-1, -0x1.cfe84ap-26, 0x1.a47d3ap-54),
    FPR_TW(0x1.e2b5d4p-2, -0x1.fe4272p-28, 0x1.8f06c4p-53),
    FPR_TW(-0x1.e2b5d4p-2, 0x1.fe4272p-28, -0x1.8f06c4p-53),
    FPR_TW(0x1.c38b3p-1, -0x1.cfe84ap-26, 0x1.a47d3ap-54),
    FPR_TW(0x1.294062p-2, 0x1.dab3ep-27, 0x1.6a2d72p-52),
    FPR_TW(0x1.e9f416p-1, -0x1.273a44p-26, -0x1.689f4ep-51),
    FPR_TW(-0x1.e9f416p-1, 0x1.273a44p-26, 0x1.689f4ep-51),
    FPR_TW(0x1.294062p-2, 0x1.dab3ep-27, 0x1.6a2d72p-52),
    FPR_TW(0x1.e9f416p-1, -0x1.273a44p-26, -0x1.689f4ep-51),
    FPR_TW(0x1.294062p-2, 0x1.dab3ep-27, 0x1.6a2d72p-52),
    FPR_TW(-0x1.294062p-2, -0x1.dab3ep-27, -0x1.6a2d72p-52),
    FPR_TW(0x1.e9f416p-1, -0x1.273a44p-26, -0x1.689f4ep-51),
    FPR_TW(0x1.e2b5d4p-2, -0x1.fe4272p-28, 0x1.8f06c4p-53),
    FPR_TW(0x1.c38b3p-1, -0x1.cfe84ap-26, 0x1.a47d3ap-54),
    FPR_TW(-0x1.c38b3p-1, 0x1.cfe84ap-26, -0x1.a47d3ap-54),
    FPR_TW(0x1.e2b5d4p-2, -0x1.fe4272p-28, 0x1.8f06c4p-53),
    FPR_TW(0x1.8bc806p-1, 0x1.62a2e8p-26, 0x1.69d0f6p-54),
    FPR_TW(0x1.44cf32p-1, 0x1.424776p-27, -0x1.e7f896p-53),
    FPR_TW(-0x1.44cf32p-1, -0x1.424776p-27, 0x1.e7f896p-53),
    FPR_TW(0x1.8bc806p-1, 0x1.62a2e8p-26, 0x1.69d0f6p-54),
    FPR_TW(0x1.917a6cp-4, -0x1.eb25eap-31, -0x1.e2718ep-60),
    FPR_TW(0x1.fd88dap-1, 0x1.e89292p-28, 0x1.9e0828p-53),
    FPR_TW(-0x1.fd88dap-1, -0x1.e89292p-28, -0x1.9e0828p-53),
    FPR_TW(0x1.917a6cp-4, -0x1.eb25eap-31, -0x1.e2718ep-60),
    FPR_TW(0x1.ff621ep-1, 0x1.bcb6bep-28, 0x1.e3a844p-53),
    FPR_TW(0x1.91f66p-5, -0x1.de44fep-30, 0x1.f376a2p-56),
    FPR_TW(-0x1.91f66p-5, 0x1.de44fep-30, -0x1.f376a2p-56),
    FPR_TW(0x1.ff621ep-1, 0x1.bcb6bep-28, 0x1.e3a844p-53),
    FPR_TW(0x1.57d694p-1, -0x1.6e626cp-26, -0x1.75720ap-55),
    FPR_TW(0x1.7b5df2p-1, 0x1.3557d8p-28, -0x1.21ea7p-53),
    FPR_TW(-0x1.7b5df2p-1, -0x1.3557d8p-28, 0x1.21ea7p-53),
    FPR_TW(0x1.57d694p-1, -0x1.6e626cp-26, -0x1.75720ap-55),
    FPR_TW(0x1.ced7bp-1, -0x1.786712p-26, 0x1.786126p-52),
    FPR_TW(0x1.b5d1p-2, 0x1.3c2b98p-27, 0x1.5b362cp-57),
    FPR_TW(-0x1.b5d1p-2, -0x1.3c2b98p-27, -0x1.5b362cp-57),
    FPR_TW(0x1.ced7bp-1, -0x1.786712p-26, 0x1.786126p-52),
    FPR_TW(0x1.58f9a8p-2, -0x1.4a9c04p-27, -0x1.80f7eep-53),
    FPR_TW(0x1.e2121p-1, 0x1.3da1bap-27, -0x1.a0298ep-52),
    FPR_TW(-0x1.e2121p-1, -0x1.3da1bap-27, 0x1.a0298ep-52),
    FPR_TW(0x1.58f9a8p-2, -0x1.4a9c04p-27, -0x1.80f7eep-53),
    FPR_TW(0x1.f0a7fp-1, -0x1.1b73cap-27, -0x1.ab4e14p-54),
    FPR_TW(0x1.f19f98p-3, -0x1.37a83ap-29, 0x1.57a422p-54),
    FPR_TW(-0x1.f19f98p-3, 0x1.37a83ap-29, -0x1.57a422p-54),
    FPR_TW(0x1.f0a7fp-1, -0x1.1b73cap-27, -0x1.ab4e14p-54),
    FPR_TW(0x1.07387ap-1, -0x1.b74004p-27, -0x1.34b402p-52),
    FPR_TW(0x1.b72834p-1, 0x1.465b9p-27, -0x1.378d3ep-52),
    FPR_TW(-0x1.b72834p-1, -0x1.465b9p-27, 0x1.378d3ep-52),
    FPR_TW(0x1.07387ap-1, -0x1.b74004p-27, -0x1.34b402p-52),
    FPR_TW(0x1.9b3e04p-1, 0x1.fce1dp-27, 0x1.6788ecp-54),
    FPR_TW(0x1.30ff8p-1, -0x1.8f47e6p-28, 0x1.c20674p-54),
    FPR_TW(-0x1.30ff8p-1, 0x1.8f47e6p-28, -0x1.c20674p-54),
    FPR_TW(0x1.9b3e04p-1, 0x1.fce1dp-27, 0x1.6788ecp-54),
    FPR_TW(0x1.2c8106p-3, 0x1.d1cc28p-28, -0x1.7768p-53),
    FPR_TW(0x1.fa7558p-1, -0x1.eeb5d2p-30, -0x1.7a0a8cp-55),
    FPR_TW(-0x1.fa7558p-1, 0x1.eeb5d2p-30, 0x1.7a0a8cp-55),
    FPR_TW(0x1.2c8106p-3, 0x1.d1cc28p-28, -0x1.7768p-53),
    FPR_TW(0x1.fa7558p-1, -0x1.eeb5d2p-30, -0x1.7a0a8cp-55),
    FPR_TW(0x1.2c8106p-3, 0x1.d1cc28p-28, -0x1.7768p-53),
    FPR_TW(-0x1.2c8106p-3, -0x1.d1cc28p-28, 0x1.7768p-53),
    FPR_TW(0x1.fa7558p-1, -0x1.eeb5d2p-30, -0x1.7a0a8cp-55),
    FPR_TW(0x1.30ff8p-1, -0x1.8f47e6p-28, 0x1.c20674p-54),
    FPR_TW(0x1.9b3e04p-1, 0x1.fce1dp-27, 0x1.6788ecp-54),
    FPR_TW(-0x1.9b3e04p-1, -0x1.fce1dp-27, -0x1.6788ecp-54),
    FPR_TW(0x1.30ff8p-1, -0x1.8f47e6p-28, 0x1.c20674p-54),
    FPR_TW(0x1.b72834p-1, 0x1.465b9p-27, -0x1.378d3ep-52),
    FPR_TW(0x1.07387ap-1, -0x1.b74004p-27, -0x1.34b402p-52),
    FPR_TW(-0x1.07387ap-1, 0x1.b74004p-27, 0x1.34b402p-52),
    FPR_TW(0x1.b72834p-1, 0x1.465b9p-27, -0x1.378d3ep-52),
    FPR_TW(0x1.f19f98p-3, -0x1.37a83ap-29, 0x1.57a422p-54),
    FPR_TW(0x1.f0a7fp-1, -0x1.1b73cap-27, -0x1.ab4e14p-54),
    FPR_TW(-0x1.f0a7fp-1, 0x1.1b73cap-27, 0x1.ab4e14p-54),
    FPR_TW(0x1.f19f98p-3, -0x1.37a83ap-29, 0x1.57a422p-54),
    FPR_TW(0x1.e2121p-1, 0x1.3da1bap-27, -0x1.a0298ep-52),
    FPR_TW(0x1.58f9a8p-2, -0x1.4a9c04p-27, -0x1.80f7eep-53),
    FPR_TW(-0x1.58f9a8p-2, 0x1.4a9c04p-27, 0x1.80f7eep-53),
    FPR_TW(0x1.e2121p-1, 0x1.3da1bap-27, -0x1.a0298ep-52),
    FPR_TW(0x1.b5d1p-2, 0x1.3c2b98p-27, 0x1.5b362cp-57),
    FPR_TW(0x1.ced7bp-1, -0x1.786712p-26, 0x1.786126p-52),
    FPR_TW(-0x1.ced7bp-1, 0x1.786712p-26, -0x1.786126p-52),
    FPR_TW(0x1.b5d1p-2, 0x1.3c2b98p-27, 0x1.5b362cp-57),
    FPR_TW(0x1.7b5df2p-1, 0x1.3557d8p-28, -0x1.21ea7p-53),
    FPR_TW(0x1.57d694p-1, -0x1.6e626cp-26, -0x1.75720ap-55),
    FPR_TW(-0x1.57d694p-1, 0x1.6e626cp-26, 0x1.75720ap-55),
    FPR_TW(0x1.7b5df2p-1, 0x1.3557d8p-28, -0x1.21ea7p-53),
    FPR_TW(0x1.91f66p-5, -0x1.de44fep-30, 0x1.f376a2p-56),
    FPR_TW(0x1.ff621ep-1, 0x1.bcb6bep-28, 0x1.e3a844p-53),
    FPR_TW(-0x1.ff621ep-1, -0x1.bcb6bep-28, -0x1.e3a844p-53),
    FPR_TW(0x1.91f66p-5, -0x1.de44fep-30, 0x1.f376a2p-56),
    FPR_TW(0x1.ffd886p-1, 0x1.099a1ap-30, -0x1.1354d4p-55),
    FPR_TW(0x1.92156p-6, -0x1.0b933p-31, -0x1.0363acp-57),
    FPR_TW(-0x1.92156p-6, 0x1.0b933p-31, 0x1.0363acp-57),
    FPR_TW(0x1.ffd886p-1, 0x1.099a1ap-30, -0x1.1354d4p-55),
    FPR_TW(0x1.610b76p-1, -0x1.5c5a64p-26, -0x1.24a366p-53),
    FPR_TW(0x1.72d084p-1, -0x1.02000ep-26, 0x1.90d4fp-51),
    FPR_TW(-0x1.72d084p-1, 0x1.02000ep-26, -0x1.90d4fp-51),
    FPR_TW(0x1.610b76p-1, -0x1.5c5a64p-26, -0x1.24a366p-53),
    FPR_TW(0x1.d4134ep-1, -0x1.d646d8p-26, -0x1.94ef52p-51),
    FPR_TW(0x1.9ef794p-2, 0x1.d476c6p-29, -0x1.d24afep-54),
    FPR_TW(-0x1.9ef794p-2, -0x1.d476c6p-29, 0x1.d24afep-54),
    FPR_TW(0x1.d4134ep-1, -0x1.d646d8p-26, -0x1.94ef52p-51),
    FPR_TW(0x1.708854p-2, -0x1.e0b74cp-27, -0x1.512c68p-54),
    FPR_TW(0x1.ddb13cp-1, -0x1.2667b8p-26, -0x1.cf879p-52),
    FPR_TW(-0x1.ddb13cp-1, 0x1.2667b8p-26, 0x1.cf879p-52),
    FPR_TW(0x1.708854p-2, -0x1.e0b74cp-27, -0x1.512c68p-54),
    FPR_TW(0x1.f38f3ap-1, 0x1.8c9cb2p-26, -0x1.cebdd8p-51),
    FPR_TW(0x1.c0b826p-3, 0x1.4fc9ecp-28, 0x1.7e50ecp-54),
    FPR_TW(-0x1.c0b826p-3, -0x1.4fc9ecp-28, -0x1.7e50ecp-54),
    FPR_TW(0x1.f38f3ap-1, 0x1.8c9cb2p-26, -0x1.cebdd8p-51),
    FPR_TW(0x1.11eb36p-1, -0x1.7c969cp-26, 0x1.421b8ap-52),
    FPR_TW(0x1.b090a6p-1, -0x1.fabf8p-27, -0x1.926da4p-55),
    FPR_TW(-0x1.b090a6p-1, 0x1.fabf8p-27, 0x1.926da4p-55),
    FPR_TW(0x1.11eb36p-1, -0x1.7c969cp-26, 0x1.421b8ap-52),
    FPR_TW(0x1.a29a7ap-1, 0x1.189e08p-31, -0x1.128bbp-56),
    FPR_TW(0x1.26d054p-1, 0x1.9ba25cp-26, -0x1.5769dp-53),
    FPR_TW(-0x1.26d054p-1, -0x1.9ba25cp-26, 0x1.5769dp-53),
    FPR_TW(0x1.a29a7ap-1, 0x1.189e08p-31, -0x1.128bbp-56),
    FPR_TW(0x1.5e2144p-3, 0x1.22cff2p-29, -0x1.ab3802p-55),
    FPR_TW(0x1.f8765p-1, -0x1.63ad16p-27, 0x1.3564acp-53),
    FPR_TW(-0x1.f8765p-1, 0x1.63ad16p-27, -0x1.3564acp-53),
    FPR_TW(0x1.5e2144p-3, 0x1.22cff2p-29, -0x1.ab3802p-55),
    FPR_TW(0x1.fc2648p-1, -0x1.e3cc06p-26, 0x1.a3d90cp-52),
    FPR_TW(0x1.f564e6p-4, -0x1.2ad19ep-29, -0x1.cbb1f8p-56),
    FPR_TW(-0x1.f564e6p-4, 0x1.2ad19ep-29, 0x1.cbb1f8p-56),
    FPR_TW(0x1.fc2648p-1, -0x1.e3cc06p-26, 0x1.a3d90cp-52),
    FPR_TW(0x1.3affa2p-1, 0x1.240a18p-26, -0x1.b0e0eep-51),
    FPR_TW(0x1.93a224p-1, 0x1.324c8p-26, -0x1.2c2be6p-51),
    FPR_TW(-0x1.93a224p-1, -0x1.324c8p-26, 0x1.2c2be6p-51),
    FPR_TW(0x1.3affa2p-1, 0x1.240a18p-26, -0x1.b0e0eep-51),
    FPR_TW(0x1.bd7c0ap-1, 0x1.8df2a6p-26, -0x1.9825a8p-51),
    FPR_TW(0x1.f8ba4ep-2, -0x1.01d952p-28, 0x1.fb44f8p-54),
    FPR_TW(-0x1.f8ba4ep-2, 0x1.01d952p-28, -0x1.fb44f8p-54),
    FPR_TW(0x1.bd7c0ap-1, 0x1.8df2a6p-26, -0x1.9825a8p-51),
    FPR_TW(0x1.111d26p-2, 0x1.58fb3cp-29, -0x1.3ed9fp-55),
    FPR_TW(0x1.ed740ep-1, 0x1.da1258p-27, 0x1.9e82c8p-52),
    FPR_TW(-0x1.ed740ep-1, -0x1.da1258p-27, -0x1.9e82c8p-52),
    FPR_TW(0x1.111d26p-2, 0x1.58fb3cp-29, -0x1.3ed9fp-55),
    FPR_TW(0x1.e6288ep-1, 0x1.891c22p-26, 0x1.ee94aap-53),
    FPR_TW(0x1.4135cap-2, -0x1.7d134p-27, 0x1.4325f2p-54),
    FPR_TW(-0x1.4135cap-2, 0x1.7d134p-27, -0x1.4325f2p-54),
    FPR_TW(0x1.e6288ep-1, 0x1.891c22p-26, 0x1.ee94aap-53),
    FPR_TW(0x1.cc66eap-2, -0x1.b38ee8p-28, -0x1.e97af2p-54),
    FPR_TW(0x1.c954b2p-1, 0x1.3411f4p-29, 0x1.ed048ap-54),
    FPR_TW(-0x1.c954b2p-1, -0x1.3411f4p-29, -0x1.ed048ap-54),
    FPR_TW(0x1.cc66eap-2, -0x1.b38ee8p-28, -0x1.e97af2p-54),
    FPR_TW(0x1.83b0ep-1, 0x1.7ff2eep-26, -0x1.16f42p-52),
    FPR_TW(0x1.4e6cacp-1, -0x1.070686p-27, 0x1.13c294p-53),
    FPR_TW(-0x1.4e6cacp-1, 0x1.070686p-27, -0x1.13c294p-53),
    FPR_TW(0x1.83b0ep-1, 0x1.7ff2eep-26, -0x1.16f42p-52),
    FPR_TW(0x1.2d520ap-4, -0x1.a63cc2p-29, 0x1.732fbcp-54),
    FPR_TW(0x1.fe9cdap-1, 0x1.a03108p-26, -0x1.7ab784p-51),
    FPR_TW(-0x1.fe9cdap-1, -0x1.a03108p-26, 0x1.7ab784p-51),
    FPR_TW(0x1.2d520ap-4, -0x1.a63cc2p-29, 0x1.732fbcp-54),
    FPR_TW(0x1.fe9cdap-1, 0x1.a03108p-26, -0x1.7ab784p-51),
    FPR_TW(0x1.2d520ap-4, -0x1.a63cc2p-29, 0x1.732fbcp-54),
    FPR_TW(-0x1.2d520ap-4, 0x1.a63cc2p-29, -0x1.732fbcp-54),
    FPR_TW(0x1.fe9cdap-1, 0x1.a03108p-26, -0x1.7ab784p-51),
    FPR_TW(0x1.4e6cacp-1, -0x1.070686p-27, 0x1.13c294p-53),
    FPR_TW(0x1.83b0ep-1, 0x1.7ff2eep-26, -0x1.16f42p-52),
    FPR_TW(-0x1.83b0ep-1, -0x1.7ff2eep-26, 0x1.16f42p-52),
    FPR_TW(0x1.4e6cacp-1, -0x1.070686p-27, 0x1.13c294p-53),
    FPR_TW(0x1.c954b2p-1, 0x1.3411f4p-29, 0x1.ed048ap-54),
    FPR_TW(0x1.cc66eap-2, -0x1.b38ee8p-28, -0x1.e97af2p-54),
    FPR_TW(-0x1.cc66eap-2, 0x1.b38ee8p-28, 0x1.e97af2p-54),
    FPR_TW(0x1.c954b2p-1, 0x1.3411f4p-29, 0x1.ed048ap-54),
    FPR_TW(0x1.4135cap-2, -0x1.7d134p-27, 0x1.4325f2p-54),
    FPR_TW(0x1.e6288ep-1, 0x1.891c22p-26, 0x1.ee94aap-53),
    FPR_TW(-0x1.e6288ep-1, -0x1.891c22p-26, -0x1.ee94aap-53),
    FPR_TW(0x1.4135cap-2, -0x1.7d134p-27, 0x1.4325f2p-54),
    FPR_TW(0x1.ed740ep-1, 0x1.da1258p-27, 0x1.9e82c8p-52),
    FPR_TW(0x1.111d26p-2, 0x1.58fb3cp-29, -0x1.3ed9fp-55),
    FPR_TW(-0x1.111d26p-2, -0x1.58fb3cp-29, 0x1.3ed9fp-55),
    FPR_TW(0x1.ed740ep-1, 0x1.da1258p-27, 0x1.9e82c8p-52),
    FPR_TW(0x1.f8ba4ep-2, -0x1.01d952p-28, 0x1.fb44f8p-54),
    FPR_TW(0x1.bd7c0ap-1, 0x1.8df2a6p-26, -0x1.9825a8p-51),
    FPR_TW(-0x1.bd7c0ap-1, -0x1.8df2a6p-26, 0x1.9825a8p-51),
    FPR_TW(0x1.f8ba4ep-2, -0x1.01d952p-28, 0x1.fb44f8p-54),
    FPR_TW(0x1.93a224p-1, 0x1.324c8p-26, -0x1.2c2be6p-51),
    FPR_TW(0x1.3affa2p-1, 0x1.240a18p-26, -0x1.b0e0eep-51),
    FPR_TW(-0x1.3affa2p-1, -0x1.240a18p-26, 0x1.b0e0eep-51),
    FPR_TW(0x1.93a224p-1, 0x1.324c8p-26, -0x1.2c2be6p-51),
    FPR_TW(0x1.f564e6p-4, -0x1.2ad19ep-29, -0x1.cbb1f8p-56),
    FPR_TW(0x1.fc2648p-1, -0x1.e3cc06p-26, 0x1.a3d90cp-52),
    FPR_TW(-0x1.fc2648p-1, 0x1.e3cc06p-26, -0x1.a3d90cp-52),
    FPR_TW(0x1.f564e6p-4, -0x1.2ad19ep-29, -0x1.cbb1f8p-56),
    FPR_TW(0x1.f8765p-1, -0x1.63ad16p-27, 0x1.3564acp-53),
    FPR_TW(0x1.5e2144p-3, 0x1.22cff2p-29, -0x1.ab3802p-55),
    FPR_TW(-0x1.5e2144p-3, -0x1.22cff2p-29, 0x1.ab3802p-55),
    FPR_TW(0x1.f8765p-1, -0x1.63ad16p-27, 0x1.3564acp-53),
    FPR_TW(0x1.26d054p-1, 0x1.9ba25cp-26, -0x1.5769dp-53),
    FPR_TW(0x1.a29a7ap-1, 0x1.189e08p-31, -0x1.128bbp-56),
    FPR_TW(-0x1.a29a7ap-1, -0x1.189e08p-31, 0x1.128bbp-56),
    FPR_TW(0x1.26d054p-1, 0x1.9ba25cp-26, -0x1.5769dp-53),
    FPR_TW(0x1.b090a6p-1, -0x1.fabf8p-27, -0x1.926da4p-55),
    FPR_TW(0x1.11eb36p-1, -0x1.7c969cp-26, 0x1.421b8ap-52),
    FPR_TW(-0x1.11eb36p-1, 0x1.7c969cp-26, -0x1.421b8ap-52),
    FPR_TW(0x1.b090a6p-1, -0x1.fabf8p-27, -0x1.926da4p-55),
    FPR_TW(0x1.c0b826p-3, 0x1.4fc9ecp-28, 0x1.7e50ecp-54),
    FPR_TW(0x1.f38f3ap-1, 0x1.8c9cb2p-26, -0x1.cebdd8p-51),
    FPR_TW(-0x1.f38f3ap-1, -0x1.8c9cb2p-26, 0x1.cebdd8p-51),
    FPR_TW(0x1.c0b826p-3, 0x1.4fc9ecp-28, 0x1.7e50ecp-54),
    FPR_TW(0x1.ddb13cp-1, -0x1.2667b8p-26, -0x1.cf879p-52),
    FPR_TW(0x1.708854p-2, -0x1.e0b74cp-27, -0x1.512c68p-54),
    FPR_TW(-0x1.708854p-2, 0x1.e0b74cp-27, 0x1.512c68p-54),
    FPR_TW(0x1.ddb13cp-1, -0x1.2667b8p-26, -0x1.cf879p-52),
    FPR_TW(0x1.9ef794p-2, 0x1.d476c6p-29, -0x1.d24afep-54),
    FPR_TW(0x1.d4134ep-1, -0x1.d646d8p-26, -0x1.94ef52p-51),
    FPR_TW(-0x1.d4134ep-1, 0x1.d646d8p-26, 0x1.94ef52p-51),
    FPR_TW(0x1.9ef794p-2, 0x1.d476c6p-29, -0x1.d24afep-54),
    FPR_TW(0x1.72d084p-1, -0x1.02000ep-26, 0x1.90d4fp-51),
    FPR_TW(0x1.610b76p-1, -0x1.5c5a64p-26, -0x1.24a366p-53),
    FPR_TW(-0x1.610b76p-1, 0x1.5c5a64p-26, 0x1.24a366p-53),
    FPR_TW(0x1.72d084p-1, -0x1.02000ep-26, 0x1.90d4fp-51),
    FPR_TW(0x1.92156p-6, -0x1.0b933p-31, -0x1.0363acp-57),
    FPR_TW(0x1.ffd886p-1, 0x1.099a1ap-30, -0x1.1354d4p-55),
    FPR_TW(-0x1.ffd886p-1, -0x1.099a1ap-30, 0x1.1354d4p-55),
    FPR_TW(0x1.92156p-6, -0x1.0b933p-31, -0x1.0363acp-57),
    FPR_TW(0x1.fff622p-1, -0x1.2c8da4p-26, -0x1.2a225cp-51),
    FPR_TW(0x1.921d2p-7, -0x1.909c3ep-34, 0x1.9878ecp-61),
    FPR_TW(-0x1.921d2p-7, 0x1.909c3ep-34, -0x1.9878ecp-61),
    FPR_TW(0x1.fff622p-1, -0x1.2c8da4p-26, -0x1.2a225cp-51),
    FPR_TW(0x1.659192p-1, 0x1.7c1e1p-27, -0x1.478536p-52),
    FPR_TW(0x1.6e7446p-1, -0x1.62aaeap-26, -0x1.76f01p-53),
    FPR_TW(-0x1.6e7446p-1, 0x1.62aaeap-26, 0x1.76f01p-53),
    FPR_TW(0x1.659192p-1, 0x1.7c1e1p-27, -0x1.478536p-52),
    FPR_TW(0x1.d69618p-1, -0x1.86c32ep-26, -0x1.4f463p-51),
    FPR_TW(0x1.9372a6p-2, 0x1.de49ecp-29, -0x1.a5ef3ap-55),
    FPR_TW(-0x1.9372a6p-2, -0x1.de49ecp-29, 0x1.a5ef3ap-55),
    FPR_TW(0x1.d69618p-1, -0x1.86c32ep-26, -0x1.4f463p-51),
    FPR_TW(0x1.7c3a94p-2, -0x1.dc4664p-27, 0x1.c0669p-52),
    FPR_TW(0x1.db6526p-1, 0x1.1c504ep-28, -0x1.35bddp-53),
    FPR_TW(-0x1.db6526p-1, -0x1.1c504ep-28, 0x1.35bddp-53),
    FPR_TW(0x1.7c3a94p-2, -0x1.dc4664p-27, 0x1.c0669p-52),
    FPR_TW(0x1.f4e604p-1, -0x1.3d3434p-27, -0x1.98ee02p-52),
    FPR_TW(0x1.a82a02p-3, 0x1.6c0114p-29, 0x1.3c37dp-56),
    FPR_TW(-0x1.a82a02p-3, -0x1.6c0114p-29, -0x1.3c37dp-56),
    FPR_TW(0x1.f4e604p-1, -0x1.3d3434p-27, -0x1.98ee02p-52),
    FPR_TW(0x1.1734d6p-1, 0x1.ef6da4p-28, 0x1.40886ap-54),
    FPR_TW(0x1.ad2bcap-1, -0x1.de2afp-29, 0x1.5c021p-54),
    FPR_TW(-0x1.ad2bcap-1, 0x1.de2afp-29, -0x1.5c021p-54),
    FPR_TW(0x1.1734d6p-1, 0x1.ef6da4p-28, 0x1.40886ap-54),
    FPR_TW(0x1.a63092p-1, -0x1.3f4148p-27, 0x1.c2dddep-53),
    FPR_TW(0x1.21a79ap-1, -0x1.b3052ap-27, 0x1.62c274p-54),
    FPR_TW(-0x1.21a79ap-1, 0x1.b3052ap-27, -0x1.62c274p-54),
    FPR_TW(0x1.a63092p-1, -0x1.3f4148p-27, 0x1.c2dddep-53),
    FPR_TW(0x1.76dd9ep-3, -0x1.af40cep-31, -0x1.715088p-56),
    FPR_TW(0x1.f7599ap-1, 0x1.d0903cp-28, -0x1.3d8672p-54),
    FPR_TW(-0x1.f7599ap-1, -0x1.d0903cp-28, 0x1.3d8672p-54),
    FPR_TW(0x1.76dd9ep-3, -0x1.af40cep-31, -0x1.715088p-56),
    FPR_TW(0x1.fce16p-1, -0x1.492cc2p-28, -0x1.2bbaep-53),
    FPR_TW(0x1.c3785cp-4, 0x1.e7b0b6p-30, -0x1.853ce8p-55),
    FPR_TW(-0x1.c3785cp-4, -0x1.e7b0b6p-30, 0x1.853ce8p-55),
    FPR_TW(0x1.fce16p-1, -0x1.492cc2p-28, -0x1.2bbaep-53),
    FPR_TW(0x1.3fed96p-1, -0x1.975526p-26, 0x1.136916p-51),
    FPR_TW(0x1.8fbccap-1, 0x1.f7ca06p-28, 0x1.d240acp-54),
    FPR_TW(-0x1.8fbccap-1, -0x1.f7ca06p-28, -0x1.d240acp-54),
    FPR_TW(0x1.3fed96p-1, -0x1.975526p-26, 0x1.136916p-51),
    FPR_TW(0x1.c08c42p-1, 0x1.9c9552p-27, 0x1.0d8acp-53),
    FPR_TW(0x1.edc196p-2, -0x1.a210e6p-27, 0x1.622f08p-52),
    FPR_TW(-0x1.edc196p-2, 0x1.a210e6p-27, -0x1.622f08p-52),
    FPR_TW(0x1.c08c42p-1, 0x1.9c9552p-27, 0x1.0d8acp-53),
    FPR_TW(0x1.1d3444p-2, -0x1.664984p-31, -0x1.720d42p-57),
    FPR_TW(0x1.ebbd8cp-1, 0x1.1be16ep-26, 0x1.0e3646p-51),
    FPR_TW(-0x1.ebbd8cp-1, -0x1.1be16ep-26, -0x1.0e3646p-51),
    FPR_TW(0x1.1d3444p-2, -0x1.664984p-31, -0x1.720d42p-57),
    FPR_TW(0x1.e817bap-1, 0x1.699a22p-26, -0x1.9d0afep-52),
    FPR_TW(0x1.35410cp-2, 0x1.70c0a8p-29, 0x1.b0d4p-54),
    FPR_TW(-0x1.35410cp-2, -0x1.70c0a8p-29, -0x1.b0d4p-54),
    FPR_TW(0x1.e817bap-1, 0x1.699a22p-26, -0x1.9d0afep-52),
    FPR_TW(0x1.d79776p-2, -0x1.1e471ep-28, 0x1.5543b2p-54),
    FPR_TW(0x1.c678b4p-1, -0x1.6ef18cp-26, -0x1.389e4ep-51),
    FPR_TW(-0x1.c678b4p-1, 0x1.6ef18cp-26, 0x1.389e4ep-51),
    FPR_TW(0x1.d79776p-2, -0x1.1e471ep-28, 0x1.5543b2p-54),
    FPR_TW(0x1.87c4p-1, 0x1.f745d8p-26, -0x1.4b6afp-53),
    FPR_TW(0x1.49a44ap-1, -0x1.193db2p-27, 0x1.6c08f4p-54),
    FPR_TW(-0x1.49a44ap-1, 0x1.193db2p-27, -0x1.6c08f4p-54),
    FPR_TW(0x1.87c4p-1, 0x1.f745d8p-26, -0x1.4b6afp-53),
    FPR_TW(0x1.5f6dp-4, 0x1.535484p-29, -0x1.cfa012p-54),
    FPR_TW(0x1.fe1cbp-1, -0x1.a1527cp-28, 0x1.1a23e4p-53),
    FPR_TW(-0x1.fe1cbp-1, 0x1.a1527cp-28, -0x1.1a23e4p-53),
    FPR_TW(0x1.5f6dp-4, 0x1.535484p-29, -0x1.cfa012p-54),
    FPR_TW(0x1.ff0956p-1, 0x1.639c6cp-27, -0x1.5fcae6p-52),
    FPR_TW(0x1.f656e8p-5, -0x1.81f7c8p-31, -0x1.2e1ebep-61),
    FPR_TW(-0x1.f656e8p-5, 0x1.81f7c8p-31, 0x1.2e1ebep-61),
    FPR_TW(0x1.ff0956p-1, 0x1.639c6cp-27, -0x1.5fcae6p-52),
    FPR_TW(0x1.53282ap-1, -0x1.ab954ep-26, 0x1.72f68ap-51),
    FPR_TW(0x1.7f8ecep-1, 0x1.ab8bb8p-28, 0x1.31b93ap-54),
    FPR_TW(-0x1.7f8ecep-1, -0x1.ab8bb8p-28, -0x1.31b93ap-54),
    FPR_TW(0x1.53282ap-1, -0x1.ab954ep-26, 0x1.72f68ap-51),
    FPR_TW(0x1.cc1f1p-1, -0x1.806074p-26, -0x1.e1a89ep-52),
    FPR_TW(0x1.c1249ep-2, -0x1.ffb846p-28, -0x1.604eaap-54),
    FPR_TW(-0x1.c1249ep-2, 0x1.ffb846p-28, 0x1.604eaap-54),
    FPR_TW(0x1.cc1f1p-1, -0x1.806074p-26, -0x1.e1a89ep-52),
    FPR_TW(0x1.4d1e24p-2, 0x1.3c73b6p-29, -0x1.db7d1cp-54),
    FPR_TW(0x1.e426a4p-1, 0x1.65783p-26, -0x1.95e31ep-53),
    FPR_TW(-0x1.e426a4p-1, -0x1.65783p-26, 0x1.95e31ep-53),
    FPR_TW(0x1.4d1e24p-2, 0x1.3c73b6p-29, -0x1.db7d1cp-54),
    FPR_TW(0x1.ef178ap-1, 0x1.f239e2p-28, -0x1.a73bd6p-53),
    FPR_TW(0x1.04fb8p-2, 0x1.c6ffb6p-27, -0x1.00504cp-53),
    FPR_TW(-0x1.04fb8p-2, -0x1.c6ffb6p-27, 0x1.00504cp-53),
    FPR_TW(0x1.ef178ap-1, 0x1.f239e2p-28, -0x1.a73bd6p-53),
    FPR_TW(0x1.01cfc8p-1, 0x1.d30faep-27, -0x1.26946cp-53),
    FPR_TW(0x1.ba5aa6p-1, 0x1.cd6434p-27, 0x1.2fd49cp-52),
    FPR_TW(-0x1.ba5aa6p-1, -0x1.cd6434p-27, -0x1.2fd49cp-52),
    FPR_TW(0x1.01cfc8p-1, 0x1.d30faep-27, -0x1.26946cp-53),
    FPR_TW(0x1.9777fp-1, -0x1.670518p-26, 0x1.baae1ap-53),
    FPR_TW(0x1.36058cp-1, -0x1.df34c2p-26, 0x1.5c0698p-52),
    FPR_TW(-0x1.36058cp-1, 0x1.df34c2p-26, -0x1.5c0698p-52),
    FPR_TW(0x1.9777fp-1, -0x1.670518p-26, 0x1.baae1ap-53),
    FPR_TW(0x1.139f0cp-3, 0x1.db5eaep-28, 0x1.aadcbcp-53),
    FPR_TW(0x1.fb5798p-1, -0x1.cd4518p-26, 0x1.237f58p-53),
    FPR_TW(-0x1.fb5798p-1, 0x1.cd4518p-26, -0x1.237f58p-53),
    FPR_TW(0x1.139f0cp-3, 0x1.db5eaep-28, 0x1.aadcbcp-53),
    FPR_TW(0x1.f97f92p-1, 0x1.324266p-27, 0x1.43aa3ep-52),
    FPR_TW(0x1.45576cp-3, -0x1.dad834p-28, -0x1.8942d2p-53),
    FPR_TW(-0x1.45576cp-3, 0x1.dad834p-28, 0x1.8942d2p-53),
    FPR_TW(0x1.f97f92p-1, 0x1.324266p-27, 0x1.43aa3ep-52),
    FPR_TW(0x1.2bedb2p-1, 0x1.7ebcfap-27, 0x1.f75b4p-53),
    FPR_TW(0x1.9ef43ep-1, 0x1.e535f2p-26, 0x1.0d8efep-51),
    FPR_TW(-0x1.9ef43ep-1, -0x1.e535f2p-26, -0x1.0d8efep-51),
    FPR_TW(0x1.2bedb2p-1, 0x1.7ebcfap-27, 0x1.f75b4p-53),
    FPR_TW(0x1.b3e4d4p-1, -0x1.0aa8eep-29, -0x1.eb6b8cp-55),
    FPR_TW(0x1.0c9704p-1, 0x1.abb132p-26, -0x1.634f6p-53),
    FPR_TW(-0x1.0c9704p-1, -0x1.abb132p-26, 0x1.634f6p-53),
    FPR_TW(0x1.b3e4d4p-1, -0x1.0aa8eep-29, -0x1.eb6b8cp-55),
    FPR_TW(0x1.d934fep-3, 0x1.5150c4p-29, 0x1.5d6e48p-55),
    FPR_TW(0x1.f2253p-1, -0x1.1138a4p-26, -0x1.920cb8p-51),
    FPR_TW(-0x1.f2253p-1, 0x1.1138a4p-26, 0x1.920cb8p-51),
    FPR_TW(0x1.d934fep-3, 0x1.5150c4p-29, 0x1.5d6e48p-55),
    FPR_TW(0x1.dfeae6p-1, 0x1.16df16p-28, -0x1.5453aap-53),
    FPR_TW(0x1.64c7dep-2, -0x1.606c1cp-29, -0x1.eef2d4p-54),
    FPR_TW(-0x1.64c7dep-2, 0x1.606c1cp-29, 0x1.eef2d4p-54),
    FPR_TW(0x1.dfeae6p-1, 0x1.16df16p-28, -0x1.5453aap-53),
    FPR_TW(0x1.aa6c82p-2, 0x1.6da7fap-27, -0x1.9d5f1p-52),
    FPR_TW(0x1.d17e78p-1, -0x1.783944p-26, -0x1.02203cp-51),
    FPR_TW(-0x1.d17e78p-1, 0x1.783944p-26, 0x1.02203cp-51),
    FPR_TW(0x1.aa6c82p-2, 0x1.6da7fap-27, -0x1.9d5f1p-52),
    FPR_TW(0x1.771e76p-1, -0x1.f91b3ep-30, 0x1.5cfce8p-56),
    FPR_TW(0x1.5c77bcp-1, -0x1.9afe74p-29, 0x1.069eaap-55),
    FPR_TW(-0x1.5c77bcp-1, 0x1.9afe74p-29, -0x1.069eaap-55),
    FPR_TW(0x1.771e76p-1, -0x1.f91b3ep-30, 0x1.5cfce8p-56),
    FPR_TW(0x1.2d8658p-5, -0x1.4d7546p-30, -0x1.74bc84p-56),
    FPR_TW(0x1.ffa72ep-1, 0x1.ffdeecp-26, -0x1.b1699cp-52),
    FPR_TW(-0x1.ffa72ep-1, -0x1.ffdeecp-26, 0x1.b1699cp-52),
    FPR_TW(0x1.2d8658p-5, -0x1.4d7546p-30, -0x1.74bc84p-56),
    FPR_TW(0x1.ffa72ep-1, 0x1.ffdeecp-26, -0x1.b1699cp-52),
    FPR_TW(0x1.2d8658p-5, -0x1.4d7546p-30, -0x1.74bc84p-56),
    FPR_TW(-0x1.2d8658p-5, 0x1.4d7546p-30, 0x1.74bc84p-56),
    FPR_TW(0x1.ffa72ep-1, 0x1.ffdeecp-26, -0x1.b1699cp-52),
    FPR_TW(0x1.5c77bcp-1, -0x1.9afe74p-29, 0x1.069eaap-55),
    FPR_TW(0x1.771e76p-1, -0x1.f91b3ep-30, 0x1.5cfce8p-56),
    FPR_TW(-0x1.771e76p-1, 0x1.f91b3ep-30, -0x1.5cfce8p-56),
    FPR_TW(0x1.5c77bcp-1, -0x1.9afe74p-29, 0x1.069eaap-55),
    FPR_TW(0x1.d17e78p-1, -0x1.783944p-26, -0x1.02203cp-51),
    FPR_TW(0x1.aa6c82p-2, 0x1.6da7fap-27, -0x1.9d5f1p-52),
    FPR_TW(-0x1.aa6c82p-2, -0x1.6da7fap-27, 0x1.9d5f1p-52),
    FPR_TW(0x1.d17e78p-1, -0x1.783944p-26, -0x1.02203cp-51),
    FPR_TW(0x1.64c7dep-2, -0x1.606c1cp-29, -0x1.eef2d4p-54),
    FPR_TW(0x1.dfeae6p-1, 0x1.16df16p-28, -0x1.5453aap-53),
    FPR_TW(-0x1.dfeae6p-1, -0x1.16df16p-28, 0x1.5453aap-53),
    FPR_TW(0x1.64c7dep-2, -0x1.606c1cp-29, -0x1.eef2d4p-54),
    FPR_TW(0x1.f2253p-1, -0x1.1138a4p-26, -0x1.920cb8p-51),
    FPR_TW(0x1.d934fep-3, 0x1.5150c4p-29, 0x1.5d6e48p-55),
    FPR_TW(-0x1.d934fep-3, -0x1.5150c4p-29, -0x1.5d6e48p-55),
    FPR_TW(0x1.f2253p-1, -0x1.1138a4p-26, -0x1.920cb8p-51),
    FPR_TW(0x1.0c9704p-1, 0x1.abb132p-26, -0x1.634f6p-53),
    FPR_TW(0x1.b3e4d4p-1, -0x1.0aa8eep-29, -0x1.eb6b8cp-55),
    FPR_TW(-0x1.b3e4d4p-1, 0x1.0aa8eep-29, 0x1.eb6b8cp-55),
    FPR_TW(0x1.0c9704p-1, 0x1.abb132p-26, -0x1.634f6p-53),
    FPR_TW(0x1.9ef43ep-1, 0x1.e535f2p-26, 0x1.0d8efep-51),
    FPR_TW(0x1.2bedb2p-1, 0x1.7ebcfap-27, 0x1.f75b4p-53),
    FPR_TW(-0x1.2bedb2p-1, -0x1.7ebcfap-27, -0x1.f75b4p-53),
    FPR_TW(0x1.9ef43ep-1, 0x1.e535f2p-26, 0x1.0d8efep-51),
    FPR_TW(0x1.45576cp-3, -0x1.dad834p-28, -0x1.8942d2p-53),
    FPR_TW(0x1.f97f92p-1, 0x1.324266p-27, 0x1.43aa3ep-52),
    FPR_TW(-0x1.f97f92p-1, -0x1.324266p-27, -0x1.43aa3ep-52),
    FPR_TW(0x1.45576cp-3, -0x1.dad834p-28, -0x1.8942d2p-53),
    FPR_TW(0x1.fb5798p-1, -0x1.cd4518p-26, 0x1.237f58p-53),
    FPR_TW(0x1.139f0cp-3, 0x1.db5eaep-28, 0x1.aadcbcp-53),
    FPR_TW(-0x1.139f0cp-3, -0x1.db5eaep-28, -0x1.aadcbcp-53),
    FPR_TW(0x1.fb5798p-1, -0x1.cd4518p-26, 0x1.237f58p-53),
    FPR_TW(0x1.36058cp-1, -0x1.df34c2p-26, 0x1.5c0698p-52),
    FPR_TW(0x1.9777fp-1, -0x1.670518p-26, 0x1.baae1ap-53),
    FPR_TW(-0x1.9777fp-1, 0x1.670518p-26, -0x1.baae1ap-53),
    FPR_TW(0x1.36058cp-1, -0x1.df34c2p-26, 0x1.5c0698p-52),
    FPR_TW(0x1.ba5aa6p-1, 0x1.cd6434p-27, 0x1.2fd49cp-52),
    FPR_TW(0x1.01cfc8p-1, 0x1.d30faep-27, -0x1.26946cp-53),
    FPR_TW(-0x1.01cfc8p-1, -0x1.d30faep-27, 0x1.26946cp-53),
    FPR_TW(0x1.ba5aa6p-1, 0x1.cd6434p-27, 0x1.2fd49cp-52),
    FPR_TW(0x1.04fb8p-2, 0x1.c6ffb6p-27, -0x1.00504cp-53),
    FPR_TW(0x1.ef178ap-1, 0x1.f239e2p-28, -0x1.a73bd6p-53),
    FPR_TW(-0x1.ef178ap-1, -0x1.f239e2p-28, 0x1.a73bd6p-53),
    FPR_TW(0x1.04fb8p-2, 0x1.c6ffb6p-27, -0x1.00504cp-53),
    FPR_TW(0x1.e426a4p-1, 0x1.65783p-26, -0x1.95e31ep-53),
    FPR_TW(0x1.4d1e24p-2, 0x1.3c73b6p-29, -0x1.db7d1cp-54),
    FPR_TW(-0x1.4d1e24p-2, -0x1.3c73b6p-29, 0x1.db7d1cp-54),
    FPR_TW(0x1.e426a4p-1, 0x1.65783p-26, -0x1.95e31ep-53),
    FPR_TW(0x1.c1249ep-2, -0x1.ffb846p-28, -0x1.604eaap-54),
    FPR_TW(0x1.cc1f1p-1, -0x1.806074p-26, -0x1.e1a89ep-52),
    FPR_TW(-0x1.cc1f1p-1, 0x1.806074p-26, 0x1.e1a89ep-52),
    FPR_TW(0x1.c1249ep-2, -0x1.ffb846p-28, -0x1.604eaap-54),
    FPR_TW(0x1.7f8ecep-1, 0x1.ab8bb8p-28, 0x1.31b93ap-54),
    FPR_TW(0x1.53282ap-1, -0x1.ab954ep-26, 0x1.72f68ap-51),
    FPR_TW(-0x1.53282ap-1, 0x1.ab954ep-26, -0x1.72f68ap-51),
    FPR_TW(0x1.7f8ecep-1, 0x1.ab8bb8p-28, 0x1.31b93ap-54),
    FPR_TW(0x1.f656e8p-5, -0x1.81f7c8p-31, -0x1.2e1ebep-61),
    FPR_TW(0x1.ff0956p-1, 0x1.639c6cp-27, -0x1.5fcae6p-52),
    FPR_TW(-0x1.ff0956p-1, -0x1.639c6cp-27, 0x1.5fcae6p-52),
    FPR_TW(0x1.f656e8p-5, -0x1.81f7c8p-31, -0x1.2e1ebep-61),
    FPR_TW(0x1.fe1cbp-1, -0x1.a1527cp-28, 0x1.1a23e4p-53),
    FPR_TW(0x1.5f6dp-4, 0x1.535484p-29, -0x1.cfa012p-54),
    FPR_TW(-0x1.5f6dp-4, -0x1.535484p-29, 0x1.cfa012p-54),
    FPR_TW(0x1.fe1cbp-1, -0x1.a1527cp-28, 0x1.1a23e4p-53),
    FPR_TW(0x1.49a44ap-1, -0x1.193db2p-27, 0x1.6c08f4p-54),
    FPR_TW(0x1.87c4p-1, 0x1.f745d8p-26, -0x1.4b6afp-53),
    FPR_TW(-0x1.87c4p-1, -0x1.f745d8p-26, 0x1.4b6afp-53),
    FPR_TW(0x1.49a44ap-1, -0x1.193db2p-27, 0x1.6c08f4p-54),
    FPR_TW(0x1.c678b4p-1, -0x1.6ef18cp-26, -0x1.389e4ep-51),
    FPR_TW(0x1.d79776p-2, -0x1.1e471ep-28, 0x1.5543b2p-54),
    FPR_TW(-0x1.d79776p-2, 0x1.1e471ep-28, -0x1.5543b2p-54),
    FPR_TW(0x1.c678b4p-1, -0x1.6ef18cp-26, -0x1.389e4ep-51),
    FPR_TW(0x1.35410cp-2, 0x1.70c0a8p-29, 0x1.b0d4p-54),
    FPR_TW(0x1.e817bap-1, 0x1.699a22p-26, -0x1.9d0afep-52),
    FPR_TW(-0x1.e817bap-1, -0x1.699a22p-26, 0x1.9d0afep-52),
    FPR_TW(0x1.35410cp-2, 0x1.70c0a8p-29, 0x1.b0d4p-54),
    FPR_TW(0x1.ebbd8cp-1, 0x1.1be16ep-26, 0x1.0e3646p-51),
    FPR_TW(0x1.1d3444p-2, -0x1.664984p-31, -0x1.720d42p-57),
    FPR_TW(-0x1.1d3444p-2, 0x1.664984p-31, 0x1.720d42p-57),
    FPR_TW(0x1.ebbd8cp-1, 0x1.1be16ep-26, 0x1.0e3646p-51),
    FPR_TW(0x1.edc196p-2, -0x1.a210e6p-27, 0x1.622f08p-52),
    FPR_TW(0x1.c08c42p-1, 0x1.9c9552p-27, 0x1.0d8acp-53),
    FPR_TW(-0x1.c08c42p-1, -0x1.9c9552p-27, -0x1.0d8acp-53),
    FPR_TW(0x1.edc196p-2, -0x1.a210e6p-27, 0x1.622f08p-52),
    FPR_TW(0x1.8fbccap-1, 0x1.f7ca06p-28, 0x1.d240acp-54),
    FPR_TW(0x1.3fed96p-1, -0x1.975526p-26, 0x1.136916p-51),
    FPR_TW(-0x1.3fed96p-1, 0x1.975526p-26, -0x1.136916p-51),
    FPR_TW(0x1.8fbccap-1, 0x1.f7ca06p-28, 0x1.d240acp-54),
    FPR_TW(0x1.c3785cp-4, 0x1.e7b0b6p-30, -0x1.853ce8p-55),
    FPR_TW(0x1.fce16p-1, -0x1.492cc2p-28, -0x1.2bbaep-53),
    FPR_TW(-0x1.fce16p-1, 0x1.492cc2p-28, 0x1.2bbaep-53),
    FPR_TW(0x1.c3785cp-4, 0x1.e7b0b6p-30, -0x1.853ce8p-55),
    FPR_TW(0x1.f7599ap-1, 0x1.d0903cp-28, -0x1.3d8672p-54),
    FPR_TW(0x1.76dd9ep-3, -0x1.af40cep-31, -0x1.715088p-56),
    FPR_TW(-0x1.76dd9ep-3, 0x1.af40cep-31, 0x1.715088p-56),
    FPR_TW(0x1.f7599ap-1, 0x1.d0903cp-28, -0x1.3d8672p-54),
    FPR_TW(0x1.21a79ap-1, -0x1.b3052ap-27, 0x1.62c274p-54),
    FPR_TW(0x1.a63092p-1, -0x1.3f4148p-27, 0x1.c2dddep-53),
    FPR_TW(-0x1.a63092p-1, 0x1.3f4148p-27, -0x1.c2dddep-53),
    FPR_TW(0x1.21a79ap-1, -0x1.b3052ap-27, 0x1.62c274p-54),
    FPR_TW(0x1.ad2bcap-1, -0x1.de2afp-29, 0x1.5c021p-54),
    FPR_TW(0x1.1734d6p-1, 0x1.ef6da4p-28, 0x1.40886ap-54),
    FPR_TW(-0x1.1734d6p-1, -0x1.ef6da4p-28, -0x1.40886ap-54),
    FPR_TW(0x1.ad2bcap-1, -0x1.de2afp-29, 0x1.5c021p-54),
    FPR_TW(0x1.a82a02p-3, 0x1.6c0114p-29, 0x1.3c37dp-56),
    FPR_TW(0x1.f4e604p-1, -0x1.3d3434p-27, -0x1.98ee02p-52),
    FPR_TW(-0x1.f4e604p-1, 0x1.3d3434p-27, 0x1.98ee02p-52),
    FPR_TW(0x1.a82a02p-3, 0x1.6c0114p-29, 0x1.3c37dp-56),
    FPR_TW(0x1.db6526p-1, 0x1.1c504ep-28, -0x1.35bddp-53),
    FPR_TW(0x1.7c3a94p-2, -0x1.dc4664p-27, 0x1.c0669p-52),
    FPR_TW(-0x1.7c3a94p-2, 0x1.dc4664p-27, -0x1.c0669p-52),
    FPR_TW(0x1.db6526p-1, 0x1.1c504ep-28, -0x1.35bddp-53),
    FPR_TW(0x1.9372a6p-2, 0x1.de49ecp-29, -0x1.a5ef3ap-55),
    FPR_TW(0x1.d69618p-1, -0x1.86c32ep-26, -0x1.4f463p-51),
    FPR_TW(-0x1.d69618p-1, 0x1.86c32ep-26, 0x1.4f463p-51),
    FPR_TW(0x1.9372a6p-2, 0x1.de49ecp-29, -0x1.a5ef3ap-55),
    FPR_TW(0x1.6e7446p-1, -0x1.62aaeap-26, -0x1.76f01p-53),
    FPR_TW(0x1.659192p-1, 0x1.7c1e1p-27, -0x1.478536p-52),
    FPR_TW(-0x1.659192p-1, -0x1.7c1e1p-27, 0x1.478536p-52),
    FPR_TW(0x1.6e7446p-1, -0x1.62aaeap-26, -0x1.76f01p-53),
    FPR_TW(0x1.921d2p-7, -0x1.909c3ep-34, 0x1.9878ecp-61),
    FPR_TW(0x1.fff622p-1, -0x1.2c8da4p-26, -0x1.2a225cp-51),
    FPR_TW(-0x1.fff622p-1, 0x1.2c8da4p-26, 0x1.2a225cp-51),
    FPR_TW(0x1.921d2p-7, -0x1.909c3ep-34, 0x1.9878ecp-61),
    FPR_TW(0x1.fffd88p-1, 0x1.63a2a4p-27, 0x1.26b38ep-52),
    FPR_TW(0x1.921f1p-8, -0x1.98ff8ep-36, -0x1.ca8d3p-61),
    FPR_TW(-0x1.921f1p-8, 0x1.98ff8ep-36, 0x1.ca8d3p-61),
    FPR_TW(0x1.fffd88p-1, 0x1.63a2a4p-27, 0x1.26b38ep-52),
    FPR_TW(0x1.67cf78p-1, 0x1.246bc4p-27, 0x1.750ab2p-59),
    FPR_TW(0x1.6c40d8p-1, -0x1.87cfb2p-26, 0x1.449754p-51),
    FPR_TW(-0x1.6c40d8p-1, 0x1.87cfb2p-26, -0x1.449754p-51),
    FPR_TW(0x1.67cf78p-1, 0x1.246bc4p-27, 0x1.750ab2p-59),
    FPR_TW(0x1.d7d0bp-1, 0x1.5c767cp-28, 0x1.6003d4p-53),
    FPR_TW(0x1.8daa52p-2, 0x1.d91496p-27, -0x1.72eb2ep-57),
    FPR_TW(-0x1.8daa52p-2, -0x1.d91496p-27, 0x1.72eb2ep-57),
    FPR_TW(0x1.d7d0bp-1, 0x1.5c767cp-28, 0x1.6003d4p-53),
    FPR_TW(0x1.820e3cp-2, -0x1.f62aa8p-27, 0x1.f9b722p-53),
    FPR_TW(0x1.da383ap-1, 0x1.2cd13p-26, 0x1.ea7efp-51),
    FPR_TW(-0x1.da383ap-1, -0x1.2cd13p-26, -0x1.ea7efp-51),
    FPR_TW(0x1.820e3cp-2, -0x1.f62aa8p-27, 0x1.f9b722p-53),
    FPR_TW(0x1.f58a2cp-1, -0x1.d0ec3p-26, 0x1.08fa5p-51),
    FPR_TW(0x1.9bdccp-3, -0x1.a47794p-28, 0x1.99632ep-53),
    FPR_TW(-0x1.9bdccp-3, 0x1.a47794p-28, -0x1.99632ep-53),
    FPR_TW(0x1.f58a2cp-1, -0x1.d0ec3p-26, 0x1.08fa5p-51),
    FPR_TW(0x1.19d5ap-1, 0x1.3e5736p-26, 0x1.fb326ap-51),
    FPR_TW(0x1.ab7326p-1, -0x1.ba4fcap-27, -0x1.cae8e6p-52),
    FPR_TW(-0x1.ab7326p-1, 0x1.ba4fcap-27, 0x1.cae8e6p-52),
    FPR_TW(0x1.19d5ap-1, 0x1.3e5736p-26, 0x1.fb326ap-51),
    FPR_TW(0x1.a7f586p-1, -0x1.ac032cp-26, -0x1.b2f488p-52),
    FPR_TW(0x1.1f0f08p-1, 0x1.7790c4p-26, -0x1.444368p-51),
    FPR_TW(-0x1.1f0f08p-1, -0x1.7790c4p-26, 0x1.444368p-51),
    FPR_TW(0x1.a7f586p-1, -0x1.ac032cp-26, -0x1.b2f488p-52),
    FPR_TW(0x1.83366ep-3, 0x1.138c98p-28, 0x1.6e6d6ap-53),
    FPR_TW(0x1.f6c3f8p-1, -0x1.052224p-28, -0x1.9ea78cp-54),
    FPR_TW(-0x1.f6c3f8p-1, 0x1.052224p-28, 0x1.9ea78cp-54),
    FPR_TW(0x1.83366ep-3, 0x1.138c98p-28, 0x1.6e6d6ap-53),
    FPR_TW(0x1.fd3792p-1, -0x1.7bbe9p-26, 0x1.152e9ep-51),
    FPR_TW(0x1.aa7b72p-4, 0x1.1257p-30, 0x1.bca734p-55),
    FPR_TW(-0x1.aa7b72p-4, -0x1.1257p-30, -0x1.bca734p-55),
    FPR_TW(0x1.fd3792p-1, -0x1.7bbe9p-26, 0x1.152e9ep-51),
    FPR_TW(0x1.425ff2p-1, -0x1.0e328ap-26, 0x1.5ece36p-53),
    FPR_TW(0x1.8dc454p-1, -0x1.9d2ce6p-26, -0x1.f71302p-52),
    FPR_TW(-0x1.8dc454p-1, 0x1.9d2ce6p-26, 0x1.f71302p-52),
    FPR_TW(0x1.425ff2p-1, -0x1.0e328ap-26, 0x1.5ece36p-53),
    FPR_TW(0x1.c20de4p-1, -0x1.5a3942p-31, 0x1.2cd752p-57),
    FPR_TW(0x1.e83e0ep-2, 0x1.5f0a22p-27, 0x1.e843c8p-53),
    FPR_TW(-0x1.e83e0ep-2, -0x1.5f0a22p-27, -0x1.e843c8p-53),
    FPR_TW(0x1.c20de4p-1, -0x1.5a3942p-31, 0x1.2cd752p-57),
    FPR_TW(0x1.233bbap-2, 0x1.78776ep-27, 0x1.666c14p-54),
    FPR_TW(0x1.eadb2ep-1, 0x1.1cf512p-26, -0x1.325d8ap-52),
    FPR_TW(-0x1.eadb2ep-1, -0x1.1cf512p-26, 0x1.325d8ap-52),
    FPR_TW(0x1.233bbap-2, 0x1.78776ep-27, 0x1.666c14p-54),
    FPR_TW(0x1.e90844p-1, -0x1.3c4102p-26, 0x1.39bf9p-52),
    FPR_TW(0x1.2f422ep-2, -0x1.44ff1ep-28, -0x1.5d406ep-54),
    FPR_TW(-0x1.2f422ep-2, 0x1.44ff1ep-28, 0x1.5d406ep-54),
    FPR_TW(0x1.e90844p-1, -0x1.3c4102p-26, 0x1.39bf9p-52),
    FPR_TW(0x1.dd28f2p-2, -0x1.6fc676p-27, 0x1.fc3152p-52),
    FPR_TW(0x1.c5042p-1, 0x1.2b6906p-29, 0x1.d47f4ep-54),
    FPR_TW(-0x1.c5042p-1, -0x1.2b6906p-29, -0x1.d47f4ep-54),
    FPR_TW(0x1.dd28f2p-2, -0x1.6fc676p-27, 0x1.fc3152p-52),
    FPR_TW(0x1.89c7eap-1, -0x1.6c8ad6p-27, 0x1.3b6dd4p-52),
    FPR_TW(0x1.473b52p-1, -0x1.19e32ep-27, -0x1.c6bcd6p-54),
    FPR_TW(-0x1.473b52p-1, 0x1.19e32ep-27, 0x1.c6bcd6p-54),
    FPR_TW(0x1.89c7eap-1, -0x1.6c8ad6p-27, 0x1.3b6dd4p-52),
    FPR_TW(0x1.787586p-4, 0x1.4bab64p-29, 0x1.57dd62p-56),
    FPR_TW(0x1.fdd53ap-1, -0x1.c17546p-34, -0x1.589e5ep-59),
    FPR_TW(-0x1.fdd53ap-1, 0x1.c17546p-34, 0x1.589e5ep-59),
    FPR_TW(0x1.787586p-4, 0x1.4bab64p-29, 0x1.57dd62p-56),
    FPR_TW(0x1.ff383p-1, 0x1.f1aaecp-26, -0x1.0caf1p-51),
    FPR_TW(0x1.c428d2p-5, -0x1.a7e504p-30, 0x1.676438p-56),
    FPR_TW(-0x1.c428d2p-5, 0x1.a7e504p-30, -0x1.676438p-56),
    FPR_TW(0x1.ff383p-1, 0x1.f1aaecp-26, -0x1.0caf1p-51),
    FPR_TW(0x1.558104p-1, -0x1.da2bb2p-27, -0x1.5d4794p-54),
    FPR_TW(0x1.7d7836p-1, 0x1.9867b6p-26, 0x1.116272p-52),
    FPR_TW(-0x1.7d7836p-1, -0x1.9867b6p-26, -0x1.116272p-52),
    FPR_TW(0x1.558104p-1, -0x1.da2bb2p-27, -0x1.5d4794p-54),
    FPR_TW(0x1.cd7d98p-1, 0x1.31665ep-26, 0x1.783418p-51),
    FPR_TW(0x1.bb7cf2p-2, 0x1.825e8p-29, 0x1.33c34cp-54),
    FPR_TW(-0x1.bb7cf2p-2, -0x1.825e8p-29, -0x1.33c34cp-54),
    FPR_TW(0x1.cd7d98p-1, 0x1.31665ep-26, 0x1.783418p-51),
    FPR_TW(0x1.530d88p-2, 0x1.5e7848p-31, -0x1.fab8e2p-56),
    FPR_TW(0x1.e31eaep-1, 0x1.0e19c4p-26, 0x1.321c7cp-51),
    FPR_TW(-0x1.e31eaep-1, -0x1.0e19c4p-26, -0x1.321c7cp-51),
    FPR_TW(0x1.530d88p-2, 0x1.5e7848p-31, -0x1.fab8e2p-56),
    FPR_TW(0x1.efe22p-1, 0x1.8172bep-26, -0x1.c6f58ap-52),
    FPR_TW(0x1.fdcdc2p-3, -0x1.480482p-29, 0x1.6922dep-56),
    FPR_TW(-0x1.fdcdc2p-3, 0x1.480482p-29, -0x1.6922dep-56),
    FPR_TW(0x1.efe22p-1, 0x1.8172bep-26, -0x1.c6f58ap-52),
    FPR_TW(0x1.048562p-1, 0x1.ab8886p-27, 0x1.3726fcp-52),
    FPR_TW(0x1.b8c38ep-1, -0x1.b15f62p-26, -0x1.d1529ap-51),
    FPR_TW(-0x1.b8c38ep-1, 0x1.b15f62p-26, 0x1.d1529ap-51),
    FPR_TW(0x1.048562p-1, 0x1.ab8886p-27, 0x1.3726fcp-52),
    FPR_TW(0x1.995cf2p-1, 0x1.db01a4p-26, 0x1.17783ep-52),
    FPR_TW(0x1.3384p-1, 0x1.a191cap-26, 0x1.a540d6p-51),
    FPR_TW(-0x1.3384p-1, -0x1.a191cap-26, -0x1.a540d6p-51),
    FPR_TW(0x1.995cf2p-1, 0x1.db01a4p-26, 0x1.17783ep-52),
    FPR_TW(0x1.20116ep-3, -0x1.627086p-28, -0x1.490b24p-55),
    FPR_TW(0x1.fae8e8p-1, 0x1.c8d9f8p-26, -0x1.49d4f2p-51),
    FPR_TW(-0x1.fae8e8p-1, -0x1.c8d9f8p-26, 0x1.49d4f2p-51),
    FPR_TW(0x1.20116ep-3, -0x1.627086p-28, -0x1.490b24p-55),
    FPR_TW(0x1.f9fce6p-1, -0x1.4a49a6p-26, -0x1.f06afcp-51),
    FPR_TW(0x1.38edbcp-3, -0x1.e64e5ep-28, 0x1.dcce7cp-54),
    FPR_TW(-0x1.38edbcp-3, 0x1.e64e5ep-28, -0x1.dcce7cp-54),
    FPR_TW(0x1.f9fce6p-1, -0x1.4a49a6p-26, -0x1.f06afcp-51),
    FPR_TW(0x1.2e780ep-1, 0x1.f4750cp-28, -0x1.6c67ecp-53),
    FPR_TW(0x1.9d1b2p-1, -0x1.42afe6p-26, 0x1.5c5faep-51),
    FPR_TW(-0x1.9d1b2p-1, 0x1.42afe6p-26, -0x1.5c5faep-51),
    FPR_TW(0x1.2e780ep-1, 0x1.f4750cp-28, -0x1.6c67ecp-53),
    FPR_TW(0x1.b588ap-1, -0x1.6debfcp-29, 0x1.c416cap-54),
    FPR_TW(0x1.09e908p-1, -0x1.7d0744p-26, 0x1.00d464p-54),
    FPR_TW(-0x1.09e908p-1, 0x1.7d0744p-26, -0x1.00d464p-54),
    FPR_TW(0x1.b588ap-1, -0x1.6debfcp-29, 0x1.c416cap-54),
    FPR_TW(0x1.e56ca2p-3, -0x1.efe5e4p-31, -0x1.5ca9ep-56),
    FPR_TW(0x1.f168f6p-1, -0x1.811bf4p-26, -0x1.893536p-52),
    FPR_TW(-0x1.f168f6p-1, 0x1.811bf4p-26, 0x1.893536p-52),
    FPR_TW(0x1.e56ca2p-3, -0x1.efe5e4p-31, -0x1.5ca9ep-56),
    FPR_TW(0x1.e100ccp-1, 0x1.453016p-26, -0x1.040b46p-51),
    FPR_TW(0x1.5ee274p-2, -0x1.0c2b2ep-27, 0x1.ac69fep-53),
    FPR_TW(-0x1.5ee274p-2, 0x1.0c2b2ep-27, -0x1.ac69fep-53),
    FPR_TW(0x1.e100ccp-1, 0x1.453016p-26, -0x1.040b46p-51),
    FPR_TW(0x1.b020d6p-2, 0x1.8fe802p-27, -0x1.bafad4p-52),
    FPR_TW(0x1.d02d5p-1, -0x1.4d426ep-29, 0x1.195ff4p-55),
    FPR_TW(-0x1.d02d5p-1, 0x1.4d426ep-29, -0x1.195ff4p-55),
    FPR_TW(0x1.b020d6p-2, 0x1.8fe802p-27, -0x1.bafad4p-52),
    FPR_TW(0x1.794006p-1, -0x1.161544p-26, 0x1.2f5252p-51),
    FPR_TW(0x1.5a28d2p-1, 0x1.4bae4ap-26, 0x1.57a26p-55),
    FPR_TW(-0x1.5a28d2p-1, -0x1.4bae4ap-26, -0x1.57a26p-55),
    FPR_TW(0x1.794006p-1, -0x1.161544p-26, 0x1.2f5252p-51),
    FPR_TW(0x1.5fc00ep-5, -0x1.ade658p-30, 0x1.b44cd4p-56),
    FPR_TW(0x1.ff871ep-1, -0x1.491f88p-27, -0x1.9d38e6p-54),
    FPR_TW(-0x1.ff871ep-1, 0x1.491f88p-27, 0x1.9d38e6p-54),
    FPR_TW(0x1.5fc00ep-5, -0x1.ade658p-30, 0x1.b44cd4p-56),
    FPR_TW(0x1.ffc252p-1, -0x1.071604p-28, 0x1.7a7d2p-56),
    FPR_TW(0x1.f69374p-6, -0x1.c5c62p-31, 0x1.fd802cp-59),
    FPR_TW(-0x1.f69374p-6, 0x1.c5c62p-31, -0x1.fd802cp-59),
    FPR_TW(0x1.ffc252p-1, -0x1.071604p-28, 0x1.7a7d2p-56),
    FPR_TW(0x1.5ec34ap-1, -0x1.4f91f2p-26, 0x1.0ef544p-51),
    FPR_TW(0x1.74f948p-1, 0x1.b51a52p-26, -0x1.7fdccep-52),
    FPR_TW(-0x1.74f948p-1, -0x1.b51a52p-26, 0x1.7fdccep-52),
    FPR_TW(0x1.5ec34ap-1, -0x1.4f91f2p-26, 0x1.0ef544p-51),
    FPR_TW(0x1.d2cb22p-1, 0x1.c1df3ep-30, -0x1.f07656p-56),
    FPR_TW(0x1.a4b412p-2, 0x1.f7a87ap-28, -0x1.b7d8dep-53),
    FPR_TW(-0x1.a4b412p-2, -0x1.f7a87ap-28, 0x1.b7d8dep-53),
    FPR_TW(0x1.d2cb22p-1, 0x1.c1df3ep-30, -0x1.f07656p-56),
    FPR_TW(0x1.6aa9d8p-2, -0x1.1c40f4p-29, -0x1.4e2d1cp-54),
    FPR_TW(0x1.ded06p-1, -0x1.043704p-26, -0x1.92cc4cp-51),
    FPR_TW(-0x1.ded06p-1, 0x1.043704p-26, 0x1.92cc4cp-51),
    FPR_TW(0x1.6aa9d8p-2, -0x1.1c40f4p-29, -0x1.4e2d1cp-54),
    FPR_TW(0x1.f2dc9cp-1, 0x1.211354p-26, -0x1.7d57f2p-52),
    FPR_TW(0x1.ccf8ccp-3, -0x1.9da9bp-28, 0x1.891c16p-53),
    FPR_TW(-0x1.ccf8ccp-3, 0x1.9da9bp-28, -0x1.891c16p-53),
    FPR_TW(0x1.f2dc9cp-1, 0x1.211354p-26, -0x1.7d57f2p-52),
    FPR_TW(0x1.0f426cp-1, -0x1.355c6p-27, -0x1.376b2p-52),
    FPR_TW(0x1.b23cd4p-1, 0x1.c004eep-27, -0x1.ea5e44p-52),
    FPR_TW(-0x1.b23cd4p-1, -0x1.c004eep-27, 0x1.ea5e44p-52),
    FPR_TW(0x1.0f426cp-1, -0x1.355c6p-27, -0x1.376b2p-52),
    FPR_TW(0x1.a0c95ep-1, 0x1.575f26p-26, 0x1.a1f35cp-51),
    FPR_TW(0x1.296072p-1, 0x1.d8a72ap-27, 0x1.56d6c8p-56),
    FPR_TW(-0x1.296072p-1, -0x1.d8a72ap-27, -0x1.56d6c8p-56),
    FPR_TW(0x1.a0c95ep-1, 0x1.575f26p-26, 0x1.a1f35cp-51),
    FPR_TW(0x1.51bdf8p-3, 0x1.65f17cp-29, 0x1.f9819ap-55),
    FPR_TW(0x1.f8fd6p-1, -0x1.46f894p-31, -0x1.8cfd78p-56),
    FPR_TW(-0x1.f8fd6p-1, 0x1.46f894p-31, 0x1.8cfd78p-56),
    FPR_TW(0x1.51bdf8p-3, 0x1.65f17cp-29, 0x1.f9819ap-55),
    FPR_TW(0x1.fbc162p-1, -0x1.0377dp-26, 0x1.7ea714p-51),
    FPR_TW(0x1.072a04p-3, 0x1.eea0c8p-29, -0x1.6e624ep-54),
    FPR_TW(-0x1.072a04p-3, -0x1.eea0c8p-29, 0x1.6e624ep-54),
    FPR_TW(0x1.fbc162p-1, -0x1.0377dp-26, 0x1.7ea714p-51),
    FPR_TW(0x1.388418p-1, 0x1.77fac8p-27, 0x1.cbf9p-53),
    FPR_TW(0x1.958efep-1, 0x1.239b76p-27, -0x1.5584cep-53),
    FPR_TW(-0x1.958efep-1, -0x1.239b76p-27, 0x1.5584cep-53),
    FPR_TW(0x1.388418p-1, 0x1.77fac8p-27, 0x1.cbf9p-53),
    FPR_TW(0x1.bbed7cp-1, 0x1.24e03ap-27, 0x1.037d5ap-52),
    FPR_TW(0x1.fe2f64p-2, 0x1.7ce242p-27, -0x1.297ab2p-56),
    FPR_TW(-0x1.fe2f64p-2, -0x1.7ce242p-27, 0x1.297ab2p-56),
    FPR_TW(0x1.bbed7cp-1, 0x1.24e03ap-27, 0x1.037d5ap-52),
    FPR_TW(0x1.0b0d9cp-2, 0x1.fb7b72p-27, 0x1.3b3a7cp-58),
    FPR_TW(0x1.ee482ep-1, 0x1.2d4edep-28, -0x1.b6066ep-56),
    FPR_TW(-0x1.ee482ep-1, -0x1.2d4edep-28, 0x1.b6066ep-56),
    FPR_TW(0x1.0b0d9cp-2, 0x1.fb7b72p-27, 0x1.3b3a7cp-58),
    FPR_TW(0x1.e529fp-1, 0x1.1ca8p-27, -0x1.cdf146p-52),
    FPR_TW(0x1.472b8ap-2, 0x1.55c414p-28, 0x1.dfc2bep-53),
    FPR_TW(-0x1.472b8ap-2, -0x1.55c414p-28, -0x1.dfc2bep-53),
    FPR_TW(0x1.e529fp-1, 0x1.1ca8p-27, -0x1.cdf146p-52),
    FPR_TW(0x1.c6c7f4p-2, 0x1.32e002p-27, -0x1.5bec26p-52),
    FPR_TW(0x1.cabc16p-1, 0x1.34172p-26, 0x1.c42d3ep-55),
    FPR_TW(-0x1.cabc16p-1, -0x1.34172p-26, -0x1.c42d3ep-55),
    FPR_TW(0x1.c6c7f4p-2, 0x1.32e002p-27, -0x1.5bec26p-52),
    FPR_TW(0x1.81a1b4p-1, -0x1.8950a6p-26, -0x1.15dea2p-51),
    FPR_TW(0x1.50cc0ap-1, -0x1.4cbecap-30, 0x1.693464p-56),
    FPR_TW(-0x1.50cc0ap-1, 0x1.4cbecap-30, -0x1.693464p-56),
    FPR_TW(0x1.81a1b4p-1, -0x1.8950a6p-26, -0x1.15dea2p-51),
    FPR_TW(0x1.144014p-4, -0x1.651ecap-29, 0x1.402778p-55),
    FPR_TW(0x1.fed58ep-1, 0x1.96ce78p-26, 0x1.e191bap-52),
    FPR_TW(-0x1.fed58ep-1, -0x1.96ce78p-26, -0x1.e191bap-52),
    FPR_TW(0x1.144014p-4, -0x1.651ecap-29, 0x1.402778p-55),
    FPR_TW(0x1.fe5f3ap-1, 0x1.e5c728p-26, 0x1.b213f2p-55),
    FPR_TW(0x1.466118p-4, -0x1.b637dap-30, -0x1.296214p-55),
    FPR_TW(-0x1.466118p-4, 0x1.b637dap-30, 0x1.296214p-55),
    FPR_TW(0x1.fe5f3ap-1, 0x1.e5c728p-26, 0x1.b213f2p-55),
    FPR_TW(0x1.4c0a14p-1, 0x1.7b0002p-27, -0x1.fb673cp-52),
    FPR_TW(0x1.85bc52p-1, -0x1.45a9ccp-27, -0x1.d748b4p-52),
    FPR_TW(-0x1.85bc52p-1, 0x1.45a9ccp-27, 0x1.d748b4p-52),
    FPR_TW(0x1.4c0a14p-1, 0x1.7b0002p-27, -0x1.fb673cp-52),
    FPR_TW(0x1.c7e8e6p-1, -0x1.bb9862p-26, 0x1.8d956ap-52),
    FPR_TW(0x1.d2016ep-2, 0x1.1d3b6cp-27, -0x1.4e45e8p-52),
    FPR_TW(-0x1.d2016ep-2, -0x1.1d3b6cp-27, 0x1.4e45e8p-52),
    FPR_TW(0x1.c7e8e6p-1, -0x1.bb9862p-26, 0x1.8d956ap-52),
    FPR_TW(0x1.3b3cfp-2, -0x1.7efad2p-28, -0x1.06491ep-55),
    FPR_TW(0x1.e7227ep-1, -0x1.255a2ep-27, -0x1.dbdafp-52),
    FPR_TW(-0x1.e7227ep-1, 0x1.255a2ep-27, 0x1.dbdafp-52),
    FPR_TW(0x1.3b3cfp-2, -0x1.7efad2p-28, -0x1.06491ep-55),
    FPR_TW(0x1.ec9b2ep-1, -0x1.87881p-26, 0x1.08c88cp-51),
    FPR_TW(0x1.172a0ep-2, -0x1.1135d2p-27, 0x1.c912bap-52),
    FPR_TW(-0x1.172a0ep-2, 0x1.1135d2p-27, -0x1.c912bap-52),
    FPR_TW(0x1.ec9b2ep-1, -0x1.87881p-26, 0x1.08c88cp-51),
    FPR_TW(0x1.f3405ap-2, -0x1.3805f4p-27, 0x1.d06846p-52),
    FPR_TW(0x1.bf064ep-1, 0x1.5377dep-29, -0x1.dbd54p-54),
    FPR_TW(-0x1.bf064ep-1, -0x1.5377dep-29, 0x1.dbd54p-54),
    FPR_TW(0x1.f3405ap-2, -0x1.3805f4p-27, 0x1.d06846p-52),
    FPR_TW(0x1.91b166p-1, 0x1.fa93b4p-26, 0x1.ec416ap-53),
    FPR_TW(0x1.3d7824p-1, -0x1.ce9f3p-27, 0x1.dfbcc2p-52),
    FPR_TW(-0x1.3d7824p-1, 0x1.ce9f3p-27, -0x1.dfbcc2p-52),
    FPR_TW(0x1.91b166p-1, 0x1.fa93b4p-26, 0x1.ec416ap-53),
    FPR_TW(0x1.dc70ecp-4, 0x1.75d3fap-29, -0x1.bb4098p-54),
    FPR_TW(0x1.fc8646p-1, 0x1.9fd6e4p-26, 0x1.4c50f8p-53),
    FPR_TW(-0x1.fc8646p-1, -0x1.9fd6e4p-26, -0x1.4c50f8p-53),
    FPR_TW(0x1.dc70ecp-4, 0x1.75d3fap-29, -0x1.bb4098p-54),
    FPR_TW(0x1.f7ea62p-1, 0x1.3cc7aep-26, -0x1.915b4ap-53),
    FPR_TW(0x1.6a813p-3, 0x1.3d92acp-29, 0x1.1f0cd8p-54),
    FPR_TW(-0x1.6a813p-3, -0x1.3d92acp-29, -0x1.1f0cd8p-54),
    FPR_TW(0x1.f7ea62p-1, 0x1.3cc7aep-26, -0x1.915b4ap-53),
    FPR_TW(0x1.243d6p-1, -0x1.19d4f8p-27, -0x1.8eb30cp-54),
    FPR_TW(0x1.a4678cp-1, 0x1.02335ap-26, -0x1.ee4b4p-51),
    FPR_TW(-0x1.a4678cp-1, -0x1.02335ap-26, 0x1.ee4b4p-51),
    FPR_TW(0x1.243d6p-1, -0x1.19d4f8p-27, -0x1.8eb30cp-54),
    FPR_TW(0x1.aee04cp-1, -0x1.787d72p-26, 0x1.d8b0ccp-52),
    FPR_TW(0x1.14915ap-1, 0x1.e66d9ep-26, -0x1.3064dp-51),
    FPR_TW(-0x1.14915ap-1, -0x1.e66d9ep-26, 0x1.3064dp-51),
    FPR_TW(0x1.aee04cp-1, -0x1.787d72p-26, 0x1.d8b0ccp-52),
    FPR_TW(0x1.b4732ep-3, 0x1.e7ace4p-28, 0x1.377cbap-54),
    FPR_TW(0x1.f43d08p-1, 0x1.7fe4b8p-27, -0x1.b1fbcep-52),
    FPR_TW(-0x1.f43d08p-1, -0x1.7fe4b8p-27, 0x1.b1fbcep-52),
    FPR_TW(0x1.b4732ep-3, 0x1.e7ace4p-28, 0x1.377cbap-54),
    FPR_TW(0x1.dc8d7cp-1, 0x1.68204cp-26, 0x1.6b7872p-56),
    FPR_TW(0x1.76634p-2, 0x1.e4831ep-27, 0x1.92b2aep-52),
    FPR_TW(-0x1.76634p-2, -0x1.e4831ep-27, -0x1.92b2aep-52),
    FPR_TW(0x1.dc8d7cp-1, 0x1.68204cp-26, 0x1.6b7872p-56),
    FPR_TW(0x1.993716p-2, 0x1.41bdfep-30, 0x1.750b9ap-55),
    FPR_TW(0x1.d556f6p-1, -0x1.a2d82ap-26, 0x1.3f8936p-54),
    FPR_TW(-0x1.d556f6p-1, 0x1.a2d82ap-26, -0x1.3f8936p-54),
    FPR_TW(0x1.993716p-2, 0x1.41bdfep-30, 0x1.750b9ap-55),
    FPR_TW(0x1.70a42cp-1, -0x1.9d125p-26, -0x1.8ecf2p-51),
    FPR_TW(0x1.63503ap-1, 0x1.8e0df4p-28, 0x1.11249p-53),
    FPR_TW(-0x1.63503ap-1, -0x1.8e0df4p-28, -0x1.11249p-53),
    FPR_TW(0x1.70a42cp-1, -0x1.9d125p-26, -0x1.8ecf2p-51),
    FPR_TW(0x1.2d936cp-6, -0x1.073c4p-32, -0x1.64a06ep-57),
    FPR_TW(0x1.ffe9ccp-1, -0x1.7695ccp-26, 0x1.2b6866p-53),
    FPR_TW(-0x1.ffe9ccp-1, 0x1.7695ccp-26, -0x1.2b6866p-53),
    FPR_TW(0x1.2d936cp-6, -0x1.073c4p-32, -0x1.64a06ep-57),
    FPR_TW(0x1.ffe9ccp-1, -0x1.7695ccp-26, 0x1.2b6866p-53),
    FPR_TW(0x1.2d936cp-6, -0x1.073c4p-32, -0x1.64a06ep-57),
    FPR_TW(-0x1.2d936cp-6, 0x1.073c4p-32, 0x1.64a06ep-57),
    FPR_TW(0x1.ffe9ccp-1, -0x1.7695ccp-26, 0x1.2b6866p-53),
    FPR_TW(0x1.63503ap-1, 0x1.8e0df4p-28, 0x1.11249p-53),
    FPR_TW(0x1.70a42cp-1, -0x1.9d125p-26, -0x1.8ecf2p-51),
    FPR_TW(-0x1.70a42cp-1, 0x1.9d125p-26, 0x1.8ecf2p-51),
    FPR_TW(0x1.63503ap-1, 0x1.8e0df4p-28, 0x1.11249p-53),
    FPR_TW(0x1.d556f6p-1, -0x1.a2d82ap-26, 0x1.3f8936p-54),
    FPR_TW(0x1.993716p-2, 0x1.41bdfep-30, 0x1.750b9ap-55),
    FPR_TW(-0x1.993716p-2, -0x1.41bdfep-30, -0x1.750b9ap-55),
    FPR_TW(0x1.d556f6p-1, -0x1.a2d82ap-26, 0x1.3f8936p-54),
    FPR_TW(0x1.76634p-2, 0x1.e4831ep-27, 0x1.92b2aep-52),
    FPR_TW(0x1.dc8d7cp-1, 0x1.68204cp-26, 0x1.6b7872p-56),
    FPR_TW(-0x1.dc8d7cp-1, -0x1.68204cp-26, -0x1.6b7872p-56),
    FPR_TW(0x1.76634p-2, 0x1.e4831ep-27, 0x1.92b2aep-52),
    FPR_TW(0x1.f43d08p-1, 0x1.7fe4b8p-27, -0x1.b1fbcep-52),
    FPR_TW(0x1.b4732ep-3, 0x1.e7ace4p-28, 0x1.377cbap-54),
    FPR_TW(-0x1.b4732ep-3, -0x1.e7ace4p-28, -0x1.377cbap-54),
    FPR_TW(0x1.f43d08p-1, 0x1.7fe4b8p-27, -0x1.b1fbcep-52),
    FPR_TW(0x1.14915ap-1, 0x1.e66d9ep-26, -0x1.3064dp-51),
    FPR_TW(0x1.aee04cp-1, -0x1.787d72p-26, 0x1.d8b0ccp-52),
    FPR_TW(-0x1.aee04cp-1, 0x1.787d72p-26, -0x1.d8b0ccp-52),
    FPR_TW(0x1.14915ap-1, 0x1.e66d9ep-26, -0x1.3064dp-51),
    FPR_TW(0x1.a4678cp-1, 0x1.02335ap-26, -0x1.ee4b4p-51),
    FPR_TW(0x1.243d6p-1, -0x1.19d4f8p-27, -0x1.8eb30cp-54),
    FPR_TW(-0x1.243d6p-1, 0x1.19d4f8p-27, 0x1.8eb30cp-54),
    FPR_TW(0x1.a4678cp-1, 0x1.02335ap-26, -0x1.ee4b4p-51),
    FPR_TW(0x1.6a813p-3, 0x1.3d92acp-29, 0x1.1f0cd8p-54),
    FPR_TW(0x1.f7ea62p-1, 0x1.3cc7aep-26, -0x1.915b4ap-53),
    FPR_TW(-0x1.f7ea62p-1, -0x1.3cc7aep-26, 0x1.915b4ap-53),
    FPR_TW(0x1.6a813p-3, 0x1.3d92acp-29, 0x1.1f0cd8p-54),
    FPR_TW(0x1.fc8646p-1, 0x1.9fd6e4p-26, 0x1.4c50f8p-53),
    FPR_TW(0x1.dc70ecp-4, 0x1.75d3fap-29, -0x1.bb4098p-54),
    FPR_TW(-0x1.dc70ecp-4, -0x1.75d3fap-29, 0x1.bb4098p-54),
    FPR_TW(0x1.fc8646p-1, 0x1.9fd6e4p-26, 0x1.4c50f8p-53),
    FPR_TW(0x1.3d7824p-1, -0x1.ce9f3p-27, 0x1.dfbcc2p-52),
    FPR_TW(0x1.91b166p-1, 0x1.fa93b4p-26, 0x1.ec416ap-53),
    FPR_TW(-0x1.91b166p-1, -0x1.fa93b4p-26, -0x1.ec416ap-53),
    FPR_TW(0x1.3d7824p-1, -0x1.ce9f3p-27, 0x1.dfbcc2p-52),
    FPR_TW(0x1.bf064ep-1, 0x1.5377dep-29, -0x1.dbd54p-54),
    FPR_TW(0x1.f3405ap-2, -0x1.3805f4p-27, 0x1.d06846p-52),
    FPR_TW(-0x1.f3405ap-2, 0x1.3805f4p-27, -0x1.d06846p-52),
    FPR_TW(0x1.bf064ep-1, 0x1.5377dep-29, -0x1.dbd54p-54),
    FPR_TW(0x1.172a0ep-2, -0x1.1135d2p-27, 0x1.c912bap-52),
    FPR_TW(0x1.ec9b2ep-1, -0x1.87881p-26, 0x1.08c88cp-51),
    FPR_TW(-0x1.ec9b2ep-1, 0x1.87881p-26, -0x1.08c88cp-51),
    FPR_TW(0x1.172a0ep-2, -0x1.1135d2p-27, 0x1.c912bap-52),
    FPR_TW(0x1.e7227ep-1, -0x1.255a2ep-27, -0x1.dbdafp-52),
    FPR_TW(0x1.3b3cfp-2, -0x1.7efad2p-28, -0x1.06491ep-55),
    FPR_TW(-0x1.3b3cfp-2, 0x1.7efad2p-28, 0x1.06491ep-55),
    FPR_TW(0x1.e7227ep-1, -0x1.255a2ep-27, -0x1.dbdafp-52),
    FPR_TW(0x1.d2016ep-2, 0x1.1d3b6cp-27, -0x1.4e45e8p-52),
    FPR_TW(0x1.c7e8e6p-1, -0x1.bb9862p-26, 0x1.8d956ap-52),
    FPR_TW(-0x1.c7e8e6p-1, 0x1.bb9862p-26, -0x1.8d956ap-52),
    FPR_TW(0x1.d2016ep-2, 0x1.1d3b6cp-27, -0x1.4e45e8p-52),
    FPR_TW(0x1.85bc52p-1, -0x1.45a9ccp-27, -0x1.d748b4p-52),
    FPR_TW(0x1.4c0a14p-1, 0x1.7b0002p-27, -0x1.fb673cp-52),
    FPR_TW(-0x1.4c0a14p-1, -0x1.7b0002p-27, 0x1.fb673cp-52),
    FPR_TW(0x1.85bc52p-1, -0x1.45a9ccp-27, -0x1.d748b4p-52),
    FPR_TW(0x1.466118p-4, -0x1.b637dap-30, -0x1.296214p-55),
    FPR_TW(0x1.fe5f3ap-1, 0x1.e5c728p-26, 0x1.b213f2p-55),
    FPR_TW(-0x1.fe5f3ap-1, -0x1.e5c728p-26, -0x1.b213f2p-55),
    FPR_TW(0x1.466118p-4, -0x1.b637dap-30, -0x1.296214p-55),
    FPR_TW(0x1.fed58ep-1, 0x1.96ce78p-26, 0x1.e191bap-52),
    FPR_TW(0x1.144014p-4, -0x1.651ecap-29, 0x1.402778p-55),
    FPR_TW(-0x1.144014p-4, 0x1.651ecap-29, -0x1.402778p-55),
    FPR_TW(0x1.fed58ep-1, 0x1.96ce78p-26, 0x1.e191bap-52),
    FPR_TW(0x1.50cc0ap-1, -0x1.4cbecap-30, 0x1.693464p-56),
    FPR_TW(0x1.81a1b4p-1, -0x1.8950a6p-26, -0x1.15dea2p-51),
    FPR_TW(-0x1.81a1b4p-1, 0x1.8950a6p-26, 0x1.15dea2p-51),
    FPR_TW(0x1.50cc0ap-1, -0x1.4cbecap-30, 0x1.693464p-56),
    FPR_TW(0x1.cabc16p-1, 0x1.34172p-26, 0x1.c42d3ep-55),
    FPR_TW(0x1.c6c7f4p-2, 0x1.32e002p-27, -0x1.5bec26p-52),
    FPR_TW(-0x1.c6c7f4p-2, -0x1.32e002p-27, 0x1.5bec26p-52),
    FPR_TW(0x1.cabc16p-1, 0x1.34172p-26, 0x1.c42d3ep-55),
    FPR_TW(0x1.472b8ap-2, 0x1.55c414p-28, 0x1.dfc2bep-53),
    FPR_TW(0x1.e529fp-1, 0x1.1ca8p-27, -0x1.cdf146p-52),
    FPR_TW(-0x1.e529fp-1, -0x1.1ca8p-27, 0x1.cdf146p-52),
    FPR_TW(0x1.472b8ap-2, 0x1.55c414p-28, 0x1.dfc2bep-53),
    FPR_TW(0x1.ee482ep-1, 0x1.2d4edep-28, -0x1.b6066ep-56),
    FPR_TW(0x1.0b0d9cp-2, 0x1.fb7b72p-27, 0x1.3b3a7cp-58),
    FPR_TW(-0x1.0b0d9cp-2, -0x1.fb7b72p-27, -0x1.3b3a7cp-58),
    FPR_TW(0x1.ee482ep-1, 0x1.2d4edep-28, -0x1.b6066ep-56),
    FPR_TW(0x1.fe2f64p-2, 0x1.7ce242p-27, -0x1.297ab2p-56),
    FPR_TW(0x1.bbed7cp-1, 0x1.24e03ap-27, 0x1.037d5ap-52),
    FPR_TW(-0x1.bbed7cp-1, -0x1.24e03ap-27, -0x1.037d5ap-52),
    FPR_TW(0x1.fe2f64p-2, 0x1.7ce242p-27, -0x1.297ab2p-56),
    FPR_TW(0x1.958efep-1, 0x1.239b76p-27, -0x1.5584cep-53),
    FPR_TW(0x1.388418p-1, 0x1.77fac8p-27, 0x1.cbf9p-53),
    FPR_TW(-0x1.388418p-1, -0x1.77fac8p-27, -0x1.cbf9p-53),
    FPR_TW(0x1.958efep-1, 0x1.239b76p-27, -0x1.5584cep-53),
    FPR_TW(0x1.072a04p-3, 0x1.eea0c8p-29, -0x1.6e624ep-54),
    FPR_TW(0x1.fbc162p-1, -0x1.0377dp-26, 0x1.7ea714p-51),
    FPR_TW(-0x1.fbc162p-1, 0x1.0377dp-26, -0x1.7ea714p-51),
    FPR_TW(0x1.072a04p-3, 0x1.eea0c8p-29, -0x1.6e624ep-54),
    FPR_TW(0x1.f8fd6p-1, -0x1.46f894p-31, -0x1.8cfd78p-56),
    FPR_TW(0x1.51bdf8p-3, 0x1.65f17cp-29, 0x1.f9819ap-55),
    FPR_TW(-0x1.51bdf8p-3, -0x1.65f17cp-29, -0x1.f9819ap-55),
    FPR_TW(0x1.f8fd6p-1, -0x1.46f894p-31, -0x1.8cfd78p-56),
    FPR_TW(0x1.296072p-1, 0x1.d8a72ap-27, 0x1.56d6c8p-56),
    FPR_TW(0x1.a0c95ep-1, 0x1.575f26p-26, 0x1.a1f35cp-51),
    FPR_TW(-0x1.a0c95ep-1, -0x1.575f26p-26, -0x1.a1f35cp-51),
    FPR_TW(0x1.296072p-1, 0x1.d8a72ap-27, 0x1.56d6c8p-56),
    FPR_TW(0x1.b23cd4p-1, 0x1.c004eep-27, -0x1.ea5e44p-52),
    FPR_TW(0x1.0f426cp-1, -0x1.355c6p-27, -0x1.376b2p-52),
    FPR_TW(-0x1.0f426cp-1, 0x1.355c6p-27, 0x1.376b2p-52),
    FPR_TW(0x1.b23cd4p-1, 0x1.c004eep-27, -0x1.ea5e44p-52),
    FPR_TW(0x1.ccf8ccp-3, -0x1.9da9bp-28, 0x1.891c16p-53),
    FPR_TW(0x1.f2dc9cp-1, 0x1.211354p-26, -0x1.7d57f2p-52),
    FPR_TW(-0x1.f2dc9cp-1, -0x1.211354p-26, 0x1.7d57f2p-52),
    FPR_TW(0x1.ccf8ccp-3, -0x1.9da9bp-28, 0x1.891c16p-53),
    FPR_TW(0x1.ded06p-1, -0x1.043704p-26, -0x1.92cc4cp-51),
    FPR_TW(0x1.6aa9d8p-2, -0x1.1c40f4p-29, -0x1.4e2d1cp-54),
    FPR_TW(-0x1.6aa9d8p-2, 0x1.1c40f4p-29, 0x1.4e2d1cp-54),
    FPR_TW(0x1.ded06p-1, -0x1.043704p-26, -0x1.92cc4cp-51),
    FPR_TW(0x1.a4b412p-2, 0x1.f7a87ap-28, -0x1.b7d8dep-53),
    FPR_TW(0x1.d2cb22p-1, 0x1.c1df3ep-30, -0x1.f07656p-56),
    FPR_TW(-0x1.d2cb22p-1, -0x1.c1df3ep-30, 0x1.f07656p-56),
    FPR_TW(0x1.a4b412p-2, 0x1.f7a87ap-28, -0x1.b7d8dep-53),
    FPR_TW(0x1.74f948p-1, 0x1.b51a52p-26, -0x1.7fdccep-52),
    FPR_TW(0x1.5ec34ap-1, -0x1.4f91f2p-26, 0x1.0ef544p-51),
    FPR_TW(-0x1.5ec34ap-1, 0x1.4f91f2p-26, -0x1.0ef544p-51),
    FPR_TW(0x1.74f948p-1, 0x1.b51a52p-26, -0x1.7fdccep-52),
    FPR_TW(0x1.f69374p-6, -0x1.c5c62p-31, 0x1.fd802cp-59),
    FPR_TW(0x1.ffc252p-1, -0x1.071604p-28, 0x1.7a7d2p-56),
    FPR_TW(-0x1.ffc252p-1, 0x1.071604p-28, -0x1.7a7d2p-56),
    FPR_TW(0x1.f69374p-6, -0x1.c5c62p-31, 0x1.fd802cp-59),
    FPR_TW(0x1.ff871ep-1, -0x1.491f88p-27, -0x1.9d38e6p-54),
    FPR_TW(0x1.5fc00ep-5, -0x1.ade658p-30, 0x1.b44cd4p-56),
    FPR_TW(-0x1.5fc00ep-5, 0x1.ade658p-30, -0x1.b44cd4p-56),
    FPR_TW(0x1.ff871ep-1, -0x1.491f88p-27, -0x1.9d38e6p-54),
    FPR_TW(0x1.5a28d2p-1, 0x1.4bae4ap-26, 0x1.57a26p-55),
    FPR_TW(0x1.794006p-1, -0x1.161544p-26, 0x1.2f5252p-51),
    FPR_TW(-0x1.794006p-1, 0x1.161544p-26, -0x1.2f5252p-51),
    FPR_TW(0x1.5a28d2p-1, 0x1.4bae4ap-26, 0x1.57a26p-55),
    FPR_TW(0x1.d02d5p-1, -0x1.4d426ep-29, 0x1.195ff4p-55),
    FPR_TW(0x1.b020d6p-2, 0x1.8fe802p-27, -0x1.bafad4p-52),
    FPR_TW(-0x1.b020d6p-2, -0x1.8fe802p-27, 0x1.bafad4p-52),
    FPR_TW(0x1.d02d5p-1, -0x1.4d426ep-29, 0x1.195ff4p-55),
    FPR_TW(0x1.5ee274p-2, -0x1.0c2b2ep-27, 0x1.ac69fep-53),
    FPR_TW(0x1.e100ccp-1, 0x1.453016p-26, -0x1.040b46p-51),
    FPR_TW(-0x1.e100ccp-1, -0x1.453016p-26, 0x1.040b46p-51),
    FPR_TW(0x1.5ee274p-2, -0x1.0c2b2ep-27, 0x1.ac69fep-53),
    FPR_TW(0x1.f168f6p-1, -0x1.811bf4p-26, -0x1.893536p-52),
    FPR_TW(0x1.e56ca2p-3, -0x1.efe5e4p-31, -0x1.5ca9ep-56),
    FPR_TW(-0x1.e56ca2p-3, 0x1.efe5e4p-31, 0x1.5ca9ep-56),
    FPR_TW(0x1.f168f6p-1, -0x1.811bf4p-26, -0x1.893536p-52),
    FPR_TW(0x1.09e908p-1, -0x1.7d0744p-26, 0x1.00d464p-54),
    FPR_TW(0x1.b588ap-1, -0x1.6debfcp-29, 0x1.c416cap-54),
    FPR_TW(-0x1.b588ap-1, 0x1.6debfcp-29, -0x1.c416cap-54),
    FPR_TW(0x1.09e908p-1, -0x1.7d0744p-26, 0x1.00d464p-54),
    FPR_TW(0x1.9d1b2p-1, -0x1.42afe6p-26, 0x1.5c5faep-51),
    FPR_TW(0x1.2e780ep-1, 0x1.f4750cp-28, -0x1.6c67ecp-53),
    FPR_TW(-0x1.2e780ep-1, -0x1.f4750cp-28, 0x1.6c67ecp-53),
    FPR_TW(0x1.9d1b2p-1, -0x1.42afe6p-26, 0x1.5c5faep-51),
    FPR_TW(0x1.38edbcp-3, -0x1.e64e5ep-28, 0x1.dcce7cp-54),
    FPR_TW(0x1.f9fce6p-1, -0x1.4a49a6p-26, -0x1.f06afcp-51),
    FPR_TW(-0x1.f9fce6p-1, 0x1.4a49a6p-26, 0x1.f06afcp-51),
    FPR_TW(0x1.38edbcp-3, -0x1.e64e5ep-28, 0x1.dcce7cp-54),
    FPR_TW(0x1.fae8e8p-1, 0x1.c8d9f8p-26, -0x1.49d4f2p-51),
    FPR_TW(0x1.20116ep-3, -0x1.627086p-28, -0x1.490b24p-55),
    FPR_TW(-0x1.20116ep-3, 0x1.627086p-28, 0x1.490b24p-55),
    FPR_TW(0x1.fae8e8p-1, 0x1.c8d9f8p-26, -0x1.49d4f2p-51),
    FPR_TW(0x1.3384p-1, 0x1.a191cap-26, 0x1.a540d6p-51),
    FPR_TW(0x1.995cf2p-1, 0x1.db01a4p-26, 0x1.17783ep-52),
    FPR_TW(-0x1.995cf2p-1, -0x1.db01a4p-26, -0x1.17783ep-52),
    FPR_TW(0x1.3384p-1, 0x1.a191cap-26, 0x1.a540d6p-51),
    FPR_TW(0x1.b8c38ep-1, -0x1.b15f62p-26, -0x1.d1529ap-51),
    FPR_TW(0x1.048562p-1, 0x1.ab8886p-27, 0x1.3726fcp-52),
    FPR_TW(-0x1.048562p-1, -0x1.ab8886p-27, -0x1.3726fcp-52),
    FPR_TW(0x1.b8c38ep-1, -0x1.b15f62p-26, -0x1.d1529ap-51),
    FPR_TW(0x1.fdcdc2p-3, -0x1.480482p-29, 0x1.6922dep-56),
    FPR_TW(0x1.efe22p-1, 0x1.8172bep-26, -0x1.c6f58ap-52),
    FPR_TW(-0x1.efe22p-1, -0x1.8172bep-26, 0x1.c6f58ap-52),
    FPR_TW(0x1.fdcdc2p-3, -0x1.480482p-29, 0x1.6922dep-56),
    FPR_TW(0x1.e31eaep-1, 0x1.0e19c4p-26, 0x1.321c7cp-51),
    FPR_TW(0x1.530d88p-2, 0x1.5e7848p-31, -0x1.fab8e2p-56),
    FPR_TW(-0x1.530d88p-2, -0x1.5e7848p-31, 0x1.fab8e2p-56),
    FPR_TW(0x1.e31eaep-1, 0x1.0e19c4p-26, 0x1.321c7cp-51),
    FPR_TW(0x1.bb7cf2p-2, 0x1.825e8p-29, 0x1.33c34cp-54),
    FPR_TW(0x1.cd7d98p-1, 0x1.31665ep-26, 0x1.783418p-51),
    FPR_TW(-0x1.cd7d98p-1, -0x1.31665ep-26, -0x1.783418p-51),
    FPR_TW(0x1.bb7cf2p-2, 0x1.825e8p-29, 0x1.33c34cp-54),
    FPR_TW(0x1.7d7836p-1, 0x1.9867b6p-26, 0x1.116272p-52),
    FPR_TW(0x1.558104p-1, -0x1.da2bb2p-27, -0x1.5d4794p-54),
    FPR_TW(-0x1.558104p-1, 0x1.da2bb2p-27, 0x1.5d4794p-54),
    FPR_TW(0x1.7d7836p-1, 0x1.9867b6p-26, 0x1.116272p-52),
    FPR_TW(0x1.c428d2p-5, -0x1.a7e504p-30, 0x1.676438p-56),
    FPR_TW(0x1.ff383p-1, 0x1.f1aaecp-26, -0x1.0caf1p-51),
    FPR_TW(-0x1.ff383p-1, -0x1.f1aaecp-26, 0x1.0caf1p-51),
    FPR_TW(0x1.c428d2p-5, -0x1.a7e504p-30, 0x1.676438p-56),
    FPR_TW(0x1.fdd53ap-1, -0x1.c17546p-34, -0x1.589e5ep-59),
    FPR_TW(0x1.787586p-4, 0x1.4bab64p-29, 0x1.57dd62p-56),
    FPR_TW(-0x1.787586p-4, -0x1.4bab64p-29, -0x1.57dd62p-56),
    FPR_TW(0x1.fdd53ap-1, -0x1.c17546p-34, -0x1.589e5ep-59),
    FPR_TW(0x1.473b52p-1, -0x1.19e32ep-27, -0x1.c6bcd6p-54),
    FPR_TW(0x1.89c7eap-1, -0x1.6c8ad6p-27, 0x1.3b6dd4p-52),
    FPR_TW(-0x1.89c7eap-1, 0x1.6c8ad6p-27, -0x1.3b6dd4p-52),
    FPR_TW(0x1.473b52p-1, -0x1.19e32ep-27, -0x1.c6bcd6p-54),
    FPR_TW(0x1.c5042p-1, 0x1.2b6906p-29, 0x1.d47f4ep-54),
    FPR_TW(0x1.dd28f2p-2, -0x1.6fc676p-27, 0x1.fc3152p-52),
    FPR_TW(-0x1.dd28f2p-2, 0x1.6fc676p-27, -0x1.fc3152p-52),
    FPR_TW(0x1.c5042p-1, 0x1.2b6906p-29, 0x1.d47f4ep-54),
    FPR_TW(0x1.2f422ep-2, -0x1.44ff1ep-28, -0x1.5d406ep-54),
    FPR_TW(0x1.e90844p-1, -0x1.3c4102p-26, 0x1.39bf9p-52),
    FPR_TW(-0x1.e90844p-1, 0x1.3c4102p-26, -0x1.39bf9p-52),
    FPR_TW(0x1.2f422ep-2, -0x1.44ff1ep-28, -0x1.5d406ep-54),
    FPR_TW(0x1.eadb2ep-1, 0x1.1cf512p-26, -0x1.325d8ap-52),
    FPR_TW(0x1.233bbap-2, 0x1.78776ep-27, 0x1.666c14p-54),
    FPR_TW(-0x1.233bbap-2, -0x1.78776ep-27, -0x1.666c14p-54),
    FPR_TW(0x1.eadb2ep-1, 0x1.1cf512p-26, -0x1.325d8ap-52),
    FPR_TW(0x1.e83e0ep-2, 0x1.5f0a22p-27, 0x1.e843c8p-53),
    FPR_TW(0x1.c20de4p-1, -0x1.5a3942p-31, 0x1.2cd752p-57),
    FPR_TW(-0x1.c20de4p-1, 0x1.5a3942p-31, -0x1.2cd752p-57),
    FPR_TW(0x1.e83e0ep-2, 0x1.5f0a22p-27, 0x1.e843c8p-53),
    FPR_TW(0x1.8dc454p-1, -0x1.9d2ce6p-26, -0x1.f71302p-52),
    FPR_TW(0x1.425ff2p-1, -0x1.0e328ap-26, 0x1.5ece36p-53),
    FPR_TW(-0x1.425ff2p-1, 0x1.0e328ap-26, -0x1.5ece36p-53),
    FPR_TW(0x1.8dc454p-1, -0x1.9d2ce6p-26, -0x1.f71302p-52),
    FPR_TW(0x1.aa7b72p-4, 0x1.1257p-30, 0x1.bca734p-55),
    FPR_TW(0x1.fd3792p-1, -0x1.7bbe9p-26, 0x1.152e9ep-51),
    FPR_TW(-0x1.fd3792p-1, 0x1.7bbe9p-26, -0x1.152e9ep-51),
    FPR_TW(0x1.aa7b72p-4, 0x1.1257p-30, 0x1.bca734p-55),
    FPR_TW(0x1.f6c3f8p-1, -0x1.052224p-28, -0x1.9ea78cp-54),
    FPR_TW(0x1.83366ep-3, 0x1.138c98p-28, 0x1.6e6d6ap-53),
    FPR_TW(-0x1.83366ep-3, -0x1.138c98p-28, -0x1.6e6d6ap-53),
    FPR_TW(0x1.f6c3f8p-1, -0x1.052224p-28, -0x1.9ea78cp-54),
    FPR_TW(0x1.1f0f08p-1, 0x1.7790c4p-26, -0x1.444368p-51),
    FPR_TW(0x1.a7f586p-1, -0x1.ac032cp-26, -0x1.b2f488p-52),
    FPR_TW(-0x1.a7f586p-1, 0x1.ac032cp-26, 0x1.b2f488p-52),
    FPR_TW(0x1.1f0f08p-1, 0x1.7790c4p-26, -0x1.444368p-51),
    FPR_TW(0x1.ab7326p-1, -0x1.ba4fcap-27, -0x1.cae8e6p-52),
    FPR_TW(0x1.19d5ap-1, 0x1.3e5736p-26, 0x1.fb326ap-51),
    FPR_TW(-0x1.19d5ap-1, -0x1.3e5736p-26, -0x1.fb326ap-51),
    FPR_TW(0x1.ab7326p-1, -0x1.ba4fcap-27, -0x1.cae8e6p-52),
    FPR_TW(0x1.9bdccp-3, -0x1.a47794p-28, 0x1.99632ep-53),
    FPR_TW(0x1.f58a2cp-1, -0x1.d0ec3p-26, 0x1.08fa5p-51),
    FPR_TW(-0x1.f58a2cp-1, 0x1.d0ec3p-26, -0x1.08fa5p-51),
    FPR_TW(0x1.9bdccp-3, -0x1.a47794p-28, 0x1.99632ep-53),
    FPR_TW(0x1.da383ap-1, 0x1.2cd13p-26, 0x1.ea7efp-51),
    FPR_TW(0x1.820e3cp-2, -0x1.f62aa8p-27, 0x1.f9b722p-53),
    FPR_TW(-0x1.820e3cp-2, 0x1.f62aa8p-27, -0x1.f9b722p-53),
    FPR_TW(0x1.da383ap-1, 0x1.2cd13p-26, 0x1.ea7efp-51),
    FPR_TW(0x1.8daa52p-2, 0x1.d91496p-27, -0x1.72eb2ep-57),
    FPR_TW(0x1.d7d0bp-1, 0x1.5c767cp-28, 0x1.6003d4p-53),
    FPR_TW(-0x1.d7d0bp-1, -0x1.5c767cp-28, -0x1.6003d4p-53),
    FPR_TW(0x1.8daa52p-2, 0x1.d91496p-27, -0x1.72eb2ep-57),
    FPR_TW(0x1.6c40d8p-1, -0x1.87cfb2p-26, 0x1.449754p-51),
    FPR_TW(0x1.67cf78p-1, 0x1.246bc4p-27, 0x1.750ab2p-59),
    FPR_TW(-0x1.67cf78p-1, -0x1.246bc4p-27, -0x1.750ab2p-59),
    FPR_TW(0x1.6c40d8p-1, -0x1.87cfb2p-26, 0x1.449754p-51),
    FPR_TW(0x1.921f1p-8, -0x1.98ff8ep-36, -0x1.ca8d3p-61),
    FPR_TW(0x1.fffd88p-1, 0x1.63a2a4p-27, 0x1.26b38ep-52),
    FPR_TW(-0x1.fffd88p-1, -0x1.63a2a4p-27, -0x1.26b38ep-52),
    FPR_TW(0x1.921f1p-8, -0x1.98ff8ep-36, -0x1.ca8d3p-61),
    FPR_TW(0x1.ffff62p-1, 0x1.621d02p-29, -0x1.6acfcep-56),
    FPR_TW(0x1.921f8cp-9, -0x1.335b46p-37, 0x1.2ba408p-63),
    FPR_TW(-0x1.921f8cp-9, 0x1.335b46p-37, -0x1.2ba408p-63),
    FPR_TW(0x1.ffff62p-1, 0x1.621d02p-29, -0x1.6acfcep-56),
    FPR_TW(0x1.68ed1ep-1, 0x1.54338ep-26, 0x1.3fa95p-53),
    FPR_TW(0x1.6b25cep-1, 0x1.a5fc54p-26, -0x1.15ac64p-51),
    FPR_TW(-0x1.6b25cep-1, -0x1.a5fc54p-26, 0x1.15ac64p-51),
    FPR_TW(0x1.68ed1ep-1, 0x1.54338ep-26, 0x1.3fa95p-53),
    FPR_TW(0x1.d86c48p-1, 0x1.116914p-27, -0x1.0bbf62p-54),
    FPR_TW(0x1.8ac4b8p-2, 0x1.b57b52p-28, -0x1.dd00bp-53),
    FPR_TW(-0x1.8ac4b8p-2, -0x1.b57b52p-28, 0x1.dd00bp-53),
    FPR_TW(0x1.d86c48p-1, 0x1.116914p-27, -0x1.0bbf62p-54),
    FPR_TW(0x1.84f6aap-2, 0x1.5e7208p-27, -0x1.a48c9p-55),
    FPR_TW(0x1.d9a00ep-1, -0x1.3a615cp-28, -0x1.f20af8p-53),
    FPR_TW(-0x1.d9a00ep-1, 0x1.3a615cp-28, 0x1.f20af8p-53),
    FPR_TW(0x1.84f6aap-2, 0x1.5e7208p-27, -0x1.a48c9p-55),
    FPR_TW(0x1.f5da6ep-1, 0x1.a86d0cp-26, -0x1.aa6df8p-52),
    FPR_TW(0x1.95b49ep-3, 0x1.36c56p-28, -0x1.84402cp-53),
    FPR_TW(-0x1.95b49ep-3, -0x1.36c56p-28, 0x1.84402cp-53),
    FPR_TW(0x1.f5da6ep-1, 0x1.a86d0cp-26, -0x1.aa6df8p-52),
    FPR_TW(0x1.1b2502p-1, -0x1.1d9188p-26, -0x1.6c843ap-53),
    FPR_TW(0x1.aa9548p-1, -0x1.74d19cp-27, -0x1.fcf06p-53),
    FPR_TW(-0x1.aa9548p-1, 0x1.74d19cp-27, 0x1.fcf06p-53),
    FPR_TW(0x1.1b2502p-1, -0x1.1d9188p-26, -0x1.6c843ap-53),
    FPR_TW(0x1.a8d676p-1, 0x1.ca8b5ap-26, 0x1.f93b88p-53),
    FPR_TW(0x1.1dc1b6p-1, 0x1.37121cp-27, 0x1.0f8afp-52),
    FPR_TW(-0x1.1dc1b6p-1, -0x1.37121cp-27, -0x1.0f8afp-52),
    FPR_TW(0x1.a8d676p-1, 0x1.ca8b5ap-26, 0x1.f93b88p-53),
    FPR_TW(0x1.896172p-3, 0x1.f10602p-29, -0x1.ec0254p-54),
    FPR_TW(0x1.f67756p-1, -0x1.2ef862p-26, -0x1.e1096ap-53),
    FPR_TW(-0x1.f67756p-1, 0x1.2ef862p-26, 0x1.e1096ap-53),
    FPR_TW(0x1.896172p-3, 0x1.f10602p-29, -0x1.ec0254p-54),
    FPR_TW(0x1.fd60d2p-1, 0x1.b4eb94p-26, -0x1.f6490ap-53),
    FPR_TW(0x1.9dfb6ep-4, 0x1.64950cp-29, -0x1.e1694cp-55),
    FPR_TW(-0x1.9dfb6ep-4, -0x1.64950cp-29, 0x1.e1694cp-55),
    FPR_TW(0x1.fd60d2p-1, 0x1.b4eb94p-26, -0x1.f6490ap-53),
    FPR_TW(0x1.4397f6p-1, -0x1.356f2p-27, -0x1.7274cap-55),
    FPR_TW(0x1.8cc6a8p-1, -0x1.5cf736p-26, 0x1.21e74cp-51),
    FPR_TW(-0x1.8cc6a8p-1, 0x1.5cf736p-26, -0x1.21e74cp-51),
    FPR_TW(0x1.4397f6p-1, -0x1.356f2p-27, -0x1.7274cap-55),
    FPR_TW(0x1.c2cd14p-1, 0x1.263c7ep-26, 0x1.259c6p-53),
    FPR_TW(0x1.e57a86p-2, 0x1.a79b04p-27, 0x1.369bfap-52),
    FPR_TW(-0x1.e57a86p-2, -0x1.a79b04p-27, -0x1.369bfap-52),
    FPR_TW(0x1.c2cd14p-1, 0x1.263c7ep-26, 0x1.259c6p-53),
    FPR_TW(0x1.263e6ap-2, -0x1.aaaad2p-28, 0x1.23a6a2p-53),
    FPR_TW(0x1.ea683ap-1, -0x1.8335p-26, -0x1.46725ap-56),
    FPR_TW(-0x1.ea683ap-1, 0x1.8335p-26, 0x1.46725ap-56),
    FPR_TW(0x1.263e6ap-2, -0x1.aaaad2p-28, 0x1.23a6a2p-53),
    FPR_TW(0x1.e97ec4p-1, -0x1.3fd29ap-26, 0x1.5bc486p-55),
    FPR_TW(0x1.2c41a4p-2, 0x1.d2a8a4p-27, 0x1.9cf036p-56),
    FPR_TW(-0x1.2c41a4p-2, -0x1.d2a8a4p-27, -0x1.9cf036p-56),
    FPR_TW(0x1.e97ec4p-1, -0x1.3fd29ap-26, 0x1.5bc486p-55),
    FPR_TW(0x1.dfeff6p-2, 0x1.aa5078p-28, -0x1.34ead8p-53),
    FPR_TW(0x1.c44834p-1, -0x1.d7c8p-26, 0x1.091f02p-51),
    FPR_TW(-0x1.c44834p-1, 0x1.d7c8p-26, -0x1.091f02p-51),
    FPR_TW(0x1.dfeff6p-2, 0x1.aa5078p-28, -0x1.34ead8p-53),
    FPR_TW(0x1.8ac872p-1, -0x1.21e278p-29, -0x1.9afaa6p-55),
    FPR_TW(0x1.4605a6p-1, 0x1.256654p-26, 0x1.243944p-52),
    FPR_TW(-0x1.4605a6p-1, -0x1.256654p-26, -0x1.243944p-52),
    FPR_TW(0x1.8ac872p-1, -0x1.21e278p-29, -0x1.9afaa6p-55),
    FPR_TW(0x1.84f872p-4, -0x1.a7d9ecp-29, 0x1.0cec8ap-57),
    FPR_TW(0x1.fdafa8p-1, -0x1.5d758ep-26, -0x1.fc4d08p-52),
    FPR_TW(-0x1.fdafa8p-1, 0x1.5d758ep-26, 0x1.fc4d08p-52),
    FPR_TW(0x1.84f872p-4, -0x1.a7d9ecp-29, 0x1.0cec8ap-57),
    FPR_TW(0x1.ff4dc6p-1, -0x1.69c826p-26, 0x1.47dd2cp-52),
    FPR_TW(0x1.ab101cp-5, -0x1.503e74p-32, -0x1.597186p-57),
    FPR_TW(-0x1.ab101cp-5, 0x1.503e74p-32, 0x1.597186p-57),
    FPR_TW(0x1.ff4dc6p-1, -0x1.69c826p-26, 0x1.47dd2cp-52),
    FPR_TW(0x1.56ac36p-1, -0x1.cd136cp-26, -0x1.7de1dp-53),
    FPR_TW(0x1.7c6b8ap-1, -0x1.8e9666p-28, -0x1.39fac6p-53),
    FPR_TW(-0x1.7c6b8ap-1, 0x1.8e9666p-28, 0x1.39fac6p-53),
    FPR_TW(0x1.56ac36p-1, -0x1.cd136cp-26, -0x1.7de1dp-53),
    FPR_TW(0x1.ce2b32p-1, 0x1.e66818p-27, -0x1.631d46p-56),
    FPR_TW(0x1.b8a782p-2, -0x1.60552ep-27, 0x1.b353ccp-53),
    FPR_TW(-0x1.b8a782p-2, 0x1.60552ep-27, -0x1.b353ccp-53),
    FPR_TW(0x1.ce2b32p-1, 0x1.e66818p-27, -0x1.631d46p-56),
    FPR_TW(0x1.560402p-2, -0x1.a1730ap-27, 0x1.1a0e0cp-52),
    FPR_TW(0x1.e298f4p-1, 0x1.0e465ep-27, 0x1.0f4274p-52),
    FPR_TW(-0x1.e298f4p-1, -0x1.0e465ep-27, -0x1.0f4274p-52),
    FPR_TW(0x1.560402p-2, -0x1.a1730ap-27, 0x1.1a0e0cp-52),
    FPR_TW(0x1.f045a2p-1, -0x1.66118ep-26, -0x1.1a52c4p-51),
    FPR_TW(0x1.f7b748p-3, 0x1.7a7004p-32, -0x1.9a96dap-57),
    FPR_TW(-0x1.f7b748p-3, -0x1.7a7004p-32, 0x1.9a96dap-57),
    FPR_TW(0x1.f045a2p-1, -0x1.66118ep-26, -0x1.1a52c4p-51),
    FPR_TW(0x1.05df3ep-1, 0x1.863716p-26, 0x1.b8748ep-51),
    FPR_TW(0x1.b7f668p-1, 0x1.b9e4bap-27, 0x1.61d996p-53),
    FPR_TW(-0x1.b7f668p-1, -0x1.b9e4bap-27, -0x1.61d996p-53),
    FPR_TW(0x1.05df3ep-1, 0x1.863716p-26, 0x1.b8748ep-51),
    FPR_TW(0x1.9a4dfap-1, 0x1.0ac1acp-27, 0x1.cfac92p-53),
    FPR_TW(0x1.32421ep-1, 0x1.8934c4p-26, -0x1.4d0ed2p-54),
    FPR_TW(-0x1.32421ep-1, -0x1.8934c4p-26, 0x1.4d0ed2p-54),
    FPR_TW(0x1.9a4dfap-1, 0x1.0ac1acp-27, 0x1.cfac92p-53),
    FPR_TW(0x1.264994p-3, 0x1.bfa682p-28, -0x1.a58bb4p-53),
    FPR_TW(0x1.faafbcp-1, 0x1.619fbcp-26, -0x1.1e349cp-51),
    FPR_TW(-0x1.faafbcp-1, -0x1.619fbcp-26, 0x1.1e349cp-51),
    FPR_TW(0x1.264994p-3, 0x1.bfa682p-28, -0x1.a58bb4p-53),
    FPR_TW(0x1.fa39bap-1, 0x1.8f42f2p-26, 0x1.cd618ep-54),
    FPR_TW(0x1.32b7cp-3, -0x1.aeba56p-29, -0x1.6aed8ep-56),
    FPR_TW(-0x1.32b7cp-3, 0x1.aeba56p-29, 0x1.6aed8ep-56),
    FPR_TW(0x1.fa39bap-1, 0x1.8f42f2p-26, 0x1.cd618ep-54),
    FPR_TW(0x1.2fbc24p-1, 0x1.688202p-26, 0x1.476e92p-51),
    FPR_TW(0x1.9c2d12p-1, -0x1.e1f148p-26, 0x1.3b393ep-52),
    FPR_TW(-0x1.9c2d12p-1, 0x1.e1f148p-26, -0x1.3b393ep-52),
    FPR_TW(0x1.2fbc24p-1, 0x1.688202p-26, 0x1.476e92p-51),
    FPR_TW(0x1.b658f2p-1, -0x1.604878p-26, 0x1.c54ad4p-51),
    FPR_TW(0x1.089112p-1, 0x1.95846p-32, 0x1.3248dep-57),
    FPR_TW(-0x1.089112p-1, -0x1.95846p-32, -0x1.3248dep-57),
    FPR_TW(0x1.b658f2p-1, -0x1.604878p-26, 0x1.c54ad4p-51),
    FPR_TW(0x1.eb86b4p-3, 0x1.8b78d2p-29, -0x1.bfcde4p-57),
    FPR_TW(0x1.f1090cp-1, -0x1.bb385p-28, -0x1.6ea992p-53),
    FPR_TW(-0x1.f1090cp-1, 0x1.bb385p-28, 0x1.6ea992p-53),
    FPR_TW(0x1.eb86b4p-3, 0x1.8b78d2p-29, -0x1.bfcde4p-57),
    FPR_TW(0x1.e18a02p-1, 0x1.fb8cdcp-26, -0x1.af81d8p-51),
    FPR_TW(0x1.5bee78p-2, 0x1.73b676p-27, 0x1.879cd2p-52),
    FPR_TW(-0x1.5bee78p-2, -0x1.73b676p-27, -0x1.879cd2p-52),
    FPR_TW(0x1.e18a02p-1, 0x1.fb8cdcp-26, -0x1.af81d8p-51),
    FPR_TW(0x1.b2f972p-2, -0x1.267346p-29, -0x1.815a3ap-54),
    FPR_TW(0x1.cf830ep-1, 0x1.19c8dp-26, -0x1.57b92p-51),
    FPR_TW(-0x1.cf830ep-1, -0x1.19c8dp-26, 0x1.57b92p-51),
    FPR_TW(0x1.b2f972p-2, -0x1.267346p-29, -0x1.815a3ap-54),
    FPR_TW(0x1.7a4f7p-1, 0x1.efe5f4p-27, 0x1.2792eap-52),
    FPR_TW(0x1.59001ep-1, -0x1.411b84p-26, -0x1.9581e6p-54),
    FPR_TW(-0x1.59001ep-1, 0x1.411b84p-26, 0x1.9581e6p-54),
    FPR_TW(0x1.7a4f7p-1, 0x1.efe5f4p-27, 0x1.2792eap-52),
    FPR_TW(0x1.78dbaap-5, 0x1.61d1a2p-31, -0x1.14a0fp-56),
    FPR_TW(0x1.ff753cp-1, -0x1.391ba8p-27, 0x1.e83cdp-52),
    FPR_TW(-0x1.ff753cp-1, 0x1.391ba8p-27, -0x1.e83cdp-52),
    FPR_TW(0x1.78dbaap-5, 0x1.61d1a2p-31, -0x1.14a0fp-56),
    FPR_TW(0x1.ffce0ap-1, -0x1.8eacc4p-28, 0x1.4214eap-54),
    FPR_TW(0x1.c454f4p-6, 0x1.9ca764p-31, -0x1.bac7bp-57),
    FPR_TW(-0x1.c454f4p-6, -0x1.9ca764p-31, 0x1.bac7bp-57),
    FPR_TW(0x1.ffce0ap-1, -0x1.8eacc4p-28, 0x1.4214eap-54),
    FPR_TW(0x1.5fe7ccp-1, -0x1.0d4af8p-28, -0x1.fcb9ccp-55),
    FPR_TW(0x1.73e558p-1, 0x1.c0f328p-26, 0x1.b6673cp-53),
    FPR_TW(-0x1.73e558p-1, -0x1.c0f328p-26, -0x1.b6673cp-53),
    FPR_TW(0x1.5fe7ccp-1, -0x1.0d4af8p-28, -0x1.fcb9ccp-55),
    FPR_TW(0x1.d36fc8p-1, -0x1.0d010ap-27, 0x1.c8bcd2p-52),
    FPR_TW(0x1.a1d654p-2, 0x1.da856p-29, -0x1.0246dp-57),
    FPR_TW(-0x1.a1d654p-2, -0x1.da856p-29, 0x1.0246dp-57),
    FPR_TW(0x1.d36fc8p-1, -0x1.0d010ap-27, 0x1.c8bcd2p-52),
    FPR_TW(0x1.6d9986p-2, 0x1.c5065ap-29, 0x1.fdc6bep-54),
    FPR_TW(0x1.de416p-1, 0x1.edb1bp-26, 0x1.66fc48p-53),
    FPR_TW(-0x1.de416p-1, -0x1.edb1bp-26, -0x1.66fc48p-53),
    FPR_TW(0x1.6d9986p-2, 0x1.c5065ap-29, 0x1.fdc6bep-54),
    FPR_TW(0x1.f33686p-1, -0x1.715444p-27, 0x1.eb7868p-56),
    FPR_TW(0x1.c6d906p-3, -0x1.945164p-28, -0x1.8dfd96p-54),
    FPR_TW(-0x1.c6d906p-3, 0x1.945164p-28, 0x1.8dfd96p-54),
    FPR_TW(0x1.f33686p-1, -0x1.715444p-27, 0x1.eb7868p-56),
    FPR_TW(0x1.109724p-1, 0x1.1a152ap-26, 0x1.a85a78p-51),
    FPR_TW(0x1.b16742p-1, 0x1.49945ep-26, 0x1.2458f6p-51),
    FPR_TW(-0x1.b16742p-1, -0x1.49945ep-26, -0x1.2458f6p-51),
    FPR_TW(0x1.109724p-1, 0x1.1a152ap-26, 0x1.a85a78p-51),
    FPR_TW(0x1.a1b26ep-1, -0x1.a7eb14p-26, -0x1.ecf10cp-53),
    FPR_TW(0x1.2818bep-1, 0x1.e9a798p-26, -0x1.8f2p-51),
    FPR_TW(-0x1.2818bep-1, -0x1.e9a798p-26, 0x1.8f2p-51),
    FPR_TW(0x1.a1b26ep-1, -0x1.a7eb14p-26, -0x1.ecf10cp-53),
    FPR_TW(0x1.57f008p-3, 0x1.9532f8p-29, -0x1.cdee6ep-55),
    FPR_TW(0x1.f8ba74p-1, -0x1.069692p-26, 0x1.e258ep-51),
    FPR_TW(-0x1.f8ba74p-1, 0x1.069692p-26, -0x1.e258ep-51),
    FPR_TW(0x1.57f008p-3, 0x1.9532f8p-29, -0x1.cdee6ep-55),
    FPR_TW(0x1.fbf47p-1, 0x1.e151bp-26, 0x1.e944ep-51),
    FPR_TW(0x1.00ee8ap-3, 0x1.adf70cp-28, -0x1.34c60ap-53),
    FPR_TW(-0x1.00ee8ap-3, -0x1.adf70cp-28, 0x1.34c60ap-53),
    FPR_TW(0x1.fbf47p-1, 0x1.e151bp-26, 0x1.e944ep-51),
    FPR_TW(0x1.39c23ep-1, 0x1.eb1814p-28, 0x1.ec4fa4p-54),
    FPR_TW(0x1.94990ep-1, 0x1.d62536p-28, 0x1.a95328p-56),
    FPR_TW(-0x1.94990ep-1, -0x1.d62536p-28, -0x1.a95328p-56),
    FPR_TW(0x1.39c23ep-1, 0x1.eb1814p-28, 0x1.ec4fa4p-54),
    FPR_TW(0x1.bcb54cp-1, 0x1.61a464p-26, 0x1.c02822p-51),
    FPR_TW(0x1.fb7576p-2, -0x1.ed9692p-29, 0x1.d48046p-54),
    FPR_TW(-0x1.fb7576p-2, 0x1.ed9692p-29, -0x1.d48046p-54),
    FPR_TW(0x1.bcb54cp-1, 0x1.61a464p-26, 0x1.c02822p-51),
    FPR_TW(0x1.0e15b4p-2, 0x1.c2e93ap-27, -0x1.2b6ff6p-53),
    FPR_TW(0x1.eddeb6p-1, 0x1.40f0cap-26, 0x1.625432p-54),
    FPR_TW(-0x1.eddeb6p-1, -0x1.40f0cap-26, -0x1.625432p-54),
    FPR_TW(0x1.0e15b4p-2, 0x1.c2e93ap-27, -0x1.2b6ff6p-53),
    FPR_TW(0x1.e5a9d6p-1, -0x1.5f7306p-26, 0x1.97d432p-52),
    FPR_TW(0x1.44310ep-2, -0x1.bb6488p-29, 0x1.8b694ep-56),
    FPR_TW(-0x1.44310ep-2, 0x1.bb6488p-29, -0x1.8b694ep-56),
    FPR_TW(0x1.e5a9d6p-1, -0x1.5f7306p-26, 0x1.97d432p-52),
    FPR_TW(0x1.c997fcp-2, 0x1.c329c4p-29, 0x1.4eb504p-55),
    FPR_TW(0x1.ca08f2p-1, -0x1.918eeep-27, 0x1.af387ep-54),
    FPR_TW(-0x1.ca08f2p-1, 0x1.918eeep-27, -0x1.af387ep-54),
    FPR_TW(0x1.c997fcp-2, 0x1.c329c4p-29, 0x1.4eb504p-55),
    FPR_TW(0x1.82a9c2p-1, -0x1.81574p-26, -0x1.2cbd1p-53),
    FPR_TW(0x1.4f9cc2p-1, 0x1.732922p-27, -0x1.add29ap-53),
    FPR_TW(-0x1.4f9cc2p-1, -0x1.732922p-27, 0x1.add29ap-53),
    FPR_TW(0x1.82a9c2p-1, -0x1.81574p-26, -0x1.2cbd1p-53),
    FPR_TW(0x1.20c968p-4, -0x1.625776p-29, -0x1.bf3a92p-55),
    FPR_TW(0x1.feb9d2p-1, 0x1.4c1044p-27, -0x1.e62bd6p-54),
    FPR_TW(-0x1.feb9d2p-1, -0x1.4c1044p-27, 0x1.e62bd6p-54),
    FPR_TW(0x1.20c968p-4, -0x1.625776p-29, -0x1.bf3a92p-55),
    FPR_TW(0x1.fe7ea8p-1, 0x1.520b58p-27, 0x1.34b086p-56),
    FPR_TW(0x1.39d9f2p-4, -0x1.a74bacp-29, -0x1.beed78p-54),
    FPR_TW(-0x1.39d9f2p-4, 0x1.a74bacp-29, 0x1.beed78p-54),
    FPR_TW(0x1.fe7ea8p-1, 0x1.520b58p-27, 0x1.34b086p-56),
    FPR_TW(0x1.4d3bc6p-1, 0x1.ab13fp-26, -0x1.48d932p-54),
    FPR_TW(0x1.84b712p-1, -0x1.ca0f8p-26, -0x1.963a48p-51),
    FPR_TW(-0x1.84b712p-1, 0x1.ca0f8p-26, 0x1.963a48p-51),
    FPR_TW(0x1.4d3bc6p-1, 0x1.ab13fp-26, -0x1.48d932p-54),
    FPR_TW(0x1.c89f58p-1, 0x1.c0a704p-27, 0x1.85620ep-52),
    FPR_TW(0x1.cf34bap-2, 0x1.dc39a4p-27, 0x1.773c6ep-55),
    FPR_TW(-0x1.cf34bap-2, -0x1.dc39a4p-27, -0x1.773c6ep-55),
    FPR_TW(0x1.c89f58p-1, 0x1.c0a704p-27, 0x1.85620ep-52),
    FPR_TW(0x1.3e39bep-2, 0x1.2dd84ep-27, 0x1.60531cp-54),
    FPR_TW(0x1.e6a61cp-1, 0x1.5754eap-27, -0x1.a67c9ap-54),
    FPR_TW(-0x1.e6a61cp-1, -0x1.5754eap-27, 0x1.a67c9ap-54),
    FPR_TW(0x1.3e39bep-2, 0x1.2dd84ep-27, 0x1.60531cp-54),
    FPR_TW(0x1.ed0836p-1, -0x1.666ff6p-29, -0x1.d6cc5cp-54),
    FPR_TW(0x1.1423eep-2, 0x1.f8d27p-27, -0x1.edd2ccp-52),
    FPR_TW(-0x1.1423eep-2, -0x1.f8d27p-27, 0x1.edd2ccp-52),
    FPR_TW(0x1.ed0836p-1, -0x1.666ff6p-29, -0x1.d6cc5cp-54),
    FPR_TW(0x1.f5fdeep-2, 0x1.95b368p-28, 0x1.742034p-53),
    FPR_TW(0x1.be41b6p-1, 0x1.1154cp-29, 0x1.01192ap-54),
    FPR_TW(-0x1.be41b6p-1, -0x1.1154cp-29, -0x1.01192ap-54),
    FPR_TW(0x1.f5fdeep-2, 0x1.95b368p-28, 0x1.742034p-53),
    FPR_TW(0x1.92aa42p-1, -0x1.d2bf58p-32, -0x1.68f89ep-57),
    FPR_TW(0x1.3c3c44p-1, 0x1.3038a2p-26, 0x1.e4a166p-51),
    FPR_TW(-0x1.3c3c44p-1, -0x1.3038a2p-26, -0x1.e4a166p-51),
    FPR_TW(0x1.92aa42p-1, -0x1.d2bf58p-32, -0x1.68f89ep-57),
    FPR_TW(0x1.e8eb8p-4, -0x1.0daaep-31, -0x1.48dd64p-56),
    FPR_TW(0x1.fc56e4p-1, -0x1.209942p-27, -0x1.103ff8p-52),
    FPR_TW(-0x1.fc56e4p-1, 0x1.209942p-27, 0x1.103ff8p-52),
    FPR_TW(0x1.e8eb8p-4, -0x1.0daaep-31, -0x1.48dd64p-56),
    FPR_TW(0x1.f830f4p-1, 0x1.4818c2p-26, -0x1.f3d6bcp-52),
    FPR_TW(0x1.6451a8p-3, 0x1.8ec186p-30, 0x1.35a2cp-55),
    FPR_TW(-0x1.6451a8p-3, -0x1.8ec186p-30, -0x1.35a2cp-55),
    FPR_TW(0x1.f830f4p-1, 0x1.4818c2p-26, -0x1.f3d6bcp-52),
    FPR_TW(0x1.258734p-1, 0x1.976e22p-26, 0x1.3a3f0ap-57),
    FPR_TW(0x1.a38184p-1, 0x1.4b2778p-26, 0x1.6436d4p-51),
    FPR_TW(-0x1.a38184p-1, -0x1.4b2778p-26, -0x1.6436d4p-51),
    FPR_TW(0x1.258734p-1, 0x1.976e22p-26, 0x1.3a3f0ap-57),
    FPR_TW(0x1.afb8fep-1, -0x1.d82a12p-27, -0x1.fdc626p-53),
    FPR_TW(0x1.133e9cp-1, 0x1.fdc4aap-26, -0x1.3426fp-53),
    FPR_TW(-0x1.133e9cp-1, -0x1.fdc4aap-26, 0x1.3426fp-53),
    FPR_TW(0x1.afb8fep-1, -0x1.d82a12p-27, -0x1.fdc626p-53),
    FPR_TW(0x1.ba9634p-3, -0x1.61d44ap-28, -0x1.aea132p-54),
    FPR_TW(0x1.f3e6bcp-1, -0x1.f221cep-28, 0x1.15774cp-53),
    FPR_TW(-0x1.f3e6bcp-1, 0x1.f221cep-28, -0x1.15774cp-53),
    FPR_TW(0x1.ba9634p-3, -0x1.61d44ap-28, -0x1.aea132p-54),
    FPR_TW(0x1.dd1ffp-1, -0x1.8eadd4p-26, -0x1.9782f2p-51),
    FPR_TW(0x1.73763cp-2, 0x1.24c212p-27, 0x1.d5b9b6p-54),
    FPR_TW(-0x1.73763cp-2, -0x1.24c212p-27, -0x1.d5b9b6p-54),
    FPR_TW(0x1.dd1ffp-1, -0x1.8eadd4p-26, -0x1.9782f2p-51),
    FPR_TW(0x1.9c17d4p-2, 0x1.037e7cp-28, 0x1.1923c6p-53),
    FPR_TW(0x1.d4b5b2p-1, -0x1.39e2b8p-27, 0x1.f054ap-52),
    FPR_TW(-0x1.d4b5b2p-1, 0x1.39e2b8p-27, -0x1.f054ap-52),
    FPR_TW(0x1.9c17d4p-2, 0x1.037e7cp-28, 0x1.1923c6p-53),
    FPR_TW(0x1.71bacap-1, -0x1.3e37c8p-26, -0x1.370b1cp-53),
    FPR_TW(0x1.622e44p-1, 0x1.fd846p-26, -0x1.819c9ep-54),
    FPR_TW(-0x1.622e44p-1, -0x1.fd846p-26, 0x1.819c9ep-54),
    FPR_TW(0x1.71bacap-1, -0x1.3e37c8p-26, -0x1.370b1cp-53),
    FPR_TW(0x1.5fd4d2p-6, 0x1.fab226p-34, -0x1.0c0a92p-61),
    FPR_TW(0x1.ffe1c6p-1, 0x1.0e196ep-26, 0x1.d89aa2p-51),
    FPR_TW(-0x1.ffe1c6p-1, -0x1.0e196ep-26, -0x1.d89aa2p-51),
    FPR_TW(0x1.5fd4d2p-6, 0x1.fab226p-34, -0x1.0c0a92p-61),
    FPR_TW(0x1.fff094p-1, 0x1.e29de8p-28, 0x1.5c633p-54),
    FPR_TW(0x1.f6a296p-7, 0x1.5732fap-32, -0x1.5f2944p-57),
    FPR_TW(-0x1.f6a296p-7, -0x1.5732fap-32, 0x1.5f2944p-57),
    FPR_TW(0x1.fff094p-1, 0x1.e29de8p-28, 0x1.5c633p-54),
    FPR_TW(0x1.647154p-1, 0x1.bfa9aep-28, -0x1.5f0e68p-53),
    FPR_TW(0x1.6f8caap-1, -0x1.8da922p-27, -0x1.60dd18p-52),
    FPR_TW(-0x1.6f8caap-1, 0x1.8da922p-27, 0x1.60dd18p-52),
    FPR_TW(0x1.647154p-1, 0x1.bfa9aep-28, -0x1.5f0e68p-53),
    FPR_TW(0x1.d5f718p-1, -0x1.aeeebp-26, -0x1.5a199p-53),
    FPR_TW(0x1.96555cp-2, -0x1.0a8d6ep-27, -0x1.428158p-55),
    FPR_TW(-0x1.96555cp-2, 0x1.0a8d6ep-27, 0x1.428158p-55),
    FPR_TW(0x1.d5f718p-1, -0x1.aeeebp-26, -0x1.5a199p-53),
    FPR_TW(0x1.794f5ep-2, 0x1.84f7ecp-28, -0x1.cfbeb6p-54),
    FPR_TW(0x1.dbf9e4p-1, 0x1.cabacep-28, -0x1.89c024p-53),
    FPR_TW(-0x1.dbf9e4p-1, -0x1.cabacep-28, 0x1.89c024p-53),
    FPR_TW(0x1.794f5ep-2, 0x1.84f7ecp-28, -0x1.cfbeb6p-54),
    FPR_TW(0x1.f4922p-1, 0x1.af2aeep-27, -0x1.c5c2dcp-52),
    FPR_TW(0x1.ae4f1ep-3, -0x1.4188cap-28, -0x1.255744p-53),
    FPR_TW(-0x1.ae4f1ep-3, 0x1.4188cap-28, 0x1.255744p-53),
    FPR_TW(0x1.f4922p-1, 0x1.af2aeep-27, -0x1.c5c2dcp-52),
    FPR_TW(0x1.15e36ep-1, 0x1.36f8bp-27, -0x1.ec3abap-52),
    FPR_TW(0x1.ae069p-1, -0x1.974262p-26, -0x1.26726ap-53),
    FPR_TW(-0x1.ae069p-1, 0x1.974262p-26, 0x1.26726ap-53),
    FPR_TW(0x1.15e36ep-1, 0x1.36f8bp-27, -0x1.ec3abap-52),
    FPR_TW(0x1.a54c92p-1, -0x1.ede15cp-26, 0x1.91843p-52),
    FPR_TW(0x1.22f2d6p-1, 0x1.8b04f8p-27, 0x1.8a8ce2p-53),
    FPR_TW(-0x1.22f2d6p-1, -0x1.8b04f8p-27, -0x1.8a8ce2p-53),
    FPR_TW(0x1.a54c92p-1, -0x1.ede15cp-26, 0x1.91843p-52),
    FPR_TW(0x1.70afd8p-3, 0x1.a118ap-28, -0x1.6cf9ep-56),
    FPR_TW(0x1.f7a29ap-1, -0x1.f2e6eap-28, -0x1.d231cep-53),
    FPR_TW(-0x1.f7a29ap-1, 0x1.f2e6eap-28, 0x1.d231cep-53),
    FPR_TW(0x1.70afd8p-3, 0x1.a118ap-28, -0x1.6cf9ep-56),
    FPR_TW(0x1.fcb47p-1, 0x1.c8a1aap-28, 0x1.126aa8p-55),
    FPR_TW(0x1.cff534p-4, -0x1.33e09p-30, 0x1.31fdd8p-56),
    FPR_TW(-0x1.cff534p-4, 0x1.33e09p-30, -0x1.31fdd8p-56),
    FPR_TW(0x1.fcb47p-1, 0x1.c8a1aap-28, 0x1.126aa8p-55),
    FPR_TW(0x1.3eb33ep-1, 0x1.57c0dp-26, 0x1.86a236p-58),
    FPR_TW(0x1.90b794p-1, 0x1.abaf8p-28, -0x1.eb135p-53),
    FPR_TW(-0x1.90b794p-1, -0x1.abaf8p-28, 0x1.eb135p-53),
    FPR_TW(0x1.3eb33ep-1, 0x1.57c0dp-26, 0x1.86a236p-58),
    FPR_TW(0x1.bfc9d2p-1, 0x1.686c52p-27, -0x1.0151cp-53),
    FPR_TW(0x1.f0819p-2, 0x1.affep-28, -0x1.299566p-53),
    FPR_TW(-0x1.f0819p-2, -0x1.affep-28, 0x1.299566p-53),
    FPR_TW(0x1.bfc9d2p-1, 0x1.686c52p-27, -0x1.0151cp-53),
    FPR_TW(0x1.1a2f8p-2, -0x1.05c37p-28, 0x1.ac8cb6p-53),
    FPR_TW(0x1.ec2cf4p-1, 0x1.635ed6p-26, 0x1.0269dcp-52),
    FPR_TW(-0x1.ec2cf4p-1, -0x1.635ed6p-26, -0x1.0269dcp-52),
    FPR_TW(0x1.1a2f8p-2, -0x1.05c37p-28, 0x1.ac8cb6p-53),
    FPR_TW(0x1.e79db2p-1, 0x1.34a2ccp-26, -0x1.8baf38p-51),
    FPR_TW(0x1.383f5ep-2, 0x1.a9db56p-29, -0x1.6a04aap-54),
    FPR_TW(-0x1.383f5ep-2, -0x1.a9db56p-29, 0x1.6a04aap-54),
    FPR_TW(0x1.e79db2p-1, 0x1.34a2ccp-26, -0x1.8baf38p-51),
    FPR_TW(0x1.d4cd02p-2, 0x1.750c14p-27, -0x1.937f34p-53),
    FPR_TW(0x1.c73158p-1, 0x1.33d55ap-26, 0x1.b99068p-51),
    FPR_TW(-0x1.c73158p-1, -0x1.33d55ap-26, -0x1.b99068p-51),
    FPR_TW(0x1.d4cd02p-2, 0x1.750c14p-27, -0x1.937f34p-53),
    FPR_TW(0x1.86c0a2p-1, -0x1.32af36p-28, 0x1.06115ap-53),
    FPR_TW(0x1.4ad796p-1, -0x1.d31ba2p-26, 0x1.76c628p-54),
    FPR_TW(-0x1.4ad796p-1, 0x1.d31ba2p-26, -0x1.76c628p-54),
    FPR_TW(0x1.86c0a2p-1, -0x1.32af36p-28, 0x1.06115ap-53),
    FPR_TW(0x1.52e774p-4, 0x1.49a9a2p-29, -0x1.793448p-54),
    FPR_TW(0x1.fe3e92p-1, 0x1.7d3b1p-26, 0x1.86bfacp-51),
    FPR_TW(-0x1.fe3e92p-1, -0x1.7d3b1p-26, -0x1.86bfacp-51),
    FPR_TW(0x1.52e774p-4, 0x1.49a9a2p-29, -0x1.793448p-54),
    FPR_TW(0x1.fef01p-1, 0x1.4130c8p-28, 0x1.2787d4p-53),
    FPR_TW(0x1.07b614p-4, 0x1.c8c60cp-29, 0x1.d8f60ep-55),
    FPR_TW(-0x1.07b614p-4, -0x1.c8c60cp-29, -0x1.d8f60ep-55),
    FPR_TW(0x1.fef01p-1, 0x1.4130c8p-28, 0x1.2787d4p-53),
    FPR_TW(0x1.51fa82p-1, -0x1.9332aep-28, 0x1.ffad98p-53),
    FPR_TW(0x1.8098b8p-1, -0x1.5235ap-26, -0x1.66ec92p-51),
    FPR_TW(-0x1.8098b8p-1, 0x1.5235ap-26, 0x1.66ec92p-51),
    FPR_TW(0x1.51fa82p-1, -0x1.9332aep-28, 0x1.ffad98p-53),
    FPR_TW(0x1.cb6e2p-1, 0x1.401b54p-26, -0x1.d4fb24p-51),
    FPR_TW(0x1.c3f6d4p-2, 0x1.c98c4ap-28, 0x1.671ef4p-54),
    FPR_TW(-0x1.c3f6d4p-2, -0x1.c98c4ap-28, -0x1.671ef4p-54),
    FPR_TW(0x1.cb6e2p-1, 0x1.401b54p-26, -0x1.d4fb24p-51),
    FPR_TW(0x1.4a253ep-2, -0x1.dc8fa2p-27, 0x1.76a82ep-53),
    FPR_TW(0x1.e4a8ep-1, -0x1.f8c686p-31, -0x1.7950f2p-56),
    FPR_TW(-0x1.e4a8ep-1, 0x1.f8c686p-31, 0x1.7950f2p-56),
    FPR_TW(0x1.4a253ep-2, -0x1.dc8fa2p-27, 0x1.76a82ep-53),
    FPR_TW(0x1.eeb074p-1, 0x1.8a14a8p-26, 0x1.1d926p-51),
    FPR_TW(0x1.0804ep-2, 0x1.7ad988p-28, -0x1.aac6ap-54),
    FPR_TW(-0x1.0804ep-2, -0x1.7ad988p-28, 0x1.aac6ap-54),
    FPR_TW(0x1.eeb074p-1, 0x1.8a14a8p-26, 0x1.1d926p-51),
    FPR_TW(0x1.00740cp-1, 0x1.05705cp-26, 0x1.495bd4p-54),
    FPR_TW(0x1.bb249ap-1, 0x1.6d881ap-30, -0x1.d6318ep-58),
    FPR_TW(-0x1.bb249ap-1, -0x1.6d881ap-30, 0x1.d6318ep-58),
    FPR_TW(0x1.00740cp-1, 0x1.05705cp-26, 0x1.495bd4p-54),
    FPR_TW(0x1.9683f4p-1, 0x1.5ebffp-28, 0x1.ddc8a4p-54),
    FPR_TW(0x1.374532p-1, -0x1.1fa01cp-27, -0x1.57765ap-52),
    FPR_TW(-0x1.374532p-1, 0x1.1fa01cp-27, 0x1.57765ap-52),
    FPR_TW(0x1.9683f4p-1, 0x1.5ebffp-28, 0x1.ddc8a4p-54),
    FPR_TW(0x1.0d64dcp-3, -0x1.a6cc3ep-30, 0x1.d1d8b6p-55),
    FPR_TW(0x1.fb8d18p-1, 0x1.acd5b6p-26, 0x1.b17a4cp-51),
    FPR_TW(-0x1.fb8d18p-1, -0x1.acd5b6p-26, -0x1.b17a4cp-51),
    FPR_TW(0x1.0d64dcp-3, -0x1.a6cc3ep-30, 0x1.d1d8b6p-55),
    FPR_TW(0x1.f93f14p-1, 0x1.f0b58p-26, 0x1.e302eap-51),
    FPR_TW(0x1.4b8b18p-3, -0x1.0c0afp-32, 0x1.b534fep-57),
    FPR_TW(-0x1.4b8b18p-3, 0x1.0c0afp-32, -0x1.b534fep-57),
    FPR_TW(0x1.f93f14p-1, 0x1.f0b58p-26, 0x1.e302eap-51),
    FPR_TW(0x1.2aa76ep-1, 0x1.0f5d6cp-26, -0x1.fe02ap-51),
    FPR_TW(0x1.9fdf5p-1, -0x1.d9d6c4p-26, -0x1.b864a2p-53),
    FPR_TW(-0x1.9fdf5p-1, 0x1.d9d6c4p-26, 0x1.b864a2p-53),
    FPR_TW(0x1.2aa76ep-1, 0x1.0f5d6cp-26, -0x1.fe02ap-51),
    FPR_TW(0x1.b3115ap-1, 0x1.7cdefcp-27, 0x1.bbbc4ep-52),
    FPR_TW(0x1.0ded0cp-1, -0x1.ed0ed2p-27, -0x1.30a82p-52),
    FPR_TW(-0x1.0ded0cp-1, 0x1.ed0ed2p-27, 0x1.30a82p-52),
    FPR_TW(0x1.b3115ap-1, 0x1.7cdefcp-27, 0x1.bbbc4ep-52),
    FPR_TW(0x1.d31774p-3, 0x1.a597bep-28, -0x1.b408dcp-55),
    FPR_TW(0x1.f2818p-1, -0x1.dcfb1ap-28, 0x1.88b81cp-53),
    FPR_TW(-0x1.f2818p-1, 0x1.dcfb1ap-28, -0x1.88b81cp-53),
    FPR_TW(0x1.d31774p-3, 0x1.a597bep-28, -0x1.b408dcp-55),
    FPR_TW(0x1.df5e36p-1, 0x1.5374b4p-26, -0x1.07807ep-51),
    FPR_TW(0x1.67b94ap-2, -0x1.a94e1ap-29, -0x1.688cdap-54),
    FPR_TW(-0x1.67b94ap-2, 0x1.a94e1ap-29, 0x1.688cdap-54),
    FPR_TW(0x1.df5e36p-1, 0x1.5374b4p-26, -0x1.07807ep-51),
    FPR_TW(0x1.a790cep-2, -0x1.84819cp-27, -0x1.4bfbc4p-52),
    FPR_TW(0x1.d2255cp-1, 0x1.b96938p-27, 0x1.176b2cp-54),
    FPR_TW(-0x1.d2255cp-1, -0x1.b96938p-27, -0x1.176b2cp-54),
    FPR_TW(0x1.a790cep-2, -0x1.84819cp-27, -0x1.4bfbc4p-52),
    FPR_TW(0x1.760c52p-1, 0x1.8608ecp-26, 0x1.ddc512p-52),
    FPR_TW(0x1.5d9deep-1, 0x1.cf8d16p-27, 0x1.f10f74p-52),
    FPR_TW(-0x1.5d9deep-1, -0x1.cf8d16p-27, -0x1.f10f74p-52),
    FPR_TW(0x1.760c52p-1, 0x1.8608ecp-26, 0x1.ddc512p-52),
    FPR_TW(0x1.14685ep-5, -0x1.2f4fap-31, -0x1.4a2434p-57),
    FPR_TW(0x1.ffb55ep-1, 0x1.097f6cp-27, -0x1.a49604p-53),
    FPR_TW(-0x1.ffb55ep-1, -0x1.097f6cp-27, 0x1.a49604p-53),
    FPR_TW(0x1.14685ep-5, -0x1.2f4fap-31, -0x1.4a2434p-57),
    FPR_TW(0x1.ff97c4p-1, 0x1.04600ap-28, 0x1.52ab2cp-57),
    FPR_TW(0x1.46a396p-5, 0x1.ff0c3p-30, -0x1.bbb254p-55),
    FPR_TW(-0x1.46a396p-5, -0x1.ff0c3p-30, 0x1.bbb254p-55),
    FPR_TW(0x1.ff97c4p-1, 0x1.04600ap-28, 0x1.52ab2cp-57),
    FPR_TW(0x1.5b50b2p-1, 0x1.93dd12p-27, 0x1.519d3p-56),
    FPR_TW(0x1.782fb2p-1, -0x1.1bd32ap-27, 0x1.583728p-52),
    FPR_TW(-0x1.782fb2p-1, 0x1.1bd32ap-27, -0x1.583728p-52),
    FPR_TW(0x1.5b50b2p-1, 0x1.93dd12p-27, 0x1.519d3p-56),
    FPR_TW(0x1.d0d672p-1, 0x1.eb3a58p-26, -0x1.dc83p-51),
    FPR_TW(0x1.ad4732p-2, -0x1.b4647ep-27, -0x1.c4de7cp-52),
    FPR_TW(-0x1.ad4732p-2, 0x1.b4647ep-27, 0x1.c4de7cp-52),
    FPR_TW(0x1.d0d672p-1, 0x1.eb3a58p-26, -0x1.dc83p-51),
    FPR_TW(0x1.61d596p-2, -0x1.bb9efep-29, -0x1.825388p-54),
    FPR_TW(0x1.e0766ep-1, -0x1.b5fc2ap-27, -0x1.c1766ep-52),
    FPR_TW(-0x1.e0766ep-1, 0x1.b5fc2ap-27, 0x1.c1766ep-52),
    FPR_TW(0x1.61d596p-2, -0x1.bb9efep-29, -0x1.825388p-54),
    FPR_TW(0x1.f1c7acp-1, -0x1.d7b8f8p-29, 0x1.504b8p-55),
    FPR_TW(0x1.df5164p-3, -0x1.fdecccp-32, -0x1.01f7d8p-57),
    FPR_TW(-0x1.df5164p-3, 0x1.fdecccp-32, 0x1.01f7d8p-57),
    FPR_TW(0x1.f1c7acp-1, -0x1.d7b8f8p-29, 0x1.504b8p-55),
    FPR_TW(0x1.0b4058p-1, 0x1.e3e17ap-27, 0x1.ca5328p-52),
    FPR_TW(0x1.b4b74p-1, 0x1.3bcf24p-26, 0x1.4fa712p-51),
    FPR_TW(-0x1.b4b74p-1, -0x1.3bcf24p-26, -0x1.4fa712p-51),
    FPR_TW(0x1.0b4058p-1, 0x1.e3e17ap-27, 0x1.ca5328p-52),
    FPR_TW(0x1.9e082ep-1, 0x1.b6848ep-26, 0x1.0ac04ep-52),
    FPR_TW(0x1.2d333ep-1, -0x1.962c8ap-26, 0x1.ef1d3ep-51),
    FPR_TW(-0x1.2d333ep-1, 0x1.962c8ap-26, -0x1.ef1d3ep-51),
    FPR_TW(0x1.9e082ep-1, 0x1.b6848ep-26, 0x1.0ac04ep-52),
    FPR_TW(0x1.3f22f6p-3, -0x1.0496eep-28, 0x1.8dff4p-54),
    FPR_TW(0x1.f9bed8p-1, -0x1.8210ecp-28, 0x1.932938p-54),
    FPR_TW(-0x1.f9bed8p-1, 0x1.8210ecp-28, -0x1.932938p-54),
    FPR_TW(0x1.3f22f6p-3, -0x1.0496eep-28, 0x1.8dff4p-54),
    FPR_TW(0x1.fb20dcp-1, 0x1.a07554p-27, -0x1.bfe292p-52),
    FPR_TW(0x1.19d894p-3, 0x1.7c49cep-32, 0x1.e8dcdcp-58),
    FPR_TW(-0x1.19d894p-3, -0x1.7c49cep-32, -0x1.e8dcdcp-58),
    FPR_TW(0x1.fb20dcp-1, 0x1.a07554p-27, -0x1.bfe292p-52),
    FPR_TW(0x1.34c526p-1, -0x1.a7d644p-26, 0x1.560fd2p-53),
    FPR_TW(0x1.986afp-1, -0x1.d7514ep-26, 0x1.ca1f84p-52),
    FPR_TW(-0x1.986afp-1, 0x1.d7514ep-26, -0x1.ca1f84p-52),
    FPR_TW(0x1.34c526p-1, -0x1.a7d644p-26, 0x1.560fd2p-53),
    FPR_TW(0x1.b98fa2p-1, -0x1.37550ep-32, 0x1.55640ep-57),
    FPR_TW(0x1.032ae6p-1, -0x1.42484ep-26, 0x1.6424fep-51),
    FPR_TW(-0x1.032ae6p-1, 0x1.42484ep-26, -0x1.6424fep-51),
    FPR_TW(0x1.b98fa2p-1, -0x1.37550ep-32, 0x1.55640ep-57),
    FPR_TW(0x1.01f18p-2, 0x1.ae7f74p-28, 0x1.aedfb2p-54),
    FPR_TW(0x1.ef7d6ep-1, 0x1.4728fp-27, -0x1.a3c67cp-55),
    FPR_TW(-0x1.ef7d6ep-1, -0x1.4728fp-27, 0x1.a3c67cp-55),
    FPR_TW(0x1.01f18p-2, 0x1.ae7f74p-28, 0x1.aedfb2p-54),
    FPR_TW(0x1.e3a33ep-1, 0x1.8eb9dp-26, 0x1.451422p-51),
    FPR_TW(0x1.50163ep-2, -0x1.f347dcp-29, -0x1.ec66ccp-56),
    FPR_TW(-0x1.50163ep-2, 0x1.f347dcp-29, 0x1.ec66ccp-56),
    FPR_TW(0x1.e3a33ep-1, 0x1.8eb9dp-26, 0x1.451422p-51),
    FPR_TW(0x1.be5152p-2, -0x1.0007e4p-27, -0x1.ad4998p-52),
    FPR_TW(0x1.cccee2p-1, 0x1.85bd4p-30, -0x1.d3116ap-55),
    FPR_TW(-0x1.cccee2p-1, -0x1.85bd4p-30, 0x1.d3116ap-55),
    FPR_TW(0x1.be5152p-2, -0x1.0007e4p-27, -0x1.ad4998p-52),
    FPR_TW(0x1.7e83f8p-1, 0x1.ec0da2p-27, -0x1.e49e58p-53),
    FPR_TW(0x1.5455p-1, -0x1.5d4c4p-26, -0x1.14e248p-51),
    FPR_TW(-0x1.5455p-1, 0x1.5d4c4p-26, 0x1.14e248p-51),
    FPR_TW(0x1.7e83f8p-1, 0x1.ec0da2p-27, -0x1.e49e58p-53),
    FPR_TW(0x1.dd407p-5, -0x1.9fdc4ep-31, 0x1.08989ep-57),
    FPR_TW(0x1.ff2162p-1, -0x1.63d9c2p-26, -0x1.bbcd26p-52),
    FPR_TW(-0x1.ff2162p-1, 0x1.63d9c2p-26, 0x1.bbcd26p-52),
    FPR_TW(0x1.dd407p-5, -0x1.9fdc4ep-31, 0x1.08989ep-57),
    FPR_TW(0x1.fdf992p-1, 0x1.7b9984p-28, -0x1.9687d6p-54),
    FPR_TW(0x1.6bf1b4p-4, -0x1.864ed8p-32, 0x1.75a492p-57),
    FPR_TW(-0x1.6bf1b4p-4, 0x1.864ed8p-32, -0x1.75a492p-57),
    FPR_TW(0x1.fdf992p-1, 0x1.7b9984p-28, -0x1.9687d6p-54),
    FPR_TW(0x1.487034p-1, -0x1.f3edcp-26, -0x1.170814p-53),
    FPR_TW(0x1.88c66ep-1, 0x1.d206e8p-27, 0x1.a8e776p-54),
    FPR_TW(-0x1.88c66ep-1, -0x1.d206e8p-27, -0x1.a8e776p-54),
    FPR_TW(0x1.487034p-1, -0x1.f3edcp-26, -0x1.170814p-53),
    FPR_TW(0x1.c5bef6p-1, -0x1.8041eap-27, 0x1.f07aep-53),
    FPR_TW(0x1.da60c6p-2, -0x1.82f794p-29, 0x1.bc31c8p-55),
    FPR_TW(-0x1.da60c6p-2, 0x1.82f794p-29, -0x1.bc31c8p-55),
    FPR_TW(0x1.c5bef6p-1, -0x1.8041eap-27, 0x1.f07aep-53),
    FPR_TW(0x1.3241fcp-2, -0x1.38e8aap-27, -0x1.f0988cp-55),
    FPR_TW(0x1.e89096p-1, -0x1.14a7f6p-27, -0x1.ab4998p-52),
    FPR_TW(-0x1.e89096p-1, 0x1.14a7f6p-27, 0x1.ab4998p-52),
    FPR_TW(0x1.3241fcp-2, -0x1.38e8aap-27, -0x1.f0988cp-55),
    FPR_TW(0x1.eb4cf6p-1, -0x1.d48efep-26, 0x1.195da2p-53),
    FPR_TW(0x1.203858p-2, 0x1.eb93dep-29, 0x1.c72c66p-54),
    FPR_TW(-0x1.203858p-2, -0x1.eb93dep-29, -0x1.c72c66p-54),
    FPR_TW(0x1.eb4cf6p-1, -0x1.d48efep-26, 0x1.195da2p-53),
    FPR_TW(0x1.eb006ap-2, -0x1.41b53cp-27, 0x1.53c9fep-56),
    FPR_TW(0x1.c14d9ep-1, -0x1.dcd0d4p-28, -0x1.18e4a4p-54),
    FPR_TW(-0x1.c14d9ep-1, 0x1.dcd0d4p-28, 0x1.18e4a4p-54),
    FPR_TW(0x1.eb006ap-2, -0x1.41b53cp-27, 0x1.53c9fep-56),
    FPR_TW(0x1.8ec10ap-1, -0x1.2de4eep-27, 0x1.8d357p-54),
    FPR_TW(0x1.412726p-1, 0x1.8f4424p-27, -0x1.dc8832p-52),
    FPR_TW(-0x1.412726p-1, -0x1.8f4424p-27, 0x1.dc8832p-52),
    FPR_TW(0x1.8ec10ap-1, -0x1.2de4eep-27, 0x1.8d357p-54),
    FPR_TW(0x1.b6fa6ep-4, 0x1.871ecap-29, -0x1.c4944ep-55),
    FPR_TW(0x1.fd0d16p-1, -0x1.c9e7dep-27, -0x1.347d2cp-54),
    FPR_TW(-0x1.fd0d16p-1, 0x1.c9e7dep-27, 0x1.347d2cp-54),
    FPR_TW(0x1.b6fa6ep-4, 0x1.871ecap-29, -0x1.c4944ep-55),
    FPR_TW(0x1.f70f64p-1, 0x1.a5bf5cp-28, -0x1.ba2288p-54),
    FPR_TW(0x1.7d0a7cp-3, -0x1.0b4d3ap-29, 0x1.c60dfep-54),
    FPR_TW(-0x1.7d0a7cp-3, 0x1.0b4d3ap-29, -0x1.c60dfep-54),
    FPR_TW(0x1.f70f64p-1, 0x1.a5bf5cp-28, -0x1.ba2288p-54),
    FPR_TW(0x1.205baap-1, 0x1.7560d6p-29, 0x1.b7b144p-56),
    FPR_TW(0x1.a7138ep-1, -0x1.629f0cp-29, 0x1.072a3ep-54),
    FPR_TW(-0x1.a7138ep-1, 0x1.629f0cp-29, -0x1.072a3ep-54),
    FPR_TW(0x1.205baap-1, 0x1.7560d6p-29, 0x1.b7b144p-56),
    FPR_TW(0x1.ac4ffcp-1, -0x1.60829cp-28, -0x1.818504p-56),
    FPR_TW(0x1.188592p-1, -0x1.8b7236p-30, -0x1.bbefe6p-56),
    FPR_TW(-0x1.188592p-1, 0x1.8b7236p-30, 0x1.bbefe6p-56),
    FPR_TW(0x1.ac4ffcp-1, -0x1.60829cp-28, -0x1.818504p-56),
    FPR_TW(0x1.a203e2p-3, -0x1.39f38ap-29, 0x1.1c1aaep-54),
    FPR_TW(0x1.f538b2p-1, -0x1.434be4p-31, -0x1.5f7cd6p-59),
    FPR_TW(-0x1.f538b2p-1, 0x1.434be4p-31, 0x1.5f7cd6p-59),
    FPR_TW(0x1.a203e2p-3, -0x1.39f38ap-29, 0x1.1c1aaep-54),
    FPR_TW(0x1.dacf42p-1, 0x1.9cd158p-26, -0x1.cff46cp-51),
    FPR_TW(0x1.7f24dep-2, -0x1.9197c4p-27, 0x1.093c8ep-52),
    FPR_TW(-0x1.7f24dep-2, 0x1.9197c4p-27, -0x1.093c8ep-52),
    FPR_TW(0x1.dacf42p-1, 0x1.9cd158p-26, -0x1.cff46cp-51),
    FPR_TW(0x1.908ef8p-2, 0x1.ef7bd2p-30, -0x1.59ffecp-55),
    FPR_TW(0x1.d733f6p-1, -0x1.ee7e4p-26, -0x1.401e4ap-53),
    FPR_TW(-0x1.d733f6p-1, 0x1.ee7e4p-26, 0x1.401e4ap-53),
    FPR_TW(0x1.908ef8p-2, 0x1.ef7bd2p-30, -0x1.59ffecp-55),
    FPR_TW(0x1.6d5afep-1, 0x1.e955fap-26, -0x1.b0d14ep-52),
    FPR_TW(0x1.66b0f4p-1, -0x1.5a98f4p-30, 0x1.1e2eb4p-55),
    FPR_TW(-0x1.66b0f4p-1, 0x1.5a98f4p-30, -0x1.1e2eb4p-55),
    FPR_TW(0x1.6d5afep-1, 0x1.e955fap-26, -0x1.b0d14ep-52),
    FPR_TW(0x1.2d96bp-7, 0x1.ca12ep-32, 0x1.770b76p-58),
    FPR_TW(0x1.fffa72p-1, 0x1.92f18ap-26, -0x1.48b2cp-53),
    FPR_TW(-0x1.fffa72p-1, -0x1.92f18ap-26, 0x1.48b2cp-53),
    FPR_TW(0x1.2d96bp-7, 0x1.ca12ep-32, 0x1.770b76p-58),
    FPR_TW(0x1.fffa72p-1, 0x1.92f18ap-26, -0x1.48b2cp-53),
    FPR_TW(0x1.2d96bp-7, 0x1.ca12ep-32, 0x1.770b76p-58),
    FPR_TW(-0x1.2d96bp-7, -0x1.ca12ep-32, -0x1.770b76p-58),
    FPR_TW(0x1.fffa72p-1, 0x1.92f18ap-26, -0x1.48b2cp-53),
    FPR_TW(0x1.66b0f4p-1, -0x1.5a98f4p-30, 0x1.1e2eb4p-55),
    FPR_TW(0x1.6d5afep-1, 0x1.e955fap-26, -0x1.b0d14ep-52),
    FPR_TW(-0x1.6d5afep-1, -0x1.e955fap-26, 0x1.b0d14ep-52),
    FPR_TW(0x1.66b0f4p-1, -0x1.5a98f4p-30, 0x1.1e2eb4p-55),
    FPR_TW(0x1.d733f6p-1, -0x1.ee7e4p-26, -0x1.401e4ap-53),
    FPR_TW(0x1.908ef8p-2, 0x1.ef7bd2p-30, -0x1.59ffecp-55),
    FPR_TW(-0x1.908ef8p-2, -0x1.ef7bd2p-30, 0x1.59ffecp-55),
    FPR_TW(0x1.d733f6p-1, -0x1.ee7e4p-26, -0x1.401e4ap-53),
    FPR_TW(0x1.7f24dep-2, -0x1.9197c4p-27, 0x1.093c8ep-52),
    FPR_TW(0x1.dacf42p-1, 0x1.9cd158p-26, -0x1.cff46cp-51),
    FPR_TW(-0x1.dacf42p-1, -0x1.9cd158p-26, 0x1.cff46cp-51),
    FPR_TW(0x1.7f24dep-2, -0x1.9197c4p-27, 0x1.093c8ep-52),
    FPR_TW(0x1.f538b2p-1, -0x1.434be4p-31, -0x1.5f7cd6p-59),
    FPR_TW(0x1.a203e2p-3, -0x1.39f38ap-29, 0x1.1c1aaep-54),
    FPR_TW(-0x1.a203e2p-3, 0x1.39f38ap-29, -0x1.1c1aaep-54),
    FPR_TW(0x1.f538b2p-1, -0x1.434be4p-31, -0x1.5f7cd6p-59),
    FPR_TW(0x1.188592p-1, -0x1.8b7236p-30, -0x1.bbefe6p-56),
    FPR_TW(0x1.ac4ffcp-1, -0x1.60829cp-28, -0x1.818504p-56),
    FPR_TW(-0x1.ac4ffcp-1, 0x1.60829cp-28, 0x1.818504p-56),
    FPR_TW(0x1.188592p-1, -0x1.8b7236p-30, -0x1.bbefe6p-56),
    FPR_TW(0x1.a7138ep-1, -0x1.629f0cp-29, 0x1.072a3ep-54),
    FPR_TW(0x1.205baap-1, 0x1.7560d6p-29, 0x1.b7b144p-56),
    FPR_TW(-0x1.205baap-1, -0x1.7560d6p-29, -0x1.b7b144p-56),
    FPR_TW(0x1.a7138ep-1, -0x1.629f0cp-29, 0x1.072a3ep-54),
    FPR_TW(0x1.7d0a7cp-3, -0x1.0b4d3ap-29, 0x1.c60dfep-54),
    FPR_TW(0x1.f70f64p-1, 0x1.a5bf5cp-28, -0x1.ba2288p-54),
    FPR_TW(-0x1.f70f64p-1, -0x1.a5bf5cp-28, 0x1.ba2288p-54),
    FPR_TW(0x1.7d0a7cp-3, -0x1.0b4d3ap-29, 0x1.c60dfep-54),
    FPR_TW(0x1.fd0d16p-1, -0x1.c9e7dep-27, -0x1.347d2cp-54),
    FPR_TW(0x1.b6fa6ep-4, 0x1.871ecap-29, -0x1.c4944ep-55),
    FPR_TW(-0x1.b6fa6ep-4, -0x1.871ecap-29, 0x1.c4944ep-55),
    FPR_TW(0x1.fd0d16p-1, -0x1.c9e7dep-27, -0x1.347d2cp-54),
    FPR_TW(0x1.412726p-1, 0x1.8f4424p-27, -0x1.dc8832p-52),
    FPR_TW(0x1.8ec10ap-1, -0x1.2de4eep-27, 0x1.8d357p-54),
    FPR_TW(-0x1.8ec10ap-1, 0x1.2de4eep-27, -0x1.8d357p-54),
    FPR_TW(0x1.412726p-1, 0x1.8f4424p-27, -0x1.dc8832p-52),
    FPR_TW(0x1.c14d9ep-1, -0x1.dcd0d4p-28, -0x1.18e4a4p-54),
    FPR_TW(0x1.eb006ap-2, -0x1.41b53cp-27, 0x1.53c9fep-56),
    FPR_TW(-0x1.eb006ap-2, 0x1.41b53cp-27, -0x1.53c9fep-56),
    FPR_TW(0x1.c14d9ep-1, -0x1.dcd0d4p-28, -0x1.18e4a4p-54),
    FPR_TW(0x1.203858p-2, 0x1.eb93dep-29, 0x1.c72c66p-54),
    FPR_TW(0x1.eb4cf6p-1, -0x1.d48efep-26, 0x1.195da2p-53),
    FPR_TW(-0x1.eb4cf6p-1, 0x1.d48efep-26, -0x1.195da2p-53),
    FPR_TW(0x1.203858p-2, 0x1.eb93dep-29, 0x1.c72c66p-54),
    FPR_TW(0x1.e89096p-1, -0x1.14a7f6p-27, -0x1.ab4998p-52),
    FPR_TW(0x1.3241fcp-2, -0x1.38e8aap-27, -0x1.f0988cp-55),
    FPR_TW(-0x1.3241fcp-2, 0x1.38e8aap-27, 0x1.f0988cp-55),
    FPR_TW(0x1.e89096p-1, -0x1.14a7f6p-27, -0x1.ab4998p-52),
    FPR_TW(0x1.da60c6p-2, -0x1.82f794p-29, 0x1.bc31c8p-55),
    FPR_TW(0x1.c5bef6p-1, -0x1.8041eap-27, 0x1.f07aep-53),
    FPR_TW(-0x1.c5bef6p-1, 0x1.8041eap-27, -0x1.f07aep-53),
    FPR_TW(0x1.da60c6p-2, -0x1.82f794p-29, 0x1.bc31c8p-55),
    FPR_TW(0x1.88c66ep-1, 0x1.d206e8p-27, 0x1.a8e776p-54),
    FPR_TW(0x1.487034p-1, -0x1.f3edcp-26, -0x1.170814p-53),
    FPR_TW(-0x1.487034p-1, 0x1.f3edcp-26, 0x1.170814p-53),
    FPR_TW(0x1.88c66ep-1, 0x1.d206e8p-27, 0x1.a8e776p-54),
    FPR_TW(0x1.6bf1b4p-4, -0x1.864ed8p-32, 0x1.75a492p-57),
    FPR_TW(0x1.fdf992p-1, 0x1.7b9984p-28, -0x1.9687d6p-54),
    FPR_TW(-0x1.fdf992p-1, -0x1.7b9984p-28, 0x1.9687d6p-54),
    FPR_TW(0x1.6bf1b4p-4, -0x1.864ed8p-32, 0x1.75a492p-57),
    FPR_TW(0x1.ff2162p-1, -0x1.63d9c2p-26, -0x1.bbcd26p-52),
    FPR_TW(0x1.dd407p-5, -0x1.9fdc4ep-31, 0x1.08989ep-57),
    FPR_TW(-0x1.dd407p-5, 0x1.9fdc4ep-31, -0x1.08989ep-57),
    FPR_TW(0x1.ff2162p-1, -0x1.63d9c2p-26, -0x1.bbcd26p-52),
    FPR_TW(0x1.5455p-1, -0x1.5d4c4p-26, -0x1.14e248p-51),
    FPR_TW(0x1.7e83f8p-1, 0x1.ec0da2p-27, -0x1.e49e58p-53),
    FPR_TW(-0x1.7e83f8p-1, -0x1.ec0da2p-27, 0x1.e49e58p-53),
    FPR_TW(0x1.5455p-1, -0x1.5d4c4p-26, -0x1.14e248p-51),
    FPR_TW(0x1.cccee2p-1, 0x1.85bd4p-30, -0x1.d3116ap-55),
    FPR_TW(0x1.be5152p-2, -0x1.0007e4p-27, -0x1.ad4998p-52),
    FPR_TW(-0x1.be5152p-2, 0x1.0007e4p-27, 0x1.ad4998p-52),
    FPR_TW(0x1.cccee2p-1, 0x1.85bd4p-30, -0x1.d3116ap-55),
    FPR_TW(0x1.50163ep-2, -0x1.f347dcp-29, -0x1.ec66ccp-56),
    FPR_TW(0x1.e3a33ep-1, 0x1.8eb9dp-26, 0x1.451422p-51),
    FPR_TW(-0x1.e3a33ep-1, -0x1.8eb9dp-26, -0x1.451422p-51),
    FPR_TW(0x1.50163ep-2, -0x1.f347dcp-29, -0x1.ec66ccp-56),
    FPR_TW(0x1.ef7d6ep-1, 0x1.4728fp-27, -0x1.a3c67cp-55),
    FPR_TW(0x1.01f18p-2, 0x1.ae7f74p-28, 0x1.aedfb2p-54),
    FPR_TW(-0x1.01f18p-2, -0x1.ae7f74p-28, -0x1.aedfb2p-54),
    FPR_TW(0x1.ef7d6ep-1, 0x1.4728fp-27, -0x1.a3c67cp-55),
    FPR_TW(0x1.032ae6p-1, -0x1.42484ep-26, 0x1.6424fep-51),
    FPR_TW(0x1.b98fa2p-1, -0x1.37550ep-32, 0x1.55640ep-57),
    FPR_TW(-0x1.b98fa2p-1, 0x1.37550ep-32, -0x1.55640ep-57),
    FPR_TW(0x1.032ae6p-1, -0x1.42484ep-26, 0x1.6424fep-51),
    FPR_TW(0x1.986afp-1, -0x1.d7514ep-26, 0x1.ca1f84p-52),
    FPR_TW(0x1.34c526p-1, -0x1.a7d644p-26, 0x1.560fd2p-53),
    FPR_TW(-0x1.34c526p-1, 0x1.a7d644p-26, -0x1.560fd2p-53),
    FPR_TW(0x1.986afp-1, -0x1.d7514ep-26, 0x1.ca1f84p-52),
    FPR_TW(0x1.19d894p-3, 0x1.7c49cep-32, 0x1.e8dcdcp-58),
    FPR_TW(0x1.fb20dcp-1, 0x1.a07554p-27, -0x1.bfe292p-52),
    FPR_TW(-0x1.fb20dcp-1, -0x1.a07554p-27, 0x1.bfe292p-52),
    FPR_TW(0x1.19d894p-3, 0x1.7c49cep-32, 0x1.e8dcdcp-58),
    FPR_TW(0x1.f9bed8p-1, -0x1.8210ecp-28, 0x1.932938p-54),
    FPR_TW(0x1.3f22f6p-3, -0x1.0496eep-28, 0x1.8dff4p-54),
    FPR_TW(-0x1.3f22f6p-3, 0x1.0496eep-28, -0x1.8dff4p-54),
    FPR_TW(0x1.f9bed8p-1, -0x1.8210ecp-28, 0x1.932938p-54),
    FPR_TW(0x1.2d333ep-1, -0x1.962c8ap-26, 0x1.ef1d3ep-51),
    FPR_TW(0x1.9e082ep-1, 0x1.b6848ep-26, 0x1.0ac04ep-52),
    FPR_TW(-0x1.9e082ep-1, -0x1.b6848ep-26, -0x1.0ac04ep-52),
    FPR_TW(0x1.2d333ep-1, -0x1.962c8ap-26, 0x1.ef1d3ep-51),
    FPR_TW(0x1.b4b74p-1, 0x1.3bcf24p-26, 0x1.4fa712p-51),
    FPR_TW(0x1.0b4058p-1, 0x1.e3e17ap-27, 0x1.ca5328p-52),
    FPR_TW(-0x1.0b4058p-1, -0x1.e3e17ap-27, -0x1.ca5328p-52),
    FPR_TW(0x1.b4b74p-1, 0x1.3bcf24p-26, 0x1.4fa712p-51),
    FPR_TW(0x1.df5164p-3, -0x1.fdecccp-32, -0x1.01f7d8p-57),
    FPR_TW(0x1.f1c7acp-1, -0x1.d7b8f8p-29, 0x1.504b8p-55),
    FPR_TW(-0x1.f1c7acp-1, 0x1.d7b8f8p-29, -0x1.504b8p-55),
    FPR_TW(0x1.df5164p-3, -0x1.fdecccp-32, -0x1.01f7d8p-57),
    FPR_TW(0x1.e0766ep-1, -0x1.b5fc2ap-27, -0x1.c1766ep-52),
    FPR_TW(0x1.61d596p-2, -0x1.bb9efep-29, -0x1.825388p-54),
    FPR_TW(-0x1.61d596p-2, 0x1.bb9efep-29, 0x1.825388p-54),
    FPR_TW(0x1.e0766ep-1, -0x1.b5fc2ap-27, -0x1.c1766ep-52),
    FPR_TW(0x1.ad4732p-2, -0x1.b4647ep-27, -0x1.c4de7cp-52),
    FPR_TW(0x1.d0d672p-1, 0x1.eb3a58p-26, -0x1.dc83p-51),
    FPR_TW(-0x1.d0d672p-1, -0x1.eb3a58p-26, 0x1.dc83p-51),
    FPR_TW(0x1.ad4732p-2, -0x1.b4647ep-27, -0x1.c4de7cp-52),
    FPR_TW(0x1.782fb2p-1, -0x1.1bd32ap-27, 0x1.583728p-52),
    FPR_TW(0x1.5b50b2p-1, 0x1.93dd12p-27, 0x1.519d3p-56),
    FPR_TW(-0x1.5b50b2p-1, -0x1.93dd12p-27, -0x1.519d3p-56),
    FPR_TW(0x1.782fb2p-1, -0x1.1bd32ap-27, 0x1.583728p-52),
    FPR_TW(0x1.46a396p-5, 0x1.ff0c3p-30, -0x1.bbb254p-55),
    FPR_TW(0x1.ff97c4p-1, 0x1.04600ap-28, 0x1.52ab2cp-57),
    FPR_TW(-0x1.ff97c4p-1, -0x1.04600ap-28, -0x1.52ab2cp-57),
    FPR_TW(0x1.46a396p-5, 0x1.ff0c3p-30, -0x1.bbb254p-55),
    FPR_TW(0x1.ffb55ep-1, 0x1.097f6cp-27, -0x1.a49604p-53),
    FPR_TW(0x1.14685ep-5, -0x1.2f4fap-31, -0x1.4a2434p-57),
    FPR_TW(-0x1.14685ep-5, 0x1.2f4fap-31, 0x1.4a2434p-57),
    FPR_TW(0x1.ffb55ep-1, 0x1.097f6cp-27, -0x1.a49604p-53),
    FPR_TW(0x1.5d9deep-1, 0x1.cf8d16p-27, 0x1.f10f74p-52),
    FPR_TW(0x1.760c52p-1, 0x1.8608ecp-26, 0x1.ddc512p-52),
    FPR_TW(-0x1.760c52p-1, -0x1.8608ecp-26, -0x1.ddc512p-52),
    FPR_TW(0x1.5d9deep-1, 0x1.cf8d16p-27, 0x1.f10f74p-52),
    FPR_TW(0x1.d2255cp-1, 0x1.b96938p-27, 0x1.176b2cp-54),
    FPR_TW(0x1.a790cep-2, -0x1.84819cp-27, -0x1.4bfbc4p-52),
    FPR_TW(-0x1.a790cep-2, 0x1.84819cp-27, 0x1.4bfbc4p-52),
    FPR_TW(0x1.d2255cp-1, 0x1.b96938p-27, 0x1.176b2cp-54),
    FPR_TW(0x1.67b94ap-2, -0x1.a94e1ap-29, -0x1.688cdap-54),
    FPR_TW(0x1.df5e36p-1, 0x1.5374b4p-26, -0x1.07807ep-51),
    FPR_TW(-0x1.df5e36p-1, -0x1.5374b4p-26, 0x1.07807ep-51),
    FPR_TW(0x1.67b94ap-2, -0x1.a94e1ap-29, -0x1.688cdap-54),
    FPR_TW(0x1.f2818p-1, -0x1.dcfb1ap-28, 0x1.88b81cp-53),
    FPR_TW(0x1.d31774p-3, 0x1.a597bep-28, -0x1.b408dcp-55),
    FPR_TW(-0x1.d31774p-3, -0x1.a597bep-28, 0x1.b408dcp-55),
    FPR_TW(0x1.f2818p-1, -0x1.dcfb1ap-28, 0x1.88b81cp-53),
    FPR_TW(0x1.0ded0cp-1, -0x1.ed0ed2p-27, -0x1.30a82p-52),
    FPR_TW(0x1.b3115ap-1, 0x1.7cdefcp-27, 0x1.bbbc4ep-52),
    FPR_TW(-0x1.b3115ap-1, -0x1.7cdefcp-27, -0x1.bbbc4ep-52),
    FPR_TW(0x1.0ded0cp-1, -0x1.ed0ed2p-27, -0x1.30a82p-52),
    FPR_TW(0x1.9fdf5p-1, -0x1.d9d6c4p-26, -0x1.b864a2p-53),
    FPR_TW(0x1.2aa76ep-1, 0x1.0f5d6cp-26, -0x1.fe02ap-51),
    FPR_TW(-0x1.2aa76ep-1, -0x1.0f5d6cp-26, 0x1.fe02ap-51),
    FPR_TW(0x1.9fdf5p-1, -0x1.d9d6c4p-26, -0x1.b864a2p-53),
    FPR_TW(0x1.4b8b18p-3, -0x1.0c0afp-32, 0x1.b534fep-57),
    FPR_TW(0x1.f93f14p-1, 0x1.f0b58p-26, 0x1.e302eap-51),
    FPR_TW(-0x1.f93f14p-1, -0x1.f0b58p-26, -0x1.e302eap-51),
    FPR_TW(0x1.4b8b18p-3, -0x1.0c0afp-32, 0x1.b534fep-57),
    FPR_TW(0x1.fb8d18p-1, 0x1.acd5b6p-26, 0x1.b17a4cp-51),
    FPR_TW(0x1.0d64dcp-3, -0x1.a6cc3ep-30, 0x1.d1d8b6p-55),
    FPR_TW(-0x1.0d64dcp-3, 0x1.a6cc3ep-30, -0x1.d1d8b6p-55),
    FPR_TW(0x1.fb8d18p-1, 0x1.acd5b6p-26, 0x1.b17a4cp-51),
    FPR_TW(0x1.374532p-1, -0x1.1fa01cp-27, -0x1.57765ap-52),
    FPR_TW(0x1.9683f4p-1, 0x1.5ebffp-28, 0x1.ddc8a4p-54),
    FPR_TW(-0x1.9683f4p-1, -0x1.5ebffp-28, -0x1.ddc8a4p-54),
    FPR_TW(0x1.374532p-1, -0x1.1fa01cp-27, -0x1.57765ap-52),
    FPR_TW(0x1.bb249ap-1, 0x1.6d881ap-30, -0x1.d6318ep-58),
    FPR_TW(0x1.00740cp-1, 0x1.05705cp-26, 0x1.495bd4p-54),
    FPR_TW(-0x1.00740cp-1, -0x1.05705cp-26, -0x1.495bd4p-54),
    FPR_TW(0x1.bb249ap-1, 0x1.6d881ap-30, -0x1.d6318ep-58),
    FPR_TW(0x1.0804ep-2, 0x1.7ad988p-28, -0x1.aac6ap-54),
    FPR_TW(0x1.eeb074p-1, 0x1.8a14a8p-26, 0x1.1d926p-51),
    FPR_TW(-0x1.eeb074p-1, -0x1.8a14a8p-26, -0x1.1d926p-51),
    FPR_TW(0x1.0804ep-2, 0x1.7ad988p-28, -0x1.aac6ap-54),
    FPR_TW(0x1.e4a8ep-1, -0x1.f8c686p-31, -0x1.7950f2p-56),
    FPR_TW(0x1.4a253ep-2, -0x1.dc8fa2p-27, 0x1.76a82ep-53),
    FPR_TW(-0x1.4a253ep-2, 0x1.dc8fa2p-27, -0x1.76a82ep-53),
    FPR_TW(0x1.e4a8ep-1, -0x1.f8c686p-31, -0x1.7950f2p-56),
    FPR_TW(0x1.c3f6d4p-2, 0x1.c98c4ap-28, 0x1.671ef4p-54),
    FPR_TW(0x1.cb6e2p-1, 0x1.401b54p-26, -0x1.d4fb24p-51),
    FPR_TW(-0x1.cb6e2p-1, -0x1.401b54p-26, 0x1.d4fb24p-51),
    FPR_TW(0x1.c3f6d4p-2, 0x1.c98c4ap-28, 0x1.671ef4p-54),
    FPR_TW(0x1.8098b8p-1, -0x1.5235ap-26, -0x1.66ec92p-51),
    FPR_TW(0x1.51fa82p-1, -0x1.9332aep-28, 0x1.ffad98p-53),
    FPR_TW(-0x1.51fa82p-1, 0x1.9332aep-28, -0x1.ffad98p-53),
    FPR_TW(0x1.8098b8p-1, -0x1.5235ap-26, -0x1.66ec92p-51),
    FPR_TW(0x1.07b614p-4, 0x1.c8c60cp-29, 0x1.d8f60ep-55),
    FPR_TW(0x1.fef01p-1, 0x1.4130c8p-28, 0x1.2787d4p-53),
    FPR_TW(-0x1.fef01p-1, -0x1.4130c8p-28, -0x1.2787d4p-53),
    FPR_TW(0x1.07b614p-4, 0x1.c8c60cp-29, 0x1.d8f60ep-55),
    FPR_TW(0x1.fe3e92p-1, 0x1.7d3b1p-26, 0x1.86bfacp-51),
    FPR_TW(0x1.52e774p-4, 0x1.49a9a2p-29, -0x1.793448p-54),
    FPR_TW(-0x1.52e774p-4, -0x1.49a9a2p-29, 0x1.793448p-54),
    FPR_TW(0x1.fe3e92p-1, 0x1.7d3b1p-26, 0x1.86bfacp-51),
    FPR_TW(0x1.4ad796p-1, -0x1.d31ba2p-26, 0x1.76c628p-54),
    FPR_TW(0x1.86c0a2p-1, -0x1.32af36p-28, 0x1.06115ap-53),
    FPR_TW(-0x1.86c0a2p-1, 0x1.32af36p-28, -0x1.06115ap-53),
    FPR_TW(0x1.4ad796p-1, -0x1.d31ba2p-26, 0x1.76c628p-54),
    FPR_TW(0x1.c73158p-1, 0x1.33d55ap-26, 0x1.b99068p-51),
    FPR_TW(0x1.d4cd02p-2, 0x1.750c14p-27, -0x1.937f34p-53),
    FPR_TW(-0x1.d4cd02p-2, -0x1.750c14p-27, 0x1.937f34p-53),
    FPR_TW(0x1.c73158p-1, 0x1.33d55ap-26, 0x1.b99068p-51),
    FPR_TW(0x1.383f5ep-2, 0x1.a9db56p-29, -0x1.6a04aap-54),
    FPR_TW(0x1.e79db2p-1, 0x1.34a2ccp-26, -0x1.8baf38p-51),
    FPR_TW(-0x1.e79db2p-1, -0x1.34a2ccp-26, 0x1.8baf38p-51),
    FPR_TW(0x1.383f5ep-2, 0x1.a9db56p-29, -0x1.6a04aap-54),
    FPR_TW(0x1.ec2cf4p-1, 0x1.635ed6p-26, 0x1.0269dcp-52),
    FPR_TW(0x1.1a2f8p-2, -0x1.05c37p-28, 0x1.ac8cb6p-53),
    FPR_TW(-0x1.1a2f8p-2, 0x1.05c37p-28, -0x1.ac8cb6p-53),
    FPR_TW(0x1.ec2cf4p-1, 0x1.635ed6p-26, 0x1.0269dcp-52),
    FPR_TW(0x1.f0819p-2, 0x1.affep-28, -0x1.299566p-53),
    FPR_TW(0x1.bfc9d2p-1, 0x1.686c52p-27, -0x1.0151cp-53),
    FPR_TW(-0x1.bfc9d2p-1, -0x1.686c52p-27, 0x1.0151cp-53),
    FPR_TW(0x1.f0819p-2, 0x1.affep-28, -0x1.299566p-53),
    FPR_TW(0x1.90b794p-1, 0x1.abaf8p-28, -0x1.eb135p-53),
    FPR_TW(0x1.3eb33ep-1, 0x1.57c0dp-26, 0x1.86a236p-58),
    FPR_TW(-0x1.3eb33ep-1, -0x1.57c0dp-26, -0x1.86a236p-58),
    FPR_TW(0x1.90b794p-1, 0x1.abaf8p-28, -0x1.eb135p-53),
    FPR_TW(0x1.cff534p-4, -0x1.33e09p-30, 0x1.31fdd8p-56),
    FPR_TW(0x1.fcb47p-1, 0x1.c8a1aap-28, 0x1.126aa8p-55),
    FPR_TW(-0x1.fcb47p-1, -0x1.c8a1aap-28, -0x1.126aa8p-55),
    FPR_TW(0x1.cff534p-4, -0x1.33e09p-30, 0x1.31fdd8p-56),
    FPR_TW(0x1.f7a29ap-1, -0x1.f2e6eap-28, -0x1.d231cep-53),
    FPR_TW(0x1.70afd8p-3, 0x1.a118ap-28, -0x1.6cf9ep-56),
    FPR_TW(-0x1.70afd8p-3, -0x1.a118ap-28, 0x1.6cf9ep-56),
    FPR_TW(0x1.f7a29ap-1, -0x1.f2e6eap-28, -0x1.d231cep-53),
    FPR_TW(0x1.22f2d6p-1, 0x1.8b04f8p-27, 0x1.8a8ce2p-53),
    FPR_TW(0x1.a54c92p-1, -0x1.ede15cp-26, 0x1.91843p-52),
    FPR_TW(-0x1.a54c92p-1, 0x1.ede15cp-26, -0x1.91843p-52),
    FPR_TW(0x1.22f2d6p-1, 0x1.8b04f8p-27, 0x1.8a8ce2p-53),
    FPR_TW(0x1.ae069p-1, -0x1.974262p-26, -0x1.26726ap-53),
    FPR_TW(0x1.15e36ep-1, 0x1.36f8bp-27, -0x1.ec3abap-52),
    FPR_TW(-0x1.15e36ep-1, -0x1.36f8bp-27, 0x1.ec3abap-52),
    FPR_TW(0x1.ae069p-1, -0x1.974262p-26, -0x1.26726ap-53),
    FPR_TW(0x1.ae4f1ep-3, -0x1.4188cap-28, -0x1.255744p-53),
    FPR_TW(0x1.f4922p-1, 0x1.af2aeep-27, -0x1.c5c2dcp-52),
    FPR_TW(-0x1.f4922p-1, -0x1.af2aeep-27, 0x1.c5c2dcp-52),
    FPR_TW(0x1.ae4f1ep-3, -0x1.4188cap-28, -0x1.255744p-53),
    FPR_TW(0x1.dbf9e4p-1, 0x1.cabacep-28, -0x1.89c024p-53),
    FPR_TW(0x1.794f5ep-2, 0x1.84f7ecp-28, -0x1.cfbeb6p-54),
    FPR_TW(-0x1.794f5ep-2, -0x1.84f7ecp-28, 0x1.cfbeb6p-54),
    FPR_TW(0x1.dbf9e4p-1, 0x1.cabacep-28, -0x1.89c024p-53),
    FPR_TW(0x1.96555cp-2, -0x1.0a8d6ep-27, -0x1.428158p-55),
    FPR_TW(0x1.d5f718p-1, -0x1.aeeebp-26, -0x1.5a199p-53),
    FPR_TW(-0x1.d5f718p-1, 0x1.aeeebp-26, 0x1.5a199p-53),
    FPR_TW(0x1.96555cp-2, -0x1.0a8d6ep-27, -0x1.428158p-55),
    FPR_TW(0x1.6f8caap-1, -0x1.8da922p-27, -0x1.60dd18p-52),
    FPR_TW(0x1.647154p-1, 0x1.bfa9aep-28, -0x1.5f0e68p-53),
    FPR_TW(-0x1.647154p-1, -0x1.bfa9aep-28, 0x1.5f0e68p-53),
    FPR_TW(0x1.6f8caap-1, -0x1.8da922p-27, -0x1.60dd18p-52),
    FPR_TW(0x1.f6a296p-7, 0x1.5732fap-32, -0x1.5f2944p-57),
    FPR_TW(0x1.fff094p-1, 0x1.e29de8p-28, 0x1.5c633p-54),
    FPR_TW(-0x1.fff094p-1, -0x1.e29de8p-28, -0x1.5c633p-54),
    FPR_TW(0x1.f6a296p-7, 0x1.5732fap-32, -0x1.5f2944p-57),
    FPR_TW(0x1.ffe1c6p-1, 0x1.0e196ep-26, 0x1.d89aa2p-51),
    FPR_TW(0x1.5fd4d2p-6, 0x1.fab226p-34, -0x1.0c0a92p-61),
    FPR_TW(-0x1.5fd4d2p-6, -0x1.fab226p-34, 0x1.0c0a92p-61),
    FPR_TW(0x1.ffe1c6p-1, 0x1.0e196ep-26, 0x1.d89aa2p-51),
    FPR_TW(0x1.622e44p-1, 0x1.fd846p-26, -0x1.819c9ep-54),
    FPR_TW(0x1.71bacap-1, -0x1.3e37c8p-26, -0x1.370b1cp-53),
    FPR_TW(-0x1.71bacap-1, 0x1.3e37c8p-26, 0x1.370b1cp-53),
    FPR_TW(0x1.622e44p-1, 0x1.fd846p-26, -0x1.819c9ep-54),
    FPR_TW(0x1.d4b5b2p-1, -0x1.39e2b8p-27, 0x1.f054ap-52),
    FPR_TW(0x1.9c17d4p-2, 0x1.037e7cp-28, 0x1.1923c6p-53),
    FPR_TW(-0x1.9c17d4p-2, -0x1.037e7cp-28, -0x1.1923c6p-53),
    FPR_TW(0x1.d4b5b2p-1, -0x1.39e2b8p-27, 0x1.f054ap-52),
    FPR_TW(0x1.73763cp-2, 0x1.24c212p-27, 0x1.d5b9b6p-54),
    FPR_TW(0x1.dd1ffp-1, -0x1.8eadd4p-26, -0x1.9782f2p-51),
    FPR_TW(-0x1.dd1ffp-1, 0x1.8eadd4p-26, 0x1.9782f2p-51),
    FPR_TW(0x1.73763cp-2, 0x1.24c212p-27, 0x1.d5b9b6p-54),
    FPR_TW(0x1.f3e6bcp-1, -0x1.f221cep-28, 0x1.15774cp-53),
    FPR_TW(0x1.ba9634p-3, -0x1.61d44ap-28, -0x1.aea132p-54),
    FPR_TW(-0x1.ba9634p-3, 0x1.61d44ap-28, 0x1.aea132p-54),
    FPR_TW(0x1.f3e6bcp-1, -0x1.f221cep-28, 0x1.15774cp-53),
    FPR_TW(0x1.133e9cp-1, 0x1.fdc4aap-26, -0x1.3426fp-53),
    FPR_TW(0x1.afb8fep-1, -0x1.d82a12p-27, -0x1.fdc626p-53),
    FPR_TW(-0x1.afb8fep-1, 0x1.d82a12p-27, 0x1.fdc626p-53),
    FPR_TW(0x1.133e9cp-1, 0x1.fdc4aap-26, -0x1.3426fp-53),
    FPR_TW(0x1.a38184p-1, 0x1.4b2778p-26, 0x1.6436d4p-51),
    FPR_TW(0x1.258734p-1, 0x1.976e22p-26, 0x1.3a3f0ap-57),
    FPR_TW(-0x1.258734p-1, -0x1.976e22p-26, -0x1.3a3f0ap-57),
    FPR_TW(0x1.a38184p-1, 0x1.4b2778p-26, 0x1.6436d4p-51),
    FPR_TW(0x1.6451a8p-3, 0x1.8ec186p-30, 0x1.35a2cp-55),
    FPR_TW(0x1.f830f4p-1, 0x1.4818c2p-26, -0x1.f3d6bcp-52),
    FPR_TW(-0x1.f830f4p-1, -0x1.4818c2p-26, 0x1.f3d6bcp-52),
    FPR_TW(0x1.6451a8p-3, 0x1.8ec186p-30, 0x1.35a2cp-55),
    FPR_TW(0x1.fc56e4p-1, -0x1.209942p-27, -0x1.103ff8p-52),
    FPR_TW(0x1.e8eb8p-4, -0x1.0daaep-31, -0x1.48dd64p-56),
    FPR_TW(-0x1.e8eb8p-4, 0x1.0daaep-31, 0x1.48dd64p-56),
    FPR_TW(0x1.fc56e4p-1, -0x1.209942p-27, -0x1.103ff8p-52),
    FPR_TW(0x1.3c3c44p-1, 0x1.3038a2p-26, 0x1.e4a166p-51),
    FPR_TW(0x1.92aa42p-1, -0x1.d2bf58p-32, -0x1.68f89ep-57),
    FPR_TW(-0x1.92aa42p-1, 0x1.d2bf58p-32, 0x1.68f89ep-57),
    FPR_TW(0x1.3c3c44p-1, 0x1.3038a2p-26, 0x1.e4a166p-51),
    FPR_TW(0x1.be41b6p-1, 0x1.1154cp-29, 0x1.01192ap-54),
    FPR_TW(0x1.f5fdeep-2, 0x1.95b368p-28, 0x1.742034p-53),
    FPR_TW(-0x1.f5fdeep-2, -0x1.95b368p-28, -0x1.742034p-53),
    FPR_TW(0x1.be41b6p-1, 0x1.1154cp-29, 0x1.01192ap-54),
    FPR_TW(0x1.1423eep-2, 0x1.f8d27p-27, -0x1.edd2ccp-52),
    FPR_TW(0x1.ed0836p-1, -0x1.666ff6p-29, -0x1.d6cc5cp-54),
    FPR_TW(-0x1.ed0836p-1, 0x1.666ff6p-29, 0x1.d6cc5cp-54),
    FPR_TW(0x1.1423eep-2, 0x1.f8d27p-27, -0x1.edd2ccp-52),
    FPR_TW(0x1.e6a61cp-1, 0x1.5754eap-27, -0x1.a67c9ap-54),
    FPR_TW(0x1.3e39bep-2, 0x1.2dd84ep-27, 0x1.60531cp-54),
    FPR_TW(-0x1.3e39bep-2, -0x1.2dd84ep-27, -0x1.60531cp-54),
    FPR_TW(0x1.e6a61cp-1, 0x1.5754eap-27, -0x1.a67c9ap-54),
    FPR_TW(0x1.cf34bap-2, 0x1.dc39a4p-27, 0x1.773c6ep-55),
    FPR_TW(0x1.c89f58p-1, 0x1.c0a704p-27, 0x1.85620ep-52),
    FPR_TW(-0x1.c89f58p-1, -0x1.c0a704p-27, -0x1.85620ep-52),
    FPR_TW(0x1.cf34bap-2, 0x1.dc39a4p-27, 0x1.773c6ep-55),
    FPR_TW(0x1.84b712p-1, -0x1.ca0f8p-26, -0x1.963a48p-51),
    FPR_TW(0x1.4d3bc6p-1, 0x1.ab13fp-26, -0x1.48d932p-54),
    FPR_TW(-0x1.4d3bc6p-1, -0x1.ab13fp-26, 0x1.48d932p-54),
    FPR_TW(0x1.84b712p-1, -0x1.ca0f8p-26, -0x1.963a48p-51),
    FPR_TW(0x1.39d9f2p-4, -0x1.a74bacp-29, -0x1.beed78p-54),
    FPR_TW(0x1.fe7ea8p-1, 0x1.520b58p-27, 0x1.34b086p-56),
    FPR_TW(-0x1.fe7ea8p-1, -0x1.520b58p-27, -0x1.34b086p-56),
    FPR_TW(0x1.39d9f2p-4, -0x1.a74bacp-29, -0x1.beed78p-54),
    FPR_TW(0x1.feb9d2p-1, 0x1.4c1044p-27, -0x1.e62bd6p-54),
    FPR_TW(0x1.20c968p-4, -0x1.625776p-29, -0x1.bf3a92p-55),
    FPR_TW(-0x1.20c968p-4, 0x1.625776p-29, 0x1.bf3a92p-55),
    FPR_TW(0x1.feb9d2p-1, 0x1.4c1044p-27, -0x1.e62bd6p-54),
    FPR_TW(0x1.4f9cc2p-1, 0x1.732922p-27, -0x1.add29ap-53),
    FPR_TW(0x1.82a9c2p-1, -0x1.81574p-26, -0x1.2cbd1p-53),
    FPR_TW(-0x1.82a9c2p-1, 0x1.81574p-26, 0x1.2cbd1p-53),
    FPR_TW(0x1.4f9cc2p-1, 0x1.732922p-27, -0x1.add29ap-53),
    FPR_TW(0x1.ca08f2p-1, -0x1.918eeep-27, 0x1.af387ep-54),
    FPR_TW(0x1.c997fcp-2, 0x1.c329c4p-29, 0x1.4eb504p-55),
    FPR_TW(-0x1.c997fcp-2, -0x1.c329c4p-29, -0x1.4eb504p-55),
    FPR_TW(0x1.ca08f2p-1, -0x1.918eeep-27, 0x1.af387ep-54),
    FPR_TW(0x1.44310ep-2, -0x1.bb6488p-29, 0x1.8b694ep-56),
    FPR_TW(0x1.e5a9d6p-1, -0x1.5f7306p-26, 0x1.97d432p-52),
    FPR_TW(-0x1.e5a9d6p-1, 0x1.5f7306p-26, -0x1.97d432p-52),
    FPR_TW(0x1.44310ep-2, -0x1.bb6488p-29, 0x1.8b694ep-56),
    FPR_TW(0x1.eddeb6p-1, 0x1.40f0cap-26, 0x1.625432p-54),
    FPR_TW(0x1.0e15b4p-2, 0x1.c2e93ap-27, -0x1.2b6ff6p-53),
    FPR_TW(-0x1.0e15b4p-2, -0x1.c2e93ap-27, 0x1.2b6ff6p-53),
    FPR_TW(0x1.eddeb6p-1, 0x1.40f0cap-26, 0x1.625432p-54),
    FPR_TW(0x1.fb7576p-2, -0x1.ed9692p-29, 0x1.d48046p-54),
    FPR_TW(0x1.bcb54cp-1, 0x1.61a464p-26, 0x1.c02822p-51),
    FPR_TW(-0x1.bcb54cp-1, -0x1.61a464p-26, -0x1.c02822p-51),
    FPR_TW(0x1.fb7576p-2, -0x1.ed9692p-29, 0x1.d48046p-54),
    FPR_TW(0x1.94990ep-1, 0x1.d62536p-28, 0x1.a95328p-56),
    FPR_TW(0x1.39c23ep-1, 0x1.eb1814p-28, 0x1.ec4fa4p-54),
    FPR_TW(-0x1.39c23ep-1, -0x1.eb1814p-28, -0x1.ec4fa4p-54),
    FPR_TW(0x1.94990ep-1, 0x1.d62536p-28, 0x1.a95328p-56),
    FPR_TW(0x1.00ee8ap-3, 0x1.adf70cp-28, -0x1.34c60ap-53),
    FPR_TW(0x1.fbf47p-1, 0x1.e151bp-26, 0x1.e944ep-51),
    FPR_TW(-0x1.fbf47p-1, -0x1.e151bp-26, -0x1.e944ep-51),
    FPR_TW(0x1.00ee8ap-3, 0x1.adf70cp-28, -0x1.34c60ap-53),
    FPR_TW(0x1.f8ba74p-1, -0x1.069692p-26, 0x1.e258ep-51),
    FPR_TW(0x1.57f008p-3, 0x1.9532f8p-29, -0x1.cdee6ep-55),
    FPR_TW(-0x1.57f008p-3, -0x1.9532f8p-29, 0x1.cdee6ep-55),
    FPR_TW(0x1.f8ba74p-1, -0x1.069692p-26, 0x1.e258ep-51),
    FPR_TW(0x1.2818bep-1, 0x1.e9a798p-26, -0x1.8f2p-51),
    FPR_TW(0x1.a1b26ep-1, -0x1.a7eb14p-26, -0x1.ecf10cp-53),
    FPR_TW(-0x1.a1b26ep-1, 0x1.a7eb14p-26, 0x1.ecf10cp-53),
    FPR_TW(0x1.2818bep-1, 0x1.e9a798p-26, -0x1.8f2p-51),
    FPR_TW(0x1.b16742p-1, 0x1.49945ep-26, 0x1.2458f6p-51),
    FPR_TW(0x1.109724p-1, 0x1.1a152ap-26, 0x1.a85a78p-51),
    FPR_TW(-0x1.109724p-1, -0x1.1a152ap-26, -0x1.a85a78p-51),
    FPR_TW(0x1.b16742p-1, 0x1.49945ep-26, 0x1.2458f6p-51),
    FPR_TW(0x1.c6d906p-3, -0x1.945164p-28, -0x1.8dfd96p-54),
    FPR_TW(0x1.f33686p-1, -0x1.715444p-27, 0x1.eb7868p-56),
    FPR_TW(-0x1.f33686p-1, 0x1.715444p-27, -0x1.eb7868p-56),
    FPR_TW(0x1.c6d906p-3, -0x1.945164p-28, -0x1.8dfd96p-54),
    FPR_TW(0x1.de416p-1, 0x1.edb1bp-26, 0x1.66fc48p-53),
    FPR_TW(0x1.6d9986p-2, 0x1.c5065ap-29, 0x1.fdc6bep-54),
    FPR_TW(-0x1.6d9986p-2, -0x1.c5065ap-29, -0x1.fdc6bep-54),
    FPR_TW(0x1.de416p-1, 0x1.edb1bp-26, 0x1.66fc48p-53),
    FPR_TW(0x1.a1d654p-2, 0x1.da856p-29, -0x1.0246dp-57),
    FPR_TW(0x1.d36fc8p-1, -0x1.0d010ap-27, 0x1.c8bcd2p-52),
    FPR_TW(-0x1.d36fc8p-1, 0x1.0d010ap-27, -0x1.c8bcd2p-52),
    FPR_TW(0x1.a1d654p-2, 0x1.da856p-29, -0x1.0246dp-57),
    FPR_TW(0x1.73e558p-1, 0x1.c0f328p-26, 0x1.b6673cp-53),
    FPR_TW(0x1.5fe7ccp-1, -0x1.0d4af8p-28, -0x1.fcb9ccp-55),
    FPR_TW(-0x1.5fe7ccp-1, 0x1.0d4af8p-28, 0x1.fcb9ccp-55),
    FPR_TW(0x1.73e558p-1, 0x1.c0f328p-26, 0x1.b6673cp-53),
    FPR_TW(0x1.c454f4p-6, 0x1.9ca764p-31, -0x1.bac7bp-57),
    FPR_TW(0x1.ffce0ap-1, -0x1.8eacc4p-28, 0x1.4214eap-54),
    FPR_TW(-0x1.ffce0ap-1, 0x1.8eacc4p-28, -0x1.4214eap-54),
    FPR_TW(0x1.c454f4p-6, 0x1.9ca764p-31, -0x1.bac7bp-57),
    FPR_TW(0x1.ff753cp-1, -0x1.391ba8p-27, 0x1.e83cdp-52),
    FPR_TW(0x1.78dbaap-5, 0x1.61d1a2p-31, -0x1.14a0fp-56),
    FPR_TW(-0x1.78dbaap-5, -0x1.61d1a2p-31, 0x1.14a0fp-56),
    FPR_TW(0x1.ff753cp-1, -0x1.391ba8p-27, 0x1.e83cdp-52),
    FPR_TW(0x1.59001ep-1, -0x1.411b84p-26, -0x1.9581e6p-54),
    FPR_TW(0x1.7a4f7p-1, 0x1.efe5f4p-27, 0x1.2792eap-52),
    FPR_TW(-0x1.7a4f7p-1, -0x1.efe5f4p-27, -0x1.2792eap-52),
    FPR_TW(0x1.59001ep-1, -0x1.411b84p-26, -0x1.9581e6p-54),
    FPR_TW(0x1.cf830ep-1, 0x1.19c8dp-26, -0x1.57b92p-51),
    FPR_TW(0x1.b2f972p-2, -0x1.267346p-29, -0x1.815a3ap-54),
    FPR_TW(-0x1.b2f972p-2, 0x1.267346p-29, 0x1.815a3ap-54),
    FPR_TW(0x1.cf830ep-1, 0x1.19c8dp-26, -0x1.57b92p-51),
    FPR_TW(0x1.5bee78p-2, 0x1.73b676p-27, 0x1.879cd2p-52),
    FPR_TW(0x1.e18a02p-1, 0x1.fb8cdcp-26, -0x1.af81d8p-51),
    FPR_TW(-0x1.e18a02p-1, -0x1.fb8cdcp-26, 0x1.af81d8p-51),
    FPR_TW(0x1.5bee78p-2, 0x1.73b676p-27, 0x1.879cd2p-52),
    FPR_TW(0x1.f1090cp-1, -0x1.bb385p-28, -0x1.6ea992p-53),
    FPR_TW(0x1.eb86b4p-3, 0x1.8b78d2p-29, -0x1.bfcde4p-57),
    FPR_TW(-0x1.eb86b4p-3, -0x1.8b78d2p-29, 0x1.bfcde4p-57),
    FPR_TW(0x1.f1090cp-1, -0x1.bb385p-28, -0x1.6ea992p-53),
    FPR_TW(0x1.089112p-1, 0x1.95846p-32, 0x1.3248dep-57),
    FPR_TW(0x1.b658f2p-1, -0x1.604878p-26, 0x1.c54ad4p-51),
    FPR_TW(-0x1.b658f2p-1, 0x1.604878p-26, -0x1.c54ad4p-51),
    FPR_TW(0x1.089112p-1, 0x1.95846p-32, 0x1.3248dep-57),
    FPR_TW(0x1.9c2d12p-1, -0x1.e1f148p-26, 0x1.3b393ep-52),
    FPR_TW(0x1.2fbc24p-1, 0x1.688202p-26, 0x1.476e92p-51),
    FPR_TW(-0x1.2fbc24p-1, -0x1.688202p-26, -0x1.476e92p-51),
    FPR_TW(0x1.9c2d12p-1, -0x1.e1f148p-26, 0x1.3b393ep-52),
    FPR_TW(0x1.32b7cp-3, -0x1.aeba56p-29, -0x1.6aed8ep-56),
    FPR_TW(0x1.fa39bap-1, 0x1.8f42f2p-26, 0x1.cd618ep-54),
    FPR_TW(-0x1.fa39bap-1, -0x1.8f42f2p-26, -0x1.cd618ep-54),
    FPR_TW(0x1.32b7cp-3, -0x1.aeba56p-29, -0x1.6aed8ep-56),
    FPR_TW(0x1.faafbcp-1, 0x1.619fbcp-26, -0x1.1e349cp-51),
    FPR_TW(0x1.264994p-3, 0x1.bfa682p-28, -0x1.a58bb4p-53),
    FPR_TW(-0x1.264994p-3, -0x1.bfa682p-28, 0x1.a58bb4p-53),
    FPR_TW(0x1.faafbcp-1, 0x1.619fbcp-26, -0x1.1e349cp-51),
    FPR_TW(0x1.32421ep-1, 0x1.8934c4p-26, -0x1.4d0ed2p-54),
    FPR_TW(0x1.9a4dfap-1, 0x1.0ac1acp-27, 0x1.cfac92p-53),
    FPR_TW(-0x1.9a4dfap-1, -0x1.0ac1acp-27, -0x1.cfac92p-53),
    FPR_TW(0x1.32421ep-1, 0x1.8934c4p-26, -0x1.4d0ed2p-54),
    FPR_TW(0x1.b7f668p-1, 0x1.b9e4bap-27, 0x1.61d996p-53),
    FPR_TW(0x1.05df3ep-1, 0x1.863716p-26, 0x1.b8748ep-51),
    FPR_TW(-0x1.05df3ep-1, -0x1.863716p-26, -0x1.b8748ep-51),
    FPR_TW(0x1.b7f668p-1, 0x1.b9e4bap-27, 0x1.61d996p-53),
    FPR_TW(0x1.f7b748p-3, 0x1.7a7004p-32, -0x1.9a96dap-57),
    FPR_TW(0x1.f045a2p-1, -0x1.66118ep-26, -0x1.1a52c4p-51),
    FPR_TW(-0x1.f045a2p-1, 0x1.66118ep-26, 0x1.1a52c4p-51),
    FPR_TW(0x1.f7b748p-3, 0x1.7a7004p-32, -0x1.9a96dap-57),
    FPR_TW(0x1.e298f4p-1, 0x1.0e465ep-27, 0x1.0f4274p-52),
    FPR_TW(0x1.560402p-2, -0x1.a1730ap-27, 0x1.1a0e0cp-52),
    FPR_TW(-0x1.560402p-2, 0x1.a1730ap-27, -0x1.1a0e0cp-52),
    FPR_TW(0x1.e298f4p-1, 0x1.0e465ep-27, 0x1.0f4274p-52),
    FPR_TW(0x1.b8a782p-2, -0x1.60552ep-27, 0x1.b353ccp-53),
    FPR_TW(0x1.ce2b32p-1, 0x1.e66818p-27, -0x1.631d46p-56),
    FPR_TW(-0x1.ce2b32p-1, -0x1.e66818p-27, 0x1.631d46p-56),
    FPR_TW(0x1.b8a782p-2, -0x1.60552ep-27, 0x1.b353ccp-53),
    FPR_TW(0x1.7c6b8ap-1, -0x1.8e9666p-28, -0x1.39fac6p-53),
    FPR_TW(0x1.56ac36p-1, -0x1.cd136cp-26, -0x1.7de1dp-53),
    FPR_TW(-0x1.56ac36p-1, 0x1.cd136cp-26, 0x1.7de1dp-53),
    FPR_TW(0x1.7c6b8ap-1, -0x1.8e9666p-28, -0x1.39fac6p-53),
    FPR_TW(0x1.ab101cp-5, -0x1.503e74p-32, -0x1.597186p-57),
    FPR_TW(0x1.ff4dc6p-1, -0x1.69c826p-26, 0x1.47dd2cp-52),
    FPR_TW(-0x1.ff4dc6p-1, 0x1.69c826p-26, -0x1.47dd2cp-52),
    FPR_TW(0x1.ab101cp-5, -0x1.503e74p-32, -0x1.597186p-57),
    FPR_TW(0x1.fdafa8p-1, -0x1.5d758ep-26, -0x1.fc4d08p-52),
    FPR_TW(0x1.84f872p-4, -0x1.a7d9ecp-29, 0x1.0cec8ap-57),
    FPR_TW(-0x1.84f872p-4, 0x1.a7d9ecp-29, -0x1.0cec8ap-57),
    FPR_TW(0x1.fdafa8p-1, -0x1.5d758ep-26, -0x1.fc4d08p-52),
    FPR_TW(0x1.4605a6p-1, 0x1.256654p-26, 0x1.243944p-52),
    FPR_TW(0x1.8ac872p-1, -0x1.21e278p-29, -0x1.9afaa6p-55),
    FPR_TW(-0x1.8ac872p-1, 0x1.21e278p-29, 0x1.9afaa6p-55),
    FPR_TW(0x1.4605a6p-1, 0x1.256654p-26, 0x1.243944p-52),
    FPR_TW(0x1.c44834p-1, -0x1.d7c8p-26, 0x1.091f02p-51),
    FPR_TW(0x1.dfeff6p-2, 0x1.aa5078p-28, -0x1.34ead8p-53),
    FPR_TW(-0x1.dfeff6p-2, -0x1.aa5078p-28, 0x1.34ead8p-53),
    FPR_TW(0x1.c44834p-1, -0x1.d7c8p-26, 0x1.091f02p-51),
    FPR_TW(0x1.2c41a4p-2, 0x1.d2a8a4p-27, 0x1.9cf036p-56),
    FPR_TW(0x1.e97ec4p-1, -0x1.3fd29ap-26, 0x1.5bc486p-55),
    FPR_TW(-0x1.e97ec4p-1, 0x1.3fd29ap-26, -0x1.5bc486p-55),
    FPR_TW(0x1.2c41a4p-2, 0x1.d2a8a4p-27, 0x1.9cf036p-56),
    FPR_TW(0x1.ea683ap-1, -0x1.8335p-26, -0x1.46725ap-56),
    FPR_TW(0x1.263e6ap-2, -0x1.aaaad2p-28, 0x1.23a6a2p-53),
    FPR_TW(-0x1.263e6ap-2, 0x1.aaaad2p-28, -0x1.23a6a2p-53),
    FPR_TW(0x1.ea683ap-1, -0x1.8335p-26, -0x1.46725ap-56),
    FPR_TW(0x1.e57a86p-2, 0x1.a79b04p-27, 0x1.369bfap-52),
    FPR_TW(0x1.c2cd14p-1, 0x1.263c7ep-26, 0x1.259c6p-53),
    FPR_TW(-0x1.c2cd14p-1, -0x1.263c7ep-26, -0x1.259c6p-53),
    FPR_TW(0x1.e57a86p-2, 0x1.a79b04p-27, 0x1.369bfap-52),
    FPR_TW(0x1.8cc6a8p-1, -0x1.5cf736p-26, 0x1.21e74cp-51),
    FPR_TW(0x1.4397f6p-1, -0x1.356f2p-27, -0x1.7274cap-55),
    FPR_TW(-0x1.4397f6p-1, 0x1.356f2p-27, 0x1.7274cap-55),
    FPR_TW(0x1.8cc6a8p-1, -0x1.5cf736p-26, 0x1.21e74cp-51),
    FPR_TW(0x1.9dfb6ep-4, 0x1.64950cp-29, -0x1.e1694cp-55),
    FPR_TW(0x1.fd60d2p-1, 0x1.b4eb94p-26, -0x1.f6490ap-53),
    FPR_TW(-0x1.fd60d2p-1, -0x1.b4eb94p-26, 0x1.f6490ap-53),
    FPR_TW(0x1.9dfb6ep-4, 0x1.64950cp-29, -0x1.e1694cp-55),
    FPR_TW(0x1.f67756p-1, -0x1.2ef862p-26, -0x1.e1096ap-53),
    FPR_TW(0x1.896172p-3, 0x1.f10602p-29, -0x1.ec0254p-54),
    FPR_TW(-0x1.896172p-3, -0x1.f10602p-29, 0x1.ec0254p-54),
    FPR_TW(0x1.f67756p-1, -0x1.2ef862p-26, -0x1.e1096ap-53),
    FPR_TW(0x1.1dc1b6p-1, 0x1.37121cp-27, 0x1.0f8afp-52),
    FPR_TW(0x1.a8d676p-1, 0x1.ca8b5ap-26, 0x1.f93b88p-53),
    FPR_TW(-0x1.a8d676p-1, -0x1.ca8b5ap-26, -0x1.f93b88p-53),
    FPR_TW(0x1.1dc1b6p-1, 0x1.37121cp-27, 0x1.0f8afp-52),
    FPR_TW(0x1.aa9548p-1, -0x1.74d19cp-27, -0x1.fcf06p-53),
    FPR_TW(0x1.1b2502p-1, -0x1.1d9188p-26, -0x1.6c843ap-53),
    FPR_TW(-0x1.1b2502p-1, 0x1.1d9188p-26, 0x1.6c843ap-53),
    FPR_TW(0x1.aa9548p-1, -0x1.74d19cp-27, -0x1.fcf06p-53),
    FPR_TW(0x1.95b49ep-3, 0x1.36c56p-28, -0x1.84402cp-53),
    FPR_TW(0x1.f5da6ep-1, 0x1.a86d0cp-26, -0x1.aa6df8p-52),
    FPR_TW(-0x1.f5da6ep-1, -0x1.a86d0cp-26, 0x1.aa6df8p-52),
    FPR_TW(0x1.95b49ep-3, 0x1.36c56p-28, -0x1.84402cp-53),
    FPR_TW(0x1.d9a00ep-1, -0x1.3a615cp-28, -0x1.f20af8p-53),
    FPR_TW(0x1.84f6aap-2, 0x1.5e7208p-27, -0x1.a48c9p-55),
    FPR_TW(-0x1.84f6aap-2, -0x1.5e7208p-27, 0x1.a48c9p-55),
    FPR_TW(0x1.d9a00ep-1, -0x1.3a615cp-28, -0x1.f20af8p-53),
    FPR_TW(0x1.8ac4b8p-2, 0x1.b57b52p-28, -0x1.dd00bp-53),
    FPR_TW(0x1.d86c48p-1, 0x1.116914p-27, -0x1.0bbf62p-54),
    FPR_TW(-0x1.d86c48p-1, -0x1.116914p-27, 0x1.0bbf62p-54),
    FPR_TW(0x1.8ac4b8p-2, 0x1.b57b52p-28, -0x1.dd00bp-53),
    FPR_TW(0x1.6b25cep-1, 0x1.a5fc54p-26, -0x1.15ac64p-51),
    FPR_TW(0x1.68ed1ep-1, 0x1.54338ep-26, 0x1.3fa95p-53),
    FPR_TW(-0x1.68ed1ep-1, -0x1.54338ep-26, -0x1.3fa95p-53),
    FPR_TW(0x1.6b25cep-1, 0x1.a5fc54p-26, -0x1.15ac64p-51),
    FPR_TW(0x1.921f8cp-9, -0x1.335b46p-37, 0x1.2ba408p-63),
    FPR_TW(0x1.ffff62p-1, 0x1.621d02p-29, -0x1.6acfcep-56),
    FPR_TW(-0x1.ffff62p-1, -0x1.621d02p-29, 0x1.6acfcep-56),
    FPR_TW(0x1.921f8cp-9, -0x1.335b46p-37, 0x1.2ba408p-63)
};

void compare_gm(){
    initialize_GM();
    for(int i = 0; i < 2048; i++){
        dunion_t xd;
        double x = mpfr_get_d(GM[i].mpfr, MPFR_RNDN);
        // fpr z = FPR(8321567036706118, -53); 
        // y.d = mpfr_get_d(z.mpfr, MPFR_RNDN);
        xd.i = GM2[i];
        
        if(x != xd.d){
            printf("not the same at index %d: %.20f != %.20f\n", i, x, xd.d);
        }
    }
}
#else
#include <stdio.h>

#if FNDSA_TW
static const fpr GM[] = {
    FPR_ZERO, FPR_ZERO,
    FPR_NZERO, FPR_ONE,
    FPR(0x1.6a09e6p-1, 0x1.9fcef4p-27, -0x1.b7ba68p-52),
    FPR(0x1.6a09e6p-1, 0x1.9fcef4p-27, -0x1.b7ba68p-52),
    FPR(-0x1.6a09e6p-1, -0x1.9fcef4p-27, 0x1.b7ba68p-52),
    FPR(0x1.6a09e6p-1, 0x1.9fcef4p-27, -0x1.b7ba68p-52),
    FPR(0x1.d906bcp-1, 0x1.e651a8p-26, 0x1.8a2bf4p-51),
    FPR(0x1.87de2ap-2, 0x1.abaa58p-28, 0x1.68d312p-53),
    FPR(-0x1.87de2ap-2, -0x1.abaa58p-28, -0x1.68d312p-53),
    FPR(0x1.d906bcp-1, 0x1.e651a8p-26, 0x1.8a2bf4p-51),
    FPR(0x1.87de2ap-2, 0x1.abaa58p-28, 0x1.68d312p-53),
    FPR(0x1.d906bcp-1, 0x1.e651a8p-26, 0x1.8a2bf4p-51),
    FPR(-0x1.d906bcp-1, -0x1.e651a8p-26, -0x1.8a2bf4p-51),
    FPR(0x1.87de2ap-2, 0x1.abaa58p-28, 0x1.68d312p-53),
    FPR(0x1.f6297cp-1, 0x1.feeb96p-26, 0x1.562172p-56),
    FPR(0x1.8f8b84p-3, -0x1.cb2cfap-30, -0x1.49b466p-55),
    FPR(-0x1.8f8b84p-3, 0x1.cb2cfap-30, 0x1.49b466p-55),
    FPR(0x1.f6297cp-1, 0x1.feeb96p-26, 0x1.562172p-56),
    FPR(0x1.1c73b4p-1, -0x1.9465cep-27, 0x1.b25dd2p-55),
    FPR(0x1.a9b662p-1, 0x1.21d434p-26, 0x1.819f64p-52),
    FPR(-0x1.a9b662p-1, -0x1.21d434p-26, -0x1.819f64p-52),
    FPR(0x1.1c73b4p-1, -0x1.9465cep-27, 0x1.b25dd2p-55),
    FPR(0x1.a9b662p-1, 0x1.21d434p-26, 0x1.819f64p-52),
    FPR(0x1.1c73b4p-1, -0x1.9465cep-27, 0x1.b25dd2p-55),
    FPR(-0x1.1c73b4p-1, 0x1.9465cep-27, -0x1.b25dd2p-55),
    FPR(0x1.a9b662p-1, 0x1.21d434p-26, 0x1.819f64p-52),
    FPR(0x1.8f8b84p-3, -0x1.cb2cfap-30, -0x1.49b466p-55),
    FPR(0x1.f6297cp-1, 0x1.feeb96p-26, 0x1.562172p-56),
    FPR(-0x1.f6297cp-1, -0x1.feeb96p-26, -0x1.562172p-56),
    FPR(0x1.8f8b84p-3, -0x1.cb2cfap-30, -0x1.49b466p-55),
    FPR(0x1.fd88dap-1, 0x1.e89292p-28, 0x1.9e0828p-53),
    FPR(0x1.917a6cp-4, -0x1.eb25eap-31, -0x1.e2718ep-60),
    FPR(-0x1.917a6cp-4, 0x1.eb25eap-31, 0x1.e2718ep-60),
    FPR(0x1.fd88dap-1, 0x1.e89292p-28, 0x1.9e0828p-53),
    FPR(0x1.44cf32p-1, 0x1.424776p-27, -0x1.e7f896p-53),
    FPR(0x1.8bc806p-1, 0x1.62a2e8p-26, 0x1.69d0f6p-54),
    FPR(-0x1.8bc806p-1, -0x1.62a2e8p-26, -0x1.69d0f6p-54),
    FPR(0x1.44cf32p-1, 0x1.424776p-27, -0x1.e7f896p-53),
    FPR(0x1.c38b3p-1, -0x1.cfe84ap-26, 0x1.a47d3ap-54),
    FPR(0x1.e2b5d4p-2, -0x1.fe4272p-28, 0x1.8f06c4p-53),
    FPR(-0x1.e2b5d4p-2, 0x1.fe4272p-28, -0x1.8f06c4p-53),
    FPR(0x1.c38b3p-1, -0x1.cfe84ap-26, 0x1.a47d3ap-54),
    FPR(0x1.294062p-2, 0x1.dab3ep-27, 0x1.6a2d72p-52),
    FPR(0x1.e9f416p-1, -0x1.273a44p-26, -0x1.689f4ep-51),
    FPR(-0x1.e9f416p-1, 0x1.273a44p-26, 0x1.689f4ep-51),
    FPR(0x1.294062p-2, 0x1.dab3ep-27, 0x1.6a2d72p-52),
    FPR(0x1.e9f416p-1, -0x1.273a44p-26, -0x1.689f4ep-51),
    FPR(0x1.294062p-2, 0x1.dab3ep-27, 0x1.6a2d72p-52),
    FPR(-0x1.294062p-2, -0x1.dab3ep-27, -0x1.6a2d72p-52),
    FPR(0x1.e9f416p-1, -0x1.273a44p-26, -0x1.689f4ep-51),
    FPR(0x1.e2b5d4p-2, -0x1.fe4272p-28, 0x1.8f06c4p-53),
    FPR(0x1.c38b3p-1, -0x1.cfe84ap-26, 0x1.a47d3ap-54),
    FPR(-0x1.c38b3p-1, 0x1.cfe84ap-26, -0x1.a47d3ap-54),
    FPR(0x1.e2b5d4p-2, -0x1.fe4272p-28, 0x1.8f06c4p-53),
    FPR(0x1.8bc806p-1, 0x1.62a2e8p-26, 0x1.69d0f6p-54),
    FPR(0x1.44cf32p-1, 0x1.424776p-27, -0x1.e7f896p-53),
    FPR(-0x1.44cf32p-1, -0x1.424776p-27, 0x1.e7f896p-53),
    FPR(0x1.8bc806p-1, 0x1.62a2e8p-26, 0x1.69d0f6p-54),
    FPR(0x1.917a6cp-4, -0x1.eb25eap-31, -0x1.e2718ep-60),
    FPR(0x1.fd88dap-1, 0x1.e89292p-28, 0x1.9e0828p-53),
    FPR(-0x1.fd88dap-1, -0x1.e89292p-28, -0x1.9e0828p-53),
    FPR(0x1.917a6cp-4, -0x1.eb25eap-31, -0x1.e2718ep-60),
    FPR(0x1.ff621ep-1, 0x1.bcb6bep-28, 0x1.e3a844p-53),
    FPR(0x1.91f66p-5, -0x1.de44fep-30, 0x1.f376a2p-56),
    FPR(-0x1.91f66p-5, 0x1.de44fep-30, -0x1.f376a2p-56),
    FPR(0x1.ff621ep-1, 0x1.bcb6bep-28, 0x1.e3a844p-53),
    FPR(0x1.57d694p-1, -0x1.6e626cp-26, -0x1.75720ap-55),
    FPR(0x1.7b5df2p-1, 0x1.3557d8p-28, -0x1.21ea7p-53),
    FPR(-0x1.7b5df2p-1, -0x1.3557d8p-28, 0x1.21ea7p-53),
    FPR(0x1.57d694p-1, -0x1.6e626cp-26, -0x1.75720ap-55),
    FPR(0x1.ced7bp-1, -0x1.786712p-26, 0x1.786126p-52),
    FPR(0x1.b5d1p-2, 0x1.3c2b98p-27, 0x1.5b362cp-57),
    FPR(-0x1.b5d1p-2, -0x1.3c2b98p-27, -0x1.5b362cp-57),
    FPR(0x1.ced7bp-1, -0x1.786712p-26, 0x1.786126p-52),
    FPR(0x1.58f9a8p-2, -0x1.4a9c04p-27, -0x1.80f7eep-53),
    FPR(0x1.e2121p-1, 0x1.3da1bap-27, -0x1.a0298ep-52),
    FPR(-0x1.e2121p-1, -0x1.3da1bap-27, 0x1.a0298ep-52),
    FPR(0x1.58f9a8p-2, -0x1.4a9c04p-27, -0x1.80f7eep-53),
    FPR(0x1.f0a7fp-1, -0x1.1b73cap-27, -0x1.ab4e14p-54),
    FPR(0x1.f19f98p-3, -0x1.37a83ap-29, 0x1.57a422p-54),
    FPR(-0x1.f19f98p-3, 0x1.37a83ap-29, -0x1.57a422p-54),
    FPR(0x1.f0a7fp-1, -0x1.1b73cap-27, -0x1.ab4e14p-54),
    FPR(0x1.07387ap-1, -0x1.b74004p-27, -0x1.34b402p-52),
    FPR(0x1.b72834p-1, 0x1.465b9p-27, -0x1.378d3ep-52),
    FPR(-0x1.b72834p-1, -0x1.465b9p-27, 0x1.378d3ep-52),
    FPR(0x1.07387ap-1, -0x1.b74004p-27, -0x1.34b402p-52),
    FPR(0x1.9b3e04p-1, 0x1.fce1dp-27, 0x1.6788ecp-54),
    FPR(0x1.30ff8p-1, -0x1.8f47e6p-28, 0x1.c20674p-54),
    FPR(-0x1.30ff8p-1, 0x1.8f47e6p-28, -0x1.c20674p-54),
    FPR(0x1.9b3e04p-1, 0x1.fce1dp-27, 0x1.6788ecp-54),
    FPR(0x1.2c8106p-3, 0x1.d1cc28p-28, -0x1.7768p-53),
    FPR(0x1.fa7558p-1, -0x1.eeb5d2p-30, -0x1.7a0a8cp-55),
    FPR(-0x1.fa7558p-1, 0x1.eeb5d2p-30, 0x1.7a0a8cp-55),
    FPR(0x1.2c8106p-3, 0x1.d1cc28p-28, -0x1.7768p-53),
    FPR(0x1.fa7558p-1, -0x1.eeb5d2p-30, -0x1.7a0a8cp-55),
    FPR(0x1.2c8106p-3, 0x1.d1cc28p-28, -0x1.7768p-53),
    FPR(-0x1.2c8106p-3, -0x1.d1cc28p-28, 0x1.7768p-53),
    FPR(0x1.fa7558p-1, -0x1.eeb5d2p-30, -0x1.7a0a8cp-55),
    FPR(0x1.30ff8p-1, -0x1.8f47e6p-28, 0x1.c20674p-54),
    FPR(0x1.9b3e04p-1, 0x1.fce1dp-27, 0x1.6788ecp-54),
    FPR(-0x1.9b3e04p-1, -0x1.fce1dp-27, -0x1.6788ecp-54),
    FPR(0x1.30ff8p-1, -0x1.8f47e6p-28, 0x1.c20674p-54),
    FPR(0x1.b72834p-1, 0x1.465b9p-27, -0x1.378d3ep-52),
    FPR(0x1.07387ap-1, -0x1.b74004p-27, -0x1.34b402p-52),
    FPR(-0x1.07387ap-1, 0x1.b74004p-27, 0x1.34b402p-52),
    FPR(0x1.b72834p-1, 0x1.465b9p-27, -0x1.378d3ep-52),
    FPR(0x1.f19f98p-3, -0x1.37a83ap-29, 0x1.57a422p-54),
    FPR(0x1.f0a7fp-1, -0x1.1b73cap-27, -0x1.ab4e14p-54),
    FPR(-0x1.f0a7fp-1, 0x1.1b73cap-27, 0x1.ab4e14p-54),
    FPR(0x1.f19f98p-3, -0x1.37a83ap-29, 0x1.57a422p-54),
    FPR(0x1.e2121p-1, 0x1.3da1bap-27, -0x1.a0298ep-52),
    FPR(0x1.58f9a8p-2, -0x1.4a9c04p-27, -0x1.80f7eep-53),
    FPR(-0x1.58f9a8p-2, 0x1.4a9c04p-27, 0x1.80f7eep-53),
    FPR(0x1.e2121p-1, 0x1.3da1bap-27, -0x1.a0298ep-52),
    FPR(0x1.b5d1p-2, 0x1.3c2b98p-27, 0x1.5b362cp-57),
    FPR(0x1.ced7bp-1, -0x1.786712p-26, 0x1.786126p-52),
    FPR(-0x1.ced7bp-1, 0x1.786712p-26, -0x1.786126p-52),
    FPR(0x1.b5d1p-2, 0x1.3c2b98p-27, 0x1.5b362cp-57),
    FPR(0x1.7b5df2p-1, 0x1.3557d8p-28, -0x1.21ea7p-53),
    FPR(0x1.57d694p-1, -0x1.6e626cp-26, -0x1.75720ap-55),
    FPR(-0x1.57d694p-1, 0x1.6e626cp-26, 0x1.75720ap-55),
    FPR(0x1.7b5df2p-1, 0x1.3557d8p-28, -0x1.21ea7p-53),
    FPR(0x1.91f66p-5, -0x1.de44fep-30, 0x1.f376a2p-56),
    FPR(0x1.ff621ep-1, 0x1.bcb6bep-28, 0x1.e3a844p-53),
    FPR(-0x1.ff621ep-1, -0x1.bcb6bep-28, -0x1.e3a844p-53),
    FPR(0x1.91f66p-5, -0x1.de44fep-30, 0x1.f376a2p-56),
    FPR(0x1.ffd886p-1, 0x1.099a1ap-30, -0x1.1354d4p-55),
    FPR(0x1.92156p-6, -0x1.0b933p-31, -0x1.0363acp-57),
    FPR(-0x1.92156p-6, 0x1.0b933p-31, 0x1.0363acp-57),
    FPR(0x1.ffd886p-1, 0x1.099a1ap-30, -0x1.1354d4p-55),
    FPR(0x1.610b76p-1, -0x1.5c5a64p-26, -0x1.24a366p-53),
    FPR(0x1.72d084p-1, -0x1.02000ep-26, 0x1.90d4fp-51),
    FPR(-0x1.72d084p-1, 0x1.02000ep-26, -0x1.90d4fp-51),
    FPR(0x1.610b76p-1, -0x1.5c5a64p-26, -0x1.24a366p-53),
    FPR(0x1.d4134ep-1, -0x1.d646d8p-26, -0x1.94ef52p-51),
    FPR(0x1.9ef794p-2, 0x1.d476c6p-29, -0x1.d24afep-54),
    FPR(-0x1.9ef794p-2, -0x1.d476c6p-29, 0x1.d24afep-54),
    FPR(0x1.d4134ep-1, -0x1.d646d8p-26, -0x1.94ef52p-51),
    FPR(0x1.708854p-2, -0x1.e0b74cp-27, -0x1.512c68p-54),
    FPR(0x1.ddb13cp-1, -0x1.2667b8p-26, -0x1.cf879p-52),
    FPR(-0x1.ddb13cp-1, 0x1.2667b8p-26, 0x1.cf879p-52),
    FPR(0x1.708854p-2, -0x1.e0b74cp-27, -0x1.512c68p-54),
    FPR(0x1.f38f3ap-1, 0x1.8c9cb2p-26, -0x1.cebdd8p-51),
    FPR(0x1.c0b826p-3, 0x1.4fc9ecp-28, 0x1.7e50ecp-54),
    FPR(-0x1.c0b826p-3, -0x1.4fc9ecp-28, -0x1.7e50ecp-54),
    FPR(0x1.f38f3ap-1, 0x1.8c9cb2p-26, -0x1.cebdd8p-51),
    FPR(0x1.11eb36p-1, -0x1.7c969cp-26, 0x1.421b8ap-52),
    FPR(0x1.b090a6p-1, -0x1.fabf8p-27, -0x1.926da4p-55),
    FPR(-0x1.b090a6p-1, 0x1.fabf8p-27, 0x1.926da4p-55),
    FPR(0x1.11eb36p-1, -0x1.7c969cp-26, 0x1.421b8ap-52),
    FPR(0x1.a29a7ap-1, 0x1.189e08p-31, -0x1.128bbp-56),
    FPR(0x1.26d054p-1, 0x1.9ba25cp-26, -0x1.5769dp-53),
    FPR(-0x1.26d054p-1, -0x1.9ba25cp-26, 0x1.5769dp-53),
    FPR(0x1.a29a7ap-1, 0x1.189e08p-31, -0x1.128bbp-56),
    FPR(0x1.5e2144p-3, 0x1.22cff2p-29, -0x1.ab3802p-55),
    FPR(0x1.f8765p-1, -0x1.63ad16p-27, 0x1.3564acp-53),
    FPR(-0x1.f8765p-1, 0x1.63ad16p-27, -0x1.3564acp-53),
    FPR(0x1.5e2144p-3, 0x1.22cff2p-29, -0x1.ab3802p-55),
    FPR(0x1.fc2648p-1, -0x1.e3cc06p-26, 0x1.a3d90cp-52),
    FPR(0x1.f564e6p-4, -0x1.2ad19ep-29, -0x1.cbb1f8p-56),
    FPR(-0x1.f564e6p-4, 0x1.2ad19ep-29, 0x1.cbb1f8p-56),
    FPR(0x1.fc2648p-1, -0x1.e3cc06p-26, 0x1.a3d90cp-52),
    FPR(0x1.3affa2p-1, 0x1.240a18p-26, -0x1.b0e0eep-51),
    FPR(0x1.93a224p-1, 0x1.324c8p-26, -0x1.2c2be6p-51),
    FPR(-0x1.93a224p-1, -0x1.324c8p-26, 0x1.2c2be6p-51),
    FPR(0x1.3affa2p-1, 0x1.240a18p-26, -0x1.b0e0eep-51),
    FPR(0x1.bd7c0ap-1, 0x1.8df2a6p-26, -0x1.9825a8p-51),
    FPR(0x1.f8ba4ep-2, -0x1.01d952p-28, 0x1.fb44f8p-54),
    FPR(-0x1.f8ba4ep-2, 0x1.01d952p-28, -0x1.fb44f8p-54),
    FPR(0x1.bd7c0ap-1, 0x1.8df2a6p-26, -0x1.9825a8p-51),
    FPR(0x1.111d26p-2, 0x1.58fb3cp-29, -0x1.3ed9fp-55),
    FPR(0x1.ed740ep-1, 0x1.da1258p-27, 0x1.9e82c8p-52),
    FPR(-0x1.ed740ep-1, -0x1.da1258p-27, -0x1.9e82c8p-52),
    FPR(0x1.111d26p-2, 0x1.58fb3cp-29, -0x1.3ed9fp-55),
    FPR(0x1.e6288ep-1, 0x1.891c22p-26, 0x1.ee94aap-53),
    FPR(0x1.4135cap-2, -0x1.7d134p-27, 0x1.4325f2p-54),
    FPR(-0x1.4135cap-2, 0x1.7d134p-27, -0x1.4325f2p-54),
    FPR(0x1.e6288ep-1, 0x1.891c22p-26, 0x1.ee94aap-53),
    FPR(0x1.cc66eap-2, -0x1.b38ee8p-28, -0x1.e97af2p-54),
    FPR(0x1.c954b2p-1, 0x1.3411f4p-29, 0x1.ed048ap-54),
    FPR(-0x1.c954b2p-1, -0x1.3411f4p-29, -0x1.ed048ap-54),
    FPR(0x1.cc66eap-2, -0x1.b38ee8p-28, -0x1.e97af2p-54),
    FPR(0x1.83b0ep-1, 0x1.7ff2eep-26, -0x1.16f42p-52),
    FPR(0x1.4e6cacp-1, -0x1.070686p-27, 0x1.13c294p-53),
    FPR(-0x1.4e6cacp-1, 0x1.070686p-27, -0x1.13c294p-53),
    FPR(0x1.83b0ep-1, 0x1.7ff2eep-26, -0x1.16f42p-52),
    FPR(0x1.2d520ap-4, -0x1.a63cc2p-29, 0x1.732fbcp-54),
    FPR(0x1.fe9cdap-1, 0x1.a03108p-26, -0x1.7ab784p-51),
    FPR(-0x1.fe9cdap-1, -0x1.a03108p-26, 0x1.7ab784p-51),
    FPR(0x1.2d520ap-4, -0x1.a63cc2p-29, 0x1.732fbcp-54),
    FPR(0x1.fe9cdap-1, 0x1.a03108p-26, -0x1.7ab784p-51),
    FPR(0x1.2d520ap-4, -0x1.a63cc2p-29, 0x1.732fbcp-54),
    FPR(-0x1.2d520ap-4, 0x1.a63cc2p-29, -0x1.732fbcp-54),
    FPR(0x1.fe9cdap-1, 0x1.a03108p-26, -0x1.7ab784p-51),
    FPR(0x1.4e6cacp-1, -0x1.070686p-27, 0x1.13c294p-53),
    FPR(0x1.83b0ep-1, 0x1.7ff2eep-26, -0x1.16f42p-52),
    FPR(-0x1.83b0ep-1, -0x1.7ff2eep-26, 0x1.16f42p-52),
    FPR(0x1.4e6cacp-1, -0x1.070686p-27, 0x1.13c294p-53),
    FPR(0x1.c954b2p-1, 0x1.3411f4p-29, 0x1.ed048ap-54),
    FPR(0x1.cc66eap-2, -0x1.b38ee8p-28, -0x1.e97af2p-54),
    FPR(-0x1.cc66eap-2, 0x1.b38ee8p-28, 0x1.e97af2p-54),
    FPR(0x1.c954b2p-1, 0x1.3411f4p-29, 0x1.ed048ap-54),
    FPR(0x1.4135cap-2, -0x1.7d134p-27, 0x1.4325f2p-54),
    FPR(0x1.e6288ep-1, 0x1.891c22p-26, 0x1.ee94aap-53),
    FPR(-0x1.e6288ep-1, -0x1.891c22p-26, -0x1.ee94aap-53),
    FPR(0x1.4135cap-2, -0x1.7d134p-27, 0x1.4325f2p-54),
    FPR(0x1.ed740ep-1, 0x1.da1258p-27, 0x1.9e82c8p-52),
    FPR(0x1.111d26p-2, 0x1.58fb3cp-29, -0x1.3ed9fp-55),
    FPR(-0x1.111d26p-2, -0x1.58fb3cp-29, 0x1.3ed9fp-55),
    FPR(0x1.ed740ep-1, 0x1.da1258p-27, 0x1.9e82c8p-52),
    FPR(0x1.f8ba4ep-2, -0x1.01d952p-28, 0x1.fb44f8p-54),
    FPR(0x1.bd7c0ap-1, 0x1.8df2a6p-26, -0x1.9825a8p-51),
    FPR(-0x1.bd7c0ap-1, -0x1.8df2a6p-26, 0x1.9825a8p-51),
    FPR(0x1.f8ba4ep-2, -0x1.01d952p-28, 0x1.fb44f8p-54),
    FPR(0x1.93a224p-1, 0x1.324c8p-26, -0x1.2c2be6p-51),
    FPR(0x1.3affa2p-1, 0x1.240a18p-26, -0x1.b0e0eep-51),
    FPR(-0x1.3affa2p-1, -0x1.240a18p-26, 0x1.b0e0eep-51),
    FPR(0x1.93a224p-1, 0x1.324c8p-26, -0x1.2c2be6p-51),
    FPR(0x1.f564e6p-4, -0x1.2ad19ep-29, -0x1.cbb1f8p-56),
    FPR(0x1.fc2648p-1, -0x1.e3cc06p-26, 0x1.a3d90cp-52),
    FPR(-0x1.fc2648p-1, 0x1.e3cc06p-26, -0x1.a3d90cp-52),
    FPR(0x1.f564e6p-4, -0x1.2ad19ep-29, -0x1.cbb1f8p-56),
    FPR(0x1.f8765p-1, -0x1.63ad16p-27, 0x1.3564acp-53),
    FPR(0x1.5e2144p-3, 0x1.22cff2p-29, -0x1.ab3802p-55),
    FPR(-0x1.5e2144p-3, -0x1.22cff2p-29, 0x1.ab3802p-55),
    FPR(0x1.f8765p-1, -0x1.63ad16p-27, 0x1.3564acp-53),
    FPR(0x1.26d054p-1, 0x1.9ba25cp-26, -0x1.5769dp-53),
    FPR(0x1.a29a7ap-1, 0x1.189e08p-31, -0x1.128bbp-56),
    FPR(-0x1.a29a7ap-1, -0x1.189e08p-31, 0x1.128bbp-56),
    FPR(0x1.26d054p-1, 0x1.9ba25cp-26, -0x1.5769dp-53),
    FPR(0x1.b090a6p-1, -0x1.fabf8p-27, -0x1.926da4p-55),
    FPR(0x1.11eb36p-1, -0x1.7c969cp-26, 0x1.421b8ap-52),
    FPR(-0x1.11eb36p-1, 0x1.7c969cp-26, -0x1.421b8ap-52),
    FPR(0x1.b090a6p-1, -0x1.fabf8p-27, -0x1.926da4p-55),
    FPR(0x1.c0b826p-3, 0x1.4fc9ecp-28, 0x1.7e50ecp-54),
    FPR(0x1.f38f3ap-1, 0x1.8c9cb2p-26, -0x1.cebdd8p-51),
    FPR(-0x1.f38f3ap-1, -0x1.8c9cb2p-26, 0x1.cebdd8p-51),
    FPR(0x1.c0b826p-3, 0x1.4fc9ecp-28, 0x1.7e50ecp-54),
    FPR(0x1.ddb13cp-1, -0x1.2667b8p-26, -0x1.cf879p-52),
    FPR(0x1.708854p-2, -0x1.e0b74cp-27, -0x1.512c68p-54),
    FPR(-0x1.708854p-2, 0x1.e0b74cp-27, 0x1.512c68p-54),
    FPR(0x1.ddb13cp-1, -0x1.2667b8p-26, -0x1.cf879p-52),
    FPR(0x1.9ef794p-2, 0x1.d476c6p-29, -0x1.d24afep-54),
    FPR(0x1.d4134ep-1, -0x1.d646d8p-26, -0x1.94ef52p-51),
    FPR(-0x1.d4134ep-1, 0x1.d646d8p-26, 0x1.94ef52p-51),
    FPR(0x1.9ef794p-2, 0x1.d476c6p-29, -0x1.d24afep-54),
    FPR(0x1.72d084p-1, -0x1.02000ep-26, 0x1.90d4fp-51),
    FPR(0x1.610b76p-1, -0x1.5c5a64p-26, -0x1.24a366p-53),
    FPR(-0x1.610b76p-1, 0x1.5c5a64p-26, 0x1.24a366p-53),
    FPR(0x1.72d084p-1, -0x1.02000ep-26, 0x1.90d4fp-51),
    FPR(0x1.92156p-6, -0x1.0b933p-31, -0x1.0363acp-57),
    FPR(0x1.ffd886p-1, 0x1.099a1ap-30, -0x1.1354d4p-55),
    FPR(-0x1.ffd886p-1, -0x1.099a1ap-30, 0x1.1354d4p-55),
    FPR(0x1.92156p-6, -0x1.0b933p-31, -0x1.0363acp-57),
    FPR(0x1.fff622p-1, -0x1.2c8da4p-26, -0x1.2a225cp-51),
    FPR(0x1.921d2p-7, -0x1.909c3ep-34, 0x1.9878ecp-61),
    FPR(-0x1.921d2p-7, 0x1.909c3ep-34, -0x1.9878ecp-61),
    FPR(0x1.fff622p-1, -0x1.2c8da4p-26, -0x1.2a225cp-51),
    FPR(0x1.659192p-1, 0x1.7c1e1p-27, -0x1.478536p-52),
    FPR(0x1.6e7446p-1, -0x1.62aaeap-26, -0x1.76f01p-53),
    FPR(-0x1.6e7446p-1, 0x1.62aaeap-26, 0x1.76f01p-53),
    FPR(0x1.659192p-1, 0x1.7c1e1p-27, -0x1.478536p-52),
    FPR(0x1.d69618p-1, -0x1.86c32ep-26, -0x1.4f463p-51),
    FPR(0x1.9372a6p-2, 0x1.de49ecp-29, -0x1.a5ef3ap-55),
    FPR(-0x1.9372a6p-2, -0x1.de49ecp-29, 0x1.a5ef3ap-55),
    FPR(0x1.d69618p-1, -0x1.86c32ep-26, -0x1.4f463p-51),
    FPR(0x1.7c3a94p-2, -0x1.dc4664p-27, 0x1.c0669p-52),
    FPR(0x1.db6526p-1, 0x1.1c504ep-28, -0x1.35bddp-53),
    FPR(-0x1.db6526p-1, -0x1.1c504ep-28, 0x1.35bddp-53),
    FPR(0x1.7c3a94p-2, -0x1.dc4664p-27, 0x1.c0669p-52),
    FPR(0x1.f4e604p-1, -0x1.3d3434p-27, -0x1.98ee02p-52),
    FPR(0x1.a82a02p-3, 0x1.6c0114p-29, 0x1.3c37dp-56),
    FPR(-0x1.a82a02p-3, -0x1.6c0114p-29, -0x1.3c37dp-56),
    FPR(0x1.f4e604p-1, -0x1.3d3434p-27, -0x1.98ee02p-52),
    FPR(0x1.1734d6p-1, 0x1.ef6da4p-28, 0x1.40886ap-54),
    FPR(0x1.ad2bcap-1, -0x1.de2afp-29, 0x1.5c021p-54),
    FPR(-0x1.ad2bcap-1, 0x1.de2afp-29, -0x1.5c021p-54),
    FPR(0x1.1734d6p-1, 0x1.ef6da4p-28, 0x1.40886ap-54),
    FPR(0x1.a63092p-1, -0x1.3f4148p-27, 0x1.c2dddep-53),
    FPR(0x1.21a79ap-1, -0x1.b3052ap-27, 0x1.62c274p-54),
    FPR(-0x1.21a79ap-1, 0x1.b3052ap-27, -0x1.62c274p-54),
    FPR(0x1.a63092p-1, -0x1.3f4148p-27, 0x1.c2dddep-53),
    FPR(0x1.76dd9ep-3, -0x1.af40cep-31, -0x1.715088p-56),
    FPR(0x1.f7599ap-1, 0x1.d0903cp-28, -0x1.3d8672p-54),
    FPR(-0x1.f7599ap-1, -0x1.d0903cp-28, 0x1.3d8672p-54),
    FPR(0x1.76dd9ep-3, -0x1.af40cep-31, -0x1.715088p-56),
    FPR(0x1.fce16p-1, -0x1.492cc2p-28, -0x1.2bbaep-53),
    FPR(0x1.c3785cp-4, 0x1.e7b0b6p-30, -0x1.853ce8p-55),
    FPR(-0x1.c3785cp-4, -0x1.e7b0b6p-30, 0x1.853ce8p-55),
    FPR(0x1.fce16p-1, -0x1.492cc2p-28, -0x1.2bbaep-53),
    FPR(0x1.3fed96p-1, -0x1.975526p-26, 0x1.136916p-51),
    FPR(0x1.8fbccap-1, 0x1.f7ca06p-28, 0x1.d240acp-54),
    FPR(-0x1.8fbccap-1, -0x1.f7ca06p-28, -0x1.d240acp-54),
    FPR(0x1.3fed96p-1, -0x1.975526p-26, 0x1.136916p-51),
    FPR(0x1.c08c42p-1, 0x1.9c9552p-27, 0x1.0d8acp-53),
    FPR(0x1.edc196p-2, -0x1.a210e6p-27, 0x1.622f08p-52),
    FPR(-0x1.edc196p-2, 0x1.a210e6p-27, -0x1.622f08p-52),
    FPR(0x1.c08c42p-1, 0x1.9c9552p-27, 0x1.0d8acp-53),
    FPR(0x1.1d3444p-2, -0x1.664984p-31, -0x1.720d42p-57),
    FPR(0x1.ebbd8cp-1, 0x1.1be16ep-26, 0x1.0e3646p-51),
    FPR(-0x1.ebbd8cp-1, -0x1.1be16ep-26, -0x1.0e3646p-51),
    FPR(0x1.1d3444p-2, -0x1.664984p-31, -0x1.720d42p-57),
    FPR(0x1.e817bap-1, 0x1.699a22p-26, -0x1.9d0afep-52),
    FPR(0x1.35410cp-2, 0x1.70c0a8p-29, 0x1.b0d4p-54),
    FPR(-0x1.35410cp-2, -0x1.70c0a8p-29, -0x1.b0d4p-54),
    FPR(0x1.e817bap-1, 0x1.699a22p-26, -0x1.9d0afep-52),
    FPR(0x1.d79776p-2, -0x1.1e471ep-28, 0x1.5543b2p-54),
    FPR(0x1.c678b4p-1, -0x1.6ef18cp-26, -0x1.389e4ep-51),
    FPR(-0x1.c678b4p-1, 0x1.6ef18cp-26, 0x1.389e4ep-51),
    FPR(0x1.d79776p-2, -0x1.1e471ep-28, 0x1.5543b2p-54),
    FPR(0x1.87c4p-1, 0x1.f745d8p-26, -0x1.4b6afp-53),
    FPR(0x1.49a44ap-1, -0x1.193db2p-27, 0x1.6c08f4p-54),
    FPR(-0x1.49a44ap-1, 0x1.193db2p-27, -0x1.6c08f4p-54),
    FPR(0x1.87c4p-1, 0x1.f745d8p-26, -0x1.4b6afp-53),
    FPR(0x1.5f6dp-4, 0x1.535484p-29, -0x1.cfa012p-54),
    FPR(0x1.fe1cbp-1, -0x1.a1527cp-28, 0x1.1a23e4p-53),
    FPR(-0x1.fe1cbp-1, 0x1.a1527cp-28, -0x1.1a23e4p-53),
    FPR(0x1.5f6dp-4, 0x1.535484p-29, -0x1.cfa012p-54),
    FPR(0x1.ff0956p-1, 0x1.639c6cp-27, -0x1.5fcae6p-52),
    FPR(0x1.f656e8p-5, -0x1.81f7c8p-31, -0x1.2e1ebep-61),
    FPR(-0x1.f656e8p-5, 0x1.81f7c8p-31, 0x1.2e1ebep-61),
    FPR(0x1.ff0956p-1, 0x1.639c6cp-27, -0x1.5fcae6p-52),
    FPR(0x1.53282ap-1, -0x1.ab954ep-26, 0x1.72f68ap-51),
    FPR(0x1.7f8ecep-1, 0x1.ab8bb8p-28, 0x1.31b93ap-54),
    FPR(-0x1.7f8ecep-1, -0x1.ab8bb8p-28, -0x1.31b93ap-54),
    FPR(0x1.53282ap-1, -0x1.ab954ep-26, 0x1.72f68ap-51),
    FPR(0x1.cc1f1p-1, -0x1.806074p-26, -0x1.e1a89ep-52),
    FPR(0x1.c1249ep-2, -0x1.ffb846p-28, -0x1.604eaap-54),
    FPR(-0x1.c1249ep-2, 0x1.ffb846p-28, 0x1.604eaap-54),
    FPR(0x1.cc1f1p-1, -0x1.806074p-26, -0x1.e1a89ep-52),
    FPR(0x1.4d1e24p-2, 0x1.3c73b6p-29, -0x1.db7d1cp-54),
    FPR(0x1.e426a4p-1, 0x1.65783p-26, -0x1.95e31ep-53),
    FPR(-0x1.e426a4p-1, -0x1.65783p-26, 0x1.95e31ep-53),
    FPR(0x1.4d1e24p-2, 0x1.3c73b6p-29, -0x1.db7d1cp-54),
    FPR(0x1.ef178ap-1, 0x1.f239e2p-28, -0x1.a73bd6p-53),
    FPR(0x1.04fb8p-2, 0x1.c6ffb6p-27, -0x1.00504cp-53),
    FPR(-0x1.04fb8p-2, -0x1.c6ffb6p-27, 0x1.00504cp-53),
    FPR(0x1.ef178ap-1, 0x1.f239e2p-28, -0x1.a73bd6p-53),
    FPR(0x1.01cfc8p-1, 0x1.d30faep-27, -0x1.26946cp-53),
    FPR(0x1.ba5aa6p-1, 0x1.cd6434p-27, 0x1.2fd49cp-52),
    FPR(-0x1.ba5aa6p-1, -0x1.cd6434p-27, -0x1.2fd49cp-52),
    FPR(0x1.01cfc8p-1, 0x1.d30faep-27, -0x1.26946cp-53),
    FPR(0x1.9777fp-1, -0x1.670518p-26, 0x1.baae1ap-53),
    FPR(0x1.36058cp-1, -0x1.df34c2p-26, 0x1.5c0698p-52),
    FPR(-0x1.36058cp-1, 0x1.df34c2p-26, -0x1.5c0698p-52),
    FPR(0x1.9777fp-1, -0x1.670518p-26, 0x1.baae1ap-53),
    FPR(0x1.139f0cp-3, 0x1.db5eaep-28, 0x1.aadcbcp-53),
    FPR(0x1.fb5798p-1, -0x1.cd4518p-26, 0x1.237f58p-53),
    FPR(-0x1.fb5798p-1, 0x1.cd4518p-26, -0x1.237f58p-53),
    FPR(0x1.139f0cp-3, 0x1.db5eaep-28, 0x1.aadcbcp-53),
    FPR(0x1.f97f92p-1, 0x1.324266p-27, 0x1.43aa3ep-52),
    FPR(0x1.45576cp-3, -0x1.dad834p-28, -0x1.8942d2p-53),
    FPR(-0x1.45576cp-3, 0x1.dad834p-28, 0x1.8942d2p-53),
    FPR(0x1.f97f92p-1, 0x1.324266p-27, 0x1.43aa3ep-52),
    FPR(0x1.2bedb2p-1, 0x1.7ebcfap-27, 0x1.f75b4p-53),
    FPR(0x1.9ef43ep-1, 0x1.e535f2p-26, 0x1.0d8efep-51),
    FPR(-0x1.9ef43ep-1, -0x1.e535f2p-26, -0x1.0d8efep-51),
    FPR(0x1.2bedb2p-1, 0x1.7ebcfap-27, 0x1.f75b4p-53),
    FPR(0x1.b3e4d4p-1, -0x1.0aa8eep-29, -0x1.eb6b8cp-55),
    FPR(0x1.0c9704p-1, 0x1.abb132p-26, -0x1.634f6p-53),
    FPR(-0x1.0c9704p-1, -0x1.abb132p-26, 0x1.634f6p-53),
    FPR(0x1.b3e4d4p-1, -0x1.0aa8eep-29, -0x1.eb6b8cp-55),
    FPR(0x1.d934fep-3, 0x1.5150c4p-29, 0x1.5d6e48p-55),
    FPR(0x1.f2253p-1, -0x1.1138a4p-26, -0x1.920cb8p-51),
    FPR(-0x1.f2253p-1, 0x1.1138a4p-26, 0x1.920cb8p-51),
    FPR(0x1.d934fep-3, 0x1.5150c4p-29, 0x1.5d6e48p-55),
    FPR(0x1.dfeae6p-1, 0x1.16df16p-28, -0x1.5453aap-53),
    FPR(0x1.64c7dep-2, -0x1.606c1cp-29, -0x1.eef2d4p-54),
    FPR(-0x1.64c7dep-2, 0x1.606c1cp-29, 0x1.eef2d4p-54),
    FPR(0x1.dfeae6p-1, 0x1.16df16p-28, -0x1.5453aap-53),
    FPR(0x1.aa6c82p-2, 0x1.6da7fap-27, -0x1.9d5f1p-52),
    FPR(0x1.d17e78p-1, -0x1.783944p-26, -0x1.02203cp-51),
    FPR(-0x1.d17e78p-1, 0x1.783944p-26, 0x1.02203cp-51),
    FPR(0x1.aa6c82p-2, 0x1.6da7fap-27, -0x1.9d5f1p-52),
    FPR(0x1.771e76p-1, -0x1.f91b3ep-30, 0x1.5cfce8p-56),
    FPR(0x1.5c77bcp-1, -0x1.9afe74p-29, 0x1.069eaap-55),
    FPR(-0x1.5c77bcp-1, 0x1.9afe74p-29, -0x1.069eaap-55),
    FPR(0x1.771e76p-1, -0x1.f91b3ep-30, 0x1.5cfce8p-56),
    FPR(0x1.2d8658p-5, -0x1.4d7546p-30, -0x1.74bc84p-56),
    FPR(0x1.ffa72ep-1, 0x1.ffdeecp-26, -0x1.b1699cp-52),
    FPR(-0x1.ffa72ep-1, -0x1.ffdeecp-26, 0x1.b1699cp-52),
    FPR(0x1.2d8658p-5, -0x1.4d7546p-30, -0x1.74bc84p-56),
    FPR(0x1.ffa72ep-1, 0x1.ffdeecp-26, -0x1.b1699cp-52),
    FPR(0x1.2d8658p-5, -0x1.4d7546p-30, -0x1.74bc84p-56),
    FPR(-0x1.2d8658p-5, 0x1.4d7546p-30, 0x1.74bc84p-56),
    FPR(0x1.ffa72ep-1, 0x1.ffdeecp-26, -0x1.b1699cp-52),
    FPR(0x1.5c77bcp-1, -0x1.9afe74p-29, 0x1.069eaap-55),
    FPR(0x1.771e76p-1, -0x1.f91b3ep-30, 0x1.5cfce8p-56),
    FPR(-0x1.771e76p-1, 0x1.f91b3ep-30, -0x1.5cfce8p-56),
    FPR(0x1.5c77bcp-1, -0x1.9afe74p-29, 0x1.069eaap-55),
    FPR(0x1.d17e78p-1, -0x1.783944p-26, -0x1.02203cp-51),
    FPR(0x1.aa6c82p-2, 0x1.6da7fap-27, -0x1.9d5f1p-52),
    FPR(-0x1.aa6c82p-2, -0x1.6da7fap-27, 0x1.9d5f1p-52),
    FPR(0x1.d17e78p-1, -0x1.783944p-26, -0x1.02203cp-51),
    FPR(0x1.64c7dep-2, -0x1.606c1cp-29, -0x1.eef2d4p-54),
    FPR(0x1.dfeae6p-1, 0x1.16df16p-28, -0x1.5453aap-53),
    FPR(-0x1.dfeae6p-1, -0x1.16df16p-28, 0x1.5453aap-53),
    FPR(0x1.64c7dep-2, -0x1.606c1cp-29, -0x1.eef2d4p-54),
    FPR(0x1.f2253p-1, -0x1.1138a4p-26, -0x1.920cb8p-51),
    FPR(0x1.d934fep-3, 0x1.5150c4p-29, 0x1.5d6e48p-55),
    FPR(-0x1.d934fep-3, -0x1.5150c4p-29, -0x1.5d6e48p-55),
    FPR(0x1.f2253p-1, -0x1.1138a4p-26, -0x1.920cb8p-51),
    FPR(0x1.0c9704p-1, 0x1.abb132p-26, -0x1.634f6p-53),
    FPR(0x1.b3e4d4p-1, -0x1.0aa8eep-29, -0x1.eb6b8cp-55),
    FPR(-0x1.b3e4d4p-1, 0x1.0aa8eep-29, 0x1.eb6b8cp-55),
    FPR(0x1.0c9704p-1, 0x1.abb132p-26, -0x1.634f6p-53),
    FPR(0x1.9ef43ep-1, 0x1.e535f2p-26, 0x1.0d8efep-51),
    FPR(0x1.2bedb2p-1, 0x1.7ebcfap-27, 0x1.f75b4p-53),
    FPR(-0x1.2bedb2p-1, -0x1.7ebcfap-27, -0x1.f75b4p-53),
    FPR(0x1.9ef43ep-1, 0x1.e535f2p-26, 0x1.0d8efep-51),
    FPR(0x1.45576cp-3, -0x1.dad834p-28, -0x1.8942d2p-53),
    FPR(0x1.f97f92p-1, 0x1.324266p-27, 0x1.43aa3ep-52),
    FPR(-0x1.f97f92p-1, -0x1.324266p-27, -0x1.43aa3ep-52),
    FPR(0x1.45576cp-3, -0x1.dad834p-28, -0x1.8942d2p-53),
    FPR(0x1.fb5798p-1, -0x1.cd4518p-26, 0x1.237f58p-53),
    FPR(0x1.139f0cp-3, 0x1.db5eaep-28, 0x1.aadcbcp-53),
    FPR(-0x1.139f0cp-3, -0x1.db5eaep-28, -0x1.aadcbcp-53),
    FPR(0x1.fb5798p-1, -0x1.cd4518p-26, 0x1.237f58p-53),
    FPR(0x1.36058cp-1, -0x1.df34c2p-26, 0x1.5c0698p-52),
    FPR(0x1.9777fp-1, -0x1.670518p-26, 0x1.baae1ap-53),
    FPR(-0x1.9777fp-1, 0x1.670518p-26, -0x1.baae1ap-53),
    FPR(0x1.36058cp-1, -0x1.df34c2p-26, 0x1.5c0698p-52),
    FPR(0x1.ba5aa6p-1, 0x1.cd6434p-27, 0x1.2fd49cp-52),
    FPR(0x1.01cfc8p-1, 0x1.d30faep-27, -0x1.26946cp-53),
    FPR(-0x1.01cfc8p-1, -0x1.d30faep-27, 0x1.26946cp-53),
    FPR(0x1.ba5aa6p-1, 0x1.cd6434p-27, 0x1.2fd49cp-52),
    FPR(0x1.04fb8p-2, 0x1.c6ffb6p-27, -0x1.00504cp-53),
    FPR(0x1.ef178ap-1, 0x1.f239e2p-28, -0x1.a73bd6p-53),
    FPR(-0x1.ef178ap-1, -0x1.f239e2p-28, 0x1.a73bd6p-53),
    FPR(0x1.04fb8p-2, 0x1.c6ffb6p-27, -0x1.00504cp-53),
    FPR(0x1.e426a4p-1, 0x1.65783p-26, -0x1.95e31ep-53),
    FPR(0x1.4d1e24p-2, 0x1.3c73b6p-29, -0x1.db7d1cp-54),
    FPR(-0x1.4d1e24p-2, -0x1.3c73b6p-29, 0x1.db7d1cp-54),
    FPR(0x1.e426a4p-1, 0x1.65783p-26, -0x1.95e31ep-53),
    FPR(0x1.c1249ep-2, -0x1.ffb846p-28, -0x1.604eaap-54),
    FPR(0x1.cc1f1p-1, -0x1.806074p-26, -0x1.e1a89ep-52),
    FPR(-0x1.cc1f1p-1, 0x1.806074p-26, 0x1.e1a89ep-52),
    FPR(0x1.c1249ep-2, -0x1.ffb846p-28, -0x1.604eaap-54),
    FPR(0x1.7f8ecep-1, 0x1.ab8bb8p-28, 0x1.31b93ap-54),
    FPR(0x1.53282ap-1, -0x1.ab954ep-26, 0x1.72f68ap-51),
    FPR(-0x1.53282ap-1, 0x1.ab954ep-26, -0x1.72f68ap-51),
    FPR(0x1.7f8ecep-1, 0x1.ab8bb8p-28, 0x1.31b93ap-54),
    FPR(0x1.f656e8p-5, -0x1.81f7c8p-31, -0x1.2e1ebep-61),
    FPR(0x1.ff0956p-1, 0x1.639c6cp-27, -0x1.5fcae6p-52),
    FPR(-0x1.ff0956p-1, -0x1.639c6cp-27, 0x1.5fcae6p-52),
    FPR(0x1.f656e8p-5, -0x1.81f7c8p-31, -0x1.2e1ebep-61),
    FPR(0x1.fe1cbp-1, -0x1.a1527cp-28, 0x1.1a23e4p-53),
    FPR(0x1.5f6dp-4, 0x1.535484p-29, -0x1.cfa012p-54),
    FPR(-0x1.5f6dp-4, -0x1.535484p-29, 0x1.cfa012p-54),
    FPR(0x1.fe1cbp-1, -0x1.a1527cp-28, 0x1.1a23e4p-53),
    FPR(0x1.49a44ap-1, -0x1.193db2p-27, 0x1.6c08f4p-54),
    FPR(0x1.87c4p-1, 0x1.f745d8p-26, -0x1.4b6afp-53),
    FPR(-0x1.87c4p-1, -0x1.f745d8p-26, 0x1.4b6afp-53),
    FPR(0x1.49a44ap-1, -0x1.193db2p-27, 0x1.6c08f4p-54),
    FPR(0x1.c678b4p-1, -0x1.6ef18cp-26, -0x1.389e4ep-51),
    FPR(0x1.d79776p-2, -0x1.1e471ep-28, 0x1.5543b2p-54),
    FPR(-0x1.d79776p-2, 0x1.1e471ep-28, -0x1.5543b2p-54),
    FPR(0x1.c678b4p-1, -0x1.6ef18cp-26, -0x1.389e4ep-51),
    FPR(0x1.35410cp-2, 0x1.70c0a8p-29, 0x1.b0d4p-54),
    FPR(0x1.e817bap-1, 0x1.699a22p-26, -0x1.9d0afep-52),
    FPR(-0x1.e817bap-1, -0x1.699a22p-26, 0x1.9d0afep-52),
    FPR(0x1.35410cp-2, 0x1.70c0a8p-29, 0x1.b0d4p-54),
    FPR(0x1.ebbd8cp-1, 0x1.1be16ep-26, 0x1.0e3646p-51),
    FPR(0x1.1d3444p-2, -0x1.664984p-31, -0x1.720d42p-57),
    FPR(-0x1.1d3444p-2, 0x1.664984p-31, 0x1.720d42p-57),
    FPR(0x1.ebbd8cp-1, 0x1.1be16ep-26, 0x1.0e3646p-51),
    FPR(0x1.edc196p-2, -0x1.a210e6p-27, 0x1.622f08p-52),
    FPR(0x1.c08c42p-1, 0x1.9c9552p-27, 0x1.0d8acp-53),
    FPR(-0x1.c08c42p-1, -0x1.9c9552p-27, -0x1.0d8acp-53),
    FPR(0x1.edc196p-2, -0x1.a210e6p-27, 0x1.622f08p-52),
    FPR(0x1.8fbccap-1, 0x1.f7ca06p-28, 0x1.d240acp-54),
    FPR(0x1.3fed96p-1, -0x1.975526p-26, 0x1.136916p-51),
    FPR(-0x1.3fed96p-1, 0x1.975526p-26, -0x1.136916p-51),
    FPR(0x1.8fbccap-1, 0x1.f7ca06p-28, 0x1.d240acp-54),
    FPR(0x1.c3785cp-4, 0x1.e7b0b6p-30, -0x1.853ce8p-55),
    FPR(0x1.fce16p-1, -0x1.492cc2p-28, -0x1.2bbaep-53),
    FPR(-0x1.fce16p-1, 0x1.492cc2p-28, 0x1.2bbaep-53),
    FPR(0x1.c3785cp-4, 0x1.e7b0b6p-30, -0x1.853ce8p-55),
    FPR(0x1.f7599ap-1, 0x1.d0903cp-28, -0x1.3d8672p-54),
    FPR(0x1.76dd9ep-3, -0x1.af40cep-31, -0x1.715088p-56),
    FPR(-0x1.76dd9ep-3, 0x1.af40cep-31, 0x1.715088p-56),
    FPR(0x1.f7599ap-1, 0x1.d0903cp-28, -0x1.3d8672p-54),
    FPR(0x1.21a79ap-1, -0x1.b3052ap-27, 0x1.62c274p-54),
    FPR(0x1.a63092p-1, -0x1.3f4148p-27, 0x1.c2dddep-53),
    FPR(-0x1.a63092p-1, 0x1.3f4148p-27, -0x1.c2dddep-53),
    FPR(0x1.21a79ap-1, -0x1.b3052ap-27, 0x1.62c274p-54),
    FPR(0x1.ad2bcap-1, -0x1.de2afp-29, 0x1.5c021p-54),
    FPR(0x1.1734d6p-1, 0x1.ef6da4p-28, 0x1.40886ap-54),
    FPR(-0x1.1734d6p-1, -0x1.ef6da4p-28, -0x1.40886ap-54),
    FPR(0x1.ad2bcap-1, -0x1.de2afp-29, 0x1.5c021p-54),
    FPR(0x1.a82a02p-3, 0x1.6c0114p-29, 0x1.3c37dp-56),
    FPR(0x1.f4e604p-1, -0x1.3d3434p-27, -0x1.98ee02p-52),
    FPR(-0x1.f4e604p-1, 0x1.3d3434p-27, 0x1.98ee02p-52),
    FPR(0x1.a82a02p-3, 0x1.6c0114p-29, 0x1.3c37dp-56),
    FPR(0x1.db6526p-1, 0x1.1c504ep-28, -0x1.35bddp-53),
    FPR(0x1.7c3a94p-2, -0x1.dc4664p-27, 0x1.c0669p-52),
    FPR(-0x1.7c3a94p-2, 0x1.dc4664p-27, -0x1.c0669p-52),
    FPR(0x1.db6526p-1, 0x1.1c504ep-28, -0x1.35bddp-53),
    FPR(0x1.9372a6p-2, 0x1.de49ecp-29, -0x1.a5ef3ap-55),
    FPR(0x1.d69618p-1, -0x1.86c32ep-26, -0x1.4f463p-51),
    FPR(-0x1.d69618p-1, 0x1.86c32ep-26, 0x1.4f463p-51),
    FPR(0x1.9372a6p-2, 0x1.de49ecp-29, -0x1.a5ef3ap-55),
    FPR(0x1.6e7446p-1, -0x1.62aaeap-26, -0x1.76f01p-53),
    FPR(0x1.659192p-1, 0x1.7c1e1p-27, -0x1.478536p-52),
    FPR(-0x1.659192p-1, -0x1.7c1e1p-27, 0x1.478536p-52),
    FPR(0x1.6e7446p-1, -0x1.62aaeap-26, -0x1.76f01p-53),
    FPR(0x1.921d2p-7, -0x1.909c3ep-34, 0x1.9878ecp-61),
    FPR(0x1.fff622p-1, -0x1.2c8da4p-26, -0x1.2a225cp-51),
    FPR(-0x1.fff622p-1, 0x1.2c8da4p-26, 0x1.2a225cp-51),
    FPR(0x1.921d2p-7, -0x1.909c3ep-34, 0x1.9878ecp-61),
    FPR(0x1.fffd88p-1, 0x1.63a2a4p-27, 0x1.26b38ep-52),
    FPR(0x1.921f1p-8, -0x1.98ff8ep-36, -0x1.ca8d3p-61),
    FPR(-0x1.921f1p-8, 0x1.98ff8ep-36, 0x1.ca8d3p-61),
    FPR(0x1.fffd88p-1, 0x1.63a2a4p-27, 0x1.26b38ep-52),
    FPR(0x1.67cf78p-1, 0x1.246bc4p-27, 0x1.750ab2p-59),
    FPR(0x1.6c40d8p-1, -0x1.87cfb2p-26, 0x1.449754p-51),
    FPR(-0x1.6c40d8p-1, 0x1.87cfb2p-26, -0x1.449754p-51),
    FPR(0x1.67cf78p-1, 0x1.246bc4p-27, 0x1.750ab2p-59),
    FPR(0x1.d7d0bp-1, 0x1.5c767cp-28, 0x1.6003d4p-53),
    FPR(0x1.8daa52p-2, 0x1.d91496p-27, -0x1.72eb2ep-57),
    FPR(-0x1.8daa52p-2, -0x1.d91496p-27, 0x1.72eb2ep-57),
    FPR(0x1.d7d0bp-1, 0x1.5c767cp-28, 0x1.6003d4p-53),
    FPR(0x1.820e3cp-2, -0x1.f62aa8p-27, 0x1.f9b722p-53),
    FPR(0x1.da383ap-1, 0x1.2cd13p-26, 0x1.ea7efp-51),
    FPR(-0x1.da383ap-1, -0x1.2cd13p-26, -0x1.ea7efp-51),
    FPR(0x1.820e3cp-2, -0x1.f62aa8p-27, 0x1.f9b722p-53),
    FPR(0x1.f58a2cp-1, -0x1.d0ec3p-26, 0x1.08fa5p-51),
    FPR(0x1.9bdccp-3, -0x1.a47794p-28, 0x1.99632ep-53),
    FPR(-0x1.9bdccp-3, 0x1.a47794p-28, -0x1.99632ep-53),
    FPR(0x1.f58a2cp-1, -0x1.d0ec3p-26, 0x1.08fa5p-51),
    FPR(0x1.19d5ap-1, 0x1.3e5736p-26, 0x1.fb326ap-51),
    FPR(0x1.ab7326p-1, -0x1.ba4fcap-27, -0x1.cae8e6p-52),
    FPR(-0x1.ab7326p-1, 0x1.ba4fcap-27, 0x1.cae8e6p-52),
    FPR(0x1.19d5ap-1, 0x1.3e5736p-26, 0x1.fb326ap-51),
    FPR(0x1.a7f586p-1, -0x1.ac032cp-26, -0x1.b2f488p-52),
    FPR(0x1.1f0f08p-1, 0x1.7790c4p-26, -0x1.444368p-51),
    FPR(-0x1.1f0f08p-1, -0x1.7790c4p-26, 0x1.444368p-51),
    FPR(0x1.a7f586p-1, -0x1.ac032cp-26, -0x1.b2f488p-52),
    FPR(0x1.83366ep-3, 0x1.138c98p-28, 0x1.6e6d6ap-53),
    FPR(0x1.f6c3f8p-1, -0x1.052224p-28, -0x1.9ea78cp-54),
    FPR(-0x1.f6c3f8p-1, 0x1.052224p-28, 0x1.9ea78cp-54),
    FPR(0x1.83366ep-3, 0x1.138c98p-28, 0x1.6e6d6ap-53),
    FPR(0x1.fd3792p-1, -0x1.7bbe9p-26, 0x1.152e9ep-51),
    FPR(0x1.aa7b72p-4, 0x1.1257p-30, 0x1.bca734p-55),
    FPR(-0x1.aa7b72p-4, -0x1.1257p-30, -0x1.bca734p-55),
    FPR(0x1.fd3792p-1, -0x1.7bbe9p-26, 0x1.152e9ep-51),
    FPR(0x1.425ff2p-1, -0x1.0e328ap-26, 0x1.5ece36p-53),
    FPR(0x1.8dc454p-1, -0x1.9d2ce6p-26, -0x1.f71302p-52),
    FPR(-0x1.8dc454p-1, 0x1.9d2ce6p-26, 0x1.f71302p-52),
    FPR(0x1.425ff2p-1, -0x1.0e328ap-26, 0x1.5ece36p-53),
    FPR(0x1.c20de4p-1, -0x1.5a3942p-31, 0x1.2cd752p-57),
    FPR(0x1.e83e0ep-2, 0x1.5f0a22p-27, 0x1.e843c8p-53),
    FPR(-0x1.e83e0ep-2, -0x1.5f0a22p-27, -0x1.e843c8p-53),
    FPR(0x1.c20de4p-1, -0x1.5a3942p-31, 0x1.2cd752p-57),
    FPR(0x1.233bbap-2, 0x1.78776ep-27, 0x1.666c14p-54),
    FPR(0x1.eadb2ep-1, 0x1.1cf512p-26, -0x1.325d8ap-52),
    FPR(-0x1.eadb2ep-1, -0x1.1cf512p-26, 0x1.325d8ap-52),
    FPR(0x1.233bbap-2, 0x1.78776ep-27, 0x1.666c14p-54),
    FPR(0x1.e90844p-1, -0x1.3c4102p-26, 0x1.39bf9p-52),
    FPR(0x1.2f422ep-2, -0x1.44ff1ep-28, -0x1.5d406ep-54),
    FPR(-0x1.2f422ep-2, 0x1.44ff1ep-28, 0x1.5d406ep-54),
    FPR(0x1.e90844p-1, -0x1.3c4102p-26, 0x1.39bf9p-52),
    FPR(0x1.dd28f2p-2, -0x1.6fc676p-27, 0x1.fc3152p-52),
    FPR(0x1.c5042p-1, 0x1.2b6906p-29, 0x1.d47f4ep-54),
    FPR(-0x1.c5042p-1, -0x1.2b6906p-29, -0x1.d47f4ep-54),
    FPR(0x1.dd28f2p-2, -0x1.6fc676p-27, 0x1.fc3152p-52),
    FPR(0x1.89c7eap-1, -0x1.6c8ad6p-27, 0x1.3b6dd4p-52),
    FPR(0x1.473b52p-1, -0x1.19e32ep-27, -0x1.c6bcd6p-54),
    FPR(-0x1.473b52p-1, 0x1.19e32ep-27, 0x1.c6bcd6p-54),
    FPR(0x1.89c7eap-1, -0x1.6c8ad6p-27, 0x1.3b6dd4p-52),
    FPR(0x1.787586p-4, 0x1.4bab64p-29, 0x1.57dd62p-56),
    FPR(0x1.fdd53ap-1, -0x1.c17546p-34, -0x1.589e5ep-59),
    FPR(-0x1.fdd53ap-1, 0x1.c17546p-34, 0x1.589e5ep-59),
    FPR(0x1.787586p-4, 0x1.4bab64p-29, 0x1.57dd62p-56),
    FPR(0x1.ff383p-1, 0x1.f1aaecp-26, -0x1.0caf1p-51),
    FPR(0x1.c428d2p-5, -0x1.a7e504p-30, 0x1.676438p-56),
    FPR(-0x1.c428d2p-5, 0x1.a7e504p-30, -0x1.676438p-56),
    FPR(0x1.ff383p-1, 0x1.f1aaecp-26, -0x1.0caf1p-51),
    FPR(0x1.558104p-1, -0x1.da2bb2p-27, -0x1.5d4794p-54),
    FPR(0x1.7d7836p-1, 0x1.9867b6p-26, 0x1.116272p-52),
    FPR(-0x1.7d7836p-1, -0x1.9867b6p-26, -0x1.116272p-52),
    FPR(0x1.558104p-1, -0x1.da2bb2p-27, -0x1.5d4794p-54),
    FPR(0x1.cd7d98p-1, 0x1.31665ep-26, 0x1.783418p-51),
    FPR(0x1.bb7cf2p-2, 0x1.825e8p-29, 0x1.33c34cp-54),
    FPR(-0x1.bb7cf2p-2, -0x1.825e8p-29, -0x1.33c34cp-54),
    FPR(0x1.cd7d98p-1, 0x1.31665ep-26, 0x1.783418p-51),
    FPR(0x1.530d88p-2, 0x1.5e7848p-31, -0x1.fab8e2p-56),
    FPR(0x1.e31eaep-1, 0x1.0e19c4p-26, 0x1.321c7cp-51),
    FPR(-0x1.e31eaep-1, -0x1.0e19c4p-26, -0x1.321c7cp-51),
    FPR(0x1.530d88p-2, 0x1.5e7848p-31, -0x1.fab8e2p-56),
    FPR(0x1.efe22p-1, 0x1.8172bep-26, -0x1.c6f58ap-52),
    FPR(0x1.fdcdc2p-3, -0x1.480482p-29, 0x1.6922dep-56),
    FPR(-0x1.fdcdc2p-3, 0x1.480482p-29, -0x1.6922dep-56),
    FPR(0x1.efe22p-1, 0x1.8172bep-26, -0x1.c6f58ap-52),
    FPR(0x1.048562p-1, 0x1.ab8886p-27, 0x1.3726fcp-52),
    FPR(0x1.b8c38ep-1, -0x1.b15f62p-26, -0x1.d1529ap-51),
    FPR(-0x1.b8c38ep-1, 0x1.b15f62p-26, 0x1.d1529ap-51),
    FPR(0x1.048562p-1, 0x1.ab8886p-27, 0x1.3726fcp-52),
    FPR(0x1.995cf2p-1, 0x1.db01a4p-26, 0x1.17783ep-52),
    FPR(0x1.3384p-1, 0x1.a191cap-26, 0x1.a540d6p-51),
    FPR(-0x1.3384p-1, -0x1.a191cap-26, -0x1.a540d6p-51),
    FPR(0x1.995cf2p-1, 0x1.db01a4p-26, 0x1.17783ep-52),
    FPR(0x1.20116ep-3, -0x1.627086p-28, -0x1.490b24p-55),
    FPR(0x1.fae8e8p-1, 0x1.c8d9f8p-26, -0x1.49d4f2p-51),
    FPR(-0x1.fae8e8p-1, -0x1.c8d9f8p-26, 0x1.49d4f2p-51),
    FPR(0x1.20116ep-3, -0x1.627086p-28, -0x1.490b24p-55),
    FPR(0x1.f9fce6p-1, -0x1.4a49a6p-26, -0x1.f06afcp-51),
    FPR(0x1.38edbcp-3, -0x1.e64e5ep-28, 0x1.dcce7cp-54),
    FPR(-0x1.38edbcp-3, 0x1.e64e5ep-28, -0x1.dcce7cp-54),
    FPR(0x1.f9fce6p-1, -0x1.4a49a6p-26, -0x1.f06afcp-51),
    FPR(0x1.2e780ep-1, 0x1.f4750cp-28, -0x1.6c67ecp-53),
    FPR(0x1.9d1b2p-1, -0x1.42afe6p-26, 0x1.5c5faep-51),
    FPR(-0x1.9d1b2p-1, 0x1.42afe6p-26, -0x1.5c5faep-51),
    FPR(0x1.2e780ep-1, 0x1.f4750cp-28, -0x1.6c67ecp-53),
    FPR(0x1.b588ap-1, -0x1.6debfcp-29, 0x1.c416cap-54),
    FPR(0x1.09e908p-1, -0x1.7d0744p-26, 0x1.00d464p-54),
    FPR(-0x1.09e908p-1, 0x1.7d0744p-26, -0x1.00d464p-54),
    FPR(0x1.b588ap-1, -0x1.6debfcp-29, 0x1.c416cap-54),
    FPR(0x1.e56ca2p-3, -0x1.efe5e4p-31, -0x1.5ca9ep-56),
    FPR(0x1.f168f6p-1, -0x1.811bf4p-26, -0x1.893536p-52),
    FPR(-0x1.f168f6p-1, 0x1.811bf4p-26, 0x1.893536p-52),
    FPR(0x1.e56ca2p-3, -0x1.efe5e4p-31, -0x1.5ca9ep-56),
    FPR(0x1.e100ccp-1, 0x1.453016p-26, -0x1.040b46p-51),
    FPR(0x1.5ee274p-2, -0x1.0c2b2ep-27, 0x1.ac69fep-53),
    FPR(-0x1.5ee274p-2, 0x1.0c2b2ep-27, -0x1.ac69fep-53),
    FPR(0x1.e100ccp-1, 0x1.453016p-26, -0x1.040b46p-51),
    FPR(0x1.b020d6p-2, 0x1.8fe802p-27, -0x1.bafad4p-52),
    FPR(0x1.d02d5p-1, -0x1.4d426ep-29, 0x1.195ff4p-55),
    FPR(-0x1.d02d5p-1, 0x1.4d426ep-29, -0x1.195ff4p-55),
    FPR(0x1.b020d6p-2, 0x1.8fe802p-27, -0x1.bafad4p-52),
    FPR(0x1.794006p-1, -0x1.161544p-26, 0x1.2f5252p-51),
    FPR(0x1.5a28d2p-1, 0x1.4bae4ap-26, 0x1.57a26p-55),
    FPR(-0x1.5a28d2p-1, -0x1.4bae4ap-26, -0x1.57a26p-55),
    FPR(0x1.794006p-1, -0x1.161544p-26, 0x1.2f5252p-51),
    FPR(0x1.5fc00ep-5, -0x1.ade658p-30, 0x1.b44cd4p-56),
    FPR(0x1.ff871ep-1, -0x1.491f88p-27, -0x1.9d38e6p-54),
    FPR(-0x1.ff871ep-1, 0x1.491f88p-27, 0x1.9d38e6p-54),
    FPR(0x1.5fc00ep-5, -0x1.ade658p-30, 0x1.b44cd4p-56),
    FPR(0x1.ffc252p-1, -0x1.071604p-28, 0x1.7a7d2p-56),
    FPR(0x1.f69374p-6, -0x1.c5c62p-31, 0x1.fd802cp-59),
    FPR(-0x1.f69374p-6, 0x1.c5c62p-31, -0x1.fd802cp-59),
    FPR(0x1.ffc252p-1, -0x1.071604p-28, 0x1.7a7d2p-56),
    FPR(0x1.5ec34ap-1, -0x1.4f91f2p-26, 0x1.0ef544p-51),
    FPR(0x1.74f948p-1, 0x1.b51a52p-26, -0x1.7fdccep-52),
    FPR(-0x1.74f948p-1, -0x1.b51a52p-26, 0x1.7fdccep-52),
    FPR(0x1.5ec34ap-1, -0x1.4f91f2p-26, 0x1.0ef544p-51),
    FPR(0x1.d2cb22p-1, 0x1.c1df3ep-30, -0x1.f07656p-56),
    FPR(0x1.a4b412p-2, 0x1.f7a87ap-28, -0x1.b7d8dep-53),
    FPR(-0x1.a4b412p-2, -0x1.f7a87ap-28, 0x1.b7d8dep-53),
    FPR(0x1.d2cb22p-1, 0x1.c1df3ep-30, -0x1.f07656p-56),
    FPR(0x1.6aa9d8p-2, -0x1.1c40f4p-29, -0x1.4e2d1cp-54),
    FPR(0x1.ded06p-1, -0x1.043704p-26, -0x1.92cc4cp-51),
    FPR(-0x1.ded06p-1, 0x1.043704p-26, 0x1.92cc4cp-51),
    FPR(0x1.6aa9d8p-2, -0x1.1c40f4p-29, -0x1.4e2d1cp-54),
    FPR(0x1.f2dc9cp-1, 0x1.211354p-26, -0x1.7d57f2p-52),
    FPR(0x1.ccf8ccp-3, -0x1.9da9bp-28, 0x1.891c16p-53),
    FPR(-0x1.ccf8ccp-3, 0x1.9da9bp-28, -0x1.891c16p-53),
    FPR(0x1.f2dc9cp-1, 0x1.211354p-26, -0x1.7d57f2p-52),
    FPR(0x1.0f426cp-1, -0x1.355c6p-27, -0x1.376b2p-52),
    FPR(0x1.b23cd4p-1, 0x1.c004eep-27, -0x1.ea5e44p-52),
    FPR(-0x1.b23cd4p-1, -0x1.c004eep-27, 0x1.ea5e44p-52),
    FPR(0x1.0f426cp-1, -0x1.355c6p-27, -0x1.376b2p-52),
    FPR(0x1.a0c95ep-1, 0x1.575f26p-26, 0x1.a1f35cp-51),
    FPR(0x1.296072p-1, 0x1.d8a72ap-27, 0x1.56d6c8p-56),
    FPR(-0x1.296072p-1, -0x1.d8a72ap-27, -0x1.56d6c8p-56),
    FPR(0x1.a0c95ep-1, 0x1.575f26p-26, 0x1.a1f35cp-51),
    FPR(0x1.51bdf8p-3, 0x1.65f17cp-29, 0x1.f9819ap-55),
    FPR(0x1.f8fd6p-1, -0x1.46f894p-31, -0x1.8cfd78p-56),
    FPR(-0x1.f8fd6p-1, 0x1.46f894p-31, 0x1.8cfd78p-56),
    FPR(0x1.51bdf8p-3, 0x1.65f17cp-29, 0x1.f9819ap-55),
    FPR(0x1.fbc162p-1, -0x1.0377dp-26, 0x1.7ea714p-51),
    FPR(0x1.072a04p-3, 0x1.eea0c8p-29, -0x1.6e624ep-54),
    FPR(-0x1.072a04p-3, -0x1.eea0c8p-29, 0x1.6e624ep-54),
    FPR(0x1.fbc162p-1, -0x1.0377dp-26, 0x1.7ea714p-51),
    FPR(0x1.388418p-1, 0x1.77fac8p-27, 0x1.cbf9p-53),
    FPR(0x1.958efep-1, 0x1.239b76p-27, -0x1.5584cep-53),
    FPR(-0x1.958efep-1, -0x1.239b76p-27, 0x1.5584cep-53),
    FPR(0x1.388418p-1, 0x1.77fac8p-27, 0x1.cbf9p-53),
    FPR(0x1.bbed7cp-1, 0x1.24e03ap-27, 0x1.037d5ap-52),
    FPR(0x1.fe2f64p-2, 0x1.7ce242p-27, -0x1.297ab2p-56),
    FPR(-0x1.fe2f64p-2, -0x1.7ce242p-27, 0x1.297ab2p-56),
    FPR(0x1.bbed7cp-1, 0x1.24e03ap-27, 0x1.037d5ap-52),
    FPR(0x1.0b0d9cp-2, 0x1.fb7b72p-27, 0x1.3b3a7cp-58),
    FPR(0x1.ee482ep-1, 0x1.2d4edep-28, -0x1.b6066ep-56),
    FPR(-0x1.ee482ep-1, -0x1.2d4edep-28, 0x1.b6066ep-56),
    FPR(0x1.0b0d9cp-2, 0x1.fb7b72p-27, 0x1.3b3a7cp-58),
    FPR(0x1.e529fp-1, 0x1.1ca8p-27, -0x1.cdf146p-52),
    FPR(0x1.472b8ap-2, 0x1.55c414p-28, 0x1.dfc2bep-53),
    FPR(-0x1.472b8ap-2, -0x1.55c414p-28, -0x1.dfc2bep-53),
    FPR(0x1.e529fp-1, 0x1.1ca8p-27, -0x1.cdf146p-52),
    FPR(0x1.c6c7f4p-2, 0x1.32e002p-27, -0x1.5bec26p-52),
    FPR(0x1.cabc16p-1, 0x1.34172p-26, 0x1.c42d3ep-55),
    FPR(-0x1.cabc16p-1, -0x1.34172p-26, -0x1.c42d3ep-55),
    FPR(0x1.c6c7f4p-2, 0x1.32e002p-27, -0x1.5bec26p-52),
    FPR(0x1.81a1b4p-1, -0x1.8950a6p-26, -0x1.15dea2p-51),
    FPR(0x1.50cc0ap-1, -0x1.4cbecap-30, 0x1.693464p-56),
    FPR(-0x1.50cc0ap-1, 0x1.4cbecap-30, -0x1.693464p-56),
    FPR(0x1.81a1b4p-1, -0x1.8950a6p-26, -0x1.15dea2p-51),
    FPR(0x1.144014p-4, -0x1.651ecap-29, 0x1.402778p-55),
    FPR(0x1.fed58ep-1, 0x1.96ce78p-26, 0x1.e191bap-52),
    FPR(-0x1.fed58ep-1, -0x1.96ce78p-26, -0x1.e191bap-52),
    FPR(0x1.144014p-4, -0x1.651ecap-29, 0x1.402778p-55),
    FPR(0x1.fe5f3ap-1, 0x1.e5c728p-26, 0x1.b213f2p-55),
    FPR(0x1.466118p-4, -0x1.b637dap-30, -0x1.296214p-55),
    FPR(-0x1.466118p-4, 0x1.b637dap-30, 0x1.296214p-55),
    FPR(0x1.fe5f3ap-1, 0x1.e5c728p-26, 0x1.b213f2p-55),
    FPR(0x1.4c0a14p-1, 0x1.7b0002p-27, -0x1.fb673cp-52),
    FPR(0x1.85bc52p-1, -0x1.45a9ccp-27, -0x1.d748b4p-52),
    FPR(-0x1.85bc52p-1, 0x1.45a9ccp-27, 0x1.d748b4p-52),
    FPR(0x1.4c0a14p-1, 0x1.7b0002p-27, -0x1.fb673cp-52),
    FPR(0x1.c7e8e6p-1, -0x1.bb9862p-26, 0x1.8d956ap-52),
    FPR(0x1.d2016ep-2, 0x1.1d3b6cp-27, -0x1.4e45e8p-52),
    FPR(-0x1.d2016ep-2, -0x1.1d3b6cp-27, 0x1.4e45e8p-52),
    FPR(0x1.c7e8e6p-1, -0x1.bb9862p-26, 0x1.8d956ap-52),
    FPR(0x1.3b3cfp-2, -0x1.7efad2p-28, -0x1.06491ep-55),
    FPR(0x1.e7227ep-1, -0x1.255a2ep-27, -0x1.dbdafp-52),
    FPR(-0x1.e7227ep-1, 0x1.255a2ep-27, 0x1.dbdafp-52),
    FPR(0x1.3b3cfp-2, -0x1.7efad2p-28, -0x1.06491ep-55),
    FPR(0x1.ec9b2ep-1, -0x1.87881p-26, 0x1.08c88cp-51),
    FPR(0x1.172a0ep-2, -0x1.1135d2p-27, 0x1.c912bap-52),
    FPR(-0x1.172a0ep-2, 0x1.1135d2p-27, -0x1.c912bap-52),
    FPR(0x1.ec9b2ep-1, -0x1.87881p-26, 0x1.08c88cp-51),
    FPR(0x1.f3405ap-2, -0x1.3805f4p-27, 0x1.d06846p-52),
    FPR(0x1.bf064ep-1, 0x1.5377dep-29, -0x1.dbd54p-54),
    FPR(-0x1.bf064ep-1, -0x1.5377dep-29, 0x1.dbd54p-54),
    FPR(0x1.f3405ap-2, -0x1.3805f4p-27, 0x1.d06846p-52),
    FPR(0x1.91b166p-1, 0x1.fa93b4p-26, 0x1.ec416ap-53),
    FPR(0x1.3d7824p-1, -0x1.ce9f3p-27, 0x1.dfbcc2p-52),
    FPR(-0x1.3d7824p-1, 0x1.ce9f3p-27, -0x1.dfbcc2p-52),
    FPR(0x1.91b166p-1, 0x1.fa93b4p-26, 0x1.ec416ap-53),
    FPR(0x1.dc70ecp-4, 0x1.75d3fap-29, -0x1.bb4098p-54),
    FPR(0x1.fc8646p-1, 0x1.9fd6e4p-26, 0x1.4c50f8p-53),
    FPR(-0x1.fc8646p-1, -0x1.9fd6e4p-26, -0x1.4c50f8p-53),
    FPR(0x1.dc70ecp-4, 0x1.75d3fap-29, -0x1.bb4098p-54),
    FPR(0x1.f7ea62p-1, 0x1.3cc7aep-26, -0x1.915b4ap-53),
    FPR(0x1.6a813p-3, 0x1.3d92acp-29, 0x1.1f0cd8p-54),
    FPR(-0x1.6a813p-3, -0x1.3d92acp-29, -0x1.1f0cd8p-54),
    FPR(0x1.f7ea62p-1, 0x1.3cc7aep-26, -0x1.915b4ap-53),
    FPR(0x1.243d6p-1, -0x1.19d4f8p-27, -0x1.8eb30cp-54),
    FPR(0x1.a4678cp-1, 0x1.02335ap-26, -0x1.ee4b4p-51),
    FPR(-0x1.a4678cp-1, -0x1.02335ap-26, 0x1.ee4b4p-51),
    FPR(0x1.243d6p-1, -0x1.19d4f8p-27, -0x1.8eb30cp-54),
    FPR(0x1.aee04cp-1, -0x1.787d72p-26, 0x1.d8b0ccp-52),
    FPR(0x1.14915ap-1, 0x1.e66d9ep-26, -0x1.3064dp-51),
    FPR(-0x1.14915ap-1, -0x1.e66d9ep-26, 0x1.3064dp-51),
    FPR(0x1.aee04cp-1, -0x1.787d72p-26, 0x1.d8b0ccp-52),
    FPR(0x1.b4732ep-3, 0x1.e7ace4p-28, 0x1.377cbap-54),
    FPR(0x1.f43d08p-1, 0x1.7fe4b8p-27, -0x1.b1fbcep-52),
    FPR(-0x1.f43d08p-1, -0x1.7fe4b8p-27, 0x1.b1fbcep-52),
    FPR(0x1.b4732ep-3, 0x1.e7ace4p-28, 0x1.377cbap-54),
    FPR(0x1.dc8d7cp-1, 0x1.68204cp-26, 0x1.6b7872p-56),
    FPR(0x1.76634p-2, 0x1.e4831ep-27, 0x1.92b2aep-52),
    FPR(-0x1.76634p-2, -0x1.e4831ep-27, -0x1.92b2aep-52),
    FPR(0x1.dc8d7cp-1, 0x1.68204cp-26, 0x1.6b7872p-56),
    FPR(0x1.993716p-2, 0x1.41bdfep-30, 0x1.750b9ap-55),
    FPR(0x1.d556f6p-1, -0x1.a2d82ap-26, 0x1.3f8936p-54),
    FPR(-0x1.d556f6p-1, 0x1.a2d82ap-26, -0x1.3f8936p-54),
    FPR(0x1.993716p-2, 0x1.41bdfep-30, 0x1.750b9ap-55),
    FPR(0x1.70a42cp-1, -0x1.9d125p-26, -0x1.8ecf2p-51),
    FPR(0x1.63503ap-1, 0x1.8e0df4p-28, 0x1.11249p-53),
    FPR(-0x1.63503ap-1, -0x1.8e0df4p-28, -0x1.11249p-53),
    FPR(0x1.70a42cp-1, -0x1.9d125p-26, -0x1.8ecf2p-51),
    FPR(0x1.2d936cp-6, -0x1.073c4p-32, -0x1.64a06ep-57),
    FPR(0x1.ffe9ccp-1, -0x1.7695ccp-26, 0x1.2b6866p-53),
    FPR(-0x1.ffe9ccp-1, 0x1.7695ccp-26, -0x1.2b6866p-53),
    FPR(0x1.2d936cp-6, -0x1.073c4p-32, -0x1.64a06ep-57),
    FPR(0x1.ffe9ccp-1, -0x1.7695ccp-26, 0x1.2b6866p-53),
    FPR(0x1.2d936cp-6, -0x1.073c4p-32, -0x1.64a06ep-57),
    FPR(-0x1.2d936cp-6, 0x1.073c4p-32, 0x1.64a06ep-57),
    FPR(0x1.ffe9ccp-1, -0x1.7695ccp-26, 0x1.2b6866p-53),
    FPR(0x1.63503ap-1, 0x1.8e0df4p-28, 0x1.11249p-53),
    FPR(0x1.70a42cp-1, -0x1.9d125p-26, -0x1.8ecf2p-51),
    FPR(-0x1.70a42cp-1, 0x1.9d125p-26, 0x1.8ecf2p-51),
    FPR(0x1.63503ap-1, 0x1.8e0df4p-28, 0x1.11249p-53),
    FPR(0x1.d556f6p-1, -0x1.a2d82ap-26, 0x1.3f8936p-54),
    FPR(0x1.993716p-2, 0x1.41bdfep-30, 0x1.750b9ap-55),
    FPR(-0x1.993716p-2, -0x1.41bdfep-30, -0x1.750b9ap-55),
    FPR(0x1.d556f6p-1, -0x1.a2d82ap-26, 0x1.3f8936p-54),
    FPR(0x1.76634p-2, 0x1.e4831ep-27, 0x1.92b2aep-52),
    FPR(0x1.dc8d7cp-1, 0x1.68204cp-26, 0x1.6b7872p-56),
    FPR(-0x1.dc8d7cp-1, -0x1.68204cp-26, -0x1.6b7872p-56),
    FPR(0x1.76634p-2, 0x1.e4831ep-27, 0x1.92b2aep-52),
    FPR(0x1.f43d08p-1, 0x1.7fe4b8p-27, -0x1.b1fbcep-52),
    FPR(0x1.b4732ep-3, 0x1.e7ace4p-28, 0x1.377cbap-54),
    FPR(-0x1.b4732ep-3, -0x1.e7ace4p-28, -0x1.377cbap-54),
    FPR(0x1.f43d08p-1, 0x1.7fe4b8p-27, -0x1.b1fbcep-52),
    FPR(0x1.14915ap-1, 0x1.e66d9ep-26, -0x1.3064dp-51),
    FPR(0x1.aee04cp-1, -0x1.787d72p-26, 0x1.d8b0ccp-52),
    FPR(-0x1.aee04cp-1, 0x1.787d72p-26, -0x1.d8b0ccp-52),
    FPR(0x1.14915ap-1, 0x1.e66d9ep-26, -0x1.3064dp-51),
    FPR(0x1.a4678cp-1, 0x1.02335ap-26, -0x1.ee4b4p-51),
    FPR(0x1.243d6p-1, -0x1.19d4f8p-27, -0x1.8eb30cp-54),
    FPR(-0x1.243d6p-1, 0x1.19d4f8p-27, 0x1.8eb30cp-54),
    FPR(0x1.a4678cp-1, 0x1.02335ap-26, -0x1.ee4b4p-51),
    FPR(0x1.6a813p-3, 0x1.3d92acp-29, 0x1.1f0cd8p-54),
    FPR(0x1.f7ea62p-1, 0x1.3cc7aep-26, -0x1.915b4ap-53),
    FPR(-0x1.f7ea62p-1, -0x1.3cc7aep-26, 0x1.915b4ap-53),
    FPR(0x1.6a813p-3, 0x1.3d92acp-29, 0x1.1f0cd8p-54),
    FPR(0x1.fc8646p-1, 0x1.9fd6e4p-26, 0x1.4c50f8p-53),
    FPR(0x1.dc70ecp-4, 0x1.75d3fap-29, -0x1.bb4098p-54),
    FPR(-0x1.dc70ecp-4, -0x1.75d3fap-29, 0x1.bb4098p-54),
    FPR(0x1.fc8646p-1, 0x1.9fd6e4p-26, 0x1.4c50f8p-53),
    FPR(0x1.3d7824p-1, -0x1.ce9f3p-27, 0x1.dfbcc2p-52),
    FPR(0x1.91b166p-1, 0x1.fa93b4p-26, 0x1.ec416ap-53),
    FPR(-0x1.91b166p-1, -0x1.fa93b4p-26, -0x1.ec416ap-53),
    FPR(0x1.3d7824p-1, -0x1.ce9f3p-27, 0x1.dfbcc2p-52),
    FPR(0x1.bf064ep-1, 0x1.5377dep-29, -0x1.dbd54p-54),
    FPR(0x1.f3405ap-2, -0x1.3805f4p-27, 0x1.d06846p-52),
    FPR(-0x1.f3405ap-2, 0x1.3805f4p-27, -0x1.d06846p-52),
    FPR(0x1.bf064ep-1, 0x1.5377dep-29, -0x1.dbd54p-54),
    FPR(0x1.172a0ep-2, -0x1.1135d2p-27, 0x1.c912bap-52),
    FPR(0x1.ec9b2ep-1, -0x1.87881p-26, 0x1.08c88cp-51),
    FPR(-0x1.ec9b2ep-1, 0x1.87881p-26, -0x1.08c88cp-51),
    FPR(0x1.172a0ep-2, -0x1.1135d2p-27, 0x1.c912bap-52),
    FPR(0x1.e7227ep-1, -0x1.255a2ep-27, -0x1.dbdafp-52),
    FPR(0x1.3b3cfp-2, -0x1.7efad2p-28, -0x1.06491ep-55),
    FPR(-0x1.3b3cfp-2, 0x1.7efad2p-28, 0x1.06491ep-55),
    FPR(0x1.e7227ep-1, -0x1.255a2ep-27, -0x1.dbdafp-52),
    FPR(0x1.d2016ep-2, 0x1.1d3b6cp-27, -0x1.4e45e8p-52),
    FPR(0x1.c7e8e6p-1, -0x1.bb9862p-26, 0x1.8d956ap-52),
    FPR(-0x1.c7e8e6p-1, 0x1.bb9862p-26, -0x1.8d956ap-52),
    FPR(0x1.d2016ep-2, 0x1.1d3b6cp-27, -0x1.4e45e8p-52),
    FPR(0x1.85bc52p-1, -0x1.45a9ccp-27, -0x1.d748b4p-52),
    FPR(0x1.4c0a14p-1, 0x1.7b0002p-27, -0x1.fb673cp-52),
    FPR(-0x1.4c0a14p-1, -0x1.7b0002p-27, 0x1.fb673cp-52),
    FPR(0x1.85bc52p-1, -0x1.45a9ccp-27, -0x1.d748b4p-52),
    FPR(0x1.466118p-4, -0x1.b637dap-30, -0x1.296214p-55),
    FPR(0x1.fe5f3ap-1, 0x1.e5c728p-26, 0x1.b213f2p-55),
    FPR(-0x1.fe5f3ap-1, -0x1.e5c728p-26, -0x1.b213f2p-55),
    FPR(0x1.466118p-4, -0x1.b637dap-30, -0x1.296214p-55),
    FPR(0x1.fed58ep-1, 0x1.96ce78p-26, 0x1.e191bap-52),
    FPR(0x1.144014p-4, -0x1.651ecap-29, 0x1.402778p-55),
    FPR(-0x1.144014p-4, 0x1.651ecap-29, -0x1.402778p-55),
    FPR(0x1.fed58ep-1, 0x1.96ce78p-26, 0x1.e191bap-52),
    FPR(0x1.50cc0ap-1, -0x1.4cbecap-30, 0x1.693464p-56),
    FPR(0x1.81a1b4p-1, -0x1.8950a6p-26, -0x1.15dea2p-51),
    FPR(-0x1.81a1b4p-1, 0x1.8950a6p-26, 0x1.15dea2p-51),
    FPR(0x1.50cc0ap-1, -0x1.4cbecap-30, 0x1.693464p-56),
    FPR(0x1.cabc16p-1, 0x1.34172p-26, 0x1.c42d3ep-55),
    FPR(0x1.c6c7f4p-2, 0x1.32e002p-27, -0x1.5bec26p-52),
    FPR(-0x1.c6c7f4p-2, -0x1.32e002p-27, 0x1.5bec26p-52),
    FPR(0x1.cabc16p-1, 0x1.34172p-26, 0x1.c42d3ep-55),
    FPR(0x1.472b8ap-2, 0x1.55c414p-28, 0x1.dfc2bep-53),
    FPR(0x1.e529fp-1, 0x1.1ca8p-27, -0x1.cdf146p-52),
    FPR(-0x1.e529fp-1, -0x1.1ca8p-27, 0x1.cdf146p-52),
    FPR(0x1.472b8ap-2, 0x1.55c414p-28, 0x1.dfc2bep-53),
    FPR(0x1.ee482ep-1, 0x1.2d4edep-28, -0x1.b6066ep-56),
    FPR(0x1.0b0d9cp-2, 0x1.fb7b72p-27, 0x1.3b3a7cp-58),
    FPR(-0x1.0b0d9cp-2, -0x1.fb7b72p-27, -0x1.3b3a7cp-58),
    FPR(0x1.ee482ep-1, 0x1.2d4edep-28, -0x1.b6066ep-56),
    FPR(0x1.fe2f64p-2, 0x1.7ce242p-27, -0x1.297ab2p-56),
    FPR(0x1.bbed7cp-1, 0x1.24e03ap-27, 0x1.037d5ap-52),
    FPR(-0x1.bbed7cp-1, -0x1.24e03ap-27, -0x1.037d5ap-52),
    FPR(0x1.fe2f64p-2, 0x1.7ce242p-27, -0x1.297ab2p-56),
    FPR(0x1.958efep-1, 0x1.239b76p-27, -0x1.5584cep-53),
    FPR(0x1.388418p-1, 0x1.77fac8p-27, 0x1.cbf9p-53),
    FPR(-0x1.388418p-1, -0x1.77fac8p-27, -0x1.cbf9p-53),
    FPR(0x1.958efep-1, 0x1.239b76p-27, -0x1.5584cep-53),
    FPR(0x1.072a04p-3, 0x1.eea0c8p-29, -0x1.6e624ep-54),
    FPR(0x1.fbc162p-1, -0x1.0377dp-26, 0x1.7ea714p-51),
    FPR(-0x1.fbc162p-1, 0x1.0377dp-26, -0x1.7ea714p-51),
    FPR(0x1.072a04p-3, 0x1.eea0c8p-29, -0x1.6e624ep-54),
    FPR(0x1.f8fd6p-1, -0x1.46f894p-31, -0x1.8cfd78p-56),
    FPR(0x1.51bdf8p-3, 0x1.65f17cp-29, 0x1.f9819ap-55),
    FPR(-0x1.51bdf8p-3, -0x1.65f17cp-29, -0x1.f9819ap-55),
    FPR(0x1.f8fd6p-1, -0x1.46f894p-31, -0x1.8cfd78p-56),
    FPR(0x1.296072p-1, 0x1.d8a72ap-27, 0x1.56d6c8p-56),
    FPR(0x1.a0c95ep-1, 0x1.575f26p-26, 0x1.a1f35cp-51),
    FPR(-0x1.a0c95ep-1, -0x1.575f26p-26, -0x1.a1f35cp-51),
    FPR(0x1.296072p-1, 0x1.d8a72ap-27, 0x1.56d6c8p-56),
    FPR(0x1.b23cd4p-1, 0x1.c004eep-27, -0x1.ea5e44p-52),
    FPR(0x1.0f426cp-1, -0x1.355c6p-27, -0x1.376b2p-52),
    FPR(-0x1.0f426cp-1, 0x1.355c6p-27, 0x1.376b2p-52),
    FPR(0x1.b23cd4p-1, 0x1.c004eep-27, -0x1.ea5e44p-52),
    FPR(0x1.ccf8ccp-3, -0x1.9da9bp-28, 0x1.891c16p-53),
    FPR(0x1.f2dc9cp-1, 0x1.211354p-26, -0x1.7d57f2p-52),
    FPR(-0x1.f2dc9cp-1, -0x1.211354p-26, 0x1.7d57f2p-52),
    FPR(0x1.ccf8ccp-3, -0x1.9da9bp-28, 0x1.891c16p-53),
    FPR(0x1.ded06p-1, -0x1.043704p-26, -0x1.92cc4cp-51),
    FPR(0x1.6aa9d8p-2, -0x1.1c40f4p-29, -0x1.4e2d1cp-54),
    FPR(-0x1.6aa9d8p-2, 0x1.1c40f4p-29, 0x1.4e2d1cp-54),
    FPR(0x1.ded06p-1, -0x1.043704p-26, -0x1.92cc4cp-51),
    FPR(0x1.a4b412p-2, 0x1.f7a87ap-28, -0x1.b7d8dep-53),
    FPR(0x1.d2cb22p-1, 0x1.c1df3ep-30, -0x1.f07656p-56),
    FPR(-0x1.d2cb22p-1, -0x1.c1df3ep-30, 0x1.f07656p-56),
    FPR(0x1.a4b412p-2, 0x1.f7a87ap-28, -0x1.b7d8dep-53),
    FPR(0x1.74f948p-1, 0x1.b51a52p-26, -0x1.7fdccep-52),
    FPR(0x1.5ec34ap-1, -0x1.4f91f2p-26, 0x1.0ef544p-51),
    FPR(-0x1.5ec34ap-1, 0x1.4f91f2p-26, -0x1.0ef544p-51),
    FPR(0x1.74f948p-1, 0x1.b51a52p-26, -0x1.7fdccep-52),
    FPR(0x1.f69374p-6, -0x1.c5c62p-31, 0x1.fd802cp-59),
    FPR(0x1.ffc252p-1, -0x1.071604p-28, 0x1.7a7d2p-56),
    FPR(-0x1.ffc252p-1, 0x1.071604p-28, -0x1.7a7d2p-56),
    FPR(0x1.f69374p-6, -0x1.c5c62p-31, 0x1.fd802cp-59),
    FPR(0x1.ff871ep-1, -0x1.491f88p-27, -0x1.9d38e6p-54),
    FPR(0x1.5fc00ep-5, -0x1.ade658p-30, 0x1.b44cd4p-56),
    FPR(-0x1.5fc00ep-5, 0x1.ade658p-30, -0x1.b44cd4p-56),
    FPR(0x1.ff871ep-1, -0x1.491f88p-27, -0x1.9d38e6p-54),
    FPR(0x1.5a28d2p-1, 0x1.4bae4ap-26, 0x1.57a26p-55),
    FPR(0x1.794006p-1, -0x1.161544p-26, 0x1.2f5252p-51),
    FPR(-0x1.794006p-1, 0x1.161544p-26, -0x1.2f5252p-51),
    FPR(0x1.5a28d2p-1, 0x1.4bae4ap-26, 0x1.57a26p-55),
    FPR(0x1.d02d5p-1, -0x1.4d426ep-29, 0x1.195ff4p-55),
    FPR(0x1.b020d6p-2, 0x1.8fe802p-27, -0x1.bafad4p-52),
    FPR(-0x1.b020d6p-2, -0x1.8fe802p-27, 0x1.bafad4p-52),
    FPR(0x1.d02d5p-1, -0x1.4d426ep-29, 0x1.195ff4p-55),
    FPR(0x1.5ee274p-2, -0x1.0c2b2ep-27, 0x1.ac69fep-53),
    FPR(0x1.e100ccp-1, 0x1.453016p-26, -0x1.040b46p-51),
    FPR(-0x1.e100ccp-1, -0x1.453016p-26, 0x1.040b46p-51),
    FPR(0x1.5ee274p-2, -0x1.0c2b2ep-27, 0x1.ac69fep-53),
    FPR(0x1.f168f6p-1, -0x1.811bf4p-26, -0x1.893536p-52),
    FPR(0x1.e56ca2p-3, -0x1.efe5e4p-31, -0x1.5ca9ep-56),
    FPR(-0x1.e56ca2p-3, 0x1.efe5e4p-31, 0x1.5ca9ep-56),
    FPR(0x1.f168f6p-1, -0x1.811bf4p-26, -0x1.893536p-52),
    FPR(0x1.09e908p-1, -0x1.7d0744p-26, 0x1.00d464p-54),
    FPR(0x1.b588ap-1, -0x1.6debfcp-29, 0x1.c416cap-54),
    FPR(-0x1.b588ap-1, 0x1.6debfcp-29, -0x1.c416cap-54),
    FPR(0x1.09e908p-1, -0x1.7d0744p-26, 0x1.00d464p-54),
    FPR(0x1.9d1b2p-1, -0x1.42afe6p-26, 0x1.5c5faep-51),
    FPR(0x1.2e780ep-1, 0x1.f4750cp-28, -0x1.6c67ecp-53),
    FPR(-0x1.2e780ep-1, -0x1.f4750cp-28, 0x1.6c67ecp-53),
    FPR(0x1.9d1b2p-1, -0x1.42afe6p-26, 0x1.5c5faep-51),
    FPR(0x1.38edbcp-3, -0x1.e64e5ep-28, 0x1.dcce7cp-54),
    FPR(0x1.f9fce6p-1, -0x1.4a49a6p-26, -0x1.f06afcp-51),
    FPR(-0x1.f9fce6p-1, 0x1.4a49a6p-26, 0x1.f06afcp-51),
    FPR(0x1.38edbcp-3, -0x1.e64e5ep-28, 0x1.dcce7cp-54),
    FPR(0x1.fae8e8p-1, 0x1.c8d9f8p-26, -0x1.49d4f2p-51),
    FPR(0x1.20116ep-3, -0x1.627086p-28, -0x1.490b24p-55),
    FPR(-0x1.20116ep-3, 0x1.627086p-28, 0x1.490b24p-55),
    FPR(0x1.fae8e8p-1, 0x1.c8d9f8p-26, -0x1.49d4f2p-51),
    FPR(0x1.3384p-1, 0x1.a191cap-26, 0x1.a540d6p-51),
    FPR(0x1.995cf2p-1, 0x1.db01a4p-26, 0x1.17783ep-52),
    FPR(-0x1.995cf2p-1, -0x1.db01a4p-26, -0x1.17783ep-52),
    FPR(0x1.3384p-1, 0x1.a191cap-26, 0x1.a540d6p-51),
    FPR(0x1.b8c38ep-1, -0x1.b15f62p-26, -0x1.d1529ap-51),
    FPR(0x1.048562p-1, 0x1.ab8886p-27, 0x1.3726fcp-52),
    FPR(-0x1.048562p-1, -0x1.ab8886p-27, -0x1.3726fcp-52),
    FPR(0x1.b8c38ep-1, -0x1.b15f62p-26, -0x1.d1529ap-51),
    FPR(0x1.fdcdc2p-3, -0x1.480482p-29, 0x1.6922dep-56),
    FPR(0x1.efe22p-1, 0x1.8172bep-26, -0x1.c6f58ap-52),
    FPR(-0x1.efe22p-1, -0x1.8172bep-26, 0x1.c6f58ap-52),
    FPR(0x1.fdcdc2p-3, -0x1.480482p-29, 0x1.6922dep-56),
    FPR(0x1.e31eaep-1, 0x1.0e19c4p-26, 0x1.321c7cp-51),
    FPR(0x1.530d88p-2, 0x1.5e7848p-31, -0x1.fab8e2p-56),
    FPR(-0x1.530d88p-2, -0x1.5e7848p-31, 0x1.fab8e2p-56),
    FPR(0x1.e31eaep-1, 0x1.0e19c4p-26, 0x1.321c7cp-51),
    FPR(0x1.bb7cf2p-2, 0x1.825e8p-29, 0x1.33c34cp-54),
    FPR(0x1.cd7d98p-1, 0x1.31665ep-26, 0x1.783418p-51),
    FPR(-0x1.cd7d98p-1, -0x1.31665ep-26, -0x1.783418p-51),
    FPR(0x1.bb7cf2p-2, 0x1.825e8p-29, 0x1.33c34cp-54),
    FPR(0x1.7d7836p-1, 0x1.9867b6p-26, 0x1.116272p-52),
    FPR(0x1.558104p-1, -0x1.da2bb2p-27, -0x1.5d4794p-54),
    FPR(-0x1.558104p-1, 0x1.da2bb2p-27, 0x1.5d4794p-54),
    FPR(0x1.7d7836p-1, 0x1.9867b6p-26, 0x1.116272p-52),
    FPR(0x1.c428d2p-5, -0x1.a7e504p-30, 0x1.676438p-56),
    FPR(0x1.ff383p-1, 0x1.f1aaecp-26, -0x1.0caf1p-51),
    FPR(-0x1.ff383p-1, -0x1.f1aaecp-26, 0x1.0caf1p-51),
    FPR(0x1.c428d2p-5, -0x1.a7e504p-30, 0x1.676438p-56),
    FPR(0x1.fdd53ap-1, -0x1.c17546p-34, -0x1.589e5ep-59),
    FPR(0x1.787586p-4, 0x1.4bab64p-29, 0x1.57dd62p-56),
    FPR(-0x1.787586p-4, -0x1.4bab64p-29, -0x1.57dd62p-56),
    FPR(0x1.fdd53ap-1, -0x1.c17546p-34, -0x1.589e5ep-59),
    FPR(0x1.473b52p-1, -0x1.19e32ep-27, -0x1.c6bcd6p-54),
    FPR(0x1.89c7eap-1, -0x1.6c8ad6p-27, 0x1.3b6dd4p-52),
    FPR(-0x1.89c7eap-1, 0x1.6c8ad6p-27, -0x1.3b6dd4p-52),
    FPR(0x1.473b52p-1, -0x1.19e32ep-27, -0x1.c6bcd6p-54),
    FPR(0x1.c5042p-1, 0x1.2b6906p-29, 0x1.d47f4ep-54),
    FPR(0x1.dd28f2p-2, -0x1.6fc676p-27, 0x1.fc3152p-52),
    FPR(-0x1.dd28f2p-2, 0x1.6fc676p-27, -0x1.fc3152p-52),
    FPR(0x1.c5042p-1, 0x1.2b6906p-29, 0x1.d47f4ep-54),
    FPR(0x1.2f422ep-2, -0x1.44ff1ep-28, -0x1.5d406ep-54),
    FPR(0x1.e90844p-1, -0x1.3c4102p-26, 0x1.39bf9p-52),
    FPR(-0x1.e90844p-1, 0x1.3c4102p-26, -0x1.39bf9p-52),
    FPR(0x1.2f422ep-2, -0x1.44ff1ep-28, -0x1.5d406ep-54),
    FPR(0x1.eadb2ep-1, 0x1.1cf512p-26, -0x1.325d8ap-52),
    FPR(0x1.233bbap-2, 0x1.78776ep-27, 0x1.666c14p-54),
    FPR(-0x1.233bbap-2, -0x1.78776ep-27, -0x1.666c14p-54),
    FPR(0x1.eadb2ep-1, 0x1.1cf512p-26, -0x1.325d8ap-52),
    FPR(0x1.e83e0ep-2, 0x1.5f0a22p-27, 0x1.e843c8p-53),
    FPR(0x1.c20de4p-1, -0x1.5a3942p-31, 0x1.2cd752p-57),
    FPR(-0x1.c20de4p-1, 0x1.5a3942p-31, -0x1.2cd752p-57),
    FPR(0x1.e83e0ep-2, 0x1.5f0a22p-27, 0x1.e843c8p-53),
    FPR(0x1.8dc454p-1, -0x1.9d2ce6p-26, -0x1.f71302p-52),
    FPR(0x1.425ff2p-1, -0x1.0e328ap-26, 0x1.5ece36p-53),
    FPR(-0x1.425ff2p-1, 0x1.0e328ap-26, -0x1.5ece36p-53),
    FPR(0x1.8dc454p-1, -0x1.9d2ce6p-26, -0x1.f71302p-52),
    FPR(0x1.aa7b72p-4, 0x1.1257p-30, 0x1.bca734p-55),
    FPR(0x1.fd3792p-1, -0x1.7bbe9p-26, 0x1.152e9ep-51),
    FPR(-0x1.fd3792p-1, 0x1.7bbe9p-26, -0x1.152e9ep-51),
    FPR(0x1.aa7b72p-4, 0x1.1257p-30, 0x1.bca734p-55),
    FPR(0x1.f6c3f8p-1, -0x1.052224p-28, -0x1.9ea78cp-54),
    FPR(0x1.83366ep-3, 0x1.138c98p-28, 0x1.6e6d6ap-53),
    FPR(-0x1.83366ep-3, -0x1.138c98p-28, -0x1.6e6d6ap-53),
    FPR(0x1.f6c3f8p-1, -0x1.052224p-28, -0x1.9ea78cp-54),
    FPR(0x1.1f0f08p-1, 0x1.7790c4p-26, -0x1.444368p-51),
    FPR(0x1.a7f586p-1, -0x1.ac032cp-26, -0x1.b2f488p-52),
    FPR(-0x1.a7f586p-1, 0x1.ac032cp-26, 0x1.b2f488p-52),
    FPR(0x1.1f0f08p-1, 0x1.7790c4p-26, -0x1.444368p-51),
    FPR(0x1.ab7326p-1, -0x1.ba4fcap-27, -0x1.cae8e6p-52),
    FPR(0x1.19d5ap-1, 0x1.3e5736p-26, 0x1.fb326ap-51),
    FPR(-0x1.19d5ap-1, -0x1.3e5736p-26, -0x1.fb326ap-51),
    FPR(0x1.ab7326p-1, -0x1.ba4fcap-27, -0x1.cae8e6p-52),
    FPR(0x1.9bdccp-3, -0x1.a47794p-28, 0x1.99632ep-53),
    FPR(0x1.f58a2cp-1, -0x1.d0ec3p-26, 0x1.08fa5p-51),
    FPR(-0x1.f58a2cp-1, 0x1.d0ec3p-26, -0x1.08fa5p-51),
    FPR(0x1.9bdccp-3, -0x1.a47794p-28, 0x1.99632ep-53),
    FPR(0x1.da383ap-1, 0x1.2cd13p-26, 0x1.ea7efp-51),
    FPR(0x1.820e3cp-2, -0x1.f62aa8p-27, 0x1.f9b722p-53),
    FPR(-0x1.820e3cp-2, 0x1.f62aa8p-27, -0x1.f9b722p-53),
    FPR(0x1.da383ap-1, 0x1.2cd13p-26, 0x1.ea7efp-51),
    FPR(0x1.8daa52p-2, 0x1.d91496p-27, -0x1.72eb2ep-57),
    FPR(0x1.d7d0bp-1, 0x1.5c767cp-28, 0x1.6003d4p-53),
    FPR(-0x1.d7d0bp-1, -0x1.5c767cp-28, -0x1.6003d4p-53),
    FPR(0x1.8daa52p-2, 0x1.d91496p-27, -0x1.72eb2ep-57),
    FPR(0x1.6c40d8p-1, -0x1.87cfb2p-26, 0x1.449754p-51),
    FPR(0x1.67cf78p-1, 0x1.246bc4p-27, 0x1.750ab2p-59),
    FPR(-0x1.67cf78p-1, -0x1.246bc4p-27, -0x1.750ab2p-59),
    FPR(0x1.6c40d8p-1, -0x1.87cfb2p-26, 0x1.449754p-51),
    FPR(0x1.921f1p-8, -0x1.98ff8ep-36, -0x1.ca8d3p-61),
    FPR(0x1.fffd88p-1, 0x1.63a2a4p-27, 0x1.26b38ep-52),
    FPR(-0x1.fffd88p-1, -0x1.63a2a4p-27, -0x1.26b38ep-52),
    FPR(0x1.921f1p-8, -0x1.98ff8ep-36, -0x1.ca8d3p-61),
    FPR(0x1.ffff62p-1, 0x1.621d02p-29, -0x1.6acfcep-56),
    FPR(0x1.921f8cp-9, -0x1.335b46p-37, 0x1.2ba408p-63),
    FPR(-0x1.921f8cp-9, 0x1.335b46p-37, -0x1.2ba408p-63),
    FPR(0x1.ffff62p-1, 0x1.621d02p-29, -0x1.6acfcep-56),
    FPR(0x1.68ed1ep-1, 0x1.54338ep-26, 0x1.3fa95p-53),
    FPR(0x1.6b25cep-1, 0x1.a5fc54p-26, -0x1.15ac64p-51),
    FPR(-0x1.6b25cep-1, -0x1.a5fc54p-26, 0x1.15ac64p-51),
    FPR(0x1.68ed1ep-1, 0x1.54338ep-26, 0x1.3fa95p-53),
    FPR(0x1.d86c48p-1, 0x1.116914p-27, -0x1.0bbf62p-54),
    FPR(0x1.8ac4b8p-2, 0x1.b57b52p-28, -0x1.dd00bp-53),
    FPR(-0x1.8ac4b8p-2, -0x1.b57b52p-28, 0x1.dd00bp-53),
    FPR(0x1.d86c48p-1, 0x1.116914p-27, -0x1.0bbf62p-54),
    FPR(0x1.84f6aap-2, 0x1.5e7208p-27, -0x1.a48c9p-55),
    FPR(0x1.d9a00ep-1, -0x1.3a615cp-28, -0x1.f20af8p-53),
    FPR(-0x1.d9a00ep-1, 0x1.3a615cp-28, 0x1.f20af8p-53),
    FPR(0x1.84f6aap-2, 0x1.5e7208p-27, -0x1.a48c9p-55),
    FPR(0x1.f5da6ep-1, 0x1.a86d0cp-26, -0x1.aa6df8p-52),
    FPR(0x1.95b49ep-3, 0x1.36c56p-28, -0x1.84402cp-53),
    FPR(-0x1.95b49ep-3, -0x1.36c56p-28, 0x1.84402cp-53),
    FPR(0x1.f5da6ep-1, 0x1.a86d0cp-26, -0x1.aa6df8p-52),
    FPR(0x1.1b2502p-1, -0x1.1d9188p-26, -0x1.6c843ap-53),
    FPR(0x1.aa9548p-1, -0x1.74d19cp-27, -0x1.fcf06p-53),
    FPR(-0x1.aa9548p-1, 0x1.74d19cp-27, 0x1.fcf06p-53),
    FPR(0x1.1b2502p-1, -0x1.1d9188p-26, -0x1.6c843ap-53),
    FPR(0x1.a8d676p-1, 0x1.ca8b5ap-26, 0x1.f93b88p-53),
    FPR(0x1.1dc1b6p-1, 0x1.37121cp-27, 0x1.0f8afp-52),
    FPR(-0x1.1dc1b6p-1, -0x1.37121cp-27, -0x1.0f8afp-52),
    FPR(0x1.a8d676p-1, 0x1.ca8b5ap-26, 0x1.f93b88p-53),
    FPR(0x1.896172p-3, 0x1.f10602p-29, -0x1.ec0254p-54),
    FPR(0x1.f67756p-1, -0x1.2ef862p-26, -0x1.e1096ap-53),
    FPR(-0x1.f67756p-1, 0x1.2ef862p-26, 0x1.e1096ap-53),
    FPR(0x1.896172p-3, 0x1.f10602p-29, -0x1.ec0254p-54),
    FPR(0x1.fd60d2p-1, 0x1.b4eb94p-26, -0x1.f6490ap-53),
    FPR(0x1.9dfb6ep-4, 0x1.64950cp-29, -0x1.e1694cp-55),
    FPR(-0x1.9dfb6ep-4, -0x1.64950cp-29, 0x1.e1694cp-55),
    FPR(0x1.fd60d2p-1, 0x1.b4eb94p-26, -0x1.f6490ap-53),
    FPR(0x1.4397f6p-1, -0x1.356f2p-27, -0x1.7274cap-55),
    FPR(0x1.8cc6a8p-1, -0x1.5cf736p-26, 0x1.21e74cp-51),
    FPR(-0x1.8cc6a8p-1, 0x1.5cf736p-26, -0x1.21e74cp-51),
    FPR(0x1.4397f6p-1, -0x1.356f2p-27, -0x1.7274cap-55),
    FPR(0x1.c2cd14p-1, 0x1.263c7ep-26, 0x1.259c6p-53),
    FPR(0x1.e57a86p-2, 0x1.a79b04p-27, 0x1.369bfap-52),
    FPR(-0x1.e57a86p-2, -0x1.a79b04p-27, -0x1.369bfap-52),
    FPR(0x1.c2cd14p-1, 0x1.263c7ep-26, 0x1.259c6p-53),
    FPR(0x1.263e6ap-2, -0x1.aaaad2p-28, 0x1.23a6a2p-53),
    FPR(0x1.ea683ap-1, -0x1.8335p-26, -0x1.46725ap-56),
    FPR(-0x1.ea683ap-1, 0x1.8335p-26, 0x1.46725ap-56),
    FPR(0x1.263e6ap-2, -0x1.aaaad2p-28, 0x1.23a6a2p-53),
    FPR(0x1.e97ec4p-1, -0x1.3fd29ap-26, 0x1.5bc486p-55),
    FPR(0x1.2c41a4p-2, 0x1.d2a8a4p-27, 0x1.9cf036p-56),
    FPR(-0x1.2c41a4p-2, -0x1.d2a8a4p-27, -0x1.9cf036p-56),
    FPR(0x1.e97ec4p-1, -0x1.3fd29ap-26, 0x1.5bc486p-55),
    FPR(0x1.dfeff6p-2, 0x1.aa5078p-28, -0x1.34ead8p-53),
    FPR(0x1.c44834p-1, -0x1.d7c8p-26, 0x1.091f02p-51),
    FPR(-0x1.c44834p-1, 0x1.d7c8p-26, -0x1.091f02p-51),
    FPR(0x1.dfeff6p-2, 0x1.aa5078p-28, -0x1.34ead8p-53),
    FPR(0x1.8ac872p-1, -0x1.21e278p-29, -0x1.9afaa6p-55),
    FPR(0x1.4605a6p-1, 0x1.256654p-26, 0x1.243944p-52),
    FPR(-0x1.4605a6p-1, -0x1.256654p-26, -0x1.243944p-52),
    FPR(0x1.8ac872p-1, -0x1.21e278p-29, -0x1.9afaa6p-55),
    FPR(0x1.84f872p-4, -0x1.a7d9ecp-29, 0x1.0cec8ap-57),
    FPR(0x1.fdafa8p-1, -0x1.5d758ep-26, -0x1.fc4d08p-52),
    FPR(-0x1.fdafa8p-1, 0x1.5d758ep-26, 0x1.fc4d08p-52),
    FPR(0x1.84f872p-4, -0x1.a7d9ecp-29, 0x1.0cec8ap-57),
    FPR(0x1.ff4dc6p-1, -0x1.69c826p-26, 0x1.47dd2cp-52),
    FPR(0x1.ab101cp-5, -0x1.503e74p-32, -0x1.597186p-57),
    FPR(-0x1.ab101cp-5, 0x1.503e74p-32, 0x1.597186p-57),
    FPR(0x1.ff4dc6p-1, -0x1.69c826p-26, 0x1.47dd2cp-52),
    FPR(0x1.56ac36p-1, -0x1.cd136cp-26, -0x1.7de1dp-53),
    FPR(0x1.7c6b8ap-1, -0x1.8e9666p-28, -0x1.39fac6p-53),
    FPR(-0x1.7c6b8ap-1, 0x1.8e9666p-28, 0x1.39fac6p-53),
    FPR(0x1.56ac36p-1, -0x1.cd136cp-26, -0x1.7de1dp-53),
    FPR(0x1.ce2b32p-1, 0x1.e66818p-27, -0x1.631d46p-56),
    FPR(0x1.b8a782p-2, -0x1.60552ep-27, 0x1.b353ccp-53),
    FPR(-0x1.b8a782p-2, 0x1.60552ep-27, -0x1.b353ccp-53),
    FPR(0x1.ce2b32p-1, 0x1.e66818p-27, -0x1.631d46p-56),
    FPR(0x1.560402p-2, -0x1.a1730ap-27, 0x1.1a0e0cp-52),
    FPR(0x1.e298f4p-1, 0x1.0e465ep-27, 0x1.0f4274p-52),
    FPR(-0x1.e298f4p-1, -0x1.0e465ep-27, -0x1.0f4274p-52),
    FPR(0x1.560402p-2, -0x1.a1730ap-27, 0x1.1a0e0cp-52),
    FPR(0x1.f045a2p-1, -0x1.66118ep-26, -0x1.1a52c4p-51),
    FPR(0x1.f7b748p-3, 0x1.7a7004p-32, -0x1.9a96dap-57),
    FPR(-0x1.f7b748p-3, -0x1.7a7004p-32, 0x1.9a96dap-57),
    FPR(0x1.f045a2p-1, -0x1.66118ep-26, -0x1.1a52c4p-51),
    FPR(0x1.05df3ep-1, 0x1.863716p-26, 0x1.b8748ep-51),
    FPR(0x1.b7f668p-1, 0x1.b9e4bap-27, 0x1.61d996p-53),
    FPR(-0x1.b7f668p-1, -0x1.b9e4bap-27, -0x1.61d996p-53),
    FPR(0x1.05df3ep-1, 0x1.863716p-26, 0x1.b8748ep-51),
    FPR(0x1.9a4dfap-1, 0x1.0ac1acp-27, 0x1.cfac92p-53),
    FPR(0x1.32421ep-1, 0x1.8934c4p-26, -0x1.4d0ed2p-54),
    FPR(-0x1.32421ep-1, -0x1.8934c4p-26, 0x1.4d0ed2p-54),
    FPR(0x1.9a4dfap-1, 0x1.0ac1acp-27, 0x1.cfac92p-53),
    FPR(0x1.264994p-3, 0x1.bfa682p-28, -0x1.a58bb4p-53),
    FPR(0x1.faafbcp-1, 0x1.619fbcp-26, -0x1.1e349cp-51),
    FPR(-0x1.faafbcp-1, -0x1.619fbcp-26, 0x1.1e349cp-51),
    FPR(0x1.264994p-3, 0x1.bfa682p-28, -0x1.a58bb4p-53),
    FPR(0x1.fa39bap-1, 0x1.8f42f2p-26, 0x1.cd618ep-54),
    FPR(0x1.32b7cp-3, -0x1.aeba56p-29, -0x1.6aed8ep-56),
    FPR(-0x1.32b7cp-3, 0x1.aeba56p-29, 0x1.6aed8ep-56),
    FPR(0x1.fa39bap-1, 0x1.8f42f2p-26, 0x1.cd618ep-54),
    FPR(0x1.2fbc24p-1, 0x1.688202p-26, 0x1.476e92p-51),
    FPR(0x1.9c2d12p-1, -0x1.e1f148p-26, 0x1.3b393ep-52),
    FPR(-0x1.9c2d12p-1, 0x1.e1f148p-26, -0x1.3b393ep-52),
    FPR(0x1.2fbc24p-1, 0x1.688202p-26, 0x1.476e92p-51),
    FPR(0x1.b658f2p-1, -0x1.604878p-26, 0x1.c54ad4p-51),
    FPR(0x1.089112p-1, 0x1.95846p-32, 0x1.3248dep-57),
    FPR(-0x1.089112p-1, -0x1.95846p-32, -0x1.3248dep-57),
    FPR(0x1.b658f2p-1, -0x1.604878p-26, 0x1.c54ad4p-51),
    FPR(0x1.eb86b4p-3, 0x1.8b78d2p-29, -0x1.bfcde4p-57),
    FPR(0x1.f1090cp-1, -0x1.bb385p-28, -0x1.6ea992p-53),
    FPR(-0x1.f1090cp-1, 0x1.bb385p-28, 0x1.6ea992p-53),
    FPR(0x1.eb86b4p-3, 0x1.8b78d2p-29, -0x1.bfcde4p-57),
    FPR(0x1.e18a02p-1, 0x1.fb8cdcp-26, -0x1.af81d8p-51),
    FPR(0x1.5bee78p-2, 0x1.73b676p-27, 0x1.879cd2p-52),
    FPR(-0x1.5bee78p-2, -0x1.73b676p-27, -0x1.879cd2p-52),
    FPR(0x1.e18a02p-1, 0x1.fb8cdcp-26, -0x1.af81d8p-51),
    FPR(0x1.b2f972p-2, -0x1.267346p-29, -0x1.815a3ap-54),
    FPR(0x1.cf830ep-1, 0x1.19c8dp-26, -0x1.57b92p-51),
    FPR(-0x1.cf830ep-1, -0x1.19c8dp-26, 0x1.57b92p-51),
    FPR(0x1.b2f972p-2, -0x1.267346p-29, -0x1.815a3ap-54),
    FPR(0x1.7a4f7p-1, 0x1.efe5f4p-27, 0x1.2792eap-52),
    FPR(0x1.59001ep-1, -0x1.411b84p-26, -0x1.9581e6p-54),
    FPR(-0x1.59001ep-1, 0x1.411b84p-26, 0x1.9581e6p-54),
    FPR(0x1.7a4f7p-1, 0x1.efe5f4p-27, 0x1.2792eap-52),
    FPR(0x1.78dbaap-5, 0x1.61d1a2p-31, -0x1.14a0fp-56),
    FPR(0x1.ff753cp-1, -0x1.391ba8p-27, 0x1.e83cdp-52),
    FPR(-0x1.ff753cp-1, 0x1.391ba8p-27, -0x1.e83cdp-52),
    FPR(0x1.78dbaap-5, 0x1.61d1a2p-31, -0x1.14a0fp-56),
    FPR(0x1.ffce0ap-1, -0x1.8eacc4p-28, 0x1.4214eap-54),
    FPR(0x1.c454f4p-6, 0x1.9ca764p-31, -0x1.bac7bp-57),
    FPR(-0x1.c454f4p-6, -0x1.9ca764p-31, 0x1.bac7bp-57),
    FPR(0x1.ffce0ap-1, -0x1.8eacc4p-28, 0x1.4214eap-54),
    FPR(0x1.5fe7ccp-1, -0x1.0d4af8p-28, -0x1.fcb9ccp-55),
    FPR(0x1.73e558p-1, 0x1.c0f328p-26, 0x1.b6673cp-53),
    FPR(-0x1.73e558p-1, -0x1.c0f328p-26, -0x1.b6673cp-53),
    FPR(0x1.5fe7ccp-1, -0x1.0d4af8p-28, -0x1.fcb9ccp-55),
    FPR(0x1.d36fc8p-1, -0x1.0d010ap-27, 0x1.c8bcd2p-52),
    FPR(0x1.a1d654p-2, 0x1.da856p-29, -0x1.0246dp-57),
    FPR(-0x1.a1d654p-2, -0x1.da856p-29, 0x1.0246dp-57),
    FPR(0x1.d36fc8p-1, -0x1.0d010ap-27, 0x1.c8bcd2p-52),
    FPR(0x1.6d9986p-2, 0x1.c5065ap-29, 0x1.fdc6bep-54),
    FPR(0x1.de416p-1, 0x1.edb1bp-26, 0x1.66fc48p-53),
    FPR(-0x1.de416p-1, -0x1.edb1bp-26, -0x1.66fc48p-53),
    FPR(0x1.6d9986p-2, 0x1.c5065ap-29, 0x1.fdc6bep-54),
    FPR(0x1.f33686p-1, -0x1.715444p-27, 0x1.eb7868p-56),
    FPR(0x1.c6d906p-3, -0x1.945164p-28, -0x1.8dfd96p-54),
    FPR(-0x1.c6d906p-3, 0x1.945164p-28, 0x1.8dfd96p-54),
    FPR(0x1.f33686p-1, -0x1.715444p-27, 0x1.eb7868p-56),
    FPR(0x1.109724p-1, 0x1.1a152ap-26, 0x1.a85a78p-51),
    FPR(0x1.b16742p-1, 0x1.49945ep-26, 0x1.2458f6p-51),
    FPR(-0x1.b16742p-1, -0x1.49945ep-26, -0x1.2458f6p-51),
    FPR(0x1.109724p-1, 0x1.1a152ap-26, 0x1.a85a78p-51),
    FPR(0x1.a1b26ep-1, -0x1.a7eb14p-26, -0x1.ecf10cp-53),
    FPR(0x1.2818bep-1, 0x1.e9a798p-26, -0x1.8f2p-51),
    FPR(-0x1.2818bep-1, -0x1.e9a798p-26, 0x1.8f2p-51),
    FPR(0x1.a1b26ep-1, -0x1.a7eb14p-26, -0x1.ecf10cp-53),
    FPR(0x1.57f008p-3, 0x1.9532f8p-29, -0x1.cdee6ep-55),
    FPR(0x1.f8ba74p-1, -0x1.069692p-26, 0x1.e258ep-51),
    FPR(-0x1.f8ba74p-1, 0x1.069692p-26, -0x1.e258ep-51),
    FPR(0x1.57f008p-3, 0x1.9532f8p-29, -0x1.cdee6ep-55),
    FPR(0x1.fbf47p-1, 0x1.e151bp-26, 0x1.e944ep-51),
    FPR(0x1.00ee8ap-3, 0x1.adf70cp-28, -0x1.34c60ap-53),
    FPR(-0x1.00ee8ap-3, -0x1.adf70cp-28, 0x1.34c60ap-53),
    FPR(0x1.fbf47p-1, 0x1.e151bp-26, 0x1.e944ep-51),
    FPR(0x1.39c23ep-1, 0x1.eb1814p-28, 0x1.ec4fa4p-54),
    FPR(0x1.94990ep-1, 0x1.d62536p-28, 0x1.a95328p-56),
    FPR(-0x1.94990ep-1, -0x1.d62536p-28, -0x1.a95328p-56),
    FPR(0x1.39c23ep-1, 0x1.eb1814p-28, 0x1.ec4fa4p-54),
    FPR(0x1.bcb54cp-1, 0x1.61a464p-26, 0x1.c02822p-51),
    FPR(0x1.fb7576p-2, -0x1.ed9692p-29, 0x1.d48046p-54),
    FPR(-0x1.fb7576p-2, 0x1.ed9692p-29, -0x1.d48046p-54),
    FPR(0x1.bcb54cp-1, 0x1.61a464p-26, 0x1.c02822p-51),
    FPR(0x1.0e15b4p-2, 0x1.c2e93ap-27, -0x1.2b6ff6p-53),
    FPR(0x1.eddeb6p-1, 0x1.40f0cap-26, 0x1.625432p-54),
    FPR(-0x1.eddeb6p-1, -0x1.40f0cap-26, -0x1.625432p-54),
    FPR(0x1.0e15b4p-2, 0x1.c2e93ap-27, -0x1.2b6ff6p-53),
    FPR(0x1.e5a9d6p-1, -0x1.5f7306p-26, 0x1.97d432p-52),
    FPR(0x1.44310ep-2, -0x1.bb6488p-29, 0x1.8b694ep-56),
    FPR(-0x1.44310ep-2, 0x1.bb6488p-29, -0x1.8b694ep-56),
    FPR(0x1.e5a9d6p-1, -0x1.5f7306p-26, 0x1.97d432p-52),
    FPR(0x1.c997fcp-2, 0x1.c329c4p-29, 0x1.4eb504p-55),
    FPR(0x1.ca08f2p-1, -0x1.918eeep-27, 0x1.af387ep-54),
    FPR(-0x1.ca08f2p-1, 0x1.918eeep-27, -0x1.af387ep-54),
    FPR(0x1.c997fcp-2, 0x1.c329c4p-29, 0x1.4eb504p-55),
    FPR(0x1.82a9c2p-1, -0x1.81574p-26, -0x1.2cbd1p-53),
    FPR(0x1.4f9cc2p-1, 0x1.732922p-27, -0x1.add29ap-53),
    FPR(-0x1.4f9cc2p-1, -0x1.732922p-27, 0x1.add29ap-53),
    FPR(0x1.82a9c2p-1, -0x1.81574p-26, -0x1.2cbd1p-53),
    FPR(0x1.20c968p-4, -0x1.625776p-29, -0x1.bf3a92p-55),
    FPR(0x1.feb9d2p-1, 0x1.4c1044p-27, -0x1.e62bd6p-54),
    FPR(-0x1.feb9d2p-1, -0x1.4c1044p-27, 0x1.e62bd6p-54),
    FPR(0x1.20c968p-4, -0x1.625776p-29, -0x1.bf3a92p-55),
    FPR(0x1.fe7ea8p-1, 0x1.520b58p-27, 0x1.34b086p-56),
    FPR(0x1.39d9f2p-4, -0x1.a74bacp-29, -0x1.beed78p-54),
    FPR(-0x1.39d9f2p-4, 0x1.a74bacp-29, 0x1.beed78p-54),
    FPR(0x1.fe7ea8p-1, 0x1.520b58p-27, 0x1.34b086p-56),
    FPR(0x1.4d3bc6p-1, 0x1.ab13fp-26, -0x1.48d932p-54),
    FPR(0x1.84b712p-1, -0x1.ca0f8p-26, -0x1.963a48p-51),
    FPR(-0x1.84b712p-1, 0x1.ca0f8p-26, 0x1.963a48p-51),
    FPR(0x1.4d3bc6p-1, 0x1.ab13fp-26, -0x1.48d932p-54),
    FPR(0x1.c89f58p-1, 0x1.c0a704p-27, 0x1.85620ep-52),
    FPR(0x1.cf34bap-2, 0x1.dc39a4p-27, 0x1.773c6ep-55),
    FPR(-0x1.cf34bap-2, -0x1.dc39a4p-27, -0x1.773c6ep-55),
    FPR(0x1.c89f58p-1, 0x1.c0a704p-27, 0x1.85620ep-52),
    FPR(0x1.3e39bep-2, 0x1.2dd84ep-27, 0x1.60531cp-54),
    FPR(0x1.e6a61cp-1, 0x1.5754eap-27, -0x1.a67c9ap-54),
    FPR(-0x1.e6a61cp-1, -0x1.5754eap-27, 0x1.a67c9ap-54),
    FPR(0x1.3e39bep-2, 0x1.2dd84ep-27, 0x1.60531cp-54),
    FPR(0x1.ed0836p-1, -0x1.666ff6p-29, -0x1.d6cc5cp-54),
    FPR(0x1.1423eep-2, 0x1.f8d27p-27, -0x1.edd2ccp-52),
    FPR(-0x1.1423eep-2, -0x1.f8d27p-27, 0x1.edd2ccp-52),
    FPR(0x1.ed0836p-1, -0x1.666ff6p-29, -0x1.d6cc5cp-54),
    FPR(0x1.f5fdeep-2, 0x1.95b368p-28, 0x1.742034p-53),
    FPR(0x1.be41b6p-1, 0x1.1154cp-29, 0x1.01192ap-54),
    FPR(-0x1.be41b6p-1, -0x1.1154cp-29, -0x1.01192ap-54),
    FPR(0x1.f5fdeep-2, 0x1.95b368p-28, 0x1.742034p-53),
    FPR(0x1.92aa42p-1, -0x1.d2bf58p-32, -0x1.68f89ep-57),
    FPR(0x1.3c3c44p-1, 0x1.3038a2p-26, 0x1.e4a166p-51),
    FPR(-0x1.3c3c44p-1, -0x1.3038a2p-26, -0x1.e4a166p-51),
    FPR(0x1.92aa42p-1, -0x1.d2bf58p-32, -0x1.68f89ep-57),
    FPR(0x1.e8eb8p-4, -0x1.0daaep-31, -0x1.48dd64p-56),
    FPR(0x1.fc56e4p-1, -0x1.209942p-27, -0x1.103ff8p-52),
    FPR(-0x1.fc56e4p-1, 0x1.209942p-27, 0x1.103ff8p-52),
    FPR(0x1.e8eb8p-4, -0x1.0daaep-31, -0x1.48dd64p-56),
    FPR(0x1.f830f4p-1, 0x1.4818c2p-26, -0x1.f3d6bcp-52),
    FPR(0x1.6451a8p-3, 0x1.8ec186p-30, 0x1.35a2cp-55),
    FPR(-0x1.6451a8p-3, -0x1.8ec186p-30, -0x1.35a2cp-55),
    FPR(0x1.f830f4p-1, 0x1.4818c2p-26, -0x1.f3d6bcp-52),
    FPR(0x1.258734p-1, 0x1.976e22p-26, 0x1.3a3f0ap-57),
    FPR(0x1.a38184p-1, 0x1.4b2778p-26, 0x1.6436d4p-51),
    FPR(-0x1.a38184p-1, -0x1.4b2778p-26, -0x1.6436d4p-51),
    FPR(0x1.258734p-1, 0x1.976e22p-26, 0x1.3a3f0ap-57),
    FPR(0x1.afb8fep-1, -0x1.d82a12p-27, -0x1.fdc626p-53),
    FPR(0x1.133e9cp-1, 0x1.fdc4aap-26, -0x1.3426fp-53),
    FPR(-0x1.133e9cp-1, -0x1.fdc4aap-26, 0x1.3426fp-53),
    FPR(0x1.afb8fep-1, -0x1.d82a12p-27, -0x1.fdc626p-53),
    FPR(0x1.ba9634p-3, -0x1.61d44ap-28, -0x1.aea132p-54),
    FPR(0x1.f3e6bcp-1, -0x1.f221cep-28, 0x1.15774cp-53),
    FPR(-0x1.f3e6bcp-1, 0x1.f221cep-28, -0x1.15774cp-53),
    FPR(0x1.ba9634p-3, -0x1.61d44ap-28, -0x1.aea132p-54),
    FPR(0x1.dd1ffp-1, -0x1.8eadd4p-26, -0x1.9782f2p-51),
    FPR(0x1.73763cp-2, 0x1.24c212p-27, 0x1.d5b9b6p-54),
    FPR(-0x1.73763cp-2, -0x1.24c212p-27, -0x1.d5b9b6p-54),
    FPR(0x1.dd1ffp-1, -0x1.8eadd4p-26, -0x1.9782f2p-51),
    FPR(0x1.9c17d4p-2, 0x1.037e7cp-28, 0x1.1923c6p-53),
    FPR(0x1.d4b5b2p-1, -0x1.39e2b8p-27, 0x1.f054ap-52),
    FPR(-0x1.d4b5b2p-1, 0x1.39e2b8p-27, -0x1.f054ap-52),
    FPR(0x1.9c17d4p-2, 0x1.037e7cp-28, 0x1.1923c6p-53),
    FPR(0x1.71bacap-1, -0x1.3e37c8p-26, -0x1.370b1cp-53),
    FPR(0x1.622e44p-1, 0x1.fd846p-26, -0x1.819c9ep-54),
    FPR(-0x1.622e44p-1, -0x1.fd846p-26, 0x1.819c9ep-54),
    FPR(0x1.71bacap-1, -0x1.3e37c8p-26, -0x1.370b1cp-53),
    FPR(0x1.5fd4d2p-6, 0x1.fab226p-34, -0x1.0c0a92p-61),
    FPR(0x1.ffe1c6p-1, 0x1.0e196ep-26, 0x1.d89aa2p-51),
    FPR(-0x1.ffe1c6p-1, -0x1.0e196ep-26, -0x1.d89aa2p-51),
    FPR(0x1.5fd4d2p-6, 0x1.fab226p-34, -0x1.0c0a92p-61),
    FPR(0x1.fff094p-1, 0x1.e29de8p-28, 0x1.5c633p-54),
    FPR(0x1.f6a296p-7, 0x1.5732fap-32, -0x1.5f2944p-57),
    FPR(-0x1.f6a296p-7, -0x1.5732fap-32, 0x1.5f2944p-57),
    FPR(0x1.fff094p-1, 0x1.e29de8p-28, 0x1.5c633p-54),
    FPR(0x1.647154p-1, 0x1.bfa9aep-28, -0x1.5f0e68p-53),
    FPR(0x1.6f8caap-1, -0x1.8da922p-27, -0x1.60dd18p-52),
    FPR(-0x1.6f8caap-1, 0x1.8da922p-27, 0x1.60dd18p-52),
    FPR(0x1.647154p-1, 0x1.bfa9aep-28, -0x1.5f0e68p-53),
    FPR(0x1.d5f718p-1, -0x1.aeeebp-26, -0x1.5a199p-53),
    FPR(0x1.96555cp-2, -0x1.0a8d6ep-27, -0x1.428158p-55),
    FPR(-0x1.96555cp-2, 0x1.0a8d6ep-27, 0x1.428158p-55),
    FPR(0x1.d5f718p-1, -0x1.aeeebp-26, -0x1.5a199p-53),
    FPR(0x1.794f5ep-2, 0x1.84f7ecp-28, -0x1.cfbeb6p-54),
    FPR(0x1.dbf9e4p-1, 0x1.cabacep-28, -0x1.89c024p-53),
    FPR(-0x1.dbf9e4p-1, -0x1.cabacep-28, 0x1.89c024p-53),
    FPR(0x1.794f5ep-2, 0x1.84f7ecp-28, -0x1.cfbeb6p-54),
    FPR(0x1.f4922p-1, 0x1.af2aeep-27, -0x1.c5c2dcp-52),
    FPR(0x1.ae4f1ep-3, -0x1.4188cap-28, -0x1.255744p-53),
    FPR(-0x1.ae4f1ep-3, 0x1.4188cap-28, 0x1.255744p-53),
    FPR(0x1.f4922p-1, 0x1.af2aeep-27, -0x1.c5c2dcp-52),
    FPR(0x1.15e36ep-1, 0x1.36f8bp-27, -0x1.ec3abap-52),
    FPR(0x1.ae069p-1, -0x1.974262p-26, -0x1.26726ap-53),
    FPR(-0x1.ae069p-1, 0x1.974262p-26, 0x1.26726ap-53),
    FPR(0x1.15e36ep-1, 0x1.36f8bp-27, -0x1.ec3abap-52),
    FPR(0x1.a54c92p-1, -0x1.ede15cp-26, 0x1.91843p-52),
    FPR(0x1.22f2d6p-1, 0x1.8b04f8p-27, 0x1.8a8ce2p-53),
    FPR(-0x1.22f2d6p-1, -0x1.8b04f8p-27, -0x1.8a8ce2p-53),
    FPR(0x1.a54c92p-1, -0x1.ede15cp-26, 0x1.91843p-52),
    FPR(0x1.70afd8p-3, 0x1.a118ap-28, -0x1.6cf9ep-56),
    FPR(0x1.f7a29ap-1, -0x1.f2e6eap-28, -0x1.d231cep-53),
    FPR(-0x1.f7a29ap-1, 0x1.f2e6eap-28, 0x1.d231cep-53),
    FPR(0x1.70afd8p-3, 0x1.a118ap-28, -0x1.6cf9ep-56),
    FPR(0x1.fcb47p-1, 0x1.c8a1aap-28, 0x1.126aa8p-55),
    FPR(0x1.cff534p-4, -0x1.33e09p-30, 0x1.31fdd8p-56),
    FPR(-0x1.cff534p-4, 0x1.33e09p-30, -0x1.31fdd8p-56),
    FPR(0x1.fcb47p-1, 0x1.c8a1aap-28, 0x1.126aa8p-55),
    FPR(0x1.3eb33ep-1, 0x1.57c0dp-26, 0x1.86a236p-58),
    FPR(0x1.90b794p-1, 0x1.abaf8p-28, -0x1.eb135p-53),
    FPR(-0x1.90b794p-1, -0x1.abaf8p-28, 0x1.eb135p-53),
    FPR(0x1.3eb33ep-1, 0x1.57c0dp-26, 0x1.86a236p-58),
    FPR(0x1.bfc9d2p-1, 0x1.686c52p-27, -0x1.0151cp-53),
    FPR(0x1.f0819p-2, 0x1.affep-28, -0x1.299566p-53),
    FPR(-0x1.f0819p-2, -0x1.affep-28, 0x1.299566p-53),
    FPR(0x1.bfc9d2p-1, 0x1.686c52p-27, -0x1.0151cp-53),
    FPR(0x1.1a2f8p-2, -0x1.05c37p-28, 0x1.ac8cb6p-53),
    FPR(0x1.ec2cf4p-1, 0x1.635ed6p-26, 0x1.0269dcp-52),
    FPR(-0x1.ec2cf4p-1, -0x1.635ed6p-26, -0x1.0269dcp-52),
    FPR(0x1.1a2f8p-2, -0x1.05c37p-28, 0x1.ac8cb6p-53),
    FPR(0x1.e79db2p-1, 0x1.34a2ccp-26, -0x1.8baf38p-51),
    FPR(0x1.383f5ep-2, 0x1.a9db56p-29, -0x1.6a04aap-54),
    FPR(-0x1.383f5ep-2, -0x1.a9db56p-29, 0x1.6a04aap-54),
    FPR(0x1.e79db2p-1, 0x1.34a2ccp-26, -0x1.8baf38p-51),
    FPR(0x1.d4cd02p-2, 0x1.750c14p-27, -0x1.937f34p-53),
    FPR(0x1.c73158p-1, 0x1.33d55ap-26, 0x1.b99068p-51),
    FPR(-0x1.c73158p-1, -0x1.33d55ap-26, -0x1.b99068p-51),
    FPR(0x1.d4cd02p-2, 0x1.750c14p-27, -0x1.937f34p-53),
    FPR(0x1.86c0a2p-1, -0x1.32af36p-28, 0x1.06115ap-53),
    FPR(0x1.4ad796p-1, -0x1.d31ba2p-26, 0x1.76c628p-54),
    FPR(-0x1.4ad796p-1, 0x1.d31ba2p-26, -0x1.76c628p-54),
    FPR(0x1.86c0a2p-1, -0x1.32af36p-28, 0x1.06115ap-53),
    FPR(0x1.52e774p-4, 0x1.49a9a2p-29, -0x1.793448p-54),
    FPR(0x1.fe3e92p-1, 0x1.7d3b1p-26, 0x1.86bfacp-51),
    FPR(-0x1.fe3e92p-1, -0x1.7d3b1p-26, -0x1.86bfacp-51),
    FPR(0x1.52e774p-4, 0x1.49a9a2p-29, -0x1.793448p-54),
    FPR(0x1.fef01p-1, 0x1.4130c8p-28, 0x1.2787d4p-53),
    FPR(0x1.07b614p-4, 0x1.c8c60cp-29, 0x1.d8f60ep-55),
    FPR(-0x1.07b614p-4, -0x1.c8c60cp-29, -0x1.d8f60ep-55),
    FPR(0x1.fef01p-1, 0x1.4130c8p-28, 0x1.2787d4p-53),
    FPR(0x1.51fa82p-1, -0x1.9332aep-28, 0x1.ffad98p-53),
    FPR(0x1.8098b8p-1, -0x1.5235ap-26, -0x1.66ec92p-51),
    FPR(-0x1.8098b8p-1, 0x1.5235ap-26, 0x1.66ec92p-51),
    FPR(0x1.51fa82p-1, -0x1.9332aep-28, 0x1.ffad98p-53),
    FPR(0x1.cb6e2p-1, 0x1.401b54p-26, -0x1.d4fb24p-51),
    FPR(0x1.c3f6d4p-2, 0x1.c98c4ap-28, 0x1.671ef4p-54),
    FPR(-0x1.c3f6d4p-2, -0x1.c98c4ap-28, -0x1.671ef4p-54),
    FPR(0x1.cb6e2p-1, 0x1.401b54p-26, -0x1.d4fb24p-51),
    FPR(0x1.4a253ep-2, -0x1.dc8fa2p-27, 0x1.76a82ep-53),
    FPR(0x1.e4a8ep-1, -0x1.f8c686p-31, -0x1.7950f2p-56),
    FPR(-0x1.e4a8ep-1, 0x1.f8c686p-31, 0x1.7950f2p-56),
    FPR(0x1.4a253ep-2, -0x1.dc8fa2p-27, 0x1.76a82ep-53),
    FPR(0x1.eeb074p-1, 0x1.8a14a8p-26, 0x1.1d926p-51),
    FPR(0x1.0804ep-2, 0x1.7ad988p-28, -0x1.aac6ap-54),
    FPR(-0x1.0804ep-2, -0x1.7ad988p-28, 0x1.aac6ap-54),
    FPR(0x1.eeb074p-1, 0x1.8a14a8p-26, 0x1.1d926p-51),
    FPR(0x1.00740cp-1, 0x1.05705cp-26, 0x1.495bd4p-54),
    FPR(0x1.bb249ap-1, 0x1.6d881ap-30, -0x1.d6318ep-58),
    FPR(-0x1.bb249ap-1, -0x1.6d881ap-30, 0x1.d6318ep-58),
    FPR(0x1.00740cp-1, 0x1.05705cp-26, 0x1.495bd4p-54),
    FPR(0x1.9683f4p-1, 0x1.5ebffp-28, 0x1.ddc8a4p-54),
    FPR(0x1.374532p-1, -0x1.1fa01cp-27, -0x1.57765ap-52),
    FPR(-0x1.374532p-1, 0x1.1fa01cp-27, 0x1.57765ap-52),
    FPR(0x1.9683f4p-1, 0x1.5ebffp-28, 0x1.ddc8a4p-54),
    FPR(0x1.0d64dcp-3, -0x1.a6cc3ep-30, 0x1.d1d8b6p-55),
    FPR(0x1.fb8d18p-1, 0x1.acd5b6p-26, 0x1.b17a4cp-51),
    FPR(-0x1.fb8d18p-1, -0x1.acd5b6p-26, -0x1.b17a4cp-51),
    FPR(0x1.0d64dcp-3, -0x1.a6cc3ep-30, 0x1.d1d8b6p-55),
    FPR(0x1.f93f14p-1, 0x1.f0b58p-26, 0x1.e302eap-51),
    FPR(0x1.4b8b18p-3, -0x1.0c0afp-32, 0x1.b534fep-57),
    FPR(-0x1.4b8b18p-3, 0x1.0c0afp-32, -0x1.b534fep-57),
    FPR(0x1.f93f14p-1, 0x1.f0b58p-26, 0x1.e302eap-51),
    FPR(0x1.2aa76ep-1, 0x1.0f5d6cp-26, -0x1.fe02ap-51),
    FPR(0x1.9fdf5p-1, -0x1.d9d6c4p-26, -0x1.b864a2p-53),
    FPR(-0x1.9fdf5p-1, 0x1.d9d6c4p-26, 0x1.b864a2p-53),
    FPR(0x1.2aa76ep-1, 0x1.0f5d6cp-26, -0x1.fe02ap-51),
    FPR(0x1.b3115ap-1, 0x1.7cdefcp-27, 0x1.bbbc4ep-52),
    FPR(0x1.0ded0cp-1, -0x1.ed0ed2p-27, -0x1.30a82p-52),
    FPR(-0x1.0ded0cp-1, 0x1.ed0ed2p-27, 0x1.30a82p-52),
    FPR(0x1.b3115ap-1, 0x1.7cdefcp-27, 0x1.bbbc4ep-52),
    FPR(0x1.d31774p-3, 0x1.a597bep-28, -0x1.b408dcp-55),
    FPR(0x1.f2818p-1, -0x1.dcfb1ap-28, 0x1.88b81cp-53),
    FPR(-0x1.f2818p-1, 0x1.dcfb1ap-28, -0x1.88b81cp-53),
    FPR(0x1.d31774p-3, 0x1.a597bep-28, -0x1.b408dcp-55),
    FPR(0x1.df5e36p-1, 0x1.5374b4p-26, -0x1.07807ep-51),
    FPR(0x1.67b94ap-2, -0x1.a94e1ap-29, -0x1.688cdap-54),
    FPR(-0x1.67b94ap-2, 0x1.a94e1ap-29, 0x1.688cdap-54),
    FPR(0x1.df5e36p-1, 0x1.5374b4p-26, -0x1.07807ep-51),
    FPR(0x1.a790cep-2, -0x1.84819cp-27, -0x1.4bfbc4p-52),
    FPR(0x1.d2255cp-1, 0x1.b96938p-27, 0x1.176b2cp-54),
    FPR(-0x1.d2255cp-1, -0x1.b96938p-27, -0x1.176b2cp-54),
    FPR(0x1.a790cep-2, -0x1.84819cp-27, -0x1.4bfbc4p-52),
    FPR(0x1.760c52p-1, 0x1.8608ecp-26, 0x1.ddc512p-52),
    FPR(0x1.5d9deep-1, 0x1.cf8d16p-27, 0x1.f10f74p-52),
    FPR(-0x1.5d9deep-1, -0x1.cf8d16p-27, -0x1.f10f74p-52),
    FPR(0x1.760c52p-1, 0x1.8608ecp-26, 0x1.ddc512p-52),
    FPR(0x1.14685ep-5, -0x1.2f4fap-31, -0x1.4a2434p-57),
    FPR(0x1.ffb55ep-1, 0x1.097f6cp-27, -0x1.a49604p-53),
    FPR(-0x1.ffb55ep-1, -0x1.097f6cp-27, 0x1.a49604p-53),
    FPR(0x1.14685ep-5, -0x1.2f4fap-31, -0x1.4a2434p-57),
    FPR(0x1.ff97c4p-1, 0x1.04600ap-28, 0x1.52ab2cp-57),
    FPR(0x1.46a396p-5, 0x1.ff0c3p-30, -0x1.bbb254p-55),
    FPR(-0x1.46a396p-5, -0x1.ff0c3p-30, 0x1.bbb254p-55),
    FPR(0x1.ff97c4p-1, 0x1.04600ap-28, 0x1.52ab2cp-57),
    FPR(0x1.5b50b2p-1, 0x1.93dd12p-27, 0x1.519d3p-56),
    FPR(0x1.782fb2p-1, -0x1.1bd32ap-27, 0x1.583728p-52),
    FPR(-0x1.782fb2p-1, 0x1.1bd32ap-27, -0x1.583728p-52),
    FPR(0x1.5b50b2p-1, 0x1.93dd12p-27, 0x1.519d3p-56),
    FPR(0x1.d0d672p-1, 0x1.eb3a58p-26, -0x1.dc83p-51),
    FPR(0x1.ad4732p-2, -0x1.b4647ep-27, -0x1.c4de7cp-52),
    FPR(-0x1.ad4732p-2, 0x1.b4647ep-27, 0x1.c4de7cp-52),
    FPR(0x1.d0d672p-1, 0x1.eb3a58p-26, -0x1.dc83p-51),
    FPR(0x1.61d596p-2, -0x1.bb9efep-29, -0x1.825388p-54),
    FPR(0x1.e0766ep-1, -0x1.b5fc2ap-27, -0x1.c1766ep-52),
    FPR(-0x1.e0766ep-1, 0x1.b5fc2ap-27, 0x1.c1766ep-52),
    FPR(0x1.61d596p-2, -0x1.bb9efep-29, -0x1.825388p-54),
    FPR(0x1.f1c7acp-1, -0x1.d7b8f8p-29, 0x1.504b8p-55),
    FPR(0x1.df5164p-3, -0x1.fdecccp-32, -0x1.01f7d8p-57),
    FPR(-0x1.df5164p-3, 0x1.fdecccp-32, 0x1.01f7d8p-57),
    FPR(0x1.f1c7acp-1, -0x1.d7b8f8p-29, 0x1.504b8p-55),
    FPR(0x1.0b4058p-1, 0x1.e3e17ap-27, 0x1.ca5328p-52),
    FPR(0x1.b4b74p-1, 0x1.3bcf24p-26, 0x1.4fa712p-51),
    FPR(-0x1.b4b74p-1, -0x1.3bcf24p-26, -0x1.4fa712p-51),
    FPR(0x1.0b4058p-1, 0x1.e3e17ap-27, 0x1.ca5328p-52),
    FPR(0x1.9e082ep-1, 0x1.b6848ep-26, 0x1.0ac04ep-52),
    FPR(0x1.2d333ep-1, -0x1.962c8ap-26, 0x1.ef1d3ep-51),
    FPR(-0x1.2d333ep-1, 0x1.962c8ap-26, -0x1.ef1d3ep-51),
    FPR(0x1.9e082ep-1, 0x1.b6848ep-26, 0x1.0ac04ep-52),
    FPR(0x1.3f22f6p-3, -0x1.0496eep-28, 0x1.8dff4p-54),
    FPR(0x1.f9bed8p-1, -0x1.8210ecp-28, 0x1.932938p-54),
    FPR(-0x1.f9bed8p-1, 0x1.8210ecp-28, -0x1.932938p-54),
    FPR(0x1.3f22f6p-3, -0x1.0496eep-28, 0x1.8dff4p-54),
    FPR(0x1.fb20dcp-1, 0x1.a07554p-27, -0x1.bfe292p-52),
    FPR(0x1.19d894p-3, 0x1.7c49cep-32, 0x1.e8dcdcp-58),
    FPR(-0x1.19d894p-3, -0x1.7c49cep-32, -0x1.e8dcdcp-58),
    FPR(0x1.fb20dcp-1, 0x1.a07554p-27, -0x1.bfe292p-52),
    FPR(0x1.34c526p-1, -0x1.a7d644p-26, 0x1.560fd2p-53),
    FPR(0x1.986afp-1, -0x1.d7514ep-26, 0x1.ca1f84p-52),
    FPR(-0x1.986afp-1, 0x1.d7514ep-26, -0x1.ca1f84p-52),
    FPR(0x1.34c526p-1, -0x1.a7d644p-26, 0x1.560fd2p-53),
    FPR(0x1.b98fa2p-1, -0x1.37550ep-32, 0x1.55640ep-57),
    FPR(0x1.032ae6p-1, -0x1.42484ep-26, 0x1.6424fep-51),
    FPR(-0x1.032ae6p-1, 0x1.42484ep-26, -0x1.6424fep-51),
    FPR(0x1.b98fa2p-1, -0x1.37550ep-32, 0x1.55640ep-57),
    FPR(0x1.01f18p-2, 0x1.ae7f74p-28, 0x1.aedfb2p-54),
    FPR(0x1.ef7d6ep-1, 0x1.4728fp-27, -0x1.a3c67cp-55),
    FPR(-0x1.ef7d6ep-1, -0x1.4728fp-27, 0x1.a3c67cp-55),
    FPR(0x1.01f18p-2, 0x1.ae7f74p-28, 0x1.aedfb2p-54),
    FPR(0x1.e3a33ep-1, 0x1.8eb9dp-26, 0x1.451422p-51),
    FPR(0x1.50163ep-2, -0x1.f347dcp-29, -0x1.ec66ccp-56),
    FPR(-0x1.50163ep-2, 0x1.f347dcp-29, 0x1.ec66ccp-56),
    FPR(0x1.e3a33ep-1, 0x1.8eb9dp-26, 0x1.451422p-51),
    FPR(0x1.be5152p-2, -0x1.0007e4p-27, -0x1.ad4998p-52),
    FPR(0x1.cccee2p-1, 0x1.85bd4p-30, -0x1.d3116ap-55),
    FPR(-0x1.cccee2p-1, -0x1.85bd4p-30, 0x1.d3116ap-55),
    FPR(0x1.be5152p-2, -0x1.0007e4p-27, -0x1.ad4998p-52),
    FPR(0x1.7e83f8p-1, 0x1.ec0da2p-27, -0x1.e49e58p-53),
    FPR(0x1.5455p-1, -0x1.5d4c4p-26, -0x1.14e248p-51),
    FPR(-0x1.5455p-1, 0x1.5d4c4p-26, 0x1.14e248p-51),
    FPR(0x1.7e83f8p-1, 0x1.ec0da2p-27, -0x1.e49e58p-53),
    FPR(0x1.dd407p-5, -0x1.9fdc4ep-31, 0x1.08989ep-57),
    FPR(0x1.ff2162p-1, -0x1.63d9c2p-26, -0x1.bbcd26p-52),
    FPR(-0x1.ff2162p-1, 0x1.63d9c2p-26, 0x1.bbcd26p-52),
    FPR(0x1.dd407p-5, -0x1.9fdc4ep-31, 0x1.08989ep-57),
    FPR(0x1.fdf992p-1, 0x1.7b9984p-28, -0x1.9687d6p-54),
    FPR(0x1.6bf1b4p-4, -0x1.864ed8p-32, 0x1.75a492p-57),
    FPR(-0x1.6bf1b4p-4, 0x1.864ed8p-32, -0x1.75a492p-57),
    FPR(0x1.fdf992p-1, 0x1.7b9984p-28, -0x1.9687d6p-54),
    FPR(0x1.487034p-1, -0x1.f3edcp-26, -0x1.170814p-53),
    FPR(0x1.88c66ep-1, 0x1.d206e8p-27, 0x1.a8e776p-54),
    FPR(-0x1.88c66ep-1, -0x1.d206e8p-27, -0x1.a8e776p-54),
    FPR(0x1.487034p-1, -0x1.f3edcp-26, -0x1.170814p-53),
    FPR(0x1.c5bef6p-1, -0x1.8041eap-27, 0x1.f07aep-53),
    FPR(0x1.da60c6p-2, -0x1.82f794p-29, 0x1.bc31c8p-55),
    FPR(-0x1.da60c6p-2, 0x1.82f794p-29, -0x1.bc31c8p-55),
    FPR(0x1.c5bef6p-1, -0x1.8041eap-27, 0x1.f07aep-53),
    FPR(0x1.3241fcp-2, -0x1.38e8aap-27, -0x1.f0988cp-55),
    FPR(0x1.e89096p-1, -0x1.14a7f6p-27, -0x1.ab4998p-52),
    FPR(-0x1.e89096p-1, 0x1.14a7f6p-27, 0x1.ab4998p-52),
    FPR(0x1.3241fcp-2, -0x1.38e8aap-27, -0x1.f0988cp-55),
    FPR(0x1.eb4cf6p-1, -0x1.d48efep-26, 0x1.195da2p-53),
    FPR(0x1.203858p-2, 0x1.eb93dep-29, 0x1.c72c66p-54),
    FPR(-0x1.203858p-2, -0x1.eb93dep-29, -0x1.c72c66p-54),
    FPR(0x1.eb4cf6p-1, -0x1.d48efep-26, 0x1.195da2p-53),
    FPR(0x1.eb006ap-2, -0x1.41b53cp-27, 0x1.53c9fep-56),
    FPR(0x1.c14d9ep-1, -0x1.dcd0d4p-28, -0x1.18e4a4p-54),
    FPR(-0x1.c14d9ep-1, 0x1.dcd0d4p-28, 0x1.18e4a4p-54),
    FPR(0x1.eb006ap-2, -0x1.41b53cp-27, 0x1.53c9fep-56),
    FPR(0x1.8ec10ap-1, -0x1.2de4eep-27, 0x1.8d357p-54),
    FPR(0x1.412726p-1, 0x1.8f4424p-27, -0x1.dc8832p-52),
    FPR(-0x1.412726p-1, -0x1.8f4424p-27, 0x1.dc8832p-52),
    FPR(0x1.8ec10ap-1, -0x1.2de4eep-27, 0x1.8d357p-54),
    FPR(0x1.b6fa6ep-4, 0x1.871ecap-29, -0x1.c4944ep-55),
    FPR(0x1.fd0d16p-1, -0x1.c9e7dep-27, -0x1.347d2cp-54),
    FPR(-0x1.fd0d16p-1, 0x1.c9e7dep-27, 0x1.347d2cp-54),
    FPR(0x1.b6fa6ep-4, 0x1.871ecap-29, -0x1.c4944ep-55),
    FPR(0x1.f70f64p-1, 0x1.a5bf5cp-28, -0x1.ba2288p-54),
    FPR(0x1.7d0a7cp-3, -0x1.0b4d3ap-29, 0x1.c60dfep-54),
    FPR(-0x1.7d0a7cp-3, 0x1.0b4d3ap-29, -0x1.c60dfep-54),
    FPR(0x1.f70f64p-1, 0x1.a5bf5cp-28, -0x1.ba2288p-54),
    FPR(0x1.205baap-1, 0x1.7560d6p-29, 0x1.b7b144p-56),
    FPR(0x1.a7138ep-1, -0x1.629f0cp-29, 0x1.072a3ep-54),
    FPR(-0x1.a7138ep-1, 0x1.629f0cp-29, -0x1.072a3ep-54),
    FPR(0x1.205baap-1, 0x1.7560d6p-29, 0x1.b7b144p-56),
    FPR(0x1.ac4ffcp-1, -0x1.60829cp-28, -0x1.818504p-56),
    FPR(0x1.188592p-1, -0x1.8b7236p-30, -0x1.bbefe6p-56),
    FPR(-0x1.188592p-1, 0x1.8b7236p-30, 0x1.bbefe6p-56),
    FPR(0x1.ac4ffcp-1, -0x1.60829cp-28, -0x1.818504p-56),
    FPR(0x1.a203e2p-3, -0x1.39f38ap-29, 0x1.1c1aaep-54),
    FPR(0x1.f538b2p-1, -0x1.434be4p-31, -0x1.5f7cd6p-59),
    FPR(-0x1.f538b2p-1, 0x1.434be4p-31, 0x1.5f7cd6p-59),
    FPR(0x1.a203e2p-3, -0x1.39f38ap-29, 0x1.1c1aaep-54),
    FPR(0x1.dacf42p-1, 0x1.9cd158p-26, -0x1.cff46cp-51),
    FPR(0x1.7f24dep-2, -0x1.9197c4p-27, 0x1.093c8ep-52),
    FPR(-0x1.7f24dep-2, 0x1.9197c4p-27, -0x1.093c8ep-52),
    FPR(0x1.dacf42p-1, 0x1.9cd158p-26, -0x1.cff46cp-51),
    FPR(0x1.908ef8p-2, 0x1.ef7bd2p-30, -0x1.59ffecp-55),
    FPR(0x1.d733f6p-1, -0x1.ee7e4p-26, -0x1.401e4ap-53),
    FPR(-0x1.d733f6p-1, 0x1.ee7e4p-26, 0x1.401e4ap-53),
    FPR(0x1.908ef8p-2, 0x1.ef7bd2p-30, -0x1.59ffecp-55),
    FPR(0x1.6d5afep-1, 0x1.e955fap-26, -0x1.b0d14ep-52),
    FPR(0x1.66b0f4p-1, -0x1.5a98f4p-30, 0x1.1e2eb4p-55),
    FPR(-0x1.66b0f4p-1, 0x1.5a98f4p-30, -0x1.1e2eb4p-55),
    FPR(0x1.6d5afep-1, 0x1.e955fap-26, -0x1.b0d14ep-52),
    FPR(0x1.2d96bp-7, 0x1.ca12ep-32, 0x1.770b76p-58),
    FPR(0x1.fffa72p-1, 0x1.92f18ap-26, -0x1.48b2cp-53),
    FPR(-0x1.fffa72p-1, -0x1.92f18ap-26, 0x1.48b2cp-53),
    FPR(0x1.2d96bp-7, 0x1.ca12ep-32, 0x1.770b76p-58),
    FPR(0x1.fffa72p-1, 0x1.92f18ap-26, -0x1.48b2cp-53),
    FPR(0x1.2d96bp-7, 0x1.ca12ep-32, 0x1.770b76p-58),
    FPR(-0x1.2d96bp-7, -0x1.ca12ep-32, -0x1.770b76p-58),
    FPR(0x1.fffa72p-1, 0x1.92f18ap-26, -0x1.48b2cp-53),
    FPR(0x1.66b0f4p-1, -0x1.5a98f4p-30, 0x1.1e2eb4p-55),
    FPR(0x1.6d5afep-1, 0x1.e955fap-26, -0x1.b0d14ep-52),
    FPR(-0x1.6d5afep-1, -0x1.e955fap-26, 0x1.b0d14ep-52),
    FPR(0x1.66b0f4p-1, -0x1.5a98f4p-30, 0x1.1e2eb4p-55),
    FPR(0x1.d733f6p-1, -0x1.ee7e4p-26, -0x1.401e4ap-53),
    FPR(0x1.908ef8p-2, 0x1.ef7bd2p-30, -0x1.59ffecp-55),
    FPR(-0x1.908ef8p-2, -0x1.ef7bd2p-30, 0x1.59ffecp-55),
    FPR(0x1.d733f6p-1, -0x1.ee7e4p-26, -0x1.401e4ap-53),
    FPR(0x1.7f24dep-2, -0x1.9197c4p-27, 0x1.093c8ep-52),
    FPR(0x1.dacf42p-1, 0x1.9cd158p-26, -0x1.cff46cp-51),
    FPR(-0x1.dacf42p-1, -0x1.9cd158p-26, 0x1.cff46cp-51),
    FPR(0x1.7f24dep-2, -0x1.9197c4p-27, 0x1.093c8ep-52),
    FPR(0x1.f538b2p-1, -0x1.434be4p-31, -0x1.5f7cd6p-59),
    FPR(0x1.a203e2p-3, -0x1.39f38ap-29, 0x1.1c1aaep-54),
    FPR(-0x1.a203e2p-3, 0x1.39f38ap-29, -0x1.1c1aaep-54),
    FPR(0x1.f538b2p-1, -0x1.434be4p-31, -0x1.5f7cd6p-59),
    FPR(0x1.188592p-1, -0x1.8b7236p-30, -0x1.bbefe6p-56),
    FPR(0x1.ac4ffcp-1, -0x1.60829cp-28, -0x1.818504p-56),
    FPR(-0x1.ac4ffcp-1, 0x1.60829cp-28, 0x1.818504p-56),
    FPR(0x1.188592p-1, -0x1.8b7236p-30, -0x1.bbefe6p-56),
    FPR(0x1.a7138ep-1, -0x1.629f0cp-29, 0x1.072a3ep-54),
    FPR(0x1.205baap-1, 0x1.7560d6p-29, 0x1.b7b144p-56),
    FPR(-0x1.205baap-1, -0x1.7560d6p-29, -0x1.b7b144p-56),
    FPR(0x1.a7138ep-1, -0x1.629f0cp-29, 0x1.072a3ep-54),
    FPR(0x1.7d0a7cp-3, -0x1.0b4d3ap-29, 0x1.c60dfep-54),
    FPR(0x1.f70f64p-1, 0x1.a5bf5cp-28, -0x1.ba2288p-54),
    FPR(-0x1.f70f64p-1, -0x1.a5bf5cp-28, 0x1.ba2288p-54),
    FPR(0x1.7d0a7cp-3, -0x1.0b4d3ap-29, 0x1.c60dfep-54),
    FPR(0x1.fd0d16p-1, -0x1.c9e7dep-27, -0x1.347d2cp-54),
    FPR(0x1.b6fa6ep-4, 0x1.871ecap-29, -0x1.c4944ep-55),
    FPR(-0x1.b6fa6ep-4, -0x1.871ecap-29, 0x1.c4944ep-55),
    FPR(0x1.fd0d16p-1, -0x1.c9e7dep-27, -0x1.347d2cp-54),
    FPR(0x1.412726p-1, 0x1.8f4424p-27, -0x1.dc8832p-52),
    FPR(0x1.8ec10ap-1, -0x1.2de4eep-27, 0x1.8d357p-54),
    FPR(-0x1.8ec10ap-1, 0x1.2de4eep-27, -0x1.8d357p-54),
    FPR(0x1.412726p-1, 0x1.8f4424p-27, -0x1.dc8832p-52),
    FPR(0x1.c14d9ep-1, -0x1.dcd0d4p-28, -0x1.18e4a4p-54),
    FPR(0x1.eb006ap-2, -0x1.41b53cp-27, 0x1.53c9fep-56),
    FPR(-0x1.eb006ap-2, 0x1.41b53cp-27, -0x1.53c9fep-56),
    FPR(0x1.c14d9ep-1, -0x1.dcd0d4p-28, -0x1.18e4a4p-54),
    FPR(0x1.203858p-2, 0x1.eb93dep-29, 0x1.c72c66p-54),
    FPR(0x1.eb4cf6p-1, -0x1.d48efep-26, 0x1.195da2p-53),
    FPR(-0x1.eb4cf6p-1, 0x1.d48efep-26, -0x1.195da2p-53),
    FPR(0x1.203858p-2, 0x1.eb93dep-29, 0x1.c72c66p-54),
    FPR(0x1.e89096p-1, -0x1.14a7f6p-27, -0x1.ab4998p-52),
    FPR(0x1.3241fcp-2, -0x1.38e8aap-27, -0x1.f0988cp-55),
    FPR(-0x1.3241fcp-2, 0x1.38e8aap-27, 0x1.f0988cp-55),
    FPR(0x1.e89096p-1, -0x1.14a7f6p-27, -0x1.ab4998p-52),
    FPR(0x1.da60c6p-2, -0x1.82f794p-29, 0x1.bc31c8p-55),
    FPR(0x1.c5bef6p-1, -0x1.8041eap-27, 0x1.f07aep-53),
    FPR(-0x1.c5bef6p-1, 0x1.8041eap-27, -0x1.f07aep-53),
    FPR(0x1.da60c6p-2, -0x1.82f794p-29, 0x1.bc31c8p-55),
    FPR(0x1.88c66ep-1, 0x1.d206e8p-27, 0x1.a8e776p-54),
    FPR(0x1.487034p-1, -0x1.f3edcp-26, -0x1.170814p-53),
    FPR(-0x1.487034p-1, 0x1.f3edcp-26, 0x1.170814p-53),
    FPR(0x1.88c66ep-1, 0x1.d206e8p-27, 0x1.a8e776p-54),
    FPR(0x1.6bf1b4p-4, -0x1.864ed8p-32, 0x1.75a492p-57),
    FPR(0x1.fdf992p-1, 0x1.7b9984p-28, -0x1.9687d6p-54),
    FPR(-0x1.fdf992p-1, -0x1.7b9984p-28, 0x1.9687d6p-54),
    FPR(0x1.6bf1b4p-4, -0x1.864ed8p-32, 0x1.75a492p-57),
    FPR(0x1.ff2162p-1, -0x1.63d9c2p-26, -0x1.bbcd26p-52),
    FPR(0x1.dd407p-5, -0x1.9fdc4ep-31, 0x1.08989ep-57),
    FPR(-0x1.dd407p-5, 0x1.9fdc4ep-31, -0x1.08989ep-57),
    FPR(0x1.ff2162p-1, -0x1.63d9c2p-26, -0x1.bbcd26p-52),
    FPR(0x1.5455p-1, -0x1.5d4c4p-26, -0x1.14e248p-51),
    FPR(0x1.7e83f8p-1, 0x1.ec0da2p-27, -0x1.e49e58p-53),
    FPR(-0x1.7e83f8p-1, -0x1.ec0da2p-27, 0x1.e49e58p-53),
    FPR(0x1.5455p-1, -0x1.5d4c4p-26, -0x1.14e248p-51),
    FPR(0x1.cccee2p-1, 0x1.85bd4p-30, -0x1.d3116ap-55),
    FPR(0x1.be5152p-2, -0x1.0007e4p-27, -0x1.ad4998p-52),
    FPR(-0x1.be5152p-2, 0x1.0007e4p-27, 0x1.ad4998p-52),
    FPR(0x1.cccee2p-1, 0x1.85bd4p-30, -0x1.d3116ap-55),
    FPR(0x1.50163ep-2, -0x1.f347dcp-29, -0x1.ec66ccp-56),
    FPR(0x1.e3a33ep-1, 0x1.8eb9dp-26, 0x1.451422p-51),
    FPR(-0x1.e3a33ep-1, -0x1.8eb9dp-26, -0x1.451422p-51),
    FPR(0x1.50163ep-2, -0x1.f347dcp-29, -0x1.ec66ccp-56),
    FPR(0x1.ef7d6ep-1, 0x1.4728fp-27, -0x1.a3c67cp-55),
    FPR(0x1.01f18p-2, 0x1.ae7f74p-28, 0x1.aedfb2p-54),
    FPR(-0x1.01f18p-2, -0x1.ae7f74p-28, -0x1.aedfb2p-54),
    FPR(0x1.ef7d6ep-1, 0x1.4728fp-27, -0x1.a3c67cp-55),
    FPR(0x1.032ae6p-1, -0x1.42484ep-26, 0x1.6424fep-51),
    FPR(0x1.b98fa2p-1, -0x1.37550ep-32, 0x1.55640ep-57),
    FPR(-0x1.b98fa2p-1, 0x1.37550ep-32, -0x1.55640ep-57),
    FPR(0x1.032ae6p-1, -0x1.42484ep-26, 0x1.6424fep-51),
    FPR(0x1.986afp-1, -0x1.d7514ep-26, 0x1.ca1f84p-52),
    FPR(0x1.34c526p-1, -0x1.a7d644p-26, 0x1.560fd2p-53),
    FPR(-0x1.34c526p-1, 0x1.a7d644p-26, -0x1.560fd2p-53),
    FPR(0x1.986afp-1, -0x1.d7514ep-26, 0x1.ca1f84p-52),
    FPR(0x1.19d894p-3, 0x1.7c49cep-32, 0x1.e8dcdcp-58),
    FPR(0x1.fb20dcp-1, 0x1.a07554p-27, -0x1.bfe292p-52),
    FPR(-0x1.fb20dcp-1, -0x1.a07554p-27, 0x1.bfe292p-52),
    FPR(0x1.19d894p-3, 0x1.7c49cep-32, 0x1.e8dcdcp-58),
    FPR(0x1.f9bed8p-1, -0x1.8210ecp-28, 0x1.932938p-54),
    FPR(0x1.3f22f6p-3, -0x1.0496eep-28, 0x1.8dff4p-54),
    FPR(-0x1.3f22f6p-3, 0x1.0496eep-28, -0x1.8dff4p-54),
    FPR(0x1.f9bed8p-1, -0x1.8210ecp-28, 0x1.932938p-54),
    FPR(0x1.2d333ep-1, -0x1.962c8ap-26, 0x1.ef1d3ep-51),
    FPR(0x1.9e082ep-1, 0x1.b6848ep-26, 0x1.0ac04ep-52),
    FPR(-0x1.9e082ep-1, -0x1.b6848ep-26, -0x1.0ac04ep-52),
    FPR(0x1.2d333ep-1, -0x1.962c8ap-26, 0x1.ef1d3ep-51),
    FPR(0x1.b4b74p-1, 0x1.3bcf24p-26, 0x1.4fa712p-51),
    FPR(0x1.0b4058p-1, 0x1.e3e17ap-27, 0x1.ca5328p-52),
    FPR(-0x1.0b4058p-1, -0x1.e3e17ap-27, -0x1.ca5328p-52),
    FPR(0x1.b4b74p-1, 0x1.3bcf24p-26, 0x1.4fa712p-51),
    FPR(0x1.df5164p-3, -0x1.fdecccp-32, -0x1.01f7d8p-57),
    FPR(0x1.f1c7acp-1, -0x1.d7b8f8p-29, 0x1.504b8p-55),
    FPR(-0x1.f1c7acp-1, 0x1.d7b8f8p-29, -0x1.504b8p-55),
    FPR(0x1.df5164p-3, -0x1.fdecccp-32, -0x1.01f7d8p-57),
    FPR(0x1.e0766ep-1, -0x1.b5fc2ap-27, -0x1.c1766ep-52),
    FPR(0x1.61d596p-2, -0x1.bb9efep-29, -0x1.825388p-54),
    FPR(-0x1.61d596p-2, 0x1.bb9efep-29, 0x1.825388p-54),
    FPR(0x1.e0766ep-1, -0x1.b5fc2ap-27, -0x1.c1766ep-52),
    FPR(0x1.ad4732p-2, -0x1.b4647ep-27, -0x1.c4de7cp-52),
    FPR(0x1.d0d672p-1, 0x1.eb3a58p-26, -0x1.dc83p-51),
    FPR(-0x1.d0d672p-1, -0x1.eb3a58p-26, 0x1.dc83p-51),
    FPR(0x1.ad4732p-2, -0x1.b4647ep-27, -0x1.c4de7cp-52),
    FPR(0x1.782fb2p-1, -0x1.1bd32ap-27, 0x1.583728p-52),
    FPR(0x1.5b50b2p-1, 0x1.93dd12p-27, 0x1.519d3p-56),
    FPR(-0x1.5b50b2p-1, -0x1.93dd12p-27, -0x1.519d3p-56),
    FPR(0x1.782fb2p-1, -0x1.1bd32ap-27, 0x1.583728p-52),
    FPR(0x1.46a396p-5, 0x1.ff0c3p-30, -0x1.bbb254p-55),
    FPR(0x1.ff97c4p-1, 0x1.04600ap-28, 0x1.52ab2cp-57),
    FPR(-0x1.ff97c4p-1, -0x1.04600ap-28, -0x1.52ab2cp-57),
    FPR(0x1.46a396p-5, 0x1.ff0c3p-30, -0x1.bbb254p-55),
    FPR(0x1.ffb55ep-1, 0x1.097f6cp-27, -0x1.a49604p-53),
    FPR(0x1.14685ep-5, -0x1.2f4fap-31, -0x1.4a2434p-57),
    FPR(-0x1.14685ep-5, 0x1.2f4fap-31, 0x1.4a2434p-57),
    FPR(0x1.ffb55ep-1, 0x1.097f6cp-27, -0x1.a49604p-53),
    FPR(0x1.5d9deep-1, 0x1.cf8d16p-27, 0x1.f10f74p-52),
    FPR(0x1.760c52p-1, 0x1.8608ecp-26, 0x1.ddc512p-52),
    FPR(-0x1.760c52p-1, -0x1.8608ecp-26, -0x1.ddc512p-52),
    FPR(0x1.5d9deep-1, 0x1.cf8d16p-27, 0x1.f10f74p-52),
    FPR(0x1.d2255cp-1, 0x1.b96938p-27, 0x1.176b2cp-54),
    FPR(0x1.a790cep-2, -0x1.84819cp-27, -0x1.4bfbc4p-52),
    FPR(-0x1.a790cep-2, 0x1.84819cp-27, 0x1.4bfbc4p-52),
    FPR(0x1.d2255cp-1, 0x1.b96938p-27, 0x1.176b2cp-54),
    FPR(0x1.67b94ap-2, -0x1.a94e1ap-29, -0x1.688cdap-54),
    FPR(0x1.df5e36p-1, 0x1.5374b4p-26, -0x1.07807ep-51),
    FPR(-0x1.df5e36p-1, -0x1.5374b4p-26, 0x1.07807ep-51),
    FPR(0x1.67b94ap-2, -0x1.a94e1ap-29, -0x1.688cdap-54),
    FPR(0x1.f2818p-1, -0x1.dcfb1ap-28, 0x1.88b81cp-53),
    FPR(0x1.d31774p-3, 0x1.a597bep-28, -0x1.b408dcp-55),
    FPR(-0x1.d31774p-3, -0x1.a597bep-28, 0x1.b408dcp-55),
    FPR(0x1.f2818p-1, -0x1.dcfb1ap-28, 0x1.88b81cp-53),
    FPR(0x1.0ded0cp-1, -0x1.ed0ed2p-27, -0x1.30a82p-52),
    FPR(0x1.b3115ap-1, 0x1.7cdefcp-27, 0x1.bbbc4ep-52),
    FPR(-0x1.b3115ap-1, -0x1.7cdefcp-27, -0x1.bbbc4ep-52),
    FPR(0x1.0ded0cp-1, -0x1.ed0ed2p-27, -0x1.30a82p-52),
    FPR(0x1.9fdf5p-1, -0x1.d9d6c4p-26, -0x1.b864a2p-53),
    FPR(0x1.2aa76ep-1, 0x1.0f5d6cp-26, -0x1.fe02ap-51),
    FPR(-0x1.2aa76ep-1, -0x1.0f5d6cp-26, 0x1.fe02ap-51),
    FPR(0x1.9fdf5p-1, -0x1.d9d6c4p-26, -0x1.b864a2p-53),
    FPR(0x1.4b8b18p-3, -0x1.0c0afp-32, 0x1.b534fep-57),
    FPR(0x1.f93f14p-1, 0x1.f0b58p-26, 0x1.e302eap-51),
    FPR(-0x1.f93f14p-1, -0x1.f0b58p-26, -0x1.e302eap-51),
    FPR(0x1.4b8b18p-3, -0x1.0c0afp-32, 0x1.b534fep-57),
    FPR(0x1.fb8d18p-1, 0x1.acd5b6p-26, 0x1.b17a4cp-51),
    FPR(0x1.0d64dcp-3, -0x1.a6cc3ep-30, 0x1.d1d8b6p-55),
    FPR(-0x1.0d64dcp-3, 0x1.a6cc3ep-30, -0x1.d1d8b6p-55),
    FPR(0x1.fb8d18p-1, 0x1.acd5b6p-26, 0x1.b17a4cp-51),
    FPR(0x1.374532p-1, -0x1.1fa01cp-27, -0x1.57765ap-52),
    FPR(0x1.9683f4p-1, 0x1.5ebffp-28, 0x1.ddc8a4p-54),
    FPR(-0x1.9683f4p-1, -0x1.5ebffp-28, -0x1.ddc8a4p-54),
    FPR(0x1.374532p-1, -0x1.1fa01cp-27, -0x1.57765ap-52),
    FPR(0x1.bb249ap-1, 0x1.6d881ap-30, -0x1.d6318ep-58),
    FPR(0x1.00740cp-1, 0x1.05705cp-26, 0x1.495bd4p-54),
    FPR(-0x1.00740cp-1, -0x1.05705cp-26, -0x1.495bd4p-54),
    FPR(0x1.bb249ap-1, 0x1.6d881ap-30, -0x1.d6318ep-58),
    FPR(0x1.0804ep-2, 0x1.7ad988p-28, -0x1.aac6ap-54),
    FPR(0x1.eeb074p-1, 0x1.8a14a8p-26, 0x1.1d926p-51),
    FPR(-0x1.eeb074p-1, -0x1.8a14a8p-26, -0x1.1d926p-51),
    FPR(0x1.0804ep-2, 0x1.7ad988p-28, -0x1.aac6ap-54),
    FPR(0x1.e4a8ep-1, -0x1.f8c686p-31, -0x1.7950f2p-56),
    FPR(0x1.4a253ep-2, -0x1.dc8fa2p-27, 0x1.76a82ep-53),
    FPR(-0x1.4a253ep-2, 0x1.dc8fa2p-27, -0x1.76a82ep-53),
    FPR(0x1.e4a8ep-1, -0x1.f8c686p-31, -0x1.7950f2p-56),
    FPR(0x1.c3f6d4p-2, 0x1.c98c4ap-28, 0x1.671ef4p-54),
    FPR(0x1.cb6e2p-1, 0x1.401b54p-26, -0x1.d4fb24p-51),
    FPR(-0x1.cb6e2p-1, -0x1.401b54p-26, 0x1.d4fb24p-51),
    FPR(0x1.c3f6d4p-2, 0x1.c98c4ap-28, 0x1.671ef4p-54),
    FPR(0x1.8098b8p-1, -0x1.5235ap-26, -0x1.66ec92p-51),
    FPR(0x1.51fa82p-1, -0x1.9332aep-28, 0x1.ffad98p-53),
    FPR(-0x1.51fa82p-1, 0x1.9332aep-28, -0x1.ffad98p-53),
    FPR(0x1.8098b8p-1, -0x1.5235ap-26, -0x1.66ec92p-51),
    FPR(0x1.07b614p-4, 0x1.c8c60cp-29, 0x1.d8f60ep-55),
    FPR(0x1.fef01p-1, 0x1.4130c8p-28, 0x1.2787d4p-53),
    FPR(-0x1.fef01p-1, -0x1.4130c8p-28, -0x1.2787d4p-53),
    FPR(0x1.07b614p-4, 0x1.c8c60cp-29, 0x1.d8f60ep-55),
    FPR(0x1.fe3e92p-1, 0x1.7d3b1p-26, 0x1.86bfacp-51),
    FPR(0x1.52e774p-4, 0x1.49a9a2p-29, -0x1.793448p-54),
    FPR(-0x1.52e774p-4, -0x1.49a9a2p-29, 0x1.793448p-54),
    FPR(0x1.fe3e92p-1, 0x1.7d3b1p-26, 0x1.86bfacp-51),
    FPR(0x1.4ad796p-1, -0x1.d31ba2p-26, 0x1.76c628p-54),
    FPR(0x1.86c0a2p-1, -0x1.32af36p-28, 0x1.06115ap-53),
    FPR(-0x1.86c0a2p-1, 0x1.32af36p-28, -0x1.06115ap-53),
    FPR(0x1.4ad796p-1, -0x1.d31ba2p-26, 0x1.76c628p-54),
    FPR(0x1.c73158p-1, 0x1.33d55ap-26, 0x1.b99068p-51),
    FPR(0x1.d4cd02p-2, 0x1.750c14p-27, -0x1.937f34p-53),
    FPR(-0x1.d4cd02p-2, -0x1.750c14p-27, 0x1.937f34p-53),
    FPR(0x1.c73158p-1, 0x1.33d55ap-26, 0x1.b99068p-51),
    FPR(0x1.383f5ep-2, 0x1.a9db56p-29, -0x1.6a04aap-54),
    FPR(0x1.e79db2p-1, 0x1.34a2ccp-26, -0x1.8baf38p-51),
    FPR(-0x1.e79db2p-1, -0x1.34a2ccp-26, 0x1.8baf38p-51),
    FPR(0x1.383f5ep-2, 0x1.a9db56p-29, -0x1.6a04aap-54),
    FPR(0x1.ec2cf4p-1, 0x1.635ed6p-26, 0x1.0269dcp-52),
    FPR(0x1.1a2f8p-2, -0x1.05c37p-28, 0x1.ac8cb6p-53),
    FPR(-0x1.1a2f8p-2, 0x1.05c37p-28, -0x1.ac8cb6p-53),
    FPR(0x1.ec2cf4p-1, 0x1.635ed6p-26, 0x1.0269dcp-52),
    FPR(0x1.f0819p-2, 0x1.affep-28, -0x1.299566p-53),
    FPR(0x1.bfc9d2p-1, 0x1.686c52p-27, -0x1.0151cp-53),
    FPR(-0x1.bfc9d2p-1, -0x1.686c52p-27, 0x1.0151cp-53),
    FPR(0x1.f0819p-2, 0x1.affep-28, -0x1.299566p-53),
    FPR(0x1.90b794p-1, 0x1.abaf8p-28, -0x1.eb135p-53),
    FPR(0x1.3eb33ep-1, 0x1.57c0dp-26, 0x1.86a236p-58),
    FPR(-0x1.3eb33ep-1, -0x1.57c0dp-26, -0x1.86a236p-58),
    FPR(0x1.90b794p-1, 0x1.abaf8p-28, -0x1.eb135p-53),
    FPR(0x1.cff534p-4, -0x1.33e09p-30, 0x1.31fdd8p-56),
    FPR(0x1.fcb47p-1, 0x1.c8a1aap-28, 0x1.126aa8p-55),
    FPR(-0x1.fcb47p-1, -0x1.c8a1aap-28, -0x1.126aa8p-55),
    FPR(0x1.cff534p-4, -0x1.33e09p-30, 0x1.31fdd8p-56),
    FPR(0x1.f7a29ap-1, -0x1.f2e6eap-28, -0x1.d231cep-53),
    FPR(0x1.70afd8p-3, 0x1.a118ap-28, -0x1.6cf9ep-56),
    FPR(-0x1.70afd8p-3, -0x1.a118ap-28, 0x1.6cf9ep-56),
    FPR(0x1.f7a29ap-1, -0x1.f2e6eap-28, -0x1.d231cep-53),
    FPR(0x1.22f2d6p-1, 0x1.8b04f8p-27, 0x1.8a8ce2p-53),
    FPR(0x1.a54c92p-1, -0x1.ede15cp-26, 0x1.91843p-52),
    FPR(-0x1.a54c92p-1, 0x1.ede15cp-26, -0x1.91843p-52),
    FPR(0x1.22f2d6p-1, 0x1.8b04f8p-27, 0x1.8a8ce2p-53),
    FPR(0x1.ae069p-1, -0x1.974262p-26, -0x1.26726ap-53),
    FPR(0x1.15e36ep-1, 0x1.36f8bp-27, -0x1.ec3abap-52),
    FPR(-0x1.15e36ep-1, -0x1.36f8bp-27, 0x1.ec3abap-52),
    FPR(0x1.ae069p-1, -0x1.974262p-26, -0x1.26726ap-53),
    FPR(0x1.ae4f1ep-3, -0x1.4188cap-28, -0x1.255744p-53),
    FPR(0x1.f4922p-1, 0x1.af2aeep-27, -0x1.c5c2dcp-52),
    FPR(-0x1.f4922p-1, -0x1.af2aeep-27, 0x1.c5c2dcp-52),
    FPR(0x1.ae4f1ep-3, -0x1.4188cap-28, -0x1.255744p-53),
    FPR(0x1.dbf9e4p-1, 0x1.cabacep-28, -0x1.89c024p-53),
    FPR(0x1.794f5ep-2, 0x1.84f7ecp-28, -0x1.cfbeb6p-54),
    FPR(-0x1.794f5ep-2, -0x1.84f7ecp-28, 0x1.cfbeb6p-54),
    FPR(0x1.dbf9e4p-1, 0x1.cabacep-28, -0x1.89c024p-53),
    FPR(0x1.96555cp-2, -0x1.0a8d6ep-27, -0x1.428158p-55),
    FPR(0x1.d5f718p-1, -0x1.aeeebp-26, -0x1.5a199p-53),
    FPR(-0x1.d5f718p-1, 0x1.aeeebp-26, 0x1.5a199p-53),
    FPR(0x1.96555cp-2, -0x1.0a8d6ep-27, -0x1.428158p-55),
    FPR(0x1.6f8caap-1, -0x1.8da922p-27, -0x1.60dd18p-52),
    FPR(0x1.647154p-1, 0x1.bfa9aep-28, -0x1.5f0e68p-53),
    FPR(-0x1.647154p-1, -0x1.bfa9aep-28, 0x1.5f0e68p-53),
    FPR(0x1.6f8caap-1, -0x1.8da922p-27, -0x1.60dd18p-52),
    FPR(0x1.f6a296p-7, 0x1.5732fap-32, -0x1.5f2944p-57),
    FPR(0x1.fff094p-1, 0x1.e29de8p-28, 0x1.5c633p-54),
    FPR(-0x1.fff094p-1, -0x1.e29de8p-28, -0x1.5c633p-54),
    FPR(0x1.f6a296p-7, 0x1.5732fap-32, -0x1.5f2944p-57),
    FPR(0x1.ffe1c6p-1, 0x1.0e196ep-26, 0x1.d89aa2p-51),
    FPR(0x1.5fd4d2p-6, 0x1.fab226p-34, -0x1.0c0a92p-61),
    FPR(-0x1.5fd4d2p-6, -0x1.fab226p-34, 0x1.0c0a92p-61),
    FPR(0x1.ffe1c6p-1, 0x1.0e196ep-26, 0x1.d89aa2p-51),
    FPR(0x1.622e44p-1, 0x1.fd846p-26, -0x1.819c9ep-54),
    FPR(0x1.71bacap-1, -0x1.3e37c8p-26, -0x1.370b1cp-53),
    FPR(-0x1.71bacap-1, 0x1.3e37c8p-26, 0x1.370b1cp-53),
    FPR(0x1.622e44p-1, 0x1.fd846p-26, -0x1.819c9ep-54),
    FPR(0x1.d4b5b2p-1, -0x1.39e2b8p-27, 0x1.f054ap-52),
    FPR(0x1.9c17d4p-2, 0x1.037e7cp-28, 0x1.1923c6p-53),
    FPR(-0x1.9c17d4p-2, -0x1.037e7cp-28, -0x1.1923c6p-53),
    FPR(0x1.d4b5b2p-1, -0x1.39e2b8p-27, 0x1.f054ap-52),
    FPR(0x1.73763cp-2, 0x1.24c212p-27, 0x1.d5b9b6p-54),
    FPR(0x1.dd1ffp-1, -0x1.8eadd4p-26, -0x1.9782f2p-51),
    FPR(-0x1.dd1ffp-1, 0x1.8eadd4p-26, 0x1.9782f2p-51),
    FPR(0x1.73763cp-2, 0x1.24c212p-27, 0x1.d5b9b6p-54),
    FPR(0x1.f3e6bcp-1, -0x1.f221cep-28, 0x1.15774cp-53),
    FPR(0x1.ba9634p-3, -0x1.61d44ap-28, -0x1.aea132p-54),
    FPR(-0x1.ba9634p-3, 0x1.61d44ap-28, 0x1.aea132p-54),
    FPR(0x1.f3e6bcp-1, -0x1.f221cep-28, 0x1.15774cp-53),
    FPR(0x1.133e9cp-1, 0x1.fdc4aap-26, -0x1.3426fp-53),
    FPR(0x1.afb8fep-1, -0x1.d82a12p-27, -0x1.fdc626p-53),
    FPR(-0x1.afb8fep-1, 0x1.d82a12p-27, 0x1.fdc626p-53),
    FPR(0x1.133e9cp-1, 0x1.fdc4aap-26, -0x1.3426fp-53),
    FPR(0x1.a38184p-1, 0x1.4b2778p-26, 0x1.6436d4p-51),
    FPR(0x1.258734p-1, 0x1.976e22p-26, 0x1.3a3f0ap-57),
    FPR(-0x1.258734p-1, -0x1.976e22p-26, -0x1.3a3f0ap-57),
    FPR(0x1.a38184p-1, 0x1.4b2778p-26, 0x1.6436d4p-51),
    FPR(0x1.6451a8p-3, 0x1.8ec186p-30, 0x1.35a2cp-55),
    FPR(0x1.f830f4p-1, 0x1.4818c2p-26, -0x1.f3d6bcp-52),
    FPR(-0x1.f830f4p-1, -0x1.4818c2p-26, 0x1.f3d6bcp-52),
    FPR(0x1.6451a8p-3, 0x1.8ec186p-30, 0x1.35a2cp-55),
    FPR(0x1.fc56e4p-1, -0x1.209942p-27, -0x1.103ff8p-52),
    FPR(0x1.e8eb8p-4, -0x1.0daaep-31, -0x1.48dd64p-56),
    FPR(-0x1.e8eb8p-4, 0x1.0daaep-31, 0x1.48dd64p-56),
    FPR(0x1.fc56e4p-1, -0x1.209942p-27, -0x1.103ff8p-52),
    FPR(0x1.3c3c44p-1, 0x1.3038a2p-26, 0x1.e4a166p-51),
    FPR(0x1.92aa42p-1, -0x1.d2bf58p-32, -0x1.68f89ep-57),
    FPR(-0x1.92aa42p-1, 0x1.d2bf58p-32, 0x1.68f89ep-57),
    FPR(0x1.3c3c44p-1, 0x1.3038a2p-26, 0x1.e4a166p-51),
    FPR(0x1.be41b6p-1, 0x1.1154cp-29, 0x1.01192ap-54),
    FPR(0x1.f5fdeep-2, 0x1.95b368p-28, 0x1.742034p-53),
    FPR(-0x1.f5fdeep-2, -0x1.95b368p-28, -0x1.742034p-53),
    FPR(0x1.be41b6p-1, 0x1.1154cp-29, 0x1.01192ap-54),
    FPR(0x1.1423eep-2, 0x1.f8d27p-27, -0x1.edd2ccp-52),
    FPR(0x1.ed0836p-1, -0x1.666ff6p-29, -0x1.d6cc5cp-54),
    FPR(-0x1.ed0836p-1, 0x1.666ff6p-29, 0x1.d6cc5cp-54),
    FPR(0x1.1423eep-2, 0x1.f8d27p-27, -0x1.edd2ccp-52),
    FPR(0x1.e6a61cp-1, 0x1.5754eap-27, -0x1.a67c9ap-54),
    FPR(0x1.3e39bep-2, 0x1.2dd84ep-27, 0x1.60531cp-54),
    FPR(-0x1.3e39bep-2, -0x1.2dd84ep-27, -0x1.60531cp-54),
    FPR(0x1.e6a61cp-1, 0x1.5754eap-27, -0x1.a67c9ap-54),
    FPR(0x1.cf34bap-2, 0x1.dc39a4p-27, 0x1.773c6ep-55),
    FPR(0x1.c89f58p-1, 0x1.c0a704p-27, 0x1.85620ep-52),
    FPR(-0x1.c89f58p-1, -0x1.c0a704p-27, -0x1.85620ep-52),
    FPR(0x1.cf34bap-2, 0x1.dc39a4p-27, 0x1.773c6ep-55),
    FPR(0x1.84b712p-1, -0x1.ca0f8p-26, -0x1.963a48p-51),
    FPR(0x1.4d3bc6p-1, 0x1.ab13fp-26, -0x1.48d932p-54),
    FPR(-0x1.4d3bc6p-1, -0x1.ab13fp-26, 0x1.48d932p-54),
    FPR(0x1.84b712p-1, -0x1.ca0f8p-26, -0x1.963a48p-51),
    FPR(0x1.39d9f2p-4, -0x1.a74bacp-29, -0x1.beed78p-54),
    FPR(0x1.fe7ea8p-1, 0x1.520b58p-27, 0x1.34b086p-56),
    FPR(-0x1.fe7ea8p-1, -0x1.520b58p-27, -0x1.34b086p-56),
    FPR(0x1.39d9f2p-4, -0x1.a74bacp-29, -0x1.beed78p-54),
    FPR(0x1.feb9d2p-1, 0x1.4c1044p-27, -0x1.e62bd6p-54),
    FPR(0x1.20c968p-4, -0x1.625776p-29, -0x1.bf3a92p-55),
    FPR(-0x1.20c968p-4, 0x1.625776p-29, 0x1.bf3a92p-55),
    FPR(0x1.feb9d2p-1, 0x1.4c1044p-27, -0x1.e62bd6p-54),
    FPR(0x1.4f9cc2p-1, 0x1.732922p-27, -0x1.add29ap-53),
    FPR(0x1.82a9c2p-1, -0x1.81574p-26, -0x1.2cbd1p-53),
    FPR(-0x1.82a9c2p-1, 0x1.81574p-26, 0x1.2cbd1p-53),
    FPR(0x1.4f9cc2p-1, 0x1.732922p-27, -0x1.add29ap-53),
    FPR(0x1.ca08f2p-1, -0x1.918eeep-27, 0x1.af387ep-54),
    FPR(0x1.c997fcp-2, 0x1.c329c4p-29, 0x1.4eb504p-55),
    FPR(-0x1.c997fcp-2, -0x1.c329c4p-29, -0x1.4eb504p-55),
    FPR(0x1.ca08f2p-1, -0x1.918eeep-27, 0x1.af387ep-54),
    FPR(0x1.44310ep-2, -0x1.bb6488p-29, 0x1.8b694ep-56),
    FPR(0x1.e5a9d6p-1, -0x1.5f7306p-26, 0x1.97d432p-52),
    FPR(-0x1.e5a9d6p-1, 0x1.5f7306p-26, -0x1.97d432p-52),
    FPR(0x1.44310ep-2, -0x1.bb6488p-29, 0x1.8b694ep-56),
    FPR(0x1.eddeb6p-1, 0x1.40f0cap-26, 0x1.625432p-54),
    FPR(0x1.0e15b4p-2, 0x1.c2e93ap-27, -0x1.2b6ff6p-53),
    FPR(-0x1.0e15b4p-2, -0x1.c2e93ap-27, 0x1.2b6ff6p-53),
    FPR(0x1.eddeb6p-1, 0x1.40f0cap-26, 0x1.625432p-54),
    FPR(0x1.fb7576p-2, -0x1.ed9692p-29, 0x1.d48046p-54),
    FPR(0x1.bcb54cp-1, 0x1.61a464p-26, 0x1.c02822p-51),
    FPR(-0x1.bcb54cp-1, -0x1.61a464p-26, -0x1.c02822p-51),
    FPR(0x1.fb7576p-2, -0x1.ed9692p-29, 0x1.d48046p-54),
    FPR(0x1.94990ep-1, 0x1.d62536p-28, 0x1.a95328p-56),
    FPR(0x1.39c23ep-1, 0x1.eb1814p-28, 0x1.ec4fa4p-54),
    FPR(-0x1.39c23ep-1, -0x1.eb1814p-28, -0x1.ec4fa4p-54),
    FPR(0x1.94990ep-1, 0x1.d62536p-28, 0x1.a95328p-56),
    FPR(0x1.00ee8ap-3, 0x1.adf70cp-28, -0x1.34c60ap-53),
    FPR(0x1.fbf47p-1, 0x1.e151bp-26, 0x1.e944ep-51),
    FPR(-0x1.fbf47p-1, -0x1.e151bp-26, -0x1.e944ep-51),
    FPR(0x1.00ee8ap-3, 0x1.adf70cp-28, -0x1.34c60ap-53),
    FPR(0x1.f8ba74p-1, -0x1.069692p-26, 0x1.e258ep-51),
    FPR(0x1.57f008p-3, 0x1.9532f8p-29, -0x1.cdee6ep-55),
    FPR(-0x1.57f008p-3, -0x1.9532f8p-29, 0x1.cdee6ep-55),
    FPR(0x1.f8ba74p-1, -0x1.069692p-26, 0x1.e258ep-51),
    FPR(0x1.2818bep-1, 0x1.e9a798p-26, -0x1.8f2p-51),
    FPR(0x1.a1b26ep-1, -0x1.a7eb14p-26, -0x1.ecf10cp-53),
    FPR(-0x1.a1b26ep-1, 0x1.a7eb14p-26, 0x1.ecf10cp-53),
    FPR(0x1.2818bep-1, 0x1.e9a798p-26, -0x1.8f2p-51),
    FPR(0x1.b16742p-1, 0x1.49945ep-26, 0x1.2458f6p-51),
    FPR(0x1.109724p-1, 0x1.1a152ap-26, 0x1.a85a78p-51),
    FPR(-0x1.109724p-1, -0x1.1a152ap-26, -0x1.a85a78p-51),
    FPR(0x1.b16742p-1, 0x1.49945ep-26, 0x1.2458f6p-51),
    FPR(0x1.c6d906p-3, -0x1.945164p-28, -0x1.8dfd96p-54),
    FPR(0x1.f33686p-1, -0x1.715444p-27, 0x1.eb7868p-56),
    FPR(-0x1.f33686p-1, 0x1.715444p-27, -0x1.eb7868p-56),
    FPR(0x1.c6d906p-3, -0x1.945164p-28, -0x1.8dfd96p-54),
    FPR(0x1.de416p-1, 0x1.edb1bp-26, 0x1.66fc48p-53),
    FPR(0x1.6d9986p-2, 0x1.c5065ap-29, 0x1.fdc6bep-54),
    FPR(-0x1.6d9986p-2, -0x1.c5065ap-29, -0x1.fdc6bep-54),
    FPR(0x1.de416p-1, 0x1.edb1bp-26, 0x1.66fc48p-53),
    FPR(0x1.a1d654p-2, 0x1.da856p-29, -0x1.0246dp-57),
    FPR(0x1.d36fc8p-1, -0x1.0d010ap-27, 0x1.c8bcd2p-52),
    FPR(-0x1.d36fc8p-1, 0x1.0d010ap-27, -0x1.c8bcd2p-52),
    FPR(0x1.a1d654p-2, 0x1.da856p-29, -0x1.0246dp-57),
    FPR(0x1.73e558p-1, 0x1.c0f328p-26, 0x1.b6673cp-53),
    FPR(0x1.5fe7ccp-1, -0x1.0d4af8p-28, -0x1.fcb9ccp-55),
    FPR(-0x1.5fe7ccp-1, 0x1.0d4af8p-28, 0x1.fcb9ccp-55),
    FPR(0x1.73e558p-1, 0x1.c0f328p-26, 0x1.b6673cp-53),
    FPR(0x1.c454f4p-6, 0x1.9ca764p-31, -0x1.bac7bp-57),
    FPR(0x1.ffce0ap-1, -0x1.8eacc4p-28, 0x1.4214eap-54),
    FPR(-0x1.ffce0ap-1, 0x1.8eacc4p-28, -0x1.4214eap-54),
    FPR(0x1.c454f4p-6, 0x1.9ca764p-31, -0x1.bac7bp-57),
    FPR(0x1.ff753cp-1, -0x1.391ba8p-27, 0x1.e83cdp-52),
    FPR(0x1.78dbaap-5, 0x1.61d1a2p-31, -0x1.14a0fp-56),
    FPR(-0x1.78dbaap-5, -0x1.61d1a2p-31, 0x1.14a0fp-56),
    FPR(0x1.ff753cp-1, -0x1.391ba8p-27, 0x1.e83cdp-52),
    FPR(0x1.59001ep-1, -0x1.411b84p-26, -0x1.9581e6p-54),
    FPR(0x1.7a4f7p-1, 0x1.efe5f4p-27, 0x1.2792eap-52),
    FPR(-0x1.7a4f7p-1, -0x1.efe5f4p-27, -0x1.2792eap-52),
    FPR(0x1.59001ep-1, -0x1.411b84p-26, -0x1.9581e6p-54),
    FPR(0x1.cf830ep-1, 0x1.19c8dp-26, -0x1.57b92p-51),
    FPR(0x1.b2f972p-2, -0x1.267346p-29, -0x1.815a3ap-54),
    FPR(-0x1.b2f972p-2, 0x1.267346p-29, 0x1.815a3ap-54),
    FPR(0x1.cf830ep-1, 0x1.19c8dp-26, -0x1.57b92p-51),
    FPR(0x1.5bee78p-2, 0x1.73b676p-27, 0x1.879cd2p-52),
    FPR(0x1.e18a02p-1, 0x1.fb8cdcp-26, -0x1.af81d8p-51),
    FPR(-0x1.e18a02p-1, -0x1.fb8cdcp-26, 0x1.af81d8p-51),
    FPR(0x1.5bee78p-2, 0x1.73b676p-27, 0x1.879cd2p-52),
    FPR(0x1.f1090cp-1, -0x1.bb385p-28, -0x1.6ea992p-53),
    FPR(0x1.eb86b4p-3, 0x1.8b78d2p-29, -0x1.bfcde4p-57),
    FPR(-0x1.eb86b4p-3, -0x1.8b78d2p-29, 0x1.bfcde4p-57),
    FPR(0x1.f1090cp-1, -0x1.bb385p-28, -0x1.6ea992p-53),
    FPR(0x1.089112p-1, 0x1.95846p-32, 0x1.3248dep-57),
    FPR(0x1.b658f2p-1, -0x1.604878p-26, 0x1.c54ad4p-51),
    FPR(-0x1.b658f2p-1, 0x1.604878p-26, -0x1.c54ad4p-51),
    FPR(0x1.089112p-1, 0x1.95846p-32, 0x1.3248dep-57),
    FPR(0x1.9c2d12p-1, -0x1.e1f148p-26, 0x1.3b393ep-52),
    FPR(0x1.2fbc24p-1, 0x1.688202p-26, 0x1.476e92p-51),
    FPR(-0x1.2fbc24p-1, -0x1.688202p-26, -0x1.476e92p-51),
    FPR(0x1.9c2d12p-1, -0x1.e1f148p-26, 0x1.3b393ep-52),
    FPR(0x1.32b7cp-3, -0x1.aeba56p-29, -0x1.6aed8ep-56),
    FPR(0x1.fa39bap-1, 0x1.8f42f2p-26, 0x1.cd618ep-54),
    FPR(-0x1.fa39bap-1, -0x1.8f42f2p-26, -0x1.cd618ep-54),
    FPR(0x1.32b7cp-3, -0x1.aeba56p-29, -0x1.6aed8ep-56),
    FPR(0x1.faafbcp-1, 0x1.619fbcp-26, -0x1.1e349cp-51),
    FPR(0x1.264994p-3, 0x1.bfa682p-28, -0x1.a58bb4p-53),
    FPR(-0x1.264994p-3, -0x1.bfa682p-28, 0x1.a58bb4p-53),
    FPR(0x1.faafbcp-1, 0x1.619fbcp-26, -0x1.1e349cp-51),
    FPR(0x1.32421ep-1, 0x1.8934c4p-26, -0x1.4d0ed2p-54),
    FPR(0x1.9a4dfap-1, 0x1.0ac1acp-27, 0x1.cfac92p-53),
    FPR(-0x1.9a4dfap-1, -0x1.0ac1acp-27, -0x1.cfac92p-53),
    FPR(0x1.32421ep-1, 0x1.8934c4p-26, -0x1.4d0ed2p-54),
    FPR(0x1.b7f668p-1, 0x1.b9e4bap-27, 0x1.61d996p-53),
    FPR(0x1.05df3ep-1, 0x1.863716p-26, 0x1.b8748ep-51),
    FPR(-0x1.05df3ep-1, -0x1.863716p-26, -0x1.b8748ep-51),
    FPR(0x1.b7f668p-1, 0x1.b9e4bap-27, 0x1.61d996p-53),
    FPR(0x1.f7b748p-3, 0x1.7a7004p-32, -0x1.9a96dap-57),
    FPR(0x1.f045a2p-1, -0x1.66118ep-26, -0x1.1a52c4p-51),
    FPR(-0x1.f045a2p-1, 0x1.66118ep-26, 0x1.1a52c4p-51),
    FPR(0x1.f7b748p-3, 0x1.7a7004p-32, -0x1.9a96dap-57),
    FPR(0x1.e298f4p-1, 0x1.0e465ep-27, 0x1.0f4274p-52),
    FPR(0x1.560402p-2, -0x1.a1730ap-27, 0x1.1a0e0cp-52),
    FPR(-0x1.560402p-2, 0x1.a1730ap-27, -0x1.1a0e0cp-52),
    FPR(0x1.e298f4p-1, 0x1.0e465ep-27, 0x1.0f4274p-52),
    FPR(0x1.b8a782p-2, -0x1.60552ep-27, 0x1.b353ccp-53),
    FPR(0x1.ce2b32p-1, 0x1.e66818p-27, -0x1.631d46p-56),
    FPR(-0x1.ce2b32p-1, -0x1.e66818p-27, 0x1.631d46p-56),
    FPR(0x1.b8a782p-2, -0x1.60552ep-27, 0x1.b353ccp-53),
    FPR(0x1.7c6b8ap-1, -0x1.8e9666p-28, -0x1.39fac6p-53),
    FPR(0x1.56ac36p-1, -0x1.cd136cp-26, -0x1.7de1dp-53),
    FPR(-0x1.56ac36p-1, 0x1.cd136cp-26, 0x1.7de1dp-53),
    FPR(0x1.7c6b8ap-1, -0x1.8e9666p-28, -0x1.39fac6p-53),
    FPR(0x1.ab101cp-5, -0x1.503e74p-32, -0x1.597186p-57),
    FPR(0x1.ff4dc6p-1, -0x1.69c826p-26, 0x1.47dd2cp-52),
    FPR(-0x1.ff4dc6p-1, 0x1.69c826p-26, -0x1.47dd2cp-52),
    FPR(0x1.ab101cp-5, -0x1.503e74p-32, -0x1.597186p-57),
    FPR(0x1.fdafa8p-1, -0x1.5d758ep-26, -0x1.fc4d08p-52),
    FPR(0x1.84f872p-4, -0x1.a7d9ecp-29, 0x1.0cec8ap-57),
    FPR(-0x1.84f872p-4, 0x1.a7d9ecp-29, -0x1.0cec8ap-57),
    FPR(0x1.fdafa8p-1, -0x1.5d758ep-26, -0x1.fc4d08p-52),
    FPR(0x1.4605a6p-1, 0x1.256654p-26, 0x1.243944p-52),
    FPR(0x1.8ac872p-1, -0x1.21e278p-29, -0x1.9afaa6p-55),
    FPR(-0x1.8ac872p-1, 0x1.21e278p-29, 0x1.9afaa6p-55),
    FPR(0x1.4605a6p-1, 0x1.256654p-26, 0x1.243944p-52),
    FPR(0x1.c44834p-1, -0x1.d7c8p-26, 0x1.091f02p-51),
    FPR(0x1.dfeff6p-2, 0x1.aa5078p-28, -0x1.34ead8p-53),
    FPR(-0x1.dfeff6p-2, -0x1.aa5078p-28, 0x1.34ead8p-53),
    FPR(0x1.c44834p-1, -0x1.d7c8p-26, 0x1.091f02p-51),
    FPR(0x1.2c41a4p-2, 0x1.d2a8a4p-27, 0x1.9cf036p-56),
    FPR(0x1.e97ec4p-1, -0x1.3fd29ap-26, 0x1.5bc486p-55),
    FPR(-0x1.e97ec4p-1, 0x1.3fd29ap-26, -0x1.5bc486p-55),
    FPR(0x1.2c41a4p-2, 0x1.d2a8a4p-27, 0x1.9cf036p-56),
    FPR(0x1.ea683ap-1, -0x1.8335p-26, -0x1.46725ap-56),
    FPR(0x1.263e6ap-2, -0x1.aaaad2p-28, 0x1.23a6a2p-53),
    FPR(-0x1.263e6ap-2, 0x1.aaaad2p-28, -0x1.23a6a2p-53),
    FPR(0x1.ea683ap-1, -0x1.8335p-26, -0x1.46725ap-56),
    FPR(0x1.e57a86p-2, 0x1.a79b04p-27, 0x1.369bfap-52),
    FPR(0x1.c2cd14p-1, 0x1.263c7ep-26, 0x1.259c6p-53),
    FPR(-0x1.c2cd14p-1, -0x1.263c7ep-26, -0x1.259c6p-53),
    FPR(0x1.e57a86p-2, 0x1.a79b04p-27, 0x1.369bfap-52),
    FPR(0x1.8cc6a8p-1, -0x1.5cf736p-26, 0x1.21e74cp-51),
    FPR(0x1.4397f6p-1, -0x1.356f2p-27, -0x1.7274cap-55),
    FPR(-0x1.4397f6p-1, 0x1.356f2p-27, 0x1.7274cap-55),
    FPR(0x1.8cc6a8p-1, -0x1.5cf736p-26, 0x1.21e74cp-51),
    FPR(0x1.9dfb6ep-4, 0x1.64950cp-29, -0x1.e1694cp-55),
    FPR(0x1.fd60d2p-1, 0x1.b4eb94p-26, -0x1.f6490ap-53),
    FPR(-0x1.fd60d2p-1, -0x1.b4eb94p-26, 0x1.f6490ap-53),
    FPR(0x1.9dfb6ep-4, 0x1.64950cp-29, -0x1.e1694cp-55),
    FPR(0x1.f67756p-1, -0x1.2ef862p-26, -0x1.e1096ap-53),
    FPR(0x1.896172p-3, 0x1.f10602p-29, -0x1.ec0254p-54),
    FPR(-0x1.896172p-3, -0x1.f10602p-29, 0x1.ec0254p-54),
    FPR(0x1.f67756p-1, -0x1.2ef862p-26, -0x1.e1096ap-53),
    FPR(0x1.1dc1b6p-1, 0x1.37121cp-27, 0x1.0f8afp-52),
    FPR(0x1.a8d676p-1, 0x1.ca8b5ap-26, 0x1.f93b88p-53),
    FPR(-0x1.a8d676p-1, -0x1.ca8b5ap-26, -0x1.f93b88p-53),
    FPR(0x1.1dc1b6p-1, 0x1.37121cp-27, 0x1.0f8afp-52),
    FPR(0x1.aa9548p-1, -0x1.74d19cp-27, -0x1.fcf06p-53),
    FPR(0x1.1b2502p-1, -0x1.1d9188p-26, -0x1.6c843ap-53),
    FPR(-0x1.1b2502p-1, 0x1.1d9188p-26, 0x1.6c843ap-53),
    FPR(0x1.aa9548p-1, -0x1.74d19cp-27, -0x1.fcf06p-53),
    FPR(0x1.95b49ep-3, 0x1.36c56p-28, -0x1.84402cp-53),
    FPR(0x1.f5da6ep-1, 0x1.a86d0cp-26, -0x1.aa6df8p-52),
    FPR(-0x1.f5da6ep-1, -0x1.a86d0cp-26, 0x1.aa6df8p-52),
    FPR(0x1.95b49ep-3, 0x1.36c56p-28, -0x1.84402cp-53),
    FPR(0x1.d9a00ep-1, -0x1.3a615cp-28, -0x1.f20af8p-53),
    FPR(0x1.84f6aap-2, 0x1.5e7208p-27, -0x1.a48c9p-55),
    FPR(-0x1.84f6aap-2, -0x1.5e7208p-27, 0x1.a48c9p-55),
    FPR(0x1.d9a00ep-1, -0x1.3a615cp-28, -0x1.f20af8p-53),
    FPR(0x1.8ac4b8p-2, 0x1.b57b52p-28, -0x1.dd00bp-53),
    FPR(0x1.d86c48p-1, 0x1.116914p-27, -0x1.0bbf62p-54),
    FPR(-0x1.d86c48p-1, -0x1.116914p-27, 0x1.0bbf62p-54),
    FPR(0x1.8ac4b8p-2, 0x1.b57b52p-28, -0x1.dd00bp-53),
    FPR(0x1.6b25cep-1, 0x1.a5fc54p-26, -0x1.15ac64p-51),
    FPR(0x1.68ed1ep-1, 0x1.54338ep-26, 0x1.3fa95p-53),
    FPR(-0x1.68ed1ep-1, -0x1.54338ep-26, -0x1.3fa95p-53),
    FPR(0x1.6b25cep-1, 0x1.a5fc54p-26, -0x1.15ac64p-51),
    FPR(0x1.921f8cp-9, -0x1.335b46p-37, 0x1.2ba408p-63),
    FPR(0x1.ffff62p-1, 0x1.621d02p-29, -0x1.6acfcep-56),
    FPR(-0x1.ffff62p-1, -0x1.621d02p-29, 0x1.6acfcep-56),
    FPR(0x1.921f8cp-9, -0x1.335b46p-37, 0x1.2ba408p-63)
};

#else
/* If rev() is the bit-reversal function over 10 bits, then,
   for k = 1 to 1023:
     GM[2*k + 0] = cos(k*pi/1024)
     GM[2*k + 1] = sin(k*pi/1024)
   All values have been computed with Sage with enough precision to get
   properly rounding values. GM[0] and GM[1] are not used. */
static const fpr GM[] = {
	FPR_ZERO, FPR_ZERO,
	FPR_NZERO, FPR_ONE,
	FPR(   6369051672525773, -53), FPR(   6369051672525773, -53),
	FPR(  -6369051672525773, -53), FPR(   6369051672525773, -53),
	FPR(   8321567036706118, -53), FPR(   6893811853601123, -54),
	FPR(  -6893811853601123, -54), FPR(   8321567036706118, -53),
	FPR(   6893811853601123, -54), FPR(   8321567036706118, -53),
	FPR(  -8321567036706118, -53), FPR(   6893811853601123, -54),
	FPR(   8834128446708912, -53), FPR(   7028869612283403, -55),
	FPR(  -7028869612283403, -55), FPR(   8834128446708912, -53),
	FPR(   5004131788810440, -53), FPR(   7489212472271267, -53),
	FPR(  -7489212472271267, -53), FPR(   5004131788810440, -53),
	FPR(   7489212472271267, -53), FPR(   5004131788810440, -53),
	FPR(  -5004131788810440, -53), FPR(   7489212472271267, -53),
	FPR(   7028869612283403, -55), FPR(   8834128446708912, -53),
	FPR(  -8834128446708912, -53), FPR(   7028869612283403, -55),
	FPR(   8963827128411430, -53), FPR(   7062879306626092, -56),
	FPR(  -7062879306626092, -56), FPR(   8963827128411430, -53),
	FPR(   5714106716331478, -53), FPR(   6962659179435841, -53),
	FPR(  -6962659179435841, -53), FPR(   5714106716331478, -53),
	FPR(   7943640554978737, -53), FPR(   8491928673252923, -54),
	FPR(  -8491928673252923, -54), FPR(   7943640554978737, -53),
	FPR(   5229303857258246, -54), FPR(   8619352278838746, -53),
	FPR(  -8619352278838746, -53), FPR(   5229303857258246, -54),
	FPR(   8619352278838746, -53), FPR(   5229303857258246, -54),
	FPR(  -5229303857258246, -54), FPR(   8619352278838746, -53),
	FPR(   8491928673252923, -54), FPR(   7943640554978737, -53),
	FPR(  -7943640554978737, -53), FPR(   8491928673252923, -54),
	FPR(   6962659179435841, -53), FPR(   5714106716331478, -53),
	FPR(  -5714106716331478, -53), FPR(   6962659179435841, -53),
	FPR(   7062879306626092, -56), FPR(   8963827128411430, -53),
	FPR(  -8963827128411430, -53), FPR(   7062879306626092, -56),
	FPR(   8996349688769918, -53), FPR(   7071397114140692, -57),
	FPR(  -7071397114140692, -57), FPR(   8996349688769918, -53),
	FPR(   6048865317612704, -53), FPR(   6673894424096687, -53),
	FPR(  -6673894424096687, -53), FPR(   6048865317612704, -53),
	FPR(   8142411687315315, -53), FPR(   7702147837811904, -54),
	FPR(  -7702147837811904, -54), FPR(   8142411687315315, -53),
	FPR(   6068868072808413, -54), FPR(   8480675002222309, -53),
	FPR(  -8480675002222309, -53), FPR(   6068868072808413, -54),
	FPR(   8737264780849367, -53), FPR(   8754283581366043, -55),
	FPR(  -8754283581366043, -55), FPR(   8737264780849367, -53),
	FPR(   4630625854357486, -53), FPR(   7725732496764478, -53),
	FPR(  -7725732496764478, -53), FPR(   4630625854357486, -53),
	FPR(   7234650278954817, -53), FPR(   5365582331473973, -53),
	FPR(  -5365582331473973, -53), FPR(   7234650278954817, -53),
	FPR(   5286522480648506, -55), FPR(   8909709923362071, -53),
	FPR(  -8909709923362071, -53), FPR(   5286522480648506, -55),
	FPR(   8909709923362071, -53), FPR(   5286522480648506, -55),
	FPR(  -5286522480648506, -55), FPR(   8909709923362071, -53),
	FPR(   5365582331473973, -53), FPR(   7234650278954817, -53),
	FPR(  -7234650278954817, -53), FPR(   5365582331473973, -53),
	FPR(   7725732496764478, -53), FPR(   4630625854357486, -53),
	FPR(  -4630625854357486, -53), FPR(   7725732496764478, -53),
	FPR(   8754283581366043, -55), FPR(   8737264780849367, -53),
	FPR(  -8737264780849367, -53), FPR(   8754283581366043, -55),
	FPR(   8480675002222309, -53), FPR(   6068868072808413, -54),
	FPR(  -6068868072808413, -54), FPR(   8480675002222309, -53),
	FPR(   7702147837811904, -54), FPR(   8142411687315315, -53),
	FPR(  -8142411687315315, -53), FPR(   7702147837811904, -54),
	FPR(   6673894424096687, -53), FPR(   6048865317612704, -53),
	FPR(  -6048865317612704, -53), FPR(   6673894424096687, -53),
	FPR(   7071397114140692, -57), FPR(   8996349688769918, -53),
	FPR(  -8996349688769918, -53), FPR(   7071397114140692, -57),
	FPR(   9004486454725901, -53), FPR(   7073527528384126, -58),
	FPR(  -7073527528384126, -58), FPR(   9004486454725901, -53),
	FPR(   6210829080669407, -53), FPR(   6523437785808790, -53),
	FPR(  -6523437785808790, -53), FPR(   6210829080669407, -53),
	FPR(   8234469430249786, -53), FPR(   7300178522992010, -54),
	FPR(  -7300178522992010, -54), FPR(   8234469430249786, -53),
	FPR(   6483292609725855, -54), FPR(   8403652042342972, -53),
	FPR(  -8403652042342972, -53), FPR(   6483292609725855, -54),
	FPR(   8788343498532233, -53), FPR(   7893954108215139, -55),
	FPR(  -7893954108215139, -55), FPR(   8788343498532233, -53),
	FPR(   4818830163135267, -53), FPR(   7609764403282432, -53),
	FPR(  -7609764403282432, -53), FPR(   4818830163135267, -53),
	FPR(   7364149319706498, -53), FPR(   5186419112612575, -53),
	FPR(  -5186419112612575, -53), FPR(   7364149319706498, -53),
	FPR(   6159551188123590, -55), FPR(   8874592046238633, -53),
	FPR(  -8874592046238633, -53), FPR(   6159551188123590, -55),
	FPR(   8939460924383187, -53), FPR(   8820618739413774, -56),
	FPR(  -8820618739413774, -56), FPR(   8939460924383187, -53),
	FPR(   5541513524170937, -53), FPR(   7100793355396091, -53),
	FPR(  -7100793355396091, -53), FPR(   5541513524170937, -53),
	FPR(   7837046897874218, -53), FPR(   8879264459430586, -54),
	FPR(  -8879264459430586, -54), FPR(   7837046897874218, -53),
	FPR(   4804669900715639, -54), FPR(   8680923061569891, -53),
	FPR(  -8680923061569891, -53), FPR(   4804669900715639, -54),
	FPR(   8552589520593170, -53), FPR(   5650787876693505, -54),
	FPR(  -5650787876693505, -54), FPR(   8552589520593170, -53),
	FPR(   8099477666776158, -54), FPR(   8045449260044789, -53),
	FPR(  -8045449260044789, -53), FPR(   8099477666776158, -54),
	FPR(   6820330957936494, -53), FPR(   5883257944270313, -53),
	FPR(  -5883257944270313, -53), FPR(   6820330957936494, -53),
	FPR(   5300885459442166, -56), FPR(   8982793858156602, -53),
	FPR(  -8982793858156602, -53), FPR(   5300885459442166, -56),
	FPR(   8982793858156602, -53), FPR(   5300885459442166, -56),
	FPR(  -5300885459442166, -56), FPR(   8982793858156602, -53),
	FPR(   5883257944270313, -53), FPR(   6820330957936494, -53),
	FPR(  -6820330957936494, -53), FPR(   5883257944270313, -53),
	FPR(   8045449260044789, -53), FPR(   8099477666776158, -54),
	FPR(  -8099477666776158, -54), FPR(   8045449260044789, -53),
	FPR(   5650787876693505, -54), FPR(   8552589520593170, -53),
	FPR(  -8552589520593170, -53), FPR(   5650787876693505, -54),
	FPR(   8680923061569891, -53), FPR(   4804669900715639, -54),
	FPR(  -4804669900715639, -54), FPR(   8680923061569891, -53),
	FPR(   8879264459430586, -54), FPR(   7837046897874218, -53),
	FPR(  -7837046897874218, -53), FPR(   8879264459430586, -54),
	FPR(   7100793355396091, -53), FPR(   5541513524170937, -53),
	FPR(  -5541513524170937, -53), FPR(   7100793355396091, -53),
	FPR(   8820618739413774, -56), FPR(   8939460924383187, -53),
	FPR(  -8939460924383187, -53), FPR(   8820618739413774, -56),
	FPR(   8874592046238633, -53), FPR(   6159551188123590, -55),
	FPR(  -6159551188123590, -55), FPR(   8874592046238633, -53),
	FPR(   5186419112612575, -53), FPR(   7364149319706498, -53),
	FPR(  -7364149319706498, -53), FPR(   5186419112612575, -53),
	FPR(   7609764403282432, -53), FPR(   4818830163135267, -53),
	FPR(  -4818830163135267, -53), FPR(   7609764403282432, -53),
	FPR(   7893954108215139, -55), FPR(   8788343498532233, -53),
	FPR(  -8788343498532233, -53), FPR(   7893954108215139, -55),
	FPR(   8403652042342972, -53), FPR(   6483292609725855, -54),
	FPR(  -6483292609725855, -54), FPR(   8403652042342972, -53),
	FPR(   7300178522992010, -54), FPR(   8234469430249786, -53),
	FPR(  -8234469430249786, -53), FPR(   7300178522992010, -54),
	FPR(   6523437785808790, -53), FPR(   6210829080669407, -53),
	FPR(  -6210829080669407, -53), FPR(   6523437785808790, -53),
	FPR(   7073527528384126, -58), FPR(   9004486454725901, -53),
	FPR(  -9004486454725901, -53), FPR(   7073527528384126, -58),
	FPR(   9006521029202651, -53), FPR(   7074060192106372, -59),
	FPR(  -7074060192106372, -59), FPR(   9006521029202651, -53),
	FPR(   6290414033205309, -53), FPR(   6446730156091567, -53),
	FPR(  -6446730156091567, -53), FPR(   6290414033205309, -53),
	FPR(   8278641599964811, -53), FPR(   7097529619223511, -54),
	FPR(  -7097529619223511, -54), FPR(   8278641599964811, -53),
	FPR(   6689055905271015, -54), FPR(   8363239276060827, -53),
	FPR(  -8363239276060827, -53), FPR(   6689055905271015, -54),
	FPR(   8811899492445997, -53), FPR(   7461973733147729, -55),
	FPR(  -7461973733147729, -55), FPR(   8811899492445997, -53),
	FPR(   4911850829306697, -53), FPR(   7550056943179025, -53),
	FPR(  -7550056943179025, -53), FPR(   4911850829306697, -53),
	FPR(   7427240153512674, -53), FPR(   5095659144473433, -53),
	FPR(  -5095659144473433, -53), FPR(   7427240153512674, -53),
	FPR(   6594706969509681, -55), FPR(   8855027013722231, -53),
	FPR(  -8855027013722231, -53), FPR(   6594706969509681, -55),
	FPR(   8952318119487099, -53), FPR(   7942347067146965, -56),
	FPR(  -7942347067146965, -56), FPR(   8952318119487099, -53),
	FPR(   5628233915913940, -53), FPR(   7032255783343117, -53),
	FPR(  -7032255783343117, -53), FPR(   5628233915913940, -53),
	FPR(   7890937899537737, -53), FPR(   8686250625038550, -54),
	FPR(  -8686250625038550, -54), FPR(   7890937899537737, -53),
	FPR(   5017364677319486, -54), FPR(   8650789058710388, -53),
	FPR(  -8650789058710388, -53), FPR(   5017364677319486, -54),
	FPR(   8586617456218381, -53), FPR(   5440455523270994, -54),
	FPR(  -5440455523270994, -54), FPR(   8586617456218381, -53),
	FPR(   8296327868244873, -54), FPR(   7995146927371163, -53),
	FPR(  -7995146927371163, -53), FPR(   8296327868244873, -54),
	FPR(   6892014024666815, -53), FPR(   5799118993295673, -53),
	FPR(  -5799118993295673, -53), FPR(   6892014024666815, -53),
	FPR(   6182347902460953, -56), FPR(   8973986217941769, -53),
	FPR(  -8973986217941769, -53), FPR(   6182347902460953, -56),
	FPR(   8990248722657709, -53), FPR(   8837249445142752, -57),
	FPR(  -8837249445142752, -57), FPR(   8990248722657709, -53),
	FPR(   5966510898238870, -53), FPR(   6747620774451057, -53),
	FPR(  -6747620774451057, -53), FPR(   5966510898238870, -53),
	FPR(   8094539977653340, -53), FPR(   7901407713763047, -54),
	FPR(  -7901407713763047, -54), FPR(   8094539977653340, -53),
	FPR(   5860269242247018, -54), FPR(   8517273596445054, -53),
	FPR(  -8517273596445054, -53), FPR(   5860269242247018, -54),
	FPR(   8709749749347266, -53), FPR(   4591251558497710, -54),
	FPR(  -4591251558497710, -54), FPR(   8709749749347266, -53),
	FPR(   4535470554627767, -53), FPR(   7781975665774802, -53),
	FPR(  -7781975665774802, -53), FPR(   4535470554627767, -53),
	FPR(   7168261574088514, -53), FPR(   5453958600874483, -53),
	FPR(  -5453958600874483, -53), FPR(   7168261574088514, -53),
	FPR(   4848781029471607, -55), FPR(   8925257479345985, -53),
	FPR(  -8925257479345985, -53), FPR(   4848781029471607, -55),
	FPR(   8892820597836187, -53), FPR(   5723467800985178, -55),
	FPR(  -5723467800985178, -55), FPR(   8892820597836187, -53),
	FPR(   5276398025110506, -53), FPR(   7299949472100244, -53),
	FPR(  -7299949472100244, -53), FPR(   5276398025110506, -53),
	FPR(   7668325860857618, -53), FPR(   4725083798866319, -53),
	FPR(  -4725083798866319, -53), FPR(   7668325860857618, -53),
	FPR(   8324745682830097, -55), FPR(   8763464012413658, -53),
	FPR(  -8763464012413658, -53), FPR(   8324745682830097, -55),
	FPR(   8442799249538603, -53), FPR(   6276552954161094, -54),
	FPR(  -6276552954161094, -54), FPR(   8442799249538603, -53),
	FPR(   7501728046727114, -54), FPR(   8189057179727324, -53),
	FPR(  -8189057179727324, -53), FPR(   7501728046727114, -54),
	FPR(   6599163009790561, -53), FPR(   6130308800119180, -53),
	FPR(  -6130308800119180, -53), FPR(   6599163009790561, -53),
	FPR(   5304479856743885, -57), FPR(   9001095837710173, -53),
	FPR(  -9001095837710173, -53), FPR(   5304479856743885, -57),
	FPR(   9001095837710173, -53), FPR(   5304479856743885, -57),
	FPR(  -5304479856743885, -57), FPR(   9001095837710173, -53),
	FPR(   6130308800119180, -53), FPR(   6599163009790561, -53),
	FPR(  -6599163009790561, -53), FPR(   6130308800119180, -53),
	FPR(   8189057179727324, -53), FPR(   7501728046727114, -54),
	FPR(  -7501728046727114, -54), FPR(   8189057179727324, -53),
	FPR(   6276552954161094, -54), FPR(   8442799249538603, -53),
	FPR(  -8442799249538603, -53), FPR(   6276552954161094, -54),
	FPR(   8763464012413658, -53), FPR(   8324745682830097, -55),
	FPR(  -8324745682830097, -55), FPR(   8763464012413658, -53),
	FPR(   4725083798866319, -53), FPR(   7668325860857618, -53),
	FPR(  -7668325860857618, -53), FPR(   4725083798866319, -53),
	FPR(   7299949472100244, -53), FPR(   5276398025110506, -53),
	FPR(  -5276398025110506, -53), FPR(   7299949472100244, -53),
	FPR(   5723467800985178, -55), FPR(   8892820597836187, -53),
	FPR(  -8892820597836187, -53), FPR(   5723467800985178, -55),
	FPR(   8925257479345985, -53), FPR(   4848781029471607, -55),
	FPR(  -4848781029471607, -55), FPR(   8925257479345985, -53),
	FPR(   5453958600874483, -53), FPR(   7168261574088514, -53),
	FPR(  -7168261574088514, -53), FPR(   5453958600874483, -53),
	FPR(   7781975665774802, -53), FPR(   4535470554627767, -53),
	FPR(  -4535470554627767, -53), FPR(   7781975665774802, -53),
	FPR(   4591251558497710, -54), FPR(   8709749749347266, -53),
	FPR(  -8709749749347266, -53), FPR(   4591251558497710, -54),
	FPR(   8517273596445054, -53), FPR(   5860269242247018, -54),
	FPR(  -5860269242247018, -54), FPR(   8517273596445054, -53),
	FPR(   7901407713763047, -54), FPR(   8094539977653340, -53),
	FPR(  -8094539977653340, -53), FPR(   7901407713763047, -54),
	FPR(   6747620774451057, -53), FPR(   5966510898238870, -53),
	FPR(  -5966510898238870, -53), FPR(   6747620774451057, -53),
	FPR(   8837249445142752, -57), FPR(   8990248722657709, -53),
	FPR(  -8990248722657709, -53), FPR(   8837249445142752, -57),
	FPR(   8973986217941769, -53), FPR(   6182347902460953, -56),
	FPR(  -6182347902460953, -56), FPR(   8973986217941769, -53),
	FPR(   5799118993295673, -53), FPR(   6892014024666815, -53),
	FPR(  -6892014024666815, -53), FPR(   5799118993295673, -53),
	FPR(   7995146927371163, -53), FPR(   8296327868244873, -54),
	FPR(  -8296327868244873, -54), FPR(   7995146927371163, -53),
	FPR(   5440455523270994, -54), FPR(   8586617456218381, -53),
	FPR(  -8586617456218381, -53), FPR(   5440455523270994, -54),
	FPR(   8650789058710388, -53), FPR(   5017364677319486, -54),
	FPR(  -5017364677319486, -54), FPR(   8650789058710388, -53),
	FPR(   8686250625038550, -54), FPR(   7890937899537737, -53),
	FPR(  -7890937899537737, -53), FPR(   8686250625038550, -54),
	FPR(   7032255783343117, -53), FPR(   5628233915913940, -53),
	FPR(  -5628233915913940, -53), FPR(   7032255783343117, -53),
	FPR(   7942347067146965, -56), FPR(   8952318119487099, -53),
	FPR(  -8952318119487099, -53), FPR(   7942347067146965, -56),
	FPR(   8855027013722231, -53), FPR(   6594706969509681, -55),
	FPR(  -6594706969509681, -55), FPR(   8855027013722231, -53),
	FPR(   5095659144473433, -53), FPR(   7427240153512674, -53),
	FPR(  -7427240153512674, -53), FPR(   5095659144473433, -53),
	FPR(   7550056943179025, -53), FPR(   4911850829306697, -53),
	FPR(  -4911850829306697, -53), FPR(   7550056943179025, -53),
	FPR(   7461973733147729, -55), FPR(   8811899492445997, -53),
	FPR(  -8811899492445997, -53), FPR(   7461973733147729, -55),
	FPR(   8363239276060827, -53), FPR(   6689055905271015, -54),
	FPR(  -6689055905271015, -54), FPR(   8363239276060827, -53),
	FPR(   7097529619223511, -54), FPR(   8278641599964811, -53),
	FPR(  -8278641599964811, -53), FPR(   7097529619223511, -54),
	FPR(   6446730156091567, -53), FPR(   6290414033205309, -53),
	FPR(  -6290414033205309, -53), FPR(   6446730156091567, -53),
	FPR(   7074060192106372, -59), FPR(   9006521029202651, -53),
	FPR(  -9006521029202651, -53), FPR(   7074060192106372, -59),
	FPR(   9007029696760466, -53), FPR(   7074193361797233, -60),
	FPR(  -7074193361797233, -60), FPR(   9007029696760466, -53),
	FPR(   6329852010540816, -53), FPR(   6408011543315061, -53),
	FPR(  -6408011543315061, -53), FPR(   6329852010540816, -53),
	FPR(   8300260568395001, -53), FPR(   6995802430416048, -54),
	FPR(  -6995802430416048, -54), FPR(   8300260568395001, -53),
	FPR(   6791561728666308, -54), FPR(   8342560202721672, -53),
	FPR(  -8342560202721672, -53), FPR(   6791561728666308, -54),
	FPR(   8823180063448708, -53), FPR(   7245558068298598, -55),
	FPR(  -7245558068298598, -55), FPR(   8823180063448708, -53),
	FPR(   4958084643600824, -53), FPR(   7519776265388244, -53),
	FPR(  -7519776265388244, -53), FPR(   4958084643600824, -53),
	FPR(   7458366714537629, -53), FPR(   5049990531286555, -53),
	FPR(  -5049990531286555, -53), FPR(   7458366714537629, -53),
	FPR(   6811916523300038, -55), FPR(   8844744230026167, -53),
	FPR(  -8844744230026167, -53), FPR(   6811916523300038, -55),
	FPR(   8958241260309380, -53), FPR(   7502754424118275, -56),
	FPR(  -7502754424118275, -56), FPR(   8958241260309380, -53),
	FPR(   5671277076310961, -53), FPR(   6997589209028812, -53),
	FPR(  -6997589209028812, -53), FPR(   5671277076310961, -53),
	FPR(   7917438270796208, -53), FPR(   8589251339374868, -54),
	FPR(  -8589251339374868, -54), FPR(   7917438270796208, -53),
	FPR(   5123430714424177, -54), FPR(   8635233224599694, -53),
	FPR(  -8635233224599694, -53), FPR(   5123430714424177, -54),
	FPR(   8603146819336178, -53), FPR(   5334980119757703, -54),
	FPR(  -5334980119757703, -54), FPR(   8603146819336178, -53),
	FPR(   8394286290816088, -54), FPR(   7969543765584135, -53),
	FPR(  -7969543765584135, -53), FPR(   8394286290816088, -54),
	FPR(   6927467009660074, -53), FPR(   5756721223463751, -53),
	FPR(  -5756721223463751, -53), FPR(   6927467009660074, -53),
	FPR(   6622738275719969, -56), FPR(   8969075513488470, -53),
	FPR(  -8969075513488470, -53), FPR(   6622738275719969, -56),
	FPR(   8993468505216860, -53), FPR(   7954473020348387, -57),
	FPR(  -7954473020348387, -57), FPR(   8993468505216860, -53),
	FPR(   6007801203085623, -53), FPR(   6710883929767346, -53),
	FPR(  -6710883929767346, -53), FPR(   6007801203085623, -53),
	FPR(   8118628663374582, -53), FPR(   7801924644814081, -54),
	FPR(  -7801924644814081, -54), FPR(   8118628663374582, -53),
	FPR(   5964680940960804, -54), FPR(   8499134293134885, -53),
	FPR(  -8499134293134885, -53), FPR(   5964680940960804, -54),
	FPR(   8723671485748716, -53), FPR(   8968562179829241, -55),
	FPR(  -8968562179829241, -55), FPR(   8723671485748716, -53),
	FPR(   4583134480704026, -53), FPR(   7754000048129257, -53),
	FPR(  -7754000048129257, -53), FPR(   4583134480704026, -53),
	FPR(   7201591494446370, -53), FPR(   5409872305491543, -53),
	FPR(  -5409872305491543, -53), FPR(   7201591494446370, -53),
	FPR(   5067747153968079, -55), FPR(   8917651573624763, -53),
	FPR(  -8917651573624763, -53), FPR(   5067747153968079, -55),
	FPR(   8901432827556552, -53), FPR(   5505098772745492, -55),
	FPR(  -5505098772745492, -55), FPR(   8901432827556552, -53),
	FPR(   5321090346314263, -53), FPR(   7267436682969301, -53),
	FPR(  -7267436682969301, -53), FPR(   5321090346314263, -53),
	FPR(   7697174075937797, -53), FPR(   4677942887564769, -53),
	FPR(  -4677942887564769, -53), FPR(   7697174075937797, -53),
	FPR(   8539675389073947, -55), FPR(   8750529122869341, -53),
	FPR(  -8750529122869341, -53), FPR(   8539675389073947, -55),
	FPR(   8461896418689196, -53), FPR(   6172826715203219, -54),
	FPR(  -6172826715203219, -54), FPR(   8461896418689196, -53),
	FPR(   7602081049296905, -54), FPR(   8165888154058130, -53),
	FPR(  -8165888154058130, -53), FPR(   7602081049296905, -54),
	FPR(   6636653650073061, -53), FPR(   6089701695779408, -53),
	FPR(  -6089701695779408, -53), FPR(   6636653650073061, -53),
	FPR(   6188054973828419, -57), FPR(   8998892164841951, -53),
	FPR(  -8998892164841951, -53), FPR(   6188054973828419, -57),
	FPR(   9002960624407544, -53), FPR(   8841410057981697, -58),
	FPR(  -8841410057981697, -58), FPR(   9002960624407544, -53),
	FPR(   6170685101797492, -53), FPR(   6561423914750605, -53),
	FPR(  -6561423914750605, -53), FPR(   6170685101797492, -53),
	FPR(   8211917892022175, -53), FPR(   7401092608336357, -54),
	FPR(  -7401092608336357, -54), FPR(   8211917892022175, -53),
	FPR(   6380042884447767, -54), FPR(   8423384213768154, -53),
	FPR(  -8423384213768154, -53), FPR(   6380042884447767, -54),
	FPR(   8776068962491037, -53), FPR(   8109502554616454, -55),
	FPR(  -8109502554616454, -55), FPR(   8776068962491037, -53),
	FPR(   4772046813433470, -53), FPR(   7639188937642932, -53),
	FPR(  -7639188937642932, -53), FPR(   4772046813433470, -53),
	FPR(   7332187422259511, -53), FPR(   5231507050503336, -53),
	FPR(  -5231507050503336, -53), FPR(   7332187422259511, -53),
	FPR(   5941621343897074, -55), FPR(   8883873558446555, -53),
	FPR(  -8883873558446555, -53), FPR(   5941621343897074, -55),
	FPR(   8932527354167686, -53), FPR(   4629632351109917, -55),
	FPR(  -4629632351109917, -55), FPR(   8932527354167686, -53),
	FPR(   5497839557798690, -53), FPR(   7134661772733911, -53),
	FPR(  -7134661772733911, -53), FPR(   5497839557798690, -53),
	FPR(   7809658296434922, -53), FPR(   8975271741297168, -54),
	FPR(  -8975271741297168, -54), FPR(   7809658296434922, -53),
	FPR(   4698049169054608, -54), FPR(   8695500095790524, -53),
	FPR(  -8695500095790524, -53), FPR(   4698049169054608, -54),
	FPR(   8535092229218300, -53), FPR(   5755636907708500, -54),
	FPR(  -5755636907708500, -54), FPR(   8535092229218300, -53),
	FPR(   8000593299177483, -54), FPR(   8070146537076992, -53),
	FPR(  -8070146537076992, -53), FPR(   8000593299177483, -54),
	FPR(   6784103575026380, -53), FPR(   5924995957629083, -53),
	FPR(  -5924995957629083, -53), FPR(   6784103575026380, -53),
	FPR(   4859846576245171, -56), FPR(   8986690462315460, -53),
	FPR(  -8986690462315460, -53), FPR(   4859846576245171, -56),
	FPR(   8978559056886080, -53), FPR(   5741724767297686, -56),
	FPR(  -5741724767297686, -56), FPR(   8978559056886080, -53),
	FPR(   5841298429575172, -53), FPR(   6856301559240908, -53),
	FPR(  -6856301559240908, -53), FPR(   5841298429575172, -53),
	FPR(   8020449076395251, -53), FPR(   8198057093618523, -54),
	FPR(  -8198057093618523, -54), FPR(   8020449076395251, -53),
	FPR(   5545726096708791, -54), FPR(   8569764811806532, -53),
	FPR(  -8569764811806532, -53), FPR(   5545726096708791, -54),
	FPR(   8666019195502468, -53), FPR(   4911109739270519, -54),
	FPR(  -4911109739270519, -54), FPR(   8666019195502468, -53),
	FPR(   8782922878275687, -54), FPR(   7864140438927325, -53),
	FPR(  -7864140438927325, -53), FPR(   8782922878275687, -54),
	FPR(   7066657597201826, -53), FPR(   5584978855691076, -53),
	FPR(  -5584978855691076, -53), FPR(   7066657597201826, -53),
	FPR(   8381640685297609, -56), FPR(   8946057928947489, -53),
	FPR(  -8946057928947489, -53), FPR(   8381640685297609, -56),
	FPR(   8864976410656110, -53), FPR(   6377249128729266, -55),
	FPR(  -6377249128729266, -55), FPR(   8864976410656110, -53),
	FPR(   5141135908973599, -53), FPR(   7395833961093832, -53),
	FPR(  -7395833961093832, -53), FPR(   5141135908973599, -53),
	FPR(   7580053365593204, -53), FPR(   4865432086605035, -53),
	FPR(  -4865432086605035, -53), FPR(   7580053365593204, -53),
	FPR(   7678108458903330, -55), FPR(   8800287158407901, -53),
	FPR(  -8800287158407901, -53), FPR(   7678108458903330, -55),
	FPR(   8383603478168160, -53), FPR(   6586298242701558, -54),
	FPR(  -6586298242701558, -54), FPR(   8383603478168160, -53),
	FPR(   7198989590052351, -54), FPR(   8256710945357489, -53),
	FPR(  -8256710945357489, -53), FPR(   7198989590052351, -54),
	FPR(   6485206053121402, -53), FPR(   6250739225336809, -53),
	FPR(  -6250739225336809, -53), FPR(   6485206053121402, -53),
	FPR(   5305378684473085, -58), FPR(   9005673271218593, -53),
	FPR(  -9005673271218593, -53), FPR(   5305378684473085, -58),
	FPR(   9005673271218593, -53), FPR(   5305378684473085, -58),
	FPR(  -5305378684473085, -58), FPR(   9005673271218593, -53),
	FPR(   6250739225336809, -53), FPR(   6485206053121402, -53),
	FPR(  -6485206053121402, -53), FPR(   6250739225336809, -53),
	FPR(   8256710945357489, -53), FPR(   7198989590052351, -54),
	FPR(  -7198989590052351, -54), FPR(   8256710945357489, -53),
	FPR(   6586298242701558, -54), FPR(   8383603478168160, -53),
	FPR(  -8383603478168160, -53), FPR(   6586298242701558, -54),
	FPR(   8800287158407901, -53), FPR(   7678108458903330, -55),
	FPR(  -7678108458903330, -55), FPR(   8800287158407901, -53),
	FPR(   4865432086605035, -53), FPR(   7580053365593204, -53),
	FPR(  -7580053365593204, -53), FPR(   4865432086605035, -53),
	FPR(   7395833961093832, -53), FPR(   5141135908973599, -53),
	FPR(  -5141135908973599, -53), FPR(   7395833961093832, -53),
	FPR(   6377249128729266, -55), FPR(   8864976410656110, -53),
	FPR(  -8864976410656110, -53), FPR(   6377249128729266, -55),
	FPR(   8946057928947489, -53), FPR(   8381640685297609, -56),
	FPR(  -8381640685297609, -56), FPR(   8946057928947489, -53),
	FPR(   5584978855691076, -53), FPR(   7066657597201826, -53),
	FPR(  -7066657597201826, -53), FPR(   5584978855691076, -53),
	FPR(   7864140438927325, -53), FPR(   8782922878275687, -54),
	FPR(  -8782922878275687, -54), FPR(   7864140438927325, -53),
	FPR(   4911109739270519, -54), FPR(   8666019195502468, -53),
	FPR(  -8666019195502468, -53), FPR(   4911109739270519, -54),
	FPR(   8569764811806532, -53), FPR(   5545726096708791, -54),
	FPR(  -5545726096708791, -54), FPR(   8569764811806532, -53),
	FPR(   8198057093618523, -54), FPR(   8020449076395251, -53),
	FPR(  -8020449076395251, -53), FPR(   8198057093618523, -54),
	FPR(   6856301559240908, -53), FPR(   5841298429575172, -53),
	FPR(  -5841298429575172, -53), FPR(   6856301559240908, -53),
	FPR(   5741724767297686, -56), FPR(   8978559056886080, -53),
	FPR(  -8978559056886080, -53), FPR(   5741724767297686, -56),
	FPR(   8986690462315460, -53), FPR(   4859846576245171, -56),
	FPR(  -4859846576245171, -56), FPR(   8986690462315460, -53),
	FPR(   5924995957629083, -53), FPR(   6784103575026380, -53),
	FPR(  -6784103575026380, -53), FPR(   5924995957629083, -53),
	FPR(   8070146537076992, -53), FPR(   8000593299177483, -54),
	FPR(  -8000593299177483, -54), FPR(   8070146537076992, -53),
	FPR(   5755636907708500, -54), FPR(   8535092229218300, -53),
	FPR(  -8535092229218300, -53), FPR(   5755636907708500, -54),
	FPR(   8695500095790524, -53), FPR(   4698049169054608, -54),
	FPR(  -4698049169054608, -54), FPR(   8695500095790524, -53),
	FPR(   8975271741297168, -54), FPR(   7809658296434922, -53),
	FPR(  -7809658296434922, -53), FPR(   8975271741297168, -54),
	FPR(   7134661772733911, -53), FPR(   5497839557798690, -53),
	FPR(  -5497839557798690, -53), FPR(   7134661772733911, -53),
	FPR(   4629632351109917, -55), FPR(   8932527354167686, -53),
	FPR(  -8932527354167686, -53), FPR(   4629632351109917, -55),
	FPR(   8883873558446555, -53), FPR(   5941621343897074, -55),
	FPR(  -5941621343897074, -55), FPR(   8883873558446555, -53),
	FPR(   5231507050503336, -53), FPR(   7332187422259511, -53),
	FPR(  -7332187422259511, -53), FPR(   5231507050503336, -53),
	FPR(   7639188937642932, -53), FPR(   4772046813433470, -53),
	FPR(  -4772046813433470, -53), FPR(   7639188937642932, -53),
	FPR(   8109502554616454, -55), FPR(   8776068962491037, -53),
	FPR(  -8776068962491037, -53), FPR(   8109502554616454, -55),
	FPR(   8423384213768154, -53), FPR(   6380042884447767, -54),
	FPR(  -6380042884447767, -54), FPR(   8423384213768154, -53),
	FPR(   7401092608336357, -54), FPR(   8211917892022175, -53),
	FPR(  -8211917892022175, -53), FPR(   7401092608336357, -54),
	FPR(   6561423914750605, -53), FPR(   6170685101797492, -53),
	FPR(  -6170685101797492, -53), FPR(   6561423914750605, -53),
	FPR(   8841410057981697, -58), FPR(   9002960624407544, -53),
	FPR(  -9002960624407544, -53), FPR(   8841410057981697, -58),
	FPR(   8998892164841951, -53), FPR(   6188054973828419, -57),
	FPR(  -6188054973828419, -57), FPR(   8998892164841951, -53),
	FPR(   6089701695779408, -53), FPR(   6636653650073061, -53),
	FPR(  -6636653650073061, -53), FPR(   6089701695779408, -53),
	FPR(   8165888154058130, -53), FPR(   7602081049296905, -54),
	FPR(  -7602081049296905, -54), FPR(   8165888154058130, -53),
	FPR(   6172826715203219, -54), FPR(   8461896418689196, -53),
	FPR(  -8461896418689196, -53), FPR(   6172826715203219, -54),
	FPR(   8750529122869341, -53), FPR(   8539675389073947, -55),
	FPR(  -8539675389073947, -55), FPR(   8750529122869341, -53),
	FPR(   4677942887564769, -53), FPR(   7697174075937797, -53),
	FPR(  -7697174075937797, -53), FPR(   4677942887564769, -53),
	FPR(   7267436682969301, -53), FPR(   5321090346314263, -53),
	FPR(  -5321090346314263, -53), FPR(   7267436682969301, -53),
	FPR(   5505098772745492, -55), FPR(   8901432827556552, -53),
	FPR(  -8901432827556552, -53), FPR(   5505098772745492, -55),
	FPR(   8917651573624763, -53), FPR(   5067747153968079, -55),
	FPR(  -5067747153968079, -55), FPR(   8917651573624763, -53),
	FPR(   5409872305491543, -53), FPR(   7201591494446370, -53),
	FPR(  -7201591494446370, -53), FPR(   5409872305491543, -53),
	FPR(   7754000048129257, -53), FPR(   4583134480704026, -53),
	FPR(  -4583134480704026, -53), FPR(   7754000048129257, -53),
	FPR(   8968562179829241, -55), FPR(   8723671485748716, -53),
	FPR(  -8723671485748716, -53), FPR(   8968562179829241, -55),
	FPR(   8499134293134885, -53), FPR(   5964680940960804, -54),
	FPR(  -5964680940960804, -54), FPR(   8499134293134885, -53),
	FPR(   7801924644814081, -54), FPR(   8118628663374582, -53),
	FPR(  -8118628663374582, -53), FPR(   7801924644814081, -54),
	FPR(   6710883929767346, -53), FPR(   6007801203085623, -53),
	FPR(  -6007801203085623, -53), FPR(   6710883929767346, -53),
	FPR(   7954473020348387, -57), FPR(   8993468505216860, -53),
	FPR(  -8993468505216860, -53), FPR(   7954473020348387, -57),
	FPR(   8969075513488470, -53), FPR(   6622738275719969, -56),
	FPR(  -6622738275719969, -56), FPR(   8969075513488470, -53),
	FPR(   5756721223463751, -53), FPR(   6927467009660074, -53),
	FPR(  -6927467009660074, -53), FPR(   5756721223463751, -53),
	FPR(   7969543765584135, -53), FPR(   8394286290816088, -54),
	FPR(  -8394286290816088, -54), FPR(   7969543765584135, -53),
	FPR(   5334980119757703, -54), FPR(   8603146819336178, -53),
	FPR(  -8603146819336178, -53), FPR(   5334980119757703, -54),
	FPR(   8635233224599694, -53), FPR(   5123430714424177, -54),
	FPR(  -5123430714424177, -54), FPR(   8635233224599694, -53),
	FPR(   8589251339374868, -54), FPR(   7917438270796208, -53),
	FPR(  -7917438270796208, -53), FPR(   8589251339374868, -54),
	FPR(   6997589209028812, -53), FPR(   5671277076310961, -53),
	FPR(  -5671277076310961, -53), FPR(   6997589209028812, -53),
	FPR(   7502754424118275, -56), FPR(   8958241260309380, -53),
	FPR(  -8958241260309380, -53), FPR(   7502754424118275, -56),
	FPR(   8844744230026167, -53), FPR(   6811916523300038, -55),
	FPR(  -6811916523300038, -55), FPR(   8844744230026167, -53),
	FPR(   5049990531286555, -53), FPR(   7458366714537629, -53),
	FPR(  -7458366714537629, -53), FPR(   5049990531286555, -53),
	FPR(   7519776265388244, -53), FPR(   4958084643600824, -53),
	FPR(  -4958084643600824, -53), FPR(   7519776265388244, -53),
	FPR(   7245558068298598, -55), FPR(   8823180063448708, -53),
	FPR(  -8823180063448708, -53), FPR(   7245558068298598, -55),
	FPR(   8342560202721672, -53), FPR(   6791561728666308, -54),
	FPR(  -6791561728666308, -54), FPR(   8342560202721672, -53),
	FPR(   6995802430416048, -54), FPR(   8300260568395001, -53),
	FPR(  -8300260568395001, -53), FPR(   6995802430416048, -54),
	FPR(   6408011543315061, -53), FPR(   6329852010540816, -53),
	FPR(  -6329852010540816, -53), FPR(   6408011543315061, -53),
	FPR(   7074193361797233, -60), FPR(   9007029696760466, -53),
	FPR(  -9007029696760466, -53), FPR(   7074193361797233, -60),
	FPR(   9007156865146114, -53), FPR(   7074226654454970, -61),
	FPR(  -7074226654454970, -61), FPR(   9007156865146114, -53),
	FPR(   6349481723403377, -53), FPR(   6388561673708188, -53),
	FPR(  -6388561673708188, -53), FPR(   6349481723403377, -53),
	FPR(   8310952915477583, -53), FPR(   6944839825747268, -54),
	FPR(  -6944839825747268, -54), FPR(   8310952915477583, -53),
	FPR(   6842718994272319, -54), FPR(   8332102832176454, -53),
	FPR(  -8332102832176454, -53), FPR(   6842718994272319, -54),
	FPR(   8828695804602461, -53), FPR(   7137247429536506, -55),
	FPR(  -7137247429536506, -55), FPR(   8828695804602461, -53),
	FPR(   4981131658359743, -53), FPR(   7504529686575502, -53),
	FPR(  -7504529686575502, -53), FPR(   4981131658359743, -53),
	FPR(   7473824766646994, -53), FPR(   5027084818466930, -53),
	FPR(  -5027084818466930, -53), FPR(   7473824766646994, -53),
	FPR(   6920425636632580, -55), FPR(   8839477938633966, -53),
	FPR(  -8839477938633966, -53), FPR(   6920425636632580, -55),
	FPR(   8961076366892190, -53), FPR(   7282851139856476, -56),
	FPR(  -7282851139856476, -56), FPR(   8961076366892190, -53),
	FPR(   5692718687339392, -53), FPR(   6980157044180565, -53),
	FPR(  -6980157044180565, -53), FPR(   5692718687339392, -53),
	FPR(   7930576735691761, -53), FPR(   8540630200145957, -54),
	FPR(  -8540630200145957, -54), FPR(   7930576735691761, -53),
	FPR(   5176391646926010, -54), FPR(   8627333353592832, -53),
	FPR(  -8627333353592832, -53), FPR(   5176391646926010, -54),
	FPR(   8611290075458352, -53), FPR(   5282166847391008, -54),
	FPR(  -5282166847391008, -54), FPR(   8611290075458352, -53),
	FPR(   8443147217093086, -54), FPR(   7956629605695492, -53),
	FPR(  -7956629605695492, -53), FPR(   8443147217093086, -54),
	FPR(   6945095779491208, -53), FPR(   5735440961974946, -53),
	FPR(  -5735440961974946, -53), FPR(   6945095779491208, -53),
	FPR(   6842840994885793, -56), FPR(   8966493518975884, -53),
	FPR(  -8966493518975884, -53), FPR(   6842840994885793, -56),
	FPR(   8994951428947667, -53), FPR(   7512970424714007, -57),
	FPR(  -7512970424714007, -57), FPR(   8994951428947667, -53),
	FPR(   6028361630966943, -53), FPR(   6692420672738099, -53),
	FPR(  -6692420672738099, -53), FPR(   6028361630966943, -53),
	FPR(   8130558439301216, -53), FPR(   7752072724043411, -54),
	FPR(  -7752072724043411, -54), FPR(   8130558439301216, -53),
	FPR(   6016802823104436, -54), FPR(   8489944602974586, -53),
	FPR(  -8489944602974586, -53), FPR(   6016802823104436, -54),
	FPR(   8730509220737932, -53), FPR(   8861464584337410, -55),
	FPR(  -8861464584337410, -55), FPR(   8730509220737932, -53),
	FPR(   4606901848488119, -53), FPR(   7739902697902825, -53),
	FPR(  -7739902697902825, -53), FPR(   4606901848488119, -53),
	FPR(   7218154856711858, -53), FPR(   5387752674272799, -53),
	FPR(  -5387752674272799, -53), FPR(   7218154856711858, -53),
	FPR(   5177159182005257, -55), FPR(   8913722698169820, -53),
	FPR(  -8913722698169820, -53), FPR(   5177159182005257, -55),
	FPR(   8905613286971281, -53), FPR(   5395836020528807, -55),
	FPR(  -5395836020528807, -55), FPR(   8905613286971281, -53),
	FPR(   5343361485770773, -53), FPR(   7251077605914050, -53),
	FPR(  -7251077605914050, -53), FPR(   5343361485770773, -53),
	FPR(   7711489578089543, -53), FPR(   4654306275012748, -53),
	FPR(  -4654306275012748, -53), FPR(   7711489578089543, -53),
	FPR(   8647020179743560, -55), FPR(   8743938102497119, -53),
	FPR(  -8743938102497119, -53), FPR(   8647020179743560, -55),
	FPR(   8471325578127065, -53), FPR(   6120876200014774, -54),
	FPR(  -6120876200014774, -54), FPR(   8471325578127065, -53),
	FPR(   7652150456031602, -54), FPR(   8154188295849595, -53),
	FPR(  -8154188295849595, -53), FPR(   7652150456031602, -54),
	FPR(   6655305358219218, -53), FPR(   6069312070034399, -53),
	FPR(  -6069312070034399, -53), FPR(   6655305358219218, -53),
	FPR(   6629757244884614, -57), FPR(   8997663271522660, -53),
	FPR(  -8997663271522660, -53), FPR(   6629757244884614, -57),
	FPR(   9003765913003641, -53), FPR(   7957506242722589, -58),
	FPR(  -7957506242722589, -58), FPR(   9003765913003641, -53),
	FPR(   6190786226252304, -53), FPR(   6542461640350018, -53),
	FPR(  -6542461640350018, -53), FPR(   6190786226252304, -53),
	FPR(   8223232361233372, -53), FPR(   7350670159317696, -54),
	FPR(  -7350670159317696, -54), FPR(   8223232361233372, -53),
	FPR(   6431698015882422, -54), FPR(   8413557723860353, -53),
	FPR(  -8413557723860353, -53), FPR(   6431698015882422, -54),
	FPR(   8782247561441008, -53), FPR(   8001765989250269, -55),
	FPR(  -8001765989250269, -55), FPR(   8782247561441008, -53),
	FPR(   4795461056637271, -53), FPR(   7624512552870645, -53),
	FPR(  -7624512552870645, -53), FPR(   4795461056637271, -53),
	FPR(   7348202953025374, -53), FPR(   5208987596045498, -53),
	FPR(  -5208987596045498, -53), FPR(   7348202953025374, -53),
	FPR(   6050614741355486, -55), FPR(   8879274589899640, -53),
	FPR(  -8879274589899640, -53), FPR(   6050614741355486, -55),
	FPR(   8936036193963400, -53), FPR(   4519992132352091, -55),
	FPR(  -4519992132352091, -55), FPR(   8936036193963400, -53),
	FPR(   5519702517755945, -53), FPR(   7117761061603948, -53),
	FPR(  -7117761061603948, -53), FPR(   5519702517755945, -53),
	FPR(   7823389415514919, -53), FPR(   8927310113985246, -54),
	FPR(  -8927310113985246, -54), FPR(   7823389415514919, -53),
	FPR(   4751381895793102, -54), FPR(   8688252467250769, -53),
	FPR(  -8688252467250769, -53), FPR(   4751381895793102, -54),
	FPR(   8543881084037075, -53), FPR(   5703239232730864, -54),
	FPR(  -5703239232730864, -54), FPR(   8543881084037075, -53),
	FPR(   8050073368155017, -54), FPR(   8057835820270665, -53),
	FPR(  -8057835820270665, -53), FPR(   8050073368155017, -54),
	FPR(   6802249279161855, -53), FPR(   5904154737026182, -53),
	FPR(  -5904154737026182, -53), FPR(   6802249279161855, -53),
	FPR(   5080389927126093, -56), FPR(   8984784444342543, -53),
	FPR(  -8984784444342543, -53), FPR(   5080389927126093, -56),
	FPR(   8980718722493792, -53), FPR(   5521331097805465, -56),
	FPR(  -5521331097805465, -56), FPR(   8980718722493792, -53),
	FPR(   5862305776050047, -53), FPR(   6838348441158650, -53),
	FPR(  -6838348441158650, -53), FPR(   5862305776050047, -53),
	FPR(   8032986972986387, -53), FPR(   8148805730028833, -54),
	FPR(  -8148805730028833, -54), FPR(   8032986972986387, -53),
	FPR(   5598283333288561, -54), FPR(   8561217456919463, -53),
	FPR(  -8561217456919463, -53), FPR(   5598283333288561, -54),
	FPR(   8673511947735049, -53), FPR(   4857912682255224, -54),
	FPR(  -4857912682255224, -54), FPR(   8673511947735049, -53),
	FPR(   8831135229857187, -54), FPR(   7850630614963393, -53),
	FPR(  -7850630614963393, -53), FPR(   8831135229857187, -54),
	FPR(   7083758813816853, -53), FPR(   5563272371750168, -53),
	FPR(  -5563272371750168, -53), FPR(   7083758813816853, -53),
	FPR(   8601170191100479, -56), FPR(   8942801513192182, -53),
	FPR(  -8942801513192182, -53), FPR(   8601170191100479, -56),
	FPR(   8869825971537420, -53), FPR(   6268429658850061, -55),
	FPR(  -6268429658850061, -55), FPR(   8869825971537420, -53),
	FPR(   5163801812627728, -53), FPR(   7380026372209606, -53),
	FPR(  -7380026372209606, -53), FPR(   5163801812627728, -53),
	FPR(   7594944627693494, -53), FPR(   4842153912968527, -53),
	FPR(  -4842153912968527, -53), FPR(   7594944627693494, -53),
	FPR(   7786067926277549, -55), FPR(   8794356716387429, -53),
	FPR(  -8794356716387429, -53), FPR(   7786067926277549, -55),
	FPR(   8393667262452058, -53), FPR(   6534826180350098, -54),
	FPR(  -6534826180350098, -54), FPR(   8393667262452058, -53),
	FPR(   7249618174605810, -54), FPR(   8245628993303844, -53),
	FPR(  -8245628993303844, -53), FPR(   7249618174605810, -54),
	FPR(   6504352530186687, -53), FPR(   6230813476397823, -53),
	FPR(  -6230813476397823, -53), FPR(   6504352530186687, -53),
	FPR(   6189482235310630, -58), FPR(   9005122242792311, -53),
	FPR(  -9005122242792311, -53), FPR(   6189482235310630, -58),
	FPR(   9006139534818257, -53), FPR(   8842450394781643, -59),
	FPR(  -8842450394781643, -59), FPR(   9006139534818257, -53),
	FPR(   6270606139937627, -53), FPR(   6465998534826869, -53),
	FPR(  -6465998534826869, -53), FPR(   6270606139937627, -53),
	FPR(   8267715182103167, -53), FPR(   7148293245867151, -54),
	FPR(  -7148293245867151, -54), FPR(   8267715182103167, -53),
	FPR(   6637708312305582, -54), FPR(   8373460784215450, -53),
	FPR(  -8373460784215450, -53), FPR(   6637708312305582, -54),
	FPR(   8806134768774068, -53), FPR(   7570076722248107, -55),
	FPR(  -7570076722248107, -55), FPR(   8806134768774068, -53),
	FPR(   4888664464941756, -53), FPR(   7565090757143791, -53),
	FPR(  -7565090757143791, -53), FPR(   4888664464941756, -53),
	FPR(   7411571937572131, -53), FPR(   5118421614990306, -53),
	FPR(  -5118421614990306, -53), FPR(   7411571937572131, -53),
	FPR(   6486008573510911, -55), FPR(   8860043409240618, -53),
	FPR(  -8860043409240618, -53), FPR(   6486008573510911, -55),
	FPR(   8949230140998484, -53), FPR(   8162032288300481, -56),
	FPR(  -8162032288300481, -56), FPR(   8949230140998484, -53),
	FPR(   5606632771683968, -53), FPR(   7049489866514174, -53),
	FPR(  -7049489866514174, -53), FPR(   5606632771683968, -53),
	FPR(   7877576242606407, -53), FPR(   8734627858479102, -54),
	FPR(  -8734627858479102, -54), FPR(   7877576242606407, -53),
	FPR(   4964260571050563, -54), FPR(   8658444875396786, -53),
	FPR(  -8658444875396786, -53), FPR(   4964260571050563, -54),
	FPR(   8578231504803418, -53), FPR(   5493116661642923, -54),
	FPR(  -5493116661642923, -54), FPR(   8578231504803418, -53),
	FPR(   8247231293972637, -54), FPR(   8007835688282839, -53),
	FPR(  -8007835688282839, -53), FPR(   8247231293972637, -54),
	FPR(   6874190143201685, -53), FPR(   5820236102574833, -53),
	FPR(  -5820236102574833, -53), FPR(   6874190143201685, -53),
	FPR(   5962064393489674, -56), FPR(   8976314881661062, -53),
	FPR(  -8976314881661062, -53), FPR(   5962064393489674, -56),
	FPR(   8988511894135185, -53), FPR(   4639257482637412, -56),
	FPR(  -4639257482637412, -56), FPR(   8988511894135185, -53),
	FPR(   5945781409913510, -53), FPR(   6765894016324346, -53),
	FPR(  -6765894016324346, -53), FPR(   5945781409913510, -53),
	FPR(   8082381294590617, -53), FPR(   7951037925568809, -54),
	FPR(  -7951037925568809, -54), FPR(   8082381294590617, -53),
	FPR(   5807980408439539, -54), FPR(   8526223038860894, -53),
	FPR(  -8526223038860894, -53), FPR(   5807980408439539, -54),
	FPR(   8702665878971716, -53), FPR(   4644672222488094, -54),
	FPR(  -4644672222488094, -54), FPR(   8702665878971716, -53),
	FPR(   4511574444966625, -53), FPR(   7795853669876749, -53),
	FPR(  -7795853669876749, -53), FPR(   4511574444966625, -53),
	FPR(   7151495329710049, -53), FPR(   5475924850081677, -53),
	FPR(  -5475924850081677, -53), FPR(   7151495329710049, -53),
	FPR(   4739228994004870, -55), FPR(   8928934438022583, -53),
	FPR(  -8928934438022583, -53), FPR(   4739228994004870, -55),
	FPR(   8888388908592136, -53), FPR(   5832572021635720, -55),
	FPR(  -5832572021635720, -55), FPR(   8888388908592136, -53),
	FPR(   5253977264024408, -53), FPR(   7316102878153182, -53),
	FPR(  -7316102878153182, -53), FPR(   5253977264024408, -53),
	FPR(   7653793419459571, -53), FPR(   4748587653907638, -53),
	FPR(  -4748587653907638, -53), FPR(   7653793419459571, -53),
	FPR(   8217162790256110, -55), FPR(   8769807759837646, -53),
	FPR(  -8769807759837646, -53), FPR(   8217162790256110, -55),
	FPR(   8433131419575708, -53), FPR(   6328327701619659, -54),
	FPR(  -6328327701619659, -54), FPR(   8433131419575708, -53),
	FPR(   7451445395452699, -54), FPR(   8200526129112289, -53),
	FPR(  -8200526129112289, -53), FPR(   7451445395452699, -54),
	FPR(   6580324430530404, -53), FPR(   6150525896504412, -53),
	FPR(  -6150525896504412, -53), FPR(   6580324430530404, -53),
	FPR(   4862615327261055, -57), FPR(   9002070596517294, -53),
	FPR(  -9002070596517294, -53), FPR(   4862615327261055, -57),
	FPR(   9000036357160980, -53), FPR(   5746294458442105, -57),
	FPR(  -5746294458442105, -57), FPR(   9000036357160980, -53),
	FPR(   6110034002932808, -53), FPR(   6617939475215195, -53),
	FPR(  -6617939475215195, -53), FPR(   6110034002932808, -53),
	FPR(   8177511151817401, -53), FPR(   7551940088880137, -54),
	FPR(  -7551940088880137, -54), FPR(   8177511151817401, -53),
	FPR(   6224719129395714, -54), FPR(   8452387612659540, -53),
	FPR(  -8452387612659540, -53), FPR(   6224719129395714, -54),
	FPR(   8757037779928840, -53), FPR(   8432250219727258, -55),
	FPR(  -8432250219727258, -55), FPR(   8757037779928840, -53),
	FPR(   4701535469536748, -53), FPR(   7682786125052197, -53),
	FPR(  -7682786125052197, -53), FPR(   4701535469536748, -53),
	FPR(   7283727356142706, -53), FPR(   5298769122728888, -53),
	FPR(  -5298769122728888, -53), FPR(   7283727356142706, -53),
	FPR(   5614309708875923, -55), FPR(   8897168584465961, -53),
	FPR(  -8897168584465961, -53), FPR(   5614309708875923, -55),
	FPR(   8921496512746829, -53), FPR(   4958287426364647, -55),
	FPR(  -4958287426364647, -55), FPR(   8921496512746829, -53),
	FPR(   5431941016931809, -53), FPR(   7184960348059028, -53),
	FPR(  -7184960348059028, -53), FPR(   5431941016931809, -53),
	FPR(   7768024414754142, -53), FPR(   4559323974712726, -53),
	FPR(  -4559323974712726, -53), FPR(   7768024414754142, -53),
	FPR(   4537787679899090, -54), FPR(   8716751640241088, -53),
	FPR(  -8716751640241088, -53), FPR(   4537787679899090, -54),
	FPR(   8508243986206341, -53), FPR(   5912502916968520, -54),
	FPR(  -5912502916968520, -54), FPR(   8508243986206341, -53),
	FPR(   7851703130898649, -54), FPR(   8106622471823008, -53),
	FPR(  -8106622471823008, -53), FPR(   7851703130898649, -54),
	FPR(   6729284021401222, -53), FPR(   5987184227491324, -53),
	FPR(  -5987184227491324, -53), FPR(   6729284021401222, -53),
	FPR(   8395900745453257, -57), FPR(   8991900931535341, -53),
	FPR(  -8991900931535341, -53), FPR(   8395900745453257, -57),
	FPR(   8971573087646471, -53), FPR(   6402573220819241, -56),
	FPR(  -6402573220819241, -56), FPR(   8971573087646471, -53),
	FPR(   5777947300499967, -53), FPR(   6909773035871137, -53),
	FPR(  -6909773035871137, -53), FPR(   5777947300499967, -53),
	FPR(   7982382913091674, -53), FPR(   8345346354319577, -54),
	FPR(  -8345346354319577, -54), FPR(   7982382913091674, -53),
	FPR(   5387743177259695, -54), FPR(   8594922587119653, -53),
	FPR(  -8594922587119653, -53), FPR(   5387743177259695, -54),
	FPR(   8643051817502737, -53), FPR(   5070421558241214, -54),
	FPR(  -5070421558241214, -54), FPR(   8643051817502737, -53),
	FPR(   8637791633298976, -54), FPR(   7904225283956311, -53),
	FPR(  -7904225283956311, -53), FPR(   8637791633298976, -54),
	FPR(   7014955509902409, -53), FPR(   5649782085062796, -53),
	FPR(  -5649782085062796, -53), FPR(   7014955509902409, -53),
	FPR(   7722587089598028, -56), FPR(   8955321835348103, -53),
	FPR(  -8955321835348103, -53), FPR(   7722587089598028, -56),
	FPR(   8849927271317175, -53), FPR(   6703343293614876, -55),
	FPR(  -6703343293614876, -55), FPR(   8849927271317175, -53),
	FPR(   5072848711672022, -53), FPR(   7442838461440245, -53),
	FPR(  -7442838461440245, -53), FPR(   5072848711672022, -53),
	FPR(   7534952065202888, -53), FPR(   4934990961460965, -53),
	FPR(  -4934990961460965, -53), FPR(   7534952065202888, -53),
	FPR(   7353800509108698, -55), FPR(   8817581275163911, -53),
	FPR(  -8817581275163911, -53), FPR(   7353800509108698, -55),
	FPR(   8352939049913017, -53), FPR(   6740340538294756, -54),
	FPR(  -6740340538294756, -54), FPR(   8352939049913017, -53),
	FPR(   7046699187928017, -54), FPR(   8289490096098815, -53),
	FPR(  -8289490096098815, -53), FPR(   7046699187928017, -54),
	FPR(   6427401098276813, -53), FPR(   6310162718700422, -53),
	FPR(  -6310162718700422, -53), FPR(   6427401098276813, -53),
	FPR(   5305603405682435, -59), FPR(   9006817750781007, -53),
	FPR(  -9006817750781007, -53), FPR(   5305603405682435, -59),
	FPR(   9006817750781007, -53), FPR(   5305603405682435, -59),
	FPR(  -5305603405682435, -59), FPR(   9006817750781007, -53),
	FPR(   6310162718700422, -53), FPR(   6427401098276813, -53),
	FPR(  -6427401098276813, -53), FPR(   6310162718700422, -53),
	FPR(   8289490096098815, -53), FPR(   7046699187928017, -54),
	FPR(  -7046699187928017, -54), FPR(   8289490096098815, -53),
	FPR(   6740340538294756, -54), FPR(   8352939049913017, -53),
	FPR(  -8352939049913017, -53), FPR(   6740340538294756, -54),
	FPR(   8817581275163911, -53), FPR(   7353800509108698, -55),
	FPR(  -7353800509108698, -55), FPR(   8817581275163911, -53),
	FPR(   4934990961460965, -53), FPR(   7534952065202888, -53),
	FPR(  -7534952065202888, -53), FPR(   4934990961460965, -53),
	FPR(   7442838461440245, -53), FPR(   5072848711672022, -53),
	FPR(  -5072848711672022, -53), FPR(   7442838461440245, -53),
	FPR(   6703343293614876, -55), FPR(   8849927271317175, -53),
	FPR(  -8849927271317175, -53), FPR(   6703343293614876, -55),
	FPR(   8955321835348103, -53), FPR(   7722587089598028, -56),
	FPR(  -7722587089598028, -56), FPR(   8955321835348103, -53),
	FPR(   5649782085062796, -53), FPR(   7014955509902409, -53),
	FPR(  -7014955509902409, -53), FPR(   5649782085062796, -53),
	FPR(   7904225283956311, -53), FPR(   8637791633298976, -54),
	FPR(  -8637791633298976, -54), FPR(   7904225283956311, -53),
	FPR(   5070421558241214, -54), FPR(   8643051817502737, -53),
	FPR(  -8643051817502737, -53), FPR(   5070421558241214, -54),
	FPR(   8594922587119653, -53), FPR(   5387743177259695, -54),
	FPR(  -5387743177259695, -54), FPR(   8594922587119653, -53),
	FPR(   8345346354319577, -54), FPR(   7982382913091674, -53),
	FPR(  -7982382913091674, -53), FPR(   8345346354319577, -54),
	FPR(   6909773035871137, -53), FPR(   5777947300499967, -53),
	FPR(  -5777947300499967, -53), FPR(   6909773035871137, -53),
	FPR(   6402573220819241, -56), FPR(   8971573087646471, -53),
	FPR(  -8971573087646471, -53), FPR(   6402573220819241, -56),
	FPR(   8991900931535341, -53), FPR(   8395900745453257, -57),
	FPR(  -8395900745453257, -57), FPR(   8991900931535341, -53),
	FPR(   5987184227491324, -53), FPR(   6729284021401222, -53),
	FPR(  -6729284021401222, -53), FPR(   5987184227491324, -53),
	FPR(   8106622471823008, -53), FPR(   7851703130898649, -54),
	FPR(  -7851703130898649, -54), FPR(   8106622471823008, -53),
	FPR(   5912502916968520, -54), FPR(   8508243986206341, -53),
	FPR(  -8508243986206341, -53), FPR(   5912502916968520, -54),
	FPR(   8716751640241088, -53), FPR(   4537787679899090, -54),
	FPR(  -4537787679899090, -54), FPR(   8716751640241088, -53),
	FPR(   4559323974712726, -53), FPR(   7768024414754142, -53),
	FPR(  -7768024414754142, -53), FPR(   4559323974712726, -53),
	FPR(   7184960348059028, -53), FPR(   5431941016931809, -53),
	FPR(  -5431941016931809, -53), FPR(   7184960348059028, -53),
	FPR(   4958287426364647, -55), FPR(   8921496512746829, -53),
	FPR(  -8921496512746829, -53), FPR(   4958287426364647, -55),
	FPR(   8897168584465961, -53), FPR(   5614309708875923, -55),
	FPR(  -5614309708875923, -55), FPR(   8897168584465961, -53),
	FPR(   5298769122728888, -53), FPR(   7283727356142706, -53),
	FPR(  -7283727356142706, -53), FPR(   5298769122728888, -53),
	FPR(   7682786125052197, -53), FPR(   4701535469536748, -53),
	FPR(  -4701535469536748, -53), FPR(   7682786125052197, -53),
	FPR(   8432250219727258, -55), FPR(   8757037779928840, -53),
	FPR(  -8757037779928840, -53), FPR(   8432250219727258, -55),
	FPR(   8452387612659540, -53), FPR(   6224719129395714, -54),
	FPR(  -6224719129395714, -54), FPR(   8452387612659540, -53),
	FPR(   7551940088880137, -54), FPR(   8177511151817401, -53),
	FPR(  -8177511151817401, -53), FPR(   7551940088880137, -54),
	FPR(   6617939475215195, -53), FPR(   6110034002932808, -53),
	FPR(  -6110034002932808, -53), FPR(   6617939475215195, -53),
	FPR(   5746294458442105, -57), FPR(   9000036357160980, -53),
	FPR(  -9000036357160980, -53), FPR(   5746294458442105, -57),
	FPR(   9002070596517294, -53), FPR(   4862615327261055, -57),
	FPR(  -4862615327261055, -57), FPR(   9002070596517294, -53),
	FPR(   6150525896504412, -53), FPR(   6580324430530404, -53),
	FPR(  -6580324430530404, -53), FPR(   6150525896504412, -53),
	FPR(   8200526129112289, -53), FPR(   7451445395452699, -54),
	FPR(  -7451445395452699, -54), FPR(   8200526129112289, -53),
	FPR(   6328327701619659, -54), FPR(   8433131419575708, -53),
	FPR(  -8433131419575708, -53), FPR(   6328327701619659, -54),
	FPR(   8769807759837646, -53), FPR(   8217162790256110, -55),
	FPR(  -8217162790256110, -55), FPR(   8769807759837646, -53),
	FPR(   4748587653907638, -53), FPR(   7653793419459571, -53),
	FPR(  -7653793419459571, -53), FPR(   4748587653907638, -53),
	FPR(   7316102878153182, -53), FPR(   5253977264024408, -53),
	FPR(  -5253977264024408, -53), FPR(   7316102878153182, -53),
	FPR(   5832572021635720, -55), FPR(   8888388908592136, -53),
	FPR(  -8888388908592136, -53), FPR(   5832572021635720, -55),
	FPR(   8928934438022583, -53), FPR(   4739228994004870, -55),
	FPR(  -4739228994004870, -55), FPR(   8928934438022583, -53),
	FPR(   5475924850081677, -53), FPR(   7151495329710049, -53),
	FPR(  -7151495329710049, -53), FPR(   5475924850081677, -53),
	FPR(   7795853669876749, -53), FPR(   4511574444966625, -53),
	FPR(  -4511574444966625, -53), FPR(   7795853669876749, -53),
	FPR(   4644672222488094, -54), FPR(   8702665878971716, -53),
	FPR(  -8702665878971716, -53), FPR(   4644672222488094, -54),
	FPR(   8526223038860894, -53), FPR(   5807980408439539, -54),
	FPR(  -5807980408439539, -54), FPR(   8526223038860894, -53),
	FPR(   7951037925568809, -54), FPR(   8082381294590617, -53),
	FPR(  -8082381294590617, -53), FPR(   7951037925568809, -54),
	FPR(   6765894016324346, -53), FPR(   5945781409913510, -53),
	FPR(  -5945781409913510, -53), FPR(   6765894016324346, -53),
	FPR(   4639257482637412, -56), FPR(   8988511894135185, -53),
	FPR(  -8988511894135185, -53), FPR(   4639257482637412, -56),
	FPR(   8976314881661062, -53), FPR(   5962064393489674, -56),
	FPR(  -5962064393489674, -56), FPR(   8976314881661062, -53),
	FPR(   5820236102574833, -53), FPR(   6874190143201685, -53),
	FPR(  -6874190143201685, -53), FPR(   5820236102574833, -53),
	FPR(   8007835688282839, -53), FPR(   8247231293972637, -54),
	FPR(  -8247231293972637, -54), FPR(   8007835688282839, -53),
	FPR(   5493116661642923, -54), FPR(   8578231504803418, -53),
	FPR(  -8578231504803418, -53), FPR(   5493116661642923, -54),
	FPR(   8658444875396786, -53), FPR(   4964260571050563, -54),
	FPR(  -4964260571050563, -54), FPR(   8658444875396786, -53),
	FPR(   8734627858479102, -54), FPR(   7877576242606407, -53),
	FPR(  -7877576242606407, -53), FPR(   8734627858479102, -54),
	FPR(   7049489866514174, -53), FPR(   5606632771683968, -53),
	FPR(  -5606632771683968, -53), FPR(   7049489866514174, -53),
	FPR(   8162032288300481, -56), FPR(   8949230140998484, -53),
	FPR(  -8949230140998484, -53), FPR(   8162032288300481, -56),
	FPR(   8860043409240618, -53), FPR(   6486008573510911, -55),
	FPR(  -6486008573510911, -55), FPR(   8860043409240618, -53),
	FPR(   5118421614990306, -53), FPR(   7411571937572131, -53),
	FPR(  -7411571937572131, -53), FPR(   5118421614990306, -53),
	FPR(   7565090757143791, -53), FPR(   4888664464941756, -53),
	FPR(  -4888664464941756, -53), FPR(   7565090757143791, -53),
	FPR(   7570076722248107, -55), FPR(   8806134768774068, -53),
	FPR(  -8806134768774068, -53), FPR(   7570076722248107, -55),
	FPR(   8373460784215450, -53), FPR(   6637708312305582, -54),
	FPR(  -6637708312305582, -54), FPR(   8373460784215450, -53),
	FPR(   7148293245867151, -54), FPR(   8267715182103167, -53),
	FPR(  -8267715182103167, -53), FPR(   7148293245867151, -54),
	FPR(   6465998534826869, -53), FPR(   6270606139937627, -53),
	FPR(  -6270606139937627, -53), FPR(   6465998534826869, -53),
	FPR(   8842450394781643, -59), FPR(   9006139534818257, -53),
	FPR(  -9006139534818257, -53), FPR(   8842450394781643, -59),
	FPR(   9005122242792311, -53), FPR(   6189482235310630, -58),
	FPR(  -6189482235310630, -58), FPR(   9005122242792311, -53),
	FPR(   6230813476397823, -53), FPR(   6504352530186687, -53),
	FPR(  -6504352530186687, -53), FPR(   6230813476397823, -53),
	FPR(   8245628993303844, -53), FPR(   7249618174605810, -54),
	FPR(  -7249618174605810, -54), FPR(   8245628993303844, -53),
	FPR(   6534826180350098, -54), FPR(   8393667262452058, -53),
	FPR(  -8393667262452058, -53), FPR(   6534826180350098, -54),
	FPR(   8794356716387429, -53), FPR(   7786067926277549, -55),
	FPR(  -7786067926277549, -55), FPR(   8794356716387429, -53),
	FPR(   4842153912968527, -53), FPR(   7594944627693494, -53),
	FPR(  -7594944627693494, -53), FPR(   4842153912968527, -53),
	FPR(   7380026372209606, -53), FPR(   5163801812627728, -53),
	FPR(  -5163801812627728, -53), FPR(   7380026372209606, -53),
	FPR(   6268429658850061, -55), FPR(   8869825971537420, -53),
	FPR(  -8869825971537420, -53), FPR(   6268429658850061, -55),
	FPR(   8942801513192182, -53), FPR(   8601170191100479, -56),
	FPR(  -8601170191100479, -56), FPR(   8942801513192182, -53),
	FPR(   5563272371750168, -53), FPR(   7083758813816853, -53),
	FPR(  -7083758813816853, -53), FPR(   5563272371750168, -53),
	FPR(   7850630614963393, -53), FPR(   8831135229857187, -54),
	FPR(  -8831135229857187, -54), FPR(   7850630614963393, -53),
	FPR(   4857912682255224, -54), FPR(   8673511947735049, -53),
	FPR(  -8673511947735049, -53), FPR(   4857912682255224, -54),
	FPR(   8561217456919463, -53), FPR(   5598283333288561, -54),
	FPR(  -5598283333288561, -54), FPR(   8561217456919463, -53),
	FPR(   8148805730028833, -54), FPR(   8032986972986387, -53),
	FPR(  -8032986972986387, -53), FPR(   8148805730028833, -54),
	FPR(   6838348441158650, -53), FPR(   5862305776050047, -53),
	FPR(  -5862305776050047, -53), FPR(   6838348441158650, -53),
	FPR(   5521331097805465, -56), FPR(   8980718722493792, -53),
	FPR(  -8980718722493792, -53), FPR(   5521331097805465, -56),
	FPR(   8984784444342543, -53), FPR(   5080389927126093, -56),
	FPR(  -5080389927126093, -56), FPR(   8984784444342543, -53),
	FPR(   5904154737026182, -53), FPR(   6802249279161855, -53),
	FPR(  -6802249279161855, -53), FPR(   5904154737026182, -53),
	FPR(   8057835820270665, -53), FPR(   8050073368155017, -54),
	FPR(  -8050073368155017, -54), FPR(   8057835820270665, -53),
	FPR(   5703239232730864, -54), FPR(   8543881084037075, -53),
	FPR(  -8543881084037075, -53), FPR(   5703239232730864, -54),
	FPR(   8688252467250769, -53), FPR(   4751381895793102, -54),
	FPR(  -4751381895793102, -54), FPR(   8688252467250769, -53),
	FPR(   8927310113985246, -54), FPR(   7823389415514919, -53),
	FPR(  -7823389415514919, -53), FPR(   8927310113985246, -54),
	FPR(   7117761061603948, -53), FPR(   5519702517755945, -53),
	FPR(  -5519702517755945, -53), FPR(   7117761061603948, -53),
	FPR(   4519992132352091, -55), FPR(   8936036193963400, -53),
	FPR(  -8936036193963400, -53), FPR(   4519992132352091, -55),
	FPR(   8879274589899640, -53), FPR(   6050614741355486, -55),
	FPR(  -6050614741355486, -55), FPR(   8879274589899640, -53),
	FPR(   5208987596045498, -53), FPR(   7348202953025374, -53),
	FPR(  -7348202953025374, -53), FPR(   5208987596045498, -53),
	FPR(   7624512552870645, -53), FPR(   4795461056637271, -53),
	FPR(  -4795461056637271, -53), FPR(   7624512552870645, -53),
	FPR(   8001765989250269, -55), FPR(   8782247561441008, -53),
	FPR(  -8782247561441008, -53), FPR(   8001765989250269, -55),
	FPR(   8413557723860353, -53), FPR(   6431698015882422, -54),
	FPR(  -6431698015882422, -54), FPR(   8413557723860353, -53),
	FPR(   7350670159317696, -54), FPR(   8223232361233372, -53),
	FPR(  -8223232361233372, -53), FPR(   7350670159317696, -54),
	FPR(   6542461640350018, -53), FPR(   6190786226252304, -53),
	FPR(  -6190786226252304, -53), FPR(   6542461640350018, -53),
	FPR(   7957506242722589, -58), FPR(   9003765913003641, -53),
	FPR(  -9003765913003641, -53), FPR(   7957506242722589, -58),
	FPR(   8997663271522660, -53), FPR(   6629757244884614, -57),
	FPR(  -6629757244884614, -57), FPR(   8997663271522660, -53),
	FPR(   6069312070034399, -53), FPR(   6655305358219218, -53),
	FPR(  -6655305358219218, -53), FPR(   6069312070034399, -53),
	FPR(   8154188295849595, -53), FPR(   7652150456031602, -54),
	FPR(  -7652150456031602, -54), FPR(   8154188295849595, -53),
	FPR(   6120876200014774, -54), FPR(   8471325578127065, -53),
	FPR(  -8471325578127065, -53), FPR(   6120876200014774, -54),
	FPR(   8743938102497119, -53), FPR(   8647020179743560, -55),
	FPR(  -8647020179743560, -55), FPR(   8743938102497119, -53),
	FPR(   4654306275012748, -53), FPR(   7711489578089543, -53),
	FPR(  -7711489578089543, -53), FPR(   4654306275012748, -53),
	FPR(   7251077605914050, -53), FPR(   5343361485770773, -53),
	FPR(  -5343361485770773, -53), FPR(   7251077605914050, -53),
	FPR(   5395836020528807, -55), FPR(   8905613286971281, -53),
	FPR(  -8905613286971281, -53), FPR(   5395836020528807, -55),
	FPR(   8913722698169820, -53), FPR(   5177159182005257, -55),
	FPR(  -5177159182005257, -55), FPR(   8913722698169820, -53),
	FPR(   5387752674272799, -53), FPR(   7218154856711858, -53),
	FPR(  -7218154856711858, -53), FPR(   5387752674272799, -53),
	FPR(   7739902697902825, -53), FPR(   4606901848488119, -53),
	FPR(  -4606901848488119, -53), FPR(   7739902697902825, -53),
	FPR(   8861464584337410, -55), FPR(   8730509220737932, -53),
	FPR(  -8730509220737932, -53), FPR(   8861464584337410, -55),
	FPR(   8489944602974586, -53), FPR(   6016802823104436, -54),
	FPR(  -6016802823104436, -54), FPR(   8489944602974586, -53),
	FPR(   7752072724043411, -54), FPR(   8130558439301216, -53),
	FPR(  -8130558439301216, -53), FPR(   7752072724043411, -54),
	FPR(   6692420672738099, -53), FPR(   6028361630966943, -53),
	FPR(  -6028361630966943, -53), FPR(   6692420672738099, -53),
	FPR(   7512970424714007, -57), FPR(   8994951428947667, -53),
	FPR(  -8994951428947667, -53), FPR(   7512970424714007, -57),
	FPR(   8966493518975884, -53), FPR(   6842840994885793, -56),
	FPR(  -6842840994885793, -56), FPR(   8966493518975884, -53),
	FPR(   5735440961974946, -53), FPR(   6945095779491208, -53),
	FPR(  -6945095779491208, -53), FPR(   5735440961974946, -53),
	FPR(   7956629605695492, -53), FPR(   8443147217093086, -54),
	FPR(  -8443147217093086, -54), FPR(   7956629605695492, -53),
	FPR(   5282166847391008, -54), FPR(   8611290075458352, -53),
	FPR(  -8611290075458352, -53), FPR(   5282166847391008, -54),
	FPR(   8627333353592832, -53), FPR(   5176391646926010, -54),
	FPR(  -5176391646926010, -54), FPR(   8627333353592832, -53),
	FPR(   8540630200145957, -54), FPR(   7930576735691761, -53),
	FPR(  -7930576735691761, -53), FPR(   8540630200145957, -54),
	FPR(   6980157044180565, -53), FPR(   5692718687339392, -53),
	FPR(  -5692718687339392, -53), FPR(   6980157044180565, -53),
	FPR(   7282851139856476, -56), FPR(   8961076366892190, -53),
	FPR(  -8961076366892190, -53), FPR(   7282851139856476, -56),
	FPR(   8839477938633966, -53), FPR(   6920425636632580, -55),
	FPR(  -6920425636632580, -55), FPR(   8839477938633966, -53),
	FPR(   5027084818466930, -53), FPR(   7473824766646994, -53),
	FPR(  -7473824766646994, -53), FPR(   5027084818466930, -53),
	FPR(   7504529686575502, -53), FPR(   4981131658359743, -53),
	FPR(  -4981131658359743, -53), FPR(   7504529686575502, -53),
	FPR(   7137247429536506, -55), FPR(   8828695804602461, -53),
	FPR(  -8828695804602461, -53), FPR(   7137247429536506, -55),
	FPR(   8332102832176454, -53), FPR(   6842718994272319, -54),
	FPR(  -6842718994272319, -54), FPR(   8332102832176454, -53),
	FPR(   6944839825747268, -54), FPR(   8310952915477583, -53),
	FPR(  -8310952915477583, -53), FPR(   6944839825747268, -54),
	FPR(   6388561673708188, -53), FPR(   6349481723403377, -53),
	FPR(  -6349481723403377, -53), FPR(   6388561673708188, -53),
	FPR(   7074226654454970, -61), FPR(   9007156865146114, -53),
	FPR(  -9007156865146114, -53), FPR(   7074226654454970, -61)
};

#endif
#endif

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_FFT(unsigned logn, fpr *f)
{
#if TEST_PRECISION
    initialize_GM();
#endif
#if FNDSA_SSE2
	size_t n = (size_t)1 << logn;
	size_t hn = n >> 1;
	size_t t = hn;
	double *ff = (double *)f;
	/* We separate the last iteration of the loop. With that change,
	   t >= 4 and ht >= 2 in all iteration of the loop. */
	for (unsigned lm = 1; lm < (logn - 1); lm ++) {
		size_t m = (size_t)1 << lm;
		size_t hm = m >> 1;
		size_t ht = t >> 1;
		size_t j0 = 0;
		for (size_t i = 0; i < hm; i ++) {
			__m128d s = _mm_loadu_pd(
				(const double *)GM + ((m + i) << 1));
			__m128d s_re = _mm_shuffle_pd(s, s, 0);
			__m128d s_im = _mm_shuffle_pd(s, s, 3);
			for (size_t j = 0; j < ht; j += 2) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + ht;
				__m128d x_re = _mm_loadu_pd(ff + j1);
				__m128d x_im = _mm_loadu_pd(ff + j1 + hn);
				__m128d y_re = _mm_loadu_pd(ff + j2);
				__m128d y_im = _mm_loadu_pd(ff + j2 + hn);
				__m128d z_re = _mm_sub_pd(
					_mm_mul_pd(y_re, s_re),
					_mm_mul_pd(y_im, s_im));
				__m128d z_im = _mm_add_pd(
					_mm_mul_pd(y_re, s_im),
					_mm_mul_pd(y_im, s_re));
				_mm_storeu_pd(ff + j1,
					_mm_add_pd(x_re, z_re));
				_mm_storeu_pd(ff + j1 + hn,
					_mm_add_pd(x_im, z_im));
				_mm_storeu_pd(ff + j2,
					_mm_sub_pd(x_re, z_re));
				_mm_storeu_pd(ff + j2 + hn,
					_mm_sub_pd(x_im, z_im));
			}
			j0 += t;
		}
		t = ht;
	}

	/* Last iteration: m = n/2, hm = n/4, t = 2, ht = 1 */
	if (logn >= 2) {
		__m128d cz = _mm_castsi128_pd(
			_mm_setr_epi32(0, 0, 0, -0x80000000));
		for (size_t i = 0; i < hn; i += 2) {
			/* s <- re(s):im(s) */
			__m128d s = _mm_loadu_pd((const double *)GM + n + i);
			/* xy_re <- re(x):re(y) */
			__m128d xy_re = _mm_loadu_pd(ff + i);
			/* xy_im <- im(x):im(y) */
			__m128d xy_im = _mm_loadu_pd(ff + i + hn);
			/* y1 <- re(y):im(y) */
			__m128d y1 = _mm_shuffle_pd(xy_re, xy_im, 3);
			/* y2 <- im(y):re(y) */
			__m128d y2 = _mm_shuffle_pd(xy_im, xy_re, 3);
			/* z_re <- re(y)*re(s):im(y)*im(s) */
			__m128d z_re = _mm_mul_pd(y1, s);
			/* z_im <- im(y)*re(s):re(y)*im(s) */
			__m128d z_im = _mm_mul_pd(y2, s);
			/* With u = y*s (complex):
			   u_re <- re(u):-re(u)
			   u_im <- im(u):-im(u)  */
			__m128d u_re = _mm_sub_pd(
				z_re,
				_mm_shuffle_pd(z_re, z_re, 1));
			__m128d u_im = _mm_xor_pd(cz,
				_mm_add_pd(
					z_im,
					_mm_shuffle_pd(z_im, z_im, 1)));
			/* u_re <- re(x+z):re(x-z)
			   u_im <- im(x+z):im(x-z) */
			u_re = _mm_add_pd(u_re,
				_mm_shuffle_pd(xy_re, xy_re, 0));
			u_im = _mm_add_pd(u_im,
				_mm_shuffle_pd(xy_im, xy_im, 0));
			_mm_storeu_pd(ff + i, u_re);
			_mm_storeu_pd(ff + i + hn, u_im);
		}
	}
#elif FNDSA_NEON
	size_t n = (size_t)1 << logn;
	size_t hn = n >> 1;
	size_t t = hn;
	float64_t *ff = (float64_t *)f;
	/* We separate the last iteration of the loop. With that change,
	   t >= 4 and ht >= 2 in all iteration of the loop. */
	for (unsigned lm = 1; lm < (logn - 1); lm ++) {
		size_t m = (size_t)1 << lm;
		size_t hm = m >> 1;
		size_t ht = t >> 1;
		size_t j0 = 0;
		for (size_t i = 0; i < hm; i ++) {
			float64x2_t s = vld1q_f64(
				(const float64_t *)GM + ((m + i) << 1));
			float64x2_t s_re = vzip1q_f64(s, s);
			float64x2_t s_im = vzip2q_f64(s, s);
			for (size_t j = 0; j < ht; j += 2) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + ht;
				float64x2_t x_re = vld1q_f64(ff + j1);
				float64x2_t x_im = vld1q_f64(ff + j1 + hn);
				float64x2_t y_re = vld1q_f64(ff + j2);
				float64x2_t y_im = vld1q_f64(ff + j2 + hn);
				float64x2_t z_re = vsubq_f64(
					vmulq_f64(y_re, s_re),
					vmulq_f64(y_im, s_im));
				float64x2_t z_im = vaddq_f64(
					vmulq_f64(y_re, s_im),
					vmulq_f64(y_im, s_re));
				vst1q_f64(ff + j1, vaddq_f64(x_re, z_re));
				vst1q_f64(ff + j1 + hn, vaddq_f64(x_im, z_im));
				vst1q_f64(ff + j2, vsubq_f64(x_re, z_re));
				vst1q_f64(ff + j2 + hn, vsubq_f64(x_im, z_im));
			}
			j0 += t;
		}
		t = ht;
	}

	/* Last iteration: m = n/2, hm = n/4, t = 2, ht = 1 */
	if (logn >= 2) {
		static const union { fpr f[2]; float64x2_t x; }
			cz = { { FPR_ZERO, FPR_NZERO } };
		for (size_t i = 0; i < hn; i += 2) {
			/* s <- re(s):im(s) */
			float64x2_t s = vld1q_f64(
				(const float64_t *)GM + n + i);
			/* xy_re <- re(x):re(y) */
			float64x2_t xy_re = vld1q_f64(ff + i);
			/* xy_im <- im(x):im(y) */
			float64x2_t xy_im = vld1q_f64(ff + i + hn);
			/* y1 <- re(y):im(y) */
			float64x2_t y1 = vzip2q_f64(xy_re, xy_im);
			/* y2 <- im(y):re(y) */
			float64x2_t y2 = vzip2q_f64(xy_im, xy_re);
			/* z_re <- re(y)*re(s):im(y)*im(s) */
			float64x2_t z_re = vmulq_f64(y1, s);
			/* z_im <- im(y)*re(s):re(y)*im(s) */
			float64x2_t z_im = vmulq_f64(y2, s);
			/* With u = y*s (complex):
			   u_re <- re(u):-re(u)
			   u_im <- im(u):-im(u)  */
			float64x2_t u_re = vsubq_f64(
				z_re,
				vextq_f64(z_re, z_re, 1));
			float64x2_t u_im = vreinterpretq_f64_u64(
				veorq_u64(cz.x, vreinterpretq_u64_f64(
					vaddq_f64(
						z_im,
						vextq_f64(z_im, z_im, 1)))));
			/* u_re <- re(x+z):re(x-z)
			   u_im <- im(x+z):im(x-z) */
			u_re = vaddq_f64(u_re, vdupq_laneq_f64(xy_re, 0));
			u_im = vaddq_f64(u_im, vdupq_laneq_f64(xy_im, 0));
			vst1q_f64(ff + i, u_re);
			vst1q_f64(ff + i + hn, u_im);
		}
	}
#elif FNDSA_RV64D
	size_t hn = (size_t)1 << (logn - 1);
	size_t t = hn;
	f64 *ff = (f64 *)f;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm;
		size_t hm = m >> 1;
		size_t ht = t >> 1;
		size_t j0 = 0;
		for (size_t i = 0; i < hm; i ++) {
			f64 s_re = ((const f64 *)GM)[((m + i) << 1) + 0];
			f64 s_im = ((const f64 *)GM)[((m + i) << 1) + 1];
			for (size_t j = 0; j < ht; j ++) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + ht;
				f64 x_re = ff[j1];
				f64 x_im = ff[j1 + hn];
				f64 y_re = ff[j2];
				f64 y_im = ff[j2 + hn];
				f64 z_re = f64_sub(
					f64_mul(y_re, s_re),
					f64_mul(y_im, s_im));
				f64 z_im = f64_add(
					f64_mul(y_im, s_re),
					f64_mul(y_re, s_im));
				ff[j1] = f64_add(x_re, z_re);
				ff[j1 + hn] = f64_add(x_im, z_im);
				ff[j2] = f64_sub(x_re, z_re);
				ff[j2 + hn] = f64_sub(x_im, z_im);
			}
			j0 += t;
		}
		t = ht;
	}
#else
	size_t hn = (size_t)1 << (logn - 1);
	size_t t = hn;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm;
		size_t hm = m >> 1;
		size_t ht = t >> 1;
		size_t j0 = 0;
		for (size_t i = 0; i < hm; i ++) {
			fpr s_re = GM[((m + i) << 1) + 0];
			fpr s_im = GM[((m + i) << 1) + 1];
			for (size_t j = 0; j < ht; j ++) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + ht;
				fpr x_re = f[j1];
				fpr x_im = f[j1 + hn];
				fpr y_re = f[j2];
				fpr y_im = f[j2 + hn];
				fpr z_re, z_im;
                fpr s_im_r = s_im;
                fpr s_re_r = s_re;
                fpr z_re_r, z_im_r;

				FPC_MUL(z_re, z_im, y_re, y_im, s_re_r, s_im_r);
				FPR_ADD_SUB(f[j1], f[j2], x_re, z_re);
				FPR_ADD_SUB(f[j1 + hn], f[j2 + hn], x_im, z_im);
			}
			j0 += t;
		}
		t = ht;
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_iFFT(unsigned logn, fpr *f)
{
#if TEST_PRECISION
    initialize_GM();
#endif
#if FNDSA_SSE2
	size_t n = (size_t)1 << logn;
	size_t hn = n >> 1;
	double *ff = (double *)f;

	/* Applying the reverse process of fpoly_FFT(), we separate the
	   first iteration (for which t = 1). */
	if (logn >= 2) {
		__m128d cz = _mm_castsi128_pd(
			_mm_setr_epi32(0, 0, 0, -0x80000000));
		for (size_t i = 0; i < hn; i += 2) {
			/* s <- re(s):im(s) */
			__m128d s = _mm_loadu_pd((const double *)GM + n + i);
			/* sc <- re(s):-im(s)  (conjugation) */
			__m128d sc = _mm_xor_pd(s, cz);
			/* xy_re <- re(x):re(y) */
			__m128d xy_re = _mm_loadu_pd(ff + i);
			/* xy_im <- im(x):im(y) */
			__m128d xy_im = _mm_loadu_pd(ff + i + hn);
			/* x <- re(x):im(x)
			   y <- re(y):im(y) */
			__m128d x = _mm_shuffle_pd(xy_re, xy_im, 0);
			__m128d y = _mm_shuffle_pd(xy_re, xy_im, 3);
			/* u <- x + y (complex) */
			__m128d u = _mm_add_pd(x, y);
			/* z <- x - y (complex) */
			__m128d z = _mm_sub_pd(x, y);
			/* v <- z*conj(s) (complex) */
			__m128d v1 = _mm_mul_pd(z, s);
			__m128d v2 = _mm_mul_pd(z, _mm_shuffle_pd(sc, sc, 1));
			__m128d v = _mm_add_pd(
				_mm_shuffle_pd(v1, v2, 2),
				_mm_shuffle_pd(v1, v2, 1));
			/* separate re/im and write */
			_mm_storeu_pd(ff + i, _mm_shuffle_pd(u, v, 0));
			_mm_storeu_pd(ff + i + hn, _mm_shuffle_pd(u, v, 3));
		}
	}

	size_t t = 2;
	for (unsigned lm = 2; lm < logn; lm ++) {
		size_t hm = (size_t)1 << (logn - lm);
		size_t m = hm << 1;
		size_t dt = t << 1;
		size_t j0 = 0;
		for (size_t i = 0; i < hm; i += 2) {
			__m128d s = _mm_loadu_pd((const double *)GM + m + i);
			__m128d s_re = _mm_shuffle_pd(s, s, 0);
			__m128d s_im = _mm_shuffle_pd(s, s, 3);
			for (size_t j = 0; j < t; j += 2) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + t;
				__m128d x_re = _mm_loadu_pd(ff + j1);
				__m128d x_im = _mm_loadu_pd(ff + j1 + hn);
				__m128d y_re = _mm_loadu_pd(ff + j2);
				__m128d y_im = _mm_loadu_pd(ff + j2 + hn);
				_mm_storeu_pd(ff + j1,
					_mm_add_pd(x_re, y_re));
				_mm_storeu_pd(ff + j1 + hn,
					_mm_add_pd(x_im, y_im));
				__m128d u_re = _mm_sub_pd(x_re, y_re);
				__m128d u_im = _mm_sub_pd(x_im, y_im);
				/* Note: we loaded s but we want to
				   multiply with conj(s). */
				__m128d z_re = _mm_add_pd(
					_mm_mul_pd(u_re, s_re),
					_mm_mul_pd(u_im, s_im));
				__m128d z_im = _mm_sub_pd(
					_mm_mul_pd(u_im, s_re),
					_mm_mul_pd(u_re, s_im));
				_mm_storeu_pd(ff + j2, z_re);
				_mm_storeu_pd(ff + j2 + hn, z_im);
			}
			j0 += dt;
		}
		t = dt;
	}

	if (n >= 4) {
		/* MM[i] = 1/2^i */
		static const fpr MM[] = {
			FPR(4503599627370496, -52),
			FPR(4503599627370496, -53),
			FPR(4503599627370496, -54),
			FPR(4503599627370496, -55),
			FPR(4503599627370496, -56),
			FPR(4503599627370496, -57),
			FPR(4503599627370496, -58),
			FPR(4503599627370496, -59),
			FPR(4503599627370496, -60),
			FPR(4503599627370496, -61)
		};

		__m128d e = _mm_load_sd((const double *)MM + (logn - 1));
		e = _mm_shuffle_pd(e, e, 0);
		for (size_t i = 0; i < n; i += 2) {
			__m128d x = _mm_loadu_pd(ff + i);
			x = _mm_mul_pd(x, e);
			_mm_storeu_pd(ff + i, x);
		}
	}
#elif FNDSA_NEON
	size_t n = (size_t)1 << logn;
	size_t hn = n >> 1;
	float64_t *ff = (float64_t *)f;

	/* Applying the reverse process of fpoly_FFT(), we separate the
	   first iteration (for which t = 1). */
	if (logn >= 2) {
		static const union { fpr f[2]; float64x2_t x; }
			cz = { { FPR_ZERO, FPR_NZERO } };
		for (size_t i = 0; i < hn; i += 2) {
			/* s <- re(s):im(s) */
			float64x2_t s = vld1q_f64(
				(const float64_t *)GM + n + i);
			/* sc <- re(s):-im(s)  (conjugation) */
			float64x2_t sc = vreinterpretq_f64_u64(
				veorq_u64(cz.x, vreinterpretq_u64_f64(s)));
			/* xy_re <- re(x):re(y) */
			float64x2_t xy_re = vld1q_f64(ff + i);
			/* xy_im <- im(x):im(y) */
			float64x2_t xy_im = vld1q_f64(ff + i + hn);
			/* x <- re(x):im(x)
			   y <- re(y):im(y) */
			float64x2_t x = vzip1q_f64(xy_re, xy_im);
			float64x2_t y = vzip2q_f64(xy_re, xy_im);
			/* u <- x + y (complex) */
			float64x2_t u = vaddq_f64(x, y);
			/* z <- x - y (complex) */
			float64x2_t z = vsubq_f64(x, y);
			/* v <- z*conj(s) (complex) */
			float64x2_t v1 = vmulq_f64(z, s);
			float64x2_t v2 = vmulq_f64(z, vextq_f64(sc, sc, 1));
			float64x2_t v = vpaddq_f64(v1, v2);
			/* separate re/im and write */
			vst1q_f64(ff + i, vzip1q_f64(u, v));
			vst1q_f64(ff + i + hn, vzip2q_f64(u, v));
		}
	}

	size_t t = 2;
	for (unsigned lm = 2; lm < logn; lm ++) {
		size_t hm = (size_t)1 << (logn - lm);
		size_t m = hm << 1;
		size_t dt = t << 1;
		size_t j0 = 0;
		for (size_t i = 0; i < hm; i += 2) {
			float64x2_t s = vld1q_f64(
				(const double *)GM + m + i);
			float64x2_t s_re = vzip1q_f64(s, s);
			float64x2_t s_im = vzip2q_f64(s, s);
			for (size_t j = 0; j < t; j += 2) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + t;
				float64x2_t x_re = vld1q_f64(ff + j1);
				float64x2_t x_im = vld1q_f64(ff + j1 + hn);
				float64x2_t y_re = vld1q_f64(ff + j2);
				float64x2_t y_im = vld1q_f64(ff + j2 + hn);
				vst1q_f64(ff + j1, vaddq_f64(x_re, y_re));
				vst1q_f64(ff + j1 + hn, vaddq_f64(x_im, y_im));
				float64x2_t u_re = vsubq_f64(x_re, y_re);
				float64x2_t u_im = vsubq_f64(x_im, y_im);
				/* Note: we loaded s but we want to
				   multiply with conj(s). */
				float64x2_t z_re = vaddq_f64(
					vmulq_f64(u_re, s_re),
					vmulq_f64(u_im, s_im));
				float64x2_t z_im = vsubq_f64(
					vmulq_f64(u_im, s_re),
					vmulq_f64(u_re, s_im));
				vst1q_f64(ff + j2, z_re);
				vst1q_f64(ff + j2 + hn, z_im);
			}
			j0 += dt;
		}
		t = dt;
	}

	if (n >= 4) {
		/* MM[i] = 1/2^i */
		static const union { fpr f; float64x1_t v; } MM[] = {
			{ FPR(4503599627370496, -52) },
			{ FPR(4503599627370496, -53) },
			{ FPR(4503599627370496, -54) },
			{ FPR(4503599627370496, -55) },
			{ FPR(4503599627370496, -56) },
			{ FPR(4503599627370496, -57) },
			{ FPR(4503599627370496, -58) },
			{ FPR(4503599627370496, -59) },
			{ FPR(4503599627370496, -60) },
			{ FPR(4503599627370496, -61) }
		};

		float64x2_t e = vdupq_lane_f64(MM[logn - 1].v, 0);
		for (size_t i = 0; i < n; i += 2) {
			float64x2_t x = vld1q_f64(ff + i);
			x = vmulq_f64(x, e);
			vst1q_f64(ff + i, x);
		}
	}
#elif FNDSA_RV64D
	size_t n = (size_t)1 << logn;
	size_t hn = n >> 1;
	size_t t = 1;
	f64 *ff = (f64 *)f;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t hm = (size_t)1 << (logn - lm);
		size_t dt = t << 1;
		size_t j0 = 0;
		for (size_t i = 0; i < (hm >> 1); i ++) {
			f64 s_re = ((const f64 *)GM)[((hm + i) << 1) + 0];
			f64 s_im = ((const f64 *)GM)[((hm + i) << 1) + 1];
			for (size_t j = 0; j < t; j ++) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + t;
				f64 x_re = ff[j1];
				f64 x_im = ff[j1 + hn];
				f64 y_re = ff[j2];
				f64 y_im = ff[j2 + hn];
				ff[j1] = f64_add(x_re, y_re);
				ff[j1 + hn] = f64_add(x_im, y_im);
				x_re = f64_sub(x_re, y_re);
				x_im = f64_sub(x_im, y_im);
				/* Note: multiply with conj(s), not s */
				ff[j2] = f64_add(
					f64_mul(x_re, s_re),
					f64_mul(x_im, s_im));
				ff[j2 + hn] = f64_sub(
					f64_mul(x_im, s_re),
					f64_mul(x_re, s_im));
			}
			j0 += dt;
		}
		t = dt;
	}

	/* MM[i] = 1/2^i */
	static const union { fpr f; f64 v; } MM[] = {
		{ FPR(4503599627370496, -52) },
		{ FPR(4503599627370496, -53) },
		{ FPR(4503599627370496, -54) },
		{ FPR(4503599627370496, -55) },
		{ FPR(4503599627370496, -56) },
		{ FPR(4503599627370496, -57) },
		{ FPR(4503599627370496, -58) },
		{ FPR(4503599627370496, -59) },
		{ FPR(4503599627370496, -60) },
		{ FPR(4503599627370496, -61) }
	};
	f64 z = MM[logn - 1].v;

	for (size_t i = 0; i < n; i ++) {
		ff[i] = f64_mul(ff[i], z);
	}
#else
	size_t n = (size_t)1 << logn;
	size_t hn = n >> 1;
	size_t t = 1;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t hm = (size_t)1 << (logn - lm);
		size_t dt = t << 1;
		size_t j0 = 0;
		for (size_t i = 0; i < (hm >> 1); i ++) {
			fpr s_re = GM[((hm + i) << 1) + 0];
			fpr s_im = fpr_neg(GM[((hm + i) << 1) + 1]);
			for (size_t j = 0; j < t; j ++) {
				size_t j1 = j0 + j;
				size_t j2 = j1 + t;
				fpr x_re = f[j1];
				fpr x_im = f[j1 + hn];
				fpr y_re = f[j2];
				fpr y_im = f[j2 + hn];
				FPR_ADD_SUB(f[j1], x_re, x_re, y_re);
				FPR_ADD_SUB(f[j1 + hn], x_im, x_im, y_im);
				FPC_MUL(x_re, x_im, x_re, x_im, s_re, s_im);
				f[j2] = x_re;
				f[j2 + hn] = x_im;
			}
			j0 += dt;
		}
		t = dt;
	}

	for (size_t i = 0; i < n; i ++) {
		f[i] = fpr_div2e(f[i], logn - 1);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_set_small(unsigned logn, fpr *d, const int8_t *f)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	size_t i = 0;
	double *dd = (double *)d;
	for (; (i + 4) <= n; i += 4) {
		__m128i x = _mm_setr_epi32(f[i], f[i + 1], f[i + 2], f[i + 3]);
		__m128d y0 = _mm_cvtepi32_pd(x);
		__m128d y1 = _mm_cvtepi32_pd(_mm_bsrli_si128(x, 8));
		_mm_storeu_pd(dd + i, y0);
		_mm_storeu_pd(dd + i + 2, y1);
	}
	__m128d z = _mm_setzero_pd();
	for (; i < n; i ++) {
		_mm_store_sd(dd + i, _mm_cvtsi32_sd(z, f[i]));
	}
#elif FNDSA_NEON
	size_t i = 0;
	float64_t *dd = (float64_t *)d;
	for (; (i + 8) <= n; i += 8) {
		int8x8_t x1 = vld1_s8(f + i);
		int16x8_t x2 = vmovl_s8(x1);
		int32x4_t x30 = vmovl_s16(vget_low_s16(x2));
		int32x4_t x31 = vmovl_high_s16(x2);
		int64x2_t x40 = vmovl_s32(vget_low_s32(x30));
		int64x2_t x41 = vmovl_high_s32(x30);
		int64x2_t x42 = vmovl_s32(vget_low_s32(x31));
		int64x2_t x43 = vmovl_high_s32(x31);

		float64x2_t y0 = vcvtq_f64_s64(x40);
		float64x2_t y1 = vcvtq_f64_s64(x41);
		float64x2_t y2 = vcvtq_f64_s64(x42);
		float64x2_t y3 = vcvtq_f64_s64(x43);
		vst1q_f64(dd + i + 0, y0);
		vst1q_f64(dd + i + 2, y1);
		vst1q_f64(dd + i + 4, y2);
		vst1q_f64(dd + i + 6, y3);
	}
	for (; i < n; i ++) {
		vst1_f64(dd + i, vcvt_f64_s64(vcreate_s64((uint64_t)f[i])));
	}
#elif FNDSA_RV64D
	f64 *dd = (f64 *)d;
	for (size_t i = 0; i < n; i ++) {
		dd[i] = f64_of(f[i]);
	}
#else
	for (size_t i = 0; i < n; i ++) {
		d[i] = fpr_of(f[i]);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_add(unsigned logn, fpr *a, const fpr *b)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (n >= 2) {
		for (size_t i = 0; i < n; i += 2) {
			__m128d xa = _mm_loadu_pd((const double *)a + i);
			__m128d xb = _mm_loadu_pd((const double *)b + i);
			_mm_storeu_pd((double *)a + i, _mm_add_pd(xa, xb));
		}
	} else {
		__m128d xa = _mm_load_sd((const double *)a);
		__m128d xb = _mm_load_sd((const double *)b);
		_mm_store_sd((double *)a, _mm_add_sd(xa, xb));
	}
#elif FNDSA_NEON
	if (n >= 2) {
		for (size_t i = 0; i < n; i += 2) {
			float64x2_t xa = vld1q_f64((const float64_t *)a + i);
			float64x2_t xb = vld1q_f64((const float64_t *)b + i);
			vst1q_f64((float64_t *)a + i, vaddq_f64(xa, xb));
		}
	} else {
		float64x1_t xa = vld1_f64((const float64_t *)a);
		float64x1_t xb = vld1_f64((const float64_t *)b);
		vst1_f64((float64_t *)a, vadd_f64(xa, xb));
	}
#elif FNDSA_RV64D
	f64 *aa = (f64 *)a;
	const f64 *bb = (const f64 *)b;
	for (size_t i = 0; i < n; i ++) {
		aa[i] = f64_add(aa[i], bb[i]);
	}
#else
	for (size_t i = 0; i < n; i ++) {
		a[i] = fpr_add(a[i], b[i]);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_sub(unsigned logn, fpr *a, const fpr *b)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	if (n >= 2) {
		for (size_t i = 0; i < n; i += 2) {
			__m128d xa = _mm_loadu_pd((const double *)a + i);
			__m128d xb = _mm_loadu_pd((const double *)b + i);
			_mm_storeu_pd((double *)a + i, _mm_sub_pd(xa, xb));
		}
	} else {
		__m128d xa = _mm_load_sd((const double *)a);
		__m128d xb = _mm_load_sd((const double *)b);
		_mm_store_sd((double *)a, _mm_sub_sd(xa, xb));
	}
#elif FNDSA_NEON
	if (n >= 2) {
		for (size_t i = 0; i < n; i += 2) {
			float64x2_t xa = vld1q_f64((const float64_t *)a + i);
			float64x2_t xb = vld1q_f64((const float64_t *)b + i);
			vst1q_f64((float64_t *)a + i, vsubq_f64(xa, xb));
		}
	} else {
		float64x1_t xa = vld1_f64((const float64_t *)a);
		float64x1_t xb = vld1_f64((const float64_t *)b);
		vst1_f64((float64_t *)a, vsub_f64(xa, xb));
	}
#elif FNDSA_RV64D
	f64 *aa = (f64 *)a;
	const f64 *bb = (const f64 *)b;
	for (size_t i = 0; i < n; i ++) {
		aa[i] = f64_sub(aa[i], bb[i]);
	}
#else
	for (size_t i = 0; i < n; i ++) {
		a[i] = fpr_sub(a[i], b[i]);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_neg(unsigned logn, fpr *a)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	__m128d xz = _mm_setzero_pd();
	if (n >= 2) {
		for (size_t i = 0; i < n; i += 2) {
			__m128d xa = _mm_loadu_pd((const double *)a + i);
			_mm_storeu_pd((double *)a + i, _mm_sub_pd(xz, xa));
		}
	} else {
		__m128d xa = _mm_load_sd((const double *)a);
		_mm_store_sd((double *)a, _mm_sub_sd(xz, xa));
	}
#elif FNDSA_NEON
	if (n >= 2) {
		for (size_t i = 0; i < n; i += 2) {
			float64x2_t xa = vld1q_f64((const float64_t *)a + i);
			vst1q_f64((float64_t *)a + i, vnegq_f64(xa));
		}
	} else {
		float64x1_t xa = vld1_f64((const float64_t *)a);
		vst1_f64((float64_t *)a, vneg_f64(xa));
	}
#elif FNDSA_RV64D
	f64 *aa = (f64 *)a;
	for (size_t i = 0; i < n; i ++) {
		aa[i] = f64_neg(aa[i]);
	}
#else
	for (size_t i = 0; i < n; i ++) {
		a[i] = fpr_neg(a[i]);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_mul_fft(unsigned logn, fpr *a, const fpr *b)
{
	size_t hn = (size_t)1 << (logn - 1);
#if FNDSA_SSE2
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			__m128d xar = _mm_loadu_pd((const double *)a + i);
			__m128d xai = _mm_loadu_pd((const double *)a + i + hn);
			__m128d xbr = _mm_loadu_pd((const double *)b + i);
			__m128d xbi = _mm_loadu_pd((const double *)b + i + hn);

			__m128d xcr = _mm_sub_pd(
				_mm_mul_pd(xar, xbr),
				_mm_mul_pd(xai, xbi));
			__m128d xci = _mm_add_pd(
				_mm_mul_pd(xar, xbi),
				_mm_mul_pd(xai, xbr));

			_mm_storeu_pd((double *)a + i, xcr);
			_mm_storeu_pd((double *)a + i + hn, xci);
		}
	} else if (hn >= 1) {
		__m128d xa = _mm_loadu_pd((const double *)a);
		__m128d xb = _mm_loadu_pd((const double *)b);
		__m128d xcr = _mm_mul_pd(xa, xb);
		__m128d xci = _mm_mul_pd(xa, _mm_shuffle_pd(xb, xb, 1));
		xcr = _mm_sub_pd(xcr, _mm_shuffle_pd(xcr, xcr, 1));
		xci = _mm_add_pd(xci, _mm_shuffle_pd(xci, xci, 1));
		__m128d xc = _mm_shuffle_pd(xcr, xci, 0);
		_mm_storeu_pd((double *)a, xc);
	}
#elif FNDSA_NEON
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			float64x2_t xar =
				vld1q_f64((const float64_t *)a + i);
			float64x2_t xai =
				vld1q_f64((const float64_t *)a + i + hn);
			float64x2_t xbr =
				vld1q_f64((const float64_t *)b + i);
			float64x2_t xbi =
				vld1q_f64((const float64_t *)b + i + hn);

			float64x2_t xcr = vsubq_f64(
				vmulq_f64(xar, xbr),
				vmulq_f64(xai, xbi));
			float64x2_t xci = vaddq_f64(
				vmulq_f64(xar, xbi),
				vmulq_f64(xai, xbr));

			vst1q_f64((float64_t *)a + i, xcr);
			vst1q_f64((float64_t *)a + i + hn, xci);
		}
	} else if (hn >= 1) {
		static const union {
			uint64_t u[2];
			float64x2_t x;
		} cz = { { 0, (uint64_t)1 << 63 } };
		float64x2_t xa = vld1q_f64((const float64_t *)a);
		float64x2_t xb = vld1q_f64((const float64_t *)b);
		float64x2_t xcr = vmulq_f64(xa, xb);
		float64x2_t xci = vmulq_f64(xa, vextq_f64(xb, xb, 1));
		xcr = vreinterpretq_f64_u64(
			veorq_u64(vreinterpretq_u64_f64(xcr), cz.x));
		float64x2_t xc = vpaddq_f64(xcr, xci);
		vst1q_f64((float64_t *)a, xc);
	}
#elif FNDSA_RV64D
	f64 *aa = (f64 *)a;
	const f64 *bb = (const f64 *)b;
	for (size_t i = 0; i < hn; i ++) {
		f64 a_re = aa[i];
		f64 a_im = aa[i + hn];
		f64 b_re = bb[i];
		f64 b_im = bb[i + hn];
		aa[i] = f64_sub(f64_mul(a_re, b_re), f64_mul(a_im, b_im));
		aa[i + hn] = f64_add(f64_mul(a_im, b_re), f64_mul(a_re, b_im));
	}
#else
	for (size_t i = 0; i < hn; i ++) {
		FPC_MUL(a[i], a[i + hn], a[i], a[i + hn], b[i], b[i + hn]);
	}
#endif
}

/* unused
TARGET_SSE2 TARGET_NEON
void
fpoly_muladj_fft(unsigned logn, fpr *a, const fpr *b)
{
	size_t hn = (size_t)1 << (logn - 1);
#if FNDSA_SSE2
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			__m128d xar = _mm_loadu_pd((const double *)a + i);
			__m128d xai = _mm_loadu_pd((const double *)a + i + hn);
			__m128d xbr = _mm_loadu_pd((const double *)b + i);
			__m128d xbi = _mm_loadu_pd((const double *)b + i + hn);

			__m128d xcr = _mm_add_pd(
				_mm_mul_pd(xar, xbr),
				_mm_mul_pd(xai, xbi));
			__m128d xci = _mm_sub_pd(
				_mm_mul_pd(xai, xbr),
				_mm_mul_pd(xar, xbi));

			_mm_storeu_pd((double *)a + i, xcr);
			_mm_storeu_pd((double *)a + i + hn, xci);
		}
	} else if (hn >= 1) {
		__m128d xa = _mm_loadu_pd((const double *)a);
		__m128d xb = _mm_loadu_pd((const double *)b);
		__m128d xcr = _mm_mul_pd(xa, xb);
		__m128d xci = _mm_mul_pd(xa, _mm_shuffle_pd(xb, xb, 1));
		xcr = _mm_add_pd(xcr, _mm_shuffle_pd(xcr, xcr, 1));
		xci = _mm_sub_pd(xci, _mm_shuffle_pd(xci, xci, 1));
		__m128d xc = _mm_shuffle_pd(xcr, xci, 2);
		_mm_storeu_pd((double *)a, xc);
	}
#elif FNDSA_NEON
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			float64x2_t xar =
				vld1q_f64((const float64_t *)a + i);
			float64x2_t xai =
				vld1q_f64((const float64_t *)a + i + hn);
			float64x2_t xbr =
				vld1q_f64((const float64_t *)b + i);
			float64x2_t xbi =
				vld1q_f64((const float64_t *)b + i + hn);

			float64x2_t xcr = vaddq_f64(
				vmulq_f64(xar, xbr),
				vmulq_f64(xai, xbi));
			float64x2_t xci = vsubq_f64(
				vmulq_f64(xai, xbr),
				vmulq_f64(xar, xbi));

			vst1q_f64((float64_t *)a + i, xcr);
			vst1q_f64((float64_t *)a + i + hn, xci);
		}
	} else if (hn >= 1) {
		static const union {
			uint64_t u[2];
			float64x2_t x;
		} cz = { { 0, (uint64_t)1 << 63 } };
		float64x2_t xa = vld1q_f64((const float64_t *)a);
		float64x2_t xb = vld1q_f64((const float64_t *)b);
		float64x2_t xcr = vmulq_f64(xa, xb);
		xb = vreinterpretq_f64_u64(
			veorq_u64(vreinterpretq_u64_f64(xb), cz.x));
		float64x2_t xci = vmulq_f64(xa, vextq_f64(xb, xb, 1));
		float64x2_t xc = vpaddq_f64(xcr, xci);
		vst1q_f64((float64_t *)a, xc);
	}
#elif FNDSA_RV64D
	f64 *aa = (f64 *)a;
	const f64 *bb = (const f64 *)b;
	for (size_t i = 0; i < hn; i ++) {
		f64 a_re = aa[i];
		f64 a_im = aa[i + hn];
		f64 b_re = bb[i];
		f64 b_im = bb[i + hn];
		aa[i] = f64_add(f64_mul(a_re, b_re), f64_mul(a_im, b_im));
		aa[i + hn] = f64_sub(f64_mul(a_im, b_re), f64_mul(a_re, b_im));
	}
#else
	for (size_t i = 0; i < hn; i ++) {
		FPC_MUL(a[i], a[i + hn],
			a[i], a[i + hn], b[i], fpr_neg(b[i + hn]));
	}
#endif
}
*/

/* unused
TARGET_SSE2 TARGET_NEON
void
fpoly_mulownadj_fft(unsigned logn, fpr *a)
{
	size_t hn = (size_t)1 << (logn - 1);
#if FNDSA_SSE2
	__m128d xz = _mm_setzero_pd();
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			__m128d xar = _mm_loadu_pd((const double *)a + i);
			__m128d xai = _mm_loadu_pd((const double *)a + i + hn);
			__m128d xcr = _mm_add_pd(
				_mm_mul_pd(xar, xar),
				_mm_mul_pd(xai, xai));
			_mm_storeu_pd((double *)a + i, xcr);
			_mm_storeu_pd((double *)a + i + hn, xz);
		}
	} else if (hn >= 1) {
		__m128d xa = _mm_loadu_pd((const double *)a);
		__m128d xcr = _mm_mul_pd(xa, xa);
		xcr = _mm_add_pd(xcr, _mm_shuffle_pd(xcr, xcr, 1));
		__m128d xc = _mm_shuffle_pd(xcr, xz, 2);
		_mm_storeu_pd((double *)a, xc);
	}
#elif FNDSA_NEON
	float64x2_t xz = vdupq_lane_f64(vcreate_f64(0), 0);
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			float64x2_t xar = vld1q_f64(
				(const float64_t *)a + i);
			float64x2_t xai = vld1q_f64(
				(const float64_t *)a + i + hn);
			float64x2_t xcr = vaddq_f64(
				vmulq_f64(xar, xar),
				vmulq_f64(xai, xai));
			vst1q_f64((float64_t *)a + i, xcr);
			vst1q_f64((float64_t *)a + i + hn, xz);
		}
	} else if (hn >= 1) {
		float64x2_t xa = vld1q_f64((const float64_t *)a);
		float64x2_t xcr = vmulq_f64(xa, xa);
		float64x2_t xc = vpaddq_f64(xa, xz);
		vst1q_f64((float64_t *)a, xc);
	}
#elif FNDSA_RV64D
	f64 *aa = (f64 *)a;
	for (size_t i = 0; i < hn; i ++) {
		f64 a_re = aa[i];
		f64 a_im = aa[i + hn];
		aa[i] = f64_add(f64_mul(a_re, a_re), f64_mul(a_im, a_im));
	}
	memset(aa + hn, 0, hn * sizeof(f64));
#else
	for (size_t i = 0; i < hn; i ++) {
		a[i] = fpr_add(fpr_sqr(a[i]), fpr_sqr(a[i + hn]));
		a[i + hn] = FPR_ZERO;
	}
#endif
}
*/

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_mulconst(unsigned logn, fpr *a, fpr x)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	__m128d xx = _mm_load_sd((const double *)&x);
	if (n >= 2) {
		xx = _mm_shuffle_pd(xx, xx, 0);
		for (size_t i = 0; i < n; i += 2) {
			__m128d xa = _mm_loadu_pd((const double *)a + i);
			_mm_storeu_pd((double *)a + i, _mm_mul_pd(xa, xx));
		}
	} else {
		__m128d xa = _mm_load_sd((const double *)a);
		_mm_store_sd((double *)a, _mm_mul_sd(xa, xx));
	}
#elif FNDSA_NEON
	float64x1_t x1 = vld1_f64((const float64_t *)&x);
	if (n >= 2) {
		float64x2_t x2 = vdupq_lane_f64(x1, 0);
		for (size_t i = 0; i < n; i += 2) {
			float64x2_t xa = vld1q_f64((const float64_t *)a + i);
			vst1q_f64((float64_t *)a + i, vmulq_f64(xa, x2));
		}
	} else {
		float64x1_t xa = vld1_f64((const float64_t *)a);
		vst1_f64((float64_t *)a, vmul_f64(xa, x1));
	}
#elif FNDSA_RV64D
	f64 z = f64_from_raw(x);
	f64 *aa = (f64 *)a;
	for (size_t i = 0; i < n; i ++) {
		aa[i] = f64_mul(aa[i], z);
	}
#else
	for (size_t i = 0; i < n; i ++) {
		a[i] = fpr_mul(a[i], x);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_LDL_fft(unsigned logn, const fpr *g00, fpr *g01, fpr *g11)
{
	size_t hn = (size_t)1 << (logn - 1);
#if FNDSA_SSE2
	static const union {
		fpr f[2];
		__m128d x;
	} one = { { FPR_ONE, FPR_ONE } };
	__m128d nz = _mm_castsi128_pd(
		_mm_setr_epi32(0, -0x80000000, 0, -0x80000000));
	const double *p00 = (const double *)g00;
	double *p01 = (double *)g01;
	double *p11 = (double *)g11;
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			__m128d g00_re = _mm_loadu_pd(p00 + i);
			__m128d g01_re = _mm_loadu_pd(p01 + i);
			__m128d g01_im = _mm_loadu_pd(p01 + i + hn);
			__m128d g11_re = _mm_loadu_pd(p11 + i);
			__m128d inv_g00_re = _mm_div_pd(one.x, g00_re);
			__m128d mu_re = _mm_mul_pd(g01_re, inv_g00_re);
			__m128d mu_im = _mm_mul_pd(g01_im, inv_g00_re);
			__m128d zo_re = _mm_add_pd(
				_mm_mul_pd(mu_re, g01_re),
				_mm_mul_pd(mu_im, g01_im));
			_mm_storeu_pd(p11 + i, _mm_sub_pd(g11_re, zo_re));
			_mm_storeu_pd(p01 + i, mu_re);
			_mm_storeu_pd(p01 + i + hn, _mm_xor_pd(nz, mu_im));
		}
	} else {
		__m128d g00_re = _mm_load_sd(p00);
		__m128d g01_re = _mm_load_sd(p01);
		__m128d g01_im = _mm_load_sd(p01 + 1);
		__m128d g11_re = _mm_load_sd(p11);
		__m128d inv_g00_re = _mm_div_sd(one.x, g00_re);
		__m128d mu_re = _mm_mul_sd(g01_re, inv_g00_re);
		__m128d mu_im = _mm_mul_sd(g01_im, inv_g00_re);
		__m128d zo_re = _mm_add_sd(
			_mm_mul_sd(mu_re, g01_re),
			_mm_mul_sd(mu_im, g01_im));
		_mm_store_sd(p11, _mm_sub_sd(g11_re, zo_re));
		_mm_store_sd(p01, mu_re);
		_mm_store_sd(p01 + 1, _mm_xor_pd(nz, mu_im));
	}
#elif FNDSA_NEON
	static const union {
		fpr f[2];
		float64x1_t s;
		float64x2_t x;
	} one = { { FPR_ONE, FPR_ONE } };
	const float64_t *p00 = (const float64_t *)g00;
	float64_t *p01 = (float64_t *)g01;
	float64_t *p11 = (float64_t *)g11;
	if (hn >= 2) {
		for (size_t i = 0; i < hn; i += 2) {
			float64x2_t g00_re = vld1q_f64(p00 + i);
			float64x2_t g01_re = vld1q_f64(p01 + i);
			float64x2_t g01_im = vld1q_f64(p01 + i + hn);
			float64x2_t g11_re = vld1q_f64(p11 + i);
			float64x2_t inv_g00_re = vdivq_f64(one.x, g00_re);
			float64x2_t mu_re = vmulq_f64(g01_re, inv_g00_re);
			float64x2_t mu_im = vmulq_f64(g01_im, inv_g00_re);
			float64x2_t zo_re = vaddq_f64(
				vmulq_f64(mu_re, g01_re),
				vmulq_f64(mu_im, g01_im));
			vst1q_f64(p11 + i, vsubq_f64(g11_re, zo_re));
			vst1q_f64(p01 + i, mu_re);
			vst1q_f64(p01 + i + hn, vnegq_f64(mu_im));
		}
	} else {
		float64x1_t g00_re = vld1_f64(p00);
		float64x1_t g01_re = vld1_f64(p01);
		float64x1_t g01_im = vld1_f64(p01 + 1);
		float64x1_t g11_re = vld1_f64(p11);
		float64x1_t inv_g00_re = vdiv_f64(one.s, g00_re);
		float64x1_t mu_re = vmul_f64(g01_re, inv_g00_re);
		float64x1_t mu_im = vmul_f64(g01_im, inv_g00_re);
		float64x1_t zo_re = vadd_f64(
			vmul_f64(mu_re, g01_re),
			vmul_f64(mu_im, g01_im));
		vst1_f64(p11, vsub_f64(g11_re, zo_re));
		vst1_f64(p01, mu_re);
		vst1_f64(p01 + 1, vneg_f64(mu_im));
	}
#elif FNDSA_RV64D
	const f64 *gg00 = (const f64 *)g00;
	f64 *gg01 = (f64 *)g01;
	f64 *gg11 = (f64 *)g11;
	for (size_t i = 0; i < hn; i ++) {
		f64 g00_re = gg00[i];
		f64 g01_re = gg01[i], g01_im = gg01[i + hn];
		f64 g11_re = gg11[i];
		f64 inv_g00_re = f64_inv(g00_re);
		f64 mu_re = f64_mul(g01_re, inv_g00_re);
		f64 mu_im = f64_mul(g01_im, inv_g00_re);
		f64 zo_re = f64_add(
			f64_mul(mu_re, g01_re),
			f64_mul(mu_im, g01_im));
		gg11[i] = f64_sub(g11_re, zo_re);
		gg01[i] = mu_re;
		gg01[i + hn] = f64_neg(mu_im);
	}
#else
	for (size_t i = 0; i < hn; i ++) {
		fpr g00_re = g00[i];
		fpr g01_re = g01[i], g01_im = g01[i + hn];
		fpr g11_re = g11[i];
		fpr inv_g00_re = fpr_inv(g00_re);
		fpr mu_re = fpr_mul(g01_re, inv_g00_re);
		fpr mu_im = fpr_mul(g01_im, inv_g00_re);
		fpr zo_re = fpr_add(
			fpr_mul(mu_re, g01_re),
			fpr_mul(mu_im, g01_im));
		g11[i] = fpr_sub(g11_re, zo_re);
		g01[i] = mu_re;
		g01[i + hn] = fpr_neg(mu_im);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_split_fft(unsigned logn, fpr *f0, fpr *f1, const fpr *f)
{
#if TEST_PRECISION
    initialize_GM();
#endif
	size_t hn = (size_t)1 << (logn - 1);
	size_t qn = hn >> 1;

	if (logn == 1) {
		f0[0] = f[0];
		f1[0] = f[hn];
	}

#if FNDSA_SSE2
	static union {
		fpr f[2];
		__m128d x;
	} h = { {
		FPR(4503599627370496, -53), FPR(4503599627370496, -53)
	} };
	const double *ff = (const double *)f;
	double *ff0 = (double *)f0;
	double *ff1 = (double *)f1;
	__m128d cz = _mm_castsi128_pd(_mm_setr_epi32(0, 0, 0, -0x80000000));
	for (size_t i = 0; i < qn; i ++) {
		__m128d ab_re = _mm_loadu_pd(ff + (i << 1));
		__m128d ab_im = _mm_loadu_pd(ff + (i << 1) + hn);
		__m128d a = _mm_shuffle_pd(ab_re, ab_im, 0);
		__m128d b = _mm_shuffle_pd(ab_re, ab_im, 3);
		__m128d u = _mm_add_pd(a, b);
		__m128d v = _mm_sub_pd(a, b);
		__m128d s = _mm_loadu_pd((const double *)GM + ((i + hn) << 1));
		__m128d sc = _mm_xor_pd(s, cz);
		/* We compute w = v*conj(s) */
		__m128d w1 = _mm_mul_pd(v, s);
		__m128d w2 = _mm_mul_pd(v, _mm_shuffle_pd(sc, sc, 1));
		__m128d w = _mm_add_pd(
			_mm_shuffle_pd(w1, w2, 0),
			_mm_shuffle_pd(w1, w2, 3));
		u = _mm_mul_pd(u, h.x);
		w = _mm_mul_pd(w, h.x);
		_mm_store_sd(ff0 + i, u);
		_mm_store_sd(ff0 + i + qn, _mm_shuffle_pd(u, u, 1));
		_mm_store_sd(ff1 + i, w);
		_mm_store_sd(ff1 + i + qn, _mm_shuffle_pd(w, w, 1));
	}
#elif FNDSA_NEON
	static union { fpr f[2]; uint64x2_t w; float64x2_t x; }
		h = { {
			FPR(4503599627370496, -53), FPR(4503599627370496, -53)
		} },
		cz = { {
			FPR_ZERO, FPR_NZERO,
		} };
	const float64_t *ff = (const float64_t *)f;
	float64_t *ff0 = (float64_t *)f0;
	float64_t *ff1 = (float64_t *)f1;
	for (size_t i = 0; i < qn; i ++) {
		float64x2_t ab_re = vld1q_f64(ff + (i << 1));
		float64x2_t ab_im = vld1q_f64(ff + (i << 1) + hn);
		float64x2_t a = vzip1q_f64(ab_re, ab_im);
		float64x2_t b = vzip2q_f64(ab_re, ab_im);
		float64x2_t u = vaddq_f64(a, b);
		float64x2_t v = vsubq_f64(a, b);
		float64x2_t s = vld1q_f64(
			(const float64_t *)GM + ((i + hn) << 1));
		float64x2_t sc = vreinterpretq_f64_u64(
			veorq_u64(vreinterpretq_u64_f64(s), cz.w));
		/* We compute w = v*conj(s) */
		float64x2_t w1 = vmulq_f64(v, s);
		float64x2_t w2 = vmulq_f64(v, vextq_f64(sc, sc, 1));
		float64x2_t w = vaddq_f64(
			vzip1q_f64(w1, w2),
			vzip2q_f64(w1, w2));
		u = vmulq_f64(u, h.x);
		w = vmulq_f64(w, h.x);
		vst1_f64(ff0 + i, vget_low_f64(u));
		vst1_f64(ff0 + i + qn, vget_high_f64(u));
		vst1_f64(ff1 + i, vget_low_f64(w));
		vst1_f64(ff1 + i + qn, vget_high_f64(w));
	}
#elif FNDSA_RV64D
	const f64 *ff = (const f64 *)f;
	f64 *ff0 = (f64 *)f0;
	f64 *ff1 = (f64 *)f1;
	for (size_t i = 0; i < qn; i ++) {
		f64 a_re = ff[(i << 1) + 0], a_im = ff[(i << 1) + 0 + hn];
		f64 b_re = ff[(i << 1) + 1], b_im = ff[(i << 1) + 1 + hn];
		f64 t_re, t_im;

		t_re = f64_add(a_re, b_re);
		t_im = f64_add(a_im, b_im);
		ff0[i] = f64_half(t_re);
		ff0[i + qn] = f64_half(t_im);

		t_re = f64_sub(a_re, b_re);
		t_im = f64_sub(a_im, b_im);
		f64 u_re = ((const f64 *)GM)[((i + hn) << 1) + 0];
		f64 u_im = ((const f64 *)GM)[((i + hn) << 1) + 1];
		f64 v_re = f64_add(f64_mul(t_re, u_re), f64_mul(t_im, u_im));
		f64 v_im = f64_sub(f64_mul(t_im, u_re), f64_mul(t_re, u_im));
		ff1[i] = f64_half(v_re);
		ff1[i + qn] = f64_half(v_im);
	}
#else
	for (size_t i = 0; i < qn; i ++) {
		fpr a_re = f[(i << 1) + 0], a_im = f[(i << 1) + 0 + hn];
		fpr b_re = f[(i << 1) + 1], b_im = f[(i << 1) + 1 + hn];
		fpr t_re, t_im, u_re, u_im;

		FPR_ADD_SUB(t_re, u_re, a_re, b_re);
		FPR_ADD_SUB(t_im, u_im, a_im, b_im);
		f0[i] = fpr_half(t_re);
		f0[i + qn] = fpr_half(t_im);
		FPC_MUL(u_re, u_im, u_re, u_im,
			GM[((i + hn) << 1) + 0],
			fpr_neg(GM[((i + hn) << 1) + 1]));
		f1[i] = fpr_half(u_re);
		f1[i + qn] = fpr_half(u_im);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_split_selfadj_fft(unsigned logn, fpr *f0, fpr *f1, const fpr *f)
{
#if TEST_PRECISION
    initialize_GM();
#endif
	size_t hn = (size_t)1 << (logn - 1);
	size_t qn = hn >> 1;

	if (logn == 1) {
		f0[0] = f[0];
		f1[0] = FPR_ZERO;
	}

#if FNDSA_SSE2
	static union { fpr f[2]; __m128d x; }
		h = { {
			FPR(4503599627370496, -53), FPR(4503599627370496, -53)
		} };
	const double *ff = (const double *)f;
	double *ff0 = (double *)f0;
	double *ff1 = (double *)f1;
	for (size_t i = 0; i < qn; i ++) {
		__m128d ab_re = _mm_loadu_pd(ff + (i << 1));
		__m128d t = _mm_shuffle_pd(ab_re, ab_re, 1);
		__m128d u = _mm_mul_pd(h.x, _mm_add_pd(ab_re, t));
		__m128d v = _mm_mul_pd(h.x, _mm_sub_pd(ab_re, t));
		__m128d s = _mm_loadu_pd((const double *)GM + ((i + hn) << 1));
		__m128d w = _mm_mul_pd(v, s);
		_mm_store_sd(ff0 + i, u);
		_mm_store_sd(ff0 + i + qn, _mm_setzero_pd());
		_mm_store_sd(ff1 + i, w);
		_mm_store_sd(ff1 + i + qn, _mm_shuffle_pd(w, w, 1));
	}
#elif FNDSA_NEON
	static union { fpr f[2]; float64x2_t x; }
		h = { {
			FPR(4503599627370496, -53), FPR(4503599627370496, -53)
		} };
	const float64_t *ff = (const float64_t *)f;
	float64_t *ff0 = (float64_t *)f0;
	float64_t *ff1 = (float64_t *)f1;
	float64x1_t z1 = vcreate_f64(0);
	for (size_t i = 0; i < qn; i ++) {
		float64x2_t ab_re = vld1q_f64(ff + (i << 1));
		float64x2_t t = vextq_f64(ab_re, ab_re, 1);
		float64x2_t u = vmulq_f64(h.x, vaddq_f64(ab_re, t));
		float64x2_t v = vmulq_f64(h.x, vsubq_f64(ab_re, t));
		float64x2_t s = vld1q_f64(
			(const float64_t *)GM + ((i + hn) << 1));
		float64x2_t w = vmulq_f64(v, s);
		vst1_f64(ff0 + i, vget_low_f64(u));
		vst1_f64(ff0 + i + qn, z1);
		vst1_f64(ff1 + i, vget_low_f64(w));
		vst1_f64(ff1 + i + qn, vget_high_f64(w));
	}
#elif FNDSA_RV64D
	const f64 *ff = (const f64 *)f;
	f64 *ff0 = (f64 *)f0;
	f64 *ff1 = (f64 *)f1;
	for (size_t i = 0; i < qn; i ++) {
		f64 a_re = ff[(i << 1) + 0];
		f64 b_re = ff[(i << 1) + 1];
		f64 t_re;

		t_re = f64_add(a_re, b_re);
		ff0[i] = f64_half(t_re);
		ff0[i + qn] = (f64){ 0.0 };

		t_re = f64_half(f64_sub(a_re, b_re));
		ff1[i] = f64_mul(t_re,
			((const f64 *)GM)[((i + hn) << 1) + 0]);
		ff1[i + qn] = f64_mul(t_re,
			f64_neg(((const f64 *)GM)[((i + hn) << 1) + 1]));
	}
#else
	for (size_t i = 0; i < qn; i ++) {
		fpr a_re = f[(i << 1) + 0];
		fpr b_re = f[(i << 1) + 1];
		fpr t_re, u_re;

		FPR_ADD_SUB(t_re, u_re, a_re, b_re);
		f0[i] = fpr_half(t_re);
		f0[i + qn] = FPR_ZERO;
		u_re = fpr_half(u_re);
		f1[i] = fpr_mul(u_re, GM[((i + hn) << 1) + 0]);
		f1[i + qn] = fpr_mul(u_re, fpr_neg(GM[((i + hn) << 1) + 1]));
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_merge_fft(unsigned logn, fpr *f, const fpr *f0, const fpr *f1)
{
#if TEST_PRECISION
    initialize_GM();
#endif
	size_t hn = (size_t)1 << (logn - 1);
	size_t qn = hn >> 1;

	if (logn == 1) {
		f[0] = f0[0];
		f[hn] = f1[0];
	}

#if FNDSA_SSE2
	const double *ff0 = (const double *)f0;
	const double *ff1 = (const double *)f1;
	double *ff = (double *)f;
	__m128d cz = _mm_castsi128_pd(_mm_setr_epi32(0, 0, 0, -0x80000000));
	for (size_t i = 0; i < qn; i ++) {
		__m128d a_re = _mm_load_sd(ff0 + i);
		__m128d a_im = _mm_load_sd(ff0 + i + qn);
		__m128d b_re = _mm_load_sd(ff1 + i);
		__m128d b_im = _mm_load_sd(ff1 + i + qn);

		__m128d s = _mm_loadu_pd((const double *)GM + ((i + hn) << 1));
		__m128d c1 = _mm_mul_pd(s, _mm_shuffle_pd(b_re, b_im, 0));
		__m128d c2 = _mm_mul_pd(s, _mm_shuffle_pd(b_im, b_re, 0));

		/* c_re <- re(b*s):-re(b*s)
		   c_im <- im(b*s):-im(b*s) */
		__m128d c_re = _mm_sub_pd(c1, _mm_shuffle_pd(c1, c1, 1));
		__m128d c_im = _mm_xor_pd(cz,
			_mm_add_pd(c2, _mm_shuffle_pd(c2, c2, 1)));

		_mm_storeu_pd(ff + (i << 1),
			_mm_add_pd(c_re, _mm_shuffle_pd(a_re, a_re, 0)));
		_mm_storeu_pd(ff + (i << 1) + hn,
			_mm_add_pd(c_im, _mm_shuffle_pd(a_im, a_im, 0)));
	}
#elif FNDSA_NEON
	static const union { fpr f[2]; uint64x2_t w; }
		cz = { { FPR_ZERO, FPR_NZERO } };
	const float64_t *ff0 = (const float64_t *)f0;
	const float64_t *ff1 = (const float64_t *)f1;
	float64_t *ff = (float64_t *)f;
	for (size_t i = 0; i < qn; i ++) {
		float64x1_t a_re = vld1_f64(ff0 + i);
		float64x1_t a_im = vld1_f64(ff0 + i + qn);
		float64x1_t b_re = vld1_f64(ff1 + i);
		float64x1_t b_im = vld1_f64(ff1 + i + qn);
		float64x2_t b = vcombine_f64(b_re, b_im);

		float64x2_t s = vld1q_f64(
			(const float64_t *)GM + ((i + hn) << 1));
		float64x2_t c1 = vmulq_f64(s, b);
		float64x2_t c2 = vmulq_f64(s, vextq_f64(b, b, 1));

		/* c_re <- re(b*s):-re(b*s)
		   c_im <- im(b*s):-im(b*s) */
		float64x2_t c_re = vsubq_f64(c1, vextq_f64(c1, c1, 1));
		float64x2_t c_im = vreinterpretq_f64_u64(
			veorq_u64(cz.w, vreinterpretq_u64_f64(
				vaddq_f64(c2, vextq_f64(c2, c2, 1)))));

		vst1q_f64(ff + (i << 1),
			vaddq_f64(c_re, vdupq_lane_f64(a_re, 0)));
		vst1q_f64(ff + (i << 1) + hn,
			vaddq_f64(c_im, vdupq_lane_f64(a_im, 0)));
	}
#elif FNDSA_RV64D
	const f64 *ff0 = (const f64 *)f0;
	const f64 *ff1 = (const f64 *)f1;
	f64 *ff = (f64 *)f;
	for (size_t i = 0; i < qn; i ++) {
		f64 a_re = ff0[i], a_im = ff0[i + qn];
		f64 b_re = ff1[i], b_im = ff1[i + qn];
		f64 s_re = ((const f64 *)GM)[((i + hn) << 1) + 0];
		f64 s_im = ((const f64 *)GM)[((i + hn) << 1) + 1];
		f64 c_re = f64_sub(f64_mul(b_re, s_re), f64_mul(b_im, s_im));
		f64 c_im = f64_add(f64_mul(b_im, s_re), f64_mul(b_re, s_im));
		ff[(i << 1) + 0] = f64_add(a_re, c_re);
		ff[(i << 1) + 0 + hn] = f64_add(a_im, c_im);
		ff[(i << 1) + 1] = f64_sub(a_re, c_re);
		ff[(i << 1) + 1 + hn] = f64_sub(a_im, c_im);
	}
#else
	for (size_t i = 0; i < qn; i ++) {
		fpr a_re = f0[i], a_im = f0[i + qn];
		fpr b_re = f1[i], b_im = f1[i + qn];
		FPC_MUL(b_re, b_im, b_re, b_im,
			GM[((i + hn) << 1) + 0], GM[((i + hn) << 1) + 1]);
		FPR_ADD_SUB(
			f[(i << 1) + 0], f[(i << 1) + 1],
			a_re, b_re);
		FPR_ADD_SUB(
			f[(i << 1) + 0 + hn], f[(i << 1) + 1 + hn],
			a_im, b_im);
	}
#endif
}

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_gram_fft(unsigned logn, fpr *b00, fpr *b01, fpr *b10, const fpr *b11)
{
	size_t hn = (size_t)1 << (logn - 1);
#if FNDSA_SSE2
	double *p00 = (double *)b00;
	double *p01 = (double *)b01;
	double *p10 = (double *)b10;
	const double *p11 = (const double *)b11;
	for (size_t i = 0; i < hn; i += 2) {
		__m128d b00_re = _mm_loadu_pd(p00 + i);
		__m128d b00_im = _mm_loadu_pd(p00 + i + hn);
		__m128d b01_re = _mm_loadu_pd(p01 + i);
		__m128d b01_im = _mm_loadu_pd(p01 + i + hn);
		__m128d b10_re = _mm_loadu_pd(p10 + i);
		__m128d b10_im = _mm_loadu_pd(p10 + i + hn);
		__m128d b11_re = _mm_loadu_pd(p11 + i);
		__m128d b11_im = _mm_loadu_pd(p11 + i + hn);

		/* g00 = b00*adj(b00) + b01*adj(b01) */
		__m128d g00_re = _mm_add_pd(
			_mm_add_pd(
				_mm_mul_pd(b00_re, b00_re),
				_mm_mul_pd(b00_im, b00_im)),
			_mm_add_pd(
				_mm_mul_pd(b01_re, b01_re),
				_mm_mul_pd(b01_im, b01_im)));
		/* g01 = b00*adj(b10) + b01*adj(b11) */
		__m128d u_re = _mm_add_pd(
			_mm_mul_pd(b00_re, b10_re),
			_mm_mul_pd(b00_im, b10_im));
		__m128d u_im = _mm_sub_pd(
			_mm_mul_pd(b00_im, b10_re),
			_mm_mul_pd(b00_re, b10_im));
		__m128d v_re = _mm_add_pd(
			_mm_mul_pd(b01_re, b11_re),
			_mm_mul_pd(b01_im, b11_im));
		__m128d v_im = _mm_sub_pd(
			_mm_mul_pd(b01_im, b11_re),
			_mm_mul_pd(b01_re, b11_im));
		__m128d g01_re = _mm_add_pd(u_re, v_re);
		__m128d g01_im = _mm_add_pd(u_im, v_im);
		/* g11 = b10*adj(b10) + b11*adj(b11) */
		__m128d g11_re = _mm_add_pd(
			_mm_add_pd(
				_mm_mul_pd(b10_re, b10_re),
				_mm_mul_pd(b10_im, b10_im)),
			_mm_add_pd(
				_mm_mul_pd(b11_re, b11_re),
				_mm_mul_pd(b11_im, b11_im)));

		_mm_storeu_pd(p00 + i, g00_re);
		_mm_storeu_pd(p00 + i + hn, _mm_setzero_pd());
		_mm_storeu_pd(p01 + i, g01_re);
		_mm_storeu_pd(p01 + i + hn, g01_im);
		_mm_storeu_pd(p10 + i, g11_re);
		_mm_storeu_pd(p10 + i + hn, _mm_setzero_pd());
	}
#elif FNDSA_NEON
	float64_t *p00 = (float64_t *)b00;
	float64_t *p01 = (float64_t *)b01;
	float64_t *p10 = (float64_t *)b10;
	const float64_t *p11 = (const float64_t *)b11;
	float64x2_t zero = vdupq_lane_f64(vcreate_f64(0), 0);
	for (size_t i = 0; i < hn; i += 2) {
		float64x2_t b00_re = vld1q_f64(p00 + i);
		float64x2_t b00_im = vld1q_f64(p00 + i + hn);
		float64x2_t b01_re = vld1q_f64(p01 + i);
		float64x2_t b01_im = vld1q_f64(p01 + i + hn);
		float64x2_t b10_re = vld1q_f64(p10 + i);
		float64x2_t b10_im = vld1q_f64(p10 + i + hn);
		float64x2_t b11_re = vld1q_f64(p11 + i);
		float64x2_t b11_im = vld1q_f64(p11 + i + hn);

		/* g00 = b00*adj(b00) + b01*adj(b01) */
		float64x2_t g00_re = vaddq_f64(
			vaddq_f64(
				vmulq_f64(b00_re, b00_re),
				vmulq_f64(b00_im, b00_im)),
			vaddq_f64(
				vmulq_f64(b01_re, b01_re),
				vmulq_f64(b01_im, b01_im)));
		/* g01 = b00*adj(b10) + b01*adj(b11) */
		float64x2_t u_re = vaddq_f64(
			vmulq_f64(b00_re, b10_re),
			vmulq_f64(b00_im, b10_im));
		float64x2_t u_im = vsubq_f64(
			vmulq_f64(b00_im, b10_re),
			vmulq_f64(b00_re, b10_im));
		float64x2_t v_re = vaddq_f64(
			vmulq_f64(b01_re, b11_re),
			vmulq_f64(b01_im, b11_im));
		float64x2_t v_im = vsubq_f64(
			vmulq_f64(b01_im, b11_re),
			vmulq_f64(b01_re, b11_im));
		float64x2_t g01_re = vaddq_f64(u_re, v_re);
		float64x2_t g01_im = vaddq_f64(u_im, v_im);
		/* g11 = b10*adj(b10) + b11*adj(b11) */
		float64x2_t g11_re = vaddq_f64(
			vaddq_f64(
				vmulq_f64(b10_re, b10_re),
				vmulq_f64(b10_im, b10_im)),
			vaddq_f64(
				vmulq_f64(b11_re, b11_re),
				vmulq_f64(b11_im, b11_im)));

		vst1q_f64(p00 + i, g00_re);
		vst1q_f64(p00 + i + hn, zero);
		vst1q_f64(p01 + i, g01_re);
		vst1q_f64(p01 + i + hn, g01_im);
		vst1q_f64(p10 + i, g11_re);
		vst1q_f64(p10 + i + hn, zero);
	}
#elif FNDSA_RV64D
	f64 *bb00 = (f64 *)b00;
	f64 *bb01 = (f64 *)b01;
	f64 *bb10 = (f64 *)b10;
	const f64 *bb11 = (const f64 *)b11;
	for (size_t i = 0; i < hn; i ++) {
		f64 b00_re = bb00[i], b00_im = bb00[i + hn];
		f64 b01_re = bb01[i], b01_im = bb01[i + hn];
		f64 b10_re = bb10[i], b10_im = bb10[i + hn];
		f64 b11_re = bb11[i], b11_im = bb11[i + hn];

		/* g00 = b00*adj(b00) + b01*adj(b01) */
		f64 g00_re = f64_add(
			f64_add(f64_sqr(b00_re), f64_sqr(b00_im)),
			f64_add(f64_sqr(b01_re), f64_sqr(b01_im)));
		/* g01 = b00*adj(b10) + b01*adj(b11) */
		f64 u_re = f64_add(
			f64_mul(b00_re, b10_re),
			f64_mul(b00_im, b10_im));
		f64 u_im = f64_sub(
			f64_mul(b00_im, b10_re),
			f64_mul(b00_re, b10_im));
		f64 v_re = f64_add(
			f64_mul(b01_re, b11_re),
			f64_mul(b01_im, b11_im));
		f64 v_im = f64_sub(
			f64_mul(b01_im, b11_re),
			f64_mul(b01_re, b11_im));
		f64 g01_re = f64_add(u_re, v_re);
		f64 g01_im = f64_add(u_im, v_im);
		/* g11 = b10*adj(b10) + b11*adj(b11) */
		f64 g11_re = f64_add(
			f64_add(f64_sqr(b10_re), f64_sqr(b10_im)),
			f64_add(f64_sqr(b11_re), f64_sqr(b11_im)));

		bb00[i] = g00_re;
		bb00[i + hn] = (f64){ 0.0 };
		bb01[i] = g01_re;
		bb01[i + hn] = g01_im;
		bb10[i] = g11_re;
		bb10[i + hn] = (f64){ 0.0 };
	}
#else
	for (size_t i = 0; i < hn; i ++) {
		fpr b00_re = b00[i], b00_im = b00[i + hn];
		fpr b01_re = b01[i], b01_im = b01[i + hn];
		fpr b10_re = b10[i], b10_im = b10[i + hn];
		fpr b11_re = b11[i], b11_im = b11[i + hn];

		/* g00 = b00*adj(b00) + b01*adj(b01) */
		fpr g00_re = fpr_add(
			fpr_add(fpr_sqr(b00_re), fpr_sqr(b00_im)),
			fpr_add(fpr_sqr(b01_re), fpr_sqr(b01_im)));
		/* g01 = b00*adj(b10) + b01*adj(b11) */
		fpr u_re, u_im, v_re, v_im;
		FPC_MUL(u_re, u_im, b00_re, b00_im, b10_re, fpr_neg(b10_im));
		FPC_MUL(v_re, v_im, b01_re, b01_im, b11_re, fpr_neg(b11_im));
		fpr g01_re = fpr_add(u_re, v_re);
		fpr g01_im = fpr_add(u_im, v_im);
		/* g11 = b10*adj(b10) + b11*adj(b11) */
		fpr g11_re = fpr_add(
			fpr_add(fpr_sqr(b10_re), fpr_sqr(b10_im)),
			fpr_add(fpr_sqr(b11_re), fpr_sqr(b11_im)));

		b00[i] = g00_re;
		b00[i + hn] = FPR_ZERO;
		b01[i] = g01_re;
		b01[i + hn] = g01_im;
		b10[i] = g11_re;
		b10[i + hn] = FPR_ZERO;
	}
#endif
}


#if FNDSA_TW && !TEST_PRECISION
#define INV_Q         FPR(0x1.554e3ap-14, -0x1.ed0b1p-39, 0x1.d7f62ap-66)
#define MINUS_INV_Q   FPR(-0x1.554e3ap-14, 0x1.ed0b1p-39, -0x1.d7f62ap-66)
#else

/* 1/q and -1/q */
#define INV_Q         FPR( 6004310871091074, -66)
#define MINUS_INV_Q   FPR(-6004310871091074, -66)
#endif

/* see sign_inner.h */
TARGET_SSE2 TARGET_NEON
void
fpoly_apply_basis(unsigned logn, fpr *t0, fpr *t1,
	const fpr *b01, const fpr *b11, const uint16_t *hm)
{
	size_t n = (size_t)1 << logn;
#if FNDSA_SSE2
	size_t i = 0;
	double *dd = (double *)t0;
	for (; (i + 4) <= n; i += 4) {
		__m128i x = _mm_setr_epi32(
			hm[i], hm[i + 1], hm[i + 2], hm[i + 3]);
		__m128d y0 = _mm_cvtepi32_pd(x);
		__m128d y1 = _mm_cvtepi32_pd(_mm_bsrli_si128(x, 8));
		_mm_storeu_pd(dd + i, y0);
		_mm_storeu_pd(dd + i + 2, y1);
	}
	__m128d z = _mm_setzero_pd();
	for (; i < n; i ++) {
		_mm_store_sd(dd + i, _mm_cvtsi32_sd(z, hm[i]));
	}
#elif FNDSA_NEON
	size_t i = 0;
	float64_t *dd = (float64_t *)t0;
	for (; (i + 4) <= n; i += 4) {
		uint16x4_t m16 = vld1_u16(hm + i);
		uint32x4_t m32 = vmovl_u16(m16);
		float64x2_t y0 = vcvtq_f64_u64(vmovl_u32(vget_low_u32(m32)));
		float64x2_t y1 = vcvtq_f64_u64(vmovl_high_u32(m32));
		vst1q_f64(dd + i, y0);
		vst1q_f64(dd + i + 2, y1);
	}
	for (; i < n; i ++) {
		vst1_f64(dd + i, vcvt_f64_u64(vcreate_u64(hm[i])));
	}
#elif FNDSA_RV64D
	f64 *tt0 = (f64 *)t0;
	for (size_t i = 0; i < n; i ++) {
		tt0[i] = f64_of(hm[i]);
	}
#else
	for (size_t i = 0; i < n; i ++) {
		t0[i] = fpr_of(hm[i]);
	}
#endif
	fpoly_FFT(logn, t0);
	memcpy(t1, t0, n * sizeof(fpr));
	fpoly_mul_fft(logn, t1, b01);
	fpoly_mulconst(logn, t1, MINUS_INV_Q);
	fpoly_mul_fft(logn, t0, b11);
	fpoly_mulconst(logn, t0, INV_Q);
}
