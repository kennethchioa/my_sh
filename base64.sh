#!/usr/bin/awk -f
#
##########################################################################################
#
# AWK script to decode argument from BASE64 to ASCII
#
# (C) March 10, 2003, Peter van Eerten
# Revised for standard AWK at October 18,2005
# This code is released under the well-known GPL license.
#
# With GNU Awk, run as follows:
#       gawk --traditional -f b64dec.awk <BASE64 string>
#
##########################################################################################

# Bitwise AND between 2 variables - var AND x
function and(var, x, l_res, l_i)
{
l_res=0;

for (l_i=0; l_i < 8; l_i++){
        if (var%2 == 1 && x%2 == 1) l_res=l_res/2 + 128;
        else l_res/=2;
        var=int(var/2);
        x=int(x/2);
}
return l_res;
}

# Rotate bytevalue left x times
function lshift(var, x)
{
while(x > 0){
    var*=2;
    x--;
}
return var;
}

# Rotate bytevalue right x times
function rshift(var, x)
{
while(x > 0){
    var=int(var/2);
    x--;
}
return var;
}

# This is the main program
BEGIN {

if (ARGC < 2) {
    print "\nDecode a BASE64 string to ASCII.";
    print "\nUsage: b64dec.awk <string>\n";
    print "Examples:"
    print "---------"
    print "b64dec.awk VGhpcyBpcyBzb21lIHRleHQ=\n"
    exit;
}
else ARGC = 1;

BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

result = ""

while (length(ARGV[1]) > 0){
	# Specify byte values
	base1 = substr(ARGV[1], 1, 1)
	base2 = substr(ARGV[1], 2, 1)
	base3 = substr(ARGV[1], 3, 1)
	base4 = substr(ARGV[1], 4, 1)
	# Now find numerical position in BASE64 string
	byte1 = index(BASE64, base1) - 1
	if (byte1 < 0) byte1 = 0
	byte2 = index(BASE64, base2) - 1
	if (byte2 < 0) byte2 = 0
	byte3 = index(BASE64, base3) - 1
	if (byte3 < 0) byte3 = 0
	byte4 = index(BASE64, base4) - 1
	if (byte4 < 0) byte4 = 0
	# Reconstruct ASCII string
	result = result sprintf( "%c", lshift(and(byte1, 63), 2) + rshift(and(byte2, 48), 4) )
	result = result sprintf( "%c", lshift(and(byte2, 15), 4) + rshift(and(byte3, 60), 2) )
	result = result sprintf( "%c", lshift(and(byte3, 3), 6) + byte4 )
	# Decrease incoming string with 4
	ARGV[1] = substr(ARGV[1], 5)
}
print "\nBase64 decoded: " result
print
}