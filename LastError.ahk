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

		fileSelf := FileOpen(A_LineFile, "r")

		while !fileSelf.AtEOF
		{
			line := Trim(fileSelf.ReadLine(), " `t`r`n")

			if (!isParsingErrors && line == "<<<START>>>")
			{
				isParsingErrors := true
				continue
			}

			if (isParsingErrors && line == "<<<END>>>")
				break

			if isParsingErrors
			{
				Temp := StrSplit(line, "|")
				id := Temp[1]
				enum := Temp[2]
				msg := Temp[3]

				LastError.ERROR_TABLE[id] := {"enum": enum, "msg": msg}
			}
		}

		fileSelf.Close()
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

/*
<<<START>>>
0|ERROR_SUCCESS|The operation completed successfully.
1|ERROR_INVALID_FUNCTION|Incorrect function.
2|ERROR_FILE_NOT_FOUND|The system cannot find the file specified.
3|ERROR_PATH_NOT_FOUND|The system cannot find the path specified.
4|ERROR_TOO_MANY_OPEN_FILES|The system cannot open the file.
5|ERROR_ACCESS_DENIED|Access is denied.
6|ERROR_INVALID_HANDLE|The handle is invalid.
7|ERROR_ARENA_TRASHED|The storage control blocks were destroyed.
8|ERROR_NOT_ENOUGH_MEMORY|Not enough storage is available to process this command.
9|ERROR_INVALID_BLOCK|The storage control block address is invalid.
10|ERROR_BAD_ENVIRONMENT|The environment is incorrect.
11|ERROR_BAD_FORMAT|An attempt was made to load a program with an incorrect format.
12|ERROR_INVALID_ACCESS|The access code is invalid.
13|ERROR_INVALID_DATA|The data is invalid.
14|ERROR_OUTOFMEMORY|Not enough storage is available to complete this operation.
15|ERROR_INVALID_DRIVE|The system cannot find the drive specified.
16|ERROR_CURRENT_DIRECTORY|The directory cannot be removed.
17|ERROR_NOT_SAME_DEVICE|The system cannot move the file to a different disk drive.
18|ERROR_NO_MORE_FILES|There are no more files.
19|ERROR_WRITE_PROTECT|The media is write protected.
20|ERROR_BAD_UNIT|The system cannot find the device specified.
21|ERROR_NOT_READY|The device is not ready.
22|ERROR_BAD_COMMAND|The device does not recognize the command.
23|ERROR_CRC|Data error (cyclic redundancy check).
24|ERROR_BAD_LENGTH|The program issued a command but the command length is incorrect.
25|ERROR_SEEK|The drive cannot locate a specific area or track on the disk.
26|ERROR_NOT_DOS_DISK|The specified disk or diskette cannot be accessed.
27|ERROR_SECTOR_NOT_FOUND|The drive cannot find the sector requested.
28|ERROR_OUT_OF_PAPER|The printer is out of paper.
29|ERROR_WRITE_FAULT|The system cannot write to the specified device.
30|ERROR_READ_FAULT|The system cannot read from the specified device.
31|ERROR_GEN_FAILURE|A device attached to the system is not functioning.
32|ERROR_SHARING_VIOLATION|The process cannot access the file because it is being used by another process.
33|ERROR_LOCK_VIOLATION|The process cannot access the file because another process has locked a portion of the file.
34|ERROR_WRONG_DISK|The wrong diskette is in the drive. Insert `%2 (Volume Serial Number: `%3) into drive `%1.
36|ERROR_SHARING_BUFFER_EXCEEDED|Too many files opened for sharing.
38|ERROR_HANDLE_EOF|Reached the end of the file.
39|ERROR_HANDLE_DISK_FULL|The disk is full.
50|ERROR_NOT_SUPPORTED|The request is not supported.
51|ERROR_REM_NOT_LIST|Windows cannot find the network path. Verify that the network path is correct and the destination computer is not busy or turned off. If Windows still cannot find the network path, contact your network administrator.
52|ERROR_DUP_NAME|You were not connected because a duplicate name exists on the network. If joining a domain, go to System in Control Panel to change the computer name and try again. If joining a workgroup, choose another workgroup name.
53|ERROR_BAD_NETPATH|The network path was not found.
54|ERROR_NETWORK_BUSY|The network is busy.
55|ERROR_DEV_NOT_EXIST|The specified network resource or device is no longer available.
56|ERROR_TOO_MANY_CMDS|The network BIOS command limit has been reached.
57|ERROR_ADAP_HDW_ERR|A network adapter hardware error occurred.
58|ERROR_BAD_NET_RESP|The specified server cannot perform the requested operation.
59|ERROR_UNEXP_NET_ERR|An unexpected network error occurred.
60|ERROR_BAD_REM_ADAP|The remote adapter is not compatible.
61|ERROR_PRINTQ_FULL|The printer queue is full.
62|ERROR_NO_SPOOL_SPACE|Space to store the file waiting to be printed is not available on the server.
63|ERROR_PRINT_CANCELLED|Your file waiting to be printed was deleted.
64|ERROR_NETNAME_DELETED|The specified network name is no longer available.
65|ERROR_NETWORK_ACCESS_DENIED|Network access is denied.
66|ERROR_BAD_DEV_TYPE|The network resource type is not correct.
67|ERROR_BAD_NET_NAME|The network name cannot be found.
68|ERROR_TOO_MANY_NAMES|The name limit for the local computer network adapter card was exceeded.
69|ERROR_TOO_MANY_SESS|The network BIOS session limit was exceeded.
70|ERROR_SHARING_PAUSED|The remote server has been paused or is in the process of being started.
71|ERROR_REQ_NOT_ACCEP|No more connections can be made to this remote computer at this time because there are already as many connections as the computer can accept.
72|ERROR_REDIR_PAUSED|The specified printer or disk device has been paused.
80|ERROR_FILE_EXISTS|The file exists.
82|ERROR_CANNOT_MAKE|The directory or file cannot be created.
83|ERROR_FAIL_I24|Fail on INT 24.
84|ERROR_OUT_OF_STRUCTURES|Storage to process this request is not available.
85|ERROR_ALREADY_ASSIGNED|The local device name is already in use.
86|ERROR_INVALID_PASSWORD|The specified network password is not correct.
87|ERROR_INVALID_PARAMETER|The parameter is incorrect.
88|ERROR_NET_WRITE_FAULT|A write fault occurred on the network.
89|ERROR_NO_PROC_SLOTS|The system cannot start another process at this time.
100|ERROR_TOO_MANY_SEMAPHORES|Cannot create another system semaphore.
101|ERROR_EXCL_SEM_ALREADY_OWNED|The exclusive semaphore is owned by another process.
102|ERROR_SEM_IS_SET|The semaphore is set and cannot be closed.
103|ERROR_TOO_MANY_SEM_REQUESTS|The semaphore cannot be set again.
104|ERROR_INVALID_AT_INTERRUPT_TIME|Cannot request exclusive semaphores at interrupt time.
105|ERROR_SEM_OWNER_DIED|The previous ownership of this semaphore has ended.
106|ERROR_SEM_USER_LIMIT|Insert the diskette for drive `%1.
107|ERROR_DISK_CHANGE|The program stopped because an alternate diskette was not inserted.
108|ERROR_DRIVE_LOCKED|The disk is in use or locked by another process.
109|ERROR_BROKEN_PIPE|The pipe has been ended.
110|ERROR_OPEN_FAILED|The system cannot open the device or file specified.
111|ERROR_BUFFER_OVERFLOW|The file name is too long.
112|ERROR_DISK_FULL|There is not enough space on the disk.
113|ERROR_NO_MORE_SEARCH_HANDLES|No more internal file identifiers available.
114|ERROR_INVALID_TARGET_HANDLE|The target internal file identifier is incorrect.
117|ERROR_INVALID_CATEGORY|The IOCTL call made by the application program is not correct.
118|ERROR_INVALID_VERIFY_SWITCH|The verify-on-write switch parameter value is not correct.
119|ERROR_BAD_DRIVER_LEVEL|The system does not support the command requested.
120|ERROR_CALL_NOT_IMPLEMENTED|This function is not supported on this system.
121|ERROR_SEM_TIMEOUT|The semaphore timeout period has expired.
122|ERROR_INSUFFICIENT_BUFFER|The data area passed to a system call is too small.
123|ERROR_INVALID_NAME|The filename, directory name, or volume label syntax is incorrect.
124|ERROR_INVALID_LEVEL|The system call level is not correct.
125|ERROR_NO_VOLUME_LABEL|The disk has no volume label.
126|ERROR_MOD_NOT_FOUND|The specified module could not be found.
127|ERROR_PROC_NOT_FOUND|The specified procedure could not be found.
128|ERROR_WAIT_NO_CHILDREN|There are no child processes to wait for.
129|ERROR_CHILD_NOT_COMPLETE|The `%1 application cannot be run in Win32 mode.
130|ERROR_DIRECT_ACCESS_HANDLE|Attempt to use a file handle to an open disk partition for an operation other than raw disk I/O.
131|ERROR_NEGATIVE_SEEK|An attempt was made to move the file pointer before the beginning of the file.
132|ERROR_SEEK_ON_DEVICE|The file pointer cannot be set on the specified device or file.
133|ERROR_IS_JOIN_TARGET|A JOIN or SUBST command cannot be used for a drive that contains previously joined drives.
134|ERROR_IS_JOINED|An attempt was made to use a JOIN or SUBST command on a drive that has already been joined.
135|ERROR_IS_SUBSTED|An attempt was made to use a JOIN or SUBST command on a drive that has already been substituted.
136|ERROR_NOT_JOINED|The system tried to delete the JOIN of a drive that is not joined.
137|ERROR_NOT_SUBSTED|The system tried to delete the substitution of a drive that is not substituted.
138|ERROR_JOIN_TO_JOIN|The system tried to join a drive to a directory on a joined drive.
139|ERROR_SUBST_TO_SUBST|The system tried to substitute a drive to a directory on a substituted drive.
140|ERROR_JOIN_TO_SUBST|The system tried to join a drive to a directory on a substituted drive.
141|ERROR_SUBST_TO_JOIN|The system tried to SUBST a drive to a directory on a joined drive.
142|ERROR_BUSY_DRIVE|The system cannot perform a JOIN or SUBST at this time.
143|ERROR_SAME_DRIVE|The system cannot join or substitute a drive to or for a directory on the same drive.
144|ERROR_DIR_NOT_ROOT|The directory is not a subdirectory of the root directory.
145|ERROR_DIR_NOT_EMPTY|The directory is not empty.
146|ERROR_IS_SUBST_PATH|The path specified is being used in a substitute.
147|ERROR_IS_JOIN_PATH|Not enough resources are available to process this command.
148|ERROR_PATH_BUSY|The path specified cannot be used at this time.
149|ERROR_IS_SUBST_TARGET|An attempt was made to join or substitute a drive for which a directory on the drive is the target of a previous substitute.
150|ERROR_SYSTEM_TRACE|System trace information was not specified in your CONFIG.SYS file, or tracing is disallowed.
151|ERROR_INVALID_EVENT_COUNT|The number of specified semaphore events for DosMuxSemWait is not correct.
152|ERROR_TOO_MANY_MUXWAITERS|DosMuxSemWait did not execute; too many semaphores are already set.
153|ERROR_INVALID_LIST_FORMAT|The DosMuxSemWait list is not correct.
154|ERROR_LABEL_TOO_LONG|The volume label you entered exceeds the label character limit of the target file system.
155|ERROR_TOO_MANY_TCBS|Cannot create another thread.
156|ERROR_SIGNAL_REFUSED|The recipient process has refused the signal.
157|ERROR_DISCARDED|The segment is already discarded and cannot be locked.
158|ERROR_NOT_LOCKED|The segment is already unlocked.
159|ERROR_BAD_THREADID_ADDR|The address for the thread ID is not correct.
160|ERROR_BAD_ARGUMENTS|One or more arguments are not correct.
161|ERROR_BAD_PATHNAME|The specified path is invalid.
162|ERROR_SIGNAL_PENDING|A signal is already pending.
164|ERROR_MAX_THRDS_REACHED|No more threads can be created in the system.
167|ERROR_LOCK_FAILED|Unable to lock a region of a file.
170|ERROR_BUSY|The requested resource is in use.
171|ERROR_DEVICE_SUPPORT_IN_PROGRESS|Device's command support detection is in progress.
173|ERROR_CANCEL_VIOLATION|A lock request was not outstanding for the supplied cancel region.
174|ERROR_ATOMIC_LOCKS_NOT_SUPPORTED|The file system does not support atomic changes to the lock type.
180|ERROR_INVALID_SEGMENT_NUMBER|The system detected a segment number that was not correct.
182|ERROR_INVALID_ORDINAL|The operating system cannot run `%1.
183|ERROR_ALREADY_EXISTS|Cannot create a file when that file already exists.
186|ERROR_INVALID_FLAG_NUMBER|The flag passed is not correct.
187|ERROR_SEM_NOT_FOUND|The specified system semaphore name was not found.
188|ERROR_INVALID_STARTING_CODESEG|The operating system cannot run `%1.
189|ERROR_INVALID_STACKSEG|The operating system cannot run `%1.
190|ERROR_INVALID_MODULETYPE|The operating system cannot run `%1.
191|ERROR_INVALID_EXE_SIGNATURE|Cannot run `%1 in Win32 mode.
192|ERROR_EXE_MARKED_INVALID|The operating system cannot run `%1.
193|ERROR_BAD_EXE_FORMAT|`%1 is not a valid Win32 application.
194|ERROR_ITERATED_DATA_EXCEEDS_64k|The operating system cannot run `%1.
195|ERROR_INVALID_MINALLOCSIZE|The operating system cannot run `%1.
196|ERROR_DYNLINK_FROM_INVALID_RING|The operating system cannot run this application program.
197|ERROR_IOPL_NOT_ENABLED|The operating system is not presently configured to run this application.
198|ERROR_INVALID_SEGDPL|The operating system cannot run `%1.
199|ERROR_AUTODATASEG_EXCEEDS_64k|The operating system cannot run this application program.
200|ERROR_RING2SEG_MUST_BE_MOVABLE|The code segment cannot be greater than or equal to 64K.
201|ERROR_RELOC_CHAIN_XEEDS_SEGLIM|The operating system cannot run `%1.
202|ERROR_INFLOOP_IN_RELOC_CHAIN|The operating system cannot run `%1.
203|ERROR_ENVVAR_NOT_FOUND|The system could not find the environment option that was entered.
205|ERROR_NO_SIGNAL_SENT|No process in the command subtree has a signal handler.
206|ERROR_FILENAME_EXCED_RANGE|The filename or extension is too long.
207|ERROR_RING2_STACK_IN_USE|The ring 2 stack is in use.
208|ERROR_META_EXPANSION_TOO_LONG|The global filename characters, * or ?, are entered incorrectly or too many global filename characters are specified.
209|ERROR_INVALID_SIGNAL_NUMBER|The signal being posted is not correct.
210|ERROR_THREAD_1_INACTIVE|The signal handler cannot be set.
212|ERROR_LOCKED|The segment is locked and cannot be reallocated.
214|ERROR_TOO_MANY_MODULES|Too many dynamic-link modules are attached to this program or dynamic-link module.
215|ERROR_NESTING_NOT_ALLOWED|Cannot nest calls to LoadModule.
216|ERROR_EXE_MACHINE_TYPE_MISMATCH|This version of `%1 is not compatible with the version of Windows you're running. Check your computer's system information and then contact the software publisher.
217|ERROR_EXE_CANNOT_MODIFY_SIGNED_BINARY|The image file `%1 is signed, unable to modify.
218|ERROR_EXE_CANNOT_MODIFY_STRONG_SIGNED_BINARY|The image file `%1 is strong signed, unable to modify.
220|ERROR_FILE_CHECKED_OUT|This file is checked out or locked for editing by another user.
221|ERROR_CHECKOUT_REQUIRED|The file must be checked out before saving changes.
222|ERROR_BAD_FILE_TYPE|The file type being saved or retrieved has been blocked.
223|ERROR_FILE_TOO_LARGE|The file size exceeds the limit allowed and cannot be saved.
224|ERROR_FORMS_AUTH_REQUIRED|Access Denied. Before opening files in this location, you must first add the web site to your trusted sites list, browse to the web site, and select the option to login automatically.
225|ERROR_VIRUS_INFECTED|Operation did not complete successfully because the file contains a virus or potentially unwanted software.
226|ERROR_VIRUS_DELETED|This file contains a virus or potentially unwanted software and cannot be opened. Due to the nature of this virus or potentially unwanted software, the file has been removed from this location.
229|ERROR_PIPE_LOCAL|The pipe is local.
230|ERROR_BAD_PIPE|The pipe state is invalid.
231|ERROR_PIPE_BUSY|All pipe instances are busy.
232|ERROR_NO_DATA|The pipe is being closed.
233|ERROR_PIPE_NOT_CONNECTED|No process is on the other end of the pipe.
234|ERROR_MORE_DATA|More data is available.
240|ERROR_VC_DISCONNECTED|The session was canceled.
254|ERROR_INVALID_EA_NAME|The specified extended attribute name was invalid.
255|ERROR_EA_LIST_INCONSISTENT|The extended attributes are inconsistent.
258|WAIT_TIMEOUT|The wait operation timed out.
259|ERROR_NO_MORE_ITEMS|No more data is available.
266|ERROR_CANNOT_COPY|The copy functions cannot be used.
267|ERROR_DIRECTORY|The directory name is invalid.
275|ERROR_EAS_DIDNT_FIT|The extended attributes did not fit in the buffer.
276|ERROR_EA_FILE_CORRUPT|The extended attribute file on the mounted file system is corrupt.
277|ERROR_EA_TABLE_FULL|The extended attribute table file is full.
278|ERROR_INVALID_EA_HANDLE|The specified extended attribute handle is invalid.
282|ERROR_EAS_NOT_SUPPORTED|The mounted file system does not support extended attributes.
288|ERROR_NOT_OWNER|Attempt to release mutex not owned by caller.
298|ERROR_TOO_MANY_POSTS|Too many posts were made to a semaphore.
299|ERROR_PARTIAL_COPY|Only part of a ReadProcessMemory or WriteProcessMemory request was completed.
300|ERROR_OPLOCK_NOT_GRANTED|The oplock request is denied.
301|ERROR_INVALID_OPLOCK_PROTOCOL|An invalid oplock acknowledgment was received by the system.
302|ERROR_DISK_TOO_FRAGMENTED|The volume is too fragmented to complete this operation.
303|ERROR_DELETE_PENDING|The file cannot be opened because it is in the process of being deleted.
304|ERROR_INCOMPATIBLE_WITH_GLOBAL_SHORT_NAME_REGISTRY_SETTING|Short name settings may not be changed on this volume due to the global registry setting.
305|ERROR_SHORT_NAMES_NOT_ENABLED_ON_VOLUME|Short names are not enabled on this volume.
306|ERROR_SECURITY_STREAM_IS_INCONSISTENT|The security stream for the given volume is in an inconsistent state. Please run CHKDSK on the volume.
307|ERROR_INVALID_LOCK_RANGE|A requested file lock operation cannot be processed due to an invalid byte range.
308|ERROR_IMAGE_SUBSYSTEM_NOT_PRESENT|The subsystem needed to support the image type is not present.
309|ERROR_NOTIFICATION_GUID_ALREADY_DEFINED|The specified file already has a notification GUID associated with it.
310|ERROR_INVALID_EXCEPTION_HANDLER|An invalid exception handler routine has been detected.
311|ERROR_DUPLICATE_PRIVILEGES|Duplicate privileges were specified for the token.
312|ERROR_NO_RANGES_PROCESSED|No ranges for the specified operation were able to be processed.
313|ERROR_NOT_ALLOWED_ON_SYSTEM_FILE|Operation is not allowed on a file system internal file.
314|ERROR_DISK_RESOURCES_EXHAUSTED|The physical resources of this disk have been exhausted.
315|ERROR_INVALID_TOKEN|The token representing the data is invalid.
316|ERROR_DEVICE_FEATURE_NOT_SUPPORTED|The device does not support the command feature.
317|ERROR_MR_MID_NOT_FOUND|The system cannot find message text for message number 0x`%1 in the message file for `%2.
318|ERROR_SCOPE_NOT_FOUND|The scope specified was not found.
319|ERROR_UNDEFINED_SCOPE|The Central Access Policy specified is not defined on the target machine.
320|ERROR_INVALID_CAP|The Central Access Policy obtained from Active Directory is invalid.
321|ERROR_DEVICE_UNREACHABLE|The device is unreachable.
322|ERROR_DEVICE_NO_RESOURCES|The target device has insufficient resources to complete the operation.
323|ERROR_DATA_CHECKSUM_ERROR|A data integrity checksum error occurred. Data in the file stream is corrupt.
324|ERROR_INTERMIXED_KERNEL_EA_OPERATION|An attempt was made to modify both a KERNEL and normal Extended Attribute (EA) in the same operation.
326|ERROR_FILE_LEVEL_TRIM_NOT_SUPPORTED|Device does not support file-level TRIM.
327|ERROR_OFFSET_ALIGNMENT_VIOLATION|The command specified a data offset that does not align to the device's granularity/alignment.
328|ERROR_INVALID_FIELD_IN_PARAMETER_LIST|The command specified an invalid field in its parameter list.
329|ERROR_OPERATION_IN_PROGRESS|An operation is currently in progress with the device.
330|ERROR_BAD_DEVICE_PATH|An attempt was made to send down the command via an invalid path to the target device.
331|ERROR_TOO_MANY_DESCRIPTORS|The command specified a number of descriptors that exceeded the maximum supported by the device.
332|ERROR_SCRUB_DATA_DISABLED|Scrub is disabled on the specified file.
333|ERROR_NOT_REDUNDANT_STORAGE|The storage device does not provide redundancy.
334|ERROR_RESIDENT_FILE_NOT_SUPPORTED|An operation is not supported on a resident file.
335|ERROR_COMPRESSED_FILE_NOT_SUPPORTED|An operation is not supported on a compressed file.
336|ERROR_DIRECTORY_NOT_SUPPORTED|An operation is not supported on a directory.
337|ERROR_NOT_READ_FROM_COPY|The specified copy of the requested data could not be read.
350|ERROR_FAIL_NOACTION_REBOOT|No action was taken as a system reboot is required.
351|ERROR_FAIL_SHUTDOWN|The shutdown operation failed.
352|ERROR_FAIL_RESTART|The restart operation failed.
353|ERROR_MAX_SESSIONS_REACHED|The maximum number of sessions has been reached.
400|ERROR_THREAD_MODE_ALREADY_BACKGROUND|The thread is already in background processing mode.
401|ERROR_THREAD_MODE_NOT_BACKGROUND|The thread is not in background processing mode.
402|ERROR_PROCESS_MODE_ALREADY_BACKGROUND|The process is already in background processing mode.
403|ERROR_PROCESS_MODE_NOT_BACKGROUND|The process is not in background processing mode.
487|ERROR_INVALID_ADDRESS|Attempt to access invalid address.
500|ERROR_USER_PROFILE_LOAD|User profile cannot be loaded.
534|ERROR_ARITHMETIC_OVERFLOW|Arithmetic result exceeded 32 bits.
535|ERROR_PIPE_CONNECTED|There is a process on other end of the pipe.
536|ERROR_PIPE_LISTENING|Waiting for a process to open the other end of the pipe.
537|ERROR_VERIFIER_STOP|Application verifier has found an error in the current process.
538|ERROR_ABIOS_ERROR|An error occurred in the ABIOS subsystem.
539|ERROR_WX86_WARNING|A warning occurred in the WX86 subsystem.
540|ERROR_WX86_ERROR|An error occurred in the WX86 subsystem.
541|ERROR_TIMER_NOT_CANCELED|An attempt was made to cancel or set a timer that has an associated APC and the subject thread is not the thread that originally set the timer with an associated APC routine.
542|ERROR_UNWIND|Unwind exception code.
543|ERROR_BAD_STACK|An invalid or unaligned stack was encountered during an unwind operation.
544|ERROR_INVALID_UNWIND_TARGET|An invalid unwind target was encountered during an unwind operation.
545|ERROR_INVALID_PORT_ATTRIBUTES|Invalid Object Attributes specified to NtCreatePort or invalid Port Attributes specified to NtConnectPort
546|ERROR_PORT_MESSAGE_TOO_LONG|Length of message passed to NtRequestPort or NtRequestWaitReplyPort was longer than the maximum message allowed by the port.
547|ERROR_INVALID_QUOTA_LOWER|An attempt was made to lower a quota limit below the current usage.
548|ERROR_DEVICE_ALREADY_ATTACHED|An attempt was made to attach to a device that was already attached to another device.
549|ERROR_INSTRUCTION_MISALIGNMENT|An attempt was made to execute an instruction at an unaligned address and the host system does not support unaligned instruction references.
550|ERROR_PROFILING_NOT_STARTED|Profiling not started.
551|ERROR_PROFILING_NOT_STOPPED|Profiling not stopped.
552|ERROR_COULD_NOT_INTERPRET|The passed ACL did not contain the minimum required information.
553|ERROR_PROFILING_AT_LIMIT|The number of active profiling objects is at the maximum and no more may be started.
554|ERROR_CANT_WAIT|Used to indicate that an operation cannot continue without blocking for I/O.
555|ERROR_CANT_TERMINATE_SELF|Indicates that a thread attempted to terminate itself by default (called NtTerminateThread with <strong>NULL</strong>) and it was the last thread in the current process.
556|ERROR_UNEXPECTED_MM_CREATE_ERR|If an MM error is returned which is not defined in the standard FsRtl filter, it is converted to one of the following errors which is guaranteed to be in the filter. In this case information is lost, however, the filter correctly handles the exception.
557|ERROR_UNEXPECTED_MM_MAP_ERROR|If an MM error is returned which is not defined in the standard FsRtl filter, it is converted to one of the following errors which is guaranteed to be in the filter. In this case information is lost, however, the filter correctly handles the exception.
558|ERROR_UNEXPECTED_MM_EXTEND_ERR|If an MM error is returned which is not defined in the standard FsRtl filter, it is converted to one of the following errors which is guaranteed to be in the filter. In this case information is lost, however, the filter correctly handles the exception.
559|ERROR_BAD_FUNCTION_TABLE|A malformed function table was encountered during an unwind operation.
560|ERROR_NO_GUID_TRANSLATION|Indicates that an attempt was made to assign protection to a file system file or directory and one of the SIDs in the security descriptor could not be translated into a GUID that could be stored by the file system. This causes the protection attempt to fail, which may cause a file creation attempt to fail.
561|ERROR_INVALID_LDT_SIZE|Indicates that an attempt was made to grow an LDT by setting its size, or that the size was not an even number of selectors.
563|ERROR_INVALID_LDT_OFFSET|Indicates that the starting value for the LDT information was not an integral multiple of the selector size.
564|ERROR_INVALID_LDT_DESCRIPTOR|Indicates that the user supplied an invalid descriptor when trying to set up Ldt descriptors.
565|ERROR_TOO_MANY_THREADS|Indicates a process has too many threads to perform the requested action. For example, assignment of a primary token may only be performed when a process has zero or one threads.
566|ERROR_THREAD_NOT_IN_PROCESS|An attempt was made to operate on a thread within a specific process, but the thread specified is not in the process specified.
567|ERROR_PAGEFILE_QUOTA_EXCEEDED|Page file quota was exceeded.
568|ERROR_LOGON_SERVER_CONFLICT|The Netlogon service cannot start because another Netlogon service running in the domain conflicts with the specified role.
569|ERROR_SYNCHRONIZATION_REQUIRED|The SAM database on a Windows Server is significantly out of synchronization with the copy on the Domain Controller. A complete synchronization is required.
570|ERROR_NET_OPEN_FAILED|The NtCreateFile API failed. This error should never be returned to an application, it is a place holder for the Windows Lan Manager Redirector to use in its internal error mapping routines.
571|ERROR_IO_PRIVILEGE_FAILED|{Privilege Failed} The I/O permissions for the process could not be changed.
572|ERROR_CONTROL_C_EXIT|{Application Exit by CTRL+C} The application terminated as a result of a CTRL+C.
573|ERROR_MISSING_SYSTEMFILE|{Missing System File} The required system file `%hs is bad or missing.
574|ERROR_UNHANDLED_EXCEPTION|{Application Error} The exception `%s.
575|ERROR_APP_INIT_FAILURE|{Application Error} The application was unable to start correctly.
576|ERROR_PAGEFILE_CREATE_FAILED|{Unable to Create Paging File} The creation of the paging file `%hs failed (`%lx). The requested size was `%ld.
577|ERROR_INVALID_IMAGE_HASH|Windows cannot verify the digital signature for this file. A recent hardware or software change might have installed a file that is signed incorrectly or damaged, or that might be malicious software from an unknown source.
578|ERROR_NO_PAGEFILE|{No Paging File Specified} No paging file was specified in the system configuration.
579|ERROR_ILLEGAL_FLOAT_CONTEXT|{EXCEPTION} A real-mode application issued a floating-point instruction and floating-point hardware is not present.
580|ERROR_NO_EVENT_PAIR|An event pair synchronization operation was performed using the thread specific client/server event pair object, but no event pair object was associated with the thread.
581|ERROR_DOMAIN_CTRLR_CONFIG_ERROR|A Windows Server has an incorrect configuration.
582|ERROR_ILLEGAL_CHARACTER|An illegal character was encountered. For a multi-byte character set this includes a lead byte without a succeeding trail byte. For the Unicode character set this includes the characters 0xFFFF and 0xFFFE.
583|ERROR_UNDEFINED_CHARACTER|The Unicode character is not defined in the Unicode character set installed on the system.
584|ERROR_FLOPPY_VOLUME|The paging file cannot be created on a floppy diskette.
585|ERROR_BIOS_FAILED_TO_CONNECT_INTERRUPT|The system BIOS failed to connect a system interrupt to the device or bus for which the device is connected.
586|ERROR_BACKUP_CONTROLLER|This operation is only allowed for the Primary Domain Controller of the domain.
587|ERROR_MUTANT_LIMIT_EXCEEDED|An attempt was made to acquire a mutant such that its maximum count would have been exceeded.
588|ERROR_FS_DRIVER_REQUIRED|A volume has been accessed for which a file system driver is required that has not yet been loaded.
589|ERROR_CANNOT_LOAD_REGISTRY_FILE|{Registry File Failure} The registry cannot load the hive (file): `%hs or its log or alternate. It is corrupt, absent, or not writable.
590|ERROR_DEBUG_ATTACH_FAILED|{Unexpected Failure in `nDebugActiveProcess} An unexpected failure occurred while processing a <strong>DebugActiveProcess</strong> API request. You may choose OK to terminate the process, or Cancel to ignore the error.
591|ERROR_SYSTEM_PROCESS_TERMINATED|{Fatal System Error} The `%hs system process terminated unexpectedly with a status of 0x`%08x.
592|ERROR_DATA_NOT_ACCEPTED|{Data Not Accepted} The TDI client could not handle the data received during an indication.
593|ERROR_VDM_HARD_ERROR|NTVDM encountered a hard error.
594|ERROR_DRIVER_CANCEL_TIMEOUT|{Cancel Timeout} The driver `%hs failed to complete a cancelled I/O request in the allotted time.
595|ERROR_REPLY_MESSAGE_MISMATCH|{Reply Message Mismatch} An attempt was made to reply to an LPC message, but the thread specified by the client ID in the message was not waiting on that message.
596|ERROR_LOST_WRITEBEHIND_DATA|{Delayed Write Failed} Windows was unable to save all the data for the file `%hs. The data has been lost. This error may be caused by a failure of your computer hardware or network connection. Please try to save this file elsewhere.
597|ERROR_CLIENT_SERVER_PARAMETERS_INVALID|The parameter(s) passed to the server in the client/server shared memory window were invalid. Too much data may have been put in the shared memory window.
598|ERROR_NOT_TINY_STREAM|The stream is not a tiny stream.
599|ERROR_STACK_OVERFLOW_READ|The request must be handled by the stack overflow code.
600|ERROR_CONVERT_TO_LARGE|Internal OFS status codes indicating how an allocation operation is handled. Either it is retried after the containing onode is moved or the extent stream is converted to a large stream.
601|ERROR_FOUND_OUT_OF_SCOPE|The attempt to find the object found an object matching by ID on the volume but it is out of the scope of the handle used for the operation.
602|ERROR_ALLOCATE_BUCKET|The bucket array must be grown. Retry transaction after doing so.
603|ERROR_MARSHALL_OVERFLOW|The user/kernel marshalling buffer has overflowed.
604|ERROR_INVALID_VARIANT|The supplied variant structure contains invalid data.
605|ERROR_BAD_COMPRESSION_BUFFER|The specified buffer contains ill-formed data.
606|ERROR_AUDIT_FAILED|{Audit Failed} An attempt to generate a security audit failed.
607|ERROR_TIMER_RESOLUTION_NOT_SET|The timer resolution was not previously set by the current process.
608|ERROR_INSUFFICIENT_LOGON_INFO|There is insufficient account information to log you on.
609|ERROR_BAD_DLL_ENTRYPOINT|{Invalid DLL Entrypoint} The dynamic link library `%hs is not written correctly. The stack pointer has been left in an inconsistent state. The entrypoint should be declared as WINAPI or STDCALL. Select YES to fail the DLL load. Select NO to continue execution. Selecting NO may cause the application to operate incorrectly.
610|ERROR_BAD_SERVICE_ENTRYPOINT|{Invalid Service Callback Entrypoint} The `%hs service is not written correctly. The stack pointer has been left in an inconsistent state. The callback entrypoint should be declared as WINAPI or STDCALL. Selecting OK will cause the service to continue operation. However, the service process may operate incorrectly.
611|ERROR_IP_ADDRESS_CONFLICT1|There is an IP address conflict with another system on the network.
612|ERROR_IP_ADDRESS_CONFLICT2|There is an IP address conflict with another system on the network.
613|ERROR_REGISTRY_QUOTA_LIMIT|{Low On Registry Space} The system has reached the maximum size allowed for the system part of the registry. Additional storage requests will be ignored.
614|ERROR_NO_CALLBACK_ACTIVE|A callback return system service cannot be executed when no callback is active.
615|ERROR_PWD_TOO_SHORT|The password provided is too short to meet the policy of your user account. Please choose a longer password.
616|ERROR_PWD_TOO_RECENT|The policy of your user account does not allow you to change passwords too frequently. This is done to prevent users from changing back to a familiar, but potentially discovered, password. If you feel your password has been compromised then please contact your administrator immediately to have a new one assigned.
617|ERROR_PWD_HISTORY_CONFLICT|You have attempted to change your password to one that you have used in the past. The policy of your user account does not allow this. Please select a password that you have not previously used.
618|ERROR_UNSUPPORTED_COMPRESSION|The specified compression format is unsupported.
619|ERROR_INVALID_HW_PROFILE|The specified hardware profile configuration is invalid.
620|ERROR_INVALID_PLUGPLAY_DEVICE_PATH|The specified Plug and Play registry device path is invalid.
621|ERROR_QUOTA_LIST_INCONSISTENT|The specified quota list is internally inconsistent with its descriptor.
622|ERROR_EVALUATION_EXPIRATION|{Windows Evaluation Notification} The evaluation period for this installation of Windows has expired. This system will shutdown in 1 hour. To restore access to this installation of Windows, please upgrade this installation using a licensed distribution of this product.
623|ERROR_ILLEGAL_DLL_RELOCATION|{Illegal System DLL Relocation} The system DLL `%hs was relocated in memory. The application will not run properly. The relocation occurred because the DLL `%hs occupied an address range reserved for Windows system DLLs. The vendor supplying the DLL should be contacted for a new DLL.
624|ERROR_DLL_INIT_FAILED_LOGOFF|{DLL Initialization Failed} The application failed to initialize because the window station is shutting down.
625|ERROR_VALIDATE_CONTINUE|The validation process needs to continue on to the next step.
626|ERROR_NO_MORE_MATCHES|There are no more matches for the current index enumeration.
627|ERROR_RANGE_LIST_CONFLICT|The range could not be added to the range list because of a conflict.
628|ERROR_SERVER_SID_MISMATCH|The server process is running under a SID different than that required by client.
629|ERROR_CANT_ENABLE_DENY_ONLY|A group marked use for deny only cannot be enabled.
630|ERROR_FLOAT_MULTIPLE_FAULTS|{EXCEPTION} Multiple floating point faults.
631|ERROR_FLOAT_MULTIPLE_TRAPS|{EXCEPTION} Multiple floating point traps.
632|ERROR_NOINTERFACE|The requested interface is not supported.
633|ERROR_DRIVER_FAILED_SLEEP|{System Standby Failed} The driver `%hs does not support standby mode. Updating this driver may allow the system to go to standby mode.
634|ERROR_CORRUPT_SYSTEM_FILE|The system file `%1 has become corrupt and has been replaced.
635|ERROR_COMMITMENT_MINIMUM|{Virtual Memory Minimum Too Low} Your system is low on virtual memory. Windows is increasing the size of your virtual memory paging file. During this process, memory requests for some applications may be denied. For more information, see Help.
636|ERROR_PNP_RESTART_ENUMERATION|A device was removed so enumeration must be restarted.
637|ERROR_SYSTEM_IMAGE_BAD_SIGNATURE|{Fatal System Error} The system image `%s is not properly signed. The file has been replaced with the signed file. The system has been shut down.
638|ERROR_PNP_REBOOT_REQUIRED|Device will not start without a reboot.
639|ERROR_INSUFFICIENT_POWER|There is not enough power to complete the requested operation.
640|ERROR_MULTIPLE_FAULT_VIOLATION|ERROR_MULTIPLE_FAULT_VIOLATION
641|ERROR_SYSTEM_SHUTDOWN|The system is in the process of shutting down.
642|ERROR_PORT_NOT_SET|An attempt to remove a processes DebugPort was made, but a port was not already associated with the process.
643|ERROR_DS_VERSION_CHECK_FAILURE|This version of Windows is not compatible with the behavior version of directory forest, domain or domain controller.
644|ERROR_RANGE_NOT_FOUND|The specified range could not be found in the range list.
646|ERROR_NOT_SAFE_MODE_DRIVER|The driver was not loaded because the system is booting into safe mode.
647|ERROR_FAILED_DRIVER_ENTRY|The driver was not loaded because it failed its initialization call.
648|ERROR_DEVICE_ENUMERATION_ERROR|The &quot;`%hs&quot; encountered an error while applying power or reading the device configuration. This may be caused by a failure of your hardware or by a poor connection.
649|ERROR_MOUNT_POINT_NOT_RESOLVED|The create operation failed because the name contained at least one mount point which resolves to a volume to which the specified device object is not attached.
650|ERROR_INVALID_DEVICE_OBJECT_PARAMETER|The device object parameter is either not a valid device object or is not attached to the volume specified by the file name.
651|ERROR_MCA_OCCURED|A Machine Check Error has occurred. Please check the system eventlog for additional information.
652|ERROR_DRIVER_DATABASE_ERROR|There was error [`%2] processing the driver database.
653|ERROR_SYSTEM_HIVE_TOO_LARGE|System hive size has exceeded its limit.
654|ERROR_DRIVER_FAILED_PRIOR_UNLOAD|The driver could not be loaded because a previous version of the driver is still in memory.
655|ERROR_VOLSNAP_PREPARE_HIBERNATE|{Volume Shadow Copy Service} Please wait while the Volume Shadow Copy Service prepares volume `%hs for hibernation.
656|ERROR_HIBERNATION_FAILURE|The system has failed to hibernate (The error code is `%hs). Hibernation will be disabled until the system is restarted.
657|ERROR_PWD_TOO_LONG|The password provided is too long to meet the policy of your user account. Please choose a shorter password.
665|ERROR_FILE_SYSTEM_LIMITATION|The requested operation could not be completed due to a file system limitation.
668|ERROR_ASSERTION_FAILURE|An assertion failure has occurred.
669|ERROR_ACPI_ERROR|An error occurred in the ACPI subsystem.
670|ERROR_WOW_ASSERTION|WOW Assertion Error.
671|ERROR_PNP_BAD_MPS_TABLE|A device is missing in the system BIOS MPS table. This device will not be used. Please contact your system vendor for system BIOS update.
672|ERROR_PNP_TRANSLATION_FAILED|A translator failed to translate resources.
673|ERROR_PNP_IRQ_TRANSLATION_FAILED|A IRQ translator failed to translate resources.
674|ERROR_PNP_INVALID_ID|Driver `%2 returned invalid ID for a child device (`%3).
675|ERROR_WAKE_SYSTEM_DEBUGGER|{Kernel Debugger Awakened} the system debugger was awakened by an interrupt.
676|ERROR_HANDLES_CLOSED|{Handles Closed} Handles to objects have been automatically closed as a result of the requested operation.
677|ERROR_EXTRANEOUS_INFORMATION|{Too Much Information} The specified access control list (ACL) contained more information than was expected.
678|ERROR_RXACT_COMMIT_NECESSARY|This warning level status indicates that the transaction state already exists for the registry sub-tree, but that a transaction commit was previously aborted. The commit has NOT been completed, but has not been rolled back either (so it may still be committed if desired).
679|ERROR_MEDIA_CHECK|{Media Changed} The media may have changed.
680|ERROR_GUID_SUBSTITUTION_MADE|{GUID Substitution} During the translation of a global identifier (GUID) to a Windows security ID (SID), no administratively-defined GUID prefix was found. A substitute prefix was used, which will not compromise system security. However, this may provide a more restrictive access than intended.
681|ERROR_STOPPED_ON_SYMLINK|The create operation stopped after reaching a symbolic link.
682|ERROR_LONGJUMP|A long jump has been executed.
683|ERROR_PLUGPLAY_QUERY_VETOED|The Plug and Play query operation was not successful.
684|ERROR_UNWIND_CONSOLIDATE|A frame consolidation has been executed.
685|ERROR_REGISTRY_HIVE_RECOVERED|{Registry Hive Recovered} Registry hive (file): `%hs was corrupted and it has been recovered. Some data might have been lost.
686|ERROR_DLL_MIGHT_BE_INSECURE|The application is attempting to run executable code from the module `%hs. This may be insecure. An alternative, `%hs, is available. Should the application use the secure module `%hs?
687|ERROR_DLL_MIGHT_BE_INCOMPATIBLE|The application is loading executable code from the module `%hs. This is secure, but may be incompatible with previous releases of the operating system. An alternative, `%hs, is available. Should the application use the secure module `%hs?
688|ERROR_DBG_EXCEPTION_NOT_HANDLED|Debugger did not handle the exception.
689|ERROR_DBG_REPLY_LATER|Debugger will reply later.
690|ERROR_DBG_UNABLE_TO_PROVIDE_HANDLE|Debugger cannot provide handle.
691|ERROR_DBG_TERMINATE_THREAD|Debugger terminated thread.
692|ERROR_DBG_TERMINATE_PROCESS|Debugger terminated process.
693|ERROR_DBG_CONTROL_C|Debugger got control C.
694|ERROR_DBG_PRINTEXCEPTION_C|Debugger printed exception on control C.
695|ERROR_DBG_RIPEXCEPTION|Debugger received RIP exception.
696|ERROR_DBG_CONTROL_BREAK|Debugger received control break.
697|ERROR_DBG_COMMAND_EXCEPTION|Debugger command communication exception.
698|ERROR_OBJECT_NAME_EXISTS|{Object Exists} An attempt was made to create an object and the object name already existed.
699|ERROR_THREAD_WAS_SUSPENDED|{Thread Suspended} A thread termination occurred while the thread was suspended. The thread was resumed, and termination proceeded.
700|ERROR_IMAGE_NOT_AT_BASE|{Image Relocated} An image file could not be mapped at the address specified in the image file. Local fixups must be performed on this image.
701|ERROR_RXACT_STATE_CREATED|This informational level status indicates that a specified registry sub-tree transaction state did not yet exist and had to be created.
702|ERROR_SEGMENT_NOTIFICATION|{Segment Load} A virtual DOS machine (VDM) is loading, unloading, or moving an MS-DOS or Win16 program segment image. An exception is raised so a debugger can load, unload or track symbols and breakpoints within these 16-bit segments.
703|ERROR_BAD_CURRENT_DIRECTORY|{Invalid Current Directory} The process cannot switch to the startup current directory `%hs. Select OK to set current directory to `%hs, or select CANCEL to exit.
704|ERROR_FT_READ_RECOVERY_FROM_BACKUP|{Redundant Read} To satisfy a read request, the NT fault-tolerant file system successfully read the requested data from a redundant copy. This was done because the file system encountered a failure on a member of the fault-tolerant volume, but was unable to reassign the failing area of the device.
705|ERROR_FT_WRITE_RECOVERY|{Redundant Write} To satisfy a write request, the NT fault-tolerant file system successfully wrote a redundant copy of the information. This was done because the file system encountered a failure on a member of the fault-tolerant volume, but was not able to reassign the failing area of the device.
706|ERROR_IMAGE_MACHINE_TYPE_MISMATCH|{Machine Type Mismatch} The image file `%hs is valid, but is for a machine type other than the current machine. Select OK to continue, or CANCEL to fail the DLL load.
707|ERROR_RECEIVE_PARTIAL|{Partial Data Received} The network transport returned partial data to its client. The remaining data will be sent later.
708|ERROR_RECEIVE_EXPEDITED|{Expedited Data Received} The network transport returned data to its client that was marked as expedited by the remote system.
709|ERROR_RECEIVE_PARTIAL_EXPEDITED|{Partial Expedited Data Received} The network transport returned partial data to its client and this data was marked as expedited by the remote system. The remaining data will be sent later.
710|ERROR_EVENT_DONE|{TDI Event Done} The TDI indication has completed successfully.
711|ERROR_EVENT_PENDING|{TDI Event Pending} The TDI indication has entered the pending state.
712|ERROR_CHECKING_FILE_SYSTEM|Checking file system on `%wZ.
713|ERROR_FATAL_APP_EXIT|{Fatal Application Exit} `%hs.
714|ERROR_PREDEFINED_HANDLE|The specified registry key is referenced by a predefined handle.
715|ERROR_WAS_UNLOCKED|{Page Unlocked} The page protection of a locked page was changed to 'No Access' and the page was unlocked from memory and from the process.
716|ERROR_SERVICE_NOTIFICATION|`%hs
717|ERROR_WAS_LOCKED|{Page Locked} One of the pages to lock was already locked.
718|ERROR_LOG_HARD_ERROR|Application popup: `%1 : `%2
719|ERROR_ALREADY_WIN32|ERROR_ALREADY_WIN32
720|ERROR_IMAGE_MACHINE_TYPE_MISMATCH_EXE|{Machine Type Mismatch} The image file `%hs is valid, but is for a machine type other than the current machine.
721|ERROR_NO_YIELD_PERFORMED|A yield execution was performed and no thread was available to run.
722|ERROR_TIMER_RESUME_IGNORED|The resumable flag to a timer API was ignored.
723|ERROR_ARBITRATION_UNHANDLED|The arbiter has deferred arbitration of these resources to its parent.
724|ERROR_CARDBUS_NOT_SUPPORTED|The inserted CardBus device cannot be started because of a configuration error on &quot;`%hs&quot;.
725|ERROR_MP_PROCESSOR_MISMATCH|The CPUs in this multiprocessor system are not all the same revision level. To use all processors the operating system restricts itself to the features of the least capable processor in the system. Should problems occur with this system, contact the CPU manufacturer to see if this mix of processors is supported.
726|ERROR_HIBERNATED|The system was put into hibernation.
727|ERROR_RESUME_HIBERNATION|The system was resumed from hibernation.
728|ERROR_FIRMWARE_UPDATED|Windows has detected that the system firmware (BIOS) was updated [previous firmware date = `%2, current firmware date `%3].
729|ERROR_DRIVERS_LEAKING_LOCKED_PAGES|A device driver is leaking locked I/O pages causing system degradation. The system has automatically enabled tracking code in order to try and catch the culprit.
730|ERROR_WAKE_SYSTEM|The system has awoken.
731|ERROR_WAIT_1|ERROR_WAIT_1
732|ERROR_WAIT_2|ERROR_WAIT_2
733|ERROR_WAIT_3|ERROR_WAIT_3
734|ERROR_WAIT_63|ERROR_WAIT_63
735|ERROR_ABANDONED_WAIT_0|ERROR_ABANDONED_WAIT_0
736|ERROR_ABANDONED_WAIT_63|ERROR_ABANDONED_WAIT_63
737|ERROR_USER_APC|ERROR_USER_APC
738|ERROR_KERNEL_APC|ERROR_KERNEL_APC
739|ERROR_ALERTED|ERROR_ALERTED
740|ERROR_ELEVATION_REQUIRED|The requested operation requires elevation.
741|ERROR_REPARSE|A reparse should be performed by the Object Manager since the name of the file resulted in a symbolic link.
742|ERROR_OPLOCK_BREAK_IN_PROGRESS|An open/create operation completed while an oplock break is underway.
743|ERROR_VOLUME_MOUNTED|A new volume has been mounted by a file system.
744|ERROR_RXACT_COMMITTED|This success level status indicates that the transaction state already exists for the registry sub-tree, but that a transaction commit was previously aborted. The commit has now been completed.
745|ERROR_NOTIFY_CLEANUP|This indicates that a notify change request has been completed due to closing the handle which made the notify change request.
746|ERROR_PRIMARY_TRANSPORT_CONNECT_FAILED|{Connect Failure on Primary Transport} An attempt was made to connect to the remote server `%hs on the primary transport, but the connection failed. The computer WAS able to connect on a secondary transport.
747|ERROR_PAGE_FAULT_TRANSITION|Page fault was a transition fault.
748|ERROR_PAGE_FAULT_DEMAND_ZERO|Page fault was a demand zero fault.
749|ERROR_PAGE_FAULT_COPY_ON_WRITE|Page fault was a demand zero fault.
750|ERROR_PAGE_FAULT_GUARD_PAGE|Page fault was a demand zero fault.
751|ERROR_PAGE_FAULT_PAGING_FILE|Page fault was satisfied by reading from a secondary storage device.
752|ERROR_CACHE_PAGE_LOCKED|Cached page was locked during operation.
753|ERROR_CRASH_DUMP|Crash dump exists in paging file.
754|ERROR_BUFFER_ALL_ZEROS|Specified buffer contains all zeros.
755|ERROR_REPARSE_OBJECT|A reparse should be performed by the Object Manager since the name of the file resulted in a symbolic link.
756|ERROR_RESOURCE_REQUIREMENTS_CHANGED|The device has succeeded a query-stop and its resource requirements have changed.
757|ERROR_TRANSLATION_COMPLETE|The translator has translated these resources into the global space and no further translations should be performed.
758|ERROR_NOTHING_TO_TERMINATE|A process being terminated has no threads to terminate.
759|ERROR_PROCESS_NOT_IN_JOB|The specified process is not part of a job.
760|ERROR_PROCESS_IN_JOB|The specified process is part of a job.
761|ERROR_VOLSNAP_HIBERNATE_READY|{Volume Shadow Copy Service} The system is now ready for hibernation.
762|ERROR_FSFILTER_OP_COMPLETED_SUCCESSFULLY|A file system or file system filter driver has successfully completed an FsFilter operation.
763|ERROR_INTERRUPT_VECTOR_ALREADY_CONNECTED|The specified interrupt vector was already connected.
764|ERROR_INTERRUPT_STILL_CONNECTED|The specified interrupt vector is still connected.
765|ERROR_WAIT_FOR_OPLOCK|An operation is blocked waiting for an oplock.
766|ERROR_DBG_EXCEPTION_HANDLED|Debugger handled exception.
767|ERROR_DBG_CONTINUE|Debugger continued.
768|ERROR_CALLBACK_POP_STACK|An exception occurred in a user mode callback and the kernel callback frame should be removed.
769|ERROR_COMPRESSION_DISABLED|Compression is disabled for this volume.
770|ERROR_CANTFETCHBACKWARDS|The data provider cannot fetch backwards through a result set.
771|ERROR_CANTSCROLLBACKWARDS|The data provider cannot scroll backwards through a result set.
772|ERROR_ROWSNOTRELEASED|The data provider requires that previously fetched data is released before asking for more data.
773|ERROR_BAD_ACCESSOR_FLAGS|The data provider was not able to interpret the flags set for a column binding in an accessor.
774|ERROR_ERRORS_ENCOUNTERED|One or more errors occurred while processing the request.
775|ERROR_NOT_CAPABLE|The implementation is not capable of performing the request.
776|ERROR_REQUEST_OUT_OF_SEQUENCE|The client of a component requested an operation which is not valid given the state of the component instance.
777|ERROR_VERSION_PARSE_ERROR|A version number could not be parsed.
778|ERROR_BADSTARTPOSITION|The iterator's start position is invalid.
779|ERROR_MEMORY_HARDWARE|The hardware has reported an uncorrectable memory error.
780|ERROR_DISK_REPAIR_DISABLED|The attempted operation required self healing to be enabled.
781|ERROR_INSUFFICIENT_RESOURCE_FOR_SPECIFIED_SHARED_SECTION_SIZE|The Desktop heap encountered an error while allocating session memory. There is more information in the system event log.
782|ERROR_SYSTEM_POWERSTATE_TRANSITION|The system power state is transitioning from `%2 to `%3.
783|ERROR_SYSTEM_POWERSTATE_COMPLEX_TRANSITION|The system power state is transitioning from `%2 to `%3 but could enter `%4.
784|ERROR_MCA_EXCEPTION|A thread is getting dispatched with MCA EXCEPTION because of MCA.
785|ERROR_ACCESS_AUDIT_BY_POLICY|Access to `%1 is monitored by policy rule `%2.
786|ERROR_ACCESS_DISABLED_NO_SAFER_UI_BY_POLICY|Access to `%1 has been restricted by your Administrator by policy rule `%2.
787|ERROR_ABANDON_HIBERFILE|A valid hibernation file has been invalidated and should be abandoned.
788|ERROR_LOST_WRITEBEHIND_DATA_NETWORK_DISCONNECTED|{Delayed Write Failed} Windows was unable to save all the data for the file `%hs; the data has been lost. This error may be caused by network connectivity issues. Please try to save this file elsewhere.
789|ERROR_LOST_WRITEBEHIND_DATA_NETWORK_SERVER_ERROR|{Delayed Write Failed} Windows was unable to save all the data for the file `%hs; the data has been lost. This error was returned by the server on which the file exists. Please try to save this file elsewhere.
790|ERROR_LOST_WRITEBEHIND_DATA_LOCAL_DISK_ERROR|{Delayed Write Failed} Windows was unable to save all the data for the file `%hs; the data has been lost. This error may be caused if the device has been removed or the media is write-protected.
791|ERROR_BAD_MCFG_TABLE|The resources required for this device conflict with the MCFG table.
792|ERROR_DISK_REPAIR_REDIRECTED|The volume repair could not be performed while it is online. Please schedule to take the volume offline so that it can be repaired.
793|ERROR_DISK_REPAIR_UNSUCCESSFUL|The volume repair was not successful.
794|ERROR_CORRUPT_LOG_OVERFULL|One of the volume corruption logs is full. Further corruptions that may be detected won't be logged.
795|ERROR_CORRUPT_LOG_CORRUPTED|One of the volume corruption logs is internally corrupted and needs to be recreated. The volume may contain undetected corruptions and must be scanned.
796|ERROR_CORRUPT_LOG_UNAVAILABLE|One of the volume corruption logs is unavailable for being operated on.
797|ERROR_CORRUPT_LOG_DELETED_FULL|One of the volume corruption logs was deleted while still having corruption records in them. The volume contains detected corruptions and must be scanned.
798|ERROR_CORRUPT_LOG_CLEARED|One of the volume corruption logs was cleared by chkdsk and no longer contains real corruptions.
799|ERROR_ORPHAN_NAME_EXHAUSTED|Orphaned files exist on the volume but could not be recovered because no more new names could be created in the recovery directory. Files must be moved from the recovery directory.
800|ERROR_OPLOCK_SWITCHED_TO_NEW_HANDLE|The oplock that was associated with this handle is now associated with a different handle.
801|ERROR_CANNOT_GRANT_REQUESTED_OPLOCK|An oplock of the requested level cannot be granted. An oplock of a lower level may be available.
802|ERROR_CANNOT_BREAK_OPLOCK|The operation did not complete successfully because it would cause an oplock to be broken. The caller has requested that existing oplocks not be broken.
803|ERROR_OPLOCK_HANDLE_CLOSED|The handle with which this oplock was associated has been closed. The oplock is now broken.
804|ERROR_NO_ACE_CONDITION|The specified access control entry (ACE) does not contain a condition.
805|ERROR_INVALID_ACE_CONDITION|The specified access control entry (ACE) contains an invalid condition.
806|ERROR_FILE_HANDLE_REVOKED|Access to the specified file handle has been revoked.
807|ERROR_IMAGE_AT_DIFFERENT_BASE|An image file was mapped at a different address from the one specified in the image file but fixups will still be automatically performed on the image.
994|ERROR_EA_ACCESS_DENIED|Access to the extended attribute was denied.
995|ERROR_OPERATION_ABORTED|The I/O operation has been aborted because of either a thread exit or an application request.
996|ERROR_IO_INCOMPLETE|Overlapped I/O event is not in a signaled state.
997|ERROR_IO_PENDING|Overlapped I/O operation is in progress.
998|ERROR_NOACCESS|Invalid access to memory location.
999|ERROR_SWAPERROR|Error performing inpage operation.
1001|ERROR_STACK_OVERFLOW|Recursion too deep; the stack overflowed.
1002|ERROR_INVALID_MESSAGE|The window cannot act on the sent message.
1003|ERROR_CAN_NOT_COMPLETE|Cannot complete this function.
1004|ERROR_INVALID_FLAGS|Invalid flags.
1005|ERROR_UNRECOGNIZED_VOLUME|The volume does not contain a recognized file system. Please make sure that all required file system drivers are loaded and that the volume is not corrupted.
1006|ERROR_FILE_INVALID|The volume for a file has been externally altered so that the opened file is no longer valid.
1007|ERROR_FULLSCREEN_MODE|The requested operation cannot be performed in full-screen mode.
1008|ERROR_NO_TOKEN|An attempt was made to reference a token that does not exist.
1009|ERROR_BADDB|The configuration registry database is corrupt.
1010|ERROR_BADKEY|The configuration registry key is invalid.
1011|ERROR_CANTOPEN|The configuration registry key could not be opened.
1012|ERROR_CANTREAD|The configuration registry key could not be read.
1013|ERROR_CANTWRITE|The configuration registry key could not be written.
1014|ERROR_REGISTRY_RECOVERED|One of the files in the registry database had to be recovered by use of a log or alternate copy. The recovery was successful.
1015|ERROR_REGISTRY_CORRUPT|The registry is corrupted. The structure of one of the files containing registry data is corrupted, or the system's memory image of the file is corrupted, or the file could not be recovered because the alternate copy or log was absent or corrupted.
1016|ERROR_REGISTRY_IO_FAILED|An I/O operation initiated by the registry failed unrecoverably. The registry could not read in, or write out, or flush, one of the files that contain the system's image of the registry.
1017|ERROR_NOT_REGISTRY_FILE|The system has attempted to load or restore a file into the registry, but the specified file is not in a registry file format.
1018|ERROR_KEY_DELETED|Illegal operation attempted on a registry key that has been marked for deletion.
1019|ERROR_NO_LOG_SPACE|System could not allocate the required space in a registry log.
1020|ERROR_KEY_HAS_CHILDREN|Cannot create a symbolic link in a registry key that already has subkeys or values.
1021|ERROR_CHILD_MUST_BE_VOLATILE|Cannot create a stable subkey under a volatile parent key.
1022|ERROR_NOTIFY_ENUM_DIR|A notify change request is being completed and the information is not being returned in the caller's buffer. The caller now needs to enumerate the files to find the changes.
1051|ERROR_DEPENDENT_SERVICES_RUNNING|A stop control has been sent to a service that other running services are dependent on.
1052|ERROR_INVALID_SERVICE_CONTROL|The requested control is not valid for this service.
1053|ERROR_SERVICE_REQUEST_TIMEOUT|The service did not respond to the start or control request in a timely fashion.
1054|ERROR_SERVICE_NO_THREAD|A thread could not be created for the service.
1055|ERROR_SERVICE_DATABASE_LOCKED|The service database is locked.
1056|ERROR_SERVICE_ALREADY_RUNNING|An instance of the service is already running.
1057|ERROR_INVALID_SERVICE_ACCOUNT|The account name is invalid or does not exist, or the password is invalid for the account name specified.
1058|ERROR_SERVICE_DISABLED|The service cannot be started, either because it is disabled or because it has no enabled devices associated with it.
1059|ERROR_CIRCULAR_DEPENDENCY|Circular service dependency was specified.
1060|ERROR_SERVICE_DOES_NOT_EXIST|The specified service does not exist as an installed service.
1061|ERROR_SERVICE_CANNOT_ACCEPT_CTRL|The service cannot accept control messages at this time.
1062|ERROR_SERVICE_NOT_ACTIVE|The service has not been started.
1063|ERROR_FAILED_SERVICE_CONTROLLER_CONNECT|The service process could not connect to the service controller.
1064|ERROR_EXCEPTION_IN_SERVICE|An exception occurred in the service when handling the control request.
1065|ERROR_DATABASE_DOES_NOT_EXIST|The database specified does not exist.
1066|ERROR_SERVICE_SPECIFIC_ERROR|The service has returned a service-specific error code.
1067|ERROR_PROCESS_ABORTED|The process terminated unexpectedly.
1068|ERROR_SERVICE_DEPENDENCY_FAIL|The dependency service or group failed to start.
1069|ERROR_SERVICE_LOGON_FAILED|The service did not start due to a logon failure.
1070|ERROR_SERVICE_START_HANG|After starting, the service hung in a start-pending state.
1071|ERROR_INVALID_SERVICE_LOCK|The specified service database lock is invalid.
1072|ERROR_SERVICE_MARKED_FOR_DELETE|The specified service has been marked for deletion.
1073|ERROR_SERVICE_EXISTS|The specified service already exists.
1074|ERROR_ALREADY_RUNNING_LKG|The system is currently running with the last-known-good configuration.
1075|ERROR_SERVICE_DEPENDENCY_DELETED|The dependency service does not exist or has been marked for deletion.
1076|ERROR_BOOT_ALREADY_ACCEPTED|The current boot has already been accepted for use as the last-known-good control set.
1077|ERROR_SERVICE_NEVER_STARTED|No attempts to start the service have been made since the last boot.
1078|ERROR_DUPLICATE_SERVICE_NAME|The name is already in use as either a service name or a service display name.
1079|ERROR_DIFFERENT_SERVICE_ACCOUNT|The account specified for this service is different from the account specified for other services running in the same process.
1080|ERROR_CANNOT_DETECT_DRIVER_FAILURE|Failure actions can only be set for Win32 services, not for drivers.
1081|ERROR_CANNOT_DETECT_PROCESS_ABORT|This service runs in the same process as the service control manager. Therefore, the service control manager cannot take action if this service's process terminates unexpectedly.
1082|ERROR_NO_RECOVERY_PROGRAM|No recovery program has been configured for this service.
1083|ERROR_SERVICE_NOT_IN_EXE|The executable program that this service is configured to run in does not implement the service.
1084|ERROR_NOT_SAFEBOOT_SERVICE|This service cannot be started in Safe Mode.
1100|ERROR_END_OF_MEDIA|The physical end of the tape has been reached.
1101|ERROR_FILEMARK_DETECTED|A tape access reached a filemark.
1102|ERROR_BEGINNING_OF_MEDIA|The beginning of the tape or a partition was encountered.
1103|ERROR_SETMARK_DETECTED|A tape access reached the end of a set of files.
1104|ERROR_NO_DATA_DETECTED|No more data is on the tape.
1105|ERROR_PARTITION_FAILURE|Tape could not be partitioned.
1106|ERROR_INVALID_BLOCK_LENGTH|When accessing a new tape of a multivolume partition, the current block size is incorrect.
1107|ERROR_DEVICE_NOT_PARTITIONED|Tape partition information could not be found when loading a tape.
1108|ERROR_UNABLE_TO_LOCK_MEDIA|Unable to lock the media eject mechanism.
1109|ERROR_UNABLE_TO_UNLOAD_MEDIA|Unable to unload the media.
1110|ERROR_MEDIA_CHANGED|The media in the drive may have changed.
1111|ERROR_BUS_RESET|The I/O bus was reset.
1112|ERROR_NO_MEDIA_IN_DRIVE|No media in drive.
1113|ERROR_NO_UNICODE_TRANSLATION|No mapping for the Unicode character exists in the target multi-byte code page.
1114|ERROR_DLL_INIT_FAILED|A dynamic link library (DLL) initialization routine failed.
1115|ERROR_SHUTDOWN_IN_PROGRESS|A system shutdown is in progress.
1116|ERROR_NO_SHUTDOWN_IN_PROGRESS|Unable to abort the system shutdown because no shutdown was in progress.
1117|ERROR_IO_DEVICE|The request could not be performed because of an I/O device error.
1118|ERROR_SERIAL_NO_DEVICE|No serial device was successfully initialized. The serial driver will unload.
1119|ERROR_IRQ_BUSY|Unable to open a device that was sharing an interrupt request (IRQ) with other devices. At least one other device that uses that IRQ was already opened.
1120|ERROR_MORE_WRITES|A serial I/O operation was completed by another write to the serial port. The IOCTL_SERIAL_XOFF_COUNTER reached zero.)
1121|ERROR_COUNTER_TIMEOUT|A serial I/O operation completed because the timeout period expired. The IOCTL_SERIAL_XOFF_COUNTER did not reach zero.)
1122|ERROR_FLOPPY_ID_MARK_NOT_FOUND|No ID address mark was found on the floppy disk.
1123|ERROR_FLOPPY_WRONG_CYLINDER|Mismatch between the floppy disk sector ID field and the floppy disk controller track address.
1124|ERROR_FLOPPY_UNKNOWN_ERROR|The floppy disk controller reported an error that is not recognized by the floppy disk driver.
1125|ERROR_FLOPPY_BAD_REGISTERS|The floppy disk controller returned inconsistent results in its registers.
1126|ERROR_DISK_RECALIBRATE_FAILED|While accessing the hard disk, a recalibrate operation failed, even after retries.
1127|ERROR_DISK_OPERATION_FAILED|While accessing the hard disk, a disk operation failed even after retries.
1128|ERROR_DISK_RESET_FAILED|While accessing the hard disk, a disk controller reset was needed, but even that failed.
1129|ERROR_EOM_OVERFLOW|Physical end of tape encountered.
1130|ERROR_NOT_ENOUGH_SERVER_MEMORY|Not enough server storage is available to process this command.
1131|ERROR_POSSIBLE_DEADLOCK|A potential deadlock condition has been detected.
1132|ERROR_MAPPED_ALIGNMENT|The base address or the file offset specified does not have the proper alignment.
1140|ERROR_SET_POWER_STATE_VETOED|An attempt to change the system power state was vetoed by another application or driver.
1141|ERROR_SET_POWER_STATE_FAILED|The system BIOS failed an attempt to change the system power state.
1142|ERROR_TOO_MANY_LINKS|An attempt was made to create more links on a file than the file system supports.
1150|ERROR_OLD_WIN_VERSION|The specified program requires a newer version of Windows.
1151|ERROR_APP_WRONG_OS|The specified program is not a Windows or MS-DOS program.
1152|ERROR_SINGLE_INSTANCE_APP|Cannot start more than one instance of the specified program.
1153|ERROR_RMODE_APP|The specified program was written for an earlier version of Windows.
1154|ERROR_INVALID_DLL|One of the library files needed to run this application is damaged.
1155|ERROR_NO_ASSOCIATION|No application is associated with the specified file for this operation.
1156|ERROR_DDE_FAIL|An error occurred in sending the command to the application.
1157|ERROR_DLL_NOT_FOUND|One of the library files needed to run this application cannot be found.
1158|ERROR_NO_MORE_USER_HANDLES|The current process has used all of its system allowance of handles for Window Manager objects.
1159|ERROR_MESSAGE_SYNC_ONLY|The message can be used only with synchronous operations.
1160|ERROR_SOURCE_ELEMENT_EMPTY|The indicated source element has no media.
1161|ERROR_DESTINATION_ELEMENT_FULL|The indicated destination element already contains media.
1162|ERROR_ILLEGAL_ELEMENT_ADDRESS|The indicated element does not exist.
1163|ERROR_MAGAZINE_NOT_PRESENT|The indicated element is part of a magazine that is not present.
1164|ERROR_DEVICE_REINITIALIZATION_NEEDED|The indicated device requires reinitialization due to hardware errors.
1165|ERROR_DEVICE_REQUIRES_CLEANING|The device has indicated that cleaning is required before further operations are attempted.
1166|ERROR_DEVICE_DOOR_OPEN|The device has indicated that its door is open.
1167|ERROR_DEVICE_NOT_CONNECTED|The device is not connected.
1168|ERROR_NOT_FOUND|Element not found.
1169|ERROR_NO_MATCH|There was no match for the specified key in the index.
1170|ERROR_SET_NOT_FOUND|The property set specified does not exist on the object.
1171|ERROR_POINT_NOT_FOUND|The point passed to GetMouseMovePoints is not in the buffer.
1172|ERROR_NO_TRACKING_SERVICE|The tracking (workstation) service is not running.
1173|ERROR_NO_VOLUME_ID|The Volume ID could not be found.
1175|ERROR_UNABLE_TO_REMOVE_REPLACED|Unable to remove the file to be replaced.
1176|ERROR_UNABLE_TO_MOVE_REPLACEMENT|Unable to move the replacement file to the file to be replaced. The file to be replaced has retained its original name.
1177|ERROR_UNABLE_TO_MOVE_REPLACEMENT_2|Unable to move the replacement file to the file to be replaced. The file to be replaced has been renamed using the backup name.
1178|ERROR_JOURNAL_DELETE_IN_PROGRESS|The volume change journal is being deleted.
1179|ERROR_JOURNAL_NOT_ACTIVE|The volume change journal is not active.
1180|ERROR_POTENTIAL_FILE_FOUND|A file was found, but it may not be the correct file.
1181|ERROR_JOURNAL_ENTRY_DELETED|The journal entry has been deleted from the journal.
1190|ERROR_SHUTDOWN_IS_SCHEDULED|A system shutdown has already been scheduled.
1191|ERROR_SHUTDOWN_USERS_LOGGED_ON|The system shutdown cannot be initiated because there are other users logged on to the computer.
1200|ERROR_BAD_DEVICE|The specified device name is invalid.
1201|ERROR_CONNECTION_UNAVAIL|The device is not currently connected but it is a remembered connection.
1202|ERROR_DEVICE_ALREADY_REMEMBERED|The local device name has a remembered connection to another network resource.
1203|ERROR_NO_NET_OR_BAD_PATH|The network path was either typed incorrectly, does not exist, or the network provider is not currently available. Please try retyping the path or contact your network administrator.
1204|ERROR_BAD_PROVIDER|The specified network provider name is invalid.
1205|ERROR_CANNOT_OPEN_PROFILE|Unable to open the network connection profile.
1206|ERROR_BAD_PROFILE|The network connection profile is corrupted.
1207|ERROR_NOT_CONTAINER|Cannot enumerate a noncontainer.
1208|ERROR_EXTENDED_ERROR|An extended error has occurred.
1209|ERROR_INVALID_GROUPNAME|The format of the specified group name is invalid.
1210|ERROR_INVALID_COMPUTERNAME|The format of the specified computer name is invalid.
1211|ERROR_INVALID_EVENTNAME|The format of the specified event name is invalid.
1212|ERROR_INVALID_DOMAINNAME|The format of the specified domain name is invalid.
1213|ERROR_INVALID_SERVICENAME|The format of the specified service name is invalid.
1214|ERROR_INVALID_NETNAME|The format of the specified network name is invalid.
1215|ERROR_INVALID_SHARENAME|The format of the specified share name is invalid.
1216|ERROR_INVALID_PASSWORDNAME|The format of the specified password is invalid.
1217|ERROR_INVALID_MESSAGENAME|The format of the specified message name is invalid.
1218|ERROR_INVALID_MESSAGEDEST|The format of the specified message destination is invalid.
1219|ERROR_SESSION_CREDENTIAL_CONFLICT|Multiple connections to a server or shared resource by the same user, using more than one user name, are not allowed. Disconnect all previous connections to the server or shared resource and try again.
1220|ERROR_REMOTE_SESSION_LIMIT_EXCEEDED|An attempt was made to establish a session to a network server, but there are already too many sessions established to that server.
1221|ERROR_DUP_DOMAINNAME|The workgroup or domain name is already in use by another computer on the network.
1222|ERROR_NO_NETWORK|The network is not present or not started.
1223|ERROR_CANCELLED|The operation was canceled by the user.
1224|ERROR_USER_MAPPED_FILE|The requested operation cannot be performed on a file with a user-mapped section open.
1225|ERROR_CONNECTION_REFUSED|The remote computer refused the network connection.
1226|ERROR_GRACEFUL_DISCONNECT|The network connection was gracefully closed.
1227|ERROR_ADDRESS_ALREADY_ASSOCIATED|The network transport endpoint already has an address associated with it.
1228|ERROR_ADDRESS_NOT_ASSOCIATED|An address has not yet been associated with the network endpoint.
1229|ERROR_CONNECTION_INVALID|An operation was attempted on a nonexistent network connection.
1230|ERROR_CONNECTION_ACTIVE|An invalid operation was attempted on an active network connection.
1231|ERROR_NETWORK_UNREACHABLE|The network location cannot be reached. For information about network troubleshooting, see Windows Help.
1232|ERROR_HOST_UNREACHABLE|The network location cannot be reached. For information about network troubleshooting, see Windows Help.
1233|ERROR_PROTOCOL_UNREACHABLE|The network location cannot be reached. For information about network troubleshooting, see Windows Help.
1234|ERROR_PORT_UNREACHABLE|No service is operating at the destination network endpoint on the remote system.
1235|ERROR_REQUEST_ABORTED|The request was aborted.
1236|ERROR_CONNECTION_ABORTED|The network connection was aborted by the local system.
1237|ERROR_RETRY|The operation could not be completed. A retry should be performed.
1238|ERROR_CONNECTION_COUNT_LIMIT|A connection to the server could not be made because the limit on the number of concurrent connections for this account has been reached.
1239|ERROR_LOGIN_TIME_RESTRICTION|Attempting to log in during an unauthorized time of day for this account.
1240|ERROR_LOGIN_WKSTA_RESTRICTION|The account is not authorized to log in from this station.
1241|ERROR_INCORRECT_ADDRESS|The network address could not be used for the operation requested.
1242|ERROR_ALREADY_REGISTERED|The service is already registered.
1243|ERROR_SERVICE_NOT_FOUND|The specified service does not exist.
1244|ERROR_NOT_AUTHENTICATED|The operation being requested was not performed because the user has not been authenticated.
1245|ERROR_NOT_LOGGED_ON|The operation being requested was not performed because the user has not logged on to the network. The specified service does not exist.
1246|ERROR_CONTINUE|Continue with work in progress.
1247|ERROR_ALREADY_INITIALIZED|An attempt was made to perform an initialization operation when initialization has already been completed.
1248|ERROR_NO_MORE_DEVICES|No more local devices.
1249|ERROR_NO_SUCH_SITE|The specified site does not exist.
1250|ERROR_DOMAIN_CONTROLLER_EXISTS|A domain controller with the specified name already exists.
1251|ERROR_ONLY_IF_CONNECTED|This operation is supported only when you are connected to the server.
1252|ERROR_OVERRIDE_NOCHANGES|The group policy framework should call the extension even if there are no changes.
1253|ERROR_BAD_USER_PROFILE|The specified user does not have a valid profile.
1254|ERROR_NOT_SUPPORTED_ON_SBS|This operation is not supported on a computer running Windows Server 2003 for Small Business Server.
1255|ERROR_SERVER_SHUTDOWN_IN_PROGRESS|The server machine is shutting down.
1256|ERROR_HOST_DOWN|The remote system is not available. For information about network troubleshooting, see Windows Help.
1257|ERROR_NON_ACCOUNT_SID|The security identifier provided is not from an account domain.
1258|ERROR_NON_DOMAIN_SID|The security identifier provided does not have a domain component.
1259|ERROR_APPHELP_BLOCK|AppHelp dialog canceled thus preventing the application from starting.
1260|ERROR_ACCESS_DISABLED_BY_POLICY|This program is blocked by group policy. For more information, contact your system administrator.
1261|ERROR_REG_NAT_CONSUMPTION|A program attempt to use an invalid register value. Normally caused by an uninitialized register. This error is Itanium specific.
1262|ERROR_CSCSHARE_OFFLINE|The share is currently offline or does not exist.
1263|ERROR_PKINIT_FAILURE|The Kerberos protocol encountered an error while validating the KDC certificate during smartcard logon. There is more information in the system event log.
1264|ERROR_SMARTCARD_SUBSYSTEM_FAILURE|The Kerberos protocol encountered an error while attempting to utilize the smartcard subsystem.
1265|ERROR_DOWNGRADE_DETECTED|The system cannot contact a domain controller to service the authentication request. Please try again later.
1271|ERROR_MACHINE_LOCKED|The machine is locked and cannot be shut down without the force option.
1273|ERROR_CALLBACK_SUPPLIED_INVALID_DATA|An application-defined callback gave invalid data when called.
1274|ERROR_SYNC_FOREGROUND_REFRESH_REQUIRED|The group policy framework should call the extension in the synchronous foreground policy refresh.
1275|ERROR_DRIVER_BLOCKED|This driver has been blocked from loading.
1276|ERROR_INVALID_IMPORT_OF_NON_DLL|A dynamic link library (DLL) referenced a module that was neither a DLL nor the process's executable image.
1277|ERROR_ACCESS_DISABLED_WEBBLADE|Windows cannot open this program since it has been disabled.
1278|ERROR_ACCESS_DISABLED_WEBBLADE_TAMPER|Windows cannot open this program because the license enforcement system has been tampered with or become corrupted.
1279|ERROR_RECOVERY_FAILURE|A transaction recover failed.
1280|ERROR_ALREADY_FIBER|The current thread has already been converted to a fiber.
1281|ERROR_ALREADY_THREAD|The current thread has already been converted from a fiber.
1282|ERROR_STACK_BUFFER_OVERRUN|The system detected an overrun of a stack-based buffer in this application. This overrun could potentially allow a malicious user to gain control of this application.
1283|ERROR_PARAMETER_QUOTA_EXCEEDED|Data present in one of the parameters is more than the function can operate on.
1284|ERROR_DEBUGGER_INACTIVE|An attempt to do an operation on a debug object failed because the object is in the process of being deleted.
1285|ERROR_DELAY_LOAD_FAILED|An attempt to delay-load a .dll or get a function address in a delay-loaded .dll failed.
1286|ERROR_VDM_DISALLOWED|`%1 is a 16-bit application. You do not have permissions to execute 16-bit applications. Check your permissions with your system administrator.
1287|ERROR_UNIDENTIFIED_ERROR|Insufficient information exists to identify the cause of failure.
1288|ERROR_INVALID_CRUNTIME_PARAMETER|The parameter passed to a C runtime function is incorrect.
1289|ERROR_BEYOND_VDL|The operation occurred beyond the valid data length of the file.
1290|ERROR_INCOMPATIBLE_SERVICE_SID_TYPE|The service start failed since one or more services in the same process have an incompatible service SID type setting. A service with restricted service SID type can only coexist in the same process with other services with a restricted SID type. If the service SID type for this service was just configured, the hosting process must be restarted in order to start this service.`nOn Windows Server 2003 and Windows XP, an unrestricted service cannot coexist in the same process with other services. The service with the unrestricted service SID type must be moved to an owned process in order to start this service.
1291|ERROR_DRIVER_PROCESS_TERMINATED|The process hosting the driver for this device has been terminated.
1292|ERROR_IMPLEMENTATION_LIMIT|An operation attempted to exceed an implementation-defined limit.
1293|ERROR_PROCESS_IS_PROTECTED|Either the target process, or the target thread's containing process, is a protected process.
1294|ERROR_SERVICE_NOTIFY_CLIENT_LAGGING|The service notification client is lagging too far behind the current state of services in the machine.
1295|ERROR_DISK_QUOTA_EXCEEDED|The requested file operation failed because the storage quota was exceeded. To free up disk space, move files to a different location or delete unnecessary files. For more information, contact your system administrator.
1296|ERROR_CONTENT_BLOCKED|The requested file operation failed because the storage policy blocks that type of file. For more information, contact your system administrator.
1297|ERROR_INCOMPATIBLE_SERVICE_PRIVILEGE|A privilege that the service requires to function properly does not exist in the service account configuration. You may use the Services Microsoft Management Console (MMC) snap-in (services.msc) and the Local Security Settings MMC snap-in (secpol.msc) to view the service configuration and the account configuration.
1298|ERROR_APP_HANG|A thread involved in this operation appears to be unresponsive.
1299|ERROR_INVALID_LABEL|Indicates a particular Security ID may not be assigned as the label of an object.
1300|ERROR_NOT_ALL_ASSIGNED|Not all privileges or groups referenced are assigned to the caller.
1301|ERROR_SOME_NOT_MAPPED|Some mapping between account names and security IDs was not done.
1302|ERROR_NO_QUOTAS_FOR_ACCOUNT|No system quota limits are specifically set for this account.
1303|ERROR_LOCAL_USER_SESSION_KEY|No encryption key is available. A well-known encryption key was returned.
1304|ERROR_NULL_LM_PASSWORD|The password is too complex to be converted to a LAN Manager password. The LAN Manager password returned is a <strong>NULL</strong> string.
1305|ERROR_UNKNOWN_REVISION|The revision level is unknown.
1306|ERROR_REVISION_MISMATCH|Indicates two revision levels are incompatible.
1307|ERROR_INVALID_OWNER|This security ID may not be assigned as the owner of this object.
1308|ERROR_INVALID_PRIMARY_GROUP|This security ID may not be assigned as the primary group of an object.
1309|ERROR_NO_IMPERSONATION_TOKEN|An attempt has been made to operate on an impersonation token by a thread that is not currently impersonating a client.
1310|ERROR_CANT_DISABLE_MANDATORY|The group may not be disabled.
1311|ERROR_NO_LOGON_SERVERS|There are currently no logon servers available to service the logon request.
1312|ERROR_NO_SUCH_LOGON_SESSION|A specified logon session does not exist. It may already have been terminated.
1313|ERROR_NO_SUCH_PRIVILEGE|A specified privilege does not exist.
1314|ERROR_PRIVILEGE_NOT_HELD|A required privilege is not held by the client.
1315|ERROR_INVALID_ACCOUNT_NAME|The name provided is not a properly formed account name.
1316|ERROR_USER_EXISTS|The specified account already exists.
1317|ERROR_NO_SUCH_USER|The specified account does not exist.
1318|ERROR_GROUP_EXISTS|The specified group already exists.
1319|ERROR_NO_SUCH_GROUP|The specified group does not exist.
1320|ERROR_MEMBER_IN_GROUP|Either the specified user account is already a member of the specified group, or the specified group cannot be deleted because it contains a member.
1321|ERROR_MEMBER_NOT_IN_GROUP|The specified user account is not a member of the specified group account.
1322|ERROR_LAST_ADMIN|This operation is disallowed as it could result in an administration account being disabled, deleted or unable to log on.
1323|ERROR_WRONG_PASSWORD|Unable to update the password. The value provided as the current password is incorrect.
1324|ERROR_ILL_FORMED_PASSWORD|Unable to update the password. The value provided for the new password contains values that are not allowed in passwords.
1325|ERROR_PASSWORD_RESTRICTION|Unable to update the password. The value provided for the new password does not meet the length, complexity, or history requirements of the domain.
1326|ERROR_LOGON_FAILURE|The user name or password is incorrect.
1327|ERROR_ACCOUNT_RESTRICTION|Account restrictions are preventing this user from signing in. For example: blank passwords aren't allowed, sign-in times are limited, or a policy restriction has been enforced.
1328|ERROR_INVALID_LOGON_HOURS|Your account has time restrictions that keep you from signing in right now.
1329|ERROR_INVALID_WORKSTATION|This user isn't allowed to sign in to this computer.
1330|ERROR_PASSWORD_EXPIRED|The password for this account has expired.
1331|ERROR_ACCOUNT_DISABLED|This user can't sign in because this account is currently disabled.
1332|ERROR_NONE_MAPPED|No mapping between account names and security IDs was done.
1333|ERROR_TOO_MANY_LUIDS_REQUESTED|Too many local user identifiers (LUIDs) were requested at one time.
1334|ERROR_LUIDS_EXHAUSTED|No more local user identifiers (LUIDs) are available.
1335|ERROR_INVALID_SUB_AUTHORITY|The subauthority part of a security ID is invalid for this particular use.
1336|ERROR_INVALID_ACL|The access control list (ACL) structure is invalid.
1337|ERROR_INVALID_SID|The security ID structure is invalid.
1338|ERROR_INVALID_SECURITY_DESCR|The security descriptor structure is invalid.
1340|ERROR_BAD_INHERITANCE_ACL|The inherited access control list (ACL) or access control entry (ACE) could not be built.
1341|ERROR_SERVER_DISABLED|The server is currently disabled.
1342|ERROR_SERVER_NOT_DISABLED|The server is currently enabled.
1343|ERROR_INVALID_ID_AUTHORITY|The value provided was an invalid value for an identifier authority.
1344|ERROR_ALLOTTED_SPACE_EXCEEDED|No more memory is available for security information updates.
1345|ERROR_INVALID_GROUP_ATTRIBUTES|The specified attributes are invalid, or incompatible with the attributes for the group as a whole.
1346|ERROR_BAD_IMPERSONATION_LEVEL|Either a required impersonation level was not provided, or the provided impersonation level is invalid.
1347|ERROR_CANT_OPEN_ANONYMOUS|Cannot open an anonymous level security token.
1348|ERROR_BAD_VALIDATION_CLASS|The validation information class requested was invalid.
1349|ERROR_BAD_TOKEN_TYPE|The type of the token is inappropriate for its attempted use.
1350|ERROR_NO_SECURITY_ON_OBJECT|Unable to perform a security operation on an object that has no associated security.
1351|ERROR_CANT_ACCESS_DOMAIN_INFO|Configuration information could not be read from the domain controller, either because the machine is unavailable, or access has been denied.
1352|ERROR_INVALID_SERVER_STATE|The security account manager (SAM) or local security authority (LSA) server was in the wrong state to perform the security operation.
1353|ERROR_INVALID_DOMAIN_STATE|The domain was in the wrong state to perform the security operation.
1354|ERROR_INVALID_DOMAIN_ROLE|This operation is only allowed for the Primary Domain Controller of the domain.
1355|ERROR_NO_SUCH_DOMAIN|The specified domain either does not exist or could not be contacted.
1356|ERROR_DOMAIN_EXISTS|The specified domain already exists.
1357|ERROR_DOMAIN_LIMIT_EXCEEDED|An attempt was made to exceed the limit on the number of domains per server.
1358|ERROR_INTERNAL_DB_CORRUPTION|Unable to complete the requested operation because of either a catastrophic media failure or a data structure corruption on the disk.
1359|ERROR_INTERNAL_ERROR|An internal error occurred.
1360|ERROR_GENERIC_NOT_MAPPED|Generic access types were contained in an access mask which should already be mapped to nongeneric types.
1361|ERROR_BAD_DESCRIPTOR_FORMAT|A security descriptor is not in the right format (absolute or self-relative).
1362|ERROR_NOT_LOGON_PROCESS|The requested action is restricted for use by logon processes only. The calling process has not registered as a logon process.
1363|ERROR_LOGON_SESSION_EXISTS|Cannot start a new logon session with an ID that is already in use.
1364|ERROR_NO_SUCH_PACKAGE|A specified authentication package is unknown.
1365|ERROR_BAD_LOGON_SESSION_STATE|The logon session is not in a state that is consistent with the requested operation.
1366|ERROR_LOGON_SESSION_COLLISION|The logon session ID is already in use.
1367|ERROR_INVALID_LOGON_TYPE|A logon request contained an invalid logon type value.
1368|ERROR_CANNOT_IMPERSONATE|Unable to impersonate using a named pipe until data has been read from that pipe.
1369|ERROR_RXACT_INVALID_STATE|The transaction state of a registry subtree is incompatible with the requested operation.
1370|ERROR_RXACT_COMMIT_FAILURE|An internal security database corruption has been encountered.
1371|ERROR_SPECIAL_ACCOUNT|Cannot perform this operation on built-in accounts.
1372|ERROR_SPECIAL_GROUP|Cannot perform this operation on this built-in special group.
1373|ERROR_SPECIAL_USER|Cannot perform this operation on this built-in special user.
1374|ERROR_MEMBERS_PRIMARY_GROUP|The user cannot be removed from a group because the group is currently the user's primary group.
1375|ERROR_TOKEN_ALREADY_IN_USE|The token is already in use as a primary token.
1376|ERROR_NO_SUCH_ALIAS|The specified local group does not exist.
1377|ERROR_MEMBER_NOT_IN_ALIAS|The specified account name is not a member of the group.
1378|ERROR_MEMBER_IN_ALIAS|The specified account name is already a member of the group.
1379|ERROR_ALIAS_EXISTS|The specified local group already exists.
1380|ERROR_LOGON_NOT_GRANTED|Logon failure: the user has not been granted the requested logon type at this computer.
1381|ERROR_TOO_MANY_SECRETS|The maximum number of secrets that may be stored in a single system has been exceeded.
1382|ERROR_SECRET_TOO_LONG|The length of a secret exceeds the maximum length allowed.
1383|ERROR_INTERNAL_DB_ERROR|The local security authority database contains an internal inconsistency.
1384|ERROR_TOO_MANY_CONTEXT_IDS|During a logon attempt, the user's security context accumulated too many security IDs.
1385|ERROR_LOGON_TYPE_NOT_GRANTED|Logon failure: the user has not been granted the requested logon type at this computer.
1386|ERROR_NT_CROSS_ENCRYPTION_REQUIRED|A cross-encrypted password is necessary to change a user password.
1387|ERROR_NO_SUCH_MEMBER|A member could not be added to or removed from the local group because the member does not exist.
1388|ERROR_INVALID_MEMBER|A new member could not be added to a local group because the member has the wrong account type.
1389|ERROR_TOO_MANY_SIDS|Too many security IDs have been specified.
1390|ERROR_LM_CROSS_ENCRYPTION_REQUIRED|A cross-encrypted password is necessary to change this user password.
1391|ERROR_NO_INHERITANCE|Indicates an ACL contains no inheritable components.
1392|ERROR_FILE_CORRUPT|The file or directory is corrupted and unreadable.
1393|ERROR_DISK_CORRUPT|The disk structure is corrupted and unreadable.
1394|ERROR_NO_USER_SESSION_KEY|There is no user session key for the specified logon session.
1395|ERROR_LICENSE_QUOTA_EXCEEDED|The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept.
1396|ERROR_WRONG_TARGET_NAME|The target account name is incorrect.
1397|ERROR_MUTUAL_AUTH_FAILED|Mutual Authentication failed. The server's password is out of date at the domain controller.
1398|ERROR_TIME_SKEW|There is a time and/or date difference between the client and server.
1399|ERROR_CURRENT_DOMAIN_NOT_ALLOWED|This operation cannot be performed on the current domain.
1400|ERROR_INVALID_WINDOW_HANDLE|Invalid window handle.
1401|ERROR_INVALID_MENU_HANDLE|Invalid menu handle.
1402|ERROR_INVALID_CURSOR_HANDLE|Invalid cursor handle.
1403|ERROR_INVALID_ACCEL_HANDLE|Invalid accelerator table handle.
1404|ERROR_INVALID_HOOK_HANDLE|Invalid hook handle.
1405|ERROR_INVALID_DWP_HANDLE|Invalid handle to a multiple-window position structure.
1406|ERROR_TLW_WITH_WSCHILD|Cannot create a top-level child window.
1407|ERROR_CANNOT_FIND_WND_CLASS|Cannot find window class.
1408|ERROR_WINDOW_OF_OTHER_THREAD|Invalid window; it belongs to other thread.
1409|ERROR_HOTKEY_ALREADY_REGISTERED|Hot key is already registered.
1410|ERROR_CLASS_ALREADY_EXISTS|Class already exists.
1411|ERROR_CLASS_DOES_NOT_EXIST|Class does not exist.
1412|ERROR_CLASS_HAS_WINDOWS|Class still has open windows.
1413|ERROR_INVALID_INDEX|Invalid index.
1414|ERROR_INVALID_ICON_HANDLE|Invalid icon handle.
1415|ERROR_PRIVATE_DIALOG_INDEX|Using private DIALOG window words.
1416|ERROR_LISTBOX_ID_NOT_FOUND|The list box identifier was not found.
1417|ERROR_NO_WILDCARD_CHARACTERS|No wildcards were found.
1418|ERROR_CLIPBOARD_NOT_OPEN|Thread does not have a clipboard open.
1419|ERROR_HOTKEY_NOT_REGISTERED|Hot key is not registered.
1420|ERROR_WINDOW_NOT_DIALOG|The window is not a valid dialog window.
1421|ERROR_CONTROL_ID_NOT_FOUND|Control ID not found.
1422|ERROR_INVALID_COMBOBOX_MESSAGE|Invalid message for a combo box because it does not have an edit control.
1423|ERROR_WINDOW_NOT_COMBOBOX|The window is not a combo box.
1424|ERROR_INVALID_EDIT_HEIGHT|Height must be less than 256.
1425|ERROR_DC_NOT_FOUND|Invalid device context (DC) handle.
1426|ERROR_INVALID_HOOK_FILTER|Invalid hook procedure type.
1427|ERROR_INVALID_FILTER_PROC|Invalid hook procedure.
1428|ERROR_HOOK_NEEDS_HMOD|Cannot set nonlocal hook without a module handle.
1429|ERROR_GLOBAL_ONLY_HOOK|This hook procedure can only be set globally.
1430|ERROR_JOURNAL_HOOK_SET|The journal hook procedure is already installed.
1431|ERROR_HOOK_NOT_INSTALLED|The hook procedure is not installed.
1432|ERROR_INVALID_LB_MESSAGE|Invalid message for single-selection list box.
1433|ERROR_SETCOUNT_ON_BAD_LB|LB_SETCOUNT sent to non-lazy list box.
1434|ERROR_LB_WITHOUT_TABSTOPS|This list box does not support tab stops.
1435|ERROR_DESTROY_OBJECT_OF_OTHER_THREAD|Cannot destroy object created by another thread.
1436|ERROR_CHILD_WINDOW_MENU|Child windows cannot have menus.
1437|ERROR_NO_SYSTEM_MENU|The window does not have a system menu.
1438|ERROR_INVALID_MSGBOX_STYLE|Invalid message box style.
1439|ERROR_INVALID_SPI_VALUE|Invalid system-wide (SPI_*) parameter.
1440|ERROR_SCREEN_ALREADY_LOCKED|Screen already locked.
1441|ERROR_HWNDS_HAVE_DIFF_PARENT|All handles to windows in a multiple-window position structure must have the same parent.
1442|ERROR_NOT_CHILD_WINDOW|The window is not a child window.
1443|ERROR_INVALID_GW_COMMAND|Invalid GW_* command.
1444|ERROR_INVALID_THREAD_ID|Invalid thread identifier.
1445|ERROR_NON_MDICHILD_WINDOW|Cannot process a message from a window that is not a multiple document interface (MDI) window.
1446|ERROR_POPUP_ALREADY_ACTIVE|Popup menu already active.
1447|ERROR_NO_SCROLLBARS|The window does not have scroll bars.
1448|ERROR_INVALID_SCROLLBAR_RANGE|Scroll bar range cannot be greater than MAXLONG.
1449|ERROR_INVALID_SHOWWIN_COMMAND|Cannot show or remove the window in the way specified.
1450|ERROR_NO_SYSTEM_RESOURCES|Insufficient system resources exist to complete the requested service.
1451|ERROR_NONPAGED_SYSTEM_RESOURCES|Insufficient system resources exist to complete the requested service.
1452|ERROR_PAGED_SYSTEM_RESOURCES|Insufficient system resources exist to complete the requested service.
1453|ERROR_WORKING_SET_QUOTA|Insufficient quota to complete the requested service.
1454|ERROR_PAGEFILE_QUOTA|Insufficient quota to complete the requested service.
1455|ERROR_COMMITMENT_LIMIT|The paging file is too small for this operation to complete.
1456|ERROR_MENU_ITEM_NOT_FOUND|A menu item was not found.
1457|ERROR_INVALID_KEYBOARD_HANDLE|Invalid keyboard layout handle.
1458|ERROR_HOOK_TYPE_NOT_ALLOWED|Hook type not allowed.
1459|ERROR_REQUIRES_INTERACTIVE_WINDOWSTATION|This operation requires an interactive window station.
1460|ERROR_TIMEOUT|This operation returned because the timeout period expired.
1461|ERROR_INVALID_MONITOR_HANDLE|Invalid monitor handle.
1462|ERROR_INCORRECT_SIZE|Incorrect size argument.
1463|ERROR_SYMLINK_CLASS_DISABLED|The symbolic link cannot be followed because its type is disabled.
1464|ERROR_SYMLINK_NOT_SUPPORTED|This application does not support the current operation on symbolic links.
1465|ERROR_XML_PARSE_ERROR|Windows was unable to parse the requested XML data.
1466|ERROR_XMLDSIG_ERROR|An error was encountered while processing an XML digital signature.
1467|ERROR_RESTART_APPLICATION|This application must be restarted.
1468|ERROR_WRONG_COMPARTMENT|The caller made the connection request in the wrong routing compartment.
1469|ERROR_AUTHIP_FAILURE|There was an AuthIP failure when attempting to connect to the remote host.
1470|ERROR_NO_NVRAM_RESOURCES|Insufficient NVRAM resources exist to complete the requested service. A reboot might be required.
1471|ERROR_NOT_GUI_PROCESS|Unable to finish the requested operation because the specified process is not a GUI process.
1500|ERROR_EVENTLOG_FILE_CORRUPT|The event log file is corrupted.
1501|ERROR_EVENTLOG_CANT_START|No event log file could be opened, so the event logging service did not start.
1502|ERROR_LOG_FILE_FULL|The event log file is full.
1503|ERROR_EVENTLOG_FILE_CHANGED|The event log file has changed between read operations.
1550|ERROR_INVALID_TASK_NAME|The specified task name is invalid.
1551|ERROR_INVALID_TASK_INDEX|The specified task index is invalid.
1552|ERROR_THREAD_ALREADY_IN_TASK|The specified thread is already joining a task.
1601|ERROR_INSTALL_SERVICE_FAILURE|The Windows Installer Service could not be accessed. This can occur if the Windows Installer is not correctly installed. Contact your support personnel for assistance.
1602|ERROR_INSTALL_USEREXIT|User cancelled installation.
1603|ERROR_INSTALL_FAILURE|Fatal error during installation.
1604|ERROR_INSTALL_SUSPEND|Installation suspended, incomplete.
1605|ERROR_UNKNOWN_PRODUCT|This action is only valid for products that are currently installed.
1606|ERROR_UNKNOWN_FEATURE|Feature ID not registered.
1607|ERROR_UNKNOWN_COMPONENT|Component ID not registered.
1608|ERROR_UNKNOWN_PROPERTY|Unknown property.
1609|ERROR_INVALID_HANDLE_STATE|Handle is in an invalid state.
1610|ERROR_BAD_CONFIGURATION|The configuration data for this product is corrupt. Contact your support personnel.
1611|ERROR_INDEX_ABSENT|Component qualifier not present.
1612|ERROR_INSTALL_SOURCE_ABSENT|The installation source for this product is not available. Verify that the source exists and that you can access it.
1613|ERROR_INSTALL_PACKAGE_VERSION|This installation package cannot be installed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service.
1614|ERROR_PRODUCT_UNINSTALLED|Product is uninstalled.
1615|ERROR_BAD_QUERY_SYNTAX|SQL query syntax invalid or unsupported.
1616|ERROR_INVALID_FIELD|Record field does not exist.
1617|ERROR_DEVICE_REMOVED|The device has been removed.
1618|ERROR_INSTALL_ALREADY_RUNNING|Another installation is already in progress. Complete that installation before proceeding with this install.
1619|ERROR_INSTALL_PACKAGE_OPEN_FAILED|This installation package could not be opened. Verify that the package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer package.
1620|ERROR_INSTALL_PACKAGE_INVALID|This installation package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer package.
1621|ERROR_INSTALL_UI_FAILURE|There was an error starting the Windows Installer service user interface. Contact your support personnel.
1622|ERROR_INSTALL_LOG_FAILURE|Error opening installation log file. Verify that the specified log file location exists and that you can write to it.
1623|ERROR_INSTALL_LANGUAGE_UNSUPPORTED|The language of this installation package is not supported by your system.
1624|ERROR_INSTALL_TRANSFORM_FAILURE|Error applying transforms. Verify that the specified transform paths are valid.
1625|ERROR_INSTALL_PACKAGE_REJECTED|This installation is forbidden by system policy. Contact your system administrator.
1626|ERROR_FUNCTION_NOT_CALLED|Function could not be executed.
1627|ERROR_FUNCTION_FAILED|Function failed during execution.
1628|ERROR_INVALID_TABLE|Invalid or unknown table specified.
1629|ERROR_DATATYPE_MISMATCH|Data supplied is of wrong type.
1630|ERROR_UNSUPPORTED_TYPE|Data of this type is not supported.
1631|ERROR_CREATE_FAILED|The Windows Installer service failed to start. Contact your support personnel.
1632|ERROR_INSTALL_TEMP_UNWRITABLE|The Temp folder is on a drive that is full or is inaccessible. Free up space on the drive or verify that you have write permission on the Temp folder.
1633|ERROR_INSTALL_PLATFORM_UNSUPPORTED|This installation package is not supported by this processor type. Contact your product vendor.
1634|ERROR_INSTALL_NOTUSED|Component not used on this computer.
1635|ERROR_PATCH_PACKAGE_OPEN_FAILED|This update package could not be opened. Verify that the update package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer update package.
1636|ERROR_PATCH_PACKAGE_INVALID|This update package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer update package.
1637|ERROR_PATCH_PACKAGE_UNSUPPORTED|This update package cannot be processed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service.
1638|ERROR_PRODUCT_VERSION|Another version of this product is already installed. Installation of this version cannot continue. To configure or remove the existing version of this product, use Add/Remove Programs on the Control Panel.
1639|ERROR_INVALID_COMMAND_LINE|Invalid command line argument. Consult the Windows Installer SDK for detailed command line help.
1640|ERROR_INSTALL_REMOTE_DISALLOWED|Only administrators have permission to add, remove, or configure server software during a Terminal services remote session. If you want to install or configure software on the server, contact your network administrator.
1641|ERROR_SUCCESS_REBOOT_INITIATED|The requested operation completed successfully. The system will be restarted so the changes can take effect.
1642|ERROR_PATCH_TARGET_NOT_FOUND|The upgrade cannot be installed by the Windows Installer service because the program to be upgraded may be missing, or the upgrade may update a different version of the program. Verify that the program to be upgraded exists on your computer and that you have the correct upgrade.
1643|ERROR_PATCH_PACKAGE_REJECTED|The update package is not permitted by software restriction policy.
1644|ERROR_INSTALL_TRANSFORM_REJECTED|One or more customizations are not permitted by software restriction policy.
1645|ERROR_INSTALL_REMOTE_PROHIBITED|The Windows Installer does not permit installation from a Remote Desktop Connection.
1646|ERROR_PATCH_REMOVAL_UNSUPPORTED|Uninstallation of the update package is not supported.
1647|ERROR_UNKNOWN_PATCH|The update is not applied to this product.
1648|ERROR_PATCH_NO_SEQUENCE|No valid sequence could be found for the set of updates.
1649|ERROR_PATCH_REMOVAL_DISALLOWED|Update removal was disallowed by policy.
1650|ERROR_INVALID_PATCH_XML|The XML update data is invalid.
1651|ERROR_PATCH_MANAGED_ADVERTISED_PRODUCT|Windows Installer does not permit updating of managed advertised products. At least one feature of the product must be installed before applying the update.
1652|ERROR_INSTALL_SERVICE_SAFEBOOT|The Windows Installer service is not accessible in Safe Mode. Please try again when your computer is not in Safe Mode or you can use System Restore to return your machine to a previous good state.
1653|ERROR_FAIL_FAST_EXCEPTION|A fail fast exception occurred. Exception handlers will not be invoked and the process will be terminated immediately.
1654|ERROR_INSTALL_REJECTED|The app that you are trying to run is not supported on this version of Windows.
1700|RPC_S_INVALID_STRING_BINDING|The string binding is invalid.
1701|RPC_S_WRONG_KIND_OF_BINDING|The binding handle is not the correct type.
1702|RPC_S_INVALID_BINDING|The binding handle is invalid.
1703|RPC_S_PROTSEQ_NOT_SUPPORTED|The RPC protocol sequence is not supported.
1704|RPC_S_INVALID_RPC_PROTSEQ|The RPC protocol sequence is invalid.
1705|RPC_S_INVALID_STRING_UUID|The string universal unique identifier (UUID) is invalid.
1706|RPC_S_INVALID_ENDPOINT_FORMAT|The endpoint format is invalid.
1707|RPC_S_INVALID_NET_ADDR|The network address is invalid.
1708|RPC_S_NO_ENDPOINT_FOUND|No endpoint was found.
1709|RPC_S_INVALID_TIMEOUT|The timeout value is invalid.
1710|RPC_S_OBJECT_NOT_FOUND|The object universal unique identifier (UUID) was not found.
1711|RPC_S_ALREADY_REGISTERED|The object universal unique identifier (UUID) has already been registered.
1712|RPC_S_TYPE_ALREADY_REGISTERED|The type universal unique identifier (UUID) has already been registered.
1713|RPC_S_ALREADY_LISTENING|The RPC server is already listening.
1714|RPC_S_NO_PROTSEQS_REGISTERED|No protocol sequences have been registered.
1715|RPC_S_NOT_LISTENING|The RPC server is not listening.
1716|RPC_S_UNKNOWN_MGR_TYPE|The manager type is unknown.
1717|RPC_S_UNKNOWN_IF|The interface is unknown.
1718|RPC_S_NO_BINDINGS|There are no bindings.
1719|RPC_S_NO_PROTSEQS|There are no protocol sequences.
1720|RPC_S_CANT_CREATE_ENDPOINT|The endpoint cannot be created.
1721|RPC_S_OUT_OF_RESOURCES|Not enough resources are available to complete this operation.
1722|RPC_S_SERVER_UNAVAILABLE|The RPC server is unavailable.
1723|RPC_S_SERVER_TOO_BUSY|The RPC server is too busy to complete this operation.
1724|RPC_S_INVALID_NETWORK_OPTIONS|The network options are invalid.
1725|RPC_S_NO_CALL_ACTIVE|There are no remote procedure calls active on this thread.
1726|RPC_S_CALL_FAILED|The remote procedure call failed.
1727|RPC_S_CALL_FAILED_DNE|The remote procedure call failed and did not execute.
1728|RPC_S_PROTOCOL_ERROR|A remote procedure call (RPC) protocol error occurred.
1729|RPC_S_PROXY_ACCESS_DENIED|Access to the HTTP proxy is denied.
1730|RPC_S_UNSUPPORTED_TRANS_SYN|The transfer syntax is not supported by the RPC server.
1732|RPC_S_UNSUPPORTED_TYPE|The universal unique identifier (UUID) type is not supported.
1733|RPC_S_INVALID_TAG|The tag is invalid.
1734|RPC_S_INVALID_BOUND|The array bounds are invalid.
1735|RPC_S_NO_ENTRY_NAME|The binding does not contain an entry name.
1736|RPC_S_INVALID_NAME_SYNTAX|The name syntax is invalid.
1737|RPC_S_UNSUPPORTED_NAME_SYNTAX|The name syntax is not supported.
1739|RPC_S_UUID_NO_ADDRESS|No network address is available to use to construct a universal unique identifier (UUID).
1740|RPC_S_DUPLICATE_ENDPOINT|The endpoint is a duplicate.
1741|RPC_S_UNKNOWN_AUTHN_TYPE|The authentication type is unknown.
1742|RPC_S_MAX_CALLS_TOO_SMALL|The maximum number of calls is too small.
1743|RPC_S_STRING_TOO_LONG|The string is too long.
1744|RPC_S_PROTSEQ_NOT_FOUND|The RPC protocol sequence was not found.
1745|RPC_S_PROCNUM_OUT_OF_RANGE|The procedure number is out of range.
1746|RPC_S_BINDING_HAS_NO_AUTH|The binding does not contain any authentication information.
1747|RPC_S_UNKNOWN_AUTHN_SERVICE|The authentication service is unknown.
1748|RPC_S_UNKNOWN_AUTHN_LEVEL|The authentication level is unknown.
1749|RPC_S_INVALID_AUTH_IDENTITY|The security context is invalid.
1750|RPC_S_UNKNOWN_AUTHZ_SERVICE|The authorization service is unknown.
1751|EPT_S_INVALID_ENTRY|The entry is invalid.
1752|EPT_S_CANT_PERFORM_OP|The server endpoint cannot perform the operation.
1753|EPT_S_NOT_REGISTERED|There are no more endpoints available from the endpoint mapper.
1754|RPC_S_NOTHING_TO_EXPORT|No interfaces have been exported.
1755|RPC_S_INCOMPLETE_NAME|The entry name is incomplete.
1756|RPC_S_INVALID_VERS_OPTION|The version option is invalid.
1757|RPC_S_NO_MORE_MEMBERS|There are no more members.
1758|RPC_S_NOT_ALL_OBJS_UNEXPORTED|There is nothing to unexport.
1759|RPC_S_INTERFACE_NOT_FOUND|The interface was not found.
1760|RPC_S_ENTRY_ALREADY_EXISTS|The entry already exists.
1761|RPC_S_ENTRY_NOT_FOUND|The entry is not found.
1762|RPC_S_NAME_SERVICE_UNAVAILABLE|The name service is unavailable.
1763|RPC_S_INVALID_NAF_ID|The network address family is invalid.
1764|RPC_S_CANNOT_SUPPORT|The requested operation is not supported.
1765|RPC_S_NO_CONTEXT_AVAILABLE|No security context is available to allow impersonation.
1766|RPC_S_INTERNAL_ERROR|An internal error occurred in a remote procedure call (RPC).
1767|RPC_S_ZERO_DIVIDE|The RPC server attempted an integer division by zero.
1768|RPC_S_ADDRESS_ERROR|An addressing error occurred in the RPC server.
1769|RPC_S_FP_DIV_ZERO|A floating-point operation at the RPC server caused a division by zero.
1770|RPC_S_FP_UNDERFLOW|A floating-point underflow occurred at the RPC server.
1771|RPC_S_FP_OVERFLOW|A floating-point overflow occurred at the RPC server.
1772|RPC_X_NO_MORE_ENTRIES|The list of RPC servers available for the binding of auto handles has been exhausted.
1773|RPC_X_SS_CHAR_TRANS_OPEN_FAIL|Unable to open the character translation table file.
1774|RPC_X_SS_CHAR_TRANS_SHORT_FILE|The file containing the character translation table has fewer than 512 bytes.
1775|RPC_X_SS_IN_NULL_CONTEXT|A null context handle was passed from the client to the host during a remote procedure call.
1777|RPC_X_SS_CONTEXT_DAMAGED|The context handle changed during a remote procedure call.
1778|RPC_X_SS_HANDLES_MISMATCH|The binding handles passed to a remote procedure call do not match.
1779|RPC_X_SS_CANNOT_GET_CALL_HANDLE|The stub is unable to get the remote procedure call handle.
1780|RPC_X_NULL_REF_POINTER|A null reference pointer was passed to the stub.
1781|RPC_X_ENUM_VALUE_OUT_OF_RANGE|The enumeration value is out of range.
1782|RPC_X_BYTE_COUNT_TOO_SMALL|The byte count is too small.
1783|RPC_X_BAD_STUB_DATA|The stub received bad data.
1784|ERROR_INVALID_USER_BUFFER|The supplied user buffer is not valid for the requested operation.
1785|ERROR_UNRECOGNIZED_MEDIA|The disk media is not recognized. It may not be formatted.
1786|ERROR_NO_TRUST_LSA_SECRET|The workstation does not have a trust secret.
1787|ERROR_NO_TRUST_SAM_ACCOUNT|The security database on the server does not have a computer account for this workstation trust relationship.
1788|ERROR_TRUSTED_DOMAIN_FAILURE|The trust relationship between the primary domain and the trusted domain failed.
1789|ERROR_TRUSTED_RELATIONSHIP_FAILURE|The trust relationship between this workstation and the primary domain failed.
1790|ERROR_TRUST_FAILURE|The network logon failed.
1791|RPC_S_CALL_IN_PROGRESS|A remote procedure call is already in progress for this thread.
1792|ERROR_NETLOGON_NOT_STARTED|An attempt was made to logon, but the network logon service was not started.
1793|ERROR_ACCOUNT_EXPIRED|The user's account has expired.
1794|ERROR_REDIRECTOR_HAS_OPEN_HANDLES|The redirector is in use and cannot be unloaded.
1795|ERROR_PRINTER_DRIVER_ALREADY_INSTALLED|The specified printer driver is already installed.
1796|ERROR_UNKNOWN_PORT|The specified port is unknown.
1797|ERROR_UNKNOWN_PRINTER_DRIVER|The printer driver is unknown.
1798|ERROR_UNKNOWN_PRINTPROCESSOR|The print processor is unknown.
1799|ERROR_INVALID_SEPARATOR_FILE|The specified separator file is invalid.
1800|ERROR_INVALID_PRIORITY|The specified priority is invalid.
1801|ERROR_INVALID_PRINTER_NAME|The printer name is invalid.
1802|ERROR_PRINTER_ALREADY_EXISTS|The printer already exists.
1803|ERROR_INVALID_PRINTER_COMMAND|The printer command is invalid.
1804|ERROR_INVALID_DATATYPE|The specified datatype is invalid.
1805|ERROR_INVALID_ENVIRONMENT|The environment specified is invalid.
1806|RPC_S_NO_MORE_BINDINGS|There are no more bindings.
1807|ERROR_NOLOGON_INTERDOMAIN_TRUST_ACCOUNT|The account used is an interdomain trust account. Use your global user account or local user account to access this server.
1808|ERROR_NOLOGON_WORKSTATION_TRUST_ACCOUNT|The account used is a computer account. Use your global user account or local user account to access this server.
1809|ERROR_NOLOGON_SERVER_TRUST_ACCOUNT|The account used is a server trust account. Use your global user account or local user account to access this server.
1810|ERROR_DOMAIN_TRUST_INCONSISTENT|The name or security ID (SID) of the domain specified is inconsistent with the trust information for that domain.
1811|ERROR_SERVER_HAS_OPEN_HANDLES|The server is in use and cannot be unloaded.
1812|ERROR_RESOURCE_DATA_NOT_FOUND|The specified image file did not contain a resource section.
1813|ERROR_RESOURCE_TYPE_NOT_FOUND|The specified resource type cannot be found in the image file.
1814|ERROR_RESOURCE_NAME_NOT_FOUND|The specified resource name cannot be found in the image file.
1815|ERROR_RESOURCE_LANG_NOT_FOUND|The specified resource language ID cannot be found in the image file.
1816|ERROR_NOT_ENOUGH_QUOTA|Not enough quota is available to process this command.
1817|RPC_S_NO_INTERFACES|No interfaces have been registered.
1818|RPC_S_CALL_CANCELLED|The remote procedure call was cancelled.
1819|RPC_S_BINDING_INCOMPLETE|The binding handle does not contain all required information.
1820|RPC_S_COMM_FAILURE|A communications failure occurred during a remote procedure call.
1821|RPC_S_UNSUPPORTED_AUTHN_LEVEL|The requested authentication level is not supported.
1822|RPC_S_NO_PRINC_NAME|No principal name registered.
1823|RPC_S_NOT_RPC_ERROR|The error specified is not a valid Windows RPC error code.
1824|RPC_S_UUID_LOCAL_ONLY|A UUID that is valid only on this computer has been allocated.
1825|RPC_S_SEC_PKG_ERROR|A security package specific error occurred.
1826|RPC_S_NOT_CANCELLED|Thread is not canceled.
1827|RPC_X_INVALID_ES_ACTION|Invalid operation on the encoding/decoding handle.
1828|RPC_X_WRONG_ES_VERSION|Incompatible version of the serializing package.
1829|RPC_X_WRONG_STUB_VERSION|Incompatible version of the RPC stub.
1830|RPC_X_INVALID_PIPE_OBJECT|The RPC pipe object is invalid or corrupted.
1831|RPC_X_WRONG_PIPE_ORDER|An invalid operation was attempted on an RPC pipe object.
1832|RPC_X_WRONG_PIPE_VERSION|Unsupported RPC pipe version.
1833|RPC_S_COOKIE_AUTH_FAILED|HTTP proxy server rejected the connection because the cookie authentication failed.
1898|RPC_S_GROUP_MEMBER_NOT_FOUND|The group member was not found.
1899|EPT_S_CANT_CREATE|The endpoint mapper database entry could not be created.
1900|RPC_S_INVALID_OBJECT|The object universal unique identifier (UUID) is the nil UUID.
1901|ERROR_INVALID_TIME|The specified time is invalid.
1902|ERROR_INVALID_FORM_NAME|The specified form name is invalid.
1903|ERROR_INVALID_FORM_SIZE|The specified form size is invalid.
1904|ERROR_ALREADY_WAITING|The specified printer handle is already being waited on.
1905|ERROR_PRINTER_DELETED|The specified printer has been deleted.
1906|ERROR_INVALID_PRINTER_STATE|The state of the printer is invalid.
1907|ERROR_PASSWORD_MUST_CHANGE|The user's password must be changed before signing in.
1908|ERROR_DOMAIN_CONTROLLER_NOT_FOUND|Could not find the domain controller for this domain.
1909|ERROR_ACCOUNT_LOCKED_OUT|The referenced account is currently locked out and may not be logged on to.
1910|OR_INVALID_OXID|The object exporter specified was not found.
1911|OR_INVALID_OID|The object specified was not found.
1912|OR_INVALID_SET|The object resolver set specified was not found.
1913|RPC_S_SEND_INCOMPLETE|Some data remains to be sent in the request buffer.
1914|RPC_S_INVALID_ASYNC_HANDLE|Invalid asynchronous remote procedure call handle.
1915|RPC_S_INVALID_ASYNC_CALL|Invalid asynchronous RPC call handle for this operation.
1916|RPC_X_PIPE_CLOSED|The RPC pipe object has already been closed.
1917|RPC_X_PIPE_DISCIPLINE_ERROR|The RPC call completed before all pipes were processed.
1918|RPC_X_PIPE_EMPTY|No more data is available from the RPC pipe.
1919|ERROR_NO_SITENAME|No site name is available for this machine.
1920|ERROR_CANT_ACCESS_FILE|The file cannot be accessed by the system.
1921|ERROR_CANT_RESOLVE_FILENAME|The name of the file cannot be resolved by the system.
1922|RPC_S_ENTRY_TYPE_MISMATCH|The entry is not of the expected type.
1923|RPC_S_NOT_ALL_OBJS_EXPORTED|Not all object UUIDs could be exported to the specified entry.
1924|RPC_S_INTERFACE_NOT_EXPORTED|Interface could not be exported to the specified entry.
1925|RPC_S_PROFILE_NOT_ADDED|The specified profile entry could not be added.
1926|RPC_S_PRF_ELT_NOT_ADDED|The specified profile element could not be added.
1927|RPC_S_PRF_ELT_NOT_REMOVED|The specified profile element could not be removed.
1928|RPC_S_GRP_ELT_NOT_ADDED|The group element could not be added.
1929|RPC_S_GRP_ELT_NOT_REMOVED|The group element could not be removed.
1930|ERROR_KM_DRIVER_BLOCKED|The printer driver is not compatible with a policy enabled on your computer that blocks NT 4.0 drivers.
1931|ERROR_CONTEXT_EXPIRED|The context has expired and can no longer be used.
1932|ERROR_PER_USER_TRUST_QUOTA_EXCEEDED|The current user's delegated trust creation quota has been exceeded.
1933|ERROR_ALL_USER_TRUST_QUOTA_EXCEEDED|The total delegated trust creation quota has been exceeded.
1934|ERROR_USER_DELETE_TRUST_QUOTA_EXCEEDED|The current user's delegated trust deletion quota has been exceeded.
1935|ERROR_AUTHENTICATION_FIREWALL_FAILED|The computer you are signing into is protected by an authentication firewall. The specified account is not allowed to authenticate to the computer.
1936|ERROR_REMOTE_PRINT_CONNECTIONS_BLOCKED|Remote connections to the Print Spooler are blocked by a policy set on your machine.
1937|ERROR_NTLM_BLOCKED|Authentication failed because NTLM authentication has been disabled.
1938|ERROR_PASSWORD_CHANGE_REQUIRED|Logon Failure: EAS policy requires that the user change their password before this operation can be performed.
2000|ERROR_INVALID_PIXEL_FORMAT|The pixel format is invalid.
2001|ERROR_BAD_DRIVER|The specified driver is invalid.
2002|ERROR_INVALID_WINDOW_STYLE|The window style or class attribute is invalid for this operation.
2003|ERROR_METAFILE_NOT_SUPPORTED|The requested metafile operation is not supported.
2004|ERROR_TRANSFORM_NOT_SUPPORTED|The requested transformation operation is not supported.
2005|ERROR_CLIPPING_NOT_SUPPORTED|The requested clipping operation is not supported.
2010|ERROR_INVALID_CMM|The specified color management module is invalid.
2011|ERROR_INVALID_PROFILE|The specified color profile is invalid.
2012|ERROR_TAG_NOT_FOUND|The specified tag was not found.
2013|ERROR_TAG_NOT_PRESENT|A required tag is not present.
2014|ERROR_DUPLICATE_TAG|The specified tag is already present.
2015|ERROR_PROFILE_NOT_ASSOCIATED_WITH_DEVICE|The specified color profile is not associated with the specified device.
2016|ERROR_PROFILE_NOT_FOUND|The specified color profile was not found.
2017|ERROR_INVALID_COLORSPACE|The specified color space is invalid.
2018|ERROR_ICM_NOT_ENABLED|Image Color Management is not enabled.
2019|ERROR_DELETING_ICM_XFORM|There was an error while deleting the color transform.
2020|ERROR_INVALID_TRANSFORM|The specified color transform is invalid.
2021|ERROR_COLORSPACE_MISMATCH|The specified transform does not match the bitmap's color space.
2022|ERROR_INVALID_COLORINDEX|The specified named color index is not present in the profile.
2023|ERROR_PROFILE_DOES_NOT_MATCH_DEVICE|The specified profile is intended for a device of a different type than the specified device.
2108|ERROR_CONNECTED_OTHER_PASSWORD|The network connection was made successfully, but the user had to be prompted for a password other than the one originally specified.
2109|ERROR_CONNECTED_OTHER_PASSWORD_DEFAULT|The network connection was made successfully using default credentials.
2202|ERROR_BAD_USERNAME|The specified username is invalid.
2250|ERROR_NOT_CONNECTED|This network connection does not exist.
2401|ERROR_OPEN_FILES|This network connection has files open or requests pending.
2402|ERROR_ACTIVE_CONNECTIONS|Active connections still exist.
2404|ERROR_DEVICE_IN_USE|The device is in use by an active process and cannot be disconnected.
3000|ERROR_UNKNOWN_PRINT_MONITOR|The specified print monitor is unknown.
3001|ERROR_PRINTER_DRIVER_IN_USE|The specified printer driver is currently in use.
3002|ERROR_SPOOL_FILE_NOT_FOUND|The spool file was not found.
3003|ERROR_SPL_NO_STARTDOC|A StartDocPrinter call was not issued.
3004|ERROR_SPL_NO_ADDJOB|An AddJob call was not issued.
3005|ERROR_PRINT_PROCESSOR_ALREADY_INSTALLED|The specified print processor has already been installed.
3006|ERROR_PRINT_MONITOR_ALREADY_INSTALLED|The specified print monitor has already been installed.
3007|ERROR_INVALID_PRINT_MONITOR|The specified print monitor does not have the required functions.
3008|ERROR_PRINT_MONITOR_IN_USE|The specified print monitor is currently in use.
3009|ERROR_PRINTER_HAS_JOBS_QUEUED|The requested operation is not allowed when there are jobs queued to the printer.
3010|ERROR_SUCCESS_REBOOT_REQUIRED|The requested operation is successful. Changes will not be effective until the system is rebooted.
3011|ERROR_SUCCESS_RESTART_REQUIRED|The requested operation is successful. Changes will not be effective until the service is restarted.
3012|ERROR_PRINTER_NOT_FOUND|No printers were found.
3013|ERROR_PRINTER_DRIVER_WARNED|The printer driver is known to be unreliable.
3014|ERROR_PRINTER_DRIVER_BLOCKED|The printer driver is known to harm the system.
3015|ERROR_PRINTER_DRIVER_PACKAGE_IN_USE|The specified printer driver package is currently in use.
3016|ERROR_CORE_DRIVER_PACKAGE_NOT_FOUND|Unable to find a core driver package that is required by the printer driver package.
3017|ERROR_FAIL_REBOOT_REQUIRED|The requested operation failed. A system reboot is required to roll back changes made.
3018|ERROR_FAIL_REBOOT_INITIATED|The requested operation failed. A system reboot has been initiated to roll back changes made.
3019|ERROR_PRINTER_DRIVER_DOWNLOAD_NEEDED|The specified printer driver was not found on the system and needs to be downloaded.
3020|ERROR_PRINT_JOB_RESTART_REQUIRED|The requested print job has failed to print. A print system update requires the job to be resubmitted.
3021|ERROR_INVALID_PRINTER_DRIVER_MANIFEST|The printer driver does not contain a valid manifest, or contains too many manifests.
3022|ERROR_PRINTER_NOT_SHAREABLE|The specified printer cannot be shared.
3050|ERROR_REQUEST_PAUSED|The operation was paused.
3950|ERROR_IO_REISSUE_AS_CACHED|Reissue the given operation as a cached IO operation.
4000|ERROR_WINS_INTERNAL|WINS encountered an error while processing the command.
4001|ERROR_CAN_NOT_DEL_LOCAL_WINS|The local WINS cannot be deleted.
4002|ERROR_STATIC_INIT|The importation from the file failed.
4003|ERROR_INC_BACKUP|The backup failed. Was a full backup done before?
4004|ERROR_FULL_BACKUP|The backup failed. Check the directory to which you are backing the database.
4005|ERROR_REC_NON_EXISTENT|The name does not exist in the WINS database.
4006|ERROR_RPL_NOT_ALLOWED|Replication with a nonconfigured partner is not allowed.
4050|PEERDIST_ERROR_CONTENTINFO_VERSION_UNSUPPORTED|The version of the supplied content information is not supported.
4051|PEERDIST_ERROR_CANNOT_PARSE_CONTENTINFO|The supplied content information is malformed.
4052|PEERDIST_ERROR_MISSING_DATA|The requested data cannot be found in local or peer caches.
4053|PEERDIST_ERROR_NO_MORE|No more data is available or required.
4054|PEERDIST_ERROR_NOT_INITIALIZED|The supplied object has not been initialized.
4055|PEERDIST_ERROR_ALREADY_INITIALIZED|The supplied object has already been initialized.
4056|PEERDIST_ERROR_SHUTDOWN_IN_PROGRESS|A shutdown operation is already in progress.
4057|PEERDIST_ERROR_INVALIDATED|The supplied object has already been invalidated.
4058|PEERDIST_ERROR_ALREADY_EXISTS|An element already exists and was not replaced.
4059|PEERDIST_ERROR_OPERATION_NOTFOUND|Can not cancel the requested operation as it has already been completed.
4060|PEERDIST_ERROR_ALREADY_COMPLETED|Can not perform the reqested operation because it has already been carried out.
4061|PEERDIST_ERROR_OUT_OF_BOUNDS|An operation accessed data beyond the bounds of valid data.
4062|PEERDIST_ERROR_VERSION_UNSUPPORTED|The requested version is not supported.
4063|PEERDIST_ERROR_INVALID_CONFIGURATION|A configuration value is invalid.
4064|PEERDIST_ERROR_NOT_LICENSED|The SKU is not licensed.
4065|PEERDIST_ERROR_SERVICE_UNAVAILABLE|PeerDist Service is still initializing and will be available shortly.
4066|PEERDIST_ERROR_TRUST_FAILURE|Communication with one or more computers will be temporarily blocked due to recent errors.
4100|ERROR_DHCP_ADDRESS_CONFLICT|The DHCP client has obtained an IP address that is already in use on the network. The local interface will be disabled until the DHCP client can obtain a new address.
4200|ERROR_WMI_GUID_NOT_FOUND|The GUID passed was not recognized as valid by a WMI data provider.
4201|ERROR_WMI_INSTANCE_NOT_FOUND|The instance name passed was not recognized as valid by a WMI data provider.
4202|ERROR_WMI_ITEMID_NOT_FOUND|The data item ID passed was not recognized as valid by a WMI data provider.
4203|ERROR_WMI_TRY_AGAIN|The WMI request could not be completed and should be retried.
4204|ERROR_WMI_DP_NOT_FOUND|The WMI data provider could not be located.
4205|ERROR_WMI_UNRESOLVED_INSTANCE_REF|The WMI data provider references an instance set that has not been registered.
4206|ERROR_WMI_ALREADY_ENABLED|The WMI data block or event notification has already been enabled.
4207|ERROR_WMI_GUID_DISCONNECTED|The WMI data block is no longer available.
4208|ERROR_WMI_SERVER_UNAVAILABLE|The WMI data service is not available.
4209|ERROR_WMI_DP_FAILED|The WMI data provider failed to carry out the request.
4210|ERROR_WMI_INVALID_MOF|The WMI MOF information is not valid.
4211|ERROR_WMI_INVALID_REGINFO|The WMI registration information is not valid.
4212|ERROR_WMI_ALREADY_DISABLED|The WMI data block or event notification has already been disabled.
4213|ERROR_WMI_READ_ONLY|The WMI data item or data block is read only.
4214|ERROR_WMI_SET_FAILURE|The WMI data item or data block could not be changed.
4250|ERROR_NOT_APPCONTAINER|This operation is only valid in the context of an app container.
4251|ERROR_APPCONTAINER_REQUIRED|This application can only run in the context of an app container.
4252|ERROR_NOT_SUPPORTED_IN_APPCONTAINER|This functionality is not supported in the context of an app container.
4253|ERROR_INVALID_PACKAGE_SID_LENGTH|The length of the SID supplied is not a valid length for app container SIDs.
4300|ERROR_INVALID_MEDIA|The media identifier does not represent a valid medium.
4301|ERROR_INVALID_LIBRARY|The library identifier does not represent a valid library.
4302|ERROR_INVALID_MEDIA_POOL|The media pool identifier does not represent a valid media pool.
4303|ERROR_DRIVE_MEDIA_MISMATCH|The drive and medium are not compatible or exist in different libraries.
4304|ERROR_MEDIA_OFFLINE|The medium currently exists in an offline library and must be online to perform this operation.
4305|ERROR_LIBRARY_OFFLINE|The operation cannot be performed on an offline library.
4306|ERROR_EMPTY|The library, drive, or media pool is empty.
4307|ERROR_NOT_EMPTY|The library, drive, or media pool must be empty to perform this operation.
4308|ERROR_MEDIA_UNAVAILABLE|No media is currently available in this media pool or library.
4309|ERROR_RESOURCE_DISABLED|A resource required for this operation is disabled.
4310|ERROR_INVALID_CLEANER|The media identifier does not represent a valid cleaner.
4311|ERROR_UNABLE_TO_CLEAN|The drive cannot be cleaned or does not support cleaning.
4312|ERROR_OBJECT_NOT_FOUND|The object identifier does not represent a valid object.
4313|ERROR_DATABASE_FAILURE|Unable to read from or write to the database.
4314|ERROR_DATABASE_FULL|The database is full.
4315|ERROR_MEDIA_INCOMPATIBLE|The medium is not compatible with the device or media pool.
4316|ERROR_RESOURCE_NOT_PRESENT|The resource required for this operation does not exist.
4317|ERROR_INVALID_OPERATION|The operation identifier is not valid.
4318|ERROR_MEDIA_NOT_AVAILABLE|The media is not mounted or ready for use.
4319|ERROR_DEVICE_NOT_AVAILABLE|The device is not ready for use.
4320|ERROR_REQUEST_REFUSED|The operator or administrator has refused the request.
4321|ERROR_INVALID_DRIVE_OBJECT|The drive identifier does not represent a valid drive.
4322|ERROR_LIBRARY_FULL|Library is full. No slot is available for use.
4323|ERROR_MEDIUM_NOT_ACCESSIBLE|The transport cannot access the medium.
4324|ERROR_UNABLE_TO_LOAD_MEDIUM|Unable to load the medium into the drive.
4325|ERROR_UNABLE_TO_INVENTORY_DRIVE|Unable to retrieve the drive status.
4326|ERROR_UNABLE_TO_INVENTORY_SLOT|Unable to retrieve the slot status.
4327|ERROR_UNABLE_TO_INVENTORY_TRANSPORT|Unable to retrieve status about the transport.
4328|ERROR_TRANSPORT_FULL|Cannot use the transport because it is already in use.
4329|ERROR_CONTROLLING_IEPORT|Unable to open or close the inject/eject port.
4330|ERROR_UNABLE_TO_EJECT_MOUNTED_MEDIA|Unable to eject the medium because it is in a drive.
4331|ERROR_CLEANER_SLOT_SET|A cleaner slot is already reserved.
4332|ERROR_CLEANER_SLOT_NOT_SET|A cleaner slot is not reserved.
4333|ERROR_CLEANER_CARTRIDGE_SPENT|The cleaner cartridge has performed the maximum number of drive cleanings.
4334|ERROR_UNEXPECTED_OMID|Unexpected on-medium identifier.
4335|ERROR_CANT_DELETE_LAST_ITEM|The last remaining item in this group or resource cannot be deleted.
4336|ERROR_MESSAGE_EXCEEDS_MAX_SIZE|The message provided exceeds the maximum size allowed for this parameter.
4337|ERROR_VOLUME_CONTAINS_SYS_FILES|The volume contains system or paging files.
4338|ERROR_INDIGENOUS_TYPE|The media type cannot be removed from this library since at least one drive in the library reports it can support this media type.
4339|ERROR_NO_SUPPORTING_DRIVES|This offline media cannot be mounted on this system since no enabled drives are present which can be used.
4340|ERROR_CLEANER_CARTRIDGE_INSTALLED|A cleaner cartridge is present in the tape library.
4341|ERROR_IEPORT_FULL|Cannot use the inject/eject port because it is not empty.
4350|ERROR_FILE_OFFLINE|This file is currently not available for use on this computer.
4351|ERROR_REMOTE_STORAGE_NOT_ACTIVE|The remote storage service is not operational at this time.
4352|ERROR_REMOTE_STORAGE_MEDIA_ERROR|The remote storage service encountered a media error.
4390|ERROR_NOT_A_REPARSE_POINT|The file or directory is not a reparse point.
4391|ERROR_REPARSE_ATTRIBUTE_CONFLICT|The reparse point attribute cannot be set because it conflicts with an existing attribute.
4392|ERROR_INVALID_REPARSE_DATA|The data present in the reparse point buffer is invalid.
4393|ERROR_REPARSE_TAG_INVALID|The tag present in the reparse point buffer is invalid.
4394|ERROR_REPARSE_TAG_MISMATCH|There is a mismatch between the tag specified in the request and the tag present in the reparse point.
4400|ERROR_APP_DATA_NOT_FOUND|Fast Cache data not found.
4401|ERROR_APP_DATA_EXPIRED|Fast Cache data expired.
4402|ERROR_APP_DATA_CORRUPT|Fast Cache data corrupt.
4403|ERROR_APP_DATA_LIMIT_EXCEEDED|Fast Cache data has exceeded its max size and cannot be updated.
4404|ERROR_APP_DATA_REBOOT_REQUIRED|Fast Cache has been ReArmed and requires a reboot until it can be updated.
4420|ERROR_SECUREBOOT_ROLLBACK_DETECTED|Secure Boot detected that rollback of protected data has been attempted.
4421|ERROR_SECUREBOOT_POLICY_VIOLATION|The value is protected by Secure Boot policy and cannot be modified or deleted.
4422|ERROR_SECUREBOOT_INVALID_POLICY|The Secure Boot policy is invalid.
4423|ERROR_SECUREBOOT_POLICY_PUBLISHER_NOT_FOUND|A new Secure Boot policy did not contain the current publisher on its update list.
4424|ERROR_SECUREBOOT_POLICY_NOT_SIGNED|The Secure Boot policy is either not signed or is signed by a non-trusted signer.
4425|ERROR_SECUREBOOT_NOT_ENABLED|Secure Boot is not enabled on this machine.
4426|ERROR_SECUREBOOT_FILE_REPLACED|Secure Boot requires that certain files and drivers are not replaced by other files or drivers.
4440|ERROR_OFFLOAD_READ_FLT_NOT_SUPPORTED|The copy offload read operation is not supported by a filter.
4441|ERROR_OFFLOAD_WRITE_FLT_NOT_SUPPORTED|The copy offload write operation is not supported by a filter.
4442|ERROR_OFFLOAD_READ_FILE_NOT_SUPPORTED|The copy offload read operation is not supported for the file.
4443|ERROR_OFFLOAD_WRITE_FILE_NOT_SUPPORTED|The copy offload write operation is not supported for the file.
4500|ERROR_VOLUME_NOT_SIS_ENABLED|Single Instance Storage is not available on this volume.
5001|ERROR_DEPENDENT_RESOURCE_EXISTS|The operation cannot be completed because other resources are dependent on this resource.
5002|ERROR_DEPENDENCY_NOT_FOUND|The cluster resource dependency cannot be found.
5003|ERROR_DEPENDENCY_ALREADY_EXISTS|The cluster resource cannot be made dependent on the specified resource because it is already dependent.
5004|ERROR_RESOURCE_NOT_ONLINE|The cluster resource is not online.
5005|ERROR_HOST_NODE_NOT_AVAILABLE|A cluster node is not available for this operation.
5006|ERROR_RESOURCE_NOT_AVAILABLE|The cluster resource is not available.
5007|ERROR_RESOURCE_NOT_FOUND|The cluster resource could not be found.
5008|ERROR_SHUTDOWN_CLUSTER|The cluster is being shut down.
5009|ERROR_CANT_EVICT_ACTIVE_NODE|A cluster node cannot be evicted from the cluster unless the node is down or it is the last node.
5010|ERROR_OBJECT_ALREADY_EXISTS|The object already exists.
5011|ERROR_OBJECT_IN_LIST|The object is already in the list.
5012|ERROR_GROUP_NOT_AVAILABLE|The cluster group is not available for any new requests.
5013|ERROR_GROUP_NOT_FOUND|The cluster group could not be found.
5014|ERROR_GROUP_NOT_ONLINE|The operation could not be completed because the cluster group is not online.
5015|ERROR_HOST_NODE_NOT_RESOURCE_OWNER|The operation failed because either the specified cluster node is not the owner of the resource, or the node is not a possible owner of the resource.
5016|ERROR_HOST_NODE_NOT_GROUP_OWNER|The operation failed because either the specified cluster node is not the owner of the group, or the node is not a possible owner of the group.
5017|ERROR_RESMON_CREATE_FAILED|The cluster resource could not be created in the specified resource monitor.
5018|ERROR_RESMON_ONLINE_FAILED|The cluster resource could not be brought online by the resource monitor.
5019|ERROR_RESOURCE_ONLINE|The operation could not be completed because the cluster resource is online.
5020|ERROR_QUORUM_RESOURCE|The cluster resource could not be deleted or brought offline because it is the quorum resource.
5021|ERROR_NOT_QUORUM_CAPABLE|The cluster could not make the specified resource a quorum resource because it is not capable of being a quorum resource.
5022|ERROR_CLUSTER_SHUTTING_DOWN|The cluster software is shutting down.
5023|ERROR_INVALID_STATE|The group or resource is not in the correct state to perform the requested operation.
5024|ERROR_RESOURCE_PROPERTIES_STORED|The properties were stored but not all changes will take effect until the next time the resource is brought online.
5025|ERROR_NOT_QUORUM_CLASS|The cluster could not make the specified resource a quorum resource because it does not belong to a shared storage class.
5026|ERROR_CORE_RESOURCE|The cluster resource could not be deleted since it is a core resource.
5027|ERROR_QUORUM_RESOURCE_ONLINE_FAILED|The quorum resource failed to come online.
5028|ERROR_QUORUMLOG_OPEN_FAILED|The quorum log could not be created or mounted successfully.
5029|ERROR_CLUSTERLOG_CORRUPT|The cluster log is corrupt.
5030|ERROR_CLUSTERLOG_RECORD_EXCEEDS_MAXSIZE|The record could not be written to the cluster log since it exceeds the maximum size.
5031|ERROR_CLUSTERLOG_EXCEEDS_MAXSIZE|The cluster log exceeds its maximum size.
5032|ERROR_CLUSTERLOG_CHKPOINT_NOT_FOUND|No checkpoint record was found in the cluster log.
5033|ERROR_CLUSTERLOG_NOT_ENOUGH_SPACE|The minimum required disk space needed for logging is not available.
5034|ERROR_QUORUM_OWNER_ALIVE|The cluster node failed to take control of the quorum resource because the resource is owned by another active node.
5035|ERROR_NETWORK_NOT_AVAILABLE|A cluster network is not available for this operation.
5036|ERROR_NODE_NOT_AVAILABLE|A cluster node is not available for this operation.
5037|ERROR_ALL_NODES_NOT_AVAILABLE|All cluster nodes must be running to perform this operation.
5038|ERROR_RESOURCE_FAILED|A cluster resource failed.
5039|ERROR_CLUSTER_INVALID_NODE|The cluster node is not valid.
5040|ERROR_CLUSTER_NODE_EXISTS|The cluster node already exists.
5041|ERROR_CLUSTER_JOIN_IN_PROGRESS|A node is in the process of joining the cluster.
5042|ERROR_CLUSTER_NODE_NOT_FOUND|The cluster node was not found.
5043|ERROR_CLUSTER_LOCAL_NODE_NOT_FOUND|The cluster local node information was not found.
5044|ERROR_CLUSTER_NETWORK_EXISTS|The cluster network already exists.
5045|ERROR_CLUSTER_NETWORK_NOT_FOUND|The cluster network was not found.
5046|ERROR_CLUSTER_NETINTERFACE_EXISTS|The cluster network interface already exists.
5047|ERROR_CLUSTER_NETINTERFACE_NOT_FOUND|The cluster network interface was not found.
5048|ERROR_CLUSTER_INVALID_REQUEST|The cluster request is not valid for this object.
5049|ERROR_CLUSTER_INVALID_NETWORK_PROVIDER|The cluster network provider is not valid.
5050|ERROR_CLUSTER_NODE_DOWN|The cluster node is down.
5051|ERROR_CLUSTER_NODE_UNREACHABLE|The cluster node is not reachable.
5052|ERROR_CLUSTER_NODE_NOT_MEMBER|The cluster node is not a member of the cluster.
5053|ERROR_CLUSTER_JOIN_NOT_IN_PROGRESS|A cluster join operation is not in progress.
5054|ERROR_CLUSTER_INVALID_NETWORK|The cluster network is not valid.
5056|ERROR_CLUSTER_NODE_UP|The cluster node is up.
5057|ERROR_CLUSTER_IPADDR_IN_USE|The cluster IP address is already in use.
5058|ERROR_CLUSTER_NODE_NOT_PAUSED|The cluster node is not paused.
5059|ERROR_CLUSTER_NO_SECURITY_CONTEXT|No cluster security context is available.
5060|ERROR_CLUSTER_NETWORK_NOT_INTERNAL|The cluster network is not configured for internal cluster communication.
5061|ERROR_CLUSTER_NODE_ALREADY_UP|The cluster node is already up.
5062|ERROR_CLUSTER_NODE_ALREADY_DOWN|The cluster node is already down.
5063|ERROR_CLUSTER_NETWORK_ALREADY_ONLINE|The cluster network is already online.
5064|ERROR_CLUSTER_NETWORK_ALREADY_OFFLINE|The cluster network is already offline.
5065|ERROR_CLUSTER_NODE_ALREADY_MEMBER|The cluster node is already a member of the cluster.
5066|ERROR_CLUSTER_LAST_INTERNAL_NETWORK|The cluster network is the only one configured for internal cluster communication between two or more active cluster nodes. The internal communication capability cannot be removed from the network.
5067|ERROR_CLUSTER_NETWORK_HAS_DEPENDENTS|One or more cluster resources depend on the network to provide service to clients. The client access capability cannot be removed from the network.
5068|ERROR_INVALID_OPERATION_ON_QUORUM|This operation cannot be performed on the cluster resource as it the quorum resource. You may not bring the quorum resource offline or modify its possible owners list.
5069|ERROR_DEPENDENCY_NOT_ALLOWED|The cluster quorum resource is not allowed to have any dependencies.
5070|ERROR_CLUSTER_NODE_PAUSED|The cluster node is paused.
5071|ERROR_NODE_CANT_HOST_RESOURCE|The cluster resource cannot be brought online. The owner node cannot run this resource.
5072|ERROR_CLUSTER_NODE_NOT_READY|The cluster node is not ready to perform the requested operation.
5073|ERROR_CLUSTER_NODE_SHUTTING_DOWN|The cluster node is shutting down.
5074|ERROR_CLUSTER_JOIN_ABORTED|The cluster join operation was aborted.
5075|ERROR_CLUSTER_INCOMPATIBLE_VERSIONS|The cluster join operation failed due to incompatible software versions between the joining node and its sponsor.
5076|ERROR_CLUSTER_MAXNUM_OF_RESOURCES_EXCEEDED|This resource cannot be created because the cluster has reached the limit on the number of resources it can monitor.
5077|ERROR_CLUSTER_SYSTEM_CONFIG_CHANGED|The system configuration changed during the cluster join or form operation. The join or form operation was aborted.
5078|ERROR_CLUSTER_RESOURCE_TYPE_NOT_FOUND|The specified resource type was not found.
5079|ERROR_CLUSTER_RESTYPE_NOT_SUPPORTED|The specified node does not support a resource of this type. This may be due to version inconsistencies or due to the absence of the resource DLL on this node.
5080|ERROR_CLUSTER_RESNAME_NOT_FOUND|The specified resource name is not supported by this resource DLL. This may be due to a bad (or changed) name supplied to the resource DLL.
5081|ERROR_CLUSTER_NO_RPC_PACKAGES_REGISTERED|No authentication package could be registered with the RPC server.
5082|ERROR_CLUSTER_OWNER_NOT_IN_PREFLIST|You cannot bring the group online because the owner of the group is not in the preferred list for the group. To change the owner node for the group, move the group.
5083|ERROR_CLUSTER_DATABASE_SEQMISMATCH|The join operation failed because the cluster database sequence number has changed or is incompatible with the locker node. This may happen during a join operation if the cluster database was changing during the join.
5084|ERROR_RESMON_INVALID_STATE|The resource monitor will not allow the fail operation to be performed while the resource is in its current state. This may happen if the resource is in a pending state.
5085|ERROR_CLUSTER_GUM_NOT_LOCKER|A non locker code got a request to reserve the lock for making global updates.
5086|ERROR_QUORUM_DISK_NOT_FOUND|The quorum disk could not be located by the cluster service.
5087|ERROR_DATABASE_BACKUP_CORRUPT|The backed up cluster database is possibly corrupt.
5088|ERROR_CLUSTER_NODE_ALREADY_HAS_DFS_ROOT|A DFS root already exists in this cluster node.
5089|ERROR_RESOURCE_PROPERTY_UNCHANGEABLE|An attempt to modify a resource property failed because it conflicts with another existing property.
5890|ERROR_CLUSTER_MEMBERSHIP_INVALID_STATE|An operation was attempted that is incompatible with the current membership state of the node.
5891|ERROR_CLUSTER_QUORUMLOG_NOT_FOUND|The quorum resource does not contain the quorum log.
5892|ERROR_CLUSTER_MEMBERSHIP_HALT|The membership engine requested shutdown of the cluster service on this node.
5893|ERROR_CLUSTER_INSTANCE_ID_MISMATCH|The join operation failed because the cluster instance ID of the joining node does not match the cluster instance ID of the sponsor node.
5894|ERROR_CLUSTER_NETWORK_NOT_FOUND_FOR_IP|A matching cluster network for the specified IP address could not be found.
5895|ERROR_CLUSTER_PROPERTY_DATA_TYPE_MISMATCH|The actual data type of the property did not match the expected data type of the property.
5896|ERROR_CLUSTER_EVICT_WITHOUT_CLEANUP|The cluster node was evicted from the cluster successfully, but the node was not cleaned up. To determine what cleanup steps failed and how to recover, see the Failover Clustering application event log using Event Viewer.
5897|ERROR_CLUSTER_PARAMETER_MISMATCH|Two or more parameter values specified for a resource's properties are in conflict.
5898|ERROR_NODE_CANNOT_BE_CLUSTERED|This computer cannot be made a member of a cluster.
5899|ERROR_CLUSTER_WRONG_OS_VERSION|This computer cannot be made a member of a cluster because it does not have the correct version of Windows installed.
5900|ERROR_CLUSTER_CANT_CREATE_DUP_CLUSTER_NAME|A cluster cannot be created with the specified cluster name because that cluster name is already in use. Specify a different name for the cluster.
5901|ERROR_CLUSCFG_ALREADY_COMMITTED|The cluster configuration action has already been committed.
5902|ERROR_CLUSCFG_ROLLBACK_FAILED|The cluster configuration action could not be rolled back.
5903|ERROR_CLUSCFG_SYSTEM_DISK_DRIVE_LETTER_CONFLICT|The drive letter assigned to a system disk on one node conflicted with the drive letter assigned to a disk on another node.
5904|ERROR_CLUSTER_OLD_VERSION|One or more nodes in the cluster are running a version of Windows that does not support this operation.
5905|ERROR_CLUSTER_MISMATCHED_COMPUTER_ACCT_NAME|The name of the corresponding computer account doesn't match the Network Name for this resource.
5906|ERROR_CLUSTER_NO_NET_ADAPTERS|No network adapters are available.
5907|ERROR_CLUSTER_POISONED|The cluster node has been poisoned.
5908|ERROR_CLUSTER_GROUP_MOVING|The group is unable to accept the request since it is moving to another node.
5909|ERROR_CLUSTER_RESOURCE_TYPE_BUSY|The resource type cannot accept the request since is too busy performing another operation.
5910|ERROR_RESOURCE_CALL_TIMED_OUT|The call to the cluster resource DLL timed out.
5911|ERROR_INVALID_CLUSTER_IPV6_ADDRESS|The address is not valid for an IPv6 Address resource. A global IPv6 address is required, and it must match a cluster network. Compatibility addresses are not permitted.
5912|ERROR_CLUSTER_INTERNAL_INVALID_FUNCTION|An internal cluster error occurred. A call to an invalid function was attempted.
5913|ERROR_CLUSTER_PARAMETER_OUT_OF_BOUNDS|A parameter value is out of acceptable range.
5914|ERROR_CLUSTER_PARTIAL_SEND|A network error occurred while sending data to another node in the cluster. The number of bytes transmitted was less than required.
5915|ERROR_CLUSTER_REGISTRY_INVALID_FUNCTION|An invalid cluster registry operation was attempted.
5916|ERROR_CLUSTER_INVALID_STRING_TERMINATION|An input string of characters is not properly terminated.
5917|ERROR_CLUSTER_INVALID_STRING_FORMAT|An input string of characters is not in a valid format for the data it represents.
5918|ERROR_CLUSTER_DATABASE_TRANSACTION_IN_PROGRESS|An internal cluster error occurred. A cluster database transaction was attempted while a transaction was already in progress.
5919|ERROR_CLUSTER_DATABASE_TRANSACTION_NOT_IN_PROGRESS|An internal cluster error occurred. There was an attempt to commit a cluster database transaction while no transaction was in progress.
5920|ERROR_CLUSTER_NULL_DATA|An internal cluster error occurred. Data was not properly initialized.
5921|ERROR_CLUSTER_PARTIAL_READ|An error occurred while reading from a stream of data. An unexpected number of bytes was returned.
5922|ERROR_CLUSTER_PARTIAL_WRITE|An error occurred while writing to a stream of data. The required number of bytes could not be written.
5923|ERROR_CLUSTER_CANT_DESERIALIZE_DATA|An error occurred while deserializing a stream of cluster data.
5924|ERROR_DEPENDENT_RESOURCE_PROPERTY_CONFLICT|One or more property values for this resource are in conflict with one or more property values associated with its dependent resource(s).
5925|ERROR_CLUSTER_NO_QUORUM|A quorum of cluster nodes was not present to form a cluster.
5926|ERROR_CLUSTER_INVALID_IPV6_NETWORK|The cluster network is not valid for an IPv6 Address resource, or it does not match the configured address.
5927|ERROR_CLUSTER_INVALID_IPV6_TUNNEL_NETWORK|The cluster network is not valid for an IPv6 Tunnel resource. Check the configuration of the IP Address resource on which the IPv6 Tunnel resource depends.
5928|ERROR_QUORUM_NOT_ALLOWED_IN_THIS_GROUP|Quorum resource cannot reside in the Available Storage group.
5929|ERROR_DEPENDENCY_TREE_TOO_COMPLEX|The dependencies for this resource are nested too deeply.
5930|ERROR_EXCEPTION_IN_RESOURCE_CALL|The call into the resource DLL raised an unhandled exception.
5931|ERROR_CLUSTER_RHS_FAILED_INITIALIZATION|The RHS process failed to initialize.
5932|ERROR_CLUSTER_NOT_INSTALLED|The Failover Clustering feature is not installed on this node.
5933|ERROR_CLUSTER_RESOURCES_MUST_BE_ONLINE_ON_THE_SAME_NODE|The resources must be online on the same node for this operation.
5934|ERROR_CLUSTER_MAX_NODES_IN_CLUSTER|A new node can not be added since this cluster is already at its maximum number of nodes.
5935|ERROR_CLUSTER_TOO_MANY_NODES|This cluster can not be created since the specified number of nodes exceeds the maximum allowed limit.
5936|ERROR_CLUSTER_OBJECT_ALREADY_USED|An attempt to use the specified cluster name failed because an enabled computer object with the given name already exists in the domain.
5937|ERROR_NONCORE_GROUPS_FOUND|This cluster cannot be destroyed. It has non-core application groups which must be deleted before the cluster can be destroyed.
5938|ERROR_FILE_SHARE_RESOURCE_CONFLICT|File share associated with file share witness resource cannot be hosted by this cluster or any of its nodes.
5939|ERROR_CLUSTER_EVICT_INVALID_REQUEST|Eviction of this node is invalid at this time. Due to quorum requirements node eviction will result in cluster shutdown. If it is the last node in the cluster, destroy cluster command should be used.
5940|ERROR_CLUSTER_SINGLETON_RESOURCE|Only one instance of this resource type is allowed in the cluster.
5941|ERROR_CLUSTER_GROUP_SINGLETON_RESOURCE|Only one instance of this resource type is allowed per resource group.
5942|ERROR_CLUSTER_RESOURCE_PROVIDER_FAILED|The resource failed to come online due to the failure of one or more provider resources.
5943|ERROR_CLUSTER_RESOURCE_CONFIGURATION_ERROR|The resource has indicated that it cannot come online on any node.
5944|ERROR_CLUSTER_GROUP_BUSY|The current operation cannot be performed on this group at this time.
5945|ERROR_CLUSTER_NOT_SHARED_VOLUME|The directory or file is not located on a cluster shared volume.
5946|ERROR_CLUSTER_INVALID_SECURITY_DESCRIPTOR|The Security Descriptor does not meet the requirements for a cluster.
5947|ERROR_CLUSTER_SHARED_VOLUMES_IN_USE|There is one or more shared volumes resources configured in the cluster. Those resources must be moved to available storage in order for operation to succeed.
5948|ERROR_CLUSTER_USE_SHARED_VOLUMES_API|This group or resource cannot be directly manipulated. Use shared volume APIs to perform desired operation.
5949|ERROR_CLUSTER_BACKUP_IN_PROGRESS|Back up is in progress. Please wait for backup completion before trying this operation again.
5950|ERROR_NON_CSV_PATH|The path does not belong to a cluster shared volume.
5951|ERROR_CSV_VOLUME_NOT_LOCAL|The cluster shared volume is not locally mounted on this node.
5952|ERROR_CLUSTER_WATCHDOG_TERMINATING|The cluster watchdog is terminating.
5953|ERROR_CLUSTER_RESOURCE_VETOED_MOVE_INCOMPATIBLE_NODES|A resource vetoed a move between two nodes because they are incompatible.
5954|ERROR_CLUSTER_INVALID_NODE_WEIGHT|The request is invalid either because node weight cannot be changed while the cluster is in disk-only quorum mode, or because changing the node weight would violate the minimum cluster quorum requirements.
5955|ERROR_CLUSTER_RESOURCE_VETOED_CALL|The resource vetoed the call.
5956|ERROR_RESMON_SYSTEM_RESOURCES_LACKING|Resource could not start or run because it could not reserve sufficient system resources.
5957|ERROR_CLUSTER_RESOURCE_VETOED_MOVE_NOT_ENOUGH_RESOURCES_ON_DESTINATION|A resource vetoed a move between two nodes because the destination currently does not have enough resources to complete the operation.
5958|ERROR_CLUSTER_RESOURCE_VETOED_MOVE_NOT_ENOUGH_RESOURCES_ON_SOURCE|A resource vetoed a move between two nodes because the source currently does not have enough resources to complete the operation.
5959|ERROR_CLUSTER_GROUP_QUEUED|The requested operation can not be completed because the group is queued for an operation.
5960|ERROR_CLUSTER_RESOURCE_LOCKED_STATUS|The requested operation can not be completed because a resource has locked status.
5961|ERROR_CLUSTER_SHARED_VOLUME_FAILOVER_NOT_ALLOWED|The resource cannot move to another node because a cluster shared volume vetoed the operation.
5962|ERROR_CLUSTER_NODE_DRAIN_IN_PROGRESS|A node drain is already in progress.`nThis value was also named <strong>ERROR_CLUSTER_NODE_EVACUATION_IN_PROGRESS</strong>
5963|ERROR_CLUSTER_DISK_NOT_CONNECTED|Clustered storage is not connected to the node.
5964|ERROR_DISK_NOT_CSV_CAPABLE|The disk is not configured in a way to be used with CSV. CSV disks must have at least one partition that is formatted with NTFS.
5965|ERROR_RESOURCE_NOT_IN_AVAILABLE_STORAGE|The resource must be part of the Available Storage group to complete this action.
5966|ERROR_CLUSTER_SHARED_VOLUME_REDIRECTED|CSVFS failed operation as volume is in redirected mode.
5967|ERROR_CLUSTER_SHARED_VOLUME_NOT_REDIRECTED|CSVFS failed operation as volume is not in redirected mode.
5968|ERROR_CLUSTER_CANNOT_RETURN_PROPERTIES|Cluster properties cannot be returned at this time.
5969|ERROR_CLUSTER_RESOURCE_CONTAINS_UNSUPPORTED_DIFF_AREA_FOR_SHARED_VOLUMES|The clustered disk resource contains software snapshot diff area that are not supported for Cluster Shared Volumes.
5970|ERROR_CLUSTER_RESOURCE_IS_IN_MAINTENANCE_MODE|The operation cannot be completed because the resource is in maintenance mode.
5971|ERROR_CLUSTER_AFFINITY_CONFLICT|The operation cannot be completed because of cluster affinity conflicts.
5972|ERROR_CLUSTER_RESOURCE_IS_REPLICA_VIRTUAL_MACHINE|The operation cannot be completed because the resource is a replica virtual machine.
6000|ERROR_ENCRYPTION_FAILED|The specified file could not be encrypted.
6001|ERROR_DECRYPTION_FAILED|The specified file could not be decrypted.
6002|ERROR_FILE_ENCRYPTED|The specified file is encrypted and the user does not have the ability to decrypt it.
6003|ERROR_NO_RECOVERY_POLICY|There is no valid encryption recovery policy configured for this system.
6004|ERROR_NO_EFS|The required encryption driver is not loaded for this system.
6005|ERROR_WRONG_EFS|The file was encrypted with a different encryption driver than is currently loaded.
6006|ERROR_NO_USER_KEYS|There are no EFS keys defined for the user.
6007|ERROR_FILE_NOT_ENCRYPTED|The specified file is not encrypted.
6008|ERROR_NOT_EXPORT_FORMAT|The specified file is not in the defined EFS export format.
6009|ERROR_FILE_READ_ONLY|The specified file is read only.
6010|ERROR_DIR_EFS_DISALLOWED|The directory has been disabled for encryption.
6011|ERROR_EFS_SERVER_NOT_TRUSTED|The server is not trusted for remote encryption operation.
6012|ERROR_BAD_RECOVERY_POLICY|Recovery policy configured for this system contains invalid recovery certificate.
6013|ERROR_EFS_ALG_BLOB_TOO_BIG|The encryption algorithm used on the source file needs a bigger key buffer than the one on the destination file.
6014|ERROR_VOLUME_NOT_SUPPORT_EFS|The disk partition does not support file encryption.
6015|ERROR_EFS_DISABLED|This machine is disabled for file encryption.
6016|ERROR_EFS_VERSION_NOT_SUPPORT|A newer system is required to decrypt this encrypted file.
6017|ERROR_CS_ENCRYPTION_INVALID_SERVER_RESPONSE|The remote server sent an invalid response for a file being opened with Client Side Encryption.
6018|ERROR_CS_ENCRYPTION_UNSUPPORTED_SERVER|Client Side Encryption is not supported by the remote server even though it claims to support it.
6019|ERROR_CS_ENCRYPTION_EXISTING_ENCRYPTED_FILE|File is encrypted and should be opened in Client Side Encryption mode.
6020|ERROR_CS_ENCRYPTION_NEW_ENCRYPTED_FILE|A new encrypted file is being created and a $EFS needs to be provided.
6021|ERROR_CS_ENCRYPTION_FILE_NOT_CSE|The SMB client requested a CSE FSCTL on a non-CSE file.
6022|ERROR_ENCRYPTION_POLICY_DENIES_OPERATION|The requested operation was blocked by policy. For more information, contact your system administrator.
6118|ERROR_NO_BROWSER_SERVERS_FOUND|The list of servers for this workgroup is not currently available.
6200|SCHED_E_SERVICE_NOT_LOCALSYSTEM|The Task Scheduler service must be configured to run in the System account to function properly. Individual tasks may be configured to run in other accounts.
6600|ERROR_LOG_SECTOR_INVALID|Log service encountered an invalid log sector.
6601|ERROR_LOG_SECTOR_PARITY_INVALID|Log service encountered a log sector with invalid block parity.
6602|ERROR_LOG_SECTOR_REMAPPED|Log service encountered a remapped log sector.
6603|ERROR_LOG_BLOCK_INCOMPLETE|Log service encountered a partial or incomplete log block.
6604|ERROR_LOG_INVALID_RANGE|Log service encountered an attempt access data outside the active log range.
6605|ERROR_LOG_BLOCKS_EXHAUSTED|Log service user marshalling buffers are exhausted.
6606|ERROR_LOG_READ_CONTEXT_INVALID|Log service encountered an attempt read from a marshalling area with an invalid read context.
6607|ERROR_LOG_RESTART_INVALID|Log service encountered an invalid log restart area.
6608|ERROR_LOG_BLOCK_VERSION|Log service encountered an invalid log block version.
6609|ERROR_LOG_BLOCK_INVALID|Log service encountered an invalid log block.
6610|ERROR_LOG_READ_MODE_INVALID|Log service encountered an attempt to read the log with an invalid read mode.
6611|ERROR_LOG_NO_RESTART|Log service encountered a log stream with no restart area.
6612|ERROR_LOG_METADATA_CORRUPT|Log service encountered a corrupted metadata file.
6613|ERROR_LOG_METADATA_INVALID|Log service encountered a metadata file that could not be created by the log file system.
6614|ERROR_LOG_METADATA_INCONSISTENT|Log service encountered a metadata file with inconsistent data.
6615|ERROR_LOG_RESERVATION_INVALID|Log service encountered an attempt to erroneous allocate or dispose reservation space.
6616|ERROR_LOG_CANT_DELETE|Log service cannot delete log file or file system container.
6617|ERROR_LOG_CONTAINER_LIMIT_EXCEEDED|Log service has reached the maximum allowable containers allocated to a log file.
6618|ERROR_LOG_START_OF_LOG|Log service has attempted to read or write backward past the start of the log.
6619|ERROR_LOG_POLICY_ALREADY_INSTALLED|Log policy could not be installed because a policy of the same type is already present.
6620|ERROR_LOG_POLICY_NOT_INSTALLED|Log policy in question was not installed at the time of the request.
6621|ERROR_LOG_POLICY_INVALID|The installed set of policies on the log is invalid.
6622|ERROR_LOG_POLICY_CONFLICT|A policy on the log in question prevented the operation from completing.
6623|ERROR_LOG_PINNED_ARCHIVE_TAIL|Log space cannot be reclaimed because the log is pinned by the archive tail.
6624|ERROR_LOG_RECORD_NONEXISTENT|Log record is not a record in the log file.
6625|ERROR_LOG_RECORDS_RESERVED_INVALID|Number of reserved log records or the adjustment of the number of reserved log records is invalid.
6626|ERROR_LOG_SPACE_RESERVED_INVALID|Reserved log space or the adjustment of the log space is invalid.
6627|ERROR_LOG_TAIL_INVALID|An new or existing archive tail or base of the active log is invalid.
6628|ERROR_LOG_FULL|Log space is exhausted.
6629|ERROR_COULD_NOT_RESIZE_LOG|The log could not be set to the requested size.
6630|ERROR_LOG_MULTIPLEXED|Log is multiplexed, no direct writes to the physical log is allowed.
6631|ERROR_LOG_DEDICATED|The operation failed because the log is a dedicated log.
6632|ERROR_LOG_ARCHIVE_NOT_IN_PROGRESS|The operation requires an archive context.
6633|ERROR_LOG_ARCHIVE_IN_PROGRESS|Log archival is in progress.
6634|ERROR_LOG_EPHEMERAL|The operation requires a non-ephemeral log, but the log is ephemeral.
6635|ERROR_LOG_NOT_ENOUGH_CONTAINERS|The log must have at least two containers before it can be read from or written to.
6636|ERROR_LOG_CLIENT_ALREADY_REGISTERED|A log client has already registered on the stream.
6637|ERROR_LOG_CLIENT_NOT_REGISTERED|A log client has not been registered on the stream.
6638|ERROR_LOG_FULL_HANDLER_IN_PROGRESS|A request has already been made to handle the log full condition.
6639|ERROR_LOG_CONTAINER_READ_FAILED|Log service encountered an error when attempting to read from a log container.
6640|ERROR_LOG_CONTAINER_WRITE_FAILED|Log service encountered an error when attempting to write to a log container.
6641|ERROR_LOG_CONTAINER_OPEN_FAILED|Log service encountered an error when attempting open a log container.
6642|ERROR_LOG_CONTAINER_STATE_INVALID|Log service encountered an invalid container state when attempting a requested action.
6643|ERROR_LOG_STATE_INVALID|Log service is not in the correct state to perform a requested action.
6644|ERROR_LOG_PINNED|Log space cannot be reclaimed because the log is pinned.
6645|ERROR_LOG_METADATA_FLUSH_FAILED|Log metadata flush failed.
6646|ERROR_LOG_INCONSISTENT_SECURITY|Security on the log and its containers is inconsistent.
6647|ERROR_LOG_APPENDED_FLUSH_FAILED|Records were appended to the log or reservation changes were made, but the log could not be flushed.
6648|ERROR_LOG_PINNED_RESERVATION|The log is pinned due to reservation consuming most of the log space. Free some reserved records to make space available.
6700|ERROR_INVALID_TRANSACTION|The transaction handle associated with this operation is not valid.
6701|ERROR_TRANSACTION_NOT_ACTIVE|The requested operation was made in the context of a transaction that is no longer active.
6702|ERROR_TRANSACTION_REQUEST_NOT_VALID|The requested operation is not valid on the Transaction object in its current state.
6703|ERROR_TRANSACTION_NOT_REQUESTED|The caller has called a response API, but the response is not expected because the TM did not issue the corresponding request to the caller.
6704|ERROR_TRANSACTION_ALREADY_ABORTED|It is too late to perform the requested operation, since the Transaction has already been aborted.
6705|ERROR_TRANSACTION_ALREADY_COMMITTED|It is too late to perform the requested operation, since the Transaction has already been committed.
6706|ERROR_TM_INITIALIZATION_FAILED|The Transaction Manager was unable to be successfully initialized. Transacted operations are not supported.
6707|ERROR_RESOURCEMANAGER_READ_ONLY|The specified ResourceManager made no changes or updates to the resource under this transaction.
6708|ERROR_TRANSACTION_NOT_JOINED|The resource manager has attempted to prepare a transaction that it has not successfully joined.
6709|ERROR_TRANSACTION_SUPERIOR_EXISTS|The Transaction object already has a superior enlistment, and the caller attempted an operation that would have created a new superior. Only a single superior enlistment is allow.
6710|ERROR_CRM_PROTOCOL_ALREADY_EXISTS|The RM tried to register a protocol that already exists.
6711|ERROR_TRANSACTION_PROPAGATION_FAILED|The attempt to propagate the Transaction failed.
6712|ERROR_CRM_PROTOCOL_NOT_FOUND|The requested propagation protocol was not registered as a CRM.
6713|ERROR_TRANSACTION_INVALID_MARSHALL_BUFFER|The buffer passed in to PushTransaction or PullTransaction is not in a valid format.
6714|ERROR_CURRENT_TRANSACTION_NOT_VALID|The current transaction context associated with the thread is not a valid handle to a transaction object.
6715|ERROR_TRANSACTION_NOT_FOUND|The specified Transaction object could not be opened, because it was not found.
6716|ERROR_RESOURCEMANAGER_NOT_FOUND|The specified ResourceManager object could not be opened, because it was not found.
6717|ERROR_ENLISTMENT_NOT_FOUND|The specified Enlistment object could not be opened, because it was not found.
6718|ERROR_TRANSACTIONMANAGER_NOT_FOUND|The specified TransactionManager object could not be opened, because it was not found.
6719|ERROR_TRANSACTIONMANAGER_NOT_ONLINE|The object specified could not be created or opened, because its associated TransactionManager is not online. The TransactionManager must be brought fully Online by calling RecoverTransactionManager to recover to the end of its LogFile before objects in its Transaction or ResourceManager namespaces can be opened. In addition, errors in writing records to its LogFile can cause a TransactionManager to go offline.
6720|ERROR_TRANSACTIONMANAGER_RECOVERY_NAME_COLLISION|The specified TransactionManager was unable to create the objects contained in its logfile in the Ob namespace. Therefore, the TransactionManager was unable to recover.
6721|ERROR_TRANSACTION_NOT_ROOT|The call to create a superior Enlistment on this Transaction object could not be completed, because the Transaction object specified for the enlistment is a subordinate branch of the Transaction. Only the root of the Transaction can be enlisted on as a superior.
6722|ERROR_TRANSACTION_OBJECT_EXPIRED|Because the associated transaction manager or resource manager has been closed, the handle is no longer valid.
6723|ERROR_TRANSACTION_RESPONSE_NOT_ENLISTED|The specified operation could not be performed on this Superior enlistment, because the enlistment was not created with the corresponding completion response in the NotificationMask.
6724|ERROR_TRANSACTION_RECORD_TOO_LONG|The specified operation could not be performed, because the record that would be logged was too long. This can occur because of two conditions: either there are too many Enlistments on this Transaction, or the combined RecoveryInformation being logged on behalf of those Enlistments is too long.
6725|ERROR_IMPLICIT_TRANSACTION_NOT_SUPPORTED|Implicit transaction are not supported.
6726|ERROR_TRANSACTION_INTEGRITY_VIOLATED|The kernel transaction manager had to abort or forget the transaction because it blocked forward progress.
6727|ERROR_TRANSACTIONMANAGER_IDENTITY_MISMATCH|The TransactionManager identity that was supplied did not match the one recorded in the TransactionManager's log file.
6728|ERROR_RM_CANNOT_BE_FROZEN_FOR_SNAPSHOT|This snapshot operation cannot continue because a transactional resource manager cannot be frozen in its current state. Please try again.
6729|ERROR_TRANSACTION_MUST_WRITETHROUGH|The transaction cannot be enlisted on with the specified EnlistmentMask, because the transaction has already completed the PrePrepare phase. In order to ensure correctness, the ResourceManager must switch to a write- through mode and cease caching data within this transaction. Enlisting for only subsequent transaction phases may still succeed.
6730|ERROR_TRANSACTION_NO_SUPERIOR|The transaction does not have a superior enlistment.
6731|ERROR_HEURISTIC_DAMAGE_POSSIBLE|The attempt to commit the Transaction completed, but it is possible that some portion of the transaction tree did not commit successfully due to heuristics. Therefore it is possible that some data modified in the transaction may not have committed, resulting in transactional inconsistency. If possible, check the consistency of the associated data.
6800|ERROR_TRANSACTIONAL_CONFLICT|The function attempted to use a name that is reserved for use by another transaction.
6801|ERROR_RM_NOT_ACTIVE|Transaction support within the specified resource manager is not started or was shut down due to an error.
6802|ERROR_RM_METADATA_CORRUPT|The metadata of the RM has been corrupted. The RM will not function.
6803|ERROR_DIRECTORY_NOT_RM|The specified directory does not contain a resource manager.
6805|ERROR_TRANSACTIONS_UNSUPPORTED_REMOTE|The remote server or share does not support transacted file operations.
6806|ERROR_LOG_RESIZE_INVALID_SIZE|The requested log size is invalid.
6807|ERROR_OBJECT_NO_LONGER_EXISTS|The object (file, stream, link) corresponding to the handle has been deleted by a Transaction Savepoint Rollback.
6808|ERROR_STREAM_MINIVERSION_NOT_FOUND|The specified file miniversion was not found for this transacted file open.
6809|ERROR_STREAM_MINIVERSION_NOT_VALID|The specified file miniversion was found but has been invalidated. Most likely cause is a transaction savepoint rollback.
6810|ERROR_MINIVERSION_INACCESSIBLE_FROM_SPECIFIED_TRANSACTION|A miniversion may only be opened in the context of the transaction that created it.
6811|ERROR_CANT_OPEN_MINIVERSION_WITH_MODIFY_INTENT|It is not possible to open a miniversion with modify access.
6812|ERROR_CANT_CREATE_MORE_STREAM_MINIVERSIONS|It is not possible to create any more miniversions for this stream.
6814|ERROR_REMOTE_FILE_VERSION_MISMATCH|The remote server sent mismatching version number or Fid for a file opened with transactions.
6815|ERROR_HANDLE_NO_LONGER_VALID|The handle has been invalidated by a transaction. The most likely cause is the presence of memory mapping on a file or an open handle when the transaction ended or rolled back to savepoint.
6816|ERROR_NO_TXF_METADATA|There is no transaction metadata on the file.
6817|ERROR_LOG_CORRUPTION_DETECTED|The log data is corrupt.
6818|ERROR_CANT_RECOVER_WITH_HANDLE_OPEN|The file can't be recovered because there is a handle still open on it.
6819|ERROR_RM_DISCONNECTED|The transaction outcome is unavailable because the resource manager responsible for it has disconnected.
6820|ERROR_ENLISTMENT_NOT_SUPERIOR|The request was rejected because the enlistment in question is not a superior enlistment.
6821|ERROR_RECOVERY_NOT_NEEDED|The transactional resource manager is already consistent. Recovery is not needed.
6822|ERROR_RM_ALREADY_STARTED|The transactional resource manager has already been started.
6823|ERROR_FILE_IDENTITY_NOT_PERSISTENT|The file cannot be opened transactionally, because its identity depends on the outcome of an unresolved transaction.
6824|ERROR_CANT_BREAK_TRANSACTIONAL_DEPENDENCY|The operation cannot be performed because another transaction is depending on the fact that this property will not change.
6825|ERROR_CANT_CROSS_RM_BOUNDARY|The operation would involve a single file with two transactional resource managers and is therefore not allowed.
6826|ERROR_TXF_DIR_NOT_EMPTY|The $Txf directory must be empty for this operation to succeed.
6827|ERROR_INDOUBT_TRANSACTIONS_EXIST|The operation would leave a transactional resource manager in an inconsistent state and is therefore not allowed.
6828|ERROR_TM_VOLATILE|The operation could not be completed because the transaction manager does not have a log.
6829|ERROR_ROLLBACK_TIMER_EXPIRED|A rollback could not be scheduled because a previously scheduled rollback has already executed or been queued for execution.
6830|ERROR_TXF_ATTRIBUTE_CORRUPT|The transactional metadata attribute on the file or directory is corrupt and unreadable.
6831|ERROR_EFS_NOT_ALLOWED_IN_TRANSACTION|The encryption operation could not be completed because a transaction is active.
6832|ERROR_TRANSACTIONAL_OPEN_NOT_ALLOWED|This object is not allowed to be opened in a transaction.
6833|ERROR_LOG_GROWTH_FAILED|An attempt to create space in the transactional resource manager's log failed. The failure status has been recorded in the event log.
6834|ERROR_TRANSACTED_MAPPING_UNSUPPORTED_REMOTE|Memory mapping (creating a mapped section) a remote file under a transaction is not supported.
6835|ERROR_TXF_METADATA_ALREADY_PRESENT|Transaction metadata is already present on this file and cannot be superseded.
6836|ERROR_TRANSACTION_SCOPE_CALLBACKS_NOT_SET|A transaction scope could not be entered because the scope handler has not been initialized.
6837|ERROR_TRANSACTION_REQUIRED_PROMOTION|Promotion was required in order to allow the resource manager to enlist, but the transaction was set to disallow it.
6838|ERROR_CANNOT_EXECUTE_FILE_IN_TRANSACTION|This file is open for modification in an unresolved transaction and may be opened for execute only by a transacted reader.
6839|ERROR_TRANSACTIONS_NOT_FROZEN|The request to thaw frozen transactions was ignored because transactions had not previously been frozen.
6840|ERROR_TRANSACTION_FREEZE_IN_PROGRESS|Transactions cannot be frozen because a freeze is already in progress.
6841|ERROR_NOT_SNAPSHOT_VOLUME|The target volume is not a snapshot volume. This operation is only valid on a volume mounted as a snapshot.
6842|ERROR_NO_SAVEPOINT_WITH_OPEN_FILES|The savepoint operation failed because files are open on the transaction. This is not permitted.
6843|ERROR_DATA_LOST_REPAIR|Windows has discovered corruption in a file, and that file has since been repaired. Data loss may have occurred.
6844|ERROR_SPARSE_NOT_ALLOWED_IN_TRANSACTION|The sparse operation could not be completed because a transaction is active on the file.
6845|ERROR_TM_IDENTITY_MISMATCH|The call to create a TransactionManager object failed because the Tm Identity stored in the logfile does not match the Tm Identity that was passed in as an argument.
6846|ERROR_FLOATED_SECTION|I/O was attempted on a section object that has been floated as a result of a transaction ending. There is no valid data.
6847|ERROR_CANNOT_ACCEPT_TRANSACTED_WORK|The transactional resource manager cannot currently accept transacted work due to a transient condition such as low resources.
6848|ERROR_CANNOT_ABORT_TRANSACTIONS|The transactional resource manager had too many tranactions outstanding that could not be aborted. The transactional resource manger has been shut down.
6849|ERROR_BAD_CLUSTERS|The operation could not be completed due to bad clusters on disk.
6850|ERROR_COMPRESSION_NOT_ALLOWED_IN_TRANSACTION|The compression operation could not be completed because a transaction is active on the file.
6851|ERROR_VOLUME_DIRTY|The operation could not be completed because the volume is dirty. Please run chkdsk and try again.
6852|ERROR_NO_LINK_TRACKING_IN_TRANSACTION|The link tracking operation could not be completed because a transaction is active.
6853|ERROR_OPERATION_NOT_SUPPORTED_IN_TRANSACTION|This operation cannot be performed in a transaction.
6854|ERROR_EXPIRED_HANDLE|The handle is no longer properly associated with its transaction. It may have been opened in a transactional resource manager that was subsequently forced to restart. Please close the handle and open a new one.
6855|ERROR_TRANSACTION_NOT_ENLISTED|The specified operation could not be performed because the resource manager is not enlisted in the transaction.
7001|ERROR_CTX_WINSTATION_NAME_INVALID|The specified session name is invalid.
7002|ERROR_CTX_INVALID_PD|The specified protocol driver is invalid.
7003|ERROR_CTX_PD_NOT_FOUND|The specified protocol driver was not found in the system path.
7004|ERROR_CTX_WD_NOT_FOUND|The specified terminal connection driver was not found in the system path.
7005|ERROR_CTX_CANNOT_MAKE_EVENTLOG_ENTRY|A registry key for event logging could not be created for this session.
7006|ERROR_CTX_SERVICE_NAME_COLLISION|A service with the same name already exists on the system.
7007|ERROR_CTX_CLOSE_PENDING|A close operation is pending on the session.
7008|ERROR_CTX_NO_OUTBUF|There are no free output buffers available.
7009|ERROR_CTX_MODEM_INF_NOT_FOUND|The MODEM.INF file was not found.
7010|ERROR_CTX_INVALID_MODEMNAME|The modem name was not found in MODEM.INF.
7011|ERROR_CTX_MODEM_RESPONSE_ERROR|The modem did not accept the command sent to it. Verify that the configured modem name matches the attached modem.
7012|ERROR_CTX_MODEM_RESPONSE_TIMEOUT|The modem did not respond to the command sent to it. Verify that the modem is properly cabled and powered on.
7013|ERROR_CTX_MODEM_RESPONSE_NO_CARRIER|Carrier detect has failed or carrier has been dropped due to disconnect.
7014|ERROR_CTX_MODEM_RESPONSE_NO_DIALTONE|Dial tone not detected within the required time. Verify that the phone cable is properly attached and functional.
7015|ERROR_CTX_MODEM_RESPONSE_BUSY|Busy signal detected at remote site on callback.
7016|ERROR_CTX_MODEM_RESPONSE_VOICE|Voice detected at remote site on callback.
7017|ERROR_CTX_TD_ERROR|Transport driver error.
7022|ERROR_CTX_WINSTATION_NOT_FOUND|The specified session cannot be found.
7023|ERROR_CTX_WINSTATION_ALREADY_EXISTS|The specified session name is already in use.
7024|ERROR_CTX_WINSTATION_BUSY|The task you are trying to do can't be completed because Remote Desktop Services is currently busy. Please try again in a few minutes. Other users should still be able to log on.
7025|ERROR_CTX_BAD_VIDEO_MODE|An attempt has been made to connect to a session whose video mode is not supported by the current client.
7035|ERROR_CTX_GRAPHICS_INVALID|The application attempted to enable DOS graphics mode. DOS graphics mode is not supported.
7037|ERROR_CTX_LOGON_DISABLED|Your interactive logon privilege has been disabled. Please contact your administrator.
7038|ERROR_CTX_NOT_CONSOLE|The requested operation can be performed only on the system console. This is most often the result of a driver or system DLL requiring direct console access.
7040|ERROR_CTX_CLIENT_QUERY_TIMEOUT|The client failed to respond to the server connect message.
7041|ERROR_CTX_CONSOLE_DISCONNECT|Disconnecting the console session is not supported.
7042|ERROR_CTX_CONSOLE_CONNECT|Reconnecting a disconnected session to the console is not supported.
7044|ERROR_CTX_SHADOW_DENIED|The request to control another session remotely was denied.
7045|ERROR_CTX_WINSTATION_ACCESS_DENIED|The requested session access is denied.
7049|ERROR_CTX_INVALID_WD|The specified terminal connection driver is invalid.
7050|ERROR_CTX_SHADOW_INVALID|The requested session cannot be controlled remotely. This may be because the session is disconnected or does not currently have a user logged on.
7051|ERROR_CTX_SHADOW_DISABLED|The requested session is not configured to allow remote control.
7052|ERROR_CTX_CLIENT_LICENSE_IN_USE|Your request to connect to this Terminal Server has been rejected. Your Terminal Server client license number is currently being used by another user. Please call your system administrator to obtain a unique license number.
7053|ERROR_CTX_CLIENT_LICENSE_NOT_SET|Your request to connect to this Terminal Server has been rejected. Your Terminal Server client license number has not been entered for this copy of the Terminal Server client. Please contact your system administrator.
7054|ERROR_CTX_LICENSE_NOT_AVAILABLE|The number of connections to this computer is limited and all connections are in use right now. Try connecting later or contact your system administrator.
7055|ERROR_CTX_LICENSE_CLIENT_INVALID|The client you are using is not licensed to use this system. Your logon request is denied.
7056|ERROR_CTX_LICENSE_EXPIRED|The system license has expired. Your logon request is denied.
7057|ERROR_CTX_SHADOW_NOT_RUNNING|Remote control could not be terminated because the specified session is not currently being remotely controlled.
7058|ERROR_CTX_SHADOW_ENDED_BY_MODE_CHANGE|The remote control of the console was terminated because the display mode was changed. Changing the display mode in a remote control session is not supported.
7059|ERROR_ACTIVATION_COUNT_EXCEEDED|Activation has already been reset the maximum number of times for this installation. Your activation timer will not be cleared.
7060|ERROR_CTX_WINSTATIONS_DISABLED|Remote logins are currently disabled.
7061|ERROR_CTX_ENCRYPTION_LEVEL_REQUIRED|You do not have the proper encryption level to access this Session.
7062|ERROR_CTX_SESSION_IN_USE|The user `%s\\`%s is currently logged on to this computer. Only the current user or an administrator can log on to this computer.
7063|ERROR_CTX_NO_FORCE_LOGOFF|The user `%s\\`%s is already logged on to the console of this computer. You do not have permission to log in at this time. To resolve this issue, contact `%s\\`%s and have them log off.
7064|ERROR_CTX_ACCOUNT_RESTRICTION|Unable to log you on because of an account restriction.
7065|ERROR_RDP_PROTOCOL_ERROR|The RDP protocol component `%2 detected an error in the protocol stream and has disconnected the client.
7066|ERROR_CTX_CDM_CONNECT|The Client Drive Mapping Service Has Connected on Terminal Connection.
7067|ERROR_CTX_CDM_DISCONNECT|The Client Drive Mapping Service Has Disconnected on Terminal Connection.
7068|ERROR_CTX_SECURITY_LAYER_ERROR|The Terminal Server security layer detected an error in the protocol stream and has disconnected the client.
7069|ERROR_TS_INCOMPATIBLE_SESSIONS|The target session is incompatible with the current session.
7070|ERROR_TS_VIDEO_SUBSYSTEM_ERROR|Windows can't connect to your session because a problem occurred in the Windows video subsystem. Try connecting again later, or contact the server administrator for assistance.
8001|FRS_ERR_INVALID_API_SEQUENCE|The file replication service API was called incorrectly.
8002|FRS_ERR_STARTING_SERVICE|The file replication service cannot be started.
8003|FRS_ERR_STOPPING_SERVICE|The file replication service cannot be stopped.
8004|FRS_ERR_INTERNAL_API|The file replication service API terminated the request. The event log may have more information.
8005|FRS_ERR_INTERNAL|The file replication service terminated the request. The event log may have more information.
8006|FRS_ERR_SERVICE_COMM|The file replication service cannot be contacted. The event log may have more information.
8007|FRS_ERR_INSUFFICIENT_PRIV|The file replication service cannot satisfy the request because the user has insufficient privileges. The event log may have more information.
8008|FRS_ERR_AUTHENTICATION|The file replication service cannot satisfy the request because authenticated RPC is not available. The event log may have more information.
8009|FRS_ERR_PARENT_INSUFFICIENT_PRIV|The file replication service cannot satisfy the request because the user has insufficient privileges on the domain controller. The event log may have more information.
8010|FRS_ERR_PARENT_AUTHENTICATION|The file replication service cannot satisfy the request because authenticated RPC is not available on the domain controller. The event log may have more information.
8011|FRS_ERR_CHILD_TO_PARENT_COMM|The file replication service cannot communicate with the file replication service on the domain controller. The event log may have more information.
8012|FRS_ERR_PARENT_TO_CHILD_COMM|The file replication service on the domain controller cannot communicate with the file replication service on this computer. The event log may have more information.
8013|FRS_ERR_SYSVOL_POPULATE|The file replication service cannot populate the system volume because of an internal error. The event log may have more information.
8014|FRS_ERR_SYSVOL_POPULATE_TIMEOUT|The file replication service cannot populate the system volume because of an internal timeout. The event log may have more information.
8015|FRS_ERR_SYSVOL_IS_BUSY|The file replication service cannot process the request. The system volume is busy with a previous request.
8016|FRS_ERR_SYSVOL_DEMOTE|The file replication service cannot stop replicating the system volume because of an internal error. The event log may have more information.
8017|FRS_ERR_INVALID_SERVICE_PARAMETER|The file replication service detected an invalid parameter.
8200|ERROR_DS_NOT_INSTALLED|An error occurred while installing the directory service. For more information, see the event log.
8201|ERROR_DS_MEMBERSHIP_EVALUATED_LOCALLY|The directory service evaluated group memberships locally.
8202|ERROR_DS_NO_ATTRIBUTE_OR_VALUE|The specified directory service attribute or value does not exist.
8203|ERROR_DS_INVALID_ATTRIBUTE_SYNTAX|The attribute syntax specified to the directory service is invalid.
8204|ERROR_DS_ATTRIBUTE_TYPE_UNDEFINED|The attribute type specified to the directory service is not defined.
8205|ERROR_DS_ATTRIBUTE_OR_VALUE_EXISTS|The specified directory service attribute or value already exists.
8206|ERROR_DS_BUSY|The directory service is busy.
8207|ERROR_DS_UNAVAILABLE|The directory service is unavailable.
8208|ERROR_DS_NO_RIDS_ALLOCATED|The directory service was unable to allocate a relative identifier.
8209|ERROR_DS_NO_MORE_RIDS|The directory service has exhausted the pool of relative identifiers.
8210|ERROR_DS_INCORRECT_ROLE_OWNER|The requested operation could not be performed because the directory service is not the master for that type of operation.
8211|ERROR_DS_RIDMGR_INIT_ERROR|The directory service was unable to initialize the subsystem that allocates relative identifiers.
8212|ERROR_DS_OBJ_CLASS_VIOLATION|The requested operation did not satisfy one or more constraints associated with the class of the object.
8213|ERROR_DS_CANT_ON_NON_LEAF|The directory service can perform the requested operation only on a leaf object.
8214|ERROR_DS_CANT_ON_RDN|The directory service cannot perform the requested operation on the RDN attribute of an object.
8215|ERROR_DS_CANT_MOD_OBJ_CLASS|The directory service detected an attempt to modify the object class of an object.
8216|ERROR_DS_CROSS_DOM_MOVE_ERROR|The requested cross-domain move operation could not be performed.
8217|ERROR_DS_GC_NOT_AVAILABLE|Unable to contact the global catalog server.
8218|ERROR_SHARED_POLICY|The policy object is shared and can only be modified at the root.
8219|ERROR_POLICY_OBJECT_NOT_FOUND|The policy object does not exist.
8220|ERROR_POLICY_ONLY_IN_DS|The requested policy information is only in the directory service.
8221|ERROR_PROMOTION_ACTIVE|A domain controller promotion is currently active.
8222|ERROR_NO_PROMOTION_ACTIVE|A domain controller promotion is not currently active.
8224|ERROR_DS_OPERATIONS_ERROR|An operations error occurred.
8225|ERROR_DS_PROTOCOL_ERROR|A protocol error occurred.
8226|ERROR_DS_TIMELIMIT_EXCEEDED|The time limit for this request was exceeded.
8227|ERROR_DS_SIZELIMIT_EXCEEDED|The size limit for this request was exceeded.
8228|ERROR_DS_ADMIN_LIMIT_EXCEEDED|The administrative limit for this request was exceeded.
8229|ERROR_DS_COMPARE_FALSE|The compare response was false.
8230|ERROR_DS_COMPARE_TRUE|The compare response was true.
8231|ERROR_DS_AUTH_METHOD_NOT_SUPPORTED|The requested authentication method is not supported by the server.
8232|ERROR_DS_STRONG_AUTH_REQUIRED|A more secure authentication method is required for this server.
8233|ERROR_DS_INAPPROPRIATE_AUTH|Inappropriate authentication.
8234|ERROR_DS_AUTH_UNKNOWN|The authentication mechanism is unknown.
8235|ERROR_DS_REFERRAL|A referral was returned from the server.
8236|ERROR_DS_UNAVAILABLE_CRIT_EXTENSION|The server does not support the requested critical extension.
8237|ERROR_DS_CONFIDENTIALITY_REQUIRED|This request requires a secure connection.
8238|ERROR_DS_INAPPROPRIATE_MATCHING|Inappropriate matching.
8239|ERROR_DS_CONSTRAINT_VIOLATION|A constraint violation occurred.
8240|ERROR_DS_NO_SUCH_OBJECT|There is no such object on the server.
8241|ERROR_DS_ALIAS_PROBLEM|There is an alias problem.
8242|ERROR_DS_INVALID_DN_SYNTAX|An invalid dn syntax has been specified.
8243|ERROR_DS_IS_LEAF|The object is a leaf object.
8244|ERROR_DS_ALIAS_DEREF_PROBLEM|There is an alias dereferencing problem.
8245|ERROR_DS_UNWILLING_TO_PERFORM|The server is unwilling to process the request.
8246|ERROR_DS_LOOP_DETECT|A loop has been detected.
8247|ERROR_DS_NAMING_VIOLATION|There is a naming violation.
8248|ERROR_DS_OBJECT_RESULTS_TOO_LARGE|The result set is too large.
8249|ERROR_DS_AFFECTS_MULTIPLE_DSAS|The operation affects multiple DSAs.
8250|ERROR_DS_SERVER_DOWN|The server is not operational.
8251|ERROR_DS_LOCAL_ERROR|A local error has occurred.
8252|ERROR_DS_ENCODING_ERROR|An encoding error has occurred.
8253|ERROR_DS_DECODING_ERROR|A decoding error has occurred.
8254|ERROR_DS_FILTER_UNKNOWN|The search filter cannot be recognized.
8255|ERROR_DS_PARAM_ERROR|One or more parameters are illegal.
8256|ERROR_DS_NOT_SUPPORTED|The specified method is not supported.
8257|ERROR_DS_NO_RESULTS_RETURNED|No results were returned.
8258|ERROR_DS_CONTROL_NOT_FOUND|The specified control is not supported by the server.
8259|ERROR_DS_CLIENT_LOOP|A referral loop was detected by the client.
8260|ERROR_DS_REFERRAL_LIMIT_EXCEEDED|The preset referral limit was exceeded.
8261|ERROR_DS_SORT_CONTROL_MISSING|The search requires a SORT control.
8262|ERROR_DS_OFFSET_RANGE_ERROR|The search results exceed the offset range specified.
8263|ERROR_DS_RIDMGR_DISABLED|The directory service detected the subsystem that allocates relative identifiers is disabled. This can occur as a protective mechanism when the system determines a significant portion of relative identifiers (RIDs) have been exhausted. Please see <a href="http://go.microsoft.com/fwlink/p/?linkid=228610" data-linktype="external">http://go.microsoft.com/fwlink/p/?linkid=228610</a> for recommended diagnostic steps and the procedure to re-enable account creation.
8301|ERROR_DS_ROOT_MUST_BE_NC|The root object must be the head of a naming context. The root object cannot have an instantiated parent.
8302|ERROR_DS_ADD_REPLICA_INHIBITED|The add replica operation cannot be performed. The naming context must be writeable in order to create the replica.
8303|ERROR_DS_ATT_NOT_DEF_IN_SCHEMA|A reference to an attribute that is not defined in the schema occurred.
8304|ERROR_DS_MAX_OBJ_SIZE_EXCEEDED|The maximum size of an object has been exceeded.
8305|ERROR_DS_OBJ_STRING_NAME_EXISTS|An attempt was made to add an object to the directory with a name that is already in use.
8306|ERROR_DS_NO_RDN_DEFINED_IN_SCHEMA|An attempt was made to add an object of a class that does not have an RDN defined in the schema.
8307|ERROR_DS_RDN_DOESNT_MATCH_SCHEMA|An attempt was made to add an object using an RDN that is not the RDN defined in the schema.
8308|ERROR_DS_NO_REQUESTED_ATTS_FOUND|None of the requested attributes were found on the objects.
8309|ERROR_DS_USER_BUFFER_TO_SMALL|The user buffer is too small.
8310|ERROR_DS_ATT_IS_NOT_ON_OBJ|The attribute specified in the operation is not present on the object.
8311|ERROR_DS_ILLEGAL_MOD_OPERATION|Illegal modify operation. Some aspect of the modification is not permitted.
8312|ERROR_DS_OBJ_TOO_LARGE|The specified object is too large.
8313|ERROR_DS_BAD_INSTANCE_TYPE|The specified instance type is not valid.
8314|ERROR_DS_MASTERDSA_REQUIRED|The operation must be performed at a master DSA.
8315|ERROR_DS_OBJECT_CLASS_REQUIRED|The object class attribute must be specified.
8316|ERROR_DS_MISSING_REQUIRED_ATT|A required attribute is missing.
8317|ERROR_DS_ATT_NOT_DEF_FOR_CLASS|An attempt was made to modify an object to include an attribute that is not legal for its class.
8318|ERROR_DS_ATT_ALREADY_EXISTS|The specified attribute is already present on the object.
8320|ERROR_DS_CANT_ADD_ATT_VALUES|The specified attribute is not present, or has no values.
8321|ERROR_DS_SINGLE_VALUE_CONSTRAINT|Multiple values were specified for an attribute that can have only one value.
8322|ERROR_DS_RANGE_CONSTRAINT|A value for the attribute was not in the acceptable range of values.
8323|ERROR_DS_ATT_VAL_ALREADY_EXISTS|The specified value already exists.
8324|ERROR_DS_CANT_REM_MISSING_ATT|The attribute cannot be removed because it is not present on the object.
8325|ERROR_DS_CANT_REM_MISSING_ATT_VAL|The attribute value cannot be removed because it is not present on the object.
8326|ERROR_DS_ROOT_CANT_BE_SUBREF|The specified root object cannot be a subref.
8327|ERROR_DS_NO_CHAINING|Chaining is not permitted.
8328|ERROR_DS_NO_CHAINED_EVAL|Chained evaluation is not permitted.
8329|ERROR_DS_NO_PARENT_OBJECT|The operation could not be performed because the object's parent is either uninstantiated or deleted.
8330|ERROR_DS_PARENT_IS_AN_ALIAS|Having a parent that is an alias is not permitted. Aliases are leaf objects.
8331|ERROR_DS_CANT_MIX_MASTER_AND_REPS|The object and parent must be of the same type, either both masters or both replicas.
8332|ERROR_DS_CHILDREN_EXIST|The operation cannot be performed because child objects exist. This operation can only be performed on a leaf object.
8333|ERROR_DS_OBJ_NOT_FOUND|Directory object not found.
8334|ERROR_DS_ALIASED_OBJ_MISSING|The aliased object is missing.
8335|ERROR_DS_BAD_NAME_SYNTAX|The object name has bad syntax.
8336|ERROR_DS_ALIAS_POINTS_TO_ALIAS|It is not permitted for an alias to refer to another alias.
8337|ERROR_DS_CANT_DEREF_ALIAS|The alias cannot be dereferenced.
8338|ERROR_DS_OUT_OF_SCOPE|The operation is out of scope.
8339|ERROR_DS_OBJECT_BEING_REMOVED|The operation cannot continue because the object is in the process of being removed.
8340|ERROR_DS_CANT_DELETE_DSA_OBJ|The DSA object cannot be deleted.
8341|ERROR_DS_GENERIC_ERROR|A directory service error has occurred.
8342|ERROR_DS_DSA_MUST_BE_INT_MASTER|The operation can only be performed on an internal master DSA object.
8343|ERROR_DS_CLASS_NOT_DSA|The object must be of class DSA.
8344|ERROR_DS_INSUFF_ACCESS_RIGHTS|Insufficient access rights to perform the operation.
8345|ERROR_DS_ILLEGAL_SUPERIOR|The object cannot be added because the parent is not on the list of possible superiors.
8346|ERROR_DS_ATTRIBUTE_OWNED_BY_SAM|Access to the attribute is not permitted because the attribute is owned by the Security Accounts Manager (SAM).
8347|ERROR_DS_NAME_TOO_MANY_PARTS|The name has too many parts.
8348|ERROR_DS_NAME_TOO_LONG|The name is too long.
8349|ERROR_DS_NAME_VALUE_TOO_LONG|The name value is too long.
8350|ERROR_DS_NAME_UNPARSEABLE|The directory service encountered an error parsing a name.
8351|ERROR_DS_NAME_TYPE_UNKNOWN|The directory service cannot get the attribute type for a name.
8352|ERROR_DS_NOT_AN_OBJECT|The name does not identify an object; the name identifies a phantom.
8353|ERROR_DS_SEC_DESC_TOO_SHORT|The security descriptor is too short.
8354|ERROR_DS_SEC_DESC_INVALID|The security descriptor is invalid.
8355|ERROR_DS_NO_DELETED_NAME|Failed to create name for deleted object.
8356|ERROR_DS_SUBREF_MUST_HAVE_PARENT|The parent of a new subref must exist.
8357|ERROR_DS_NCNAME_MUST_BE_NC|The object must be a naming context.
8358|ERROR_DS_CANT_ADD_SYSTEM_ONLY|It is not permitted to add an attribute which is owned by the system.
8359|ERROR_DS_CLASS_MUST_BE_CONCRETE|The class of the object must be structural; you cannot instantiate an abstract class.
8360|ERROR_DS_INVALID_DMD|The schema object could not be found.
8361|ERROR_DS_OBJ_GUID_EXISTS|A local object with this GUID (dead or alive) already exists.
8362|ERROR_DS_NOT_ON_BACKLINK|The operation cannot be performed on a back link.
8363|ERROR_DS_NO_CROSSREF_FOR_NC|The cross reference for the specified naming context could not be found.
8364|ERROR_DS_SHUTTING_DOWN|The operation could not be performed because the directory service is shutting down.
8365|ERROR_DS_UNKNOWN_OPERATION|The directory service request is invalid.
8366|ERROR_DS_INVALID_ROLE_OWNER|The role owner attribute could not be read.
8367|ERROR_DS_COULDNT_CONTACT_FSMO|The requested FSMO operation failed. The current FSMO holder could not be contacted.
8368|ERROR_DS_CROSS_NC_DN_RENAME|Modification of a DN across a naming context is not permitted.
8369|ERROR_DS_CANT_MOD_SYSTEM_ONLY|The attribute cannot be modified because it is owned by the system.
8370|ERROR_DS_REPLICATOR_ONLY|Only the replicator can perform this function.
8371|ERROR_DS_OBJ_CLASS_NOT_DEFINED|The specified class is not defined.
8372|ERROR_DS_OBJ_CLASS_NOT_SUBCLASS|The specified class is not a subclass.
8373|ERROR_DS_NAME_REFERENCE_INVALID|The name reference is invalid.
8374|ERROR_DS_CROSS_REF_EXISTS|A cross reference already exists.
8375|ERROR_DS_CANT_DEL_MASTER_CROSSREF|It is not permitted to delete a master cross reference.
8376|ERROR_DS_SUBTREE_NOTIFY_NOT_NC_HEAD|Subtree notifications are only supported on NC heads.
8377|ERROR_DS_NOTIFY_FILTER_TOO_COMPLEX|Notification filter is too complex.
8378|ERROR_DS_DUP_RDN|Schema update failed: duplicate RDN.
8379|ERROR_DS_DUP_OID|Schema update failed: duplicate OID.
8380|ERROR_DS_DUP_MAPI_ID|Schema update failed: duplicate MAPI identifier.
8381|ERROR_DS_DUP_SCHEMA_ID_GUID|Schema update failed: duplicate schema-id GUID.
8382|ERROR_DS_DUP_LDAP_DISPLAY_NAME|Schema update failed: duplicate LDAP display name.
8383|ERROR_DS_SEMANTIC_ATT_TEST|Schema update failed: range-lower less than range upper.
8384|ERROR_DS_SYNTAX_MISMATCH|Schema update failed: syntax mismatch.
8385|ERROR_DS_EXISTS_IN_MUST_HAVE|Schema deletion failed: attribute is used in must-contain.
8386|ERROR_DS_EXISTS_IN_MAY_HAVE|Schema deletion failed: attribute is used in may-contain.
8387|ERROR_DS_NONEXISTENT_MAY_HAVE|Schema update failed: attribute in may-contain does not exist.
8388|ERROR_DS_NONEXISTENT_MUST_HAVE|Schema update failed: attribute in must-contain does not exist.
8389|ERROR_DS_AUX_CLS_TEST_FAIL|Schema update failed: class in aux-class list does not exist or is not an auxiliary class.
8390|ERROR_DS_NONEXISTENT_POSS_SUP|Schema update failed: class in poss-superiors does not exist.
8391|ERROR_DS_SUB_CLS_TEST_FAIL|Schema update failed: class in subclassof list does not exist or does not satisfy hierarchy rules.
8392|ERROR_DS_BAD_RDN_ATT_ID_SYNTAX|Schema update failed: Rdn-Att-Id has wrong syntax.
8393|ERROR_DS_EXISTS_IN_AUX_CLS|Schema deletion failed: class is used as auxiliary class.
8394|ERROR_DS_EXISTS_IN_SUB_CLS|Schema deletion failed: class is used as sub class.
8395|ERROR_DS_EXISTS_IN_POSS_SUP|Schema deletion failed: class is used as poss superior.
8396|ERROR_DS_RECALCSCHEMA_FAILED|Schema update failed in recalculating validation cache.
8397|ERROR_DS_TREE_DELETE_NOT_FINISHED|The tree deletion is not finished. The request must be made again to continue deleting the tree.
8398|ERROR_DS_CANT_DELETE|The requested delete operation could not be performed.
8399|ERROR_DS_ATT_SCHEMA_REQ_ID|Cannot read the governs class identifier for the schema record.
8400|ERROR_DS_BAD_ATT_SCHEMA_SYNTAX|The attribute schema has bad syntax.
8401|ERROR_DS_CANT_CACHE_ATT|The attribute could not be cached.
8402|ERROR_DS_CANT_CACHE_CLASS|The class could not be cached.
8403|ERROR_DS_CANT_REMOVE_ATT_CACHE|The attribute could not be removed from the cache.
8404|ERROR_DS_CANT_REMOVE_CLASS_CACHE|The class could not be removed from the cache.
8405|ERROR_DS_CANT_RETRIEVE_DN|The distinguished name attribute could not be read.
8406|ERROR_DS_MISSING_SUPREF|No superior reference has been configured for the directory service. The directory service is therefore unable to issue referrals to objects outside this forest.
8407|ERROR_DS_CANT_RETRIEVE_INSTANCE|The instance type attribute could not be retrieved.
8408|ERROR_DS_CODE_INCONSISTENCY|An internal error has occurred.
8409|ERROR_DS_DATABASE_ERROR|A database error has occurred.
8410|ERROR_DS_GOVERNSID_MISSING|The attribute GOVERNSID is missing.
8411|ERROR_DS_MISSING_EXPECTED_ATT|An expected attribute is missing.
8412|ERROR_DS_NCNAME_MISSING_CR_REF|The specified naming context is missing a cross reference.
8413|ERROR_DS_SECURITY_CHECKING_ERROR|A security checking error has occurred.
8414|ERROR_DS_SCHEMA_NOT_LOADED|The schema is not loaded.
8415|ERROR_DS_SCHEMA_ALLOC_FAILED|Schema allocation failed. Please check if the machine is running low on memory.
8416|ERROR_DS_ATT_SCHEMA_REQ_SYNTAX|Failed to obtain the required syntax for the attribute schema.
8417|ERROR_DS_GCVERIFY_ERROR|The global catalog verification failed. The global catalog is not available or does not support the operation. Some part of the directory is currently not available.
8418|ERROR_DS_DRA_SCHEMA_MISMATCH|The replication operation failed because of a schema mismatch between the servers involved.
8419|ERROR_DS_CANT_FIND_DSA_OBJ|The DSA object could not be found.
8420|ERROR_DS_CANT_FIND_EXPECTED_NC|The naming context could not be found.
8421|ERROR_DS_CANT_FIND_NC_IN_CACHE|The naming context could not be found in the cache.
8422|ERROR_DS_CANT_RETRIEVE_CHILD|The child object could not be retrieved.
8423|ERROR_DS_SECURITY_ILLEGAL_MODIFY|The modification was not permitted for security reasons.
8424|ERROR_DS_CANT_REPLACE_HIDDEN_REC|The operation cannot replace the hidden record.
8425|ERROR_DS_BAD_HIERARCHY_FILE|The hierarchy file is invalid.
8426|ERROR_DS_BUILD_HIERARCHY_TABLE_FAILED|The attempt to build the hierarchy table failed.
8427|ERROR_DS_CONFIG_PARAM_MISSING|The directory configuration parameter is missing from the registry.
8428|ERROR_DS_COUNTING_AB_INDICES_FAILED|The attempt to count the address book indices failed.
8429|ERROR_DS_HIERARCHY_TABLE_MALLOC_FAILED|The allocation of the hierarchy table failed.
8430|ERROR_DS_INTERNAL_FAILURE|The directory service encountered an internal failure.
8431|ERROR_DS_UNKNOWN_ERROR|The directory service encountered an unknown failure.
8432|ERROR_DS_ROOT_REQUIRES_CLASS_TOP|A root object requires a class of 'top'.
8433|ERROR_DS_REFUSING_FSMO_ROLES|This directory server is shutting down, and cannot take ownership of new floating single-master operation roles.
8434|ERROR_DS_MISSING_FSMO_SETTINGS|The directory service is missing mandatory configuration information, and is unable to determine the ownership of floating single-master operation roles.
8435|ERROR_DS_UNABLE_TO_SURRENDER_ROLES|The directory service was unable to transfer ownership of one or more floating single-master operation roles to other servers.
8436|ERROR_DS_DRA_GENERIC|The replication operation failed.
8437|ERROR_DS_DRA_INVALID_PARAMETER|An invalid parameter was specified for this replication operation.
8438|ERROR_DS_DRA_BUSY|The directory service is too busy to complete the replication operation at this time.
8439|ERROR_DS_DRA_BAD_DN|The distinguished name specified for this replication operation is invalid.
8440|ERROR_DS_DRA_BAD_NC|The naming context specified for this replication operation is invalid.
8441|ERROR_DS_DRA_DN_EXISTS|The distinguished name specified for this replication operation already exists.
8442|ERROR_DS_DRA_INTERNAL_ERROR|The replication system encountered an internal error.
8443|ERROR_DS_DRA_INCONSISTENT_DIT|The replication operation encountered a database inconsistency.
8444|ERROR_DS_DRA_CONNECTION_FAILED|The server specified for this replication operation could not be contacted.
8445|ERROR_DS_DRA_BAD_INSTANCE_TYPE|The replication operation encountered an object with an invalid instance type.
8446|ERROR_DS_DRA_OUT_OF_MEM|The replication operation failed to allocate memory.
8447|ERROR_DS_DRA_MAIL_PROBLEM|The replication operation encountered an error with the mail system.
8448|ERROR_DS_DRA_REF_ALREADY_EXISTS|The replication reference information for the target server already exists.
8449|ERROR_DS_DRA_REF_NOT_FOUND|The replication reference information for the target server does not exist.
8450|ERROR_DS_DRA_OBJ_IS_REP_SOURCE|The naming context cannot be removed because it is replicated to another server.
8451|ERROR_DS_DRA_DB_ERROR|The replication operation encountered a database error.
8452|ERROR_DS_DRA_NO_REPLICA|The naming context is in the process of being removed or is not replicated from the specified server.
8453|ERROR_DS_DRA_ACCESS_DENIED|Replication access was denied.
8454|ERROR_DS_DRA_NOT_SUPPORTED|The requested operation is not supported by this version of the directory service.
8455|ERROR_DS_DRA_RPC_CANCELLED|The replication remote procedure call was cancelled.
8456|ERROR_DS_DRA_SOURCE_DISABLED|The source server is currently rejecting replication requests.
8457|ERROR_DS_DRA_SINK_DISABLED|The destination server is currently rejecting replication requests.
8458|ERROR_DS_DRA_NAME_COLLISION|The replication operation failed due to a collision of object names.
8459|ERROR_DS_DRA_SOURCE_REINSTALLED|The replication source has been reinstalled.
8460|ERROR_DS_DRA_MISSING_PARENT|The replication operation failed because a required parent object is missing.
8461|ERROR_DS_DRA_PREEMPTED|The replication operation was preempted.
8462|ERROR_DS_DRA_ABANDON_SYNC|The replication synchronization attempt was abandoned because of a lack of updates.
8463|ERROR_DS_DRA_SHUTDOWN|The replication operation was terminated because the system is shutting down.
8464|ERROR_DS_DRA_INCOMPATIBLE_PARTIAL_SET|Synchronization attempt failed because the destination DC is currently waiting to synchronize new partial attributes from source. This condition is normal if a recent schema change modified the partial attribute set. The destination partial attribute set is not a subset of source partial attribute set.
8465|ERROR_DS_DRA_SOURCE_IS_PARTIAL_REPLICA|The replication synchronization attempt failed because a master replica attempted to sync from a partial replica.
8466|ERROR_DS_DRA_EXTN_CONNECTION_FAILED|The server specified for this replication operation was contacted, but that server was unable to contact an additional server needed to complete the operation.
8467|ERROR_DS_INSTALL_SCHEMA_MISMATCH|The version of the directory service schema of the source forest is not compatible with the version of directory service on this computer.
8468|ERROR_DS_DUP_LINK_ID|Schema update failed: An attribute with the same link identifier already exists.
8469|ERROR_DS_NAME_ERROR_RESOLVING|Name translation: Generic processing error.
8470|ERROR_DS_NAME_ERROR_NOT_FOUND|Name translation: Could not find the name or insufficient right to see name.
8471|ERROR_DS_NAME_ERROR_NOT_UNIQUE|Name translation: Input name mapped to more than one output name.
8472|ERROR_DS_NAME_ERROR_NO_MAPPING|Name translation: Input name found, but not the associated output format.
8473|ERROR_DS_NAME_ERROR_DOMAIN_ONLY|Name translation: Unable to resolve completely, only the domain was found.
8474|ERROR_DS_NAME_ERROR_NO_SYNTACTICAL_MAPPING|Name translation: Unable to perform purely syntactical mapping at the client without going out to the wire.
8475|ERROR_DS_CONSTRUCTED_ATT_MOD|Modification of a constructed attribute is not allowed.
8476|ERROR_DS_WRONG_OM_OBJ_CLASS|The OM-Object-Class specified is incorrect for an attribute with the specified syntax.
8477|ERROR_DS_DRA_REPL_PENDING|The replication request has been posted; waiting for reply.
8478|ERROR_DS_DS_REQUIRED|The requested operation requires a directory service, and none was available.
8479|ERROR_DS_INVALID_LDAP_DISPLAY_NAME|The LDAP display name of the class or attribute contains non-ASCII characters.
8480|ERROR_DS_NON_BASE_SEARCH|The requested search operation is only supported for base searches.
8481|ERROR_DS_CANT_RETRIEVE_ATTS|The search failed to retrieve attributes from the database.
8482|ERROR_DS_BACKLINK_WITHOUT_LINK|The schema update operation tried to add a backward link attribute that has no corresponding forward link.
8483|ERROR_DS_EPOCH_MISMATCH|Source and destination of a cross-domain move do not agree on the object's epoch number. Either source or destination does not have the latest version of the object.
8484|ERROR_DS_SRC_NAME_MISMATCH|Source and destination of a cross-domain move do not agree on the object's current name. Either source or destination does not have the latest version of the object.
8485|ERROR_DS_SRC_AND_DST_NC_IDENTICAL|Source and destination for the cross-domain move operation are identical. Caller should use local move operation instead of cross-domain move operation.
8486|ERROR_DS_DST_NC_MISMATCH|Source and destination for a cross-domain move are not in agreement on the naming contexts in the forest. Either source or destination does not have the latest version of the Partitions container.
8487|ERROR_DS_NOT_AUTHORITIVE_FOR_DST_NC|Destination of a cross-domain move is not authoritative for the destination naming context.
8488|ERROR_DS_SRC_GUID_MISMATCH|Source and destination of a cross-domain move do not agree on the identity of the source object. Either source or destination does not have the latest version of the source object.
8489|ERROR_DS_CANT_MOVE_DELETED_OBJECT|Object being moved across-domains is already known to be deleted by the destination server. The source server does not have the latest version of the source object.
8490|ERROR_DS_PDC_OPERATION_IN_PROGRESS|Another operation which requires exclusive access to the PDC FSMO is already in progress.
8491|ERROR_DS_CROSS_DOMAIN_CLEANUP_REQD|A cross-domain move operation failed such that two versions of the moved object exist - one each in the source and destination domains. The destination object needs to be removed to restore the system to a consistent state.
8492|ERROR_DS_ILLEGAL_XDOM_MOVE_OPERATION|This object may not be moved across domain boundaries either because cross-domain moves for this class are disallowed, or the object has some special characteristics, e.g.: trust account or restricted RID, which prevent its move.
8493|ERROR_DS_CANT_WITH_ACCT_GROUP_MEMBERSHPS|Can't move objects with memberships across domain boundaries as once moved, this would violate the membership conditions of the account group. Remove the object from any account group memberships and retry.
8494|ERROR_DS_NC_MUST_HAVE_NC_PARENT|A naming context head must be the immediate child of another naming context head, not of an interior node.
8495|ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE|The directory cannot validate the proposed naming context name because it does not hold a replica of the naming context above the proposed naming context. Please ensure that the domain naming master role is held by a server that is configured as a global catalog server, and that the server is up to date with its replication partners. (Applies only to Windows 2000 Domain Naming masters.)
8496|ERROR_DS_DST_DOMAIN_NOT_NATIVE|Destination domain must be in native mode.
8497|ERROR_DS_MISSING_INFRASTRUCTURE_CONTAINER|The operation cannot be performed because the server does not have an infrastructure container in the domain of interest.
8498|ERROR_DS_CANT_MOVE_ACCOUNT_GROUP|Cross-domain move of non-empty account groups is not allowed.
8499|ERROR_DS_CANT_MOVE_RESOURCE_GROUP|Cross-domain move of non-empty resource groups is not allowed.
8500|ERROR_DS_INVALID_SEARCH_FLAG|The search flags for the attribute are invalid. The ANR bit is valid only on attributes of Unicode or Teletex strings.
8501|ERROR_DS_NO_TREE_DELETE_ABOVE_NC|Tree deletions starting at an object which has an NC head as a descendant are not allowed.
8502|ERROR_DS_COULDNT_LOCK_TREE_FOR_DELETE|The directory service failed to lock a tree in preparation for a tree deletion because the tree was in use.
8503|ERROR_DS_COULDNT_IDENTIFY_OBJECTS_FOR_TREE_DELETE|The directory service failed to identify the list of objects to delete while attempting a tree deletion.
8504|ERROR_DS_SAM_INIT_FAILURE|Security Accounts Manager initialization failed because of the following error: `%1. Error Status: 0x`%2. Please shutdown this system and reboot into Directory Services Restore Mode, check the event log for more detailed information.
8505|ERROR_DS_SENSITIVE_GROUP_VIOLATION|Only an administrator can modify the membership list of an administrative group.
8506|ERROR_DS_CANT_MOD_PRIMARYGROUPID|Cannot change the primary group ID of a domain controller account.
8507|ERROR_DS_ILLEGAL_BASE_SCHEMA_MOD|An attempt is made to modify the base schema.
8508|ERROR_DS_NONSAFE_SCHEMA_CHANGE|Adding a new mandatory attribute to an existing class, deleting a mandatory attribute from an existing class, or adding an optional attribute to the special class Top that is not a backlink attribute (directly or through inheritance, for example, by adding or deleting an auxiliary class) is not allowed.
8509|ERROR_DS_SCHEMA_UPDATE_DISALLOWED|Schema update is not allowed on this DC because the DC is not the schema FSMO Role Owner.
8510|ERROR_DS_CANT_CREATE_UNDER_SCHEMA|An object of this class cannot be created under the schema container. You can only create attribute-schema and class-schema objects under the schema container.
8511|ERROR_DS_INSTALL_NO_SRC_SCH_VERSION|The replica/child install failed to get the objectVersion attribute on the schema container on the source DC. Either the attribute is missing on the schema container or the credentials supplied do not have permission to read it.
8512|ERROR_DS_INSTALL_NO_SCH_VERSION_IN_INIFILE|The replica/child install failed to read the objectVersion attribute in the SCHEMA section of the file schema.ini in the system32 directory.
8513|ERROR_DS_INVALID_GROUP_TYPE|The specified group type is invalid.
8514|ERROR_DS_NO_NEST_GLOBALGROUP_IN_MIXEDDOMAIN|You cannot nest global groups in a mixed domain if the group is security-enabled.
8515|ERROR_DS_NO_NEST_LOCALGROUP_IN_MIXEDDOMAIN|You cannot nest local groups in a mixed domain if the group is security-enabled.
8516|ERROR_DS_GLOBAL_CANT_HAVE_LOCAL_MEMBER|A global group cannot have a local group as a member.
8517|ERROR_DS_GLOBAL_CANT_HAVE_UNIVERSAL_MEMBER|A global group cannot have a universal group as a member.
8518|ERROR_DS_UNIVERSAL_CANT_HAVE_LOCAL_MEMBER|A universal group cannot have a local group as a member.
8519|ERROR_DS_GLOBAL_CANT_HAVE_CROSSDOMAIN_MEMBER|A global group cannot have a cross-domain member.
8520|ERROR_DS_LOCAL_CANT_HAVE_CROSSDOMAIN_LOCAL_MEMBER|A local group cannot have another cross domain local group as a member.
8521|ERROR_DS_HAVE_PRIMARY_MEMBERS|A group with primary members cannot change to a security-disabled group.
8522|ERROR_DS_STRING_SD_CONVERSION_FAILED|The schema cache load failed to convert the string default SD on a class-schema object.
8523|ERROR_DS_NAMING_MASTER_GC|Only DSAs configured to be Global Catalog servers should be allowed to hold the Domain Naming Master FSMO role. (Applies only to Windows 2000 servers.)
8524|ERROR_DS_DNS_LOOKUP_FAILURE|The DSA operation is unable to proceed because of a DNS lookup failure.
8525|ERROR_DS_COULDNT_UPDATE_SPNS|While processing a change to the DNS Host Name for an object, the Service Principal Name values could not be kept in sync.
8526|ERROR_DS_CANT_RETRIEVE_SD|The Security Descriptor attribute could not be read.
8527|ERROR_DS_KEY_NOT_UNIQUE|The object requested was not found, but an object with that key was found.
8528|ERROR_DS_WRONG_LINKED_ATT_SYNTAX|The syntax of the linked attribute being added is incorrect. Forward links can only have syntax 2.5.5.1, 2.5.5.7, and 2.5.5.14, and backlinks can only have syntax 2.5.5.1.
8529|ERROR_DS_SAM_NEED_BOOTKEY_PASSWORD|Security Account Manager needs to get the boot password.
8530|ERROR_DS_SAM_NEED_BOOTKEY_FLOPPY|Security Account Manager needs to get the boot key from floppy disk.
8531|ERROR_DS_CANT_START|Directory Service cannot start.
8532|ERROR_DS_INIT_FAILURE|Directory Services could not start.
8533|ERROR_DS_NO_PKT_PRIVACY_ON_CONNECTION|The connection between client and server requires packet privacy or better.
8534|ERROR_DS_SOURCE_DOMAIN_IN_FOREST|The source domain may not be in the same forest as destination.
8535|ERROR_DS_DESTINATION_DOMAIN_NOT_IN_FOREST|The destination domain must be in the forest.
8536|ERROR_DS_DESTINATION_AUDITING_NOT_ENABLED|The operation requires that destination domain auditing be enabled.
8537|ERROR_DS_CANT_FIND_DC_FOR_SRC_DOMAIN|The operation couldn't locate a DC for the source domain.
8538|ERROR_DS_SRC_OBJ_NOT_GROUP_OR_USER|The source object must be a group or user.
8539|ERROR_DS_SRC_SID_EXISTS_IN_FOREST|The source object's SID already exists in destination forest.
8540|ERROR_DS_SRC_AND_DST_OBJECT_CLASS_MISMATCH|The source and destination object must be of the same type.
8541|ERROR_SAM_INIT_FAILURE|Security Accounts Manager initialization failed because of the following error: `%1. Error Status: 0x`%2. Click OK to shut down the system and reboot into Safe Mode. Check the event log for detailed information.
8542|ERROR_DS_DRA_SCHEMA_INFO_SHIP|Schema information could not be included in the replication request.
8543|ERROR_DS_DRA_SCHEMA_CONFLICT|The replication operation could not be completed due to a schema incompatibility.
8544|ERROR_DS_DRA_EARLIER_SCHEMA_CONFLICT|The replication operation could not be completed due to a previous schema incompatibility.
8545|ERROR_DS_DRA_OBJ_NC_MISMATCH|The replication update could not be applied because either the source or the destination has not yet received information regarding a recent cross-domain move operation.
8546|ERROR_DS_NC_STILL_HAS_DSAS|The requested domain could not be deleted because there exist domain controllers that still host this domain.
8547|ERROR_DS_GC_REQUIRED|The requested operation can be performed only on a global catalog server.
8548|ERROR_DS_LOCAL_MEMBER_OF_LOCAL_ONLY|A local group can only be a member of other local groups in the same domain.
8549|ERROR_DS_NO_FPO_IN_UNIVERSAL_GROUPS|Foreign security principals cannot be members of universal groups.
8550|ERROR_DS_CANT_ADD_TO_GC|The attribute is not allowed to be replicated to the GC because of security reasons.
8551|ERROR_DS_NO_CHECKPOINT_WITH_PDC|The checkpoint with the PDC could not be taken because there too many modifications being processed currently.
8552|ERROR_DS_SOURCE_AUDITING_NOT_ENABLED|The operation requires that source domain auditing be enabled.
8553|ERROR_DS_CANT_CREATE_IN_NONDOMAIN_NC|Security principal objects can only be created inside domain naming contexts.
8554|ERROR_DS_INVALID_NAME_FOR_SPN|A Service Principal Name (SPN) could not be constructed because the provided hostname is not in the necessary format.
8555|ERROR_DS_FILTER_USES_CONTRUCTED_ATTRS|A Filter was passed that uses constructed attributes.
8556|ERROR_DS_UNICODEPWD_NOT_IN_QUOTES|The unicodePwd attribute value must be enclosed in double quotes.
8557|ERROR_DS_MACHINE_ACCOUNT_QUOTA_EXCEEDED|Your computer could not be joined to the domain. You have exceeded the maximum number of computer accounts you are allowed to create in this domain. Contact your system administrator to have this limit reset or increased.
8558|ERROR_DS_MUST_BE_RUN_ON_DST_DC|For security reasons, the operation must be run on the destination DC.
8559|ERROR_DS_SRC_DC_MUST_BE_SP4_OR_GREATER|For security reasons, the source DC must be NT4SP4 or greater.
8560|ERROR_DS_CANT_TREE_DELETE_CRITICAL_OBJ|Critical Directory Service System objects cannot be deleted during tree delete operations. The tree delete may have been partially performed.
8561|ERROR_DS_INIT_FAILURE_CONSOLE|Directory Services could not start because of the following error: `%1. Error Status: 0x`%2. Please click OK to shutdown the system. You can use the recovery console to diagnose the system further.
8562|ERROR_DS_SAM_INIT_FAILURE_CONSOLE|Security Accounts Manager initialization failed because of the following error: `%1. Error Status: 0x`%2. Please click OK to shutdown the system. You can use the recovery console to diagnose the system further.
8563|ERROR_DS_FOREST_VERSION_TOO_HIGH|The version of the operating system is incompatible with the current AD DS forest functional level or AD LDS Configuration Set functional level. You must upgrade to a new version of the operating system before this server can become an AD DS Domain Controller or add an AD LDS Instance in this AD DS Forest or AD LDS Configuration Set.
8564|ERROR_DS_DOMAIN_VERSION_TOO_HIGH|The version of the operating system installed is incompatible with the current domain functional level. You must upgrade to a new version of the operating system before this server can become a domain controller in this domain.
8565|ERROR_DS_FOREST_VERSION_TOO_LOW|The version of the operating system installed on this server no longer supports the current AD DS Forest functional level or AD LDS Configuration Set functional level. You must raise the AD DS Forest functional level or AD LDS Configuration Set functional level before this server can become an AD DS Domain Controller or an AD LDS Instance in this Forest or Configuration Set.
8566|ERROR_DS_DOMAIN_VERSION_TOO_LOW|The version of the operating system installed on this server no longer supports the current domain functional level. You must raise the domain functional level before this server can become a domain controller in this domain.
8567|ERROR_DS_INCOMPATIBLE_VERSION|The version of the operating system installed on this server is incompatible with the functional level of the domain or forest.
8568|ERROR_DS_LOW_DSA_VERSION|The functional level of the domain (or forest) cannot be raised to the requested value, because there exist one or more domain controllers in the domain (or forest) that are at a lower incompatible functional level.
8569|ERROR_DS_NO_BEHAVIOR_VERSION_IN_MIXEDDOMAIN|The forest functional level cannot be raised to the requested value since one or more domains are still in mixed domain mode. All domains in the forest must be in native mode, for you to raise the forest functional level.
8570|ERROR_DS_NOT_SUPPORTED_SORT_ORDER|The sort order requested is not supported.
8571|ERROR_DS_NAME_NOT_UNIQUE|The requested name already exists as a unique identifier.
8572|ERROR_DS_MACHINE_ACCOUNT_CREATED_PRENT4|The machine account was created pre-NT4. The account needs to be recreated.
8573|ERROR_DS_OUT_OF_VERSION_STORE|The database is out of version store.
8574|ERROR_DS_INCOMPATIBLE_CONTROLS_USED|Unable to continue operation because multiple conflicting controls were used.
8575|ERROR_DS_NO_REF_DOMAIN|Unable to find a valid security descriptor reference domain for this partition.
8576|ERROR_DS_RESERVED_LINK_ID|Schema update failed: The link identifier is reserved.
8577|ERROR_DS_LINK_ID_NOT_AVAILABLE|Schema update failed: There are no link identifiers available.
8578|ERROR_DS_AG_CANT_HAVE_UNIVERSAL_MEMBER|An account group cannot have a universal group as a member.
8579|ERROR_DS_MODIFYDN_DISALLOWED_BY_INSTANCE_TYPE|Rename or move operations on naming context heads or read-only objects are not allowed.
8580|ERROR_DS_NO_OBJECT_MOVE_IN_SCHEMA_NC|Move operations on objects in the schema naming context are not allowed.
8581|ERROR_DS_MODIFYDN_DISALLOWED_BY_FLAG|A system flag has been set on the object and does not allow the object to be moved or renamed.
8582|ERROR_DS_MODIFYDN_WRONG_GRANDPARENT|This object is not allowed to change its grandparent container. Moves are not forbidden on this object, but are restricted to sibling containers.
8583|ERROR_DS_NAME_ERROR_TRUST_REFERRAL|Unable to resolve completely, a referral to another forest is generated.
8584|ERROR_NOT_SUPPORTED_ON_STANDARD_SERVER|The requested action is not supported on standard server.
8585|ERROR_DS_CANT_ACCESS_REMOTE_PART_OF_AD|Could not access a partition of the directory service located on a remote server. Make sure at least one server is running for the partition in question.
8586|ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE_V2|The directory cannot validate the proposed naming context (or partition) name because it does not hold a replica nor can it contact a replica of the naming context above the proposed naming context. Please ensure that the parent naming context is properly registered in DNS, and at least one replica of this naming context is reachable by the Domain Naming master.
8587|ERROR_DS_THREAD_LIMIT_EXCEEDED|The thread limit for this request was exceeded.
8588|ERROR_DS_NOT_CLOSEST|The Global catalog server is not in the closest site.
8589|ERROR_DS_CANT_DERIVE_SPN_WITHOUT_SERVER_REF|The DS cannot derive a service principal name (SPN) with which to mutually authenticate the target server because the corresponding server object in the local DS database has no serverReference attribute.
8590|ERROR_DS_SINGLE_USER_MODE_FAILED|The Directory Service failed to enter single user mode.
8591|ERROR_DS_NTDSCRIPT_SYNTAX_ERROR|The Directory Service cannot parse the script because of a syntax error.
8592|ERROR_DS_NTDSCRIPT_PROCESS_ERROR|The Directory Service cannot process the script because of an error.
8593|ERROR_DS_DIFFERENT_REPL_EPOCHS|The directory service cannot perform the requested operation because the servers involved are of different replication epochs (which is usually related to a domain rename that is in progress).
8594|ERROR_DS_DRS_EXTENSIONS_CHANGED|The directory service binding must be renegotiated due to a change in the server extensions information.
8595|ERROR_DS_REPLICA_SET_CHANGE_NOT_ALLOWED_ON_DISABLED_CR|Operation not allowed on a disabled cross ref.
8596|ERROR_DS_NO_MSDS_INTID|Schema update failed: No values for msDS-IntId are available.
8597|ERROR_DS_DUP_MSDS_INTID|Schema update failed: Duplicate msDS-INtId. Retry the operation.
8598|ERROR_DS_EXISTS_IN_RDNATTID|Schema deletion failed: attribute is used in rDNAttID.
8599|ERROR_DS_AUTHORIZATION_FAILED|The directory service failed to authorize the request.
8600|ERROR_DS_INVALID_SCRIPT|The Directory Service cannot process the script because it is invalid.
8601|ERROR_DS_REMOTE_CROSSREF_OP_FAILED|The remote create cross reference operation failed on the Domain Naming Master FSMO. The operation's error is in the extended data.
8602|ERROR_DS_CROSS_REF_BUSY|A cross reference is in use locally with the same name.
8603|ERROR_DS_CANT_DERIVE_SPN_FOR_DELETED_DOMAIN|The DS cannot derive a service principal name (SPN) with which to mutually authenticate the target server because the server's domain has been deleted from the forest.
8604|ERROR_DS_CANT_DEMOTE_WITH_WRITEABLE_NC|Writeable NCs prevent this DC from demoting.
8605|ERROR_DS_DUPLICATE_ID_FOUND|The requested object has a non-unique identifier and cannot be retrieved.
8606|ERROR_DS_INSUFFICIENT_ATTR_TO_CREATE_OBJECT|Insufficient attributes were given to create an object. This object may not exist because it may have been deleted and already garbage collected.
8607|ERROR_DS_GROUP_CONVERSION_ERROR|The group cannot be converted due to attribute restrictions on the requested group type.
8608|ERROR_DS_CANT_MOVE_APP_BASIC_GROUP|Cross-domain move of non-empty basic application groups is not allowed.
8609|ERROR_DS_CANT_MOVE_APP_QUERY_GROUP|Cross-domain move of non-empty query based application groups is not allowed.
8610|ERROR_DS_ROLE_NOT_VERIFIED|The FSMO role ownership could not be verified because its directory partition has not replicated successfully with at least one replication partner.
8611|ERROR_DS_WKO_CONTAINER_CANNOT_BE_SPECIAL|The target container for a redirection of a well known object container cannot already be a special container.
8612|ERROR_DS_DOMAIN_RENAME_IN_PROGRESS|The Directory Service cannot perform the requested operation because a domain rename operation is in progress.
8613|ERROR_DS_EXISTING_AD_CHILD_NC|The directory service detected a child partition below the requested partition name. The partition hierarchy must be created in a top down method.
8614|ERROR_DS_REPL_LIFETIME_EXCEEDED|The directory service cannot replicate with this server because the time since the last replication with this server has exceeded the tombstone lifetime.
8615|ERROR_DS_DISALLOWED_IN_SYSTEM_CONTAINER|The requested operation is not allowed on an object under the system container.
8616|ERROR_DS_LDAP_SEND_QUEUE_FULL|The LDAP servers network send queue has filled up because the client is not processing the results of its requests fast enough. No more requests will be processed until the client catches up. If the client does not catch up then it will be disconnected.
8617|ERROR_DS_DRA_OUT_SCHEDULE_WINDOW|The scheduled replication did not take place because the system was too busy to execute the request within the schedule window. The replication queue is overloaded. Consider reducing the number of partners or decreasing the scheduled replication frequency.
8618|ERROR_DS_POLICY_NOT_KNOWN|At this time, it cannot be determined if the branch replication policy is available on the hub domain controller. Please retry at a later time to account for replication latencies.
8619|ERROR_NO_SITE_SETTINGS_OBJECT|The site settings object for the specified site does not exist.
8620|ERROR_NO_SECRETS|The local account store does not contain secret material for the specified account.
8621|ERROR_NO_WRITABLE_DC_FOUND|Could not find a writable domain controller in the domain.
8622|ERROR_DS_NO_SERVER_OBJECT|The server object for the domain controller does not exist.
8623|ERROR_DS_NO_NTDSA_OBJECT|The NTDS Settings object for the domain controller does not exist.
8624|ERROR_DS_NON_ASQ_SEARCH|The requested search operation is not supported for ASQ searches.
8625|ERROR_DS_AUDIT_FAILURE|A required audit event could not be generated for the operation.
8626|ERROR_DS_INVALID_SEARCH_FLAG_SUBTREE|The search flags for the attribute are invalid. The subtree index bit is valid only on single valued attributes.
8627|ERROR_DS_INVALID_SEARCH_FLAG_TUPLE|The search flags for the attribute are invalid. The tuple index bit is valid only on attributes of Unicode strings.
8628|ERROR_DS_HIERARCHY_TABLE_TOO_DEEP|The address books are nested too deeply. Failed to build the hierarchy table.
8629|ERROR_DS_DRA_CORRUPT_UTD_VECTOR|The specified up-to-date-ness vector is corrupt.
8630|ERROR_DS_DRA_SECRETS_DENIED|The request to replicate secrets is denied.
8631|ERROR_DS_RESERVED_MAPI_ID|Schema update failed: The MAPI identifier is reserved.
8632|ERROR_DS_MAPI_ID_NOT_AVAILABLE|Schema update failed: There are no MAPI identifiers available.
8633|ERROR_DS_DRA_MISSING_KRBTGT_SECRET|The replication operation failed because the required attributes of the local krbtgt object are missing.
8634|ERROR_DS_DOMAIN_NAME_EXISTS_IN_FOREST|The domain name of the trusted domain already exists in the forest.
8635|ERROR_DS_FLAT_NAME_EXISTS_IN_FOREST|The flat name of the trusted domain already exists in the forest.
8636|ERROR_INVALID_USER_PRINCIPAL_NAME|The User Principal Name (UPN) is invalid.
8637|ERROR_DS_OID_MAPPED_GROUP_CANT_HAVE_MEMBERS|OID mapped groups cannot have members.
8638|ERROR_DS_OID_NOT_FOUND|The specified OID cannot be found.
8639|ERROR_DS_DRA_RECYCLED_TARGET|The replication operation failed because the target object referred by a link value is recycled.
8640|ERROR_DS_DISALLOWED_NC_REDIRECT|The redirect operation failed because the target object is in a NC different from the domain NC of the current domain controller.
8641|ERROR_DS_HIGH_ADLDS_FFL|The functional level of the AD LDS configuration set cannot be lowered to the requested value.
8642|ERROR_DS_HIGH_DSA_VERSION|The functional level of the domain (or forest) cannot be lowered to the requested value.
8643|ERROR_DS_LOW_ADLDS_FFL|The functional level of the AD LDS configuration set cannot be raised to the requested value, because there exist one or more ADLDS instances that are at a lower incompatible functional level.
8644|ERROR_DOMAIN_SID_SAME_AS_LOCAL_WORKSTATION|The domain join cannot be completed because the SID of the domain you attempted to join was identical to the SID of this machine. This is a symptom of an improperly cloned operating system install. You should run sysprep on this machine in order to generate a new machine SID. Please see <a href="http://go.microsoft.com/fwlink/p/?linkid=168895" data-linktype="external">http://go.microsoft.com/fwlink/p/?linkid=168895</a> for more information.
8645|ERROR_DS_UNDELETE_SAM_VALIDATION_FAILED|The undelete operation failed because the Sam Account Name or Additional Sam Account Name of the object being undeleted conflicts with an existing live object.
8646|ERROR_INCORRECT_ACCOUNT_TYPE|The system is not authoritative for the specified account and therefore cannot complete the operation. Please retry the operation using the provider associated with this account. If this is an online provider please use the provider's online site.
9001|DNS_ERROR_RCODE_FORMAT_ERROR|DNS server unable to interpret format.
9002|DNS_ERROR_RCODE_SERVER_FAILURE|DNS server failure.
9003|DNS_ERROR_RCODE_NAME_ERROR|DNS name does not exist.
9004|DNS_ERROR_RCODE_NOT_IMPLEMENTED|DNS request not supported by name server.
9005|DNS_ERROR_RCODE_REFUSED|DNS operation refused.
9006|DNS_ERROR_RCODE_YXDOMAIN|DNS name that ought not exist, does exist.
9007|DNS_ERROR_RCODE_YXRRSET|DNS RR set that ought not exist, does exist.
9008|DNS_ERROR_RCODE_NXRRSET|DNS RR set that ought to exist, does not exist.
9009|DNS_ERROR_RCODE_NOTAUTH|DNS server not authoritative for zone.
9010|DNS_ERROR_RCODE_NOTZONE|DNS name in update or prereq is not in zone.
9016|DNS_ERROR_RCODE_BADSIG|DNS signature failed to verify.
9017|DNS_ERROR_RCODE_BADKEY|DNS bad key.
9018|DNS_ERROR_RCODE_BADTIME|DNS signature validity expired.
9101|DNS_ERROR_KEYMASTER_REQUIRED|Only the DNS server acting as the key master for the zone may perform this operation.
9102|DNS_ERROR_NOT_ALLOWED_ON_SIGNED_ZONE|This operation is not allowed on a zone that is signed or has signing keys.
9103|DNS_ERROR_NSEC3_INCOMPATIBLE_WITH_RSA_SHA1|NSEC3 is not compatible with the RSA-SHA-1 algorithm. Choose a different algorithm or use NSEC.`nThis value was also named <strong>DNS_ERROR_INVALID_NSEC3_PARAMETERS</strong>
9104|DNS_ERROR_NOT_ENOUGH_SIGNING_KEY_DESCRIPTORS|The zone does not have enough signing keys. There must be at least one key signing key (KSK) and at least one zone signing key (ZSK).
9105|DNS_ERROR_UNSUPPORTED_ALGORITHM|The specified algorithm is not supported.
9106|DNS_ERROR_INVALID_KEY_SIZE|The specified key size is not supported.
9107|DNS_ERROR_SIGNING_KEY_NOT_ACCESSIBLE|One or more of the signing keys for a zone are not accessible to the DNS server. Zone signing will not be operational until this error is resolved.
9108|DNS_ERROR_KSP_DOES_NOT_SUPPORT_PROTECTION|The specified key storage provider does not support DPAPI++ data protection. Zone signing will not be operational until this error is resolved.
9109|DNS_ERROR_UNEXPECTED_DATA_PROTECTION_ERROR|An unexpected DPAPI++ error was encountered. Zone signing will not be operational until this error is resolved.
9110|DNS_ERROR_UNEXPECTED_CNG_ERROR|An unexpected crypto error was encountered. Zone signing may not be operational until this error is resolved.
9111|DNS_ERROR_UNKNOWN_SIGNING_PARAMETER_VERSION|The DNS server encountered a signing key with an unknown version. Zone signing will not be operational until this error is resolved.
9112|DNS_ERROR_KSP_NOT_ACCESSIBLE|The specified key service provider cannot be opened by the DNS server.
9113|DNS_ERROR_TOO_MANY_SKDS|The DNS server cannot accept any more signing keys with the specified algorithm and KSK flag value for this zone.
9114|DNS_ERROR_INVALID_ROLLOVER_PERIOD|The specified rollover period is invalid.
9115|DNS_ERROR_INVALID_INITIAL_ROLLOVER_OFFSET|The specified initial rollover offset is invalid.
9116|DNS_ERROR_ROLLOVER_IN_PROGRESS|The specified signing key is already in process of rolling over keys.
9117|DNS_ERROR_STANDBY_KEY_NOT_PRESENT|The specified signing key does not have a standby key to revoke.
9118|DNS_ERROR_NOT_ALLOWED_ON_ZSK|This operation is not allowed on a zone signing key (ZSK).
9119|DNS_ERROR_NOT_ALLOWED_ON_ACTIVE_SKD|This operation is not allowed on an active signing key.
9120|DNS_ERROR_ROLLOVER_ALREADY_QUEUED|The specified signing key is already queued for rollover.
9121|DNS_ERROR_NOT_ALLOWED_ON_UNSIGNED_ZONE|This operation is not allowed on an unsigned zone.
9122|DNS_ERROR_BAD_KEYMASTER|This operation could not be completed because the DNS server listed as the current key master for this zone is down or misconfigured. Resolve the problem on the current key master for this zone or use another DNS server to seize the key master role.
9123|DNS_ERROR_INVALID_SIGNATURE_VALIDITY_PERIOD|The specified signature validity period is invalid.
9124|DNS_ERROR_INVALID_NSEC3_ITERATION_COUNT|The specified NSEC3 iteration count is higher than allowed by the minimum key length used in the zone.
9125|DNS_ERROR_DNSSEC_IS_DISABLED|This operation could not be completed because the DNS server has been configured with DNSSEC features disabled. Enable DNSSEC on the DNS server.
9126|DNS_ERROR_INVALID_XML|This operation could not be completed because the XML stream received is empty or syntactically invalid.
9127|DNS_ERROR_NO_VALID_TRUST_ANCHORS|This operation completed, but no trust anchors were added because all of the trust anchors received were either invalid, unsupported, expired, or would not become valid in less than 30 days.
9128|DNS_ERROR_ROLLOVER_NOT_POKEABLE|The specified signing key is not waiting for parental DS update.
9129|DNS_ERROR_NSEC3_NAME_COLLISION|Hash collision detected during NSEC3 signing. Specify a different user-provided salt, or use a randomly generated salt, and attempt to sign the zone again.
9130|DNS_ERROR_NSEC_INCOMPATIBLE_WITH_NSEC3_RSA_SHA1|NSEC is not compatible with the NSEC3-RSA-SHA-1 algorithm. Choose a different algorithm or use NSEC3.
9501|DNS_INFO_NO_RECORDS|No records found for given DNS query.
9502|DNS_ERROR_BAD_PACKET|Bad DNS packet.
9503|DNS_ERROR_NO_PACKET|No DNS packet.
9504|DNS_ERROR_RCODE|DNS error, check rcode.
9505|DNS_ERROR_UNSECURE_PACKET|Unsecured DNS packet.
9506|DNS_REQUEST_PENDING|DNS query request is pending.
9551|DNS_ERROR_INVALID_TYPE|Invalid DNS type.
9552|DNS_ERROR_INVALID_IP_ADDRESS|Invalid IP address.
9553|DNS_ERROR_INVALID_PROPERTY|Invalid property.
9554|DNS_ERROR_TRY_AGAIN_LATER|Try DNS operation again later.
9555|DNS_ERROR_NOT_UNIQUE|Record for given name and type is not unique.
9556|DNS_ERROR_NON_RFC_NAME|DNS name does not comply with RFC specifications.
9557|DNS_STATUS_FQDN|DNS name is a fully-qualified DNS name.
9558|DNS_STATUS_DOTTED_NAME|DNS name is dotted (multi-label).
9559|DNS_STATUS_SINGLE_PART_NAME|DNS name is a single-part name.
9560|DNS_ERROR_INVALID_NAME_CHAR|DNS name contains an invalid character.
9561|DNS_ERROR_NUMERIC_NAME|DNS name is entirely numeric.
9562|DNS_ERROR_NOT_ALLOWED_ON_ROOT_SERVER|The operation requested is not permitted on a DNS root server.
9563|DNS_ERROR_NOT_ALLOWED_UNDER_DELEGATION|The record could not be created because this part of the DNS namespace has been delegated to another server.
9564|DNS_ERROR_CANNOT_FIND_ROOT_HINTS|The DNS server could not find a set of root hints.
9565|DNS_ERROR_INCONSISTENT_ROOT_HINTS|The DNS server found root hints but they were not consistent across all adapters.
9566|DNS_ERROR_DWORD_VALUE_TOO_SMALL|The specified value is too small for this parameter.
9567|DNS_ERROR_DWORD_VALUE_TOO_LARGE|The specified value is too large for this parameter.
9568|DNS_ERROR_BACKGROUND_LOADING|This operation is not allowed while the DNS server is loading zones in the background. Please try again later.
9569|DNS_ERROR_NOT_ALLOWED_ON_RODC|The operation requested is not permitted on against a DNS server running on a read-only DC.
9570|DNS_ERROR_NOT_ALLOWED_UNDER_DNAME|No data is allowed to exist underneath a DNAME record.
9571|DNS_ERROR_DELEGATION_REQUIRED|This operation requires credentials delegation.
9572|DNS_ERROR_INVALID_POLICY_TABLE|Name resolution policy table has been corrupted. DNS resolution will fail until it is fixed. Contact your network administrator.
9601|DNS_ERROR_ZONE_DOES_NOT_EXIST|DNS zone does not exist.
9602|DNS_ERROR_NO_ZONE_INFO|DNS zone information not available.
9603|DNS_ERROR_INVALID_ZONE_OPERATION|Invalid operation for DNS zone.
9604|DNS_ERROR_ZONE_CONFIGURATION_ERROR|Invalid DNS zone configuration.
9605|DNS_ERROR_ZONE_HAS_NO_SOA_RECORD|DNS zone has no start of authority (SOA) record.
9606|DNS_ERROR_ZONE_HAS_NO_NS_RECORDS|DNS zone has no Name Server (NS) record.
9607|DNS_ERROR_ZONE_LOCKED|DNS zone is locked.
9608|DNS_ERROR_ZONE_CREATION_FAILED|DNS zone creation failed.
9609|DNS_ERROR_ZONE_ALREADY_EXISTS|DNS zone already exists.
9610|DNS_ERROR_AUTOZONE_ALREADY_EXISTS|DNS automatic zone already exists.
9611|DNS_ERROR_INVALID_ZONE_TYPE|Invalid DNS zone type.
9612|DNS_ERROR_SECONDARY_REQUIRES_MASTER_IP|Secondary DNS zone requires master IP address.
9613|DNS_ERROR_ZONE_NOT_SECONDARY|DNS zone not secondary.
9614|DNS_ERROR_NEED_SECONDARY_ADDRESSES|Need secondary IP address.
9615|DNS_ERROR_WINS_INIT_FAILED|WINS initialization failed.
9616|DNS_ERROR_NEED_WINS_SERVERS|Need WINS servers.
9617|DNS_ERROR_NBSTAT_INIT_FAILED|NBTSTAT initialization call failed.
9618|DNS_ERROR_SOA_DELETE_INVALID|Invalid delete of start of authority (SOA).
9619|DNS_ERROR_FORWARDER_ALREADY_EXISTS|A conditional forwarding zone already exists for that name.
9620|DNS_ERROR_ZONE_REQUIRES_MASTER_IP|This zone must be configured with one or more master DNS server IP addresses.
9621|DNS_ERROR_ZONE_IS_SHUTDOWN|The operation cannot be performed because this zone is shut down.
9622|DNS_ERROR_ZONE_LOCKED_FOR_SIGNING|This operation cannot be performed because the zone is currently being signed. Please try again later.
9651|DNS_ERROR_PRIMARY_REQUIRES_DATAFILE|Primary DNS zone requires datafile.
9652|DNS_ERROR_INVALID_DATAFILE_NAME|Invalid datafile name for DNS zone.
9653|DNS_ERROR_DATAFILE_OPEN_FAILURE|Failed to open datafile for DNS zone.
9654|DNS_ERROR_FILE_WRITEBACK_FAILED|Failed to write datafile for DNS zone.
9655|DNS_ERROR_DATAFILE_PARSING|Failure while reading datafile for DNS zone.
9701|DNS_ERROR_RECORD_DOES_NOT_EXIST|DNS record does not exist.
9702|DNS_ERROR_RECORD_FORMAT|DNS record format error.
9703|DNS_ERROR_NODE_CREATION_FAILED|Node creation failure in DNS.
9704|DNS_ERROR_UNKNOWN_RECORD_TYPE|Unknown DNS record type.
9705|DNS_ERROR_RECORD_TIMED_OUT|DNS record timed out.
9706|DNS_ERROR_NAME_NOT_IN_ZONE|Name not in DNS zone.
9707|DNS_ERROR_CNAME_LOOP|CNAME loop detected.
9708|DNS_ERROR_NODE_IS_CNAME|Node is a CNAME DNS record.
9709|DNS_ERROR_CNAME_COLLISION|A CNAME record already exists for given name.
9710|DNS_ERROR_RECORD_ONLY_AT_ZONE_ROOT|Record only at DNS zone root.
9711|DNS_ERROR_RECORD_ALREADY_EXISTS|DNS record already exists.
9712|DNS_ERROR_SECONDARY_DATA|Secondary DNS zone data error.
9713|DNS_ERROR_NO_CREATE_CACHE_DATA|Could not create DNS cache data.
9714|DNS_ERROR_NAME_DOES_NOT_EXIST|DNS name does not exist.
9715|DNS_WARNING_PTR_CREATE_FAILED|Could not create pointer (PTR) record.
9716|DNS_WARNING_DOMAIN_UNDELETED|DNS domain was undeleted.
9717|DNS_ERROR_DS_UNAVAILABLE|The directory service is unavailable.
9718|DNS_ERROR_DS_ZONE_ALREADY_EXISTS|DNS zone already exists in the directory service.
9719|DNS_ERROR_NO_BOOTFILE_IF_DS_ZONE|DNS server not creating or reading the boot file for the directory service integrated DNS zone.
9720|DNS_ERROR_NODE_IS_DNAME|Node is a DNAME DNS record.
9721|DNS_ERROR_DNAME_COLLISION|A DNAME record already exists for given name.
9722|DNS_ERROR_ALIAS_LOOP|An alias loop has been detected with either CNAME or DNAME records.
9751|DNS_INFO_AXFR_COMPLETE|DNS AXFR (zone transfer) complete.
9752|DNS_ERROR_AXFR|DNS zone transfer failed.
9753|DNS_INFO_ADDED_LOCAL_WINS|Added local WINS server.
9801|DNS_STATUS_CONTINUE_NEEDED|Secure update call needs to continue update request.
9851|DNS_ERROR_NO_TCPIP|TCP/IP network protocol not installed.
9852|DNS_ERROR_NO_DNS_SERVERS|No DNS servers configured for local system.
9901|DNS_ERROR_DP_DOES_NOT_EXIST|The specified directory partition does not exist.
9902|DNS_ERROR_DP_ALREADY_EXISTS|The specified directory partition already exists.
9903|DNS_ERROR_DP_NOT_ENLISTED|This DNS server is not enlisted in the specified directory partition.
9904|DNS_ERROR_DP_ALREADY_ENLISTED|This DNS server is already enlisted in the specified directory partition.
9905|DNS_ERROR_DP_NOT_AVAILABLE|The directory partition is not available at this time. Please wait a few minutes and try again.
9906|DNS_ERROR_DP_FSMO_ERROR|The operation failed because the domain naming master FSMO role could not be reached. The domain controller holding the domain naming master FSMO role is down or unable to service the request or is not running Windows Server 2003 or later.
10004|WSAEINTR|A blocking operation was interrupted by a call to WSACancelBlockingCall.
10009|WSAEBADF|The file handle supplied is not valid.
10013|WSAEACCES|An attempt was made to access a socket in a way forbidden by its access permissions.
10014|WSAEFAULT|The system detected an invalid pointer address in attempting to use a pointer argument in a call.
10022|WSAEINVAL|An invalid argument was supplied.
10024|WSAEMFILE|Too many open sockets.
10035|WSAEWOULDBLOCK|A non-blocking socket operation could not be completed immediately.
10036|WSAEINPROGRESS|A blocking operation is currently executing.
10037|WSAEALREADY|An operation was attempted on a non-blocking socket that already had an operation in progress.
10038|WSAENOTSOCK|An operation was attempted on something that is not a socket.
10039|WSAEDESTADDRREQ|A required address was omitted from an operation on a socket.
10040|WSAEMSGSIZE|A message sent on a datagram socket was larger than the internal message buffer or some other network limit, or the buffer used to receive a datagram into was smaller than the datagram itself.
10041|WSAEPROTOTYPE|A protocol was specified in the socket function call that does not support the semantics of the socket type requested.
10042|WSAENOPROTOOPT|An unknown, invalid, or unsupported option or level was specified in a getsockopt or setsockopt call.
10043|WSAEPROTONOSUPPORT|The requested protocol has not been configured into the system, or no implementation for it exists.
10044|WSAESOCKTNOSUPPORT|The support for the specified socket type does not exist in this address family.
10045|WSAEOPNOTSUPP|The attempted operation is not supported for the type of object referenced.
10046|WSAEPFNOSUPPORT|The protocol family has not been configured into the system or no implementation for it exists.
10047|WSAEAFNOSUPPORT|An address incompatible with the requested protocol was used.
10048|WSAEADDRINUSE|Only one usage of each socket address (protocol/network address/port) is normally permitted.
10049|WSAEADDRNOTAVAIL|The requested address is not valid in its context.
10050|WSAENETDOWN|A socket operation encountered a dead network.
10051|WSAENETUNREACH|A socket operation was attempted to an unreachable network.
10052|WSAENETRESET|The connection has been broken due to keep-alive activity detecting a failure while the operation was in progress.
10053|WSAECONNABORTED|An established connection was aborted by the software in your host machine.
10054|WSAECONNRESET|An existing connection was forcibly closed by the remote host.
10055|WSAENOBUFS|An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.
10056|WSAEISCONN|A connect request was made on an already connected socket.
10057|WSAENOTCONN|A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using a sendto call) no address was supplied.
10058|WSAESHUTDOWN|A request to send or receive data was disallowed because the socket had already been shut down in that direction with a previous shutdown call.
10059|WSAETOOMANYREFS|Too many references to some kernel object.
10060|WSAETIMEDOUT|A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.
10061|WSAECONNREFUSED|No connection could be made because the target machine actively refused it.
10062|WSAELOOP|Cannot translate name.
10063|WSAENAMETOOLONG|Name component or name was too long.
10064|WSAEHOSTDOWN|A socket operation failed because the destination host was down.
10065|WSAEHOSTUNREACH|A socket operation was attempted to an unreachable host.
10066|WSAENOTEMPTY|Cannot remove a directory that is not empty.
10067|WSAEPROCLIM|A Windows Sockets implementation may have a limit on the number of applications that may use it simultaneously.
10068|WSAEUSERS|Ran out of quota.
10069|WSAEDQUOT|Ran out of disk quota.
10070|WSAESTALE|File handle reference is no longer available.
10071|WSAEREMOTE|Item is not available locally.
10091|WSASYSNOTREADY|WSAStartup cannot function at this time because the underlying system it uses to provide network services is currently unavailable.
10092|WSAVERNOTSUPPORTED|The Windows Sockets version requested is not supported.
10093|WSANOTINITIALISED|Either the application has not called WSAStartup, or WSAStartup failed.
10101|WSAEDISCON|Returned by WSARecv or WSARecvFrom to indicate the remote party has initiated a graceful shutdown sequence.
10102|WSAENOMORE|No more results can be returned by WSALookupServiceNext.
10103|WSAECANCELLED|A call to WSALookupServiceEnd was made while this call was still processing. The call has been canceled.
10104|WSAEINVALIDPROCTABLE|The procedure call table is invalid.
10105|WSAEINVALIDPROVIDER|The requested service provider is invalid.
10106|WSAEPROVIDERFAILEDINIT|The requested service provider could not be loaded or initialized.
10107|WSASYSCALLFAILURE|A system call has failed.
10108|WSASERVICE_NOT_FOUND|No such service is known. The service cannot be found in the specified name space.
10109|WSATYPE_NOT_FOUND|The specified class was not found.
10110|WSA_E_NO_MORE|No more results can be returned by WSALookupServiceNext.
10111|WSA_E_CANCELLED|A call to WSALookupServiceEnd was made while this call was still processing. The call has been canceled.
10112|WSAEREFUSED|A database query failed because it was actively refused.
11001|WSAHOST_NOT_FOUND|No such host is known.
11002|WSATRY_AGAIN|This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server.
11003|WSANO_RECOVERY|A non-recoverable error occurred during a database lookup.
11004|WSANO_DATA|The requested name is valid, but no data of the requested type was found.
11005|WSA_QOS_RECEIVERS|At least one reserve has arrived.
11006|WSA_QOS_SENDERS|At least one path has arrived.
11007|WSA_QOS_NO_SENDERS|There are no senders.
11008|WSA_QOS_NO_RECEIVERS|There are no receivers.
11009|WSA_QOS_REQUEST_CONFIRMED|Reserve has been confirmed.
11010|WSA_QOS_ADMISSION_FAILURE|Error due to lack of resources.
11011|WSA_QOS_POLICY_FAILURE|Rejected for administrative reasons - bad credentials.
11012|WSA_QOS_BAD_STYLE|Unknown or conflicting style.
11013|WSA_QOS_BAD_OBJECT|Problem with some part of the filterspec or providerspecific buffer in general.
11014|WSA_QOS_TRAFFIC_CTRL_ERROR|Problem with some part of the flowspec.
11015|WSA_QOS_GENERIC_ERROR|General QOS error.
11016|WSA_QOS_ESERVICETYPE|An invalid or unrecognized service type was found in the flowspec.
11017|WSA_QOS_EFLOWSPEC|An invalid or inconsistent flowspec was found in the QOS structure.
11018|WSA_QOS_EPROVSPECBUF|Invalid QOS provider-specific buffer.
11019|WSA_QOS_EFILTERSTYLE|An invalid QOS filter style was used.
11020|WSA_QOS_EFILTERTYPE|An invalid QOS filter type was used.
11021|WSA_QOS_EFILTERCOUNT|An incorrect number of QOS FILTERSPECs were specified in the FLOWDESCRIPTOR.
11022|WSA_QOS_EOBJLENGTH|An object with an invalid ObjectLength field was specified in the QOS provider-specific buffer.
11023|WSA_QOS_EFLOWCOUNT|An incorrect number of flow descriptors was specified in the QOS structure.
11024|WSA_QOS_EUNKOWNPSOBJ|An unrecognized object was found in the QOS provider-specific buffer.
11025|WSA_QOS_EPOLICYOBJ|An invalid policy object was found in the QOS provider-specific buffer.
11026|WSA_QOS_EFLOWDESC|An invalid QOS flow descriptor was found in the flow descriptor list.
11027|WSA_QOS_EPSFLOWSPEC|An invalid or inconsistent flowspec was found in the QOS provider specific buffer.
11028|WSA_QOS_EPSFILTERSPEC|An invalid FILTERSPEC was found in the QOS provider-specific buffer.
11029|WSA_QOS_ESDMODEOBJ|An invalid shape discard mode object was found in the QOS provider specific buffer.
11030|WSA_QOS_ESHAPERATEOBJ|An invalid shaping rate object was found in the QOS provider-specific buffer.
11031|WSA_QOS_RESERVED_PETYPE|A reserved policy element was found in the QOS provider-specific buffer.
11032|WSA_SECURE_HOST_NOT_FOUND|No such host is known securely.
11033|WSA_IPSEC_NAME_POLICY_ERROR|Name based IPSEC policy could not be added
12111|ERROR_FTP_DROPPED|The FTP operation was not completed because the session was aborted.
12112|ERROR_FTP_NO_PASSIVE_MODE|Passive mode is not available on the server.
12110|ERROR_FTP_TRANSFER_IN_PROGRESS|The requested operation cannot be made on the FTP session handle because an operation is already in progress.
12137|ERROR_GOPHER_ATTRIBUTE_NOT_FOUND|The requested attribute could not be located.`nWindows XP and Windows Server 2003 R2 and earlier only.
12132|ERROR_GOPHER_DATA_ERROR|An error was detected while receiving data from the Gopher server.`nWindows XP and Windows Server 2003 R2 and earlier only.
12133|ERROR_GOPHER_END_OF_DATA|The end of the data has been reached.`nWindows XP and Windows Server 2003 R2 and earlier only.
12135|ERROR_GOPHER_INCORRECT_LOCATOR_TYPE|The type of the locator is not correct for this operation.`nWindows XP and Windows Server 2003 R2 and earlier only.
12134|ERROR_GOPHER_INVALID_LOCATOR|The supplied locator is not valid.`nWindows XP and Windows Server 2003 R2 and earlier only.
12131|ERROR_GOPHER_NOT_FILE|The request must be made for a file locator.`nWindows XP and Windows Server 2003 R2 and earlier only.
12136|ERROR_GOPHER_NOT_GOPHER_PLUS|The requested operation can be made only against a Gopher+ server, or with a locator that specifies a Gopher+ operation.`nWindows XP and Windows Server 2003 R2 and earlier only.
12130|ERROR_GOPHER_PROTOCOL_ERROR|An error was detected while parsing data returned from the Gopher server.`nWindows XP and Windows Server 2003 R2 and earlier only.
12138|ERROR_GOPHER_UNKNOWN_LOCATOR|The locator type is unknown.`nWindows XP and Windows Server 2003 R2 and earlier only.
12162|ERROR_HTTP_COOKIE_DECLINED|The HTTP cookie was declined by the server.
12161|ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION|The HTTP cookie requires confirmation.`nWindows Vista and Windows Server 2008 and earlier only.
12151|ERROR_HTTP_DOWNLEVEL_SERVER|The server did not return any headers.
12155|ERROR_HTTP_HEADER_ALREADY_EXISTS|The header could not be added because it already exists.
12150|ERROR_HTTP_HEADER_NOT_FOUND|The requested header could not be located.
12153|ERROR_HTTP_INVALID_HEADER|The supplied header is invalid.
12154|ERROR_HTTP_INVALID_QUERY_REQUEST|The request made to HttpQueryInfo is invalid.
12152|ERROR_HTTP_INVALID_SERVER_RESPONSE|The server response could not be parsed.
12160|ERROR_HTTP_NOT_REDIRECTED|The HTTP request was not redirected.
12156|ERROR_HTTP_REDIRECT_FAILED|The redirection failed because either the scheme changed (for example, HTTP to FTP) or all attempts made to redirect failed (default is five attempts).
12168|ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION|The redirection requires user confirmation.
12047|ERROR_INTERNET_ASYNC_THREAD_FAILED|The application could not start an asynchronous thread.
12166|ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT|There was an error in the automatic proxy configuration script.
12010|ERROR_INTERNET_BAD_OPTION_LENGTH|The length of an option supplied to InternetQueryOption or InternetSetOption is incorrect for the type of option specified.
12022|ERROR_INTERNET_BAD_REGISTRY_PARAMETER|A required registry value was located but is an incorrect type or has an invalid value.
12029|ERROR_INTERNET_CANNOT_CONNECT|The attempt to connect to the server failed.
12042|ERROR_INTERNET_CHG_POST_IS_NON_SECURE|The application is posting and attempting to change multiple lines of text on a server that is not secure.
12044|ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED|The server is requesting client authentication.
12046|ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP|Client authorization is not set up on this computer.
12030|ERROR_INTERNET_CONNECTION_ABORTED|The connection with the server has been terminated.
12031|ERROR_INTERNET_CONNECTION_RESET|The connection with the server has been reset.
12175|ERROR_INTERNET_DECODING_FAILED|WinINet failed to perform content decoding on the response. For more information, see the Content Encoding topic.
12049|ERROR_INTERNET_DIALOG_PENDING|Another thread has a password dialog box in progress.
12163|ERROR_INTERNET_DISCONNECTED|The Internet connection has been lost.
12003|ERROR_INTERNET_EXTENDED_ERROR|An extended error was returned from the server. This is typically a string or buffer containing a verbose error message. Call InternetGetLastResponseInfo to retrieve the error text.
12171|ERROR_INTERNET_FAILED_DUETOSECURITYCHECK|The function failed due to a security check.
12032|ERROR_INTERNET_FORCE_RETRY|The function needs to redo the request.
12054|ERROR_INTERNET_FORTEZZA_LOGIN_NEEDED|The requested resource requires Fortezza authentication.
12036|ERROR_INTERNET_HANDLE_EXISTS|The request failed because the handle already exists.
12039|ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR|The application is moving from a non-SSL to an SSL connection because of a redirect.
12052|ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR|The data being submitted to an SSL connection is being redirected to a non-SSL connection.
12040|ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR|The application is moving from an SSL to an non-SSL connection because of a redirect.
12027|ERROR_INTERNET_INCORRECT_FORMAT|The format of the request is invalid.
12019|ERROR_INTERNET_INCORRECT_HANDLE_STATE|The requested operation cannot be carried out because the handle supplied is not in the correct state.
12018|ERROR_INTERNET_INCORRECT_HANDLE_TYPE|The type of handle supplied is incorrect for this operation.
12014|ERROR_INTERNET_INCORRECT_PASSWORD|The request to connect and log on to an FTP server could not be completed because the supplied password is incorrect.
12013|ERROR_INTERNET_INCORRECT_USER_NAME|The request to connect and log on to an FTP server could not be completed because the supplied user name is incorrect.
12053|ERROR_INTERNET_INSERT_CDROM|The request requires a CD-ROM to be inserted in the CD-ROM drive to locate the resource requested.`nWindows Vista and Windows Server 2008 and earlier only.
12004|ERROR_INTERNET_INTERNAL_ERROR|An internal error has occurred.
12045|ERROR_INTERNET_INVALID_CA|The function is unfamiliar with the Certificate Authority that generated the server's certificate.
12016|ERROR_INTERNET_INVALID_OPERATION|The requested operation is invalid.
12009|ERROR_INTERNET_INVALID_OPTION|A request to InternetQueryOption or InternetSetOption specified an invalid option value.
12033|ERROR_INTERNET_INVALID_PROXY_REQUEST|The request to the proxy was invalid.
12005|ERROR_INTERNET_INVALID_URL|The URL is invalid.
12028|ERROR_INTERNET_ITEM_NOT_FOUND|The requested item could not be located.
12015|ERROR_INTERNET_LOGIN_FAILURE|The request to connect and log on to an FTP server failed.
12174|ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY|The MS-Logoff digest header has been returned from the website. This header specifically instructs the digest package to purge credentials for the associated realm. This error will only be returned if INTERNET_ERROR_MASK_LOGIN_FAILURE_DISPLAY_ENTITY_BODY option has been set; otherwise, ERROR_INTERNET_LOGIN_FAILURE is returned.
12041|ERROR_INTERNET_MIXED_SECURITY|The content is not entirely secure. Some of the content being viewed may have come from unsecured servers.
12007|ERROR_INTERNET_NAME_NOT_RESOLVED|The server name could not be resolved.
12173|ERROR_INTERNET_NEED_MSN_SSPI_PKG|Not currently implemented.
12034|ERROR_INTERNET_NEED_UI|A user interface or other blocking operation has been requested.`nWindows Vista and Windows Server 2008 and earlier only.
12025|ERROR_INTERNET_NO_CALLBACK|An asynchronous request could not be made because a callback function has not been set.
12024|ERROR_INTERNET_NO_CONTEXT|An asynchronous request could not be made because a zero context value was supplied.
12023|ERROR_INTERNET_NO_DIRECT_ACCESS|Direct network access cannot be made at this time.
12172|ERROR_INTERNET_NOT_INITIALIZED|Initialization of the WinINet API has not occurred. Indicates that a higher-level function, such as InternetOpen, has not been called yet.
12020|ERROR_INTERNET_NOT_PROXY_REQUEST|The request cannot be made via a proxy.
12017|ERROR_INTERNET_OPERATION_CANCELLED|The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed.
12011|ERROR_INTERNET_OPTION_NOT_SETTABLE|The requested option cannot be set, only queried.
12001|ERROR_INTERNET_OUT_OF_HANDLES|No more handles could be generated at this time.
12043|ERROR_INTERNET_POST_IS_NON_SECURE|The application is posting data to a server that is not secure.
12008|ERROR_INTERNET_PROTOCOL_NOT_FOUND|The requested protocol could not be located.
12165|ERROR_INTERNET_PROXY_SERVER_UNREACHABLE|The designated proxy server cannot be reached.
12048|ERROR_INTERNET_REDIRECT_SCHEME_CHANGE|The function could not handle the redirection, because the scheme changed (for example, HTTP to FTP).
12021|ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND|A required registry value could not be located.
12026|ERROR_INTERNET_REQUEST_PENDING|The required operation could not be completed because one or more requests are pending.
12050|ERROR_INTERNET_RETRY_DIALOG|The dialog box should be retried.
12038|ERROR_INTERNET_SEC_CERT_CN_INVALID|SSL certificate common name (host name field) is incorrect for example, if you entered www.server.com and the common name on the certificate says www.different.com.
12037|ERROR_INTERNET_SEC_CERT_DATE_INVALID|SSL certificate date that was received from the server is bad. The certificate is expired.
12055|ERROR_INTERNET_SEC_CERT_ERRORS|The SSL certificate contains errors.
12056|ERROR_INTERNET_SEC_CERT_NO_REV|The SSL certificate was not revoked.
12057|ERROR_INTERNET_SEC_CERT_REV_FAILED|Revocation of the SSL certificate failed.
12170|ERROR_INTERNET_SEC_CERT_REVOKED|The SSL certificate was revoked.
12169|ERROR_INTERNET_SEC_INVALID_CERT|The SSL certificate is invalid.
12157|ERROR_INTERNET_SECURITY_CHANNEL_ERROR|The application experienced an internal error loading the SSL libraries.
12164|ERROR_INTERNET_SERVER_UNREACHABLE|The website or server indicated is unreachable.
12012|ERROR_INTERNET_SHUTDOWN|WinINet support is being shut down or unloaded.
12159|ERROR_INTERNET_TCPIP_NOT_INSTALLED|The required protocol stack is not loaded and the application cannot start WinSock.
12002|ERROR_INTERNET_TIMEOUT|The request has timed out.
12158|ERROR_INTERNET_UNABLE_TO_CACHE_FILE|The function was unable to cache the file.
12167|ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT|The automatic proxy configuration script could not be downloaded. The INTERNET_FLAG_MUST_CACHE_REQUEST flag was set.
12006|ERROR_INTERNET_UNRECOGNIZED_SCHEME|The URL scheme could not be recognized, or is not supported."
13000|ERROR_IPSEC_QM_POLICY_EXISTS|The specified quick mode policy already exists.
13001|ERROR_IPSEC_QM_POLICY_NOT_FOUND|The specified quick mode policy was not found.
13002|ERROR_IPSEC_QM_POLICY_IN_USE|The specified quick mode policy is being used.
13003|ERROR_IPSEC_MM_POLICY_EXISTS|The specified main mode policy already exists.
13004|ERROR_IPSEC_MM_POLICY_NOT_FOUND|The specified main mode policy was not found.
13005|ERROR_IPSEC_MM_POLICY_IN_USE|The specified main mode policy is being used.
13006|ERROR_IPSEC_MM_FILTER_EXISTS|The specified main mode filter already exists.
13007|ERROR_IPSEC_MM_FILTER_NOT_FOUND|The specified main mode filter was not found.
13008|ERROR_IPSEC_TRANSPORT_FILTER_EXISTS|The specified transport mode filter already exists.
13009|ERROR_IPSEC_TRANSPORT_FILTER_NOT_FOUND|The specified transport mode filter does not exist.
13010|ERROR_IPSEC_MM_AUTH_EXISTS|The specified main mode authentication list exists.
13011|ERROR_IPSEC_MM_AUTH_NOT_FOUND|The specified main mode authentication list was not found.
13012|ERROR_IPSEC_MM_AUTH_IN_USE|The specified main mode authentication list is being used.
13013|ERROR_IPSEC_DEFAULT_MM_POLICY_NOT_FOUND|The specified default main mode policy was not found.
13014|ERROR_IPSEC_DEFAULT_MM_AUTH_NOT_FOUND|The specified default main mode authentication list was not found.
13015|ERROR_IPSEC_DEFAULT_QM_POLICY_NOT_FOUND|The specified default quick mode policy was not found.
13016|ERROR_IPSEC_TUNNEL_FILTER_EXISTS|The specified tunnel mode filter exists.
13017|ERROR_IPSEC_TUNNEL_FILTER_NOT_FOUND|The specified tunnel mode filter was not found.
13018|ERROR_IPSEC_MM_FILTER_PENDING_DELETION|The Main Mode filter is pending deletion.
13019|ERROR_IPSEC_TRANSPORT_FILTER_PENDING_DELETION|The transport filter is pending deletion.
13020|ERROR_IPSEC_TUNNEL_FILTER_PENDING_DELETION|The tunnel filter is pending deletion.
13021|ERROR_IPSEC_MM_POLICY_PENDING_DELETION|The Main Mode policy is pending deletion.
13022|ERROR_IPSEC_MM_AUTH_PENDING_DELETION|The Main Mode authentication bundle is pending deletion.
13023|ERROR_IPSEC_QM_POLICY_PENDING_DELETION|The Quick Mode policy is pending deletion.
13024|WARNING_IPSEC_MM_POLICY_PRUNED|The Main Mode policy was successfully added, but some of the requested offers are not supported.
13025|WARNING_IPSEC_QM_POLICY_PRUNED|The Quick Mode policy was successfully added, but some of the requested offers are not supported.
13800|ERROR_IPSEC_IKE_NEG_STATUS_BEGIN|ERROR_IPSEC_IKE_NEG_STATUS_BEGIN
13801|ERROR_IPSEC_IKE_AUTH_FAIL|IKE authentication credentials are unacceptable.
13802|ERROR_IPSEC_IKE_ATTRIB_FAIL|IKE security attributes are unacceptable.
13803|ERROR_IPSEC_IKE_NEGOTIATION_PENDING|IKE Negotiation in progress.
13804|ERROR_IPSEC_IKE_GENERAL_PROCESSING_ERROR|General processing error.
13805|ERROR_IPSEC_IKE_TIMED_OUT|Negotiation timed out.
13806|ERROR_IPSEC_IKE_NO_CERT|IKE failed to find valid machine certificate. Contact your Network Security Administrator about installing a valid certificate in the appropriate Certificate Store.
13807|ERROR_IPSEC_IKE_SA_DELETED|IKE SA deleted by peer before establishment completed.
13808|ERROR_IPSEC_IKE_SA_REAPED|IKE SA deleted before establishment completed.
13809|ERROR_IPSEC_IKE_MM_ACQUIRE_DROP|Negotiation request sat in Queue too long.
13810|ERROR_IPSEC_IKE_QM_ACQUIRE_DROP|Negotiation request sat in Queue too long.
13811|ERROR_IPSEC_IKE_QUEUE_DROP_MM|Negotiation request sat in Queue too long.
13812|ERROR_IPSEC_IKE_QUEUE_DROP_NO_MM|Negotiation request sat in Queue too long.
13813|ERROR_IPSEC_IKE_DROP_NO_RESPONSE|No response from peer.
13814|ERROR_IPSEC_IKE_MM_DELAY_DROP|Negotiation took too long.
13815|ERROR_IPSEC_IKE_QM_DELAY_DROP|Negotiation took too long.
13816|ERROR_IPSEC_IKE_ERROR|Unknown error occurred.
13817|ERROR_IPSEC_IKE_CRL_FAILED|Certificate Revocation Check failed.
13818|ERROR_IPSEC_IKE_INVALID_KEY_USAGE|Invalid certificate key usage.
13819|ERROR_IPSEC_IKE_INVALID_CERT_TYPE|Invalid certificate type.
13820|ERROR_IPSEC_IKE_NO_PRIVATE_KEY|IKE negotiation failed because the machine certificate used does not have a private key. IPsec certificates require a private key. Contact your Network Security administrator about replacing with a certificate that has a private key.
13821|ERROR_IPSEC_IKE_SIMULTANEOUS_REKEY|Simultaneous rekeys were detected.
13822|ERROR_IPSEC_IKE_DH_FAIL|Failure in Diffie-Hellman computation.
13823|ERROR_IPSEC_IKE_CRITICAL_PAYLOAD_NOT_RECOGNIZED|Don't know how to process critical payload.
13824|ERROR_IPSEC_IKE_INVALID_HEADER|Invalid header.
13825|ERROR_IPSEC_IKE_NO_POLICY|No policy configured.
13826|ERROR_IPSEC_IKE_INVALID_SIGNATURE|Failed to verify signature.
13827|ERROR_IPSEC_IKE_KERBEROS_ERROR|Failed to authenticate using Kerberos.
13828|ERROR_IPSEC_IKE_NO_PUBLIC_KEY|Peer's certificate did not have a public key.
13829|ERROR_IPSEC_IKE_PROCESS_ERR|Error processing error payload.
13830|ERROR_IPSEC_IKE_PROCESS_ERR_SA|Error processing SA payload.
13831|ERROR_IPSEC_IKE_PROCESS_ERR_PROP|Error processing Proposal payload.
13832|ERROR_IPSEC_IKE_PROCESS_ERR_TRANS|Error processing Transform payload.
13833|ERROR_IPSEC_IKE_PROCESS_ERR_KE|Error processing KE payload.
13834|ERROR_IPSEC_IKE_PROCESS_ERR_ID|Error processing ID payload.
13835|ERROR_IPSEC_IKE_PROCESS_ERR_CERT|Error processing Cert payload.
13836|ERROR_IPSEC_IKE_PROCESS_ERR_CERT_REQ|Error processing Certificate Request payload.
13837|ERROR_IPSEC_IKE_PROCESS_ERR_HASH|Error processing Hash payload.
13838|ERROR_IPSEC_IKE_PROCESS_ERR_SIG|Error processing Signature payload.
13839|ERROR_IPSEC_IKE_PROCESS_ERR_NONCE|Error processing Nonce payload.
13840|ERROR_IPSEC_IKE_PROCESS_ERR_NOTIFY|Error processing Notify payload.
13841|ERROR_IPSEC_IKE_PROCESS_ERR_DELETE|Error processing Delete Payload.
13842|ERROR_IPSEC_IKE_PROCESS_ERR_VENDOR|Error processing VendorId payload.
13843|ERROR_IPSEC_IKE_INVALID_PAYLOAD|Invalid payload received.
13844|ERROR_IPSEC_IKE_LOAD_SOFT_SA|Soft SA loaded.
13845|ERROR_IPSEC_IKE_SOFT_SA_TORN_DOWN|Soft SA torn down.
13846|ERROR_IPSEC_IKE_INVALID_COOKIE|Invalid cookie received.
13847|ERROR_IPSEC_IKE_NO_PEER_CERT|Peer failed to send valid machine certificate.
13848|ERROR_IPSEC_IKE_PEER_CRL_FAILED|Certification Revocation check of peer's certificate failed.
13849|ERROR_IPSEC_IKE_POLICY_CHANGE|New policy invalidated SAs formed with old policy.
13850|ERROR_IPSEC_IKE_NO_MM_POLICY|There is no available Main Mode IKE policy.
13851|ERROR_IPSEC_IKE_NOTCBPRIV|Failed to enabled TCB privilege.
13852|ERROR_IPSEC_IKE_SECLOADFAIL|Failed to load SECURITY.DLL.
13853|ERROR_IPSEC_IKE_FAILSSPINIT|Failed to obtain security function table dispatch address from SSPI.
13854|ERROR_IPSEC_IKE_FAILQUERYSSP|Failed to query Kerberos package to obtain max token size.
13855|ERROR_IPSEC_IKE_SRVACQFAIL|Failed to obtain Kerberos server credentials for ISAKMP/ERROR_IPSEC_IKE service. Kerberos authentication will not function. The most likely reason for this is lack of domain membership. This is normal if your computer is a member of a workgroup.
13856|ERROR_IPSEC_IKE_SRVQUERYCRED|Failed to determine SSPI principal name for ISAKMP/ERROR_IPSEC_IKE service (`nQueryCredentialsAttributes).
13857|ERROR_IPSEC_IKE_GETSPIFAIL|Failed to obtain new SPI for the inbound SA from IPsec driver. The most common cause for this is that the driver does not have the correct filter. Check your policy to verify the filters.
13858|ERROR_IPSEC_IKE_INVALID_FILTER|Given filter is invalid.
13859|ERROR_IPSEC_IKE_OUT_OF_MEMORY|Memory allocation failed.
13860|ERROR_IPSEC_IKE_ADD_UPDATE_KEY_FAILED|Failed to add Security Association to IPsec Driver. The most common cause for this is if the IKE negotiation took too long to complete. If the problem persists, reduce the load on the faulting machine.
13861|ERROR_IPSEC_IKE_INVALID_POLICY|Invalid policy.
13862|ERROR_IPSEC_IKE_UNKNOWN_DOI|Invalid DOI.
13863|ERROR_IPSEC_IKE_INVALID_SITUATION|Invalid situation.
13864|ERROR_IPSEC_IKE_DH_FAILURE|Diffie-Hellman failure.
13865|ERROR_IPSEC_IKE_INVALID_GROUP|Invalid Diffie-Hellman group.
13866|ERROR_IPSEC_IKE_ENCRYPT|Error encrypting payload.
13867|ERROR_IPSEC_IKE_DECRYPT|Error decrypting payload.
13868|ERROR_IPSEC_IKE_POLICY_MATCH|Policy match error.
13869|ERROR_IPSEC_IKE_UNSUPPORTED_ID|Unsupported ID.
13870|ERROR_IPSEC_IKE_INVALID_HASH|Hash verification failed.
13871|ERROR_IPSEC_IKE_INVALID_HASH_ALG|Invalid hash algorithm.
13872|ERROR_IPSEC_IKE_INVALID_HASH_SIZE|Invalid hash size.
13873|ERROR_IPSEC_IKE_INVALID_ENCRYPT_ALG|Invalid encryption algorithm.
13874|ERROR_IPSEC_IKE_INVALID_AUTH_ALG|Invalid authentication algorithm.
13875|ERROR_IPSEC_IKE_INVALID_SIG|Invalid certificate signature.
13876|ERROR_IPSEC_IKE_LOAD_FAILED|Load failed.
13877|ERROR_IPSEC_IKE_RPC_DELETE|Deleted via RPC call.
13878|ERROR_IPSEC_IKE_BENIGN_REINIT|Temporary state created to perform reinitialization. This is not a real failure.
13879|ERROR_IPSEC_IKE_INVALID_RESPONDER_LIFETIME_NOTIFY|The lifetime value received in the Responder Lifetime Notify is below the Windows 2000 configured minimum value. Please fix the policy on the peer machine.
13880|ERROR_IPSEC_IKE_INVALID_MAJOR_VERSION|The recipient cannot handle version of IKE specified in the header.
13881|ERROR_IPSEC_IKE_INVALID_CERT_KEYLEN|Key length in certificate is too small for configured security requirements.
13882|ERROR_IPSEC_IKE_MM_LIMIT|Max number of established MM SAs to peer exceeded.
13883|ERROR_IPSEC_IKE_NEGOTIATION_DISABLED|IKE received a policy that disables negotiation.
13884|ERROR_IPSEC_IKE_QM_LIMIT|Reached maximum quick mode limit for the main mode. New main mode will be started.
13885|ERROR_IPSEC_IKE_MM_EXPIRED|Main mode SA lifetime expired or peer sent a main mode delete.
13886|ERROR_IPSEC_IKE_PEER_MM_ASSUMED_INVALID|Main mode SA assumed to be invalid because peer stopped responding.
13887|ERROR_IPSEC_IKE_CERT_CHAIN_POLICY_MISMATCH|Certificate doesn't chain to a trusted root in IPsec policy.
13888|ERROR_IPSEC_IKE_UNEXPECTED_MESSAGE_ID|Received unexpected message ID.
13889|ERROR_IPSEC_IKE_INVALID_AUTH_PAYLOAD|Received invalid authentication offers.
13890|ERROR_IPSEC_IKE_DOS_COOKIE_SENT|Sent DoS cookie notify to initiator.
13891|ERROR_IPSEC_IKE_SHUTTING_DOWN|IKE service is shutting down.
13892|ERROR_IPSEC_IKE_CGA_AUTH_FAILED|Could not verify binding between CGA address and certificate.
13893|ERROR_IPSEC_IKE_PROCESS_ERR_NATOA|Error processing NatOA payload.
13894|ERROR_IPSEC_IKE_INVALID_MM_FOR_QM|Parameters of the main mode are invalid for this quick mode.
13895|ERROR_IPSEC_IKE_QM_EXPIRED|Quick mode SA was expired by IPsec driver.
13896|ERROR_IPSEC_IKE_TOO_MANY_FILTERS|Too many dynamically added IKEEXT filters were detected.
13897|ERROR_IPSEC_IKE_NEG_STATUS_END|ERROR_IPSEC_IKE_NEG_STATUS_END
13898|ERROR_IPSEC_IKE_KILL_DUMMY_NAP_TUNNEL|NAP reauth succeeded and must delete the dummy NAP IKEv2 tunnel.
13899|ERROR_IPSEC_IKE_INNER_IP_ASSIGNMENT_FAILURE|Error in assigning inner IP address to initiator in tunnel mode.
13900|ERROR_IPSEC_IKE_REQUIRE_CP_PAYLOAD_MISSING|Require configuration payload missing.
13901|ERROR_IPSEC_KEY_MODULE_IMPERSONATION_NEGOTIATION_PENDING|A negotiation running as the security principle who issued the connection is in progress.
13902|ERROR_IPSEC_IKE_COEXISTENCE_SUPPRESS|SA was deleted due to IKEv1/AuthIP co-existence suppress check.
13903|ERROR_IPSEC_IKE_RATELIMIT_DROP|Incoming SA request was dropped due to peer IP address rate limiting.
13904|ERROR_IPSEC_IKE_PEER_DOESNT_SUPPORT_MOBIKE|Peer does not support MOBIKE.
13905|ERROR_IPSEC_IKE_AUTHORIZATION_FAILURE|SA establishment is not authorized.
13906|ERROR_IPSEC_IKE_STRONG_CRED_AUTHORIZATION_FAILURE|SA establishment is not authorized because there is not a sufficiently strong PKINIT-based credential.
13907|ERROR_IPSEC_IKE_AUTHORIZATION_FAILURE_WITH_OPTIONAL_RETRY|SA establishment is not authorized. You may need to enter updated or different credentials such as a smartcard.
13908|ERROR_IPSEC_IKE_STRONG_CRED_AUTHORIZATION_AND_CERTMAP_FAILURE|SA establishment is not authorized because there is not a sufficiently strong PKINIT-based credential. This might be related to certificate-to-account mapping failure for the SA.
13909|ERROR_IPSEC_IKE_NEG_STATUS_EXTENDED_END|ERROR_IPSEC_IKE_NEG_STATUS_EXTENDED_END
13910|ERROR_IPSEC_BAD_SPI|The SPI in the packet does not match a valid IPsec SA.
13911|ERROR_IPSEC_SA_LIFETIME_EXPIRED|Packet was received on an IPsec SA whose lifetime has expired.
13912|ERROR_IPSEC_WRONG_SA|Packet was received on an IPsec SA that does not match the packet characteristics.
13913|ERROR_IPSEC_REPLAY_CHECK_FAILED|Packet sequence number replay check failed.
13914|ERROR_IPSEC_INVALID_PACKET|IPsec header and/or trailer in the packet is invalid.
13915|ERROR_IPSEC_INTEGRITY_CHECK_FAILED|IPsec integrity check failed.
13916|ERROR_IPSEC_CLEAR_TEXT_DROP|IPsec dropped a clear text packet.
13917|ERROR_IPSEC_AUTH_FIREWALL_DROP|IPsec dropped an incoming ESP packet in authenticated firewall mode. This drop is benign.
13918|ERROR_IPSEC_THROTTLE_DROP|IPsec dropped a packet due to DoS throttling.
13925|ERROR_IPSEC_DOSP_BLOCK|IPsec DoS Protection matched an explicit block rule.
13926|ERROR_IPSEC_DOSP_RECEIVED_MULTICAST|IPsec DoS Protection received an IPsec specific multicast packet which is not allowed.
13927|ERROR_IPSEC_DOSP_INVALID_PACKET|IPsec DoS Protection received an incorrectly formatted packet.
13928|ERROR_IPSEC_DOSP_STATE_LOOKUP_FAILED|IPsec DoS Protection failed to look up state.
13929|ERROR_IPSEC_DOSP_MAX_ENTRIES|IPsec DoS Protection failed to create state because the maximum number of entries allowed by policy has been reached.
13930|ERROR_IPSEC_DOSP_KEYMOD_NOT_ALLOWED|IPsec DoS Protection received an IPsec negotiation packet for a keying module which is not allowed by policy.
13931|ERROR_IPSEC_DOSP_NOT_INSTALLED|IPsec DoS Protection has not been enabled.
13932|ERROR_IPSEC_DOSP_MAX_PER_IP_RATELIMIT_QUEUES|IPsec DoS Protection failed to create a per internal IP rate limit queue because the maximum number of queues allowed by policy has been reached.
14000|ERROR_SXS_SECTION_NOT_FOUND|The requested section was not present in the activation context.
14001|ERROR_SXS_CANT_GEN_ACTCTX|The application has failed to start because its side-by-side configuration is incorrect. Please see the application event log or use the command-line sxstrace.exe tool for more detail.
14002|ERROR_SXS_INVALID_ACTCTXDATA_FORMAT|The application binding data format is invalid.
14003|ERROR_SXS_ASSEMBLY_NOT_FOUND|The referenced assembly is not installed on your system.
14004|ERROR_SXS_MANIFEST_FORMAT_ERROR|The manifest file does not begin with the required tag and format information.
14005|ERROR_SXS_MANIFEST_PARSE_ERROR|The manifest file contains one or more syntax errors.
14006|ERROR_SXS_ACTIVATION_CONTEXT_DISABLED|The application attempted to activate a disabled activation context.
14007|ERROR_SXS_KEY_NOT_FOUND|The requested lookup key was not found in any active activation context.
14008|ERROR_SXS_VERSION_CONFLICT|A component version required by the application conflicts with another component version already active.
14009|ERROR_SXS_WRONG_SECTION_TYPE|The type requested activation context section does not match the query API used.
14010|ERROR_SXS_THREAD_QUERIES_DISABLED|Lack of system resources has required isolated activation to be disabled for the current thread of execution.
14011|ERROR_SXS_PROCESS_DEFAULT_ALREADY_SET|An attempt to set the process default activation context failed because the process default activation context was already set.
14012|ERROR_SXS_UNKNOWN_ENCODING_GROUP|The encoding group identifier specified is not recognized.
14013|ERROR_SXS_UNKNOWN_ENCODING|The encoding requested is not recognized.
14014|ERROR_SXS_INVALID_XML_NAMESPACE_URI|The manifest contains a reference to an invalid URI.
14015|ERROR_SXS_ROOT_MANIFEST_DEPENDENCY_NOT_INSTALLED|The application manifest contains a reference to a dependent assembly which is not installed.
14016|ERROR_SXS_LEAF_MANIFEST_DEPENDENCY_NOT_INSTALLED|The manifest for an assembly used by the application has a reference to a dependent assembly which is not installed.
14017|ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE|The manifest contains an attribute for the assembly identity which is not valid.
14018|ERROR_SXS_MANIFEST_MISSING_REQUIRED_DEFAULT_NAMESPACE|The manifest is missing the required default namespace specification on the assembly element.
14019|ERROR_SXS_MANIFEST_INVALID_REQUIRED_DEFAULT_NAMESPACE|The manifest has a default namespace specified on the assembly element but its value is not &quot;urn:schemas-microsoft-com:asm.v1&quot;.
14020|ERROR_SXS_PRIVATE_MANIFEST_CROSS_PATH_WITH_REPARSE_POINT|The private manifest probed has crossed a path with an unsupported reparse point.
14021|ERROR_SXS_DUPLICATE_DLL_NAME|Two or more components referenced directly or indirectly by the application manifest have files by the same name.
14022|ERROR_SXS_DUPLICATE_WINDOWCLASS_NAME|Two or more components referenced directly or indirectly by the application manifest have window classes with the same name.
14023|ERROR_SXS_DUPLICATE_CLSID|Two or more components referenced directly or indirectly by the application manifest have the same COM server CLSIDs.
14024|ERROR_SXS_DUPLICATE_IID|Two or more components referenced directly or indirectly by the application manifest have proxies for the same COM interface IIDs.
14025|ERROR_SXS_DUPLICATE_TLBID|Two or more components referenced directly or indirectly by the application manifest have the same COM type library TLBIDs.
14026|ERROR_SXS_DUPLICATE_PROGID|Two or more components referenced directly or indirectly by the application manifest have the same COM ProgIDs.
14027|ERROR_SXS_DUPLICATE_ASSEMBLY_NAME|Two or more components referenced directly or indirectly by the application manifest are different versions of the same component which is not permitted.
14028|ERROR_SXS_FILE_HASH_MISMATCH|A component's file does not match the verification information present in the component manifest.
14029|ERROR_SXS_POLICY_PARSE_ERROR|The policy manifest contains one or more syntax errors.
14030|ERROR_SXS_XML_E_MISSINGQUOTE|Manifest Parse Error : A string literal was expected, but no opening quote character was found.
14031|ERROR_SXS_XML_E_COMMENTSYNTAX|Manifest Parse Error : Incorrect syntax was used in a comment.
14032|ERROR_SXS_XML_E_BADSTARTNAMECHAR|Manifest Parse Error : A name was started with an invalid character.
14033|ERROR_SXS_XML_E_BADNAMECHAR|Manifest Parse Error : A name contained an invalid character.
14034|ERROR_SXS_XML_E_BADCHARINSTRING|Manifest Parse Error : A string literal contained an invalid character.
14035|ERROR_SXS_XML_E_XMLDECLSYNTAX|Manifest Parse Error : Invalid syntax for an xml declaration.
14036|ERROR_SXS_XML_E_BADCHARDATA|Manifest Parse Error : An Invalid character was found in text content.
14037|ERROR_SXS_XML_E_MISSINGWHITESPACE|Manifest Parse Error : Required white space was missing.
14038|ERROR_SXS_XML_E_EXPECTINGTAGEND|Manifest Parse Error : The character '&gt;' was expected.
14039|ERROR_SXS_XML_E_MISSINGSEMICOLON|Manifest Parse Error : A semi colon character was expected.
14040|ERROR_SXS_XML_E_UNBALANCEDPAREN|Manifest Parse Error : Unbalanced parentheses.
14041|ERROR_SXS_XML_E_INTERNALERROR|Manifest Parse Error : Internal error.
14042|ERROR_SXS_XML_E_UNEXPECTED_WHITESPACE|Manifest Parse Error : Whitespace is not allowed at this location.
14043|ERROR_SXS_XML_E_INCOMPLETE_ENCODING|Manifest Parse Error : End of file reached in invalid state for current encoding.
14044|ERROR_SXS_XML_E_MISSING_PAREN|Manifest Parse Error : Missing parenthesis.
14045|ERROR_SXS_XML_E_EXPECTINGCLOSEQUOTE|Manifest Parse Error : A single or double closing quote character (\' or \&quot;) is missing.
14046|ERROR_SXS_XML_E_MULTIPLE_COLONS|Manifest Parse Error : Multiple colons are not allowed in a name.
14047|ERROR_SXS_XML_E_INVALID_DECIMAL|Manifest Parse Error : Invalid character for decimal digit.
14048|ERROR_SXS_XML_E_INVALID_HEXIDECIMAL|Manifest Parse Error : Invalid character for hexadecimal digit.
14049|ERROR_SXS_XML_E_INVALID_UNICODE|Manifest Parse Error : Invalid unicode character value for this platform.
14050|ERROR_SXS_XML_E_WHITESPACEORQUESTIONMARK|Manifest Parse Error : Expecting whitespace or '?'.
14051|ERROR_SXS_XML_E_UNEXPECTEDENDTAG|Manifest Parse Error : End tag was not expected at this location.
14052|ERROR_SXS_XML_E_UNCLOSEDTAG|Manifest Parse Error : The following tags were not closed: `%1.
14053|ERROR_SXS_XML_E_DUPLICATEATTRIBUTE|Manifest Parse Error : Duplicate attribute.
14054|ERROR_SXS_XML_E_MULTIPLEROOTS|Manifest Parse Error : Only one top level element is allowed in an XML document.
14055|ERROR_SXS_XML_E_INVALIDATROOTLEVEL|Manifest Parse Error : Invalid at the top level of the document.
14056|ERROR_SXS_XML_E_BADXMLDECL|Manifest Parse Error : Invalid xml declaration.
14057|ERROR_SXS_XML_E_MISSINGROOT|Manifest Parse Error : XML document must have a top level element.
14058|ERROR_SXS_XML_E_UNEXPECTEDEOF|Manifest Parse Error : Unexpected end of file.
14059|ERROR_SXS_XML_E_BADPEREFINSUBSET|Manifest Parse Error : Parameter entities cannot be used inside markup declarations in an internal subset.
14060|ERROR_SXS_XML_E_UNCLOSEDSTARTTAG|Manifest Parse Error : Element was not closed.
14061|ERROR_SXS_XML_E_UNCLOSEDENDTAG|Manifest Parse Error : End element was missing the character '&gt;'.
14062|ERROR_SXS_XML_E_UNCLOSEDSTRING|Manifest Parse Error : A string literal was not closed.
14063|ERROR_SXS_XML_E_UNCLOSEDCOMMENT|Manifest Parse Error : A comment was not closed.
14064|ERROR_SXS_XML_E_UNCLOSEDDECL|Manifest Parse Error : A declaration was not closed.
14065|ERROR_SXS_XML_E_UNCLOSEDCDATA|Manifest Parse Error : A CDATA section was not closed.
14066|ERROR_SXS_XML_E_RESERVEDNAMESPACE|Manifest Parse Error : The namespace prefix is not allowed to start with the reserved string &quot;xml&quot;.
14067|ERROR_SXS_XML_E_INVALIDENCODING|Manifest Parse Error : System does not support the specified encoding.
14068|ERROR_SXS_XML_E_INVALIDSWITCH|Manifest Parse Error : Switch from current encoding to specified encoding not supported.
14069|ERROR_SXS_XML_E_BADXMLCASE|Manifest Parse Error : The name 'xml' is reserved and must be lower case.
14070|ERROR_SXS_XML_E_INVALID_STANDALONE|Manifest Parse Error : The standalone attribute must have the value 'yes' or 'no'.
14071|ERROR_SXS_XML_E_UNEXPECTED_STANDALONE|Manifest Parse Error : The standalone attribute cannot be used in external entities.
14072|ERROR_SXS_XML_E_INVALID_VERSION|Manifest Parse Error : Invalid version number.
14073|ERROR_SXS_XML_E_MISSINGEQUALS|Manifest Parse Error : Missing equals sign between attribute and attribute value.
14074|ERROR_SXS_PROTECTION_RECOVERY_FAILED|Assembly Protection Error : Unable to recover the specified assembly.
14075|ERROR_SXS_PROTECTION_PUBLIC_KEY_TOO_SHORT|Assembly Protection Error : The public key for an assembly was too short to be allowed.
14076|ERROR_SXS_PROTECTION_CATALOG_NOT_VALID|Assembly Protection Error : The catalog for an assembly is not valid, or does not match the assembly's manifest.
14077|ERROR_SXS_UNTRANSLATABLE_HRESULT|An HRESULT could not be translated to a corresponding Win32 error code.
14078|ERROR_SXS_PROTECTION_CATALOG_FILE_MISSING|Assembly Protection Error : The catalog for an assembly is missing.
14079|ERROR_SXS_MISSING_ASSEMBLY_IDENTITY_ATTRIBUTE|The supplied assembly identity is missing one or more attributes which must be present in this context.
14080|ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE_NAME|The supplied assembly identity has one or more attribute names that contain characters not permitted in XML names.
14081|ERROR_SXS_ASSEMBLY_MISSING|The referenced assembly could not be found.
14082|ERROR_SXS_CORRUPT_ACTIVATION_STACK|The activation context activation stack for the running thread of execution is corrupt.
14083|ERROR_SXS_CORRUPTION|The application isolation metadata for this process or thread has become corrupt.
14084|ERROR_SXS_EARLY_DEACTIVATION|The activation context being deactivated is not the most recently activated one.
14085|ERROR_SXS_INVALID_DEACTIVATION|The activation context being deactivated is not active for the current thread of execution.
14086|ERROR_SXS_MULTIPLE_DEACTIVATION|The activation context being deactivated has already been deactivated.
14087|ERROR_SXS_PROCESS_TERMINATION_REQUESTED|A component used by the isolation facility has requested to terminate the process.
14088|ERROR_SXS_RELEASE_ACTIVATION_CONTEXT|A kernel mode component is releasing a reference on an activation context.
14089|ERROR_SXS_SYSTEM_DEFAULT_ACTIVATION_CONTEXT_EMPTY|The activation context of system default assembly could not be generated.
14090|ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_VALUE|The value of an attribute in an identity is not within the legal range.
14091|ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_NAME|The name of an attribute in an identity is not within the legal range.
14092|ERROR_SXS_IDENTITY_DUPLICATE_ATTRIBUTE|An identity contains two definitions for the same attribute.
14093|ERROR_SXS_IDENTITY_PARSE_ERROR|The identity string is malformed. This may be due to a trailing comma, more than two unnamed attributes, missing attribute name or missing attribute value.
14094|ERROR_MALFORMED_SUBSTITUTION_STRING|A string containing localized substitutable content was malformed. Either a dollar sign ($) was followed by something other than a left parenthesis or another dollar sign or an substitution's right parenthesis was not found.
14095|ERROR_SXS_INCORRECT_PUBLIC_KEY_TOKEN|The public key token does not correspond to the public key specified.
14096|ERROR_UNMAPPED_SUBSTITUTION_STRING|A substitution string had no mapping.
14097|ERROR_SXS_ASSEMBLY_NOT_LOCKED|The component must be locked before making the request.
14098|ERROR_SXS_COMPONENT_STORE_CORRUPT|The component store has been corrupted.
14099|ERROR_ADVANCED_INSTALLER_FAILED|An advanced installer failed during setup or servicing.
14100|ERROR_XML_ENCODING_MISMATCH|The character encoding in the XML declaration did not match the encoding used in the document.
14101|ERROR_SXS_MANIFEST_IDENTITY_SAME_BUT_CONTENTS_DIFFERENT|The identities of the manifests are identical but their contents are different.
14102|ERROR_SXS_IDENTITIES_DIFFERENT|The component identities are different.
14103|ERROR_SXS_ASSEMBLY_IS_NOT_A_DEPLOYMENT|The assembly is not a deployment.
14104|ERROR_SXS_FILE_NOT_PART_OF_ASSEMBLY|The file is not a part of the assembly.
14105|ERROR_SXS_MANIFEST_TOO_BIG|The size of the manifest exceeds the maximum allowed.
14106|ERROR_SXS_SETTING_NOT_REGISTERED|The setting is not registered.
14107|ERROR_SXS_TRANSACTION_CLOSURE_INCOMPLETE|One or more required members of the transaction are not present.
14108|ERROR_SMI_PRIMITIVE_INSTALLER_FAILED|The SMI primitive installer failed during setup or servicing.
14109|ERROR_GENERIC_COMMAND_FAILED|A generic command executable returned a result that indicates failure.
14110|ERROR_SXS_FILE_HASH_MISSING|A component is missing file verification information in its manifest.
15000|ERROR_EVT_INVALID_CHANNEL_PATH|The specified channel path is invalid.
15001|ERROR_EVT_INVALID_QUERY|The specified query is invalid.
15002|ERROR_EVT_PUBLISHER_METADATA_NOT_FOUND|The publisher metadata cannot be found in the resource.
15003|ERROR_EVT_EVENT_TEMPLATE_NOT_FOUND|The template for an event definition cannot be found in the resource (error = `%1).
15004|ERROR_EVT_INVALID_PUBLISHER_NAME|The specified publisher name is invalid.
15005|ERROR_EVT_INVALID_EVENT_DATA|The event data raised by the publisher is not compatible with the event template definition in the publisher's manifest.
15007|ERROR_EVT_CHANNEL_NOT_FOUND|The specified channel could not be found. Check channel configuration.
15008|ERROR_EVT_MALFORMED_XML_TEXT|The specified xml text was not well-formed. See Extended Error for more details.
15009|ERROR_EVT_SUBSCRIPTION_TO_DIRECT_CHANNEL|The caller is trying to subscribe to a direct channel which is not allowed. The events for a direct channel go directly to a logfile and cannot be subscribed to.
15010|ERROR_EVT_CONFIGURATION_ERROR|Configuration error.
15011|ERROR_EVT_QUERY_RESULT_STALE|The query result is stale / invalid. This may be due to the log being cleared or rolling over after the query result was created. Users should handle this code by releasing the query result object and reissuing the query.
15012|ERROR_EVT_QUERY_RESULT_INVALID_POSITION|Query result is currently at an invalid position.
15013|ERROR_EVT_NON_VALIDATING_MSXML|Registered MSXML doesn't support validation.
15014|ERROR_EVT_FILTER_ALREADYSCOPED|An expression can only be followed by a change of scope operation if it itself evaluates to a node set and is not already part of some other change of scope operation.
15015|ERROR_EVT_FILTER_NOTELTSET|Can't perform a step operation from a term that does not represent an element set.
15016|ERROR_EVT_FILTER_INVARG|Left hand side arguments to binary operators must be either attributes, nodes or variables and right hand side arguments must be constants.
15017|ERROR_EVT_FILTER_INVTEST|A step operation must involve either a node test or, in the case of a predicate, an algebraic expression against which to test each node in the node set identified by the preceeding node set can be evaluated.
15018|ERROR_EVT_FILTER_INVTYPE|This data type is currently unsupported.
15019|ERROR_EVT_FILTER_PARSEERR|A syntax error occurred at position `%1!d!.
15020|ERROR_EVT_FILTER_UNSUPPORTEDOP|This operator is unsupported by this implementation of the filter.
15021|ERROR_EVT_FILTER_UNEXPECTEDTOKEN|The token encountered was unexpected.
15022|ERROR_EVT_INVALID_OPERATION_OVER_ENABLED_DIRECT_CHANNEL|The requested operation cannot be performed over an enabled direct channel. The channel must first be disabled before performing the requested operation.
15023|ERROR_EVT_INVALID_CHANNEL_PROPERTY_VALUE|Channel property `%1!s! contains invalid value. The value has invalid type, is outside of valid range, can't be updated or is not supported by this type of channel.
15024|ERROR_EVT_INVALID_PUBLISHER_PROPERTY_VALUE|Publisher property `%1!s! contains invalid value. The value has invalid type, is outside of valid range, can't be updated or is not supported by this type of publisher.
15025|ERROR_EVT_CHANNEL_CANNOT_ACTIVATE|The channel fails to activate.
15026|ERROR_EVT_FILTER_TOO_COMPLEX|The xpath expression exceeded supported complexity. Please symplify it or split it into two or more simple expressions.
15027|ERROR_EVT_MESSAGE_NOT_FOUND|the message resource is present but the message is not found in the string/message table.
15028|ERROR_EVT_MESSAGE_ID_NOT_FOUND|The message id for the desired message could not be found.
15029|ERROR_EVT_UNRESOLVED_VALUE_INSERT|The substitution string for insert index (`%1) could not be found.
15030|ERROR_EVT_UNRESOLVED_PARAMETER_INSERT|The description string for parameter reference (`%1) could not be found.
15031|ERROR_EVT_MAX_INSERTS_REACHED|The maximum number of replacements has been reached.
15032|ERROR_EVT_EVENT_DEFINITION_NOT_FOUND|The event definition could not be found for event id (`%1).
15033|ERROR_EVT_MESSAGE_LOCALE_NOT_FOUND|The locale specific resource for the desired message is not present.
15034|ERROR_EVT_VERSION_TOO_OLD|The resource is too old to be compatible.
15035|ERROR_EVT_VERSION_TOO_NEW|The resource is too new to be compatible.
15036|ERROR_EVT_CANNOT_OPEN_CHANNEL_OF_QUERY|The channel at index `%1!d! of the query can't be opened.
15037|ERROR_EVT_PUBLISHER_DISABLED|The publisher has been disabled and its resource is not available. This usually occurs when the publisher is in the process of being uninstalled or upgraded.
15038|ERROR_EVT_FILTER_OUT_OF_RANGE|Attempted to create a numeric type that is outside of its valid range.
15080|ERROR_EC_SUBSCRIPTION_CANNOT_ACTIVATE|The subscription fails to activate.
15081|ERROR_EC_LOG_DISABLED|The log of the subscription is in disabled state, and can not be used to forward events to. The log must first be enabled before the subscription can be activated.
15082|ERROR_EC_CIRCULAR_FORWARDING|When forwarding events from local machine to itself, the query of the subscription can't contain target log of the subscription.
15083|ERROR_EC_CREDSTORE_FULL|The credential store that is used to save credentials is full.
15084|ERROR_EC_CRED_NOT_FOUND|The credential used by this subscription can't be found in credential store.
15085|ERROR_EC_NO_ACTIVE_CHANNEL|No active channel is found for the query.
15100|ERROR_MUI_FILE_NOT_FOUND|The resource loader failed to find MUI file.
15101|ERROR_MUI_INVALID_FILE|The resource loader failed to load MUI file because the file fail to pass validation.
15102|ERROR_MUI_INVALID_RC_CONFIG|The RC Manifest is corrupted with garbage data or unsupported version or missing required item.
15103|ERROR_MUI_INVALID_LOCALE_NAME|The RC Manifest has invalid culture name.
15104|ERROR_MUI_INVALID_ULTIMATEFALLBACK_NAME|The RC Manifest has invalid ultimatefallback name.
15105|ERROR_MUI_FILE_NOT_LOADED|The resource loader cache doesn't have loaded MUI entry.
15106|ERROR_RESOURCE_ENUM_USER_STOP|User stopped resource enumeration.
15107|ERROR_MUI_INTLSETTINGS_UILANG_NOT_INSTALLED|UI language installation failed.
15108|ERROR_MUI_INTLSETTINGS_INVALID_LOCALE_NAME|Locale installation failed.
15110|ERROR_MRM_RUNTIME_NO_DEFAULT_OR_NEUTRAL_RESOURCE|A resource does not have default or neutral value.
15111|ERROR_MRM_INVALID_PRICONFIG|Invalid PRI config file.
15112|ERROR_MRM_INVALID_FILE_TYPE|Invalid file type.
15113|ERROR_MRM_UNKNOWN_QUALIFIER|Unknown qualifier.
15114|ERROR_MRM_INVALID_QUALIFIER_VALUE|Invalid qualifier value.
15115|ERROR_MRM_NO_CANDIDATE|No Candidate found.
15116|ERROR_MRM_NO_MATCH_OR_DEFAULT_CANDIDATE|The ResourceMap or NamedResource has an item that does not have default or neutral resource..
15117|ERROR_MRM_RESOURCE_TYPE_MISMATCH|Invalid ResourceCandidate type.
15118|ERROR_MRM_DUPLICATE_MAP_NAME|Duplicate Resource Map.
15119|ERROR_MRM_DUPLICATE_ENTRY|Duplicate Entry.
15120|ERROR_MRM_INVALID_RESOURCE_IDENTIFIER|Invalid Resource Identifier.
15121|ERROR_MRM_FILEPATH_TOO_LONG|Filepath too long.
15122|ERROR_MRM_UNSUPPORTED_DIRECTORY_TYPE|Unsupported directory type.
15126|ERROR_MRM_INVALID_PRI_FILE|Invalid PRI File.
15127|ERROR_MRM_NAMED_RESOURCE_NOT_FOUND|NamedResource Not Found.
15135|ERROR_MRM_MAP_NOT_FOUND|ResourceMap Not Found.
15136|ERROR_MRM_UNSUPPORTED_PROFILE_TYPE|Unsupported MRT profile type.
15137|ERROR_MRM_INVALID_QUALIFIER_OPERATOR|Invalid qualifier operator.
15138|ERROR_MRM_INDETERMINATE_QUALIFIER_VALUE|Unable to determine qualifier value or qualifier value has not been set.
15139|ERROR_MRM_AUTOMERGE_ENABLED|Automerge is enabled in the PRI file.
15140|ERROR_MRM_TOO_MANY_RESOURCES|Too many resources defined for package.
15200|ERROR_MCA_INVALID_CAPABILITIES_STRING|The monitor returned a DDC/CI capabilities string that did not comply with the ACCESS.bus 3.0, DDC/CI 1.1 or MCCS 2 Revision 1 specification.
15201|ERROR_MCA_INVALID_VCP_VERSION|The monitor's VCP Version (0xDF) VCP code returned an invalid version value.
15202|ERROR_MCA_MONITOR_VIOLATES_MCCS_SPECIFICATION|The monitor does not comply with the MCCS specification it claims to support.
15203|ERROR_MCA_MCCS_VERSION_MISMATCH|The MCCS version in a monitor's mccs_ver capability does not match the MCCS version the monitor reports when the VCP Version (0xDF) VCP code returned an invalid version value.
15204|ERROR_MCA_UNSUPPORTED_MCCS_VERSION|The Monitor Configuration API only works with monitors that support the MCCS 1.0 specification, MCCS 2.0 specification or the MCCS 2.0 Revision 1 specification.
15205|ERROR_MCA_INTERNAL_ERROR|An internal Monitor Configuration API error occurred.
15206|ERROR_MCA_INVALID_TECHNOLOGY_TYPE_RETURNED|The monitor returned an invalid monitor technology type. CRT, Plasma and LCD (TFT) are examples of monitor technology types. This error implies that the monitor violated the MCCS 2.0 or MCCS 2.0 Revision 1 specification.
15207|ERROR_MCA_UNSUPPORTED_COLOR_TEMPERATURE|The caller of SetMonitorColorTemperature specified a color temperature that the current monitor did not support. This error implies that the monitor violated the MCCS 2.0 or MCCS 2.0 Revision 1 specification.
15250|ERROR_AMBIGUOUS_SYSTEM_DEVICE|The requested system device cannot be identified due to multiple indistinguishable devices potentially matching the identification criteria.
15299|ERROR_SYSTEM_DEVICE_NOT_FOUND|The requested system device cannot be found.
15300|ERROR_HASH_NOT_SUPPORTED|Hash generation for the specified hash version and hash type is not enabled on the server.
15301|ERROR_HASH_NOT_PRESENT|The hash requested from the server is not available or no longer valid.
15321|ERROR_SECONDARY_IC_PROVIDER_NOT_REGISTERED|The secondary interrupt controller instance that manages the specified interrupt is not registered.
15322|ERROR_GPIO_CLIENT_INFORMATION_INVALID|The information supplied by the GPIO client driver is invalid.
15323|ERROR_GPIO_VERSION_NOT_SUPPORTED|The version specified by the GPIO client driver is not supported.
15324|ERROR_GPIO_INVALID_REGISTRATION_PACKET|The registration packet supplied by the GPIO client driver is not valid.
15325|ERROR_GPIO_OPERATION_DENIED|The requested operation is not suppported for the specified handle.
15326|ERROR_GPIO_INCOMPATIBLE_CONNECT_MODE|The requested connect mode conflicts with an existing mode on one or more of the specified pins.
15327|ERROR_GPIO_INTERRUPT_ALREADY_UNMASKED|The interrupt requested to be unmasked is not masked.
15400|ERROR_CANNOT_SWITCH_RUNLEVEL|The requested run level switch cannot be completed successfully.
15401|ERROR_INVALID_RUNLEVEL_SETTING|The service has an invalid run level setting. The run level for a service must not be higher than the run level of its dependent services.
15402|ERROR_RUNLEVEL_SWITCH_TIMEOUT|The requested run level switch cannot be completed successfully since one or more services will not stop or restart within the specified timeout.
15403|ERROR_RUNLEVEL_SWITCH_AGENT_TIMEOUT|A run level switch agent did not respond within the specified timeout.
15404|ERROR_RUNLEVEL_SWITCH_IN_PROGRESS|A run level switch is currently in progress.
15405|ERROR_SERVICES_FAILED_AUTOSTART|One or more services failed to start during the service startup phase of a run level switch.
15501|ERROR_COM_TASK_STOP_PENDING|The task stop request cannot be completed immediately since task needs more time to shutdown.
15600|ERROR_INSTALL_OPEN_PACKAGE_FAILED|Package could not be opened.
15601|ERROR_INSTALL_PACKAGE_NOT_FOUND|Package was not found.
15602|ERROR_INSTALL_INVALID_PACKAGE|Package data is invalid.
15603|ERROR_INSTALL_RESOLVE_DEPENDENCY_FAILED|Package failed updates, dependency or conflict validation.
15604|ERROR_INSTALL_OUT_OF_DISK_SPACE|There is not enough disk space on your computer. Please free up some space and try again.
15605|ERROR_INSTALL_NETWORK_FAILURE|There was a problem downloading your product.
15606|ERROR_INSTALL_REGISTRATION_FAILURE|Package could not be registered.
15607|ERROR_INSTALL_DEREGISTRATION_FAILURE|Package could not be unregistered.
15608|ERROR_INSTALL_CANCEL|User cancelled the install request.
15609|ERROR_INSTALL_FAILED|Install failed. Please contact your software vendor.
15610|ERROR_REMOVE_FAILED|Removal failed. Please contact your software vendor.
15611|ERROR_PACKAGE_ALREADY_EXISTS|The provided package is already installed, and reinstallation of the package was blocked. Check the AppXDeployment-Server event log for details.
15612|ERROR_NEEDS_REMEDIATION|The application cannot be started. Try reinstalling the application to fix the problem.
15613|ERROR_INSTALL_PREREQUISITE_FAILED|A Prerequisite for an install could not be satisfied.
15614|ERROR_PACKAGE_REPOSITORY_CORRUPTED|The package repository is corrupted.
15615|ERROR_INSTALL_POLICY_FAILURE|To install this application you need either a Windows developer license or a sideloading-enabled system.
15616|ERROR_PACKAGE_UPDATING|The application cannot be started because it is currently updating.
15617|ERROR_DEPLOYMENT_BLOCKED_BY_POLICY|The package deployment operation is blocked by policy. Please contact your system administrator.
15618|ERROR_PACKAGES_IN_USE|The package could not be installed because resources it modifies are currently in use.
15619|ERROR_RECOVERY_FILE_CORRUPT|The package could not be recovered because necessary data for recovery have been corrupted.
15620|ERROR_INVALID_STAGED_SIGNATURE|The signature is invalid. To register in developer mode, AppxSignature.p7x and AppxBlockMap.xml must be valid or should not be present.
15621|ERROR_DELETING_EXISTING_APPLICATIONDATA_STORE_FAILED|An error occurred while deleting the package's previously existing application data.
15622|ERROR_INSTALL_PACKAGE_DOWNGRADE|The package could not be installed because a higher version of this package is already installed.
15623|ERROR_SYSTEM_NEEDS_REMEDIATION|An error in a system binary was detected. Try refreshing the PC to fix the problem.
15624|ERROR_APPX_INTEGRITY_FAILURE_CLR_NGEN|A corrupted CLR NGEN binary was detected on the system.
15625|ERROR_RESILIENCY_FILE_CORRUPT|The operation could not be resumed because necessary data for recovery have been corrupted.
15626|ERROR_INSTALL_FIREWALL_SERVICE_NOT_RUNNING|The package could not be installed because the Windows Firewall service is not running. Enable the Windows Firewall service and try again.
15700|APPMODEL_ERROR_NO_PACKAGE|The process has no package identity.
15701|APPMODEL_ERROR_PACKAGE_RUNTIME_CORRUPT|The package runtime information is corrupted.
15702|APPMODEL_ERROR_PACKAGE_IDENTITY_CORRUPT|The package identity is corrupted.
15703|APPMODEL_ERROR_NO_APPLICATION|The process has no application identity.
15800|ERROR_STATE_LOAD_STORE_FAILED|Loading the state store failed.
15801|ERROR_STATE_GET_VERSION_FAILED|Retrieving the state version for the application failed.
15802|ERROR_STATE_SET_VERSION_FAILED|Setting the state version for the application failed.
15803|ERROR_STATE_STRUCTURED_RESET_FAILED|Resetting the structured state of the application failed.
15804|ERROR_STATE_OPEN_CONTAINER_FAILED|State Manager failed to open the container.
15805|ERROR_STATE_CREATE_CONTAINER_FAILED|State Manager failed to create the container.
15806|ERROR_STATE_DELETE_CONTAINER_FAILED|State Manager failed to delete the container.
15807|ERROR_STATE_READ_SETTING_FAILED|State Manager failed to read the setting.
15808|ERROR_STATE_WRITE_SETTING_FAILED|State Manager failed to write the setting.
15809|ERROR_STATE_DELETE_SETTING_FAILED|State Manager failed to delete the setting.
15810|ERROR_STATE_QUERY_SETTING_FAILED|State Manager failed to query the setting.
15811|ERROR_STATE_READ_COMPOSITE_SETTING_FAILED|State Manager failed to read the composite setting.
15812|ERROR_STATE_WRITE_COMPOSITE_SETTING_FAILED|State Manager failed to write the composite setting.
15813|ERROR_STATE_ENUMERATE_CONTAINER_FAILED|State Manager failed to enumerate the containers.
15814|ERROR_STATE_ENUMERATE_SETTINGS_FAILED|State Manager failed to enumerate the settings.
15815|ERROR_STATE_COMPOSITE_SETTING_VALUE_SIZE_LIMIT_EXCEEDED|The size of the state manager composite setting value has exceeded the limit.
15816|ERROR_STATE_SETTING_VALUE_SIZE_LIMIT_EXCEEDED|The size of the state manager setting value has exceeded the limit.
15817|ERROR_STATE_SETTING_NAME_SIZE_LIMIT_EXCEEDED|The length of the state manager setting name has exceeded the limit.
15818|ERROR_STATE_CONTAINER_NAME_SIZE_LIMIT_EXCEEDED|The length of the state manager container name has exceeded the limit.
15841|ERROR_API_UNAVAILABLE|This API cannot be used in the context of the caller's application type.
<<<END>>>
*/
