--  General Function Package
--
--  Description: This package contains general VHDL functions.
--
--  Notes: None.
--
--  Revision History:
--      Steven Okai     02/16/14    1) Initial revision.
--                                  2) Added bitwise functions and log2().
--      Steven Okai     03/18/14    1) Added vector types.
--                                  2) Added and_reduce and or_reduce.
--

library ieee;
use ieee.std_logic_1164.all;

package GeneralFuncPkg is

    type integer_vector is array (natural range <>) of integer;
    
    type slv_2_vector    is array (natural range <>) of std_logic_vector(1 downto 0);
    type slv_3_vector    is array (natural range <>) of std_logic_vector(2 downto 0);
    type slv_4_vector    is array (natural range <>) of std_logic_vector(3 downto 0);
    type slv_5_vector    is array (natural range <>) of std_logic_vector(4 downto 0);
    type slv_6_vector    is array (natural range <>) of std_logic_vector(5 downto 0);
    type slv_7_vector    is array (natural range <>) of std_logic_vector(6 downto 0);
    type slv_8_vector    is array (natural range <>) of std_logic_vector(7 downto 0);
    type slv_9_vector    is array (natural range <>) of std_logic_vector(8 downto 0);
    type slv_10_vector   is array (natural range <>) of std_logic_vector(9 downto 0);
    type slv_11_vector   is array (natural range <>) of std_logic_vector(10 downto 0);
    type slv_12_vector   is array (natural range <>) of std_logic_vector(11 downto 0);
    type slv_13_vector   is array (natural range <>) of std_logic_vector(12 downto 0);
    type slv_14_vector   is array (natural range <>) of std_logic_vector(13 downto 0);
    type slv_15_vector   is array (natural range <>) of std_logic_vector(14 downto 0);
    type slv_16_vector   is array (natural range <>) of std_logic_vector(15 downto 0);
    type slv_17_vector   is array (natural range <>) of std_logic_vector(16 downto 0);
    type slv_18_vector   is array (natural range <>) of std_logic_vector(17 downto 0);
    type slv_19_vector   is array (natural range <>) of std_logic_vector(18 downto 0);
    type slv_20_vector   is array (natural range <>) of std_logic_vector(19 downto 0);
    type slv_21_vector   is array (natural range <>) of std_logic_vector(20 downto 0);
    type slv_22_vector   is array (natural range <>) of std_logic_vector(21 downto 0);
    type slv_23_vector   is array (natural range <>) of std_logic_vector(22 downto 0);
    type slv_24_vector   is array (natural range <>) of std_logic_vector(23 downto 0);
    type slv_25_vector   is array (natural range <>) of std_logic_vector(24 downto 0);
    type slv_26_vector   is array (natural range <>) of std_logic_vector(25 downto 0);
    type slv_27_vector   is array (natural range <>) of std_logic_vector(26 downto 0);
    type slv_28_vector   is array (natural range <>) of std_logic_vector(27 downto 0);
    type slv_29_vector   is array (natural range <>) of std_logic_vector(28 downto 0);
    type slv_30_vector   is array (natural range <>) of std_logic_vector(29 downto 0);
    type slv_31_vector   is array (natural range <>) of std_logic_vector(30 downto 0);
    type slv_32_vector   is array (natural range <>) of std_logic_vector(31 downto 0);
    type slv_33_vector   is array (natural range <>) of std_logic_vector(32 downto 0);
    type slv_34_vector   is array (natural range <>) of std_logic_vector(33 downto 0);
    type slv_35_vector   is array (natural range <>) of std_logic_vector(34 downto 0);
    type slv_36_vector   is array (natural range <>) of std_logic_vector(35 downto 0);
    type slv_37_vector   is array (natural range <>) of std_logic_vector(36 downto 0);
    type slv_38_vector   is array (natural range <>) of std_logic_vector(37 downto 0);
    type slv_39_vector   is array (natural range <>) of std_logic_vector(38 downto 0);
    type slv_40_vector   is array (natural range <>) of std_logic_vector(39 downto 0);
    type slv_41_vector   is array (natural range <>) of std_logic_vector(40 downto 0);
    type slv_42_vector   is array (natural range <>) of std_logic_vector(41 downto 0);
    type slv_43_vector   is array (natural range <>) of std_logic_vector(42 downto 0);
    type slv_44_vector   is array (natural range <>) of std_logic_vector(43 downto 0);
    type slv_45_vector   is array (natural range <>) of std_logic_vector(44 downto 0);
    type slv_46_vector   is array (natural range <>) of std_logic_vector(45 downto 0);
    type slv_47_vector   is array (natural range <>) of std_logic_vector(46 downto 0);
    type slv_48_vector   is array (natural range <>) of std_logic_vector(47 downto 0);
    type slv_49_vector   is array (natural range <>) of std_logic_vector(48 downto 0);
    type slv_50_vector   is array (natural range <>) of std_logic_vector(49 downto 0);
    type slv_51_vector   is array (natural range <>) of std_logic_vector(50 downto 0);
    type slv_52_vector   is array (natural range <>) of std_logic_vector(51 downto 0);
    type slv_53_vector   is array (natural range <>) of std_logic_vector(52 downto 0);
    type slv_54_vector   is array (natural range <>) of std_logic_vector(53 downto 0);
    type slv_55_vector   is array (natural range <>) of std_logic_vector(54 downto 0);
    type slv_56_vector   is array (natural range <>) of std_logic_vector(55 downto 0);
    type slv_57_vector   is array (natural range <>) of std_logic_vector(56 downto 0);
    type slv_58_vector   is array (natural range <>) of std_logic_vector(57 downto 0);
    type slv_59_vector   is array (natural range <>) of std_logic_vector(58 downto 0);
    type slv_60_vector   is array (natural range <>) of std_logic_vector(59 downto 0);
    type slv_61_vector   is array (natural range <>) of std_logic_vector(60 downto 0);
    type slv_62_vector   is array (natural range <>) of std_logic_vector(61 downto 0);
    type slv_63_vector   is array (natural range <>) of std_logic_vector(62 downto 0);
    type slv_64_vector   is array (natural range <>) of std_logic_vector(63 downto 0);
    type slv_65_vector   is array (natural range <>) of std_logic_vector(64 downto 0);
    type slv_66_vector   is array (natural range <>) of std_logic_vector(65 downto 0);
    type slv_67_vector   is array (natural range <>) of std_logic_vector(66 downto 0);
    type slv_68_vector   is array (natural range <>) of std_logic_vector(67 downto 0);
    type slv_69_vector   is array (natural range <>) of std_logic_vector(68 downto 0);
    type slv_70_vector   is array (natural range <>) of std_logic_vector(69 downto 0);
    type slv_71_vector   is array (natural range <>) of std_logic_vector(70 downto 0);
    type slv_72_vector   is array (natural range <>) of std_logic_vector(71 downto 0);
    type slv_73_vector   is array (natural range <>) of std_logic_vector(72 downto 0);
    type slv_74_vector   is array (natural range <>) of std_logic_vector(73 downto 0);
    type slv_75_vector   is array (natural range <>) of std_logic_vector(74 downto 0);
    type slv_76_vector   is array (natural range <>) of std_logic_vector(75 downto 0);
    type slv_77_vector   is array (natural range <>) of std_logic_vector(76 downto 0);
    type slv_78_vector   is array (natural range <>) of std_logic_vector(77 downto 0);
    type slv_79_vector   is array (natural range <>) of std_logic_vector(78 downto 0);
    type slv_80_vector   is array (natural range <>) of std_logic_vector(79 downto 0);
    type slv_81_vector   is array (natural range <>) of std_logic_vector(80 downto 0);
    type slv_82_vector   is array (natural range <>) of std_logic_vector(81 downto 0);
    type slv_83_vector   is array (natural range <>) of std_logic_vector(82 downto 0);
    type slv_84_vector   is array (natural range <>) of std_logic_vector(83 downto 0);
    type slv_85_vector   is array (natural range <>) of std_logic_vector(84 downto 0);
    type slv_86_vector   is array (natural range <>) of std_logic_vector(85 downto 0);
    type slv_87_vector   is array (natural range <>) of std_logic_vector(86 downto 0);
    type slv_88_vector   is array (natural range <>) of std_logic_vector(87 downto 0);
    type slv_89_vector   is array (natural range <>) of std_logic_vector(88 downto 0);
    type slv_90_vector   is array (natural range <>) of std_logic_vector(89 downto 0);
    type slv_91_vector   is array (natural range <>) of std_logic_vector(90 downto 0);
    type slv_92_vector   is array (natural range <>) of std_logic_vector(91 downto 0);
    type slv_93_vector   is array (natural range <>) of std_logic_vector(92 downto 0);
    type slv_94_vector   is array (natural range <>) of std_logic_vector(93 downto 0);
    type slv_95_vector   is array (natural range <>) of std_logic_vector(94 downto 0);
    type slv_96_vector   is array (natural range <>) of std_logic_vector(95 downto 0);
    type slv_97_vector   is array (natural range <>) of std_logic_vector(96 downto 0);
    type slv_98_vector   is array (natural range <>) of std_logic_vector(97 downto 0);
    type slv_99_vector   is array (natural range <>) of std_logic_vector(98 downto 0);
    type slv_100_vector  is array (natural range <>) of std_logic_vector(99 downto 0);
    type slv_101_vector  is array (natural range <>) of std_logic_vector(100 downto 0);
    type slv_102_vector  is array (natural range <>) of std_logic_vector(101 downto 0);
    type slv_103_vector  is array (natural range <>) of std_logic_vector(102 downto 0);
    type slv_104_vector  is array (natural range <>) of std_logic_vector(103 downto 0);
    type slv_105_vector  is array (natural range <>) of std_logic_vector(104 downto 0);
    type slv_106_vector  is array (natural range <>) of std_logic_vector(105 downto 0);
    type slv_107_vector  is array (natural range <>) of std_logic_vector(106 downto 0);
    type slv_108_vector  is array (natural range <>) of std_logic_vector(107 downto 0);
    type slv_109_vector  is array (natural range <>) of std_logic_vector(108 downto 0);
    type slv_110_vector  is array (natural range <>) of std_logic_vector(109 downto 0);
    type slv_111_vector  is array (natural range <>) of std_logic_vector(110 downto 0);
    type slv_112_vector  is array (natural range <>) of std_logic_vector(111 downto 0);
    type slv_113_vector  is array (natural range <>) of std_logic_vector(112 downto 0);
    type slv_114_vector  is array (natural range <>) of std_logic_vector(113 downto 0);
    type slv_115_vector  is array (natural range <>) of std_logic_vector(114 downto 0);
    type slv_116_vector  is array (natural range <>) of std_logic_vector(115 downto 0);
    type slv_117_vector  is array (natural range <>) of std_logic_vector(116 downto 0);
    type slv_118_vector  is array (natural range <>) of std_logic_vector(117 downto 0);
    type slv_119_vector  is array (natural range <>) of std_logic_vector(118 downto 0);
    type slv_120_vector  is array (natural range <>) of std_logic_vector(119 downto 0);
    type slv_121_vector  is array (natural range <>) of std_logic_vector(120 downto 0);
    type slv_122_vector  is array (natural range <>) of std_logic_vector(121 downto 0);
    type slv_123_vector  is array (natural range <>) of std_logic_vector(122 downto 0);
    type slv_124_vector  is array (natural range <>) of std_logic_vector(123 downto 0);
    type slv_125_vector  is array (natural range <>) of std_logic_vector(124 downto 0);
    type slv_126_vector  is array (natural range <>) of std_logic_vector(125 downto 0);
    type slv_127_vector  is array (natural range <>) of std_logic_vector(126 downto 0);
    type slv_128_vector  is array (natural range <>) of std_logic_vector(127 downto 0);
    type slv_129_vector  is array (natural range <>) of std_logic_vector(128 downto 0);
    type slv_130_vector  is array (natural range <>) of std_logic_vector(129 downto 0);
    type slv_131_vector  is array (natural range <>) of std_logic_vector(130 downto 0);
    type slv_132_vector  is array (natural range <>) of std_logic_vector(131 downto 0);
    type slv_133_vector  is array (natural range <>) of std_logic_vector(132 downto 0);
    type slv_134_vector  is array (natural range <>) of std_logic_vector(133 downto 0);
    type slv_135_vector  is array (natural range <>) of std_logic_vector(134 downto 0);
    type slv_136_vector  is array (natural range <>) of std_logic_vector(135 downto 0);
    type slv_137_vector  is array (natural range <>) of std_logic_vector(136 downto 0);
    type slv_138_vector  is array (natural range <>) of std_logic_vector(137 downto 0);
    type slv_139_vector  is array (natural range <>) of std_logic_vector(138 downto 0);
    type slv_140_vector  is array (natural range <>) of std_logic_vector(139 downto 0);
    type slv_141_vector  is array (natural range <>) of std_logic_vector(140 downto 0);
    type slv_142_vector  is array (natural range <>) of std_logic_vector(141 downto 0);
    type slv_143_vector  is array (natural range <>) of std_logic_vector(142 downto 0);
    type slv_144_vector  is array (natural range <>) of std_logic_vector(143 downto 0);
    type slv_145_vector  is array (natural range <>) of std_logic_vector(144 downto 0);
    type slv_146_vector  is array (natural range <>) of std_logic_vector(145 downto 0);
    type slv_147_vector  is array (natural range <>) of std_logic_vector(146 downto 0);
    type slv_148_vector  is array (natural range <>) of std_logic_vector(147 downto 0);
    type slv_149_vector  is array (natural range <>) of std_logic_vector(148 downto 0);
    type slv_150_vector  is array (natural range <>) of std_logic_vector(149 downto 0);
    type slv_151_vector  is array (natural range <>) of std_logic_vector(150 downto 0);
    type slv_152_vector  is array (natural range <>) of std_logic_vector(151 downto 0);
    type slv_153_vector  is array (natural range <>) of std_logic_vector(152 downto 0);
    type slv_154_vector  is array (natural range <>) of std_logic_vector(153 downto 0);
    type slv_155_vector  is array (natural range <>) of std_logic_vector(154 downto 0);
    type slv_156_vector  is array (natural range <>) of std_logic_vector(155 downto 0);
    type slv_157_vector  is array (natural range <>) of std_logic_vector(156 downto 0);
    type slv_158_vector  is array (natural range <>) of std_logic_vector(157 downto 0);
    type slv_159_vector  is array (natural range <>) of std_logic_vector(158 downto 0);
    type slv_160_vector  is array (natural range <>) of std_logic_vector(159 downto 0);
    type slv_161_vector  is array (natural range <>) of std_logic_vector(160 downto 0);
    type slv_162_vector  is array (natural range <>) of std_logic_vector(161 downto 0);
    type slv_163_vector  is array (natural range <>) of std_logic_vector(162 downto 0);
    type slv_164_vector  is array (natural range <>) of std_logic_vector(163 downto 0);
    type slv_165_vector  is array (natural range <>) of std_logic_vector(164 downto 0);
    type slv_166_vector  is array (natural range <>) of std_logic_vector(165 downto 0);
    type slv_167_vector  is array (natural range <>) of std_logic_vector(166 downto 0);
    type slv_168_vector  is array (natural range <>) of std_logic_vector(167 downto 0);
    type slv_169_vector  is array (natural range <>) of std_logic_vector(168 downto 0);
    type slv_170_vector  is array (natural range <>) of std_logic_vector(169 downto 0);
    type slv_171_vector  is array (natural range <>) of std_logic_vector(170 downto 0);
    type slv_172_vector  is array (natural range <>) of std_logic_vector(171 downto 0);
    type slv_173_vector  is array (natural range <>) of std_logic_vector(172 downto 0);
    type slv_174_vector  is array (natural range <>) of std_logic_vector(173 downto 0);
    type slv_175_vector  is array (natural range <>) of std_logic_vector(174 downto 0);
    type slv_176_vector  is array (natural range <>) of std_logic_vector(175 downto 0);
    type slv_177_vector  is array (natural range <>) of std_logic_vector(176 downto 0);
    type slv_178_vector  is array (natural range <>) of std_logic_vector(177 downto 0);
    type slv_179_vector  is array (natural range <>) of std_logic_vector(178 downto 0);
    type slv_180_vector  is array (natural range <>) of std_logic_vector(179 downto 0);
    type slv_181_vector  is array (natural range <>) of std_logic_vector(180 downto 0);
    type slv_182_vector  is array (natural range <>) of std_logic_vector(181 downto 0);
    type slv_183_vector  is array (natural range <>) of std_logic_vector(182 downto 0);
    type slv_184_vector  is array (natural range <>) of std_logic_vector(183 downto 0);
    type slv_185_vector  is array (natural range <>) of std_logic_vector(184 downto 0);
    type slv_186_vector  is array (natural range <>) of std_logic_vector(185 downto 0);
    type slv_187_vector  is array (natural range <>) of std_logic_vector(186 downto 0);
    type slv_188_vector  is array (natural range <>) of std_logic_vector(187 downto 0);
    type slv_189_vector  is array (natural range <>) of std_logic_vector(188 downto 0);
    type slv_190_vector  is array (natural range <>) of std_logic_vector(189 downto 0);
    type slv_191_vector  is array (natural range <>) of std_logic_vector(190 downto 0);
    type slv_192_vector  is array (natural range <>) of std_logic_vector(191 downto 0);
    type slv_193_vector  is array (natural range <>) of std_logic_vector(192 downto 0);
    type slv_194_vector  is array (natural range <>) of std_logic_vector(193 downto 0);
    type slv_195_vector  is array (natural range <>) of std_logic_vector(194 downto 0);
    type slv_196_vector  is array (natural range <>) of std_logic_vector(195 downto 0);
    type slv_197_vector  is array (natural range <>) of std_logic_vector(196 downto 0);
    type slv_198_vector  is array (natural range <>) of std_logic_vector(197 downto 0);
    type slv_199_vector  is array (natural range <>) of std_logic_vector(198 downto 0);
    type slv_200_vector  is array (natural range <>) of std_logic_vector(199 downto 0);
    type slv_201_vector  is array (natural range <>) of std_logic_vector(200 downto 0);
    type slv_202_vector  is array (natural range <>) of std_logic_vector(201 downto 0);
    type slv_203_vector  is array (natural range <>) of std_logic_vector(202 downto 0);
    type slv_204_vector  is array (natural range <>) of std_logic_vector(203 downto 0);
    type slv_205_vector  is array (natural range <>) of std_logic_vector(204 downto 0);
    type slv_206_vector  is array (natural range <>) of std_logic_vector(205 downto 0);
    type slv_207_vector  is array (natural range <>) of std_logic_vector(206 downto 0);
    type slv_208_vector  is array (natural range <>) of std_logic_vector(207 downto 0);
    type slv_209_vector  is array (natural range <>) of std_logic_vector(208 downto 0);
    type slv_210_vector  is array (natural range <>) of std_logic_vector(209 downto 0);
    type slv_211_vector  is array (natural range <>) of std_logic_vector(210 downto 0);
    type slv_212_vector  is array (natural range <>) of std_logic_vector(211 downto 0);
    type slv_213_vector  is array (natural range <>) of std_logic_vector(212 downto 0);
    type slv_214_vector  is array (natural range <>) of std_logic_vector(213 downto 0);
    type slv_215_vector  is array (natural range <>) of std_logic_vector(214 downto 0);
    type slv_216_vector  is array (natural range <>) of std_logic_vector(215 downto 0);
    type slv_217_vector  is array (natural range <>) of std_logic_vector(216 downto 0);
    type slv_218_vector  is array (natural range <>) of std_logic_vector(217 downto 0);
    type slv_219_vector  is array (natural range <>) of std_logic_vector(218 downto 0);
    type slv_220_vector  is array (natural range <>) of std_logic_vector(219 downto 0);
    type slv_221_vector  is array (natural range <>) of std_logic_vector(220 downto 0);
    type slv_222_vector  is array (natural range <>) of std_logic_vector(221 downto 0);
    type slv_223_vector  is array (natural range <>) of std_logic_vector(222 downto 0);
    type slv_224_vector  is array (natural range <>) of std_logic_vector(223 downto 0);
    type slv_225_vector  is array (natural range <>) of std_logic_vector(224 downto 0);
    type slv_226_vector  is array (natural range <>) of std_logic_vector(225 downto 0);
    type slv_227_vector  is array (natural range <>) of std_logic_vector(226 downto 0);
    type slv_228_vector  is array (natural range <>) of std_logic_vector(227 downto 0);
    type slv_229_vector  is array (natural range <>) of std_logic_vector(228 downto 0);
    type slv_230_vector  is array (natural range <>) of std_logic_vector(229 downto 0);
    type slv_231_vector  is array (natural range <>) of std_logic_vector(230 downto 0);
    type slv_232_vector  is array (natural range <>) of std_logic_vector(231 downto 0);
    type slv_233_vector  is array (natural range <>) of std_logic_vector(232 downto 0);
    type slv_234_vector  is array (natural range <>) of std_logic_vector(233 downto 0);
    type slv_235_vector  is array (natural range <>) of std_logic_vector(234 downto 0);
    type slv_236_vector  is array (natural range <>) of std_logic_vector(235 downto 0);
    type slv_237_vector  is array (natural range <>) of std_logic_vector(236 downto 0);
    type slv_238_vector  is array (natural range <>) of std_logic_vector(237 downto 0);
    type slv_239_vector  is array (natural range <>) of std_logic_vector(238 downto 0);
    type slv_240_vector  is array (natural range <>) of std_logic_vector(239 downto 0);
    type slv_241_vector  is array (natural range <>) of std_logic_vector(240 downto 0);
    type slv_242_vector  is array (natural range <>) of std_logic_vector(241 downto 0);
    type slv_243_vector  is array (natural range <>) of std_logic_vector(242 downto 0);
    type slv_244_vector  is array (natural range <>) of std_logic_vector(243 downto 0);
    type slv_245_vector  is array (natural range <>) of std_logic_vector(244 downto 0);
    type slv_246_vector  is array (natural range <>) of std_logic_vector(245 downto 0);
    type slv_247_vector  is array (natural range <>) of std_logic_vector(246 downto 0);
    type slv_248_vector  is array (natural range <>) of std_logic_vector(247 downto 0);
    type slv_249_vector  is array (natural range <>) of std_logic_vector(248 downto 0);
    type slv_250_vector  is array (natural range <>) of std_logic_vector(249 downto 0);
    type slv_251_vector  is array (natural range <>) of std_logic_vector(250 downto 0);
    type slv_252_vector  is array (natural range <>) of std_logic_vector(251 downto 0);
    type slv_253_vector  is array (natural range <>) of std_logic_vector(252 downto 0);
    type slv_254_vector  is array (natural range <>) of std_logic_vector(253 downto 0);
    type slv_255_vector  is array (natural range <>) of std_logic_vector(254 downto 0);
    type slv_256_vector  is array (natural range <>) of std_logic_vector(255 downto 0);
    type slv_512_vector  is array (natural range <>) of std_logic_vector(511 downto 0);
    type slv_1024_vector is array (natural range <>) of std_logic_vector(1024 downto 0);
    type slv_2048_vector is array (natural range <>) of std_logic_vector(2048 downto 0);

    function bitwise_and (A : std_logic_vector; B : std_logic_vector) return std_logic_vector;
    function bitwise_or (A : std_logic_vector; B : std_logic_vector) return std_logic_vector;
    function bitwise_xor (A : std_logic_vector; B : std_logic_vector) return std_logic_vector;
    function bitwise_not (A : std_logic_vector) return std_logic_vector;
    function and_reduce (A : std_logic_vector) return std_logic_vector;
    function or_reduce (A : std_logic_vector) return std_logic_vector;
    
    function log2(x : integer) return integer;
    
