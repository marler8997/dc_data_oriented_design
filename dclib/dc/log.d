module dc.log;

void errorf(T...)(string fmt, T args)
{
    import std.stdio;
    write("Error: ");
    writefln(fmt, args);
}