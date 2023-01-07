--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	https://github.com/kikito/md5.lua but as a module and cleaned up a little; This is version 0.5.0
]]

local bit_band = bit.band
local bit_bor = bit.bor
local bit_bxor = bit.bxor
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift

module("md5", package.seeall)

Const = {
	0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
	0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
	0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
	0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
	0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
	0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
	0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
	0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
	0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
	0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
	0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
	0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
	0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
	0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
	0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
	0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
	0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
}

local f = function(x, y, z)
	return bit_bor(bit_band(x, y), bit_band(-x - 1, z))
end

local g = function(x, y, z)
	return bit_bor(bit_band(x, z), bit_band(y, -z - 1))
end

local h = function(x, y, z)
	return bit_bxor(x, bit_bxor(y, z))
end

local i = function(x, y, z)
	return bit_bxor(y, bit_bor(x, -z - 1))
end

local z = function(f, a, b, c, d, x, s, ac)
	a = bit_band(a + f(b, c, d) + x + ac, 0xffffffff)
	return bit_bor(bit_lshift(bit_band(a, bit_rshift(0xffffffff, s)), s), bit_rshift(a, 32 - s)) + b
end

local MAX = 2 ^ 31
local SUB = 2 ^ 32

function Fix(a)
	if a > MAX then
		return a - SUB
	end

	return a
end

function Transform(A, B, C, D, X)
	local a, b, c, d = A, B, C, D

	a=z(f,a,b,c,d,X[ 0], 7,Const[ 1]) -- I'm not even gonna try with this cluster fuck
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(f,d,a,b,c,X[ 1],12,Const[ 2])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(f,c,d,a,b,X[ 2],17,Const[ 3])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(f,b,c,d,a,X[ 3],22,Const[ 4])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(f,a,b,c,d,X[ 4], 7,Const[ 5])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(f,d,a,b,c,X[ 5],12,Const[ 6])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(f,c,d,a,b,X[ 6],17,Const[ 7])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(f,b,c,d,a,X[ 7],22,Const[ 8])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(f,a,b,c,d,X[ 8], 7,Const[ 9])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(f,d,a,b,c,X[ 9],12,Const[10])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(f,c,d,a,b,X[10],17,Const[11])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(f,b,c,d,a,X[11],22,Const[12])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(f,a,b,c,d,X[12], 7,Const[13])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(f,d,a,b,c,X[13],12,Const[14])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(f,c,d,a,b,X[14],17,Const[15])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(f,b,c,d,a,X[15],22,Const[16])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)

	a=z(g,a,b,c,d,X[ 1], 5,Const[17])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(g,d,a,b,c,X[ 6], 9,Const[18])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(g,c,d,a,b,X[11],14,Const[19])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(g,b,c,d,a,X[ 0],20,Const[20])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(g,a,b,c,d,X[ 5], 5,Const[21])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(g,d,a,b,c,X[10], 9,Const[22])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(g,c,d,a,b,X[15],14,Const[23])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(g,b,c,d,a,X[ 4],20,Const[24])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(g,a,b,c,d,X[ 9], 5,Const[25])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(g,d,a,b,c,X[14], 9,Const[26])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(g,c,d,a,b,X[ 3],14,Const[27])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(g,b,c,d,a,X[ 8],20,Const[28])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(g,a,b,c,d,X[13], 5,Const[29])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(g,d,a,b,c,X[ 2], 9,Const[30])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(g,c,d,a,b,X[ 7],14,Const[31])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(g,b,c,d,a,X[12],20,Const[32])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)

	a=z(h,a,b,c,d,X[ 5], 4,Const[33])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(h,d,a,b,c,X[ 8],11,Const[34])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(h,c,d,a,b,X[11],16,Const[35])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(h,b,c,d,a,X[14],23,Const[36])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(h,a,b,c,d,X[ 1], 4,Const[37])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(h,d,a,b,c,X[ 4],11,Const[38])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(h,c,d,a,b,X[ 7],16,Const[39])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(h,b,c,d,a,X[10],23,Const[40])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(h,a,b,c,d,X[13], 4,Const[41])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(h,d,a,b,c,X[ 0],11,Const[42])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(h,c,d,a,b,X[ 3],16,Const[43])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(h,b,c,d,a,X[ 6],23,Const[44])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(h,a,b,c,d,X[ 9], 4,Const[45])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(h,d,a,b,c,X[12],11,Const[46])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(h,c,d,a,b,X[15],16,Const[47])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(h,b,c,d,a,X[ 2],23,Const[48])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)

	a=z(i,a,b,c,d,X[ 0], 6,Const[49])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(i,d,a,b,c,X[ 7],10,Const[50])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(i,c,d,a,b,X[14],15,Const[51])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(i,b,c,d,a,X[ 5],21,Const[52])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(i,a,b,c,d,X[12], 6,Const[53])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(i,d,a,b,c,X[ 3],10,Const[54])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(i,c,d,a,b,X[10],15,Const[55])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(i,b,c,d,a,X[ 1],21,Const[56])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(i,a,b,c,d,X[ 8], 6,Const[57])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(i,d,a,b,c,X[15],10,Const[58])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(i,c,d,a,b,X[ 6],15,Const[59])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(i,b,c,d,a,X[13],21,Const[60])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	a=z(i,a,b,c,d,X[ 4], 6,Const[61])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	d=z(i,d,a,b,c,X[11],10,Const[62])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	c=z(i,c,d,a,b,X[ 2],15,Const[63])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)
	b=z(i,b,c,d,a,X[ 9],21,Const[64])
	a=Fix(a) b=Fix(b) c=Fix(c) d=Fix(d)

	return A + a, B + b, C + c, D + d
end

function PseudoRandom(number)
    local a, b, c, d = Fix(Const[65]), Fix(Const[66]), Fix(Const[67]), Fix(Const[68])

    local m = {}

    for i= 0, 15 do
		m[i] = 0
	end

    m[0] = number
    m[1] = 128
    m[14] = 32

    local a,b,c,d = Transform(a,b,c,d,m)

    return bit_rshift( Fix(b) , 16) % 256
end

EngineSpread = {}