end package GeneralFuncPkg;

package body GeneralFuncPkg is
    -- This function returns the bitwise AND of two std_logic_vectors or equal length.
    function bitwise_and (A : std_logic_vector; B : std_logic_vector) return std_logic_vector is
        
        variable C : std_logic_vector(A'range);
        
        begin
        
        -- Check that the vectors are the same width.
        assert A'length = B'length
            report "Vectors are different lengths."
            severity failure;
        
        -- Go through vector and-ing bits.
        for i in A'range loop
            C(i) := A(i) and B(i);
        end loop;
        
        return C; -- Return result.
        
    end bitwise_and;
    
    -- This function returns the bitwise OR of two std_logic_vectors or equal length.
    function bitwise_or (A : std_logic_vector; B : std_logic_vector) return std_logic_vector is
        
        variable C : std_logic_vector(A'range);
        
        begin
        
        -- Check that the vectors are the same width.
        assert A'length = B'length
            report "Vectors are different lengths."
            severity failure;
        
        -- Go through vector or-ing bits.
        for i in A'range loop
            C(i) := A(i) or B(i);
        end loop;
        
        return C; -- Return result.
        
    end bitwise_or;
    
    -- This function returns the bitwise XOR of two std_logic_vectors or equal length.
    function bitwise_xor (A : std_logic_vector; B : std_logic_vector) return std_logic_vector is
        
        variable C : std_logic_vector(A'range);
        
        begin
        
        -- Check that the vectors are the same width.
        assert A'length = B'length
            report "Vectors are different lengths."
            severity failure;
        
        -- Go through vector or-ing bits.
        for i in A'range loop
            C(i) := A(i) xor B(i);
        end loop;
        
        return C; -- Return result.
        
    end bitwise_xor;
    
    -- This function returns the bitwise XOR of two std_logic_vectors or equal length.
    function bitwise_not (A : std_logic_vector) return std_logic_vector is
        
        variable C : std_logic_vector(A'range);
        constant ONES : std_logic_vector(A'range) := (others=>'1');
        begin
        
        -- XOR vector with all ones will flip all bits.
        C := bitwise_xor(A, ONES);
        
        return C; -- Return result.
        
    end bitwise_not;

    -- This function returns the and of all bits in the passed std_logic_vector.
    function and_reduce (A : std_logic_vector) return std_logic is
        
        variable B : std_logic := '1';
        begin
        
        -- And all bits together.
        for i in A'range loop
            B := B and A(i);
        end loop;
        
        return B;   -- Return result.
        
    end and_reduce;
    
    function or_reduce (A : std_logic_vector) return std_logic is
    
        variable B : std_logic := '0';
        begin
        
        -- Or all bits together.
        for i in A'range loop
            B := B or A(i);
        end loop;
        
        return B;   -- Return result.
        
    end or_reduce;
    
    -- This function returns ceil(log2(x)).
    function log2 (x : integer) return integer is
        variable xTemp : integer := x; -- Make a copy of x.
        variable DivCount : integer := 0; -- Number of times x can be divided by 2.
        
        begin
        
        -- Count how many times can be divided by 2.
        while (xTemp > 1) loop
            DivCount := DivCount + 1; -- Increment div count.
            xTemp := xTemp/2; -- Divide by 2.
        end loop;
        
        -- Number of times divided by 2 is log2(x).
        return DivCount;
        
    end log2;
    
end GeneralFuncPkg;