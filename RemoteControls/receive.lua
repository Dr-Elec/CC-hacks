local modem = peripheral.find("modem")
local Iport,Oport = 16,15
modem.open(Iport)