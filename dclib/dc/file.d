/**

In the compiler, every file that is opened is saved and the name is normalized.

If the same file is requested to be opened more than once, than it should return the
existing file that was already open.
*/
module dc.file;

import std.array : Appender;

import dc.util : asImmutable;
import dc.sentinel : zstring, assumeSentinel;

struct Global
{
    static __gshared Object lock = new Object();
    static __gshared Appender!(ReadFile[]) readFiles;
}

struct ReadFile
{
    zstring originalName;
    zstring normalizedName;
    zstring text;
}

zstring normalizeFileName(zstring name)
{
    // TODO: normalize the name;
    return name;
}
bool filenamesEqual(const(char)[] left, const(char)[] right)
{
    // TODO: on windows it is case insensitive
    return left == right;
}

ReadFile readFile(zstring name)
{
    return readFile(name, normalizeFileName(name));
}
ReadFile readFile(zstring name, zstring normalizedName)
{
    import std.stdio : File;

    synchronized (Global.lock)
    {
        foreach (readFile; Global.readFiles.data)
        {
            if (filenamesEqual(normalizedName.val, readFile.normalizedName.val))
            {
                return readFile;
            }
        }
        // TODO: get out of the lock before reading the file, then I'll
        //       need to add the file to another array of "reading" files
        //       and the caller will need to wait until it's ready so I'll
        //       need an event to signal any threads waiting on the file
        // TODO: not sure if I should open with name or normalizedName
        auto openFile = File(normalizedName.val, "r");
        const fileSize = openFile.size;
        auto buffer = new char[fileSize + 1];
        auto readLength = openFile.rawRead(buffer).length;
        if (readLength != fileSize)
        {
            import std.format : format;
            assert(0, format("tried to read entire file of size %s but only read %s", fileSize, readLength));
        }
        buffer[fileSize] = '\0';
        auto readFile = ReadFile(name, normalizedName,
            buffer[0 .. fileSize].asImmutable.assumeSentinel);
        Global.readFiles.put(readFile);
        return readFile;
    }
}