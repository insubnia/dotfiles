-- Author: Insub Song
-- https://mika-s.github.io/wireshark/lua/dissector/2017/11/04/creating-a-wireshark-dissector-in-lua-1.html

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
    [0x00] = "DEFAULT"  ,
    [0x01] = "RMS_BSM"  ,
    [0x02] = "RMS_PBSM" ,
    [0x04] = "NS_RMS"   ,
    [0x08] = "NS_RSS"   ,
    [0x10] = "RMS_RSS"  ,
    [0x20] = "RMS_NS"   ,
}



-- Mandatory: fields table
local f = protocol.fields
f.SrcNodeId = ProtoField.uint8("protocol.SourceNodeIdentifier", "Source Node Identifier", base.HEX)
f.ControlBitVector = ProtoField.uint8("protocol.ControlBitVector", "Control Bit Vector", base.HEX)

f.NetworkRequestReason = ProtoField.uint8("protocol.NetworkRequestReason", "Network Request Reason", base.HEX)
f.NMState = ProtoField.uint8("protocol.NMState", "NM State (Current - Previous)", base.HEX)

f.UserData = ProtoField.bytes("protocol.UserData", "User Data", base.SPACE)

-- Mandatory: dissector function
function protocol.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end

    pinfo.cols.protocol = "EthNM" -- protocol.name
    local subtree = tree:add(protocol, buffer(), "EthNM Protocol Data")

    subtree:add(f.SrcNodeId, buffer(0, 1)):append_text(parenthesis( SRC_ID[buffer(0, 1):uint()] ))

    subtree:add(f.ControlBitVector, buffer(1, 1))
    subtree:add(f.NetworkRequestReason, buffer(2, 1))

    subtree:add(f.NMState, buffer(3, 1)):append_text(parenthesis( NM_STATE[buffer(3, 1):uint()] ))

    subtree:add(f.UserData, buffer(4, length-4))
end


local udp_port = DissectorTable.get("udp.port")
udp_port:add(13800, protocol)
