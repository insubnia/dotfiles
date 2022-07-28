-- Author: Insub Song
-- https://mika-s.github.io/wireshark/lua/dissector/2017/11/04/creating-a-wireshark-dissector-in-lua-1.html
-- https://github.com/Cisco-Talos/Winbox_Protocol_Dissector/blob/master/Winbox_Dissector.lua

protocol = Proto("EthDiag", "EthDiag Protocol") -- name, description

function parenthesis(string)
    if string ~= nil then
        return " (" .. string .. ")"
    else
        return ""
    end
end

local SID = {
    [0x10] = "SessionControl"       ,
    [0x11] = "ECUReset"             ,
    [0x27] = "SecurityAccess"       ,
    [0x28] = "CommunicationControl" ,
    [0x3E] = "TesterPresent"        ,
    [0x85] = "ControlDTC"           ,
    [0x22] = "ReadDataById"         ,
    [0x2E] = "WriteDataById"        ,
    [0x31] = "RoutineControl"       ,
    [0x19] = "ReadDTC"              ,
    [0x14] = "ClearDTC"             ,
    [0x34] = "RequestDownload"      ,
    [0x36] = "TransferData"         ,
    [0x37] = "RequestTransferExit"  ,
    [0x20] = "???"                  ,
}
local SID_copy = {}
for k, v in pairs(SID) do SID_copy[k] = v end  -- deep copy
for k, v in pairs(SID_copy) do
    if v ~= nil then
        SID[k + 0x40] = v .. " - Positive"
    end
end

local NRC = {
    [0x10] = "General Reject"                              ,
    [0x11] = "Service Not Supported"                       ,
    [0x12] = "Sub-function Not Supported"                  ,
    [0x22] = "Conditions Not Correct"                      ,
    [0x31] = "Request Out Of Range"                        ,
    [0x33] = "Security Access Denied"                      ,
    [0x36] = "Exceed Number Of Attempts"                   ,
    [0x78] = "Request Correctly Received-Response Pending" ,
}

local MSG_ID = {
    [0x5D5] = "to ADAS_DRV_Master"   ,
    [0x5DD] = "from ADAS_DRV_Master" ,
    [0x5A7] = "to ADAS_DRV_Slave1"   ,
    [0x5AF] = "from ADAS_DRV_Slave1" ,
    [0x5D9] = "to CCU_AP"            , -- not sure
    [0x5D1] = "from CCU_AP"          , -- not sure
    [0x7DF] = "to ALL"               ,
    [0x1000] = "from/to EDT"         ,
}

-- Mandatory: fields table
local f = protocol.fields

f.ProtocolVersion = ProtoField.uint8("protocol.ProtocolVersion", "Protocol Version", base.HEX)
f.InverseProtocol = ProtoField.uint8("protocol.InverseProtocol", "Inverse Protocol", base.HEX)
f.PayloadType = ProtoField.uint16("protocol.PayloadType", "Payload Type", base.HEX)
f.PayloadLength = ProtoField.uint32("protocol.PayloadLength", "Payload Length", base.DEC)
f.Payload = ProtoField.bytes("protocol.Payload", "Payload", base.SPACE)

f.ReqID = ProtoField.uint16("protocol.ReqID", "Request ID", base.HEX)
f.ResID = ProtoField.uint16("protocol.ResID", "Response ID", base.HEX)
f.SA = ProtoField.uint16("protocol.SA", "Source Address", base.HEX)
f.TA = ProtoField.uint16("protocol.TA", "Target Address", base.HEX)
f.SID = ProtoField.uint8("protocol.SID", "Service ID", base.HEX)
f.RID = ProtoField.uint16("protocol.RID", "Routine ID", base.HEX)
f.DID = ProtoField.uint16("protocol.DID", "Data ID", base.HEX)
f.Data = ProtoField.bytes("protocol.Data", "Data", base.SPACE)
f.Padding = ProtoField.bytes("protocol.Padding", "Padding", base.SPACE)
f.NegativeResponse = ProtoField.uint24("protocol.NegativeResponse", "Negative Response", base.HEX)

f.FrameType = ProtoField.uint8("protocol.FrameType", "Frame Type", base.HEX, nil, 0xF0)
f.SF_DL = ProtoField.uint8("protocol.SF_DL", "SF_DL", base.DEC, nil, 0x0F)
f.FF_DL = ProtoField.uint16("protocol.FF_DL", "FF_DL", base.DEC, nil, 0x0FFF)
f.SN = ProtoField.uint8("protocol.SN", "Sequence Number", base.DEC, nil, 0x0F)
f.FS = ProtoField.uint8("protocol.FS", "Flow Status", base.DEC, nil, 0x0F)
f.BS = ProtoField.uint8("protocol.BS", "Block Size", base.DEC)
f.STmin = ProtoField.uint8("protocol.STmin", "STmin", base.DEC)


