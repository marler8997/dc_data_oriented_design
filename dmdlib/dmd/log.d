module dmd.log;

void log(T...)(string fmt, T args)
{
    import std.stdio;
    write("[LOG] ");
    writefln(fmt, args);
}