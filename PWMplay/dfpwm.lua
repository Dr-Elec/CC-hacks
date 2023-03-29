local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")
local args = {...}
local decoder = dfpwm.make_decoder()
while true do 
    for chunk in io.lines(args[1], 16 * 1024) do
        local buffer = decoder(chunk)

        while not speaker.playAudio(buffer,3) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end