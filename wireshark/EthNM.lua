-- Author: Insub Song
-- https://mika-s.github.io/wireshark/lua/dissector/2017/11/04/creating-a-wireshark-dissector-in-lua-1.html
-- https://github.com/Cisco-Talos/Winbox_Protocol_Dissector/blob/master/Winbox_Dissector.lua

protocol = Proto("EthNM", "EthNM Protocol") -- name, description

function parenthesis(string)
    if string ~= nil then
        return " (" .. string .. ")"
    else
        return ""
    end
end

local SRC_ID = {
    [0x01] = "CCU_MCU"         ,
    [0x02] = "CCU_AP"          ,
    [0x03] = "DCU"             ,
    [0x30] = "ADAS_PRK_Master" ,
    [0x41] = "ccIC_HU"         ,
    [0x50] = "HDM"             ,
    [0x51] = "ADAS_DRV_Master" ,
    [0x52] = "ADAS_VP_Master"  ,
    [0x53] = "ADAS_DRV_Slave1" ,
    [0x5D] = "DVRS_ETH"        ,
}

local NM_STATE = {
    [0x00] = "DEFAULT"                         ,
    [0x01] = "RepeatMessage - BusSleep"        ,
    [0x02] = "RepeatMessage - PrepareBusSleep" ,
    [0x04] = "Normal - RepeatMessage"          ,
    [0x08] = "Normal - ReadySleep"             ,
    [0x10] = "RepeatMessage - ReadySleep"      ,
    [0x20] = "RepeatMessage - Normal"          ,
    [0xFF] = "??"
}



-- Mandatory: fields table
local f = protocol.fields
f.SrcNodeId = ProtoField.uint8("protocol.SourceNodeIdentifier", "Source Node Identifier", base.HEX)
f.ControlBitVector = ProtoField.uint8("protocol.ControlBitVector", "Control Bit Vector", base.HEX)

f.PnInfo = ProtoField.uint8("protocol.PnInfo", "PN Info", base.DEC, nil, 0x40)
f.ActiveWakeUp = ProtoField.uint8("protocol.ActiveWakeUp", "Active Wake Up", base.DEC, nil, 0x10)
f.RepeatMessageRequest = ProtoField.uint8("protocol.RepeatMessageRequest", "Repeat Message Request", base.DEC, nil, 0x01)
-- f.Reserved = ProtoField.uint8("protocol.Reserved", "Reserved", base.HEX, nil, 0xAE)

f.NetworkRequestReason = ProtoField.uint8("protocol.NetworkRequestReason", "Network Request Reason", base.HEX)
f.NMState = ProtoField.uint8("protocol.NMState", "NM State (Current - Previous)", base.HEX)

f.UserData = ProtoField.bytes("protocol.UserData", "User Data", base.SPACE)

f.PNI = ProtoField.bytes("protocol.PNI", "PNI", base.SPACE)
f.PNC_1 = ProtoField.uint32("protocol.PNC_1", "All ECUs", base.DEC, nil, 0x00000001)
f.PNC_2 = ProtoField.uint32("protocol.PNC_2", "OTA ECUs", base.DEC, nil, 0x00000002)
f.PNC_16 = ProtoField.uint32("protocol.PNC_16", "ADAS_VP", base.DEC, nil, 0x00008000)
f.PNC_17 = ProtoField.uint32("protocol.PNC_17", "ADAS_DRV", base.DEC, nil, 0x00010000)
f.PNC_18 = ProtoField.uint32("protocol.PNC_18", "ADAS_PRK", base.DEC, nil, 0x00020000)
f.PNC_19 = ProtoField.uint32("protocol.PNC_19", "HDM", base.DEC, nil, 0x00040000)
f.PNC_20 = ProtoField.uint32("protocol.PNC_20", "ccIC", base.DEC, nil, 0x00080000)
f.PNC_21 = ProtoField.uint32("protocol.PNC_21", "DVRS", base.DEC, nil, 0x00100000)


-- Mandatory: dissector function
function protocol.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end

    pinfo.cols.protocol = "EthNM" -- protocol.name
    local subtree = tree:add(protocol, buffer(), "EthNM Protocol Data")

    subtree:add(f.SrcNodeId, buffer(0, 1)):append_text(parenthesis( SRC_ID[buffer(0, 1):uint()] ))

    subtree:add(f.ControlBitVector, buffer(1, 1))
    subtree:add(f.PnInfo, buffer(1, 1))
    subtree:add(f.ActiveWakeUp, buffer(1, 1))
    subtree:add(f.RepeatMessageRequest, buffer(1, 1))
    -- subtree:add(f.Reserved, buffer(1, 1))

    subtree:add(f.NetworkRequestReason, buffer(2, 1))
    subtree:add(f.NMState, buffer(3, 1)):append_text(parenthesis( NM_STATE[buffer(3, 1):uint()] ))

    if bit.band(buffer(1, 1):uint(), 0x40) == 0 then
        subtree:add(f.UserData, buffer(4, length-4))
    else
        subtree:add(f.PNI, buffer(4, length-4))
        subtree:add_le(f.PNC_1, buffer(4, 4))
        subtree:add_le(f.PNC_2, buffer(4, 4))
        subtree:add_le(f.PNC_16, buffer(4, 4))
        subtree:add_le(f.PNC_17, buffer(4, 4))
        subtree:add_le(f.PNC_18, buffer(4, 4))
        subtree:add_le(f.PNC_19, buffer(4, 4))
        subtree:add_le(f.PNC_20, buffer(4, 4))
        subtree:add_le(f.PNC_21, buffer(4, 4))
    end
end


local udp_port = DissectorTable.get("udp.port")
udp_port:add(13800, protocol)