-- Mandatory: dissector function
function protocol.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end


    pinfo.cols.protocol = "EthDiag" -- protocol.name
    local subtree = tree:add(protocol, buffer(), "EthDiag Protocol Data")

    local protocol_version = buffer(0, 1):uint()

    if protocol_version ~= 0xCA then
        subtree:append_text(" - Mass Data")
        return
    end

    subtree:add(f.ProtocolVersion, buffer(0, 1))
    subtree:add(f.InverseProtocol, buffer(1, 1))
    pt = subtree:add(f.PayloadType, buffer(2, 2))
    subtree:add(f.PayloadLength, buffer(4, 4))

    if buffer(4,4):uint() > 0 then
        payload = subtree:add(f.Payload, buffer(8))
    end

    local payload_type = buffer(2, 2):uint()
    local toECU = (tostring(pinfo.src)=="10.0.5.0") or (tostring(pinfo.src)=="10.0.6.0")

    if payload_type == 0x8001 then
        pt:append_text(" (Diagnostic Message)")

        if toECU then
            payload:add(f.ReqID, buffer(8, 2)):append_text((parenthesis( MSG_ID[buffer(8, 2):uint()] )))
        else
            payload:add(f.ResID, buffer(8, 2)):append_text((parenthesis( MSG_ID[buffer(8, 2):uint()] )))
        end

        local frame_type = bit.rshift(buffer(10, 1):uint(), 4)
        if frame_type == 0 then
            local data_length = bit.band(buffer(10, 1):uint(), 0x0F)
            local sid = buffer(11,1):uint()

            payload:add(f.FrameType, buffer(10, 1)):append_text(" (Single Frame)")
            if data_length ~= 0 then
                payload:add(f.SF_DL, buffer(10, 1))
                if sid ~=0x7F then
                    payload:add(f.SID, buffer(11, 1)):append_text(parenthesis(SID[sid]))
                    if data_length > 1 then
                        payload:add(f.Data, buffer(12, data_length-1))
                    end
                    if length > 11 + data_length then
                        payload:add(f.Padding, buffer(11+data_length))
                    end
                else
                    local fail_sid = buffer(12, 1):uint()
                    local nrc = buffer(13, 1):uint()
                    payload:add(f.NegativeResponse, buffer(11, 3)):
                        append_text(parenthesis(string.format("%s / NRC: 0x%02x <%s>", SID[fail_sid], nrc, NRC[nrc])))
                    payload:add(f.Padding, buffer(14))
                end
            else
                payload:add(f.Data, buffer(11))
            end
        elseif frame_type == 1 then
            local sid = buffer(12,1):uint()

            payload:add(f.FrameType, buffer(10, 1)):append_text(" (First Frame)")
            payload:add(f.FF_DL, buffer(10, 2))
            payload:add(f.SID, buffer(12, 1)):append_text(parenthesis(SID[sid]))
            payload:add(f.Data, buffer(13, length-13))
        elseif frame_type == 2 then
            payload:add(f.FrameType, buffer(10, 1)):append_text(" (Consecutive Frame)")
            payload:add(f.SN, buffer(10, 1))
            payload:add(f.Data, buffer(11))
        elseif frame_type == 3 then
            payload:add(f.FrameType, buffer(10, 1)):append_text(" (Flow Control)")
            payload:add(f.FS, buffer(10, 1))
            payload:add(f.BS, buffer(11, 1))
            payload:add(f.STmin, buffer(12, 1))
            payload:add(f.Padding, buffer(13))
        else
            payload:add(f.Data, buffer(10))
        end


    elseif payload_type == 0xFCBC then
        pt:append_text(" (Mass Data Transfer)")

        payload:add(f.SA, buffer(8, 2)):append_text((parenthesis( MSG_ID[buffer(8, 2):uint()] )))
        payload:add(f.TA, buffer(10, 2)):append_text((parenthesis( MSG_ID[buffer(10, 2):uint()] )))

        local sid = buffer(12,1):uint()
        if sid ~= 0x7F then
            payload:add(f.SID, buffer(12, 1)):append_text(parenthesis(SID[sid]))
            if buffer:len() > 13 then
                payload:add(f.Data, buffer(13))
            end
        else
            local fail_sid = buffer(13,1):uint()
            local nrc = buffer(14,1):uint()
            payload:add(f.NegativeResponse, buffer(12, 3)):
                append_text(parenthesis(string.format("%s / NRC: 0x%02x <%s>", SID[fail_sid], nrc, NRC[nrc])))
        end


    elseif payload_type == 0x0007 then
        pt:append_text(" (Alive Check Message)")
    else
        pt:append_text(" (Unknown Payload Type)")
    end
end


local tcp_port = DissectorTable.get("tcp.port")
tcp_port:add(13402, protocol)
tcp_port:add(13404, protocol)

