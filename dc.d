#!/usr/bin/env rund
//!importPath dclib
//!importPath dmdlib
//!importFilenamePath dmd_file_imports
//!version NoBackend
//!debug
//!debugSymbols

module __none;

import dc.log;
import dc.sentinel : makeSentinel;
import dc.file : ReadFile, readFile;
import dc.parsed : ParsedModule, parseModule;

import std.string : startsWith;
void usage()
{
    import std.stdio;
    writeln("Usage: dc [-options] <file>...");
}
int main(string[] args)
{
    // DMD setup
    {
        import dmd.globals;
        global._init();
        global.params.isLinux = true;
        global.params.is64bit = true;
    }
    {
        import dmd.mtype;
        Type._init();
    }
    {
        import dmd.expression;
        Expression._init();
    }
    {
        import dmd.target;
        Target._init();
    }
    {
        import dmd.dmodule;
        Module._init();
    }
    {
        import dmd.objc;
        ObjcSelector._init();
    }
    {
        import dmd.id;
        Id.initialize();
    }

    args = args[1 .. $];
    {
        size_t newArgsLength = 0;
        scope (exit) args.length = newArgsLength;
        for (size_t i = 0; i < args.length; i++)
        {
            auto arg = args[i];
            if (!arg.startsWith("-"))
            {
                args[newArgsLength++] = arg;
            }
            else
            {
                import std.stdio;
                errorf("unknown command line option '%s'", arg);
                return 1;
            }
        }
    }
    if (args.length == 0)
    {
        errorf("no files were given to compile");
        return 1;
    }

    // TODO: do this on multiple threads, or maybe using async
    //       io so that multiple files could be read at a time
    scope readFiles = new ReadFile[args.length];
    foreach (i, arg; args)
    {
        readFiles[i] = readFile(arg.makeSentinel.asImmutable);
    }

    // parse each file into a ParsedModule
    // TODO: do this on separate threads
    scope modulesToCompile = new ParsedModule*[readFiles.length];
    foreach (i, ref readFile; readFiles)
    {
        modulesToCompile[i] = parseModule(readFile);
    }

    errorf("not fully implemented");
    return 1;
}
