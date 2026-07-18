-- Copyright 2010 Riccardo Belloli (belloli@email.it)
-- This file is a part of QDKP_V2 (see about.txt in the Addon's root folder)
-- Community patch: rotating backups (multiple snapshots) instead of a single one.

--             ## CORE FUNCTIONS ##
--                Backup/Restore
--
--      Functions to backup all the officier notes in local, and to restore that backup in the guild infos.
--      Backups are now kept in a rotation of QDKP2_BACKUP_MAX snapshots (newest first).
--
-- API Documentation:
--      QDKP2_Backup(): Immediately makes a new snapshot of all notes. Older snapshots are kept, up to QDKP2_BACKUP_MAX.
--      QDKP2_Restore([DoNotAsk],[index]): Restores snapshot number <index> (1 = newest, default). You need to upload changes to make them live.
--      QDKP2_ListBackups(): Prints the list of stored snapshots with their dates.

QDKP2_BACKUP_MAX = QDKP2_BACKUP_MAX or 5

local function GetSnapshots()
-- returns the snapshot list, migrating the legacy single-backup format if found.
  QDKP2backup = QDKP2backup or {}
  if not QDKP2backup.SNAPSHOTS then
    QDKP2backup.SNAPSHOTS = {}
    if QDKP2backup.DATE then --legacy format: entries in the array part + DATE.
      local legacy = { DATE = QDKP2backup.DATE, ENTRIES = {} }
      for i = 1, table.getn(QDKP2backup) do
        legacy.ENTRIES[i] = QDKP2backup[i]
        QDKP2backup[i] = nil
      end
      QDKP2backup.DATE = nil
      table.insert(QDKP2backup.SNAPSHOTS, legacy)
    end
  end
  return QDKP2backup.SNAPSHOTS
end


function QDKP2_Backup()
--Backup the officernotes. will backup all the dkp values of both guild members and externals.
  local snapshots = GetSnapshots()
  local entries = {}
  for i=1, QDKP2_GetNumGuildMembers(true) do
    local name, rank, rankIndex, level, class, zone, note, officernote ,datafield, online, status = QDKP2_GetGuildRosterInfo(i);
    entries[i] = {name, datafield}
  end
  table.insert(snapshots, 1, { DATE = time(), ENTRIES = entries })
  while #snapshots > QDKP2_BACKUP_MAX do
    table.remove(snapshots)
  end
  QDKP2_Msg(QDKP2_COLOR_GREEN.."Backup complete. "..table.getn(entries).." entries. Snapshots stored: "..#snapshots.."/"..QDKP2_BACKUP_MAX)
  QDKP2_Events:Fire("BACKUP_SAVED")
end


function QDKP2_ListBackups()
-- prints all the stored snapshots.
  local snapshots = GetSnapshots()
  if #snapshots == 0 then
    QDKP2_Msg("No backups found")
    return
  end
  QDKP2_Msg(QDKP2_COLOR_YELLOW.."Stored backups (newest first):")
  for i = 1, #snapshots do
    local snap = snapshots[i]
    QDKP2_Msg("  #"..i.." - "..date("%d/%m/%y %H:%M", snap.DATE).." ("..#snap.ENTRIES.." entries)")
  end
end


function QDKP2_Restore(DoNotAsk, index)
-- restores the backup snapshot <index> (1 = newest, default). Will introduce a delta in the DKP values to align the live to the backup.
-- You need to save them: untill you don't the notes won't be alterned. This function will restore DKP values to externals' data ONLY IF
-- the external is already defined. Won't restore alts' status, log, raid settings and, more generally, anything else than the DKP values.
  local snapshots = GetSnapshots()
  index = index or 1
  local snap = snapshots[index]
  if not snap or not snap.DATE then
    QDKP2_Msg("No backups found")
    return
  end
  if not DoNotAsk then
    local mess="Do you want to restore all\n data as in the backup of\n"..date("%d/%m/%y %H:%M", snap.DATE).."?"
    QDKP2_AskUser(mess,QDKP2_Restore,true,index)
  else
    local count = 0
    local get = 0
    local tempBackup = snap.ENTRIES
    for i=1, table.getn(tempBackup) do
      local name = tempBackup[i][1]
      local datafield = tempBackup[i][2]
      if QDKP2_IsInGuild(name) and not QDKP2_IsAlt(name) then
        local net, total, spent, hours = QDKP2_ParseNote(datafield)
        local DTotal = total - QDKP2note[name][QDKP2_TOTAL]
        local DSpent = spent - QDKP2note[name][QDKP2_SPENT]
        local DHours = hours - QDKP2note[name][QDKP2_HOURS]
        get = get + 1
        if DTotal==0 then DTotal = nil; end
        if DSpent==0 then DSpent = nil; end
        if DHours==0 then DHours = nil; end
        if DTotal or DSpent or DHours then
          QDKP2_AddTotals(name, DTotal, DSpent, DHours, "restored backup", true, nil, nil, true)
        end
      elseif not QDKP2_IsAlt(name) then
        QDKP2_Debug(2,"Core",name.."has not been restored because is an alt of "..QDKP2_GetMain(name))
      else
        QDKP2_Debug(2,"Core",name.."has not been restored because doesn't seems to be in the guild.")
      end
      count = count + 1
    end
    QDKP2_Msg(QDKP2_COLOR_GREEN.."Restored "..get.." entries. Send changes to upload them in officer notes.")
    QDKP2_RefreshGuild()
    QDKP2_Events:Fire("BACKUP_RESTORED")
    QDKP2_Events:Fire("DATA_UPDATED","all")
  end
end
