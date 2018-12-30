#NoEnv
#Warn ClassOverwrite

class LastError
{
	static INIT := LastError._LoadErrorTable()

	id[] {
		get {
			return A_LastError
		}
	}

	hex[] {
		get {
			return Format("0x{:X}", A_LastError)
		}
	}

	enum[] {
		get {
			return LastError._ResultOrNotFound("enum")
		}
	}

	msg[] {
		get {
			return LastError._ResultOrNotFound("msg")
		}
	}

	info[] {
		get {
			return LastError._ResultOrNotFound("info", ObjBindMethod(LastError, "_FormattedCompleteInfo"))
		}
	}

	_LoadErrorTable() {
		LastError.ERROR_TABLE := {}

		SplitPath A_LineFile, , libDir
		errorTableTxt := "error_table.txt"
		errorTableTxtPath := libDir "\" errorTableTxt

		if !FileExist(errorTableTxtPath)
		{
			MsgBox % 0x1000 | 0x10, % "Class " this.__Class ": Error Table Not Found!", % Format("
			(LTrim
				The error description file '{2:}' could not be found in class {1:}'s directory: ""{3:}""

				Exiting script.
			)", this.__Class, errorTableTxt, libDir)

			ExitApp
		}

		file := FileOpen(errorTableTxtPath, "r")

		while !file.AtEOF
		{
			Line := RTrim(file.ReadLine())
			RegExMatch(Line, "(?P<id>[^\|]+)\|(?P<enum>[^\|]+)\|(?P<msg>[^\|]+)", m_)
			LastError.ERROR_TABLE[m_id] := {"enum": m_enum, "msg": m_msg}
		}

		file.Close()
	}

	_FormattedCompleteInfo(id) {
		return Format("{}`n`n{2:} (0x{2:X})`n{}", LastError.ERROR_TABLE[id].enum, id, LastError.ERROR_TABLE[id].msg)
	}

	_ResultOrNotFound(field, fn := "") {
		id := A_LastError

		if (LastError.ERROR_TABLE.HasKey(id))
			if IsObject(fn)
				return fn.Call(id)
			else
				return LastError.ERROR_TABLE[id, field]
		else
			return LastError._MessageInfoNotFound(id, field)
	}

	_MessageInfoNotFound(id, field) {
		return Format("Requested '{:U}' could not be found for A_LastError: {}", field, id)
	}
}
