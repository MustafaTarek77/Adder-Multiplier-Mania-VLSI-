vsim  registeredFPM

add wave -radix hex registeredFPM/*
add wave -radix bin registeredFPM/clk
force registeredFPM/reset 0 
force -freeze sim:/registeredFPM/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/registeredFPM/enable 1 0
# A = 5.325
force registeredFPM/A 32'h40aa6666
# B = 5.325
force registeredFPM/B 32'h40aa6666
run 300 ps

# A = -2.125
force registeredFPM/A				32'hc0080000
# B = -3.625
force registeredFPM/B				32'hc0680000
run 300 ps

# A = -0.625
force registeredFPM/A				32'hbf200000
# B = 1.625
force registeredFPM/B				32'h3fd00000
run 300 ps

# A = 5.25
force registeredFPM/A				32'h40a80000
# B = -3.0625
force registeredFPM/B				32'hc0440000
run 300 ps

# A = 0.0
force registeredFPM/A				32'h00000000
# B = 5.25
force registeredFPM/B				32'h40a80000
run 300 ps

# A = 0.0
force registeredFPM/A				32'h00000000
# B = -3.125
force registeredFPM/B				32'hc0480000
run 300 ps

# A = 1.0
force registeredFPM/A				32'h3f800000
# B = 3.125
force registeredFPM/B				32'h40480000
run 300 ps

# A = 1.0
force registeredFPM/A				32'h3f800000
# B = -3.125
force registeredFPM/B				32'hc0480000
run 300 ps

# A = 0.0
force registeredFPM/A				32'h00000000
# B = 0.0
force registeredFPM/B				32'h00000000
run 300 ps

# A = high exponent number
force registeredFPM/A				32'h7f000000
# B = high exponent number
force registeredFPM/B				32'h7f000000
run 300 ps

# A = low exponent number
force registeredFPM/A				32'h00800000
# B = low exponent number
force registeredFPM/B				32'h00800000
run 300 ps